{
  lib,
  rootPath,
  config,
  ...
}:
{
  options.lib = lib.mkOption {
    type = lib.types.unspecified;
    default = import rootPath { inherit lib; };
  };
  config.flake = { inherit (config) lib; };
}
