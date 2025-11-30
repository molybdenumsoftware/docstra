{ lib }:
{
  evalDocs =
    args@{ modules, ... }:
    lib.evalModules (
      args
      // {
        class = "docstra";
        modules =
          let
            recurse =
              path:
              path
              |> builtins.readDir
              |> lib.mapAttrsToList (
                fileName: fileType:
                let
                  filePath = path + "/${fileName}";
                in
                if fileType == "regular" then
                  filePath
                else if fileType == "directory" then
                  recurse filePath
                else
                  throw "${filePath} has unsupported file type ${fileType}"
              );
          in
          ./modules |> recurse |> lib.flatten |> lib.concat modules;
      }
    );
}
