# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./graphics.nix
      ./keyd.nix
    ];

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/efi";
    };
    grub = {
      enable = true;
      useOSProber = false;
      efiSupport = true;
      device = "nodev";
      timeoutStyle = "menu";
      default = "saved";
    };
  };

  system.copySystemConfiguration = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    persistent = true;
    options = "--delete-older-than 90d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "monthly" ];
  };

  networking.hostName = "diomentia"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      roboto roboto-slab roboto-mono roboto-flex roboto-serif
      (nerdfonts.override { fonts = [
        "NerdFontsSymbolsOnly"
        "CascadiaCode" "CascadiaMono"
        "Iosevka" "IosevkaTerm" "IosevkaTermSlab"
        "JetBrainsMono"
        "ComicShannsMono"
      ]; })
    ];

    fontconfig.defaultFonts = {
      serif = [ "Roboto Serif" "Noto Serif" ];
      sansSerif = [ "Roboto Sans" "Noto Sans" ];
      monospace = [ "CaskaydiaCove Nerd Font" "Roboto Mono" "Noto Sans Mono" ];
      emoji = [ "Noto Emoji" ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-120b";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # KDE Plasma 6
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,ru";
    options = "grp:win_space_toggle,caps:escape";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.groups.nixos.members = [ "root" "dio" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dio = {
    description = "Demetrius R.";
    isNormalUser = true;
    uid = 1134;
    initialHashedPassword =
      "$y$j9T$mH5EZb/OBF8ACbwFGIEHa1$5Cw0t9dqll73lpN2vATJU9RW03/MWlPs.PwpgrZd0m0";
    useDefaultShell = false;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      home-manager
    ];
  };

  programs = {
    command-not-found       .enable = false;
    firefox                 .enable = true;
    fish                    .enable = true;
    git                     .enable = true;
    htop                    .enable = true;
    java                    .enable = true;
    less                    .enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    nix-index               .enable = true;
    nix-ld                  .enable = true;
    npm                     .enable = true;
    partition-manager       .enable = true;
    rog-control-center      .enable = true;
    yazi                    .enable = true;
  };

  services = {
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    trashy
    parted
    gparted
    p7zip
    calc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;




  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

