# Learning Dashboard

## Overview
A robust, offline-first mobile application built with Flutter following Clean Architecture principles. It demonstrates dynamic state management, local data caching, and separation of concerns using industry-standard design patterns.

## Tech Stack
- **Flutter** & **Dart**
- **BLoC** (`flutter_bloc`) for State Management
- **Clean Architecture** (Feature-first)
- **GetIt** for Dependency Injection
- **SharedPreferences** for Offline Persistence
- **Mocktail** & **bloc_test** for Testing

## Features
- **Mock Login**: Form validation, simulated network latency, error handling, and loading states.
- **Course Dashboard**: Fetches and lists courses from a mock remote JSON API.
- **Course Details**: Displays dynamic progress, course metadata, and a list of lessons.
- **Lesson Completion**: Users can mark lessons as complete, which instantly updates the overall course progress.
- **Offline Cache**: Data is cached locally on fetch. If the network goes offline, the app seamlessly falls back to the local cache. Lesson completions are persisted offline.
- **Error Handling**: Graceful failure management utilizing functional `Result`/`Failure` abstractions.
- **Comprehensive Testing**: Contains 49 passing tests spanning unit, widget, and BLoC environments.

## Architecture
```text
Presentation (Widgets + BLoC)
    ↓
Domain (UseCases + Entities)
    ↓
Data (Repositories + Models)
    ↓
Remote / Local Data Sources
```
- **Presentation**: Handles UI and maps user events to state transitions.
- **Domain**: Contains pure business logic and entity invariants (e.g., Progress calculation). Completely decoupled from Flutter.
- **Data**: Orchestrates data flow, maps models to entities, and implements repository contracts.
- **Data Sources**: Interacts with external services (APIs, Local DBs).

## Offline Strategy
The application follows a remote-first, cache-fallback strategy:
```text
Remote success
      ↓
Cache locally
      ↓
Return data

Remote failure
      ↓
Read local cache
      ↓
Return cached data
```
`SharedPreferences` is used for caching as the assignment requires simple local persistence without heavyweight database engines.

## Authentication
Authentication is currently mocked for the purposes of the assignment. 
In a production environment:
- The mock data source would be replaced with an actual API endpoint (e.g., via `Dio`).
- The authentication token would be securely stored using platform-backed keystores (e.g., `flutter_secure_storage`) rather than simple SharedPreferences.

## Production Considerations
- **Secure Token Storage**: Switch to `flutter_secure_storage`.
- **Real API Integration**: Implement Retrofit/Dio for type-safe API requests.
- **Pagination**: Implement cursor/offset pagination in `GetCoursesUseCase` as the course list scales.
- **Scalable Database**: Migrate the `LocalStorage` underlying implementation to a robust relational/NoSQL solution like `Drift` (SQLite) or `Isar` if offline data volume grows significantly.

## Testing
The project maintains robust test coverage with **49 tests** all passing. Tests encompass offline repository fallbacks, entity calculations, BLoC state mutations, and UI widgets.

## Demo Credentials
Use the following credentials to bypass the mock login:
**Email:** `demo@example.com`  
**Password:** `password123`

## Running the Project
```bash
flutter pub get
flutter run
```

## Build
To build the release APK for Android:
```bash
flutter build apk --release
```

## AI Usage Statement
AI tools were utilized during development to rapidly scaffold boilerplate, generate tests, and brainstorm architectural patterns. However, the entire codebase was manually reviewed, modified, tested, and validated to ensure strict compliance with Clean Architecture and SOLID principles. The developer fully understands, owns, and can defend every line of implementation.
