{ pkgs, lib, ... }:
let
  settings = {
    env = {
      CLAUDE_CODE_ENABLE_TELEMETRY = "0";
    };
    permissions = {
      allow = [
        "Read(~/*)"
        "Bash(git -C * status)"
        "Bash(git -C * diff)"
        "Bash(git -C * diff --stat)"
        "Bash(git add *)"
        "Bash(git commit -m ' *)"
        "Bash(gh search *)"
        "Bash(gh pr list *)"
        "Bash(gh pr diff *)"
        "Bash(gh run list *)"
        "Bash(grep *)"
        "Bash(cargo check *)"
        "Bash(cargo search:*)"
        "Bash(cargo clippy *)"
        "Bash(cargo build *)"
        ''Bash(docker exec postgres psql -U admin -d demeter -c "SELECT *)''
        "Bash(docker exec postgres psql -U admin -d demeter -c 'SELECT *)"
        "WebSearch"
        "WebFetch(domain:crates.io)"
        "WebFetch(domain:docs.rs)"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:raw.githubusercontent.com)"
        "WebFetch(domain:fly.io)"
        "WebFetch(domain:book.leptos.dev)"
        "WebFetch(domain:davidchipperfield.com)"
        "WebFetch(domain:api.quickfile.co.uk)"
        "WebFetch(domain:kemset.com)"
        "WebFetch(domain:obsidian.md)"
        "WebFetch(domain:help.obsidian.md)"
      ];
      deny = [
        "Read(./.env)"
        "Read(./.env.*)"
        "Read(~/.secrets/*)"
        "Bash(cat ~/.secrets/*)"
        "Bash(cat /home/aydin/.secrets/*)"
      ];
      ask = [
        "Bash(curl *)"
      ];
    };
    model = "claude-opus-4-8";
    statusLine = {
      type = "command";
      command = "bash ${../statusline.sh}";
    };
    spinnerTipsEnabled = false;
    servers = { };
    effortLevel = "medium";
    remoteControlAtStartup = false;
    prefersReducedMotion = true;
    theme = "dark";
  };

  settingsFile = (pkgs.formats.json { }).generate "claude-code-settings.json" (
    settings // { "$schema" = "https://json.schemastore.org/claude-code-settings.json"; }
  );
in
{
  programs.claude-code = {
    enable = true;

    context = ''
      @rules/rust-structured-logging.md

      # Running Commands

      Use `nix` when running commands as the host machine likely doesn't have what you need
      installed. For example, I don't have `cargo` installed globally, you will need to run it
      with `nix`.

      # Dotfiles

      Zeus is a NixOS machine; hades and poseidon are Home-Manager-only.
      Dotfiles live in `~/dotfiles` (or `~/Projects/dotfiles`). Config under `~/.config/`
      and `~/.claude/` are read-only symlinks to the Nix store; edit the source in dotfiles
      and rebuild. On zeus: `sudo nixos-rebuild switch --flake ~/dotfiles#zeus`.
      On hades/poseidon: `home-manager switch --flake ~/dotfiles`.

      # Naming Conventions

      1. Don't name things with a single letter.
      2. Never abbreviate.
      3. Don't put types in the names, the type system handles that. Use type annotations where the language supports them (Go, Rust, TypeScript, Python type hints, etc.).
      4. Include units in the name. For example, instead of `delay` use `delaySeconds`.

      **Exception:** `err` is allowed in Go since `error` shadows the built-in type.

      5. Don't name modules or classes `utils`, `helpers`, or similar, reorganize the code into modules with descriptive names instead.
      6. Don't prefix class names with `Base` or `Abstract`, rename the child class to be more specific instead. The parent class should hold the general name.

      These rules apply to SQL as well:

      - No single-letter table aliases (`f`, `l`, `v`). Use the full table name or a full descriptive
        alias (e.g. `home_team`, `away_team`).
      - No abbreviated aliases (`ht`, `awt`).
      - Only qualify a column with its table name when there is genuine ambiguity, i.e. the same
        column name appears in more than one joined table. Do not prefix every column by default.

      # Comments

      Do not write comments. This is a hard default, not a preference. The
      overwhelming majority of code should ship with zero comments. Do not
      narrate what the code does, restate a name, or explain a decision that the
      diff or commit message already carries. When you feel the urge to comment,
      that urge is a signal to fix the code instead:

      - Extract magic values into named constants.
      - Name variables and functions to express intent, so the code reads like the comment would.
      - Move complex conditions into named functions or variables.
      - Use types to encode constraints instead of describing them in comments (e.g. `optional<T>` instead of a `-1` convention).

      A comment is justified only when it is genuinely impossible to encode the
      information in the code itself, and its absence would mislead the next
      reader. That is rare. When in doubt, leave it out. The narrow exceptions:

      - Non-obvious code written for performance reasons, explain *why* it looks weird.
      - References to a specific algorithm or mathematical principle, link to the source.

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
    '';

    rules = {
      rust-structured-logging = ''
        # Rust Structured Logging

        Use structured events with named properties and message templates following
        the [message templates](https://messagetemplates.org/) specification.

        Use the `tracing` crate's `event!` macro. Never use the convenience macros
        (`tracing::info!`, `tracing::warn!`, `tracing::error!`, etc.) because they
        have a parsing ambiguity with dotted field names like `error.message` or
        `file.path`, causing "local ambiguity when calling macro" build failures.

        ## Avoid String Formatting

        String formatting allocates memory at runtime. Message templates defer formatting
        until viewing time. The message template should include all named properties for
        easier inspection at viewing time.

        ```rust,ignore
        // Bad
        tracing::info!("file opened: {}", path);

        // Good
        event!(
            name: "file.open.success",
            Level::INFO,
            file.path = path.display(),
            "file opened: {{file.path}}",
        );
        ```

        Use the `{{property}}` syntax in message templates which preserves the literal
        text while escaping Rust's format syntax.

        ## Name Your Events

        Use hierarchical dot-notation: `<component>.<operation>.<state>`

        ```rust,ignore
        event!(
            name: "file.processing.success",
            Level::INFO,
            file.path = file_path,
            "file {{file.path}} processed successfully",
        );
        ```

        ## Follow OpenTelemetry Semantic Conventions

        Use [OTel semantic conventions](https://opentelemetry.io/docs/specs/semconv/)
        for common attributes:

        - HTTP: `http.request.method`, `http.response.status_code`, `url.path`, `server.address`
        - File: `file.path`, `file.directory`, `file.name`, `file.size`
        - Database: `db.system.name`, `db.namespace`, `db.operation.name`
        - Errors: `error.type`, `error.message`

        ## Redact Sensitive Data

        Never log plain sensitive data (emails, tokens, session IDs, PII).
      '';
    };

    skills = {
      rust-guidelines = ../.claude/skills/rust-guidelines;
    };
  };

  home.activation.claudeCodeWritableSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "$HOME/.claude"
    run rm -f "$HOME/.claude/settings.json"
    run install -m600 ${settingsFile} "$HOME/.claude/settings.json"
  '';
}
