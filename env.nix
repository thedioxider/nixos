{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    (builtins.elem (lib.getName pkg) [
      "nvidia-settings"
      "nvidia-x11"
      "cuda-merged"
      "libnvjitlink"
      "libnpp"
      "cudnn"
      "zerotierone"
      "steam"
      "steam-unwrapped"
    ])
    || (builtins.match "^(cuda_[a-z_]+)|(libcu[a-z]+)$" (lib.getName pkg)) != null;

  ### Programs, Services & Environment
  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
      };
    };
    git.enable = true;
    firefox.enable = true;
    # TODO: maybe change to btop++
    htop.enable = true;
    java.enable = true;
    less.enable = true;
    neovim.enable = true;
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
    adb.enable = true;
    steam.enable = true;
  };

  services = {
    flatpak.enable = true;
    pipewire = {
      pulse.enable = true;
      audio.enable = true;
    };
  };

  environment.shellAliases = { };

  environment.systemPackages = with pkgs; [
    brightnessctl
    gcc
    jq
    wget
    curl
    ffmpeg
    zip
    unzip
    age
    ssh-to-age
    sops
    wl-clipboard
    trash-cli
    parted
    gparted
    p7zip
    calc
    dive
    podman-tui
    podman-compose
    distrobox
    exfatprogs
    xorg.xhost
    libGL
    glib
    cudatoolkit
    inputs.nix-sweep.packages.${pkgs.stdenv.hostPlatform.system}.default
    helix
  ];

  ### Encryption & Secrets
  sops =
    let
      secrets-store_path = "${inputs.secrets-dir}/store.yaml";
    in
    lib.optionalAttrs (builtins.pathExists secrets-store_path) {
      defaultSopsFile = secrets-store_path;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

      secrets = {
        hello = { };
      };
    };
}
