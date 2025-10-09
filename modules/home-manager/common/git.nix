{ config, pkgs, ... }:

{
  # Note: Package is installed at system level
  programs.git = {
    enable = true;
    userName = "Thomas Hexton";
    userEmail = "25544371+thomashexton@users.noreply.github.com";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      
      push = {
        autoSetupRemote = true;
      };
      
      diff = {
        external = "difft";
      };
      
      pager = {
        branch = false;
      };
      
      alias = {
        # Traditional aliases
        tdiff = "-c diff.external= diff --no-ext-diff";
        # Parent branch
        parent = "!git show-branch | grep '*' | grep -v \"$(git rev-parse --abbrev-ref HEAD)\" | head -n1 | sed 's/.*\\[\\(.*\\)\\].*/\\1/' | sed 's/[\\^~].*//' #";
      };
      
      core = {
        editor = "zed --wait";
      };
      
      filter.lfs = {
        clean = "git-lfs clean -- %f";
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
      };
    };
  };
}
