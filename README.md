# Slack Clone by Gautam Manwani

A real-time messaging app built with Flutter and Firebase. Its basically like Slack but simpler version for demo purpose.

## Tech Stack

- Flutter 3.x
- Firebase (Firestore, Auth)
- BLoC for state management
- Clean architecture pattern

## Features

### Core Stuff
- Email/password login (demo mode - works with any credentials)
- Channel list with unread counts
- Real-time messaging with Firebase
- Message reactions (thumbs up, heart)
- Dark mode toggle

### Bonus Things
- Typing indicators shows when someone typing
- Message grouping by sender
- Offline support with Firestore
- Optimistic UI updates
- Auto-scroll to latest messages

## Setup

1. Clone the repo
2. Run `flutter pub get`
3. Setup Firebase:
   - Run `flutterfire configure`
   - Or manually add your `firebase_options.dart`
4. Enable Firestore and Authentication in Firebase console
5. Run `flutter run`

Thats it!

## Architecture

Using clean architecture with 3 layers:
- **Presentation**: UI stuff with BLoC
- **Domain**: Business logic and entities
- **Data**: Firebase integration and models

```
lib/
├── core/          # shared stuff
├── domain/        # entities and repository interfaces
├── data/          # firebase implementation
└── presentation/  # UI and blocs
```

## Demo

### Video Demo
[Add your demo video here]

### Download APK
[Add Google Drive link to APK here]

## How it Works

App uses Firestore real-time listeners for live updates. When user sends message, it shows immediately (optimistic UI) then syncs with Firebase. If internet is off, messages queued and sent later automatically.

Reactions work same way - tap to add/remove, updates in realtime for all users.

## What Could Be Better

With more time I would add:
- Message editing/deletion
- File attachments
- Better error handling
- Unit tests
- Push notifications
- Search functionality
- Thread replies

## Notes

This is demo app built for assessment purpose. Using Firebase free tier so should work fine for testing. All users share same workspace ("default-workspace").

Firebase wont break if you change app name/bundle - it uses the config in `firebase_options.dart` which stays same.
