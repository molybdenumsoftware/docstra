{ lib, ... }:
{
  config.perSystem =
    { pkgs, system, ... }:
    let
      servePath = "serve";
      buildCommand = ''
        nix-build $"($git_root)/dev" -A packages.${system}.website --out-link $"($serve_path)/result"
      '';
    in
    {
      gitignore = [ "/${servePath}" ];

      make-shells.default.packages = [
        (pkgs.writers.writeNuBin "dev-server" ''
          let git_root = git rev-parse --show-toplevel
          let serve_path = $"($git_root)/${servePath}"

          ${buildCommand}

          let live_server = job spawn { ${lib.getExe pkgs.live-server} --poll $serve_path --open result }
          ${lib.getExe pkgs.watchexec} --postpone ${buildCommand}
        '')
      ];
    };
}
