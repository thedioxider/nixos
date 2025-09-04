{ config, lib, pkgs, modulesPath, ... }:
let
  asus-armoury = pkgs.fetchurl {
    url =
      "https://lore.kernel.org/all/20240926092952.1284435-1-luke@ljones.dev/t.mbox.gz";
    hash = "sha256-E6KdDvvyHiLUWWO/PAHXMtIDGFG0c7ZfAeohlhJtjwI=";
  };
in {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usb_storage" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ ];
  boot.kernelPatches = [{
    name = "asus-armoury";
    patch = asus-armoury;
  }];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5656b356-ca2f-4776-bc58-6f04094316f2";
    fsType = "ext4";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-uuid/9F38-9C03";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/dsk/win/C" = {
    device = "/dev/disk/by-uuid/0C06D2E106D2CABA";
    fsType = "ntfs";
  };
  fileSystems."/dsk/win/D" = {
    device = "/dev/disk/by-uuid/A876D57A76D54A28";
    fsType = "ntfs";
  };

  fileSystems."/dsk/arch" = {
    device = "/dev/disk/by-uuid/a0918439-753b-4e5e-8eb7-69e90f3754fa";
  };

  boot.loader.grub.extraEntries = ''
    menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os {
        savedefault
        set gfxpayload=keep
        insmod gzio
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 9F38-9C03
        linux /vmlinuz-linux root=UUID=a0918439-753b-4e5e-8eb7-69e90f3754fa rw loglevel=3 quiet resume=/dev/disk/by-uuid/42837e7a-845e-475a-8315-b31d4efc25d6
        initrd /intel-ucode.img /initramfs-linux.img
    }

    menuentry 'Windows 11' --class windows --class os $menuentry_id_option {
        savedefault
        insmod part_gpt
        insmod fat
        search --no-floppy --fs-uuid --set=root 78FE-DD96
        chainloader /efi/Microsoft/Boot/bootmgfw.efi
    }
  '';

  swapDevices =
    [{ device = "/dev/disk/by-uuid/99a71219-fd36-4bc7-824b-9b048aedd575"; }];
  boot.resumeDevice = "/dev/disk/by-uuid/99a71219-fd36-4bc7-824b-9b048aedd575";

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp55s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" "i915" ];

  hardware.bluetooth.enable = true;

  services.xserver.xkb.layout = "us,ru";

  # hardware.opentabletdriver = {
  #   enable = true;
  #   daemon.enable = true;
  # };
}
