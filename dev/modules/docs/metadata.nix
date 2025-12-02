{ config, ... }:
{
  documentation.module = {
    metadata = { inherit (config.metadata) title; };
  };
}
