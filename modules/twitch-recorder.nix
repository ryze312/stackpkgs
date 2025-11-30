{ config, lib, pkgs, ... }:

{
  options.services.twitch-recorder = {
    enable = lib.mkEnableOption "twitch-recorder";
    package = lib.mkPackageOption pkgs "twitch-recorder" {
      default = [ "stackpkgs" "twitch-recorder" ];
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      description = ''
        twitch-recorder configuration
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file in format defined by systemd.exec(5).
        Client details can be passed this way, without havint to expose them in world-readable Nix store.

        ```
        services.twitch-recorder.settings = {
          twitch = {
            client_id = "$CLIENT_ID";
            client_secret = "$CLIENT_SECRET";
            token = "$TOKEN";
          }
        }
        ```
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "twitch-recorder";
      description = ''
        User for twitch-recorder service
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "twitch-recorder";
      description = ''
        Group for twitch-recorder service
      '';
    };
  };

  config =
  let
    cfg = config.services.twitch-recorder;
    envsubst = lib.getExe pkgs.envsubst;
    configFile = pkgs.writers.writeTOML "twitch-recorder.toml" cfg.settings;

    envSubstitute = cfg.environmentFile != null;
    needUser = cfg.user == "twitch-recorder";
    needGroup = cfg.group == "twitch-recorder";
    userSetOutputPath = lib.hasAttrByPath [ "downloader" "output_path" ] cfg.settings;

    finalConfig = if envSubstitute then
      "\${RUNTIME_DIRECTORY}/twitch-recorder.toml"
    else
      configFile;

    ensureConfigOption = option: path: {
      assertion = lib.hasAttrByPath (lib.splitString "." path) cfg.settings;
      message = "${option} (services.twitch-recorder.settings.${path}) must be defined";
    };
  in
  lib.mkIf cfg.enable {
    assertions = [
      (ensureConfigOption "Client ID" "twitch.client_id")
      (ensureConfigOption "Client secret" "twitch.client_secret")
      (ensureConfigOption "Token" "twitch.token")
    ];

    users.users.twitch-recorder = lib.mkIf needUser {
      isSystemUser = true;
      description = "Twitch-Recorder user";
      group = cfg.group;
    };

    users.groups.twitch-recorder = lib.mkIf needGroup {};

    systemd.services.twitch-recorder = {
      description = "Twitch-Recorder";
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      preStart = lib.mkIf envSubstitute ''
        ${envsubst} -i ${configFile} -o ${finalConfig}
      '';

      script = ''
        ${lib.getExe cfg.package} -c ${finalConfig}
      '';

      serviceConfig = {
        EnvironmentFile = lib.mkIf envSubstitute cfg.environmentFile;

        StateDirectory = "twitch-recorder";
        RuntimeDirectory = "twitch-recorder";
        WorkingDirectory = "/var/lib/twitch-recorder";

        ReadWritePaths = lib.mkIf userSetOutputPath [
          cfg.settings.downloader.output_path
        ];

        User = cfg.user;
        Group = cfg.group;

        StateDirectoryMode = "770";
        UMask = "0007";

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
          "~@privileged"
          "~@resources"
        ];
      };
    };
  };
}
