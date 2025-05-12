{ lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    egl-wayland
    swaynotificationcenter
    hyprpolkitagent

    (catppuccin-sddm.override { flavor = "macchiato"; })
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
    theme = "catppuccin-macchiato";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };
}
