# NixOS Common

Host/user agnostic components for building a NixOS system.

This provides;
- Custom modules used to simplify configuration
    - "Data-only" modules (and public realisations thereof where appropriate)
    - Proper configuration modules that can be enabled
- Useful functions
- Resources used by modules (eg. shell templates)


## `extlib`

`extlib` is an extension to the Nix standard library, providing a few utility functions.

For a list of extensions, refer to the `extlib` README.

Note that all common modules **require** `extlib` to be passed to them.


## `renix`

`renix` is a Home Manager styling module, based around 2-bit colour palettes.

`renix` uses a 2-bit colour system organised into a `main` foreground-background pair, and
an `accent` foreground-background pair.

It provides the following;
```
activeTheme [theme] : the current chosen theme
themes [attrset<theme>] : a set of available themes
```

with auxilary options;
```
theme {
    colour [palette] : the primary colour palette (hex colours)
    termColour [palette] : the colour palette for terminals (terminal 256 colour)
    fontMono [str] : the name of the default monospace font
    fontSerif [str] : the name of the default serif font
    fontSans [str] : the name of the default sans-serif font
    fontSizeLarge [int - 15] : large font size
    fontSizeNormal [int - 12] : standard font size
    fontSizeSmall [int - 10] : small font size

    integrations [attrs] : a set of all integration configurations
}

palette {
    mainBg [str] : the primary background colour
    mainFg [str] : the primary foreground colour
    accentBg [str] : the accent background colour
    accentFg [str] : the accent foreground colour
}
```

### `renix` Integrations

The following integration modules are provided for `renix`:
- TODO


For more detail, refer to the `renix` README.


## `data_modules`

A data module provides a means of declaring an easily accessible data value.

Data modules never cause the generation of any config on their own, and thus are intended to be compatible with both NixOS and Home-Manager.

Data modules are often the description of data that is then provided from a `secrets` module.
