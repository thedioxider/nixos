{
  description = "NixOS system built by Diomentia";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets-dir = {
      url = "path:/etc/secrets";
      flake = false;
    };
  };

  nixConfig = { max-jobs = "auto"; };

  outputs = { self, nixpkgs, ... }@inputs: {

    nixosConfigurations."miementa" = let system = "x86_64-linux";
    in nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        ### Main configurations
        ./system.nix

        ### Hardware dependant
        ./hw-configs/hw-fx707.nix

        ### Plasma Desktop
        # ./plasma.nix

        ### Network
        ./network.nix

        ### Power management & Sleep configs
        ./power.nix

        ### Graphics card setup & drivers
        ./graphics.nix

        ### Programs, Services & Environment
        ./env.nix

        ### Hyprland
        ./hyprland.nix

        ### keyd remapping service setup
        ./keyd.nix

        ### Other
        inputs.sops-nix.nixosModules.sops
      ];
    };
  };
}
