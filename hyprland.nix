{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hyprland-pkgs = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = with pkgs; [
    egl-wayland
    swaynotificationcenter

    # (catppuccin-sddm.override { flavor = "macchiato"; })
    where-is-my-sddm-theme
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    # https://wiki.hyprland.org/Configuring/Multi-GPU/
    AQ_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = [ pkgs.qt6.qt5compat ];
    theme = "where_is_my_sddm_theme";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
    package = hyprland-pkgs.hyprland;
    portalPackage = hyprland-pkgs.xdg-desktop-portal-hyprland;
  };

  services.hypridle.enable = true;
}
