{ pkgs ? import <nixpkgs> {}
, doc ? {
    outPath = ./.;
    revCount = 0;
    shortRev = "0000000";
    gitTag = "master";
  }
}:
let
  lib = pkgs.lib;

in {
  platformDoc = lib.hydraJob (
    pkgs.stdenv.mkDerivation {
      name = "platform-doc";
      src = (import ./. {
        inherit pkgs;
        inherit (doc) revCount shortRev gitTag;
      });
      builder = pkgs.stdenv.shell;
      PATH = with pkgs; lib.makeBinPath [ coreutils gnutar gzip ];
      args = [ "-ec" ''
        mkdir -p $out/nix-support
        tar czf $out/platform-doc.tar.gz -C $src .
        echo "file tarball $out/platform-doc.tar.gz" >> $out/nix-support/hydra-build-products
        cp $src/objects.inv $out
        echo "file objects $out/objects.inv" >> $out/nix-support/hydra-build-products
      ''];
    }
  );
}
