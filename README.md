# Slack Clone - Real-Time Channel Messaging App

A real-time messaging application built with Flutter, featuring Slack-like UI and real-time communication using Firebase Firestore.

## 📱 Project Overview

This is a mobile-first messaging application that demonstrates:
- Real-time messaging with WebSocket-like functionality via Firebase Firestore
- Clean architecture with proper separation of concerns
- State management using BLoC pattern
- Slack-inspired UI/UX design
- All bonus features implemented (typing indicators, message grouping, offline support, dark mode, reactions)

## 🛠 Tech Stack & Versions

- **Flutter**: 3.x
- **Dart SDK**: ^3.9.2
- **State Management**: flutter_bloc ^8.1.6
- **Backend**: Firebase (Firestore, Auth)
  - firebase_core: ^3.8.0
  - cloud_firestore: ^5.5.0
  - firebase_auth: ^5.3.3
- **Local Storage**: shared_preferences ^2.5.3
- **Utilities**:
  - intl: ^0.19.0
  - equatable: ^2.0.7
- **UI**:
  - flutter_svg: ^2.2.0
  - lottie: ^3.3.1

## ⚙️ Setup Instructions (Local)

### Prerequisites

1. Install Flutter SDK (3.x or later)
2. Install Firebase CLI: `npm install -g firebase-tools`
3. Install FlutterFire CLI: `dart pub global activate flutterfire_cli`

### Installation Steps

1. **Clone the repository**
   ```bash
   cd /path/to/project
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**

   **Option A: Use your own Firebase project** (Recommended)
   ```bash
   flutterfire configure --project=your-project-id
   ```
   This will automatically generate `firebase_options.dart` with your credentials.

   **Option B: Use placeholder (for testing structure only)**
   - The project includes `firebase_options.dart` with placeholders
   - Replace with actual values from your Firebase project
   - See `FIREBASE_SETUP.md` for detailed instructions

4. **Set up Firestore**
   - Go to Firebase Console → Firestore Database
   - Create database in test mode
   - Firestore will be automatically populated when you use the app

5. **Enable Authentication**
   - Go to Firebase Console → Authentication
   - Enable Email/Password sign-in method

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔐 Environment Variables

Firebase configuration is stored in `lib/firebase_options.dart`.

**Required Firebase Configuration:**
- API Key
- App ID
- Messaging Sender ID
- Project ID
- Storage Bucket
- Auth Domain

See `FIREBASE_SETUP.md` for complete setup instructions.

## 🏗 Architecture Decisions

### Clean Architecture

The project follows clean architecture principles with three main layers:

```
lib/
├── core/                    # Shared utilities and configurations
│   ├── constants/          # App-wide constants
│   ├── extensions/         # Dart extensions
│   ├── utils/              # Utilities (storage, theme, DI)
│   └── widgets/            # Reusable widgets (if any)
│
├── domain/                  # Business logic layer
│   ├── entities/           # Business entities
│   └── repositories/       # Abstract repository interfaces
│
├── data/                    # Data layer
│   ├── models/             # Data models (DTOs)
│   ├── datasources/        # Data sources (Firebase)
│   └── repositories/       # Repository implementations
│
└── presentation/            # UI layer
    ├── auth/               # Authentication feature
    ├── channels/           # Channel list feature
    ├── chat/               # Chat messaging feature
    └── theme/              # Theme management
```

### Key Design Decisions

1. **BLoC Pattern for State Management**
   - Separation of business logic from UI
   - Reactive programming with streams
   - Easy testing and maintainability

2. **Firebase Firestore for Real-Time**
   - Chosen over WebSocket for ease of use
   - Built-in offline support
   - Real-time listeners for live updates
   - No custom backend required

3. **Dependency Injection**
   - Custom lightweight DI container
   - Lazy loading for better performance
   - Easy mocking for unit tests

4. **Repository Pattern**
   - Abstraction over data sources
   - Easy to switch implementations
   - Testable business logic

## 📋 Features Implemented

### Core Features ✅

- [x] **Authentication & Workspace**
  - Email/password login (or mocked auth)
  - Auto-join default workspace after login

- [x] **Channel List Screen**
  - Display of #general and #random channels
  - Unread message count per channel
  - Active channel highlight

- [x] **Channel Chat Screen**
  - Real-time message stream using Firestore
  - Message bubbles with sender name, timestamp, text
  - Optimistic UI updates when sending
  - Auto-scroll to latest message

- [x] **UI/UX Requirements**
  - Slack-like layout and spacing
  - Keyboard-safe input bar
  - Loading, empty, and error states
  - Smooth message list performance (ListView with efficient rendering)

### Bonus Features (Strong Differentiators) ✅

- [x] **Typing Indicator**
  - Real-time typing status updates
  - Shows "User is typing..." below message list
  - Automatic cleanup after 5 seconds of inactivity

- [x] **Message Grouping by User**
  - Groups consecutive messages from same sender
  - Shows avatar and name only for first message
  - Clean, compact UI for message threads

- [x] **Offline Message Queue**
  - Firestore's built-in offline support
  - Messages stored locally when offline
  - Auto-sync when connection restored
  - Optimistic UI with status indicators (sending/sent/failed)

- [x] **Dark Mode**
  - Full dark theme support
  - Toggle in app bar
  - Persistent across sessions
  - Slack-inspired color scheme

- [x] **Reactions (👍 ❤️)**
  - Long-press message to add reaction
  - Tap reaction to toggle on/off
  - Real-time reaction updates
  - Grouped reaction display with counts

## 🔄 Real-Time Flow

```
1. User opens chat screen
   ↓
2. ChatBloc subscribes to Firestore messages collection
   ↓
3. Firestore sends initial messages + listens for changes
   ↓
4. New message arrives → Firestore snapshot event
   ↓
5. ChatBloc receives update → emits new state
   ↓
6. UI rebuilds with new messages
   ↓
7. Auto-scroll to bottom (if at bottom)
```

## ⚠️ Assumptions & Limitations

### Assumptions

1. **Firebase Free Tier Sufficient**
   - Assuming usage within Firebase free tier limits (50K reads, 20K writes/day)
   - Perfect for demo and small-scale use

2. **Demo Authentication**
   - Any email/password creates a new account
   - No email verification required
   - Simplified for assessment purposes

3. **Single Workspace**
   - Default workspace "default-workspace" for all users
   - Multi-workspace support can be added easily

4. **Text Messages Only**
   - Currently supports text messages
   - Image/file attachments not implemented (can be added)

### Limitations

1. **No Backend Server**
   - Using Firestore directly from client
   - Security rules should be tightened for production

2. **Message Limit**
   - Loading last 100 messages per channel for performance
   - Pagination not implemented

3. **No Push Notifications**
   - Would require Firebase Cloud Messaging setup
   - Background notification handling not implemented

4. **No Search Functionality**
   - Message search not implemented
   - Can be added with Firestore queries or Algolia

5. **No User Presence**
   - Online/offline status not tracked
   - Can be added with Firestore realtime updates

## 🚀 What I Would Improve with More Time

1. **Testing**
   - Unit tests for BLoCs and repositories
   - Widget tests for UI components
   - Integration tests for critical flows

2. **Performance Optimization**
   - Message pagination/lazy loading
   - Image caching for avatars
   - Message list virtualization for thousands of messages

3. **Enhanced Features**
   - Message editing and deletion
   - Thread replies
   - File/image attachments
   - User profiles and presence
   - Push notifications
   - Message search
   - Read receipts
   - Link previews

4. **Security**
   - Stricter Firestore security rules
   - Rate limiting
   - Input sanitization
   - Proper authentication tokens

5. **UX Improvements**
   - Skeleton loaders
   - More animations and transitions
   - Better error handling and retry mechanisms
   - Offline mode indicator
   - Haptic feedback

6. **Code Quality**
   - More comprehensive error handling
   - Better logging and analytics
   - Code documentation
   - Performance monitoring

## 📱 Screenshots

See the demo video for visual representation of all features.

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/
```

## 🔍 Code Structure Highlights

- **Clean Architecture**: Proper separation of presentation, domain, and data layers
- **SOLID Principles**: Single responsibility, dependency inversion
- **BLoC Pattern**: Unidirectional data flow, testable business logic
- **Reactive Programming**: Stream-based real-time updates
- **Dependency Injection**: Loose coupling, easy testing

## 📄 License

This is an assessment project. All rights reserved.

## 👨‍💻 Author

Developed as part of Flutter Developer Assessment.

## 📚 Additional Documentation

- See `FIREBASE_SETUP.md` for Firebase configuration details
- See `DESIGN.md` for architecture and design decisions
# slack-clone-flutter-developer-gautam-manwani
