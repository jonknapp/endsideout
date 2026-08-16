# nix/

Nix needs a different view of the gem bundle than Docker does, so the Nix build
gets its own lockfile here. There is still only one `Gemfile` — the one in the
repo root.

| file           | what it is                                                          |
| -------------- | ------------------------------------------------------------------- |
| `Gemfile.lock` | the same gem *versions* as `../Gemfile.lock`, but `PLATFORMS: ruby`  |
| `gemset.nix`   | generated from `Gemfile.lock` by bundix                              |

## Why two lockfiles

`../Gemfile.lock` lists precompiled platform gems (`nokogiri-x86_64-linux-gnu`,
`sqlite3-aarch64-linux-musl`, …). Two problems for Nix:

- `bundlerEnv` builds one gem set for one platform and can't consume those
  variants, so gems have to resolve to the pure-ruby platform and be compiled
  from source against nixpkgs' libxml2/sqlite/libffi.
- Those precompiled `.so`s are linked against a non-Nix glibc.

But the root lockfile can't just be reduced to `PLATFORMS: ruby`, because
`thruster` ships *only* a prebuilt Go binary — its pure-ruby gem is a shim that
prints `ERROR: Unsupported platform` and exits 1, which would break the
`CMD ["./bin/thrust", ...]` entrypoint in `../Dockerfile`.

## Regenerating

```sh
nix run .#update-gems
```

That reseeds `nix/Gemfile.lock` from `../Gemfile.lock` (so the two can only ever
differ in `PLATFORMS`, never in gem versions), strips the platform-specific
entries, and re-runs bundix. Run it after any change to `../Gemfile` or
`../Gemfile.lock`, and commit both `nix/Gemfile.lock` and `nix/gemset.nix`.

The only expected difference beyond `PLATFORMS` is `mini_portile2`, which the
source build of nokogiri depends on and the precompiled one doesn't.
