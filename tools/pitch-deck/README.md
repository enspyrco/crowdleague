# CrowdLeague Pitch Deck Generator

Syncs `docs/pitch-deck.md` to a Google Slides presentation.

## Setup

### 1. Create Google Cloud Credentials

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing
3. Enable APIs:
   - Google Slides API
   - Google Drive API
4. Go to **APIs & Services > Credentials**
5. Click **Create Credentials > OAuth client ID**
6. Select **Desktop app** as application type
7. Download or copy the Client ID and Client Secret

### 2. Create .env File

Create a `.env` file in this directory:

```bash
GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-client-secret
```

The `.env` file is gitignored and loaded automatically by the npm scripts.

### 3. Install Dependencies

```bash
cd tools/pitch-deck
npm install
```

## Usage

### First Run (Authentication)

```bash
npm run auth
```

This opens a browser for Google OAuth. After authorizing, tokens are saved locally.

### Generate Presentation

```bash
npm run generate
```

This will:

1. Parse `docs/pitch-deck.md`
2. Create a new Google Slides presentation (or update existing)
3. Print the presentation URL

### Update Existing Presentation

The tool remembers the last presentation ID. To update:

```bash
npm run generate
```

Or specify a different presentation:

```bash
npm run generate -- --presentation-id=YOUR_PRESENTATION_ID
```

## Files

- `index.js` - Main generator script
- `auth.js` - OAuth2 authentication helper
- `.tokens.json` - Saved OAuth tokens (gitignored)
- `.config.json` - Saved presentation ID (gitignored)

## How It Works

1. Reads `docs/pitch-deck.md`
2. Parses markdown into slide structure (splits on `---`)
3. Extracts titles, subtitles, lists, tables, and text
4. Generates Google Slides API requests
5. Creates/updates the presentation via batch API calls

## Customization

Edit the `COLORS` object in `index.js` to change the color scheme:

```javascript
const COLORS = {
  DARK_BLUE: { red: 0.102, green: 0.212, blue: 0.365 },
  ACCENT_BLUE: { red: 0.193, green: 0.510, blue: 0.784 },
  // ...
};
```

## Troubleshooting

### "Missing GOOGLE_CLIENT_ID" error

Ensure environment variables are set before running.

### "Token refresh failed"

Delete `.tokens.json` and run `npm run auth` again.

### Slides look wrong

The markdown parser expects the format in `pitch-deck.md`. Major format changes may require updating `parsePitchDeck()` in `index.js`.
