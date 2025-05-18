{ lib }:

{
	optimizationLevel ? "O3",
	enableLTO ? true,
	additionalFlags ? []
}:

pkg:

assert lib.assertOneOf "optimizationLevel" optimizationLevel [
	"O0"
	"O1"
	"O2"
	"O3"
	"Ofast"
	"Os"
	"Oz"
	"Og"
];

let
	flags = [ "-${optimizationLevel}" ]
			++ lib.optional enableLTO "-flto"
			++ additionalFlags;
in
pkg.overrideAttrs (prevAttrs: {
	env.NIX_CFLAGS_COMPILE = (prevAttrs.env.NIX_CFLAGS_COMPILE or "")
							 + lib.strings.concatStringsSep " " flags;
})
