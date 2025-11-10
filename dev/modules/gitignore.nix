{ lib, ... }:
{
  perSystem =
    psArgs@{ pkgs, ... }:
    {
      options.gitignore = lib.mkOption {
        type = lib.types.listOf lib.types.singleLineStr;
        default = [ ];
        apply = lib.concat [ "result" ];
      };
      config.files.files = lib.singleton {
        path_ = ".gitignore";
        drv = psArgs.config.gitignore |> lib.naturalSort |> lib.concatLines |> pkgs.writeText ".gitignore";
      };
    };
}
