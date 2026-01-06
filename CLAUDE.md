# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CrowdLeague is a Flutter mobile app for finding and connecting with sports players at local venues. The app uses Firebase for backend services (Auth, Firestore, Storage, Functions, Messaging, Crashlytics, Analytics).

## Common Commands

### Flutter App

```bash
# Run the app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/court_surface_dropdown_test.dart

# Analyze code
flutter analyze

# Get dependencies
flutter pub get
```

### Firebase Functions (in `functions/` directory)

```bash
cd functions

# Install dependencies
npm install

# Build TypeScript
npm run build

# Run tests
npm test

# Lint
npm run lint

# Start emulators for local development
npm run build && firebase emulators:start --only storage,functions

# Debug functions with inspector
npm run build && firebase emulators:start --only functions,firestore,storage --inspect-functions

# Deploy functions
npm run deploy
```

## Architecture

### Service Locator Pattern

The app uses a custom service locator (`lib/utils/locator.dart`) for dependency injection:

```dart
// Register a service (in main.dart)
Locator.add<ServiceType>(ServiceInstance(...));

// Retrieve a service anywhere in the app
locate<ServiceType>().someMethod();
```

All services are registered in `main()` before `runApp()`. Services wrap Firebase SDK classes and expose streams/methods to the UI layer.

### Key Services

- **UserService**: Unified service handling Google/Apple sign-in, user profile management, and crew operations. Exposes current user profile via `BehaviorSubject` stream
- **PlayersService**: Player profiles with `PlayerCache` for frequently accessed data
- **VenuesService**: Venue CRUD operations with Firebase Storage for images
- **NotificationsService**: Push notification handling and badge counts
- **ConversationsService**: Chat messaging between players
- **MessagingService**: FCM token management

### Navigation

Uses `go_router` with named routes defined in `lib/main.dart`. Routes include onboarding flow (`/edit-name`, `/edit-profile-pic`, `/onboard-notifications`), venue management, player profiles, and conversations.

### Main Screens

The `HomeScreen` uses `NavigationBar` with four destinations:

1. Venues (map view)
2. Notifications (with badge count)
3. Messages/Conversations
4. You (user profile)

### Firebase Functions

TypeScript functions in `functions/src/`:

- `crew-request.ts` / `accept-crew-request.ts` / `split-crews.ts`: Player relationship management
- `send-message-to-participants.ts`: Push notifications for messages
- `resize-images.ts`: Image processing on upload

### Data Models

Models are in feature directories (e.g., `lib/players/models/player.dart`, `lib/venues/models/venue.dart`). Most have `fromJsonWithId` factory constructors for Firestore document parsing.

### Venue Photo/Icon Flow

1. User picks photo → cropped locally via `image_cropper`
2. `Screenshot` widget captures `VenueIcon` widget as PNG bytes (48x48)
3. Both original photo and icon bytes uploaded to Storage (`venuePhotos/{id}.jpg`, `venuePhotos/{id}_icon`)
4. `resize-images` Cloud Function triggers, creates `_large`, `_medium`, `_small` variants
5. Map displays icon via `BitmapDescriptor.bytes()` from downloaded icon bytes

### Firebase Configuration

- Project ID: `crowdleague-project`
- Cloud Functions region: `us-central1`
- Database and bucket names defined in `lib/utils/globals.dart`
- Storage bucket: `crowdleague-project.firebasestorage.app`

### Firebase Storage Access

Two separate permission systems:

1. **Firebase Storage Rules** (`storage.rules`) - applies to Firebase SDK access (`storageRef.getData()`, `storageRef.putFile()`)
2. **GCS IAM** - applies to direct URL access (`https://storage.googleapis.com/bucket/path`)

Venue photos need public URL access for `Image.network()`, so bucket has `allUsers:objectViewer` IAM role. Storage rules still require auth for writes.

### Firebase Deployment

Note: `firebase.json` must include `"storage": {"rules": "storage.rules"}` for storage deployment to work.

```bash
# Deploy storage rules
firebase deploy --only storage

# Deploy firestore rules
firebase deploy --only firestore

# Deploy functions
firebase deploy --only functions
```

## iOS Simulator Notes

- Push notifications (APNS) are not available on iOS simulators - the app gracefully skips FCM setup
- Google Maps works on simulators but may require API key configuration

## Development Workflow

### Branch Protection

The `main` branch is protected with the following rules:

- Pull request required before merging
- 1 approval required
- CI status checks must pass
- Conversations must be resolved

### CI Pipeline

GitHub Actions runs on all PRs and pushes to main (`.github/workflows/ci.yml`):

- `flutter analyze --no-fatal-infos`
- `flutter test`

### Making Changes

1. Create a feature branch: `git checkout -b feature/my-feature`
2. Make changes and commit
3. Push and open a PR: `gh pr create`
4. CI runs automatically
5. Request review (claude-reviewer-max available)
6. Get approval + green CI → merge

### Environment Variables

PATs for Claude agents are stored in `.env` (gitignored):

```bash
CLAUDE_REVIEWER_PAT="ghp_..."  # For claude-reviewer-max
CLAUDE_PM_PAT="ghp_..."        # For claude-pm-enspyr
```

Load before using `/review` or `/pm` commands:
```bash
source .env
```

## Testing

Widget tests use `fake_cloud_firestore` and `firebase_storage_mocks` to mock Firebase services. Register mocked services via `Locator.add<T>()` before running tests.
