{ ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;
    ignores = [
      "*.DS_Store"
      ".DS_Store"
      "._*"
      ".Spotlight-V100"
      ".Trashes"
      "*~"
      "*.bak"
      "*.swp"
      "*.swo"
      "*.log"
      "**/.claude/settings.local.json"
    ];
    settings = {
      user = {
        name = "Thomas Hexton";
        email = "25544371+thomashexton@users.noreply.github.com";
      };

      init.defaultBranch = "main";
      pull.rebase = true;

      push.autoSetupRemote = true;

      diff.external = "difft";

      pager.branch = false;

      alias = {
        tdiff = "-c diff.external= diff --no-ext-diff";
        parent = "!git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1 | sed 's/.*\\[\\(.*\\)\\].*/\\1/' | sed 's/[\\^~].*//' #";
      };

      merge.conflictstyle = "diff3";

      core.editor = "zed --wait";
    };
  };

  xdg.configFile."git/config".force = true;
  xdg.configFile."git/ignore".force = true;
}
