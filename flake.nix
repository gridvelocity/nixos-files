{
  description = "Hyprland on NixOS";

  inputs = {
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1. Add the community NixOS hardware support repo
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, nixos-hardware, ... }@inputs: {
    nixosConfigurations.larptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Expose 'inputs' to all your NixOS system submodules (like security.nix)
      specialArgs = { inherit inputs; }; 
      
      modules = [
        # Your host-specific entry point
        ./hosts/larptop
        
        # Pull in the baseline X1 Carbon Gen 4 optimizations
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-carbon-gen4
        
        # Home Manager configuration layer
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
