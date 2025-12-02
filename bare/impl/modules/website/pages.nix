{
  config,
  lib,
  options,
  ...
}:
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
    contentTypes = lib.mkOption {
      internal = true;
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            option = lib.mkOption {
              # module system option
              type = lib.types.unspecified;
            };
            toHtnl = lib.mkOption {
              type = lib.types.functionTo (
                # htnl IR
                lib.types.unspecified
              );
            };
          };
        }
      );
    };
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
                default =
                  page.config.content
                  |> map (piece: piece |> lib.attrsToList |> lib.head)
                  |> map ({ name, value }: config.contentTypes.${name}.toHtnl value);
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
                  config.contentTypes |> lib.mapAttrs (tag: lib.getAttr "option") |> lib.types.attrTag
                );
              };
            };
          }
        )
      );
    };
  };
}
