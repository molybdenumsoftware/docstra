{ inputs, config, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      path_ = "README.md";
    in
    {
      treefmt.settings.global.excludes = [ path_ ];
      files.files = [
        {
          inherit path_;
          drv =
            let
              inherit (inputs.htnl.lib.polymorphic.partials)
                h1
                p
                a
                code
                ;
            in
            [
              (h1 config.metadata.title)
              (p config.metadata.description.ir)
              (p (
                a { href = config.metadata.website.url; } [
                  (code config.metadata.website.url)
                ]
              ))
            ]
            |> inputs.htnl.lib.serialize
            |> pkgs.writeText "README.md";
        }
      ];
    };
}
