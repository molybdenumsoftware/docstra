{
  lib,
  config,
  inputs,
  ...
}:
{
  options.documentation.module = lib.mkOption {
    type = lib.types.deferredModule;
  };
  config.perSystem =
    { pkgs, ... }:
    let
      documentation = config.lib.evalDocs {
        modules = [
          {
            inherit pkgs;
            htnl = inputs.htnl.lib;
          }
          config.documentation.module
        ];
      };

    in
    {
      packages.website = documentation.config.outputs.website;

      make-shells.default.packages = [ pkgs.nodePackages_latest.live-server ];
    };
}
