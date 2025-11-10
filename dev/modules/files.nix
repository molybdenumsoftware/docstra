{ inputs, ... }:
{
  imports = [ inputs.files.flakeModules.default ];
  perSystem = psArgs: {
    files.gitToplevel = ../..;
    make-shells.default.packages = [ psArgs.config.files.writer.drv ];
  };
}
