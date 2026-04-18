# ecto_trim usage rules

Rules apply to `ecto_trim ~> 1.0`.

Ecto parameterized type that trims and normalizes whitespace on `cast` and
`dump`. Use it as the field type — no manual `String.trim/1` in changesets.

## Minimal pattern

```elixir
schema "companies" do
  field :name, EctoTrim                    # for text inputs (default)
  field :bio,  EctoTrim, mode: :multi_line # for textareas
end
```

No changeset changes needed — `cast/3` sees the normalized value.

## Modes

- **`:single_line`** (default) — trims leading/trailing whitespace, then
  collapses ALL internal whitespace (including newlines) to single spaces.
  For names, titles, slugs, single-line inputs.
- **`:multi_line`** — trims leading/trailing whitespace, then collapses
  3+ consecutive newlines to 2. Paragraph breaks preserved.
  For body / description / any textarea-backed field.

```elixir
# :single_line
cast(%Company{}, %{name: "  Acme   Corp  "}, [:name]).changes.name
#=> "Acme Corp"

# :multi_line
cast(%Company{}, %{bio: "Para 1\n\n\n\nPara 2"}, [:bio]).changes.bio
#=> "Para 1\n\nPara 2"
```

## Do

- **Use `EctoTrim` for every user-facing text field** — any field whose
  value comes from a form, API payload, or pasted input.
- **Use `mode: :multi_line` for textareas.** The default `:single_line`
  destroys paragraph breaks silently — it collapses `\n` to space.
- **Trust the normalization to happen on cast AND dump.** You never need
  to call `String.trim/1` yourself on these fields.

## Don't

- **Don't use plain `:string`** for user-facing text. The bug shows up
  months later when someone pastes `"Acme \u00A0 Corp"` with trailing
  whitespace or extra spaces that silently break search, slugs, and
  equality checks.
- **Don't use `:single_line` on fields that need newlines** (addresses,
  bios, descriptions). Pick `:multi_line` the moment the UI has a
  `<textarea>`.
- **Don't add a separate `String.trim/1`** in your changeset — it's
  already trimmed, and a second pass won't hurt but signals confusion
  about where normalization lives.
- **Don't migrate existing dirty data via EctoTrim alone.** `load/3` is a
  pass-through — data already in the DB stays as-is until the next write.
  Backfill with a one-off `Repo.update_all` + changeset if cleanup matters.

## Configuration

None. `:mode` is the only option. Invalid modes raise `ArgumentError` at
schema compile time — not at runtime.

## Testing

No need to test `EctoTrim` itself (covered upstream). Test your own
fields only when the mode choice is non-obvious, e.g. to pin `:multi_line`
on a body field so a future edit doesn't silently regress to single-line:

```elixir
test ":bio preserves paragraph breaks" do
  cs = cast(%Article{}, %{bio: "a\n\nb"}, [:bio])
  assert cs.changes.bio == "a\n\nb"
end
```
