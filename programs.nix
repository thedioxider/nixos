{ pkgs, ... }:
{
  programs = {
    command-not-found.enable = false;
    fish = {
      enable = true;
      shellAliases = {
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
      };
      package = pkgs.unstable.fish;
    };
    git.enable = true;
    firefox.enable = true;
    htop.enable = true;
    java.enable = true;
    less.enable = true;
    neovim = {
      enable = true;
      package = pkgs.unstable.neovim-unwrapped;
    };
    nix-index.enable = true;
    nix-ld.enable = true;
    npm = {
      enable = true;
      package = pkgs.unstable.nodePackages.npm;
    };
    partition-manager.enable = true;
    rog-control-center.enable = true;
    yazi = {
      enable = true;
      package = pkgs.unstable.yazi;
    };
    appimage = {
      enable = true;
      binfmt = true;
    };
    amnezia-vpn = {
      enable = true;
      package = pkgs.unstable.amnezia-vpn;
    };
    adb.enable = true;
    steam = {
      enable = true;
      package = pkgs.unstable.steam;
    };
  };
}
