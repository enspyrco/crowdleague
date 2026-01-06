# CrowdLeague Workflow

Sprint tasks from TENGPT Meeting 1 (January 3, 2025).

## Sprint Schedule

- **Opening**: Sunday (50 minutes)
- **Mid-check**: Saturday
- **Retro**: Friday

---

## Week 1 (Due: Friday 9 Jan 2026, COB)

### Part 1: Remove Complexity

- [x] Simplify codebase (merged: f07e595a)
- [x] Fix user feedback bugs (#196-#202)
- [x] Create ROADMAP.md

### Part 2: Social Side Research

- [x] Research social network features for referees and basketball players
- [x] Investigate ranking system requirements
- [x] Review competitor apps (targeting 12-19 year old demographic)

#### Research Findings (6 Jan 2026)

**Connection Models Reviewed:**

- **Facebook**: Symmetric "friend" model — mutual consent, equal privileges
- **Instagram**: Asymmetric "follow" model — one-way, no consent needed
- **Snapchat**: Symmetric + engagement layers (Best Friends, streaks, solar system)
- **LinkedIn**: Symmetric with degree visibility (1st/2nd/3rd connections)

**Decision: Keep "Crew" as simple symmetric model**

- Mutual consent required (request → accept)
- No engagement tiers or gamification for now
- Sports-themed terminology fits the app
- Equivalent to Facebook's original friend model

**Future Gamification Options (backlog):**

- "Starting 5" — top crew members by interaction
- Court position visualization
- Relationship badges (Court Regulars, Day Ones, etc.)
- Streak system for consistent interaction

**Ranking System:**

- Defer until core social features are stable
- Consider LinkedIn-style trust chains for referees later

---

## Week 2 (Due: Friday 16 Jan 2026, COB)

### Part 1: Add Payment Platform

- [ ] Research payment integration options
- [ ] Implement payment platform

### Part 2: App Store Submission

- [x] Prepare Play Store listing (icon, screenshots, description)
- [x] Upload build to Play Store (v0.0.5+13)
- [x] Upload build to App Store Connect (v0.0.5+13)
- [ ] Prepare App Store listing (screenshots, description)
- [ ] Submit to Play Store for review
- [ ] Submit to App Store for review

### Part 3: Infrastructure (6 Jan 2026)

- [x] Set up CI pipeline (GitHub Actions: analyze + test)
- [x] Configure branch protection for main
  - PRs required
  - 1 approval required
  - CI must pass
  - Conversations must be resolved

---

## Key Milestone

**App Store Submission** - Week 2, Part 2

Context: Opportunity for equity-free funding targeting the 12-19 year old demographic for the Olympics.

---

## Recently Merged

- PR #209: Fix onboarding notifications text formatting (bug #198)
- PR #208: Fix Firebase config for iOS Crashlytics (bug #207)
- PR #206: Fix profile pic upload spinner (bug #205)
- PR #204: Add messages badge feature (issue #203)
