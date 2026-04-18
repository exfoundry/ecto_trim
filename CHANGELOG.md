# Changelog

## [1.0.1] - 2026-04-18

### Added
- `usage-rules.md` — ships with the hex package so tools like `usage_rules`
  and memex `deps` sources can surface it to AI agents.

## [1.0.0] - 2026-04-13

### Added
- `EctoTrim` parameterized type with `:single_line` and `:multi_line` modes
- Whitespace trimming and normalization on `cast` and `dump`
- Passthrough on `load` (data is already normalized)
