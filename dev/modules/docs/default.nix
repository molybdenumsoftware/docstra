{
  lib,
  ...
}:
{
  options.documentation.module = lib.mkOption {
    type = lib.types.deferredModule;
  };
  config.perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.nodePackages_latest.live-server ];
    };
}
