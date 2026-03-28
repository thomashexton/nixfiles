{ ... }:

let
  homeDir = "/Users/thomashexton";
  kanataBin = "/opt/homebrew/bin/kanata";
  kanataConfig = "${homeDir}/.config/kanata/kanata.kbd";
in
{
  launchd.daemons.kanata = {
    serviceConfig = {
      Label = "com.thomashexton.kanata";
      KeepAlive = true;
      ProgramArguments = [
        kanataBin
        "--cfg"
        kanataConfig
      ];
      RunAtLoad = true;
      StandardErrorPath = "${homeDir}/.cache/kanata.stderr.log";
      StandardOutPath = "${homeDir}/.cache/kanata.stdout.log";
      WorkingDirectory = homeDir;
    };
  };
}
