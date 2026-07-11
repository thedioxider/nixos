{
  description = "NixOS system built by Diomentia";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    secrets-dir = {
      url = "path:/etc/secrets";
      flake = false;
    };
    hyprland.url = "github:hyprwm/Hyprland/v0.55.2";
  };

  nixConfig = {
    max-jobs = "auto";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      nixosConfigurations."miementa" =
        let
          system = "x86_64-linux";
          allowUnfreePredicate = import ./unfree.nix nixpkgs.lib;
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.config = { inherit allowUnfreePredicate; };
              nixpkgs.overlays = [
                (self: super: {
                  unstable = import inputs.nixpkgs-unstable {
                    inherit (self.stdenv.hostPlatform) system;
                    config = { inherit allowUnfreePredicate; };
                  };
                })
              ];
            }
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

            ### Environment
            ./env.nix

            ### Programs
            ./programs.nix

            ### System packages & unfree allowlist
            ./packages.nix

            ### Services
            ./services.nix

            ### Secrets
            ./secrets.nix

            ### Hyprland
            ./hyprland.nix

            ### keyd remapping service setup
            ./keyd.nix

            ### Switch primary GPU at relogin
            ./aq-gpu.nix

            ### Other
            inputs.hyprland.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };
    };
}
