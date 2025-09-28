# Packages
| Name                  | Package             | Description                                                                             |
|-----------------------|---------------------|-----------------------------------------------------------------------------------------|
| AudioRelay            | audiorelay          | Application to stream every sound from your PC to one or multiple Android devices       |
| Compile optimized     | compileOptimized    | Utility function for compiling packages with custom compile flags aimed at optimization |
| VSCode extensions     | vscode-extensions   | Collection of VSCode extensions not found in nixpkgs                                    |

# Unstable packages
Unstable packages are packages that may or may not be in nixpkgs, they are located under unstable attrset.
These packages are updated more frequently than their nixpkgs counterparts.
| Name                  | Package             | Description                                    |
|-----------------------|---------------------|------------------------------------------------|
| Invidious             | invidious           | Open source alternative front-end to YouTube   |
| invidious-companion   | invidious-companion | Invidious companion for handling video streams |

# Compile optimized
Compile packages written in various languages using custom compile flags, typically this would override some attribute in the provided package derivation. A set of defaults is provided, which can be overridden. Additional flags may be set using `additionalFlags` parameter.

You can use the functions as follows:
```
compileOptimized.${language}
```

## Example
```
compileOptimized.Rust {
    panic = "unwind"; # Use unwind for panic
} pkgs.rustc
```

## C
Overrides: `env.NIX_CFLAGS_COMPILE`

`CNoLTO` is also provided for convenience, as many packages may fail to compile with LTO enabled.

### Defaults
```
{
  optimizationLevel ? "O3",
  enableLTO ? true,
  additionalFlags ? []
}
```

## Rust
Overrides: `RUSTFLAGS`

### Defaults
```
{
  opt-level ? "3",
  debug ? "none",
  split-debuginfo ? "off",
  strip ? "symbols",
  debug-assertions ? false,
  overflow-checks ? false,
  lto ? "fat",
  panic ? "abort",
  codegen-units ? 1,
  enableNoPIC ? false,
  additionalFlags ? []
}
```

# VSCode extensions
A set of VSCode extensions is available, typically this would contain extensions which are missing from nixpkgs.

Extensions are built from [TOML file](./packages/vscode-extensions/extensions.toml), which describes the required attributes for building in `info` section and additional information in `meta` section.

## Available extensions
- [LeonardSSH.vscord](https://marketplace.visualstudio.com/items?itemName=LeonardSSH.vscord)
- [Catppuccin.catppuccin-vsc-icons](https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons)
- [keifererikson.nightfox](https://marketplace.visualstudio.com/items?itemName=keifererikson.nightfox)
- [willasm.comment-highlighter](https://marketplace.visualstudio.com/items?itemName=willasm.comment-highlighter)
- [geequlim.godot-tools](https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools)
