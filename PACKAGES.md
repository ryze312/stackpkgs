# Packages
| Name              | Package           | Description                                                                             |
|-------------------|-------------------|-----------------------------------------------------------------------------------------|
| AudioRelay        | audiorelay        | Application to stream every sound from your PC to one or multiple Android devices       |
| Compile optimized | compileOptimized  | Utility function for compiling packages with custom compile flags aimed at optimization |
| VSCode extensions | vscode-extensions | Collection of VSCode extensions not found in nixpkgs                                    |

# Compile optimized
Compile packages written in various languages using custom compile flags, typically this would override some attribute in the provided package derivation. A set of defaults is provided, which can be overriden. Additional flags may be set using `additionalFlags` parameter.

You can use the functions as follows:
```
compileOptimized.${language}
```

## Example
```
compileOptimized.Rust {
    enableNativeOptimizations = false; # No native optimizations
} pkgs.rustc
```

## C
Overrides: `env.NIX_CFLAGS_COMPILE`

`CNoLTO` is also provided for convinience, as many packages may fail to compile with LTO enabled.

### Defaults
```
{
  optimizationLevel ? "O3",
  enableLTO ? true,
  enableNativeOptimizations ? true,
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
  enableNativeOptimizations ? true,
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
