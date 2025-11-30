{ lib, ... }:
{
  options.pkgs = lib.mkOption { type = lib.types.pkgs; };
}
