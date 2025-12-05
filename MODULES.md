# Modules

## invidious-companion
Module for configuring the [inviduous-companion](https://github.com/iv-org/invidious-companion) service for use with [invidious](https://github.com/iv-org/invidious). By default the package from stackpkgs is used. You can configure the companion settings and specify enviroment file, e.g for storing secrets.
```nix
services.invidious-companion = {
  enable = true;
  package = stackpkgs.unstable.invidious-companion;
  
  environmentFile = "";
  settings = {};
};
```

## twitch-recorder
Module for configuring the [twitch-recorder](https://github.com/ryze312/twitch-recorder) service. By default the package from stackpkgs is used. In settings, you can can optionally use values from an environment fil, e.g to safely specify the client details.
```nix
services.twitch-recorder = {
  enable = true;
  package = stackpkgs.twitch-recorder;
  
  environmentFile = "/var/lib/secrets/twitch-recorder.env";
  settings = {    
    twitch = {
      client_id = "$CLIENT_ID";
      client_secret = "$CLIENT_SECRET";
      token = "$TOKEN"; 
      
      users = [ "twitch" ];
    };
  };
};
```
