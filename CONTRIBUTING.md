# Contributing to DevUtils

Thank you for your interest in contributing to DevUtils!

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Making Changes](#making-changes)
- [Style Guidelines](#style-guidelines)
- [Testing](#testing)
- [Pull Request Process](#pull-request-process)
- [Questions?](#questions)

## Code of Conduct

This project is governed by the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). By participating, you are expected to uphold this code.

## Getting Started

1. **Open an Issue** — Before submitting a Pull Request, please open a corresponding issue to discuss your proposed changes.
2. **Fork the repository** on GitHub.
3. **Clone your fork** to your local machine.
4. **Create a new branch** — Use a descriptive name like `feat/regex-tester` or `fix/json-formatting`.

## Development Setup

### Prerequisites

- **Flutter** (stable channel) — [Install](https://docs.flutter.dev/get-started/install)
- **Dart** (bundled with Flutter)

### Setup

```bash
# Get dependencies
flutter pub get

# Run code generation (if you changed DI)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Project Structure

```
lib/
  core/
    router/       — GoRouter configuration
    theme/        — Theme, colors, design tokens
    models/       — Shared data models
    constants/    — App-wide constants
  features/
    <feature>/    — Each tool is a feature, containing:
      bloc/       — BLoC events, states, and logic
      pages/      — UI screen
      services/   — Business logic (pure Dart)
      widgets/    — Reusable widgets for this feature
  di/             — Dependency injection (GetIt + Injectable)
```

Currently implemented tools: JSON Formatter, Timestamp Converter, JWT Decoder, API Tester. Implemented features follow the same BLoC + Service pattern — use `features/json_formatter/` as a reference.

## Making Changes

### What to Work On

Check [open issues](https://github.com/ishaan-jindal/DevUtils-Flutter/issues) for `good first issue` or `help wanted` labels. Good places to start:
- Implement a "coming soon" tool (Regex Tester, Base64, etc.)
- Add tests for existing services
- Improve the UI/UX of an existing tool

### Commit Messages

Write clear, concise commit messages:

```
feat: implement regex tester with live matching
fix: handle malformed JSON in formatter service
refactor: extract shared widget for tool output area
```

## Style Guidelines

- Run `flutter analyze` and fix all warnings before committing.
- Follow the [Flutter style guide](https://docs.flutter.dev/style-guide).
- Use `snake_case` for file and directory names.
- Use `lowerCamelCase` for variables and methods.
- Use `UpperCamelCase` for types and classes.
- Keep widgets focused — extract reusable widgets when a build method exceeds ~100 lines.
- Prefer `const` constructors where possible.

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

We welcome unit tests for service classes — these are pure Dart and easy to test without widget infrastructure.

## Pull Request Process

1. Ensure your code passes `flutter analyze` with no warnings.
2. Run `flutter test` and ensure all tests pass. Add tests for new functionality.
3. Reference the issue number in your PR description (e.g., `Fixes #123`).
4. Provide a clear, concise description of your changes.
5. Wait for feedback and address any requested changes.

## Questions?

Open a [discussion](https://github.com/ishaan-jindal/DevUtils-Flutter/discussions) or ask in the issue you're working on.
