{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.agola;

in {
  options.services.agola = {
    enable = mkOption {
      description = "Whether to enable agola.";
      default = false;
      type = types.bool;
    };

    adminToken = mkOption {
      description = "Password for web.";
      default = "root";
      type = types.str;
    };

    hmacKey = mkOption {
      description = "Password for hmac.";
      default = "supersecretsigningkey";
      type = types.str;
    };

    etcdPort = mkOption {
      description = "Port number for embedded etcd instance.";
      default = 2379;
      type = types.port;
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/agola";
      description = "Agola data directory.";
    };
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 agola - - -"
    ];

    #services.etcd.enable = true;

    systemd.services.agola = let
      etcdAddress = "http://localhost:${toString cfg.etcdPort}";
      configFile = pkgs.writeText "config-agola.yml" ''
        gateway:
          apiExposedURL: "http://localhost:8000"
          webExposedURL: "http://localhost:8000"
          runserviceURL: "http://localhost:4000"
          configstoreURL: "http://localhost:4002"
          gitserverURL: "http://localhost:4003"

          web:
            listenAddress: ":8000"
            tls: false
          tokenSigning:
            method: hmac
            key: ${cfg.hmacKey}
          adminToken: "${cfg.adminToken}"

        scheduler:
          runserviceURL: "http://localhost:4000"

        notification:
          webExposedURL: "http://localhost:8000"
          runserviceURL: "http://localhost:4000"
          configstoreURL: "http://localhost:4002"
          etcd:
            endpoints: "${etcdAddress}"

        configstore:
          dataDir: ${cfg.dataDir}/configstore
          etcd:
            endpoints: "${etcdAddress}"
          objectStorage:
            type: posix
            path: ${cfg.dataDir}/configstore/ost
          web:
            listenAddress: ":4002"

        runservice:
          dataDir: ${cfg.dataDir}/runservice
          etcd:
            endpoints: "${etcdAddress}"
          objectStorage:
            type: posix
            path: ${cfg.dataDir}/runservice/ost
          web:
            listenAddress: ":4000"

        executor:
          dataDir: ${cfg.dataDir}/executor
          toolboxPath: ${pkgs.agola}/bin
          runserviceURL: "http://localhost:4000"
          web:
            listenAddress: ":4001"
          activeTasksLimit: 2
          driver:
            type: docker

        gitserver:
          dataDir: ${cfg.dataDir}/gitserver
          gatewayURL: "http://localhost:8000"
          web:
            listenAddress: ":4003"
      '';
    in {
      description = "Simple build server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      unitConfig = {
        Documentation = "https://github.com/agola-io/agola";
      };

      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.agola}/bin/agola serve --config ${configFile} --embedded-etcd --components all-base,executor";
        User = "agola";
        LimitNOFILE = 40000;
      };
    };

    environment.systemPackages = [ pkgs.agola ];

    users.extraGroups.agola = {};
    users.extraUsers.agola = {
      description = "Agola daemon user";
      extraGroups = [ "agola" ];
      home = cfg.dataDir;
    };
  };
}
