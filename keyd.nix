{ ... }:
{
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            rightalt = "layer(movements)";
            "leftmeta + leftalt" = "layer(media)";
            rightcontrol = "compose";
          };
          shift = {
            capslock = "capslock";
          };
          movements = {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
            u = "home";
            i = "end";
            "," = "C-S-tab";
            "." = "C-tab";
          };
          media = {
            z = "playpause";
            "*" = "play";
            "/" = "pause";
            "+" = "nextsong";
            "-" = "previoussong";
          };
        };
      };
    };
  };
}
