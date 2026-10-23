{
  description = "Hyprland on NixOS";

  inputs = {
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, nixos-hardware, ... }@inputs: {
    nixosConfigurations.larptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      specialArgs = { inherit inputs; }; 
      
      modules = [
        ./hosts/larptop
        
        nixos-hardware.nixosModules.common-pc-laptop-lenovo-thinkpad-open-fprintd
        
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { inherit spicetify-nix; };
            users.collguy = import ./home/collguy.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}

