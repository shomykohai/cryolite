{
  pkgs,
  config,
  lib,
  ...
}: {
  options = {
    services.qemu.enable = lib.mkEnableOption "Enable QEMU virtualization service";
  };

  config = lib.mkIf config.services.qemu.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
      };
    };

    programs.virt-manager.enable = true;

    # GPU passthrough
    boot.kernelParams = ["intel_iommu=on" "iommu=pt"];
  };
}
