{ lib, config, ... }:
let
  inherit (config.htnl.polymorphic.partials) p code div;
in
{
  options.subjects.nixpkgsModuleSystem.htnlMappers = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.functionTo (
        # htnl IR
        lib.types.unspecified
      )
    );
    default = {
      lazyAttrsOf = option: (p "lazyAttrsOf");
      bool = option: p "bool";
      nullOr = option: p "nullOr";
      unspecified = option: p "unspecified";
      attrsOf = option: p "attrsOf";
      singleLineStr = option: p "singleLineStr";
      package = option: p "package";
      pkgs = option: p "pkgs";
      str = option: p "str";
    };
  };
  config.contentTypes.nixpkgsModuleSystem = {
    option = lib.mkOption {
      type = lib.types.submodule {
        options.result = lib.mkOption { };
      };
    };
    toHtnl =
      v:
      div [
        (p "Nixpkgs module system configuration")
        (p [
          "Class: "
          (code v.result.class)
        ])
        (p "Options:")
        # TODO what about the contents of `_module`?
        (
          v.result.options
          |> lib.optionAttrSetToDocList
          |> map (
            option:
            lib.trace (lib.attrNames option) (div [
              (p (code option.name))
              (
                [
                  { name = "internal"; }
                  { name = "readOnly"; }
                ]
                |> map (
                  attribute: lib.optional (lib.attrByPath [ attribute.name ] false option) (p (code attribute.name))
                )
              )
            ])
          )
        )
      ];
  };
}
