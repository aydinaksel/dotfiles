# Naming Conventions

1. Don't name things with a single letter.
2. Never abbreviate.
3. Don't put types in the names — the type system handles that. Use type annotations where the language supports them (Go, Rust, TypeScript, Python type hints, etc.).
4. Include units in the name. For example, instead of `delay` use `delaySeconds`.

**Exception:** `err` is allowed in Go since `error` shadows the built-in type.

5. Don't name modules or classes `utils`, `helpers`, or similar — reorganize the code into modules with descriptive names instead.
6. Don't prefix class names with `Base` or `Abstract` — rename the child class to be more specific instead. The parent class should hold the general name.

# Comments

Avoid comments. If you feel the need to write one, first try to make the code self-documenting:

- Extract magic values into named constants.
- Name variables and functions to express intent, so the code reads like the comment would.
- Move complex conditions into named functions or variables.
- Use types to encode constraints instead of describing them in comments (e.g. `optional<T>` instead of a `-1` convention).

Comments are acceptable in narrow cases:
- Non-obvious code written for performance reasons — explain *why* it looks weird.
- References to a specific algorithm or mathematical principle — link to the source.

Write documentation for public APIs and high-level architecture, not implementation internals. Keep documentation close to the code using tools like Doxygen, pydoc, or JavaDoc.

# Never Nester

If you need more than 3 levels of indentation, you're screwed anyway, and you
should fix your program.
