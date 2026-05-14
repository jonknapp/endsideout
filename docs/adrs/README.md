# Architecture Decision Records (ADRs) 

## Purpose
ADRs are a way to document the architectural decisions made during the development of a software project. 
They provide a clear and concise record of the reasoning behind each decision, making it easier for future developers to understand the context and rationale behind the choices made.
A good ADR provides a clear "why" regarding a decision around the architecture of the system, especially when the decision is not obvious.


## Creating a New ADR

Use the built-in Rails generator to create a new ADR with the correct filename and template pre-filled:

```sh
bin/rails generate adr <title_in_snake_case>
```

For example:

```sh
bin/rails generate adr use_postgres_as_primary_database
```

This will create `docs/adrs/0001_use_postgres_as_primary_database.md` with today's date and all required sections. The number is assigned automatically based on existing ADRs. The title is normalized to snake_case regardless of how it's provided — kebab-case, CamelCase, and spaces all work.

## Format
Each ADR should follow a consistent format to ensure clarity and ease of understanding. A common format includes the following sections:
1. **Title**: A brief and descriptive title for the decision.
2. **Context**: A description of the problem or situation that led to the need for a decision.
3. **Authors**: The name of the person(s) or team responsible for making the decision.
4. **Decision**: A clear statement of the decision that was made.
5. **Consequences**: An explanation of the consequences of the decision, including any trade-offs or implications.