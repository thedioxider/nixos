{ config, lib, ... }:
let
  nmProfile = { id # Name of a network displayed in system
    , ptype ? "wifi" # Profile type
    , ssid ? null # WiFi SSID
      # WiFi security type (e.g. "wpa-enterprise")
    , security ? if (ptype == "wifi") then "wpa-personal" else null
    , psk ? null # psk for wpa-personal
    , zone ? "public" # Firewall zone
    , autoconnect ? true
    , autoconnect-priority ? null # Priority in range [-999,999]
    , permissions ? null # User/group permissions
    , eap-auth ? null # Credentials needed for wpa-enterprise
    , ... }:
    let
      supported_ptype = [ "wifi" "vpn" ];
      supported_wifi_security = [ "wpa-personal" "wpa-enterprise" ];
    in assert lib.assertMsg (builtins.elem ptype supported_ptype) ''
      unknown profile type: ${ptype}
      supported: ${builtins.concatStringsSep ", " supported_ptype}
    '';
    assert lib.assertMsg (ptype == "wifi" -> ssid != null)
      "wifi ssid is required: ${id}";
    assert lib.assertMsg
      (ptype == "wifi" -> builtins.elem security supported_wifi_security) ''
        unknown wifi security: ${security}
        supported: ${builtins.concatStringsSep ", " supported_wifi_security}
      '';
    lib.filterAttrsRecursive (n: v: v != null) {
      connection = {
        inherit id ssid permissions autoconnect autoconnect-priority zone;
        type = ptype;
      };
      ipv4 = { method = "auto"; };
      ipv6 = { method = "auto"; };
    } // lib.optionalAttrs (ptype == "wifi") ({
      wifi = {
        inherit ssid;
        mode = "infrastructure";
      };
    } // lib.optionalAttrs (security == "wpa-personal") {
      wifi-security = {
        inherit psk;
        auth-alg = "open";
        key-mgmt = "wpa-psk";
      };
    } // lib.optionalAttrs (security == "wpa-enterprise")
      (assert lib.assertMsg (eap-auth != null)
        "eap-identity is required: ${id}";
        wpaEnterpriseProfile eap-auth));
  wpaEnterpriseProfile = { eap ? "peap" # Type of enterprice connection
    , ca-cert, identity, password, ... }:
    let supported_eap = [ "peap" ];
    in assert lib.assertMsg (builtins.elem eap supported_eap) ''
      unknown EAP: ${eap}
      supported: ${builtins.concatStringsSep ", " supported_eap}
    ''; {
      wifi-security = {
        auth-alg = "open";
        key-mgmt = "wpa-eap";
      };
      "802-1x" = {
        inherit eap ca-cert identity password;
      } // lib.optionalAttrs (eap == "peap") { phase2-auth = "mschapv2"; };
    };

  # all the connections can be stored externally in json
  connections_config = /etc/secrets/network/connections.json;
  # connections_config = ./secrets/example/network/connections.json;
  profiles = builtins.mapAttrs (n: v: nmProfile ({ id = n; } // v)) ({
    dendobriy = {
      id = "dobriyden"; # can be omitted since name of attr used as fallback
      ptype = "wifi";
      zone = "trusted";
      ssid = "dobriyden";
      psk = "dendobriy";
      # you can have your secrets inserted as environment variables, i.e.
      # psk = "$dobriyden_psk";
    };
  } // lib.optionalAttrs (builtins.pathExists connections_config)
    (builtins.fromJSON (builtins.readFile connections_config)));

  # secrets stored in form of environment variables
  env_secrets = lib.optional
    (builtins.pathExists config.sops.secrets.network-credentials.path)
    config.sops.secrets.network-credentials.path;
in {
  # sops.age.sshKeyPaths = ["${./secrets/example/example_ssh}"];
  sops.secrets = let
    network-credentials_path = /etc/secrets/network/credentials.env;
    # network-credentials_path = ./secrets/example/network/credentials.env;
  in lib.optionalAttrs (builtins.pathExists network-credentials_path) {
    network-credentials = {
      format = "dotenv";
      sopsFile = network-credentials_path;
      key = "";
    };
  };

  networking.networkmanager = {
    enable = true;
    # wifi.powersave = true;
    ensureProfiles = {
      inherit profiles;
      environmentFiles = env_secrets;
    };
  };

  # required for DHCP to function
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 53 67 111 2049 7667 8090 8082 ];
    allowedTCPPorts = [ 111 2049 ];
    extraCommands = ''
      iptables -A INPUT -p udp -s 224.0.0.0/4 -j ACCEPT
      iptables -A INPUT -p udp -d 224.0.0.0/4 -j ACCEPT
    '';
  };

  # services.avahi = {
  #   enable = true;
  #   nssmdns4 = true;
  #   nssmdns6 = true;
  # };
  # users.groups.avahi-autoipd.name = "avahi-autoipd";
  # users.users.avahi-autoipd = {
  #   isNormalUser = true;
  #   home = "/var/lib/avahi-autoipd";
  #   group = "avahi-autoipd";
  # };

  # enable the OpenSSH daemon
  services.openssh.enable = true;
}
