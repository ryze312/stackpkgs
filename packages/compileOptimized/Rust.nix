{ lib }:

# See https://doc.rust-lang.org/cargo/reference/profiles.html
# and https://doc.rust-lang.org/rustc/codegen-options/index.html
# for list of options

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
}:

pkg:

assert lib.assertOneOf "opt-level" opt-level [ "0" "1" "2" "3" "s" "z" ];
assert lib.assertOneOf "debug" debug [ "none" "line-directives-only" "line-tables-only" "limited" "full" ];
assert lib.assertOneOf "split-debug-info" split-debuginfo [ "off" "packed" "unpacked" ];
assert lib.assertOneOf "strip" strip [ "none" "debuginfo" "symbols" ];
assert lib.assertOneOf "lto" lto [ "off" "thin" "fat" ];
assert lib.assertOneOf "panic" panic [ "unwind" "abort" ];
assert lib.assertMsg (codegen-units > 0 && lib.mod codegen-units 1 == 0) "codegen-units must be a positive integer";

let
  codegenOptions = [
    "opt-level=${opt-level}"
    "debuginfo=${debug}"
    "split-debuginfo=${split-debuginfo}"
    "strip=${strip}"
    "debug-assertions=${lib.boolToString debug-assertions}"
    "overflow-checks=${lib.boolToString overflow-checks}"
    "lto=${lto}"
    "panic=${panic}"
    "codegen-units=${toString codegen-units}"
  ]
  ++ lib.optional (lto != "off") "embed-bitcode=true" # LLVM bitcode is required for performing LTO
  ++ lib.optional enableNoPIC "relocation-model=static";
in
pkg.overrideAttrs (finalAttrs: prevAttrs: {
  cargoBuildType = "release";

  # Disable tests with abort panic strategy. Tests can only run with unwind strategy
  # See unstable panic-abort-tests option
  doCheck = prevAttrs.doCheck && panic != "abort";

  RUSTFLAGS = (prevAttrs.RUSTFLAGS or "")
    + lib.strings.concatMapStringsSep " " (flag: "-C ${flag}") codegenOptions
    + " "
    + lib.strings.concatStringsSep " " additionalFlags;
})
