{ config, lib, pkgs, ... }: {
  ### NixOS special options
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.nix-sweep = {
    enable = true;
    interval = "weekly";
    removeOlder = "7d";
    keepMin = 5;
    keepMax = 20;
  };
  nix.optimise = {
    automatic = true;
    dates = [ "monthly" ];
  };

  ### Boot
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

  ### System
  i18n = {
    defaultLocale = "C.UTF-8";
    extraLocaleSettings = { LC_TIME = "ru_RU.UTF-8"; };
  };
  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-120b";
    useXkbConfig = true;
  };

  networking.hostName = "miementa";

  time.timeZone = "Europe/Moscow";

  services.libinput.enable = true;
  services.printing.enable = true;

  services.xserver.xkb.options = "grp:win_space_toggle,shift:both_shiftlock";

  security.lsm = lib.mkForce [ ];
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs;
      [ noto-fonts roboto roboto-slab roboto-mono roboto-flex roboto-serif ]
      ++ (with pkgs.nerd-fonts; [
        symbols-only
        caskaydia-cove
        caskaydia-mono
        iosevka
        iosevka-term
        iosevka-term-slab
        jetbrains-mono
        comic-shanns-mono
      ]);

    fontconfig.defaultFonts = {
      serif = [ "Roboto Serif" "Noto Serif" ];
      sansSerif = [ "Roboto Sans" "Noto Sans" ];
      monospace = [ "CaskaydiaCove Nerd Font" "Roboto Mono" "Noto Sans Mono" ];
      emoji = [ "Noto Emoji" ];
    };
  };

  ### Users & Groups
  users.groups.nixos.members = [ "root" "dio" ];

  users.users.dio = {
    description = "Demetrius R.";
    isNormalUser = true;
    uid = 1134;
    initialHashedPassword =
      "$y$j9T$mH5EZb/OBF8ACbwFGIEHa1$5Cw0t9dqll73lpN2vATJU9RW03/MWlPs.PwpgrZd0m0";
    useDefaultShell = false;
    shell = pkgs.fish;
    # start session at boot rather then at login
    linger = false;
    extraGroups =
      [ "wheel" "networkmanager" "kvm" "adbusers" "dialout" "video" ];
    packages = with pkgs; [ ];
  };

  ### Uncon-figured out (yet)
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  #
  #
  #
  #
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
