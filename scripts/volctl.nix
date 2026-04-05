{ pkgs, ... }:

{
    name = "volctl";

    deps = [
        pkgs.wireplumber
        pkgs.gawk
        pkgs.gnugrep
    ];

    src = ''
        if [[ "$1" = "" || "$1" = "help" || "$1" = "--help" ]]; then
            echo "Usage: (<target> [<vol %>]) | list"
            echo "<target> : the process to target (no case)"
            echo "           special targets OUT and IN target current audio output/input"
            echo "<vol %> : the volume to assign to the target"
            echo "          if not provided, toggles mute/unmute"
            echo "list : list available targets"
            exit 0
        fi

        AVAILABLE_TARGETS=("$(wpctl status | \
                awk '/Streams/ { flag=1; next } /Video/ { flag = 0; exit } flag' | \
                grep -e "\[active\]" -e "\[paused\]" -e "\[init\]" -B 1 | grep -v -e "\[active\]" -e "\[paused\]" -e "\[init\]")")

        if [[ "$1" == "list" ]]; then
            echo "''${AVAILABLE_TARGETS[*]}" | sed 's/.*[0-9]*\. //'
            exit 0
        elif [[ "$1" == "OUT" ]]; then
            TARGET="@DEFAULT_SINK@"
        elif [[ "$1" == "IN" ]]; then
            TARGET="@DEFAULT_SOURCE@"
        else
            TARGET="$(echo "''${AVAILABLE_TARGETS[*]}" | grep -iwF "$1" | grep -o '[0-9]*')"
            if [[ -z $TARGET ]]; then
                echo "Could not find target $1"
                exit 1
            fi
        fi

        if [[ -z "$2" ]]; then
            wpctl set-mute "$TARGET" toggle
        else
            if [ "$2" -eq "$2" ] 2>/dev/null; then
                wpctl set-volume "$TARGET" "$2%"
            else
                echo "Volume ($2) is not a number"
                exit 1
            fi
        fi
    '';

    skipChecks = [ "SC2181" "SC2001" ];

    completions = ''
        #!${pkgs.runtimeShell}
        _volctl_completions() {
            if [[ "$COMP_CWORD" -eq 1 ]]; then
                WORDLIST=(OUT IN)
                local IFS=$'\n'
                WORDLIST+=("$(wpctl status | \
                    awk '/Streams/ { flag=1; next } /Video/ { flag = 0; exit } flag' | \
                    grep -e "\[active\]" -e "\[paused\]" -e "\[init\]" -B 1 | grep -v -e "\[active\]" -e "\[paused\]" -e "\[init\]" | \
                    sed 's/.*[0-9]*\. //' | sed 's/ *$//' | tr '[:upper:]' '[:lower:]')")
                COMPREPLY=($(compgen -W "''${WORDLIST[*]}" -- "''${COMP_WORDS[COMP_CWORD]}"))
                COMPREPLY=($(printf '%q\n' "''${COMPREPLY[@]}"))
            else
                COMPREPLY=()
            fi
        }

        complete -F _volctl_completions volctl
    '';
}
