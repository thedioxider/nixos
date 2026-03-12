{
  config,
  lib,
  pkgs,
  ...
}:
{
  # enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  nixpkgs.config.cudaSupport = true;
  nixpkgs.config.cudaCapabilities = [ "8.9" ];
  nixpkgs.config.cudaForwardCompat = false;

  nixpkgs.overlays = [
    (_: prev: {
      onnxruntime = prev.onnxruntime.override { cudaSupport = false; };
    })
  ];

  systemd.services.nix-daemon.serviceConfig.MemoryMax = "90%";

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
