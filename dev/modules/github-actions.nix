{
  perSystem =
    { pkgs, ... }:
    let
      path_ = ".github/workflows/check.yaml";
    in
    {
      files.files = [
        {
          inherit path_;
          drv = pkgs.writers.writeJSON "gh-actions-workflow-check.yaml" {
            on = {
              push = { };
              workflow_call = { };
            };
            jobs.check = {
              runs-on = "ubuntu-latest";
              steps = [
                { uses = "actions/checkout@v5"; }
                { uses = "cachix/install-nix-action@master"; }
                { uses = "DeterminateSystems/magic-nix-cache-action@main"; }
                { run = "nix flake --print-build-logs --accept-flake-config check"; }
              ];
            };
          };
        }
      ];
      treefmt.settings.global.excludes = [ path_ ];
    };
}
