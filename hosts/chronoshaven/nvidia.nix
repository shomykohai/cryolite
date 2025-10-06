{ pkgs, config, libs, ... }:

{
  # OpenGL
  hardware.graphics = {
    enable = true;
  };


  services.xserver.videoDrivers = ["nvidia" "intel"];

  # Stop nix from complaining

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;


    powerManagement.enable = false;
    powerManagement.finegrained = false;

    prime = {
      intelBusId = "PCI:00:02.0";
      nvidiaBusId = "PCI:01:00.0";
    };
    
    # On wayland, the display is not recognized anyway
    nvidiaSettings = false;
    
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

}