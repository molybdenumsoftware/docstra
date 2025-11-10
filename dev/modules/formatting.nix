{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = {
    treefmt = {
      programs.nixfmt.enable = true;
      settings.on-unmatched = "fatal";
    };
  };
}
