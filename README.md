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

### Useful Commands

- **Run all CI checks (Recommended before pushing)**: `bin/ci` (runs setup, RuboCop, security audits, and tests)
- **Run unit & integration tests**: `bin/rails test`
- **Run system tests**: `bin/rails test:system`
- **Code style & linting**: `bin/rubocop`
- **Security audits**: `bin/brakeman`, `bin/bundler-audit`, and `bin/importmap audit`