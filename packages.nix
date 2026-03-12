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
    distrobox
    exfatprogs
    xorg.xhost
    libGL
    glib
    cudatoolkit
    inputs.nix-sweep.packages.${pkgs.stdenv.hostPlatform.system}.default
    helix
    pulsemixer
    podman-tui
    podman-compose
  ];
}
