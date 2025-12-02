{ config, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      workflowPath = ".github/workflows/publish-website.yaml";
    in
    {
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
