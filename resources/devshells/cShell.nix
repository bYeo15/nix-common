let
    sources = import ./npins;
    pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
    packages = with pkgs; [
        gcc
        cmocka
        ltrace
        valgrind
        gdb
    ];
}
