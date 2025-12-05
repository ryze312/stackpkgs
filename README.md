# Stackpkgs

> [!NOTE]
> Stabilty is not guaranteed. I will try my best to provide support, but there may be occasional issues.

Stackpkgs is a collection of packages and modules commonly used in my NixOS configurations, split into a separate repository for ease of reuse and sharing.

## How to use
In order to use stackpkgs, you have to enable `flakes` and optionally `nix-command` experimental features in your nix configuration.
```nix
nix.settings.experimental-features = [ "flakes" "nix-command" ];
```
Then you should be able to add stackpkgs as an input to your flake. 
```nix
inputs = {
  stackpkgs = "git+https://code.thishorsie.rocks/ryze/stackpkgs";
  
  # Or from GitHub
  # stackpkgs = "github:ryze312/stackpkgs";
};
```

### Use the overlay
```nix
nixpkgs.overlays = [
  stackpkgs.overlays.default
];

# The packages will be accessible under the stackpkgs attrset
environment.systemPackages = [
  pkgs.stackpkgs.audiorelay
];
```

### Use a module
For example [twitch-recorder](https://github.com/ryze312/twitch-recorder) module:
```nix
imports = [ stackpkgs.nixosModules.twitch-recorder ];

services.twitch-recorder = {
  enable = true;
  settings = {};
};
```

## See available:
- [Packages](PACKAGES.md)
- [Modules](MODULES.md)
