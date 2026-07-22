# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.0] - 2026-07-22

### Changed

- Rendered attributes are now emitted in a stable alphabetical order, with `data-*`
  attributes last. Generated SVG is semantically identical, but attribute order differs
  from previous releases, so committed or snapshot-tested output will show a diff.
- `Rectangle.new/4`, `Image.new/5`, `Image.at_location/3`, `Circle.at_location/3`, and
  `Marker.size/3` now accept `<length-percentage>` strings such as `"50%"` or `"2em"` in
  addition to numbers. This matches the struct types and what the renderer already
  supported; only the specs were too narrow.
- Narrowed `path_length` to `number() | nil` on `Rectangle`, `Path`, `Polygon`, and
  `Polyline`. SVG defines `pathLength` as a `<number>`; the attribute had accumulated
  three different spellings across the library, and `Circle` and `Ellipse` were already
  correct.

### Fixed

- Several typespecs declared a field as non-nilable while the struct defaulted it to
  `nil`: `Text.content`, `Tspan.content`, `Use.href`, and `Rectangle.x` / `Rectangle.y`.
- `Marker.marker_units` was typed `number()`. It is the enum `"strokeWidth"` /
  `"userSpaceOnUse"`, now `String.t() | nil`.
- `rotate` on `Text` and `Tspan` was typed `String.t()`. SVG allows a list of numbers, so
  a bare number is valid; now `String.t() | number() | nil`.

## [0.4.0] - 2026-06-02

### Added

- New elements: `ClipPath`, `Ellipse`, `Image`, `LinearGradient`, `Mask`, `Pattern`, `RadialGradient`, `Stop`, `Symbol`, and `Tspan`
- Common element attributes shared across elements
- Credo for static analysis
- Community standards docs (code of conduct, contributing guide, issue and pull request templates)
- Hex badges and a documentation section in the README

### Changed

- Improved documentation across all elements, including a kitchen-sink integration example
- Updated dependencies (including `ex_doc`)
- Updated `mix.exs` for Hex publishing

### Fixed

- Path rendering bugs
- Updating a circle's radius
- `map_join` optimization warnings
- Module doc example, installation reference, and assorted typos

## [0.3.4] - 2025-09-22

### Added

- Support for custom data attributes

### Changed

- Updated dependencies
- Code formatting pass

## [0.3.3] - 2025-09-08

### Added

- Private data map on SVG struct (using `private` to avoid confusion with SVG meta tag)
- CI test runner with badge

### Changed

- Allow `Text.new/0` without requiring x/y coordinates

## [0.3.2] - 2024-07-22

### Fixed

- Allow `Use` to take a title and other common children ([#2](https://github.com/geofflane/vectored/issues/2))

## [0.3.1] - 2024-07-18

### Fixed

- Rectangle rendering

## [0.3.0] - 2024-06-21

### Added

- Polygon support

## [0.2.0] - 2024-06-20

### Added

- Common elements: title, desc, and better defs handling
- Basic transform support
- Macro-generated common attributes and setter functions for every property
- Documentation, specs, and typespecs
- License info in README

### Fixed

- Element casing
- Size handling

## [0.1.0] - 2024-06-18

### Added

- Initial release
- Core SVG struct and rendering
- Basic elements: circle, rect, line, ellipse, text, image
- Path support with builder API
- Polyline support
- Markers
- Defs and Use elements
- xmlns handling

[Unreleased]: https://github.com/geofflane/vectored/compare/0.4.0...HEAD
[0.4.0]: https://github.com/geofflane/vectored/compare/0.3.4...0.4.0
[0.3.4]: https://github.com/geofflane/vectored/compare/0.3.3...0.3.4
[0.3.3]: https://github.com/geofflane/vectored/compare/0.3.2...0.3.3
[0.3.2]: https://github.com/geofflane/vectored/compare/0.3.1...0.3.2
[0.3.1]: https://github.com/geofflane/vectored/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/geofflane/vectored/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/geofflane/vectored/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/geofflane/vectored/releases/tag/0.1.0
