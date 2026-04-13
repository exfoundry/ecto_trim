# EctoTrim

Ecto parameterized type that trims and normalizes whitespace on cast and dump.

## Why

Users paste text with extra spaces, trailing whitespace, and long runs of blank lines. EctoTrim normalizes whitespace at the Ecto type level — define the field once, skip the manual `String.trim/1` in every changeset.

## Status

This library is used in several production websites and is considered complete. Updates will only be made for compatibility with new Elixir or Ecto versions.

## Installation

```elixir
def deps do
  [{:ecto_trim, "~> 1.0"}]
end
```

## Usage

```elixir
schema "companies" do
  field :name, EctoTrim                    # for text inputs
  field :bio, EctoTrim, mode: :multi_line  # for textareas
end
```

### Modes

- `:single_line` (default) — trims leading/trailing whitespace and collapses all internal whitespace to single spaces
- `:multi_line` — trims leading/trailing whitespace and collapses 3+ consecutive newlines to 2, preserving paragraph breaks

### Examples

```elixir
# single_line (default)
changeset = cast(%Company{}, %{name: "  Acme   Corp  "}, [:name])
changeset.changes.name
#=> "Acme Corp"

# multi_line
changeset = cast(%Company{}, %{bio: "Line one\n\n\n\nLine two"}, [:bio])
changeset.changes.bio
#=> "Line one\n\nLine two"
```

## License

MIT
