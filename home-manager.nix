{ config, pkgs, lib, ... }:
let
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.useGlobalPkgs = true;

  home-manager.users.dio = { pkgs, ... }: {
    home.packages = with pkgs; [
      chezmoi
    ];
    programs = {
      firefox                 .enable = true;
      java                    .enable = true;
      neovim = {
        enable = true;
        defaultEditor = true;
      };
    };

    home.stateVersion = "24.11";
  };
}
