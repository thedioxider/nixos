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
      wireplumber.extraConfig."99-bt-suspend" = {
        "monitor.bluez.rules" = [
          {
            matches = [{ "node.name" = "~bluez_output.*"; }];
            actions.update-props = {
                "session.suspend-timeout-seconds" = 1;
                "node.pause-on-idle" = true;
              };
          }
        ];
      };
    };
  };
}
