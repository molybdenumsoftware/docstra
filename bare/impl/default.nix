{ lib }:
let
  implModules = [
    (
      { config, ... }:
      let
        inherit (config.htnl.polymorphic.partials)
          html
          div
          ul
          li
          a
          head
          title
          link
          meta
          body
          ;
      in
      {
        options = {
          metadata.title = lib.mkOption { type = lib.types.singleLineStr; };
          htnl = lib.mkOption {
            type = lib.types.attrsOf lib.types.anything;
            readOnly = true;
            default =
              builtins.fetchTarball {
                url = "https://github.com/molybdenumsoftware/htnl/archive/fd21209db27f8d15fc9a62f202e874029f7e87b6.tar.gz";
                sha256 = "01gn7hylfkrfpp24fswzjip5zjm6y751ilrw0xx6f7h9wsjdfv0l";
              }
              |> (tarball: import tarball { inherit lib; });
          };
          outputs = {
            website = lib.mkOption {
              readOnly = true;
              type = lib.types.package;
            };
            validation = lib.mkOption {
              readOnly = true;
              type = lib.types.package;
            };
          };
          pkgs = lib.mkOption { type = lib.types.pkgs; };
          tableOfContents = lib.mkOption {
            internal = true;
            readOnly = true;
            type = lib.types.unspecified;
            default = (
              ul { class = "bg-gray-800 p-1"; } (
                config.pages
                |> lib.mapAttrsToList (
                  _: page:
                  li [
                    (a { href = page.path; } page.title)
                    (ul (
                      page.headings
                      |> lib.ifilter0 (i: v: !(i == 0 && v.level == 1))
                      |> map (
                        heading:
                        li { class = "ms-[${toString (heading.level - 1)}ch]"; } (
                          if heading.id == null then
                            config.htnl.raw heading.content
                          else
                            a { href = "${page.path}#${heading.id}"; } (config.htnl.raw heading.content)
                        )
                      )
                    ))
                  ]
                )
              )
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
                      default = page.config.contentProcessed.headings;
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
                              config.tableOfContents
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
        config = {
          outputs = {
            website =
              let
                inputCss = config.pkgs.writeText "input.css" ''
                  @import "tailwindcss";
                  @plugin "@tailwindcss/typography";
                '';
              in
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
                config.pkgs.runCommand "${config.pages.index.title}-website"
                  {
                    nativeBuildInputs = [
                      config.pkgs.validator-nu
                      config.pkgs.tailwindcss_4
                    ];
                  }
                  ''
                    mkdir $out
                    cp -r ${bundle}/* $out
                    html_files=$(find -L $out -not -path $out'/nix/store/*' -type f)
                    vnu --Werror $html_files
                    tailwindcss -i ${inputCss} --cwd $out -o $out/style.css
                  ''
              );
          };
        };
      }
    )
  ];
in
{
  evalDocs =
    args@{ modules, ... }:
    lib.evalModules (
      args
      // {
        class = "docstra";
        modules = lib.concat implModules modules;
      }
    );
}
