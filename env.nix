{ lib, pkgs, ... }:
let sops-nix = builtins.getFlake "github:Mic92/sops-nix";
in {
  imports = [ sops-nix.nixosModules.sops ];

  ### Programs, Services & Environment
  programs = {
    command-not-found.enable = false;
    fish.enable = true;
    git.enable = true;
    # TODO: maybe change to btop++
    htop.enable = true;
    java.enable = true;
    less.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    nix-index.enable = true;
    nix-ld.enable = true;
    npm.enable = true;
    partition-manager.enable = true;
    rog-control-center.enable = true;
    yazi.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    amnezia-vpn.enable = true;
  };

  services = { flatpak.enable = true; };

  environment.shellAliases = { };

  environment.systemPackages = with pkgs; [
    brightnessctl
    gcc
    jq
    ffmpeg
    zip
    unzip
    age
    ssh-to-age
    sops
    wl-clipboard
    trashy
    parted
    gparted
    p7zip
    calc
    dive
    podman-tui
    podman-compose
    distrobox
  ];

  environment.variables = { EDITOR = "nvim"; };

  ### Encryption & Secrets
  sops = let secrets-store_path = /etc/secrets/store.yaml;
  in lib.optionalAttrs (builtins.pathExists secrets-store_path) {
    defaultSopsFile = secrets-store_path;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = { hello = { }; };
  };
}
