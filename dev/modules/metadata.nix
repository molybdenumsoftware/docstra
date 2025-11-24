{ inputs, lib, ... }:
{
  options.metadata =
    let
      inherit (inputs.htnl.lib.polymorphic.partials) a p;
    in
    {
      title = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "docstra";
      };
      description = {
        plaintext = lib.mkOption {
          type = lib.types.singleLineStr;
          default = "Nix-powered documentation authoring library";
        };
        ir = lib.mkOption {
          type = lib.types.unspecified;
          default = [
            (a { href = "https://nix.dev/"; } "Nix")
            "-powered documentation authoring library"
          ];
        };

      };
      website.url = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "https://docstra.molybdenum.software/";
      };
      repository.url = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "https://github.com/molybdenumsoftware/docstra";
      };
    };
}
