{
  lib,
  ...
}:
{
  options.documentation.module = lib.mkOption {
    type = lib.types.deferredModule;
  };
}
