{
  description = "Nix dev shell for a Ruby project that uses mise";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            bashInteractive
            mise
            git
            gnumake
            pkg-config
            openssl
            zlib
            readline
            libyaml
            libffi
            libxml2
            libxslt
            postgresql
            vips
            rustc
            cargo
            nodejs_26
            chromium
            chromedriver
          ];

          shellHook = ''
            export MISE_CONFIG_DIR="$PWD"
            export MISE_DATA_DIR="$PWD/.mise"
            export MISE_CACHE_DIR="$PWD/.cache/mise"
            export MISE_STATE_DIR="$PWD/.local/state/mise"

            mkdir -p "$MISE_DATA_DIR" "$MISE_CACHE_DIR" "$MISE_STATE_DIR"

            export LD_LIBRARY_PATH="${
              pkgs.lib.makeLibraryPath [
                pkgs.vips
                pkgs.openssl
                pkgs.zlib
                pkgs.libxml2
                pkgs.libxslt
              ]
            }:$LD_LIBRARY_PATH"

            eval "$(${pkgs.mise}/bin/mise activate bash)"
          '';
        };
      }
    );
}
