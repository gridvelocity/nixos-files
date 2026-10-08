{
  description = "Hyprland on Nixos";

  inputs = {
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, ... }: {
    nixosConfigurations.larptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        {
          nixpkgs.overlays = [
            (final: prev: {
              libfprint-2-tod1-vfs0090 =
                prev.libfprint-2-tod1-vfs0090.overrideAttrs (old: {
                  patches = (old.patches or []) ++ [
                    ./patches/vfs0090-libfprint-1.94.patch
                  ];

                  meta = old.meta // {
                    broken = false;
                  };
                });
            })
          ];
        }

        ./configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = {
              inherit spicetify-nix;
            };

            users.collguy = import ./home.nix;

            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}