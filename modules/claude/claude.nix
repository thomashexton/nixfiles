let
  managedSettings = ./managed-settings.json;
in
{
  darwin.base.system.activationScripts.claudeManagedSettings.text = ''
    /bin/mkdir -p "/Library/Application Support/ClaudeCode/managed-settings.d"
    /bin/ln -sfn ${managedSettings} "/Library/Application Support/ClaudeCode/managed-settings.d/10-nixfiles-attribution.json"
  '';

  nixos.base.environment.etc."claude-code/managed-settings.d/10-nixfiles-attribution.json".source =
    managedSettings;

  home.base =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.unstable.claude-code ];
    };
}
