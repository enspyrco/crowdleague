/**
 * OAuth2 authentication helper for Google Slides API
 *
 * Setup:
 * 1. Go to Google Cloud Console: https://console.cloud.google.com
 * 2. Create/select a project
 * 3. Enable the Google Slides API and Google Drive API
 * 4. Create OAuth 2.0 credentials (Desktop app)
 * 5. Download credentials and set environment variables:
 *    - GOOGLE_CLIENT_ID
 *    - GOOGLE_CLIENT_SECRET
 *
 * Usage:
 *   npm run auth
 */

import { google } from 'googleapis';
import http from 'http';
import url from 'url';
import open from 'open';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const TOKEN_PATH = path.join(__dirname, '.tokens.json');

const SCOPES = [
  'https://www.googleapis.com/auth/presentations',
  'https://www.googleapis.com/auth/drive.file'
];

export async function getAuthClient() {
  const clientId = process.env.GOOGLE_CLIENT_ID;
  const clientSecret = process.env.GOOGLE_CLIENT_SECRET;

  if (!clientId || !clientSecret) {
    console.error('Missing GOOGLE_CLIENT_ID or GOOGLE_CLIENT_SECRET environment variables');
    console.error('\nSetup instructions:');
    console.error('1. Go to https://console.cloud.google.com');
    console.error('2. Create a project and enable Google Slides API + Drive API');
    console.error('3. Create OAuth 2.0 credentials (Desktop app type)');
    console.error('4. Set environment variables:');
    console.error('   export GOOGLE_CLIENT_ID="your-client-id"');
    console.error('   export GOOGLE_CLIENT_SECRET="your-client-secret"');
    process.exit(1);
  }

  const oauth2Client = new google.auth.OAuth2(
    clientId,
    clientSecret,
    'http://localhost:3000/oauth2callback'
  );

  // Check for existing tokens
  if (fs.existsSync(TOKEN_PATH)) {
    const tokens = JSON.parse(fs.readFileSync(TOKEN_PATH, 'utf-8'));
    oauth2Client.setCredentials(tokens);

    // Check if token is expired
    if (tokens.expiry_date && tokens.expiry_date > Date.now()) {
      return oauth2Client;
    }

    // Try to refresh
    if (tokens.refresh_token) {
      try {
        const { credentials } = await oauth2Client.refreshAccessToken();
        oauth2Client.setCredentials(credentials);
        fs.writeFileSync(TOKEN_PATH, JSON.stringify(credentials));
        return oauth2Client;
      } catch (err) {
        console.log('Token refresh failed, re-authenticating...');
      }
    }
  }

  // Need new authentication
  return await authenticateWithBrowser(oauth2Client);
}

async function authenticateWithBrowser(oauth2Client) {
  return new Promise((resolve, reject) => {
    const authUrl = oauth2Client.generateAuthUrl({
      access_type: 'offline',
      scope: SCOPES,
      prompt: 'consent'
    });

    const server = http.createServer(async (req, res) => {
      try {
        const queryParams = new url.URL(req.url, 'http://localhost:3000').searchParams;
        const code = queryParams.get('code');

        if (code) {
          res.writeHead(200, { 'Content-Type': 'text/html' });
          res.end('<h1>Authentication successful!</h1><p>You can close this window.</p>');

          const { tokens } = await oauth2Client.getToken(code);
          oauth2Client.setCredentials(tokens);
          fs.writeFileSync(TOKEN_PATH, JSON.stringify(tokens));

          server.close();
          resolve(oauth2Client);
        }
      } catch (err) {
        res.writeHead(500);
        res.end('Authentication failed');
        reject(err);
      }
    }).listen(3000);

    console.log('Opening browser for authentication...');
    console.log('If browser does not open, visit:', authUrl);

    // Try to open browser
    import('open').then(({ default: open }) => {
      open(authUrl);
    }).catch(() => {
      console.log('Could not open browser automatically.');
    });
  });
}

// Run authentication if called directly
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  getAuthClient()
    .then(() => {
      console.log('Authentication successful! Tokens saved to .tokens.json');
      process.exit(0);
    })
    .catch(err => {
      console.error('Authentication failed:', err);
      process.exit(1);
    });
}
