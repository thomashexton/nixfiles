{ pkgs, ... }:

let
  homeDir = "/Users/thomashexton";
  kanataBin = "${pkgs.kanata}/bin/kanata";
  kanataConfig = "${homeDir}/.config/kanata/kanata.kbd";
  # Wireless keyboards (the Logitech "USB Receiver") enumerate a moment after boot.
  # kanata grabs devices once at startup and never re-grabs, so a plain RunAtLoad
  # can start before the receiver is ready and then silently skip remapping it.
  # Wait for the config symlink and the receiver to appear before launching, and
  # fall back after ~60s so a keyboard that is simply off never blocks startup.
  startScript = pkgs.writeShellScript "kanata-launch" ''
    for _ in $(seq 1 60); do
      if [ -e "${kanataConfig}" ] \
        && /usr/sbin/ioreg -c IOHIDDevice -r -l | grep -q '"Product" = "USB Receiver"'; then
        break
      fi
      sleep 1
    done
    exec ${kanataBin} --cfg "${kanataConfig}"
  '';
in
{
  launchd.daemons.kanata = {
    serviceConfig = {
      Label = "com.thomashexton.kanata";
      KeepAlive = true;
      ProgramArguments = [ "${startScript}" ];
      RunAtLoad = true;
      StandardErrorPath = "${homeDir}/.cache/kanata.stderr.log";
      StandardOutPath = "${homeDir}/.cache/kanata.stdout.log";
      WorkingDirectory = homeDir;
    };
  };
}
