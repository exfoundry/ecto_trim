# Changelog

## [1.0.2] - 2026-06-12

### Changed
- Repository moved to https://github.com/saschabrink/ecto_trim — package
  metadata, docs links, and license now reflect the maintainer's real name.
- CI tests against Elixir 1.19 and 1.20 via the Nix flake dev shells.
- README badges for Hex version, docs, CI status, and license.

## [1.0.1] - 2026-04-18

### Added
- `usage-rules.md` — ships with the hex package so tools like `usage_rules`
  and memex `deps` sources can surface it to AI agents.

## [1.0.0] - 2026-04-13

### Added
- `EctoTrim` parameterized type with `:single_line` and `:multi_line` modes
- Whitespace trimming and normalization on `cast` and `dump`
- Passthrough on `load` (data is already normalized)
