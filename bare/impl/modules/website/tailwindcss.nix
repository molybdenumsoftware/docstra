{ lib, config, ... }:
let
  inputCss = config.pkgs.writeText "input.css" ''
    @import "tailwindcss";
    @plugin "@tailwindcss/typography";
  '';
in
{
  options.website.tailwindcss.phase = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    internal = true;
    default =
      [
        (lib.getExe config.pkgs.tailwindcss_4)
        "-i ${inputCss}"
        "--cwd $out"
        "-o $out/style.css"
      ]
      |> lib.concatStringsSep " ";
  };
}
