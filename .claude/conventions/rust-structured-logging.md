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
