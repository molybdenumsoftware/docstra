{ lib, config, ... }:
{
  options.githubActions.setUpNix = lib.mkOption {
    type = lib.types.listOf (lib.types.attrsOf lib.types.unspecified);
    readOnly = true;
    default = [
      {
        uses = "nixbuild/nix-quick-install-action@master";
        "with".nix_conf = ''
          keep-env-derivations = true
          keep-outputs = true
        '';
      }
      {
        uses = "nix-community/cache-nix-action@main";
        "with".primary-key = "a-single-key";
      }
    ];
  };
  config.perSystem =
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
              ]
              ++ config.githubActions.setUpNix
              ++ [
                { run = "nix flake --print-build-logs --accept-flake-config check"; }
              ];
            };
          };
        }
      ];
      treefmt.settings.global.excludes = [ path_ ];
    };
}
