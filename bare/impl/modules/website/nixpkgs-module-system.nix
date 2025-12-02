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
      lazyAttrsOf = option: p "lazyAttrsOf";
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
          v.result.class
        ])
        (p "Options:")
        # TODO what about the contents of `_module`?
        (
          v.result.options
          |> (
            options:
            let
              recurse =
                path: v:
                if lib.isOption v then
                  div [
                    (path |> lib.concatStringsSep "." |> code |> p)
                    (lib.optional (v.internal or false) (p (code "internal")))
                    (lib.optional (v.readOnly or false) (p (code "readOnly")))
                    (p [
                      "Type: "
                      (code v.type.name)
                    ])
                    (config.subjects.nixpkgsModuleSystem.htnlMappers.${v.type.name} v)
                  ]
                else
                  v |> lib.mapAttrsToList (name: value: recurse (lib.concat path [ name ]) value);
            in
            recurse [ ] options
          )
        )
      ];
  };
}
