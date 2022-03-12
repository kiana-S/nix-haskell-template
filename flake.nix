{
  description = "A simple haskell template";

  outputs = { self }: {

    templates.haskell = {
      description = "A haskell executable";
      path = ./template;
    };

    defaultTemplate = self.templates.haskell;
  };
}
