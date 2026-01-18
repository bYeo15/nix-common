{ config, lib, extlib, ... }: availableIntegrations: activeTheme:
    # Fold the (potentially nested) realisations of each integration into a single config attrset
    lib.attrsets.foldlAttrs (acc: n: v:
        acc // (
            lib.setAttrByPath availableIntegrations."${n}".attrpath (availableIntegrations."${n}".realise activeTheme v)
        )
    ) { }
    # Select only for enabled integrations
    (lib.filterAttrs (name: value: value.enable) activeTheme.integrations)

