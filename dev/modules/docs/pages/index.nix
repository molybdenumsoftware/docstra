{ config, ... }:
{
  documentation.module = (
    docArgs:
    let
      inherit (docArgs.config.htnl.polymorphic.partials)
        p
        a
        h1
        ;
    in
    {
      pages.index = {
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
    }
  );
}
