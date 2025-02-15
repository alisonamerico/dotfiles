{
  description = "Flake para NixOS com Home Manager e estrutura modular";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {
<<<<<<< HEAD
      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/common.nix
          ./modules/work.nix
=======
      default = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ./modules/common.nix
          ./modules/default.nix
>>>>>>> 85bcac74 (update files)
          home-manager.nixosModules.home-manager
        ];
      };

<<<<<<< HEAD
      personal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./modules/common.nix
          ./modules/personal.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };

    homeConfigurations = {
      work = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs;
        modules = [ ./home/work.nix ];
      };

      personal = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs;
        modules = [ ./home/personal.nix ];
=======
    homeConfigurations = {
      default = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs;
        modules = [ ./home/default.nix ];
>>>>>>> 85bcac74 (update files)
      };
    };
  };
}
