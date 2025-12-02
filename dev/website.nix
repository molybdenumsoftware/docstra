./default.nix
|> import
|> (defaultNix: defaultNix.outputs.packages.${builtins.currentSystem}.website)
