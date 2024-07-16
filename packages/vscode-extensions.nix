{ lib, vscode-utils }:

let
  extensions = builtins.fromTOML (builtins.readFile ./vscode-extensions/extensions.toml);
  marketplaceBaseURL = "https://marketplace.visualstudio.com/items?itemName=";

  buildExtension = (publisher: name: ext:
    vscode-utils.buildVscodeMarketplaceExtension {
      # Generate publisher and name
      # Replace hash with fake one if needed
      mktplcRef = ext.info
                  // { inherit publisher name; }
                  // lib.optionalAttrs (ext.info.hash == "fake") { hash = lib.fakeHash; };

      # Generate download page
      # And convert SPDX license to license from lib
      meta = ext.meta // {
        downloadPage = marketplaceBaseURL + "${publisher}.${name}";
        license = lib.getLicenseFromSpdxId ext.meta.license;
      };
    }
  );

  # Just calls buildExtension for each extension found in publisher.extensionName attrsets
  transformExtensions = extensions: lib.mapAttrs (publisher: ext: lib.mapAttrs (buildExtension publisher) ext) extensions;
in
transformExtensions extensions
