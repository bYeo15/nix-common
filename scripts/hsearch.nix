{ config, lib, pkgs, ... }:

let
    launcher = lib.findFirst (x: x.cond) (abort "hsearch cannot be used without a launcher") [
        {
            pkg = config.programs.rofi.package;
            target = "rofi -dmenu -no-tokenize -p 'Select History Entry:'";
            cond = config.programs.rofi.enable;
        }
    ];

    clipboard = lib.findFirst (x: x.cond) (abort "hsearch cannot be used without a clipboard") [
        {
            pkg = pkgs.wl-clipboard;
            target = "wl-copy";
            cond = lib.any (x: x.value.enable) (lib.attrsToList config.wayland.windowManager);
        }
    ];
in {
    name = "hsearch";

    deps = [
        launcher.pkg
        clipboard.pkg
    ];

    src = ''
        HIST="$(cat "$HISTFILE")"

        if [[ $# -ge 1 ]]; then
            HIST="$(grep -- "$@" <<< "$HIST")"
        fi

        ${launcher.target} <<< "$HIST" | ${clipboard.target}
    '';
}
