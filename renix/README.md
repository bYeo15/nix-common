# renix

`renix` is a styling system for NixOS (targeting Home-Manager).

A `renix` style consists of a base theme, and configuration of application-specific integrations.

## Base Theme

A base `renix` theme is
```
{
    # Hex RGB colour palette for full-colour applications
    colour = {
        mainBg = "<hex colour>";
        mainFg = "<hex colour>";
        accentBg = "<hex colour>";
        accentFg = "<hex colour>";
    };

    # Terminal ANSI-256 colour palette
    termColour = {
        mainBg = "<256 colour>";
        mainFg = "<256 colour>";
        accentBg = "<256 colour>";
        accentFg = "<256 colour>";
    };

    fontMono = "<fontname>";
    fontSans = "<fontname>";
    fontSerif = "<fontname>";

    fontSizeLarge = <size>;
    fontSizeNormal = <size>;
    fontSizeSmall = <size>;

    integrations = {
        # See below
        <integration_name> = {
            enable = true;
            # ...
        };
    };
}
```

## Integrations

Integrations target specific applications. By enabling an integration, your fonts and colours are automatically applied to the target application.

Each integration may also offer additional customisation options. See `integrations` for specific options.
