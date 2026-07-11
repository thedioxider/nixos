{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.aqGpu;

  orderList = lib.concatStringsSep " " cfg.order;

  # CLI. `_load` is what the Hyprland config calls at startup: it prints the
  # AQ_DRM_DEVICES string for the saved index and records what it handed over,
  # so `show` can tell whether a re-login is pending.
  aq-gpu = pkgs.writeShellApplication {
    name = "aq-gpu";
    runtimeInputs = [ pkgs.coreutils ];
    text = ''
      ORDER=( ${orderList} )
      N=''${#ORDER[@]}
      INDEX="''${XDG_STATE_HOME:-$HOME/.local/state}/aq-gpu/index"
      LOADED="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/aq-gpu-loaded"

      index() {  # current index, clamped to a valid entry
        local i; i="$(cat "$INDEX" 2>/dev/null || echo 0)"
        [[ "$i" =~ ^[0-9]+$ ]] || i=0
        echo "$(( i % N ))"
      }

      case "''${1:-show}" in
        show)
          want="''${ORDER[$(index)]}"
          loaded="$(cat "$LOADED" 2>/dev/null || true)"
          echo "configured: $want"
          if [ -n "$loaded" ]; then
            if [ "$loaded" = "$want" ]; then
              echo "running: $loaded (up to date)"
            else
              echo "running: $loaded (re-login to apply $want)"
            fi
          fi
          ;;
        switch)  # rotate to next, or jump to a named alias / index
          i="$(index)"
          if [ $# -ge 2 ]; then
            if [[ "$2" =~ ^[0-9]+$ ]]; then
              i=$(( $2 % N ))
            else
              i=-1
              for j in "''${!ORDER[@]}"; do
                if [ "''${ORDER[j]}" = "$2" ]; then i="$j"; fi
              done
              if [ "$i" -lt 0 ]; then
                echo "unknown: $2 (have: ''${ORDER[*]})" >&2
                exit 1
              fi
            fi
          else
            i=$(( (i + 1) % N ))
          fi
          mkdir -p "$(dirname "$INDEX")"; echo "$i" > "$INDEX"
          echo "next: ''${ORDER[i]} — re-login to apply"
          ;;
        _load)  # called by the Hyprland config; prints AQ_DRM_DEVICES value
          i="$(index)"; devs=""
          for (( k = 0; k < N; k++ )); do
            devs+="''${devs:+:}/dev/dri/''${ORDER[(i + k) % N]}"
          done
          mkdir -p "$(dirname "$LOADED")"; echo "''${ORDER[i]}" > "$LOADED"
          printf '%s\n' "$devs"
          ;;
        *) echo "usage: aq-gpu [show | switch [alias|index]]" >&2; exit 1 ;;
      esac
    '';
  };
in
{
  options.programs.aqGpu = {
    enable = lib.mkEnableOption "switchable compositor GPU via AQ_DRM_DEVICES";

    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      example = {
        igpu = "0000:00:02.0";
        dgpu = "0000:01:00.0";
      };
      description = ''
        Map of alias name -> PCI address. Each becomes a stable
        `/dev/dri/<alias>` symlink (pinned by PCI address, so it survives
        cardN renumbering across reboots).
      '';
    };

    order = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = lib.attrNames cfg.aliases;
      defaultText = lib.literalExpression "lib.attrNames cfg.aliases";
      description = ''
        Rotation order of aliases. Index 0 keeps the list as-is (first entry is
        the compositor's primary GPU); `aq-gpu switch` left-rotates it. Must
        include every card that may drive a monitor. Note the default sorts
        alphabetically — set this explicitly to control the default primary.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.extraRules =
      lib.concatMapStringsSep "\n" (
        alias:
        ''KERNELS=="${cfg.aliases.${alias}}", SUBSYSTEM=="drm", KERNEL=="card*", SYMLINK+="dri/${alias}"''
      ) (lib.attrNames cfg.aliases)
      + "\n";

    environment.systemPackages = [ aq-gpu ];
  };
}
