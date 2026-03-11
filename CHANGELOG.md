# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Added Credo and fixed map_join optimization warnings
- Documentation improvements and typo fixes
- Updated mix.exs for Hex publishing

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

[Unreleased]: https://github.com/geofflane/vectored/compare/0.3.4...HEAD
[0.3.4]: https://github.com/geofflane/vectored/compare/0.3.3...0.3.4
[0.3.3]: https://github.com/geofflane/vectored/compare/0.3.2...0.3.3
[0.3.2]: https://github.com/geofflane/vectored/compare/0.3.1...0.3.2
[0.3.1]: https://github.com/geofflane/vectored/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/geofflane/vectored/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/geofflane/vectored/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/geofflane/vectored/releases/tag/0.1.0
