{ config, lib, ... }:
let
  inherit (config.htnl.polymorphic.partials)
    html
    div
    head
    title
    link
    meta
    body
    ;
in
{
  options = {
    pages = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          page@{ name, ... }:
          {
            options = {
              path = lib.mkOption {
                readOnly = true;
                type = lib.types.singleLineStr;
                default = "/${page.name}.html";
              };
              headings = lib.mkOption {
                internal = true;
                readOnly = true;
                type = lib.types.listOf lib.types.unspecified;
                default = page.config.contentProcessed.headings.nested;
              };
              contentProcessed = lib.mkOption {
                internal = true;
                readOnly = true;
                type = lib.types.unspecified;
                default = page.config.contentIr |> config.htnl.process;
              };
              contentIr = lib.mkOption {
                internal = true;
                readOnly = true;
                type = lib.types.unspecified;
                default = page.config.content |> map (piece: div { class = "prose prose-invert"; } piece.htnl);
              };
              ir = lib.mkOption {
                internal = true;
                readOnly = true;
                type = lib.types.unspecified;
                default =
                  html { lang = "en"; } [
                    (head [
                      (title [
                        page.config.title
                        " | "
                        config.metadata.title
                      ])
                      (link {
                        rel = "stylesheet";
                        href = "./style.css";
                      })
                      (meta {
                        name = "viewport";
                        content = "width=device-width, initial-scale=1.0";
                      })
                    ])
                    (body
                      {
                        class =
                          [
                            "bg-black"
                            "text-white"
                            "h-screen"
                            "flex"
                            "flex-col"
                            "sm:flex-row-reverse"
                          ]
                          |> lib.concatStringsSep " ";
                      }
                      [
                        (div { class = "p-1 flex-grow"; } page.config.contentIr)
                        config.navigation
                      ]
                    )
                  ]
                  |> config.htnl.document;
              };
              title = lib.mkOption {
                type = lib.types.singleLineStr;
              };
              content = lib.mkOption {
                type = lib.types.listOf (
                  lib.types.attrTag {
                    htnl = lib.mkOption {
                      type = lib.types.listOf (
                        lib.types.oneOf [
                          lib.types.str
                          (
                            lib.types.attrsOf lib.types.anything
                            |> lib.flip lib.types.addCheck (v: v.type or null == "htnl-element")
                          )
                          (
                            lib.types.attrsOf lib.types.anything
                            |> lib.flip lib.types.addCheck (v: v.type or null == "htnl-raw")
                          )
                        ]
                      );
                    };
                  }
                );
              };
            };
          }
        )
      );
    };
  };
}
