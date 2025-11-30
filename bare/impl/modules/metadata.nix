{ lib, ... }:
{
  options.metadata.title = lib.mkOption { type = lib.types.singleLineStr; };
}
