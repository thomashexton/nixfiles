{
  darwin.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        (pkgs.obsidian.overrideAttrs {
          version = "1.12.7";
          src = pkgs.fetchurl {
            url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.12.7/Obsidian-1.12.7.dmg";
            hash = "sha256-O4XBO0zlVRLobhcKfNKklOLbaVrIiMBgHhU8uFt3iBs=";
          };
        })
      ];
    };

  nixos.workstation =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.obsidian ];
    };
}
