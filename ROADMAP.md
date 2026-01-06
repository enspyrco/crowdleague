# CrowdLeague Roadmap

A Flutter mobile app for finding and connecting with sports players at local venues.

## Current Features

### Core Functionality

- **Venues** - Map view with venue locations, add new venues with photos
- **Player Profiles** - User profiles with photos, crew relationships
- **Crews** - Follow/connect with other players (request, accept, decline, split)
- **Messaging** - Direct conversations between players
- **Notifications** - Crew requests, acceptances, and system alerts

### Platform Support

- iOS
- Android
- macOS
- Web

---

## Phase 1: Bug Fixes & Stability

Priority fixes for existing functionality.

### High Priority

- [x] #196 #197: Fix photo upload loading state issues
- [x] #198: Fix onboarding notifications text formatting
- [x] #199: Fix CrewRequestNotification card overflow
- [ ] #202: Fix conversation not appearing in Messages list

### Medium Priority

- [ ] #200: Add visual feedback to notification buttons
- [ ] #150: Fix notification count accuracy

### Low Priority

- [ ] #189: Update image_cropper version

---

## Phase 2: Profile Enhancements

Improve the user profile experience.

- [ ] #186: Add UI to choose/delete existing profile pic
- [ ] #191: Add backend logic for deleting profile pics
- [ ] #185: Create separate storage buckets for venue photos and profile pics

---

## Phase 3: Check-In & Presence

Let players share when they're at a venue.

- [ ] #178: Show check-ins on Venues page
- [ ] #177: Notify crew when you check in
- [ ] #175: Expand Check-In to "Heads Up" feature (schedule future sessions)

---

## Phase 4: Performance & Scaling

Optimize for larger user base.

- [ ] #169: Implement pagination for NotificationsScreen
- [ ] #168: Use prototypeItem in ConversationsScreen
- [ ] #173: Optimize image caching (pre-cache DB calls, use FadeInImage)
- [ ] #159: Allow different extents for Notifications ListView items
- [ ] #154: Avoid phantom users from pre-launch reports

---

## Phase 5: Testing & Quality

Improve test coverage and reliability.

- [ ] #193: Write native tests for native UI elements
- [ ] Add widget tests for core screens
- [ ] Add integration tests for critical user flows

---

## Future Ideas

Potential features for later consideration:

- **Sports/Activity Types** - Filter venues by sport (basketball, tennis, etc.)
- **Scheduling** - Book courts, set up games in advance
- **Teams/Groups** - Form teams beyond 1:1 crews
- **Leaderboards** - Track activity, achievements
- **Events** - Organize tournaments or pickup games
- **Reviews** - Rate venues and courts

---

## Contributing

See open issues at: <https://github.com/enspyrco/crowdleague/issues>

Project board: <https://github.com/orgs/enspyrco/projects/4>
