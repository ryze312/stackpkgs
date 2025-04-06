{ config, lib, pkgs, ... }:

# We're not using service.invidious.invidious-companion
# To prevent clashing with the modules in nixpkgs
let
  cfg = config.services.invidious-companion;
  configFile = pkgs.writers.writeTOML "invidious-companion-config" cfg.settings;

  denoDir = "/var/cache/invidious-companion";
in
{
  options.services.invidious-companion = {
    enable = lib.mkEnableOption "invidious-companion";
    package = lib.mkPackageOption pkgs "invidious-companion" {
      default = [ "stackpkgs" "unstable" "invidious-companion" ];
    };

    settings = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = ''
        Configuration for invidious-companion service.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the invidious-companion service.
        Enviroment variables can be used to set certain configuration values, including secret key, such as:
        - `HOST` => `server.host`,
        - `PORT` => `server.port`,
        - `SERVER_SECRET_KEY` => `server.secret_key`,
        - `SERVER_ENCRYPT_QUERY_PARAMS` => `server.encrypt_query_params`,
        - `PROXY` => `networking.proxy`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.invidious-companion = {
      before = lib.optional (config.services.invidious.enable) "invidious.service";
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment = {
        DENO_DIR = denoDir;
      } // lib.optionalAttrs (cfg.settings != null) {
        CONFIG_FILE = configFile;
      };

      serviceConfig = {
        ExecStart = lib.getExe cfg.package;

        DynamicUser = true;
        User = "invidious-companion";

        CacheDirectory = "invidious-companion";
        ReadWritePaths = [ denoDir ];

        CapabilityBoundingSet = "";
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0066";
      } // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
    };
  };
}
