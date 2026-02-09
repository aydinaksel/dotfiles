# Naming Conventions

1. Don't name things with a single letter.
2. Never abbreviate.
3. Don't put types in the names — the type system handles that. Use type annotations where the language supports them (Go, Rust, TypeScript, Python type hints, etc.).
4. Include units in the name. For example, instead of `delay` use `delaySeconds`.

**Exception:** `err` is allowed in Go since `error` shadows the built-in type.
