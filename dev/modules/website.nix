{
  inputs,
  config,
  lib,
  rootPath,
  ...
}:
{
  perSystem =
    psArgs@{ pkgs, ... }:
    let
      workflowPath = ".github/workflows/publish-website.yaml";

      indexHtml =
        let
          inherit (inputs.htnl.lib) serialize raw toDocument;
          inherit (inputs.htnl.lib.polymorphic.partials)
            a
            body
            code
            div
            em
            head
            html
            link
            meta
            p
            pre
            title
            script
            ;
        in
        html { lang = "en"; } [
          (head [
            (meta { charset = "UTF-8"; })
            (meta {
              name = "viewport";
              content = "width=device-width, initial-scale=1.0";
            })
            (meta {
              name = "description";
              content = config.metadata.description.plaintext;
            })
            (title config.metadata.title)
            (link {
              rel = "stylesheet";
              href = "./style.css";
            })
            (link {
              rel = "stylesheet";
              href = "highlightjs.css";
            })
            (script { type = "module"; } (raw
            # js
            ''
              import hljs from './highlight.js';
              import nix from './highlight-nix.js';
              hljs.registerLanguage('nix', nix);
              hljs.highlightAll()
            ''))
          ])
          (body
            {
              class =
                [
                  "bg-black"
                  "text-white"
                  "p-[5vw]"
                  "flex"
                  "flex-col"
                  "gap-[10vh]"
                ]
                |> lib.concatStringsSep " ";
            }
            [
              (
                [
                  ''<svg role="img">''
                  ''<title>${config.metadata.title}</title>''
                  ''<use href="graphics.svg#content"></use>''
                  ''</svg>''
                ]
                |> lib.concatStrings
                |> raw
              )

              (a { href = config.metadata.repository.url; } (code config.metadata.repository.url))
            ]
          )
        ]
        |> toDocument
        |> serialize
        |> pkgs.writeText "index.html"
        |> (
          indexHtml:
          pkgs.runCommand "validated-index.html"
            {
              nativeBuildInputs = [ pkgs.validator-nu ];
            }
            ''
              mkdir $out
              vnu --Werror ${indexHtml}
              ln -s ${indexHtml} $out/index.html
            ''
        );

      inputCss = pkgs.writeText "input.css" ''
        @import "tailwindcss" source("${indexHtml}");
        @plugin "@tailwindcss/typography";
      '';
    in
    {
      make-shells.default.inputsFrom = [
        indexHtml
        psArgs.config.packages.website
      ];

      packages.website =
        pkgs.runCommand "website"
          {
            nativeBuildInputs = [
              pkgs.tailwindcss_4
            ];
          }
          ''
            mkdir $out
            ln -s ${indexHtml}/index.html $out
            ln -s ${rootPath + "/dev/modules/graphics/inkscape.svg"} $out/graphics.svg
            ln -s ${inputs.highlightjs-stylesheet} $out/highlightjs.css
            ln -s ${inputs.highlightjs-esmodule} $out/highlight.js
            ln -s ${inputs.highlightjs-nix} $out/highlight-nix.js
            tailwindcss -i ${inputCss} -o $out/style.css
          '';

      files.files = [
        {
          path_ = workflowPath;
          drv = pkgs.writers.writeJSON "gh-actions-workflow-publish-website.yaml" {
            on = {
              pull_request = { };
              push.branches = [ "master" ];
            };

            permissions = {
              contents = "read";
              pages = "write";
              id-token = "write";
            };

            concurrency = {
              group = "\${{ github.workflow }}-\${{ github.ref_name }}";
              cancel-in-progress = true;
            };

            jobs.publish-website = {
              runs-on = "ubuntu-latest";
              steps = [
                { uses = "actions/checkout@v4"; }
                { uses = "cachix/install-nix-action@master"; }
                { uses = "DeterminateSystems/magic-nix-cache-action@main"; }
                { run = "nix build -vv --print-build-logs --accept-flake-config .#website"; }
                {
                  uses = "actions/upload-pages-artifact@v4";
                  "with".path = "result";
                }
                {
                  "if" = "github.ref == 'refs/heads/\${{ github.event.repository.default_branch }}'";
                  uses = "actions/deploy-pages@v4";
                }
              ];
            };
          };
        }
      ];

      treefmt.settings.global.excludes = [ workflowPath ];
    };

}
