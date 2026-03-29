{ config, lib, ... }:

let
    browser = lib.findFirst (x: x.cond) (abort "quicksearch cannot be used without a browser") [
        {
            pkg = config.programs.qutebrowser.package;
            target = "qutebrowser --target private-window";
            cond = config.programs.qutebrowser.enable;
        }

        {
            pkg = config.programs.firefox.package;
            target = "firefox --private-window";
            cond = config.programs.firefox.enable;
        }
    ];

    launcher = lib.findFirst (x: x.cond) (abort "quicksearch cannot be used without a launcher") [
        {
            pkg = config.programs.rofi.package;
            target = "echo | rofi -dmenu -p 'Search Term:' -theme-str 'window{height:32;}'";
            cond = config.programs.rofi.enable;
        }
    ];

    # FUTURE: infer from config
    engine = "https://noai.duckduckgo.com/?q=";
in {
    name = "quicksearch";

    deps = [
        browser.pkg
        launcher.pkg
    ];

    src = ''
        REGEX_SITE="[^\ ]+\.[^\ ]+"

        SEARCH="$(${launcher.target})"

        if [[ -z $SEARCH ]]; then exit 1; fi

        if [[ $SEARCH ~= $REGEX_SITE ]]; then
            exec ${browser.target} $SEARCH
        else
            exec ${browser.target} ${engine}$SEARCH
        fi
    '';
}
