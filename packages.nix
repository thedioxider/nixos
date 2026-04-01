{
  pkgs,
  inputs,
  ...
}:
{
  environment.systemPackages =
    (with pkgs; [
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
      pulsemixer
      podman-tui
      podman-compose
    ])
    ++ (with pkgs.unstable; [
      helix
      amneziawg-go
      amneziawg-tools
    ])
    ++ [
      inputs.nix-sweep.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
}
