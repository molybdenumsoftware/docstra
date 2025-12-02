{
  config.perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.nodePackages_latest.live-server ];
    };
}
