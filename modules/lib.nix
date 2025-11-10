{
  lib,
  rootPath,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.unspecified;
    default = import rootPath { inherit lib; };
  };
}
