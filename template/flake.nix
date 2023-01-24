{
  description = "A haskell executable";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # package/executable name
        packageName = "";
        execName = packageName;
        
        # version of ghc used
        hp = pkgs.haskellPackages;
        
        project = returnShellEnv:
          hp.developPackage {
            inherit returnShellEnv;
            name = packageName;
            root = ./.;
            withHoogle = false;
            overrides = self: super: with pkgs.haskell.lib; {
              # Use callCabal2nix to override Haskell dependencies here
              # Example: 
              # > NanoID = self.callCabal2nix "NanoID" inputs.NanoID { };
            };
            modifier = drv:
              pkgs.haskell.lib.addBuildTools drv (with hp; [
                # Specify your build/dev dependencies here.
              ]);
          };
      in
      {
        # Used by `nix build` & `nix run` (prod exe)
        packages.default = project false;

        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/${execName}";
        };

        # Used by `nix develop` (dev shell)
        devShell = project true;
      });
}
