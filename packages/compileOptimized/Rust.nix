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
  enableNativeOptimizations ? true,
  enableNoPIC ? false,
  additionalFlags ? []
}:

pkg:

assert builtins.elem opt-level [ "0" "1" "2" "3" "s" "z" ];
assert builtins.elem debug [ "none" "line-directives-only" "line-tables-only" "limited" "full" ];
assert builtins.elem split-debuginfo [ "off" "packed" "unpacked" ];
assert builtins.elem strip [ "none" "debuginfo" "symbols" ];
assert builtins.elem lto [ "off" "thin" "fat" ];
assert builtins.elem panic [ "unwind" "abort" ];
assert codegen-units > 0;

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
  ++ lib.optional enableNoPIC "relocation-model=static"
  ++ lib.optional enableNativeOptimizations "target-cpu=native";
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
