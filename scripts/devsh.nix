{ config, lib, pkgs, ... }:

{
    name = "devsh";

    deps = [
        pkgs.coreutils
        pkgs.npins
    ];

    src = ''
        TARGET_DEVSHELL="${config.devshells.default.template}"
        INIT_HOOK='${config.devshells.default.hook}'

        case $1 in
            "help" | "--help")
                echo "Usage: <shell>"
                echo -e "${lib.attrsets.foldlAttrs (acc: n: v: acc + "\n\t${n}") "Available Shells:" config.devshells}"
                exit 0
            ;;
            ${lib.attrsets.foldlAttrs (acc: n: v: acc + "${n})\nTARGET_DEVSHELL=${v.template}\nINIT_HOOK=\'${v.hook}\'\n;;\n") "" config.devshells}
            "")
            ;;
            *)
                echo "[ ERROR ] : $1 is not a known devshell"
                exit 1
            ;;
        esac

        cp "$TARGET_DEVSHELL" ./shell.nix
        chmod u+w ./shell.nix
        npins init
        eval "$INIT_HOOK"
        echo "use nix" > ./.envrc
    '';

    completions = ''
        #!${pkgs.runtimeShell}
        complete -W "${lib.attrsets.foldlAttrs (acc: n: v: acc + "${n} ") "" config.devshells}" devsh
    '';
}
