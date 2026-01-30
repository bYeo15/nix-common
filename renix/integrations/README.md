# `renix` Integrations

A `renix` integration is a function of the form:
```
{ pkgs, lib, extlib, ... } -> {
    attrpath: list<str>
    realise: fn attrs -> fn attrs -> attrs
}
```

`attrpath` should expose the path of the Home Manager config that the integration corresponds to, while `realise` is a function that turns a given style config (the overall `renix` theme, then the integration config) into the actual Home Manager config.

Note that `attrpath` must be absolute.


## The Structure of an Integration

An integration's configuration should take the form
```
{
    enable: bool
    ...
}
```
`enable` is the only mandatory attribute, and it determines whether the config for the integration will be realised.

Everything else is integration-specific.

For the integration-specific attributes, refer to the given integration file.
