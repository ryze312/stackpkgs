{ newPkgs, system, ... }:

{
  users.users.ryze = {
    isNormalUser = true;
    password = "ryze";
    extraGroups = [ "wheel" ];
  };

  nixpkgs = {
    pkgs = newPkgs;
    hostPlatform = system;
  };

  nix.settings = {
    experimental-features = [ "flakes" "nix-command" ];
    trusted-users = [ "ryze" ];
  };
}
