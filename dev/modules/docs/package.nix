{
  lib,
  config,
  inputs,
  ...
}:
{
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
    };
}
