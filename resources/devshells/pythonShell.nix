let
    sources = import ./npins;
    pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
    packages = with pkgs; [
        python3
    ];

    shellHook = ''
        SAVED_PS1="$PS1"
        if [[ -d venv ]]; then
            source venv/bin/activate
        fi
        PS1="$SAVED_PS1"
    '';
}
