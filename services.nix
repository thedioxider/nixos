{ ... }:
{
  services = {
    gvfs.enable = true;
    flatpak.enable = true;
    pipewire = {
      pulse.enable = true;
      audio.enable = true;
    };
  };
}
