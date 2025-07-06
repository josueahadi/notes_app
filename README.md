# Flutter Notes App

Notes application built with Flutter and Firebase.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## Features

- **Secure Authentication** - Email/password login with Firebase Auth
- **Real-time Data Sync** - Cloud Firestore integration
- **Full CRUD Operations** - Create, Read, Update, Delete notes
- **Clean Architecture** - Separation of concerns with proper layering
- **State Management** - BLoC pattern for predictable state handling
- **User-Friendly UI** - Material Design 3 with intuitive navigation
- **Error Handling** - Comprehensive error management with user feedback
- **Offline Support** - Firestore's built-in offline capabilities
- **Security Rules** - User-specific data access control

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐          │
│  │   Screens   │  │   Widgets   │  │    BLoCs    │          │
│  │             │  │             │  │             │          │
│  │• AuthScreen │  │• NoteItem   │  │• AuthBloc   │          │
│  │• NotesScreen│  │• NoteDialog │  │• NotesBloc  │          │
│  └─────────────┘  └─────────────┘  └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │  Repositories   │              │     Models      │       │
│  │                 │              │                 │       │
│  │• AuthRepository │◄────────────►│• NoteModel      │       │
│  │• NotesRepository│              │                 │       │
│  └─────────────────┘              └─────────────────┘       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
├─────────────────────────────────────────────────────────────┤
│                  ┌─────────────────┐                        │
│                  │    Entities     │                        │
│                  │                 │                        │
│                  │ • Note          │                        │
│                  └─────────────────┘                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   EXTERNAL SERVICES                         │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐              ┌─────────────────┐       │
│  │ Firebase Auth   │              │   Firestore     │       │
│  │                 │              │                 │       │
│  │ • Sign In/Up    │              │ • Notes Storage │       │
│  │ • User Session  │              │ • Real-time Sync│       │
│  └─────────────────┘              └─────────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### Data Flow

```
User Interaction → Widget → BLoC Event → Repository → Firebase
                                    ↓
User Interface ← Widget ← BLoC State ← Repository ← Firebase Response
```

### Project Structure

```
📁lib/
├── main.dart                          # App entry point
├── domain/                            # Business logic layer
│   └── entities/
│       └── note.dart                  # Note entity
├── data/                              # Data access layer
│   ├── models/
│   │   └── note_model.dart           # Firestore data model
│   └── repositories/
│       ├── auth_repository.dart       # Authentication operations
│       └── notes_repository.dart      # Notes CRUD operations
└── presentation/                      # UI layer
    ├── bloc/
    │   ├── auth_bloc.dart            # Authentication state management
    │   └── notes_bloc.dart           # Notes state management
    ├── screens/
    │   ├── auth_screen.dart          # Login/Signup UI
    │   └── notes_screen.dart         # Notes list UI
    └── widgets/
        ├── note_item.dart            # Individual note widget
        └── note_dialog.dart          # Add/Edit note dialog
```

## Getting Started

### Prerequisites

- **Flutter SDK**: >= 3.0.0
- **Dart SDK**: >= 3.0.0
- **Firebase Account**: [Create one here](https://console.firebase.google.com/)
- **IDE**: VS Code, Android Studio, or IntelliJ IDEA

### Installation Steps

#### 1. Clone the Repository

```bash
git clone https://github.com/josueahadi/notes_app.git
cd notes_app
```

#### 2. Install Dependencies

```bash
flutter pub get
```

#### 3. Firebase Setup

##### A. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" or "Create a project"
3. Enter project name (e.g., "Flutter Notes App")
4. Choose whether to enable Google Analytics (optional)
5. Click "Create project"

##### B. Enable Firebase Services

**Enable Authentication:**

1. Navigate to Authentication → Get Started
2. Go to "Sign-in method" tab
3. Enable "Email/Password" provider
4. Click "Save"

**Enable Firestore Database:**

1. Navigate to Firestore Database
2. Click "Create database"
3. Choose "Test mode" (for development)
4. Select a location (e.g., us-central1)
5. Click "Done"

##### C. Add Flutter App to Firebase

**For Android:**

1. Click the Android icon in project overview
2. Enter package name: `com.example.notes_app`
3. Download `google-services.json`
4. Place it in `android/app/` directory

**For iOS:**

1. Click the iOS icon in project overview
2. Enter bundle ID: `com.example.notesApp`
3. Download `GoogleService-Info.plist`
4. Add it to `ios/Runner/` in Xcode

#### 4. Configure Build Files

##### Android Configuration

**android/build.gradle** (project level):

```gradle
buildscript {
    ext.kotlin_version = '1.7.10'
    dependencies {
        classpath 'com.android.tools.build:gradle:7.2.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.3.15'  // Add this line
    }
}
```

**android/app/build.gradle**:

```gradle
apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply plugin: 'com.google.gms.google-services'  // Add this line

android {
    compileSdkVersion 33

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 33
        multiDexEnabled true  // Add this if needed
    }
}
```

##### iOS Configuration

1. Open `ios/Runner.xcworkspace` in Xcode
2. Right-click "Runner" → "Add Files to Runner"
3. Select `GoogleService-Info.plist`
4. Ensure it's added to the Runner target

#### 5. Set Up Firestore Security Rules

1. Go to Firestore Database → Rules tab
2. Replace default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

3. Click "Publish"

#### 6. Build and Run

```bash
# Check for any issues
flutter doctor

# Run the app
flutter run

# Build for production
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## Usage

### Authentication Flow

1. **First Launch**: User sees login screen
2. **Sign Up**: New users create account with email/password
3. **Sign In**: Returning users enter credentials
4. **Auto-Login**: App remembers authentication state

### Notes Management

1. **View Notes**: All notes displayed in chronological order
2. **Add Note**: Tap "+" button to create new note
3. **Edit Note**: Tap edit icon to modify existing note
4. **Delete Note**: Tap delete icon with confirmation dialog
5. **Empty State**: Helpful message when no notes exist

### Offline Support

- **Automatic Sync**: Changes sync when connection restored
- **Local Cache**: Notes available offline
- **Conflict Resolution**: Firebase handles data conflicts

## Testing

### Run Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Widget tests
flutter test test/widget_test.dart
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Security Features

### Authentication Security

- **Firebase Auth**: Industry-standard authentication
- **Password Requirements**: Minimum 6 characters
- **Email Validation**: Proper email format checking
- **Session Management**: Secure token handling

### Data Security

- **User Isolation**: Users can only access their own notes
- **Firestore Rules**: Server-side access control
- **HTTPS**: All data transmitted securely
- **No Local Storage**: Sensitive data not stored locally

### Security Rules Explanation

```javascript
// Users can only read/write their own notes
match /users/{userId}/notes/{noteId} {
  allow read, write: if request.auth != null && request.auth.uid == userId;
}
```

## UI/UX Features

### Material Design 3

- **Modern Aesthetics**: Latest Material Design principles
- **Responsive Layout**: Adapts to different screen sizes
- **Accessibility**: Screen reader and keyboard navigation support

### User Feedback

- **Loading States**: Visual feedback during operations
- **Success Messages**: Confirmation of completed actions
- **Error Handling**: Clear error messages with actionable advice
- **Empty States**: Helpful guidance when no content exists

### Navigation

- **Intuitive Flow**: Logical progression through app features
- **Back Navigation**: Consistent back button behavior
- **Deep Linking**: Support for direct navigation to specific screens

## Configuration

### Environment Variables

Create `.env` file for configuration:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
```

### Build Configurations

**Development:**

```bash
flutter run --flavor dev -t lib/main_dev.dart
```

**Production:**

```bash
flutter run --flavor prod -t lib/main_prod.dart
```

## Performance Optimization

### Firestore Optimization

- **Efficient Queries**: Indexed fields for better performance
- **Pagination**: Limit query results for large datasets
- **Offline Persistence**: Enabled by default in Firebase

### Flutter Optimization

- **Widget Rebuilds**: Optimized with BLoC pattern
- **Memory Management**: Proper disposal of resources
- **Bundle Size**: Tree-shaking eliminates unused code

## Deployment

### Android Deployment

```bash
# Build release APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release

# Sign the app (configure signing in android/app/build.gradle)
```

### iOS Deployment

```bash
# Build for iOS
flutter build ios --release

# Archive in Xcode
# Upload to App Store Connect
```

### CI/CD Pipeline

Example GitHub Actions workflow:

```yaml
name: Build and Deploy
on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --release
```

## Contributing

### Development Setup

1. **Fork the repository**
2. **Create feature branch**: `git checkout -b feature/amazing-feature`
3. **Follow coding standards**: Use `flutter analyze` and `dart format`
4. **Write tests**: Maintain test coverage above 80%
5. **Commit changes**: `git commit -m 'Add amazing feature'`
6. **Push to branch**: `git push origin feature/amazing-feature`
7. **Open Pull Request**

### Code Style

- **Dart Style Guide**: Follow official Dart conventions
- **Documentation**: Comment complex logic and public APIs
- **Testing**: Write unit tests for business logic
- **Architecture**: Maintain clean architecture principles

## Troubleshooting

### Common Issues

**Build Errors:**

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

**Firebase Connection Issues:**

- Verify `google-services.json`/`GoogleService-Info.plist` placement
- Check Firebase project configuration
- Ensure internet connectivity

**Authentication Errors:**

- Verify email/password provider is enabled
- Check Firebase Auth settings
- Review security rules

**Firestore Permission Errors:**

- Ensure security rules are published
- Verify user authentication status
- Check rule syntax in Firebase Console

### Debug Commands

```bash
# Check Flutter installation
flutter doctor -v

# View logs
flutter logs

# Debug build
flutter run --debug

# Profile performance
flutter run --profile
```

## License

N/A

## Support

- **Documentation**: [Flutter Docs](https://docs.flutter.dev/)
- **Firebase Help**: [Firebase Docs](https://firebase.google.com/docs)
- **Issues**: [GitHub Issues](https://github.com/yourusername/notes_app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/notes_app/discussions)

---

_Last updated: July 2025_
