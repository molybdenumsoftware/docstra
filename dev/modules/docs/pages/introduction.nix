{ config, ... }:
{
  documentation.module = (
    docArgs:
    let
      inherit (docArgs.config.htnl.polymorphic.partials)
        p
        h1
        ul
        li
        ;
    in
    {
      pages.introduction = {
        title = "Introduction";
        content = [
          {
            htnl = [
              (h1 [
                "Introduction to ${config.metadata.title}, the "
                config.metadata.description.ir
              ])
              (p "Nix, because:")
              (ul [
                (li "Reproducibility")
                (li "Access to Nixpkgs")
                (li "Single source of truth")
                (li "Caching")
              ])
            ];
          }
        ];
      };
    }
  );
}
