# Garden Planner

A Flutter to-do app for managing your gardening tasks. Built with clean architecture, BLoC state management, and local data persistence. Works on both iOS and Android.

## Features

### Task Management
- Create and edit tasks with form validations
- Toggle completion status with visual indicators
- Swipe-to-delete with confirmation

### Task List
- Infinite scroll pagination (10 items per page) 
- Search tasks by name and description
- Filter tasks by completion status
- Sort tasks by creation date, alphabetically, and completion status
- Task count display 

### User Experience
- Persistent data storage that lives across app relaunches
- Indicators for loading, empty and error states
- Material Design 3 styling

## Architecture

The app follows Clean Architecture principles with clear separation of concerns:

```
lib/
├── presentation/     # UI layer (BLoC, pages, widgets)
├── domain/           # Business logic (entities, use cases, repositories)
├── data/             # Data layer (repositories, data sources, models)
└── core/             # Shared utilities (DI, mock data)
```

## Setup

### Prerequisites
- Flutter SDK 3.9.2 or higher

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd garden_planner
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

The app includes mock data that will be automatically loaded on first launch.

## Libraries Used

- `flutter_bloc` - State management (BLoC pattern)
- `hive` / `hive_flutter` - Local NoSQL database for data persistence
- `get_it` - Dependency injection
- `freezed` - Immutable classes with code generation
- `build_runner` - Code generation tool

## Technical Decisions

- **BLoC over Cubit**: Better separation between events and states, making the app more scalable
- **Hive over SharedPreferences**: Better for structured objects like Task entities.
- **Clean Architecture**: Enforces separation of concerns and makes the codebase maintainable and testable
- **Infinite Scroll**: Automatic data loading as the user scrolls, providing a better experience than page navigation buttons
- **Freezed**: Reduces boilerplate and ensures immutability
