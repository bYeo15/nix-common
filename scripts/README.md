# Script Packages

A script is described with a script definition, which is a function
```
{ config, lib, pkgs, ... } -> {
    name: str
    src: str
    completions: optional<str>
}
```

A script definition can be passed to `make_script.nix` to turn it into a derivation.

Scripts are aimed at Home-Manager.
