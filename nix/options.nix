{
  config,
  lib,
  pkgs,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };
  cfg = config.services.hister;
  hasSettings = cfg.settings != { };
  mkHisterEnv =
    cfg:
    lib.optionalAttrs (cfg.dataDir != null) {
      HISTER_DATA_DIR = cfg.dataDir;
    }
    // lib.optionalAttrs (cfg.port != null) {
      HISTER_PORT = builtins.toString cfg.port;
    }
    // lib.optionalAttrs (cfg.configPath != null) {
      HISTER_CONFIG = builtins.toString cfg.configPath;
    }
    // lib.optionalAttrs (cfg.settings != { }) {
      HISTER_CONFIG = "${yamlFormat.generate "hister-config.yml" cfg.settings}";
    };
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "hister" "config" ] [ "services" "hister" "settings" ])
  ];

  options.services.hister = {
    enable = lib.mkEnableOption "Hister web history service";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The hister package to use.";
    };

    dataDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/lib/hister";
      description = ''
        Directory where Hister stores its data.
        If set, this will override the `app.directory` setting in the configuration file.
      '';
    };

    port = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      example = 4433;
      description = ''
        Port on which Hister listens.
        If set, this will override the `server.address` port in the configuration file.
      '';
    };

    configPath = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/etc/hister/config.yml";
      description = "Path to an existing configuration file.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/hister.env";
      description = ''
        Path to an environment file (read at service start) used to inject
        secrets such as `HISTER__APP__ACCESS_TOKEN` without placing them in
        the world-readable Nix store. Only honored by the systemd-based
        services (NixOS and Linux home-manager); ignored on launchd.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = yamlFormat.type;
        options = {
          app = lib.mkOption {
            type = lib.types.submodule { freeformType = yamlFormat.type; };
            default = { };
            description = "App section (maps to the `app:` block of config.yml).";
          };
          server = lib.mkOption {
            type = lib.types.submodule { freeformType = yamlFormat.type; };
            default = { };
            description = "Server section (maps to the `server:` block of config.yml).";
          };
          indexer = lib.mkOption {
            type = lib.types.submodule { freeformType = yamlFormat.type; };
            default = { };
            description = "Indexer section (maps to the `indexer:` block of config.yml).";
          };
          crawler = lib.mkOption {
            type = lib.types.submodule { freeformType = yamlFormat.type; };
            default = { };
            description = "Crawler section (maps to the `crawler:` block of config.yml).";
          };
          hotkeys = lib.mkOption {
            type = lib.types.submodule { freeformType = yamlFormat.type; };
            default = { };
            description = "Hotkeys section (maps to the `hotkeys:` block of config.yml).";
          };
          extractors = lib.mkOption {
            type = lib.types.submodule { freeformType = yamlFormat.type; };
            default = { };
            description = "Extractors section (maps to the `extractors:` block of config.yml).";
          };
          sensitive_content_patterns = lib.mkOption {
            type = lib.types.attrsOf lib.types.str;
            default = { };
            description = "Regular expressions for redacting sensitive content.";
          };
        };
      };
      default = { };
      description = ''
        Hister configuration rendered to YAML and passed via HISTER_CONFIG.
        Accepts any structure the server accepts — see the `app`, `server`,
        `indexer`, `crawler`, `hotkeys`, `extractors`, and
        `sensitive_content_patterns` blocks documented upstream.
      '';
      example = lib.literalExpression ''
        {
          app = {
            search_url = "https://google.com/search?q={query}";
            log_level = "info";
          };
          server = {
            address = "127.0.0.1:4433";
            database = "db.sqlite3";
          };
          hotkeys.web = {
            "/" = "focus_search_input";
            "enter" = "open_result";
          };
        }
      '';
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.configPath != null && hasSettings);
        message = "Only one of services.hister.configPath and services.hister.settings can be set";
      }
    ];
    _module.args.histerEnv = mkHisterEnv;
  };
}
