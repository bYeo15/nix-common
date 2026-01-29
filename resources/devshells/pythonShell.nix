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
        source venv/bin/activate
        PS1="$SAVED_PS1"
    '';
}
