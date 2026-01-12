/**
 * CrowdLeague Pitch Deck Generator
 *
 * Uses claude-slides to generate/update Google Slides from config.
 *
 * Prerequisites:
 *   1. Install claude-slides: cd ~/git/individuals/nickmeinhold/claude-skills && npm install
 *   2. Authenticate once: npm run auth (in claude-skills)
 *   3. Set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET env vars
 *
 * Usage:
 *   npm run generate
 *   npm run generate -- --presentation-id=EXISTING_ID  # Update existing
 */

import { execSync } from 'child_process';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CONFIG_PATH = path.join(__dirname, 'pitch-deck.config.json');
const SAVED_ID_PATH = path.join(__dirname, '.config.json');
const CLAUDE_SKILLS_PATH = path.join(process.env.HOME, 'git/individuals/nickmeinhold/claude-skills');

async function main() {
  console.log('CrowdLeague Pitch Deck Generator\n');
  console.log('Using claude-slides for generation...\n');

  // Check for existing presentation ID
  let presentationId = process.env.PITCH_DECK_ID;
  const idArg = process.argv.find(arg => arg.startsWith('--presentation-id='));
  if (idArg) {
    presentationId = idArg.split('=')[1];
  }
  if (!presentationId && fs.existsSync(SAVED_ID_PATH)) {
    const config = JSON.parse(fs.readFileSync(SAVED_ID_PATH, 'utf-8'));
    presentationId = config.presentationId;
  }

  // Build command
  let cmd = `npx --prefix "${CLAUDE_SKILLS_PATH}" claude-slides --config "${CONFIG_PATH}" --output json`;
  if (presentationId) {
    cmd += ` --presentation-id "${presentationId}"`;
    console.log(`Updating existing presentation: ${presentationId}`);
  } else {
    console.log('Creating new presentation...');
  }

  try {
    const result = execSync(cmd, {
      encoding: 'utf-8',
      env: { ...process.env },
      stdio: ['inherit', 'pipe', 'inherit']
    });

    const output = JSON.parse(result.trim());

    // Save presentation ID for future updates
    if (!presentationId) {
      fs.writeFileSync(SAVED_ID_PATH, JSON.stringify({ presentationId: output.presentationId }, null, 2));
    }

    console.log(`\nDone! View your presentation at:\n${output.presentationUrl}`);
  } catch (error) {
    if (error.message.includes('No authentication tokens found')) {
      console.error('\nAuthentication required. Run:');
      console.error(`  cd ${CLAUDE_SKILLS_PATH} && npm run auth`);
      process.exit(1);
    }
    throw error;
  }
}

main().catch(err => {
  console.error('Error:', err.message);
  process.exit(1);
});
