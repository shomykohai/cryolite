{
  pkgs,
  frostix,
  lib,
  config,
  ...
}: {
  systemd.user.services.ferroxide = {
    enable = lib.mkIf config.programs.thunderbird-ferroxide.enable true;
    description = "Ferroxide Protonmail Bridge service";
    wantedBy = ["default.target"];
    after = ["network.target"];
    serviceConfig = {
      # You might be wondering, why are you using a wrapper script?
      # Well, simple answer: For some obscure reason, nix doesn't put the
      # `serve` option in the systemd service file.
      # Sooo, because this is already making me lose my mind,
      # just do things the hacky way.
      # TODO: See if this is actually a bug, or I just have skill issues :<
      ExecStart = "${pkgs.writeShellScript "ferroxide-wrapper" ''
        exec ${frostix.ferroxide}/bin/ferroxide serve
      ''}";
    };
  };
}
