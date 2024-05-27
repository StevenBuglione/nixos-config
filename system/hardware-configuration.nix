# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "radeon" ];
  boot.initrd.kernelModules = [ "radeon" ];
  boot.kernelModules = [ "kvm-amd" "radeon" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
  hardware.opengl.extraPackages = [ pkgs.amdvlk ];
  hardware.opengl.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # my stupid usb hub crashes systemct suspend half of the time now
  # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Sleep_hooks
  systemd.services.root-suspend = {
    enable = true;
    description = "Root systemd suspend prehook";
    unitConfig = {
      Description = "Root systemd suspend prehook";
      Before = "sleep.target";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.uhubctl}/bin/uhubctl -a off";
    };
    wantedBy = [ "sleep.target" ];
  };
  systemd.services.root-resume = {
    enable = true;
    description = "Root systemd suspend posthook";
    unitConfig = {
      Description = "Root systemd suspend posthook";
      After = "suspend.target";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.uhubctl}/bin/uhubctl -a on";
    };
    wantedBy = [ "suspend.target" ];
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 90;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_background_ratio" = 2;
    "vm.dirty_ratio" = 5;
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/637d8261-0650-4ece-a35b-59d97baf64a7";
      fsType = "btrfs";
      options = [ "noatime,compress-force=zstd:2,discard=async,commit=120,clear_cache,space_cache=v2,subvol=@" ];
    };

  boot.initrd.luks.devices."luks-385106b5-71f7-460e-9a2b-2416f3b54cb6".device = "/dev/disk/by-uuid/385106b5-71f7-460e-9a2b-2416f3b54cb6";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/F09D-73C9";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp4s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
