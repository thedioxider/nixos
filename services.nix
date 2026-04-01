{ pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    flatpak = {
      enable = true;
      package = pkgs.unstable.flatpak;
    };
    pipewire = {
      pulse.enable = true;
      audio.enable = true;
    };
  };
}
