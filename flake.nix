{
  description = "endsideout";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-ruby.url = "github:bobvanderlinden/nixpkgs-ruby";
    nixpkgs-ruby.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-ruby,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        name = "endsideout";
        pkgs = import nixpkgs {
          inherit system;

          config.allowUnfree = true;
        };
        ruby = nixpkgs-ruby.packages.${system}."ruby-4.0";

        # Gemfile.lock says `BUNDLED WITH 4.0.16`, but pkgs.bundler is still on
        # 2.x, which won't read a 4.x lockfile. Build the matching Bundler.
        bundler = pkgs.buildRubyGem {
          inherit ruby;

          gemName = "bundler";
          version = "4.0.16";
          name = "bundler-4.0.16";
          source.sha256 = "sha256-1spd1EDCT5q86YRM9EzI4YxqVT3mWkfvtFRBN6+SxH0=";
          dontPatchShebangs = true;

          postFixup = ''
            substituteInPlace $out/bin/bundle \
              --replace-quiet "activate_bin_path" "bin_path"
          '';
        };

        # bundix 2.5.0 doesn't know Bundler's `windows` platform alias, which the
        # stock Rails Gemfile uses for tzinfo-data and debug. It looks the name up
        # in PLATFORM_MAPPING, gets nil back, and dies with
        # "Cannot convert to nix: nil" while serialising gemset.nix.
        #
        # Kept to a single line of Ruby on purpose: a multi-line replacement here
        # is at the mercy of however nixfmt reindents the '' string.
        bundix-unwrapped = pkgs.bundix.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace lib/bundix.rb \
              --replace-fail '"x64_mingw" => [{engine: "mingw"}],' \
              '"x64_mingw" => [{engine: "mingw"}], "windows" => [{engine: "mswin"}, {engine: "mswin64"}, {engine: "mingw"}],'
          '';
        });

        # bundix defaults every path to the working directory (Gemfile,
        # Gemfile.lock, gemset.nix), so a bare `bundix` in this repo writes a root
        # gemset.nix generated from the *multi-platform* root lockfile — the exact
        # thing the two-lockfile split exists to avoid. Bake the right paths in;
        # anything the caller passes still wins, since it comes later in ARGV.
        bundix = pkgs.writeShellApplication {
          name = "bundix";

          runtimeInputs = [
            pkgs.gitMinimal
            pkgs.nix
          ];

          # Called by store path, not by name: this wrapper is itself called
          # `bundix`, so a bare `bundix` here would be one PATH change away from
          # recursing into itself.
          text = ''
            root=$(git rev-parse --show-toplevel)
            exec ${bundix-unwrapped}/bin/bundix \
              --gemfile="$root/Gemfile" \
              --lockfile="$root/nix/Gemfile.lock" \
              --gemset="$root/nix/gemset.nix" \
              "$@"
          '';
        };

        # `bundler` is an argument of the bundlerEnv *function*, not of its
        # attrset, so it has to be threaded in with .override — passing it
        # alongside gemfile/gemset gets silently swallowed by the `...` pattern,
        # leaving you with whatever pkgs.bundler happens to be.
        gems = (pkgs.bundlerEnv.override { inherit bundler; }) {
          inherit name ruby;

          # One Gemfile, two lockfiles — see nix/README.md. The root
          # Gemfile.lock keeps its precompiled platform gems so Docker's
          # ./bin/thrust entrypoint works; nix/Gemfile.lock is the same versions
          # pinned to PLATFORMS: ruby, the only shape bundlerEnv and bundix can
          # consume.
          gemfile = ./Gemfile;
          lockfile = ./nix/Gemfile.lock;
          gemset = ./nix/gemset.nix;
        };

        # Reseeds nix/Gemfile.lock from the canonical lockfile, strips the
        # platform-specific entries, and regenerates nix/gemset.nix. Seeding from
        # the root lock rather than resolving from scratch is what keeps the two
        # lockfiles on identical gem versions.
        update-gems = pkgs.writeShellApplication {
          name = "update-gems";

          runtimeInputs = [
            ruby
            bundler
            bundix # the path-pinning wrapper, so the paths below are belt-and-braces
            pkgs.gnugrep
            pkgs.gawk
            pkgs.gitMinimal
            pkgs.nix
          ];

          text = ''
            root=$(git rev-parse --show-toplevel)
            cd "$root"

            cp Gemfile.lock nix/Gemfile.lock

            # --lockfile keeps every write off the canonical Gemfile.lock, so
            # this only ever touches nix/Gemfile.lock.
            export BUNDLE_GEMFILE="$root/Gemfile"
            export BUNDLE_FORCE_RUBY_PLATFORM=true

            platforms=$(awk '
              /^PLATFORMS/ { in_section = 1; next }
              /^$/         { in_section = 0 }
              in_section && $1 != "ruby" { print $1 }
            ' nix/Gemfile.lock)

            # All in one invocation, deliberately: looping one platform per call
            # leaves only the last removal applied. force_ruby_platform is what
            # leaves `ruby` behind once the rest are gone.
            if [ -n "$platforms" ]; then
              # shellcheck disable=SC2086
              bundle lock --lockfile=nix/Gemfile.lock --remove-platform $platforms
            fi

            remaining=$(awk '
              /^PLATFORMS/ { in_section = 1; next }
              /^$/         { in_section = 0 }
              in_section   { print $1 }
            ' nix/Gemfile.lock)
            if [ "$remaining" != "ruby" ]; then
              echo "update-gems: expected PLATFORMS: ruby, got: $remaining" >&2
              exit 1
            fi
            if grep -qE '^ +[^ ]+ \([0-9][^)]*-(x86_64|aarch64|arm64|arm|java|universal)' nix/Gemfile.lock; then
              echo "update-gems: platform-specific gems survived in nix/Gemfile.lock" >&2
              exit 1
            fi

            bundix \
              --gemfile="$root/Gemfile" \
              --lockfile="$root/nix/Gemfile.lock" \
              --gemset="$root/nix/gemset.nix"
          '';
        };
      in
      {
        apps = {
          bundix = {
            type = "app";
            program = "${bundix}/bin/bundix";
          };
          bundler = {
            type = "app";
            program = "${bundler}/bin/bundler";
          };
          update-gems = {
            type = "app";
            program = "${update-gems}/bin/update-gems";
          };
        };

        packages.default = gems;

        devShells.default = pkgs.mkShell {
          inherit name;

          IRB_USE_AUTOCOMPLETE = "false";

          # tailwindcss-ruby vendors a prebuilt binary in its platform-specific
          # gem variant, which the pure-ruby platform doesn't have. This is the
          # gem's documented escape hatch for exactly that case; it wants the
          # *directory* holding the executable, not the executable.
          TAILWINDCSS_INSTALL_DIR = "${pkgs.tailwindcss_4}/bin";

          packages = [
            # gems.wrappedRuby is a `ruby` that already knows about the gem path.
            # The bare interpreter would shadow it and hide every bundled gem.
            gems
            gems.wrappedRuby
            bundix
            update-gems
          ]
          ++ (with pkgs; [
            nixfmt
            nodejs_24
            overmind
            vips
            (yarn.override { nodejs = nodejs_24; })
          ]);
        };
      }
    );
}
