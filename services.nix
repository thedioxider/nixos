{ ... }:
{
  services = {
    flatpak.enable = true;
    pipewire = {
      pulse.enable = true;
      audio.enable = true;
    };
  };
}
