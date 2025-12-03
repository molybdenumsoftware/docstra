{ lib, config, ... }:
let
  inherit (config.htnl.polymorphic.partials)
    p
    a
    dl
    dt
    dd
    pre
    code
    div
    ;
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
        (div { class = "text-xl mt-[1lh]"; } "Nixpkgs module system configuration")
        (div { class = "mt-[1lh]"; } [
          "Class: "
          (code v.result.class)
        ])
        (div { class = "mt-[1lh]"; } "Options:")
        # TODO what about the contents of `_module`?
        (
          v.result.options
          |> lib.optionAttrSetToDocList
          |> map (
            option:
            # TODO `.loc` gives us the individual path parts, so nicer styling possible and perhaps some navigation features
            lib.trace (lib.attrNames option) (dl [
              (
                let
                  id = option.name |> lib.replaceStrings [ "<" ">" ] [ "_" "_" ] |> (n: "opt:${n}");
                in
                dt
                  {
                    inherit id;
                    class = "mt-[1lh] text-lg";
                  }
                  (
                    a {
                      href = "#${id}";
                      class = "border-b";
                    } (code option.name)
                  )
              )
              (dd { class = "py-[1lh] ps-[1ch] border-s"; } [
                (div { class = "flex gap-2"; } (
                  [
                    "internal"
                    "readOnly"
                  ]
                  |> map (
                    attribute:
                    lib.optional (lib.attrByPath [ attribute ] false option) (
                      code { class = "text-sm bg-neutral-700 px-[2px] rounded-sm"; } attribute
                    )
                  )
                ))
                (lib.optional (lib.isString option.description) (
                  # TODO convert markdown to HTML
                  pre { class = "mt-[1lh]"; } (code option.description)
                ))
                # TODO use shared gap instead of these `mt-[1lh]`
                (div { class = "mt-[1lh]"; } [
                  "Type: "
                  option.type
                ])
                # TODO declarations
                # TODO filter by `.visible`
                # TODO default
              ])
            ])
          )
        )
      ];
  };
}
