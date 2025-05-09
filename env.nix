{ lib, pkgs, ... }: {
### Programs, Services & Environment
  programs = {
    command-not-found       .enable = false;
    fish                    .enable = true;
    git                     .enable = true;
    # TODO: maybe change to btop++
    htop                    .enable = true;
    java                    .enable = true;
    less                    .enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    nix-index               .enable = true;
    nix-ld                  .enable = true;
    npm                     .enable = true;
    partition-manager       .enable = true;
    rog-control-center      .enable = true;
    yazi                    .enable = true;
  };

  services = {};

  environment.shellAliases = {};

  environment.systemPackages = with pkgs; [
    gcc
    wl-clipboard
    trashy
    parted
    gparted
    p7zip
    calc
  ];
}
