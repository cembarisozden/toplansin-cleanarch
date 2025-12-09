# 🏟️ Toplansın

> A modern football field reservation & subscription mobile app built with Flutter.

[![Flutter](https://img.shields.io/badge/Flutter-3.10+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.10+-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)
[![Architecture](https://img.shields.io/badge/Architecture-Clean-brightgreen)]()
[![State](https://img.shields.io/badge/State-BLoC-blue)]()

---

## ✨ Features

- 🔍 **Discover** — Find nearby football fields
- 📅 **Book** — Reserve your spot in seconds
- 🔄 **Subscribe** — Manage recurring reservations
- 👥 **Teams** — Create and join teams
- 🔔 **Notifications** — Stay updated with push notifications
- 📊 **Analytics** — Track your activity

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
│
├── core/                     # Shared utilities & configs
│   ├── config/               # Environment & Firebase config
│   ├── constants/            # App-wide constants
│   ├── errors/               # Failures & exceptions
│   ├── extensions/           # Dart extensions
│   ├── network/              # Network utilities
│   ├── router/               # GoRouter configuration
│   ├── theme/                # App theme & colors
│   ├── usecases/             # Base use case class
│   └── utils/                # Logger & helpers
│
├── data/                     # Data Layer
│   ├── datasources/          # Remote & local data sources
│   │   ├── remote/           # API calls (Firebase, etc.)
│   │   └── local/            # Local storage (SharedPrefs, etc.)
│   ├── models/               # DTOs with JSON serialization
│   └── repositories/         # Repository implementations
│
├── domain/                   # Domain Layer (Business Logic)
│   ├── entities/             # Business entities
│   ├── repositories/         # Repository contracts (abstract)
│   └── usecases/             # Application use cases
│
├── presentation/             # Presentation Layer (UI)
│   ├── blocs/                # BLoC state management
│   ├── pages/                # Screen widgets
│   └── widgets/              # Reusable UI components
│
└── injection_container/      # Dependency injection setup
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Framework** | Flutter 3.10+ |
| **Language** | Dart 3.10+ |
| **State Management** | BLoC / Cubit |
| **DI** | GetIt + Injectable |
| **Routing** | GoRouter |
| **Backend** | Firebase |
| **Database** | Cloud Firestore |
| **Authentication** | Firebase Auth |
| **Push Notifications** | Firebase Messaging |
| **Analytics** | Firebase Analytics + BigQuery |
| **Crash Reporting** | Firebase Crashlytics |
| **Code Generation** | Freezed + JSON Serializable |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.10.0`
- Dart SDK `^3.10.0`
- Firebase CLI
- Android Studio / VS Code

### Installation

```bash
# Clone the repository
git clone https://github.com/your-username/toplansin.git
cd toplansin

# Install dependencies
flutter pub get

# Generate code (models, DI, etc.)
dart run build_runner build --delete-conflicting-outputs

# Run the app (development)
flutter run --flavor dev -t lib/main.dart
```

---

## 📦 Build & Release

```bash
# Development APK
flutter build apk --flavor dev -t lib/main.dart

# Production APK
flutter build apk --flavor prod -t lib/main.dart --release

# App Bundle (Play Store)
flutter build appbundle --flavor prod -t lib/main.dart --release
```

---

## 🔥 Firebase Environments

| Environment | Description |
|-------------|-------------|
| `dev` | Development & testing |
| `prod` | Production release |

Each environment uses a separate Firebase project for data isolation.

---

## 📁 Project Structure Overview

```
├── android/          # Android native code
├── ios/              # iOS native code
├── lib/              # Dart source code
├── test/             # Unit & widget tests
├── pubspec.yaml      # Dependencies
└── README.md         # You are here!
```

---

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is proprietary software. All rights reserved.

---

<p align="center">
  Made with ❤️ using Flutter
</p>
