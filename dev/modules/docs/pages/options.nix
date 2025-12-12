{ config, ... }:
{
  documentation.module =
    docArgs:
    let
      inherit (docArgs.config.htnl.polymorphic.partials) h1 p;
    in
    {
      pages.options = {
        title = "Options reference";
        content = [
          {
            htnl = [
              (h1 [
                config.metadata.title
                " options reference"
              ])
            ];
          }
          {
            nixpkgsModuleSystem = {
              result = config.lib.evalDocs { modules = [ ]; };
            };
          }
        ];
      };
    };
}
