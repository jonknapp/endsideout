# EndsideOut LMS

## Mission 💖

[EndsideOut](https://endsideout.org/) is a non-profit dedicated to combatting obesity and chronic health conditions by building health literacy and fostering behavior change in underserved communities.

This application is a Learning Management System (LMS) that helps EndsideOut deliver its health literacy curriculum, schedule that curriculum across schools and classrooms, and track participation and trends over time.

## Reach 🌟

EndsideOut currently runs programs in **Baltimore, Maryland** and surrounding counties, plus a **remote program in Liberia**. This LMS is the tool that will let a small team deliver curriculum consistently across every one of those classrooms.

## Ruby for Good

EndsideOut LMS is one of many projects initiated and run by Ruby for Good. You can find out more at https://rubyforgood.org.

## Status ⚠️

This project is in **active early development** and is **not yet open to outside contributors**. We are still defining what the application needs to do. Once requirements are settled, we will open it up and publish contribution guidelines here.

## How It Works

EndsideOut staff build a **curriculum** as a set of **programs**. Each program is broken into ordered **content modules** at different **levels**, and every module holds the videos, documents, and resources that make up the lesson.

Curriculum is delivered through **schools** and their **classrooms**. A classroom enrolls in a program at a given level, and modules are scheduled to publish on specific dates. **Students** belong to a classroom, and their participation is recorded through **student sessions** — giving the organization the statistics and trends it needs to measure impact.

See [Architecture Decision Records (ADRs)](docs/adrs/README.md) for architectural decisions and guidelines.

## Getting Started 🛠️

Built on **Ruby on Rails 8** with Hotwire, Tailwind, SQLite, and the Solid stack (Queue/Cache/Cable), deployed with Kamal.

### Prerequisites

- **[mise](https://mise.jdx.dev/)**: Recommended environment and tool version manager for Ruby (macOS & Linux / WSL2).
- **libvips**: Native image processing library required by Active Storage.
  - **macOS**: `brew install libvips`
  - **Ubuntu/Debian**: `sudo apt-get install -y libvips`
  - **Fedora**: `sudo dnf install vips`
  - **Windows**: Use [WSL2 (Windows Subsystem for Linux)](https://learn.microsoft.com/en-us/windows/wsl/install) with Ubuntu/Debian.
- **SQLite3**: Database engine (pre-installed on macOS).

### Local Setup

1. **Clone the repository**:

   ```sh
   git clone https://github.com/rubyforgood/endsideout.git
   cd endsideout
   ```

2. **Install Ruby with mise**:

   ```sh
   mise install
   ```

3. **Run setup**:

   ```sh
   bin/setup
   ```

   This will install gem dependencies, prepare and seed the database, and clear log/temp files.

4. **Start the development server**:
   ```sh
   bin/dev
   ```
   Visit [http://localhost:3000](http://localhost:3000) in your browser. Seed data is generated with [Faker](https://github.com/faker-ruby/faker); see `db/seeds.rb` for default login credentials.

### Setup with Nix

If you prefer a more reproducible development environment, the project includes a `flake.nix` that uses [Nix](https://nixos.org/) to provide all system-level dependencies (compilers, native libraries, `mise` itself) without requiring any manual installation steps.

**How it works**

Rather than replacing `mise`, Nix acts as the layer beneath it. The `flake.nix` provides a dev shell containing:

- `mise` — which then installs and manages Ruby per `.mise.toml`
- All native libraries that Ruby gems need to compile (`libvips`, `openssl`, `libxml2`, `libffi`, `zlib`, etc.)
- Other dev tools (`git`, `pkg-config`, etc.)

This means the `mise` + `bundle install` workflow is unchanged inside the Nix shell — Nix just ensures the C libraries and build tools are present and reproducible across machines.

**Prerequisites**

- [Nix](https://nixos.org/download/) with flakes enabled
- [direnv](https://direnv.net/) with [nix-direnv](https://github.com/nix-community/nix-direnv) (recommended, for automatic shell activation)

Enable flakes if you haven't already (add to `~/.config/nix/nix.conf` or `/etc/nix/nix.conf`):

```
experimental-features = nix-flakes nix-command
```

**Entering the dev shell**

With direnv (recommended — activates automatically on `cd`):

```sh
direnv allow
```

Without direnv:

```sh
nix develop
```

Both drop you into a shell where `mise`, all native libraries, and build tools are available. From there, run the normal setup:

```sh
mise install   # installs Ruby 4.0.6
bin/setup      # installs gems, prepares the database
bin/dev        # starts the server
```

**Where things get installed**

Inside the Nix shell, the `shellHook` redirects all mise data into the project directory so nothing is written to your home folder:

| What               | Location                                              |
| ------------------ | ----------------------------------------------------- |
| Ruby (and bundler) | `.mise/installs/ruby/4.0.6/`                          |
| Gems               | `.mise/installs/ruby/4.0.6/lib/ruby/gems/4.0.0/gems/` |
| mise shims         | `.mise/shims/`                                        |
| mise cache         | `.cache/mise/`                                        |
| mise state         | `.local/state/mise/`                                  |

All of these directories are gitignored. The Nix store itself (`/nix/store/...`) holds the system libraries and the `mise` binary — those are read-only and shared across your machine, never modified by this project.

Outside the Nix shell (e.g. with a globally installed mise), Ruby goes to `~/.local/share/mise/installs/ruby/4.0.6/` and gems follow it there.

**Updating dependencies**

_Ruby version:_ change `.mise.toml`, then run `mise install` inside the Nix shell.

_Native library changes:_ edit `flake.nix` and re-enter the shell (`direnv reload` or `nix develop`). Commit both `flake.nix` and `flake.lock`.

_Gem versions:_ all gem updates happen inside the Nix shell so the native libraries are available when gems with C extensions compile. The order matters:

1. Edit `Gemfile` with your changes (add, remove, or loosen a version constraint).
2. Update `Gemfile.lock`:
   ```sh
   bundle update <gemname>   # update a specific gem and its dependencies
   # or
   bundle update             # update everything within Gemfile constraints
   ```
3. Install the updated gems:
   ```sh
   bundle install
   ```

Steps 2 and 3 can be combined — `bundle update` installs as well as re-locks — but running them separately makes it easier to review what changed in `Gemfile.lock` before gems are written to disk.

Commit both `Gemfile` and `Gemfile.lock` together.

### Useful Commands

- **Run all CI checks (Recommended before pushing)**: `bin/ci` (runs setup, RuboCop, security audits, and tests)
- **Run unit & integration tests**: `bin/rails test`
- **Run system tests**: `bin/rails test:system`
- **Code style & linting**: `bin/rubocop`
- **Security audits**: `bin/brakeman`, `bin/bundler-audit`, and `bin/importmap audit`
