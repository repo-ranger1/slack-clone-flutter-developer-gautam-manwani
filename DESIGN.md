# Design Doc - Slack Clone

## Whats Inside

This document explains how the app is structured and design choices made during development.

## System Overview

Built a real-time messaging app using Flutter and Firebase. Its like Slack but simplified for demo purposes.

**Features Working:**
- Real-time messaging (obviously)
- Optimistic UI - messages show instant
- Works offline too
- Typing indicators
- Message reactions
- Dark mode
- Messages grouped by user

**Tech Used:**
```
Flutter → BLoC → Repository → Firebase Firestore → Local Storage
```

## Architecture

Using clean architecture with 3 layers. Keeps things organized and testable.

### Presentation Layer
All the UI stuff. Pages, widgets, and BLoC for state management.

```
presentation/
├── auth/      # login page and auth bloc
├── channels/  # channel list stuff
├── chat/      # chat page (most complex part)
└── theme/     # dark mode toggle
```

Why BLoC? Because it separates business logic from UI properly. Makes testing easier too.

### Domain Layer
Business logic lives here. Just entities and repository interfaces.

```
domain/
├── entities/      # user, channel, message objects
└── repositories/  # interfaces only
```

### Data Layer
Handles all Firebase stuff. Models convert between Firestore and entities.

```
data/
├── models/       # DTOs for firestore
├── datasources/  # firebase queries
└── repositories/ # implementations
```

### Core Layer
Shared utilities like constants, extensions, DI container, storage helpers.

## How Real-Time Works

### Sending Messages

1. User types and hits send
2. Message shows immediately (optimistic UI)
3. Background: saves to Firestore
4. If success: status → "sent"
5. If fail: status → "failed", can retry

This way user don't have to wait for server. Feels instant.

### Receiving Messages

App subscribes to Firestore stream when chat opens. Any new message from any user triggers the stream and UI updates automatically. Simple as that.

### Typing Indicators

When user types, app updates Firestore with typing status + timestamp. Other users listen to this and show "User is typing...". After 3 seconds of no typing, indicator disappears.

Used debounce so it don't spam Firestore on every keystroke.

## Scaling This Thing

### Current State (MVP)
Works fine for 100-1000 users. But has limitations:
- Direct Firestore access from client
- Loads all messages (limit 100)
- No pagination yet
- No caching strategy

### If We Need 10K Users

Would need:
1. Backend service layer (REST API or GraphQL)
2. Message pagination (lazy load on scroll)
3. Caching: Memory → SQLite → Network
4. Batch writes for optimization
5. Redis for presence tracking

### For 100K+ Users

Would go full microservices:
- Separate services for auth, messages, presence, notifications
- Message queue (Kafka/RabbitMQ)
- Database sharding
- Load balancer for WebSocket servers
- CDN for assets

But thats way overkill for now.

## Trade-offs Made

### Firebase vs Custom Backend
**Chose Firebase** because:
- Real-time works out of box
- No backend to maintain
- Free tier enough for demo
- Fast development

Downside is vendor lock-in but worth it for MVP.

### BLoC vs Riverpod/GetX
**Chose BLoC** for:
- Industry standard
- Good separation of concerns
- Testable
- Shows proper architecture

More boilerplate than others but demonstrates better practices.

### Optimistic UI
Shows messages immediately instead of waiting for server. Better UX even tho slightly more complex to implement.

## Data Structure

Firestore organized like this:

```
workspaces/{id}/
├── channels/{id}/
│   ├── name, createdAt
│   └── messages/{id}/
│       ├── text, sender, timestamp
│       └── reactions: [{emoji, userId}]
├── users/{id}/
│   └── typing: {isTyping, channelId, timestamp}
└── channelMetadata/{id}/
    └── unreadCount/{userId}: {count}
```

Pretty straightforward structure. Works well with Firestore queries.

## Performance Stuff

### Message List
- Uses ListView with reverse for efficient scrolling
- Auto-dispose streams to prevent memory leaks
- Limits queries to 100 messages
- Groups messages to reduce widget count

### State Management
- Immutable state updates with copyWith()
- Equatable prevents unnecessary rebuilds
- BlocBuilder for selective widget rebuilds

### Memory
Always cancel subscriptions in close() method. Otherwise memory leaks everywhere.

## Security

Currently using test mode (allow all) for demo. Obviously not production-ready.

For production would add proper Firestore rules:
- Only authenticated users can read/write
- Users can only edit their own messages
- Validation on message structure
- Rate limiting

But test mode fine for assessment purposes.

## Conclusion

Architecture is solid even tho its simplified for demo. Clean separation of layers, real-time working smoothly, and clear path for scaling if needed.

Trade-offs made sense for MVP while showing understanding of production-level architecture.
