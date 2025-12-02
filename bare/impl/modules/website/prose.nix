{ config, lib, ... }:
let
  inherit (config.htnl.polymorphic.partials) div;
in
{
  contentTypes.htnl = {
    option = lib.mkOption {
      type = lib.types.listOf (
        lib.types.oneOf [
          lib.types.str
          (
            lib.types.attrsOf lib.types.anything
            |> lib.flip lib.types.addCheck (v: v.type or null == "htnl-element")
          )
          (
            lib.types.attrsOf lib.types.anything
            |> lib.flip lib.types.addCheck (v: v.type or null == "htnl-raw")
          )
        ]
      );
    };
    toHtnl = div { class = "prose prose-invert"; };
  };
}
