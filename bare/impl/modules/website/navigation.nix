{ config, lib, ... }:
let
  inherit (config.htnl.polymorphic.partials) ul li a;
in
{
  options.navigation = lib.mkOption {
    internal = true;
    readOnly = true;
    type = lib.types.unspecified;
    default = (
      ul { class = "bg-gray-800 p-1 shrink-0"; } (
        config.pages
        |> lib.mapAttrsToList (
          pageId: page:
          let
            recurse =
              headings:
              headings
              |> map (
                heading:
                if heading.level == 1 then
                  lib.optionals (heading ? subHeadings) (recurse heading.subHeadings)
                else
                  li { class = "ms-[1ch]"; } [
                    (
                      if heading ? id then
                        a { href = "${page.path}#${heading.id}"; } (config.htnl.raw heading.content)
                      else
                        config.htnl.raw heading.content
                    )
                    (lib.optionals (heading ? subHeadings) (ul (recurse heading.subHeadings)))
                  ]
              );
          in
          li [
            (a { href = page.path; } page.title)
            (ul (recurse page.headings))
          ]
        )
      )
    );

  };
}
