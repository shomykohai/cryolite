{
  pkgsUnstable,
  config,
  lib,
  ...
}: {
  options = {
    docker.stregatto.enable = lib.mkEnableOption "Enable the stregatto docker container";
  };

  config = lib.mkIf config.docker.stregatto.enable {
    # Needed for stregatto to work!
    services.ollama = {
      enable = true;
      package = pkgsUnstable.ollama;
      loadModels = [
        "llama3.2"
        "qwen3:4b"
        "qwen3:8b"
      ];
      host = "0.0.0.0";
    };

    virtualisation.oci-containers.containers = {
      stregatto = {
        image = "ghcr.io/cheshire-cat-ai/core:latest";
        ports = ["1865:80" "5678:5678"];
        volumes = [
          "/var/lib/stregatto/static:/app/cat/static"
          "/var/lib/stregatto/plugins:/app/cat/plugins"
          "/var/lib/stregatto/data:/app/cat/data"
        ];
        # extraOptions = ["--network=host"];
      };
    };
  };
}
