# SPM App Copilot Instructions

This document provides guidance for AI coding agents to effectively contribute to the SPM App codebase.

## Architecture

The SPM App follows a standard Flutter project structure with a clear separation of concerns. The main components are organized as follows:

- **`lib/src/screens`**: Contains all the individual screens of the application, such as `auth`, `home`, `profile`, and `tutorial`. Each screen is responsible for its own UI and state management.
- **`lib/src/shared`**: Includes shared widgets, themes, and utilities that are used across multiple screens. This helps maintain a consistent look and feel throughout the app.
- **`lib/src/core`**: This directory is intended for core business logic, models, and services that are fundamental to the application's functionality.

## Developer Workflow

### Running the App

To run the app, use the standard Flutter command:

```bash
flutter run
```

### Building the App

To create a release build, use the following command:

```bash
flutter build
```

### Testing

While there are no specific tests implemented yet, the project is set up for testing using `flutter_test`. When adding new features, please include corresponding tests.

## Conventions and Patterns

- **Theming**: The app's theme is defined in `lib/src/shared/theme`. When adding new UI components, please use the predefined theme colors and styles to ensure consistency.
- **Utilities**: Shared utility functions are located in `lib/src/shared/utils`. If you need to add a new utility function, please place it in this directory.
- **Assets**: All static assets, such as images and icons, are stored in the `assets` directory. When adding new assets, make sure to update the `pubspec.yaml` file accordingly.

## Dependencies

The project relies on several key dependencies:

- **`flutter_svg`**: Used for rendering SVG images.
- **`font_awesome_flutter`**: Provides a set of icons that can be used throughout the app.
- **`shared_preferences`**: Used for persisting simple data, such as user preferences.

When adding new dependencies, please ensure they are compatible with the existing packages and follow the project's coding standards.
