{
  description = "Nix flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, hyprland, home-manager, ... }:
  let lib = nixpkgs.lib;
    user = "drembryo";
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  in {
    nixosConfigurations = {
      ${user} = lib.nixosSystem {
        inherit system;
        modules = [ ./configuration.nix ];
      };
    };

   homeConfigurations = {
      ${user} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [ ./home.nix ];
    };
   };
 };
}
