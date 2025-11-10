{
  inputs = {

    files.url = "github:mightyiam/files";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "dedupe_flake-compat";
      };
    };

    highlightjs-stylesheet = {
      flake = false;
      url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/styles/base16/gruvbox-dark-hard.min.css";
    };

    highlightjs-esmodule = {
      flake = false;
      url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/es/highlight.min.js";
    };

    highlightjs-nix = {
      flake = false;
      url = "https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.11.1/es/languages/nix.min.js";
    };

    import-tree.url = "github:vic/import-tree";

    make-shell = {
      url = "github:nicknovitski/make-shell";
      inputs.flake-compat.follows = "dedupe_flake-compat";
    };

    nixpkgs.url = "https://channels.nixos.org/nixpkgs-unstable/nixexprs.tar.xz";

    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    htnl = {
      url = "github:molybdenumsoftware/htnl";
      inputs.nixpkgs-lib.follows = "nixpkgs";
      inputs.flake-parts.follows = "dedupe_flake-parts";
    };
  };

  # _additional_ `inputs` only for deduplication
  inputs = {
    dedupe_flake-compat.url = "github:edolstra/flake-compat";
    dedupe_flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = _: { };
}
