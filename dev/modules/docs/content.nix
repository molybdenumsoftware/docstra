{ lib, config, ... }:
{
  documentation.module = (
    docArgs:
    let
      inherit (docArgs.config.htnl.polymorphic.partials)
        p
        a
        h1
        h2
        h3
        ;
    in
    {
      metadata = { inherit (config.metadata) title; };
      pages = {
        index = {
          title = "Index";
          content = [
            {
              htnl = [
                (h1 [
                  config.metadata.title
                  ", a "
                  config.metadata.description.ir
                ])
                (p "Welcome to the ${config.metadata.title} documentation!")
                (p [
                  "${config.metadata.title} is a "
                  config.metadata.description.ir
                  "."
                ])
                (p [
                  "So this documentation is "
                  (a { href = "https://en.wikipedia.org/wiki/Eating_your_own_dog_food"; } "dog food!")
                ])
              ];
            }
          ];
        };
        introduction = {
          title = "Introduction";
          content = [
            {
              htnl = [
                (h1 [
                  "Introduction to ${config.metadata.title}, the "
                  config.metadata.description.ir
                ])
                (h2 { id = "background"; } "Background")
                (p "Some background")
                (h3 { id = "deeper"; } "Deeper")
                (p "more")
                (h2 { id = "description"; } "Description")
                (p config.metadata.description.ir)
                (h2 { id = "goals"; } "Goals")
              ];
            }
          ];
        };
      };
    }
  );
}
