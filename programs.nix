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
    };
    git.enable = true;
    firefox.enable = true;
    htop.enable = true;
    java.enable = true;
    less.enable = true;
    neovim.enable = true;
    nix-index.enable = true;
    nix-ld.enable = true;
    npm.enable = true;
    partition-manager.enable = true;
    rog-control-center.enable = true;
    yazi.enable = true;
    appimage = {
      enable = true;
      binfmt = true;
    };
    amnezia-vpn = {
      enable = true;
      package = pkgs.unstable.amnezia-vpn;
    };
    adb.enable = true;
    steam.enable = true;
  };
}
