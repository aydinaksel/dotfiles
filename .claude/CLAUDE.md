@conventions/rust-structured-logging.md

# Naming Conventions

1. Don't name things with a single letter.
2. Never abbreviate.
3. Don't put types in the names — the type system handles that. Use type annotations where the language supports them (Go, Rust, TypeScript, Python type hints, etc.).
4. Include units in the name. For example, instead of `delay` use `delaySeconds`.

**Exception:** `err` is allowed in Go since `error` shadows the built-in type.

5. Don't name modules or classes `utils`, `helpers`, or similar — reorganize the code into modules with descriptive names instead.
6. Don't prefix class names with `Base` or `Abstract` — rename the child class to be more specific instead. The parent class should hold the general name.

These rules apply to SQL as well:

- No single-letter table aliases (`f`, `l`, `v`). Use the full table name or a full descriptive
  alias (e.g. `home_team`, `away_team`).
- No abbreviated aliases (`ht`, `awt`).
- Only qualify a column with its table name when there is genuine ambiguity — i.e. the same
  column name appears in more than one joined table. Do not prefix every column by default.

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

If you need more than 3 levels of indentation, you're screwed anyway, and you should fix your program.

# Writing Style

- Never use em dashes. Use periods or commas instead, or restructure the sentence.

# Prettify

- Follow the [Google Markdown style guide](https://google.github.io/styleguide/docguide/style.html) when editing this and other Markdown files.

# Leptos (Rust)

Leptos 0.7+ (Tachys renderer) types views as deeply nested tuples like
`HtmlElement<Div, Attrs, (Child1, Child2, ...)>` so rendering can be
zero-cost. The flip side is that nontrivial view trees blow rustc's
default `recursion_limit` and query depth limit (both 128) during release
monomorphization, even when `cargo check` passes. The fix is `AnyView`
type erasure via `.into_any()`, not bumping `recursion_limit`.

- Every `#[component]` whose body contains a `<For>`, conditional
  `move || if/else`, deeply nested children, or more than a couple of
  child elements should end with `.into_any()` so the parent only sees
  `AnyView`. Leaf components with one or two simple elements do not
  need it.
- Each arm of a conditional `move || if/else` (or `match`) that
  produces different concrete view types must call `.into_any()` per
  arm. The compiler error here is usually obvious; the release-build
  query-depth blow-up is not.
- Do not raise `recursion_limit` as the primary fix. It just delays the
  next blow-up as the view tree grows. Treat any temptation to raise it
  as a signal to add `.into_any()` at the right component boundary.
- The runtime cost of `AnyView` is one boxed `dyn` per erasure, which
  is negligible in practice and is the intended escape hatch per the
  Leptos book.
