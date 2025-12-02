{ config, ... }:
{
  documentation.module = (
    docArgs:
    let
      inherit (docArgs.config.htnl.polymorphic.partials)
        p
        h1
        h2
        h3
        ;
    in
    {
      pages.introduction = {
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
    }
  );
}
