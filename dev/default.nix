let
  lockFile = ./flake.lock |> builtins.readFile |> builtins.fromJSON;
  flake-compat-node = lockFile.nodes.${lockFile.nodes.root.inputs.flake-compat};
  flake-compat =
    {
      inherit (flake-compat-node.locked) url;
      sha256 = flake-compat-node.locked.narHash;
    }
    |> builtins.fetchTarball
    |> import;
in
{
  copySourceTreeToStore = false;
  src = ../.;
}
|> flake-compat
|> builtins.getAttr "defaultNix"
