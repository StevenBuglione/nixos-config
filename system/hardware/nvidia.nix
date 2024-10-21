{ config, pkgs, ... }:

{
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.sessionVariables = {
    VDPAU_DRIVER = "nvidia";
    __GL_THREADED_OPTIMIZATIONS = "1";
  };
}