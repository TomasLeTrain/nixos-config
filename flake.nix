{
  description = "NIXOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors.url = "github:misterio77/nix-colors";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    potatofox = {
      url = "git+https://codeberg.org/awwpotato/PotatoFox";
      flake = false;
    };

    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # hyprland.url = "github:hyprwm/Hyprland";
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = { self, nixpkgs, home-manager, nix-colors, ... } @ inputs :
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
  in rec {
    nixosConfigurations = {
      nixbtw = lib.nixosSystem {
        inherit system pkgs;
        modules = [
	  ./nixos/configuration.nix
#           home-manager.nixosModules.home-manager
# 	  {
# 		  home-manager = {
# 			  useGlobalPkgs = true;
# 			  useUserPackages = true;
# # inherit pkgs;
# 			  extraSpecialArgs = { inherit inputs nix-colors; };
# 			  users.tomas = import ./home-manager/home.nix;
# 		  };
# 	  }
	];
      };
    };

    homeConfigurations = {
      # "tomas@nixbtw" = nixosConfigurations.nixbtw.config.home-manager.users.tomas.home;

      "tomas@nixbtw" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs nix-colors; };
        modules = [ ./home-manager/home.nix ];
      };
    };

	  #  packages = {
	  #      "${system}" = {
	  # # scuff way to let hm not fail
	  #        homeConfigurations = {
	  #          "tomas@nixbtw" = let
	  #            cfg = nixosConfigurations.nixbtw.config.home-manager.users.tomas;
	  #          in  {
	  #            activationPackage = cfg.home.activationPackage;  
	  #            config.news.json.output = cfg.news.json.output; 
	  #          };
	  #        };
	  #      };
	  #    };
   };

}
