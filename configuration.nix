{ config, lib, pkgs, ... }: {
  imports = [
    ### Hardware-dependent options
    ./hardware-configuration.nix

    ### Power management & Sleep configs
    ./power.nix

    ### Graphics card setup & drivers
    ./graphics.nix

    ### Programs, Services & Environment
    ./env.nix

    ### Plasma Desktop
    # ./plasma.nix

    ### Hyprland
    ./hyprland.nix

    ### keyd remapping service setup
    ./keyd.nix
  ];

### NixOS special options
  system.copySystemConfiguration = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-settings" "nvidia-x11"
  ];
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
      extraConfig = ''
        GRUB_CMDLINE_LINUX="acpi_sleep=nonvs"
      '';
    };
  };

### System
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    packages = with pkgs; [ terminus_font ];
    font = "ter-120b";
    useXkbConfig = true;
  };

  networking.hostName = "diomentia";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";

  ### Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      roboto roboto-slab roboto-mono roboto-flex roboto-serif
    ] ++ (with pkgs.nerd-fonts; [
      symbols-only
      caskaydia-cove caskaydia-mono
      iosevka iosevka-term iosevka-term-slab
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

  services.libinput.enable = true;
  services.printing.enable = true;

  # enable the OpenSSH daemon
  # services.openssh.enable = true;

  services.xserver.xkb.options = "grp:win_space_toggle,shift:both_shiftlock";

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
    linger = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    packages = with pkgs; [
      home-manager
    ];
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
