# CrowdLeague Beta Testing Guide

## Overview

CrowdLeague connects sports players with local venues and each other. Test on iOS (TestFlight) and Android (Play Store Internal Testing).

---

## 1. Authentication & Onboarding

**Sign In:**

- [ ] Google Sign-In works correctly
- [ ] Apple Sign-In works (iOS only)
- [ ] Sign out and sign back in preserves data

**First-time Onboarding:**

- [ ] Edit name screen appears after first sign-in
- [ ] Profile photo picker works (camera + gallery)
- [ ] Photo cropping functions correctly
- [ ] Notification permission prompt appears
- [ ] Skip buttons work on optional steps

---

## 2. Venues (Map Tab)

**Map Display:**

- [ ] Map loads with correct initial location
- [ ] Current location button works
- [ ] Map markers display venue icons correctly
- [ ] Tapping marker shows venue details

**Add Venue:**

- [ ] "Add Venue" button visible
- [ ] Can set venue location on map
- [ ] Can add venue name and description
- [ ] Photo upload works (take photo / choose from gallery)
- [ ] Icon preview shows correctly before saving
- [ ] Venue appears on map after creation

**Venue Details:**

- [ ] Venue info displays correctly
- [ ] Multiple photos display and swipe
- [ ] Can add additional photos to existing venues
- [ ] Photo zoom/full-screen works

---

## 3. Player Profiles & Crews

**Your Profile (You Tab):**

- [ ] Profile displays name, photo, crew count
- [ ] Edit profile button works
- [ ] Can update name
- [ ] Can change profile photo
- [ ] Changes save and persist

**Viewing Other Players:**

- [ ] Can view other player profiles
- [ ] Shows their crew members
- [ ] Shows mutual connections if any

**Crew Management:**

- [ ] Send crew request to another player
- [ ] Receive notification of incoming request
- [ ] Accept crew request
- [ ] Decline crew request
- [ ] Remove someone from crew (split crews)
- [ ] Crew count updates correctly

---

## 4. Messaging (Messages Tab)

**Conversations List:**

- [ ] Shows all active conversations
- [ ] Unread indicator displays correctly
- [ ] Tapping opens conversation

**Individual Conversation:**

- [ ] Messages load correctly
- [ ] Can send text message
- [ ] Message appears immediately
- [ ] Timestamps display correctly
- [ ] Scroll to load older messages
- [ ] New messages appear in real-time

**Starting Conversation:**

- [ ] Can start chat from player profile
- [ ] New conversation appears in list

---

## 5. Notifications (Notifications Tab)

**Notification Display:**

- [ ] Badge count shows on tab
- [ ] Crew requests appear
- [ ] Message notifications appear
- [ ] Tapping notification navigates correctly

**Push Notifications:**

- [ ] Receive push when app backgrounded
- [ ] Receive push for new messages
- [ ] Receive push for crew requests
- [ ] Tapping push opens correct screen

---

## 6. Navigation & UI

**Bottom Navigation:**

- [ ] All four tabs accessible (Venues, Notifications, Messages, You)
- [ ] Tab indicators show correctly
- [ ] Navigation state preserved when switching tabs

**General UI:**

- [ ] No layout overflow on different screen sizes
- [ ] Loading indicators appear during operations
- [ ] Error messages display when operations fail
- [ ] Back button works correctly throughout

---

## 7. Edge Cases & Error Handling

- [ ] Works with poor network connection
- [ ] Handles offline gracefully
- [ ] Large images don't crash app
- [ ] Long venue names/descriptions display correctly
- [ ] Empty states show appropriate messages

---

## Known Limitations

- Push notifications don't work on iOS Simulator (use real device)
- Some features may take a moment to sync across devices

---

## Reporting Issues

When reporting bugs, include:

1. Device model and OS version
2. Steps to reproduce
3. Expected vs actual behavior
4. Screenshots/screen recordings if possible

Report issues at: <https://github.com/enspyrco/crowdleague/issues>

---

**Focus Areas:** Authentication flow, venue creation with photos, crew requests, and real-time messaging are the core features requiring thorough testing before public launch.
