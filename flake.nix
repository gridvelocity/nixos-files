{
  description = "Hyprland on Nixos";

  inputs = {
    spicetify-nix.url = "github:Gerg-L/spicetify-nix/24.11";

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