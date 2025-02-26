{
  inv-sig-helper,
  fetchFromGitHub,
}:

inv-sig-helper.overrideAttrs (_: finalAttrs: rec {
  name = "${finalAttrs.pname}-${version}";
  version = "0-unstable-2025-02-26";

  src = fetchFromGitHub {
    owner = "iv-org";
    repo = "inv_sig_helper";
    rev = "add99d6a654bae838b030914a7fef8252406fc45";
    hash = "sha256-p1cbXYmKBoeXF4L9XKc5jc79KW8dxzDbjZiUSMJQDs8=";
  };
})
