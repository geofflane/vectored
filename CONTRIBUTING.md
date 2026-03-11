# Contributing to Vectored

Thanks for your interest in contributing! Here's how to get started.

## Getting Started

1. [Fork the repo](https://github.com/geofflane/vectored/fork) and clone your fork
2. Create a feature branch: `git checkout -b my-feature`
3. Install dependencies: `mix deps.get`

## Development

Run the test suite:

```bash
mix test
```

Before submitting, please make sure your code passes:

```bash
mix format --check-formatted
mix credo --strict
mix dialyzer
```

## Submitting Changes

1. Commit your changes with a clear message
2. Push to your fork: `git push origin my-feature`
3. [Open a pull request](https://github.com/geofflane/vectored/compare) against `main`

Please include:

- A description of what changed and why
- Tests for new functionality
- Updated documentation if applicable

## Code Style

This project uses `mix format` for consistent formatting. The `.formatter.exs` file in the repo root defines the rules.

## Questions?

Open an issue — happy to help!
