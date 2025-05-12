{ config, lib, pkgs, ... }: {
  # enable OpenGL
  hardware.graphics = { enable = true; };

  # load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" "modesetting" ];

  hardware.nvidia = {
    modesetting.enable = true;

    dynamicBoost.enable = true;

    # turns off GPU when not in use
    powerManagement = {
      enable = true;
      finegrained = true;
    };

    # full list GPUs supported by open source kernel module
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    open = true;

    # `nvidia-settings`
    nvidiaSettings = true;

    # stable/latest/beta/production/vulkan_beta
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
