/*
    TEMP: This currently builds a patched version of `glpaper`, pending
    a finished `glbg`
*/

{
    lib,
    stdenv,
    fetchFromGitHub,
    meson,
    ninja,
    pkg-config,
    wayland,
    libx11,
    libGL,
}:

stdenv.mkDerivation {
    pname = "glbg";
    version = "fork-patch";

    src = fetchFromGitHub {
        owner = "bYeo15";
        repo = "glbg";
        rev = "refs/heads/glpaper_fix";
        hash = "sha256-B5OKQsYCvoSnqE54S6T/zOc8aC1pNXeR5j6UxQBRgs4=";
    };

    nativeBuildInputs = [
        meson
        ninja
        pkg-config
    ];

    buildInputs = [
        wayland
        libx11 # required by libglvnd
        libGL
    ];

    meta = {
        description = "wlr_layer_shell based gl desktop background";
        mainProgram = "glpaper";    # TEMP
        license = lib.licenses.gpl3Plus;
        platforms = lib.platforms.linux;
    };
}
