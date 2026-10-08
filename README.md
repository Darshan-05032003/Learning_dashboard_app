# Learning Dashboard Application

A highly robust, offline-first mobile application built with Flutter following Clean Architecture principles and SOLID design patterns. 

This repository was created as a submission for the **Senior Mobile App Developer – Technical Assignment**.

## 📱 Features
- **Authentication**: A mock login flow demonstrating form validation and state handling.
- **Course Dashboard**: Fetches and displays a list of courses from a mock remote JSON.
- **Course Details**: Displays in-depth course information and a paginated/scrollable list of lessons.
- **Lesson Completion**: Allows marking lessons as completed, automatically calculating and updating course progress.
- **Offline-First Architecture**: 
  - On launch, the app attempts to fetch data from the remote source. 
  - Successful remote fetches update a local SharedPreferences-based cache.
  - If the network fails (offline), the app gracefully falls back to the cache, allowing the user to view courses and complete lessons uninterrupted.
  - Lesson completions update both the domain models and the local cache in real-time.

## 🏗️ Architecture & Stack
This project enforces a strict separation of concerns using **Feature-first Clean Architecture**:

- **Presentation Layer**: UI (Widgets & Pages) + State Management (BLoC / `flutter_bloc`).
- **Domain Layer**: Core Business Logic (Entities & Use Cases) + Repository Interfaces. Independent of any external packages.
- **Data Layer**: Data Transfer Objects (Models) + Data Sources (Remote/Local) + Repository Implementations. Maps models to pure domain entities.
- **Core Layer**: Shared utilities, error handling (Failure & Result abstractions), Dependency Injection (`get_it`), Local Storage, and Network Info.

**Key Tools:**
- **State Management**: `flutter_bloc`, `equatable`
- **Dependency Injection**: `get_it`
- **Routing**: Flutter native `Navigator 2.0` (via `MaterialPageRoute`)
- **Persistence**: `shared_preferences`
- **Testing**: `flutter_test`, `bloc_test`, `mocktail`

## 🛠️ Testing Strategy
The application features a robust test suite covering Domain, Data, Presentation, and Utility layers.
- **Unit Tests**: Mocked dependencies using `mocktail` for BLoCs, UseCases, Repositories, and DataSources.
- **Widget Tests**: Pumped widget structures checking for specific interactions (e.g., dispatching events on tap, validating login forms).
- **Coverage**: Over **49 passing tests** ensuring the app's offline caching, network fallback, and state mutation are completely predictable.

Run tests using:
```bash
flutter test
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.24.x or higher)
- Dart SDK (3.5.x or higher)

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run code generation (if applicable) / Analyze code:
   ```bash
   flutter analyze
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## 📂 Project Structure
```
lib/
├── core/
│   ├── constants/
│   ├── di/                 # Dependency injection setup
│   ├── error/              # Failure and Exception abstractions
│   ├── network/            # Network connectivity abstractions
│   ├── storage/            # Local storage abstractions
│   ├── theme/              # Material 3 global app theme
│   └── usecase/            # Base use case interface
├── features/
│   ├── auth/               # Authentication Feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── courses/            # Courses & Lessons Feature
│       ├── data/           
│       │   ├── datasources/# Remote (JSON) & Local (Cache)
│       │   ├── models/     # DTOs
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/   # Course, Lesson
│       │   ├── repositories/
│       │   └── usecases/   # GetCoursesUseCase, CompleteLessonUseCase
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── main.dart
```

## 🧠 Key Design Decisions
1. **Result/Failure Pattern**: Inspired by functional programming (Either/Result), the app handles errors explicitly via a `Result<T>` wrapper, avoiding unexpected exceptions propagating to the UI.
2. **Immutable Domain Entities**: Entities like `Course` compute their own `progress` based on their `lessonItems`, preventing bugs where cached progress might desync from actual lesson completion states.
3. **Local Storage Abstraction**: `SharedPreferences` is wrapped in a `LocalStorage` interface. This allows us to easily swap the underlying database (e.g., to Hive or SQLite) in the future without touching the repositories.

## 📝 Documentation Notes
You can find step-by-step implementation notes in the `doc/` directory, detailing the sequential rollout of features, BLoCs, and testing setups.
