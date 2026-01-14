# Review Configuration

## Project Context
CrowdLeague is a Flutter mobile app for finding and connecting with sports players at local venues. Initially focused on the Melbourne basketball community.

## Tech Stack
- **Flutter/Dart**: Mobile app with Firebase backend
- **Firebase**: Auth, Firestore, Storage, Functions, Messaging, Crashlytics, Analytics
- **Cloud Functions**: TypeScript in `functions/` directory

## Architecture Patterns
- Service locator pattern (`locate<Service>()`)
- BehaviorSubject streams for state management
- go_router for navigation

## Key Services
- UserService: Auth and user profile management
- PlayersService: Player profiles with PlayerCache
- VenuesService: Venue CRUD with Firebase Storage
- ConversationsService: Chat messaging
- NotificationsService: Push notifications

## Review Focus Areas
- Firebase security rules and data access patterns
- Service locator usage patterns
- Stream-based state management
- Flutter/Dart best practices

## Code Standards
- Dart: Follow flutter_lints rules
- Run `flutter analyze --no-fatal-infos` for Dart
- Run `npm run lint` and `npm test` for Functions

## Coverage Requirements
- New features should have tests covering main success path
- Bug fixes should include regression tests
- Flag files <80% coverage for attention (not blocking)
- Missing tests for critical paths (auth, data writes) should REQUEST_CHANGES

## Required Checks
- CI must pass (Analyze & Test job)
- No new linter warnings
