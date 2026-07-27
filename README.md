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

See [DESIGN.md](DESIGN.md) for the full data model and workflow.

## Getting Started 🛠️

Built on **Ruby on Rails 8** with Hotwire, Tailwind, SQLite, and the Solid stack (Queue/Cache/Cable), deployed with Kamal. See [DESIGN.md](DESIGN.md) for the full tech stack.

```sh
git clone https://github.com/rubyforgood/endsideout.git
cd endsideout
bundle install
bin/rails db:prepare   # create, load schema, seed sample data
bin/dev                # http://localhost:3000
```

Seed data is generated with [Faker](https://github.com/faker-ruby/faker); see `db/seeds.rb` for login credentials.