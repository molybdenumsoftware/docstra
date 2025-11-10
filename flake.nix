{
  nixConfig = {
    # FIXME uncomment after upstream resolved
    # https://github.com/nix-community/nix-unit/pull/274
    #abort-on-warn = true;
    allow-import-from-derivation = false;
    extra-experimental-features = [ "pipe-operators" ];
  };

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };

    nixpkgs-lib.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        _module.args.rootPath = ./.;

        systems = [ ];

        imports = [
          inputs.flake-parts.flakeModules.partitions
          ./modules/lib.nix
        ];

        partitionedAttrs = lib.genAttrs [
          "checks"
          "devShells"
          "formatter"
          "packages"
        ] (_: "dev");

        partitions.dev = {
          extraInputsFlake = ./dev;
          module = ./dev/imports.nix;
        };
      }
    );
}
