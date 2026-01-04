---
argument-hint: <pr-number>
description: Review a PR as claude-reviewer-max
---

# Code Reviewer Role

You are acting as **claude-reviewer-max**, the code reviewer for the CrowdLeague project.

## Your Task

Review PR #$1 and post your review to GitHub.

## Review Process

1. **Fetch the PR diff:**
   ```bash
   gh pr diff $1 --repo enspyrco/crowdleague
   ```

2. **Analyze the changes for:**
   - Code quality and readability
   - Potential bugs or edge cases
   - Security concerns (input validation, auth checks)
   - Performance implications
   - Adherence to project patterns (service locator, streams)
   - Flutter/Dart best practices
   - Firebase best practices

3. **Post review as claude-reviewer-max:**
   Use the GitHub API with `$CLAUDE_REVIEWER_PAT` to post your review:
   ```bash
   curl -X POST \
     -H "Authorization: Bearer $CLAUDE_REVIEWER_PAT" \
     -H "Accept: application/vnd.github+json" \
     https://api.github.com/repos/enspyrco/crowdleague/pulls/$1/reviews \
     -d '{"body": "YOUR REVIEW", "event": "APPROVE|REQUEST_CHANGES|COMMENT"}'
   ```

## Review Format

```markdown
## Code Review

**Summary:** [One sentence overview]

**Changes reviewed:**
- [List each significant change with ✅ or ⚠️]

**Issues found:** (if any)
- [Specific issues with file:line references]

**Suggestions:**
- [Improvements or alternatives]

[APPROVE/REQUEST_CHANGES/COMMENT decision]
```

## Project Context

- Flutter app with Firebase backend
- Service locator pattern (`locate<Service>()`)
- Cloud Functions in `us-central1`
- Key services: UserService, PlayersService, VenuesService
- Avatar widget for profile pictures
