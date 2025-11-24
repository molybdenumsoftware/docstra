{
  config,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    let
      workflowPath = ".github/workflows/publish-website.yaml";

      documentation = config.lib.evalDocs {
        modules = [
          (
            docArgs:
            let
              inherit (docArgs.config.htnl.polymorphic.partials)
                p
                a
                h1
                h2
                ;
            in
            {
              inherit pkgs;
              metadata = { inherit (config.metadata) title; };
              pages = {
                index = {
                  title = "Index";
                  content = [
                    {
                      htnl = [
                        (h1 [
                          config.metadata.title
                          ", a "
                          config.metadata.description.ir
                        ])
                        (p "Welcome to the ${config.metadata.title} documentation!")
                        (p [
                          "${config.metadata.title} is a "
                          config.metadata.description.ir
                          "."
                        ])
                        (p [
                          "So this documentation is "
                          (a { href = "https://en.wikipedia.org/wiki/Eating_your_own_dog_food"; } "dog food!")
                        ])
                      ];
                    }
                  ];
                };
                introduction = {
                  title = "Introduction";
                  content = [
                    {
                      htnl = [
                        (h1 [
                          "Introduction to ${config.metadata.title}, the "
                          config.metadata.description.ir
                        ])
                        (h2 { id = "background"; } "Background")
                        (p "Some background")
                        (h2 { id = "description"; } "Description")
                        (p config.metadata.description.ir)
                        (h2 { id = "goals"; } "Goals")
                      ];
                    }
                  ];
                };
              };
            }
          )
        ];

      };

    in
    {
      packages.website = documentation.config.outputs.website;

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
              ]
              ++ config.githubActions.setUpNix
              ++ [
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
