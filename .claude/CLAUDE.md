# Naming Conventions

1. Don't name things with a single letter.
2. Never abbreviate.
3. Don't put types in the names — the type system handles that. Use type annotations where the language supports them (Go, Rust, TypeScript, Python type hints, etc.).
4. Include units in the name. For example, instead of `delay` use `delaySeconds`.

**Exception:** `err` is allowed in Go since `error` shadows the built-in type.

5. Don't name modules or classes `utils`, `helpers`, or similar — reorganize the code into modules with descriptive names instead.
6. Don't prefix class names with `Base` or `Abstract` — rename the child class to be more specific instead. The parent class should hold the general name.
