{pkgs, ...}: {
  # Actual containers configuration
  imports = [
    ./containers.nix
  ];

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "btrfs";

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.oci-containers.backend = "docker";

  networking.firewall.trustedInterfaces = ["docker0"];
  networking.firewall.extraCommands = ''
    iptables -A DOCKER-USER -m physdev --physdev-is-bridged -j ACCEPT
    iptables -A DOCKER-USER -i br-+ -o br-+ -j DROP
  '';

  systemd.user.services.dockerd = {
    enable = true;
    description = "Docker daemon";
    wantedBy = ["default.target"];
    serviceConfig = {
      ExecStart = "${pkgs.docker}/bin/dockerd --host=fd://";
    };
  };
}
