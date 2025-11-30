{ lib, config, ... }:
{
  options.outputs.website = lib.mkOption {
    readOnly = true;
    type = lib.types.package;
    default =
      config.pages
      |> lib.mapAttrs' (
        pageId: page: {
          name = page.path;
          value = page.ir;
        }
      )
      |> (
        htmlDocuments:
        config.htnl.bundle config.pkgs {
          inherit htmlDocuments;
        }
      )
      |> (
        bundle:
        config.pkgs.runCommand "${config.pages.index.title}-website" { } ''
          mkdir $out
          cp -r ${bundle}/* $out
          ${config.website.htmlValidation.phase}
          ${config.website.tailwindcss.phase}
        ''
      );
  };
}
