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
    {
      packages.website =
        {
          modules = [
            {
              inherit pkgs;
              htnl = inputs.htnl.lib;
            }
            config.documentation.module
          ];
        }
        |> config.lib.evalDocs
        |> lib.getAttrFromPath [
          "config"
          "outputs"
          "website"
        ];

      make-shells.default.packages = [ pkgs.nodePackages_latest.live-server ];
    };
}
