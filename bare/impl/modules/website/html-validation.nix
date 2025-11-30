{ lib, config, ... }:
{
  options.website.htmlValidation.phase = lib.mkOption {
    type = lib.types.str;
    internal = true;
    readOnly = true;
    default =
      [
        (lib.getExe config.pkgs.validator-nu)
        ''html_files=$(find -L $out -not -path $out'/nix/store/*' -type f)''
        "--Werror"
        "$html_files"
      ]
      |> lib.concatStringsSep " ";
  };
}
