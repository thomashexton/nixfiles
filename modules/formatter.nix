# Repository-wide Nix formatter for every supported evaluation system.
{
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
