/**
 * CrowdLeague Pitch Deck Generator
 *
 * Creates Google Slides presentation with hand-crafted content.
 * Based on the Google Apps Script version but using Node.js googleapis.
 *
 * Usage:
 *   npm run generate
 *   npm run generate -- --presentation-id=EXISTING_ID  # Update existing
 */

import { google } from 'googleapis';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { getAuthClient } from './auth.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CONFIG_PATH = path.join(__dirname, '.config.json');

// Colors (RGB 0-1 scale)
const COLORS = {
  DARK_BLUE: { red: 0.102, green: 0.212, blue: 0.365 },    // #1a365d
  ACCENT_BLUE: { red: 0.193, green: 0.510, blue: 0.784 },  // #3182ce
  WHITE: { red: 1.0, green: 1.0, blue: 1.0 },
  DARK_GRAY: { red: 0.176, green: 0.216, blue: 0.282 },    // #2d3748
};

// Conversion: points to EMU (English Metric Units)
const PT_TO_EMU = 12700;

function pt(points) {
  return points * PT_TO_EMU;
}

/**
 * Slide content - hand-crafted for best appearance
 * Updated with corrected statistics from pitch-deck.md
 */
const SLIDES = [
  // Slide 1: Title
  {
    background: COLORS.DARK_BLUE,
    elements: [
      { text: 'CrowdLeague', x: 50, y: 150, w: 620, h: 80, size: 48, color: COLORS.WHITE, bold: true },
      { text: 'Find players. Find venues. Play more.', x: 50, y: 240, w: 620, h: 40, size: 24, color: COLORS.ACCENT_BLUE },
      { text: 'Building the grassroots sports communities\nthat create champions', x: 50, y: 320, w: 620, h: 60, size: 18, color: COLORS.WHITE },
    ],
    notes: `TITLE SLIDE

Key message: CrowdLeague solves the fragmentation problem in grassroots sports.

Talking points:
- We help people find places to play and people to play with
- Focus on casual/recreational players, not elite athletes
- Australian-built for Australian sports culture`
  },

  // Slide 2: The Problem
  {
    elements: [
      { text: 'The Problem', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: 'Young Australians are dropping out of sport', x: 50, y: 90, w: 620, h: 40, size: 24, color: COLORS.ACCENT_BLUE, bold: true },
      { text: `• 34% of young Australians have asked to quit organized sports
  27% stop playing by age 15 (Allianz/PureProfile 2024)

• Time pressure, cost, and competitiveness drive them away

• Finding pickup games and connecting with players is fragmented

The Gap: No single platform connects grassroots basketball players
with courts and each other.`, x: 50, y: 150, w: 620, h: 250, size: 17, color: COLORS.DARK_GRAY },
    ],
    notes: `THE PROBLEM - Sources

"34% of young Australians want to quit organized sports"
Source: Allianz Australia Youth Sports Research 2024
https://ministryofsport.com/new-research-from-allianz-australia-highlights-drop-in-youth-sports-participation/

Key findings:
- Main reasons: too much pressure, not fun anymore, time constraints
- Teens stay in sport when it's fun and social`
  },

  // Slide 3: The Solution
  {
    elements: [
      { text: 'The Solution', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: 'CrowdLeague connects players with venues and each other', x: 50, y: 90, w: 620, h: 40, size: 20, color: COLORS.ACCENT_BLUE, bold: true },
      { text: `🗺️  Discover Venues
     Interactive map with photos and facility details

👥  Build Your Crew
     Connect with players who share your interests

💬  Coordinate Play
     Message your crew, get notified when friends are playing

🏀  Grassroots-First
     Designed for casual players, not elite athletes`, x: 50, y: 150, w: 620, h: 250, size: 16, color: COLORS.DARK_GRAY },
    ],
    notes: `THE SOLUTION

Demo flow (if showing app):
1. Open map - show nearby venues with photos
2. Tap venue - see details, who plays there
3. Show crew list - your trusted network
4. Show messaging - coordinate meetups

Differentiators:
- Venue-FIRST (not event-first)
- Crew model = trusted connections
- No performance tracking`
  },

  // Slide 4: Market Opportunity
  {
    elements: [
      { text: 'Market Opportunity', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: `Australian Sports Tech Market

  2024 Market Size:     $632 million AUD
  2034 Projected:        $2.16 billion AUD
  Growth Rate:            13.1% CAGR

Participation Numbers

  • 84% of Australian adults participate in sports annually
  • 4.8 million Australians aged 0-14
  • 36% of children participate in organized sport weekly
  • Brisbane 2032 driving $7.1B+ investment`, x: 50, y: 100, w: 620, h: 300, size: 16, color: COLORS.DARK_GRAY },
    ],
    notes: `MARKET OPPORTUNITY - Sources

Sports Tech Market:
Source: Expert Market Research
https://www.expertmarketresearch.com.au/reports/australia-sports-technology-market
- 2024: $632M AUD
- 2034: $2.16B AUD (projected)
- CAGR: 13.1%

Participation Stats:
Source: Sport Australia AusPlay
https://www.ausport.gov.au/participation/participants/youth`
  },

  // Slide 5: Brisbane 2032
  {
    background: COLORS.DARK_BLUE,
    elements: [
      { text: 'Brisbane 2032 Olympics', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.WHITE, bold: true },
      { text: '"Today\'s teenagers are tomorrow\'s Olympic athletes"', x: 50, y: 90, w: 620, h: 40, size: 20, color: COLORS.ACCENT_BLUE },
      { text: `Unprecedented grassroots investment:

  Games On! Program:     $250 million
  Go for Gold Fund:         $100 million
  Venue Infrastructure:    $7.1 billion

CrowdLeague builds the grassroots communities
that feed into Olympic pathways.`, x: 50, y: 160, w: 620, h: 220, size: 18, color: COLORS.WHITE },
    ],
    notes: `WHY MELBOURNE FIRST - Sources

Melbourne as sporting capital:
- Australian Open, Melbourne Cup, F1 Grand Prix
- Home of AFL (largest attendance globally)

Startup ecosystem:
- Melbourne Angels, Startmate, LaunchVic

Brisbane 2032 (Phase 2):
Source: QLD 2032 Delivery Plan
https://www.delivering2032.com.au/__data/assets/pdf_file/0013/105061/Queensland_Government-2032_Delivery_Plan.pdf`
  },

  // Slide 6: Competitive Landscape
  {
    elements: [
      { text: 'Competitive Landscape', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: `Competitor          Focus                        Gap
─────────────────────────────────────────────────
OpenSports         Event registration      No venue discovery, US-focused
Strava                  Fitness tracking         Individual, not social play
Meetup                General events          Not sports-specific
Facebook            Community forums    Fragmented, not purpose-built

CrowdLeague Differentiators:
  ✓ Venue-first discovery
  ✓ Trusted crew network (not random strangers)
  ✓ Australian-built for Australian sports culture`, x: 50, y: 100, w: 620, h: 280, size: 14, color: COLORS.DARK_GRAY },
    ],
    notes: `COMPETITIVE LANDSCAPE

OpenSports: US-based, event registration, no venue discovery
Strava: 100M+ users, individual tracking, not social
Meetup: General events, not sports-specific
Facebook: Fragmented groups, no venue database

Our advantage:
- Purpose-built for AU grassroots sports
- Venue-first approach
- Local Melbourne knowledge`
  },

  // Slide 7: Business Model
  {
    elements: [
      { text: 'Business Model', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: `Phase 1: Community Building (Current)
  • Free for all players
  • Build user base and court database
  • Focus on Melbourne basketball community

Phase 2: Venue Partnerships
  • Premium court listings ($50-200/month)
  • Booking commission (10-15%)
  • Event promotion and sponsored listings

Phase 3: Scale & Monetize
  • Expand to Brisbane, Sydney, Perth
  • B2B offerings for basketball associations
  • Sponsorship and targeted advertising`, x: 50, y: 100, w: 620, h: 290, size: 15, color: COLORS.DARK_GRAY },
    ],
    notes: `BUSINESS MODEL

Phase 2 Revenue:
1. Premium venue listings: $50-200/month
2. Booking commission: 10-15%
3. Event promotion, sponsored listings

Comparable models:
- ClassPass, OpenTable, Hipcamp`
  },

  // Slide 8: Current Status
  {
    elements: [
      { text: 'Current Status', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: 'Product Ready', x: 50, y: 85, w: 620, h: 35, size: 22, color: COLORS.ACCENT_BLUE, bold: true },
      { text: `✓ Fully functional iOS and Android app
✓ Google & Apple Sign-In authentication
✓ Interactive court map with photo uploads
✓ Player profiles and crew connections
✓ Real-time messaging between crew members
✓ Push notifications

Stage: Pre-Launch — Seeking funding for user acquisition

Next Milestones:
  1. Seed 100+ Melbourne basketball courts
  2. Beta launch with local basketball community
  3. Partner with Basketball Victoria`, x: 50, y: 130, w: 620, h: 250, size: 14, color: COLORS.DARK_GRAY },
    ],
    notes: `CURRENT STATUS

Tech stack: Flutter, Firebase, Google Maps
Deployed to App Store + Play Store

Development: Solo founder + Claude Code AI

Next milestones:
1. Seed 100+ Melbourne venues
2. Beta: 500+ users
3. Partner with Basketball Victoria`
  },

  // Slide 9: The Ask
  {
    elements: [
      { text: 'The Ask', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: 'Seeking: $50,000 - $100,000', x: 50, y: 85, w: 620, h: 35, size: 24, color: COLORS.ACCENT_BLUE, bold: true },
      { text: `Use of Funds:

  Marketing & User Acquisition     40%
  Venue Database Seeding           30%
  Operations (18 months)               20%
  Contingency                                  10%

This Enables:
  • Launch with 100+ courts, 500+ users in Melbourne
  • Validate product-market fit
  • Build foundation for Series Seed

Success Metrics:
  • 500+ MAU, 100+ venues, 30%+ retention`, x: 50, y: 135, w: 620, h: 260, size: 15, color: COLORS.DARK_GRAY },
    ],
    notes: `THE ASK - Budget Breakdown

$50K-$100K Pre-Seed

Marketing (40%): Social ads, community outreach
Venue Seeding (30%): Photography, data entry
Operations (20%): Firebase, App Store fees
Contingency (10%)

Runway: 18 months
Success metrics: 500+ MAU, 100+ venues, 30%+ retention`
  },

  // Slide 10: Team
  {
    elements: [
      { text: 'Team', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.DARK_BLUE, bold: true },
      { text: `Nicholas Meinhold
Founder & Developer

• 20 years software development experience
• Flutter & Firebase expertise
• Passionate recreational basketball player
• Based in Melbourne, Victoria


Development accelerated with Claude Code AI assistance
• Rapid iteration and code review
• 24/7 development capability`, x: 50, y: 100, w: 620, h: 280, size: 16, color: COLORS.DARK_GRAY },
    ],
    notes: `TEAM

Key points:
- Local knowledge: You know Melbourne venues
- Technical: Full-stack capability
- Passion: You're the target user
- Resourceful: Built MVP with AI assistance`
  },

  // Slide 11: The Vision
  {
    background: COLORS.DARK_BLUE,
    elements: [
      { text: 'The Vision', x: 50, y: 30, w: 620, h: 50, size: 36, color: COLORS.WHITE, bold: true },
      { text: `Roadmap:

  2026  Melbourne — Validate product-market fit
  2027  Sydney — Prove multi-city model
  2028  Brisbane — Ride the Olympics wave
  2032  National — The platform young Australians
            use to find courts and players

Building the grassroots communities
that create champions.`, x: 50, y: 100, w: 620, h: 230, size: 18, color: COLORS.WHITE },
    ],
    notes: `THE VISION - Timeline

2026 Melbourne: Validate PMF
2027 Sydney: Prove multi-city model
2028-32 Brisbane: Olympics wave ($7.1B investment)
2032+ National

Exit opportunities:
- Sports media acquisition
- Fitness platform (ClassPass-style)
- Growth equity`
  },
];

/**
 * Create a text box on a slide
 */
function createTextBoxRequests(slideId, elementId, elem) {
  return [
    {
      createShape: {
        objectId: elementId,
        shapeType: 'TEXT_BOX',
        elementProperties: {
          pageObjectId: slideId,
          size: {
            width: { magnitude: pt(elem.w), unit: 'EMU' },
            height: { magnitude: pt(elem.h), unit: 'EMU' }
          },
          transform: {
            scaleX: 1,
            scaleY: 1,
            translateX: pt(elem.x),
            translateY: pt(elem.y),
            unit: 'EMU'
          }
        }
      }
    },
    {
      insertText: {
        objectId: elementId,
        text: elem.text
      }
    },
    {
      updateTextStyle: {
        objectId: elementId,
        style: {
          fontFamily: 'Arial',
          fontSize: { magnitude: elem.size, unit: 'PT' },
          foregroundColor: { opaqueColor: { rgbColor: elem.color } },
          bold: elem.bold || false
        },
        fields: 'fontFamily,fontSize,foregroundColor,bold'
      }
    },
    {
      updateParagraphStyle: {
        objectId: elementId,
        style: {
          lineSpacing: 115,
          alignment: 'START'
        },
        fields: 'lineSpacing,alignment'
      }
    }
  ];
}

/**
 * Main function
 */
async function main() {
  console.log('CrowdLeague Pitch Deck Generator\n');

  // Authenticate
  const auth = await getAuthClient();
  const slidesApi = google.slides({ version: 'v1', auth });

  // Check for existing presentation ID
  let presentationId = process.env.PITCH_DECK_ID;
  const idArg = process.argv.find(arg => arg.startsWith('--presentation-id='));
  if (idArg) {
    presentationId = idArg.split('=')[1];
  }
  if (!presentationId && fs.existsSync(CONFIG_PATH)) {
    const config = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));
    presentationId = config.presentationId;
  }

  if (presentationId) {
    // Update existing presentation
    console.log(`Updating existing presentation: ${presentationId}`);

    // Get existing slides
    const existing = await slidesApi.presentations.get({ presentationId });
    const existingSlides = existing.data.slides || [];

    // Delete all existing slides
    if (existingSlides.length > 0) {
      console.log(`Deleting ${existingSlides.length} existing slides...`);
      const deleteRequests = existingSlides.map(slide => ({
        deleteObject: { objectId: slide.objectId }
      }));
      await slidesApi.presentations.batchUpdate({
        presentationId,
        requestBody: { requests: deleteRequests }
      });
    }
  } else {
    // Create new presentation
    console.log('Creating new presentation...');
    const presentation = await slidesApi.presentations.create({
      requestBody: { title: 'CrowdLeague Pitch Deck' }
    });
    presentationId = presentation.data.presentationId;
    fs.writeFileSync(CONFIG_PATH, JSON.stringify({ presentationId }, null, 2));
    console.log(`Created: ${presentationId}`);

    // Delete the default blank slide
    const defaultSlideId = presentation.data.slides[0].objectId;
    await slidesApi.presentations.batchUpdate({
      presentationId,
      requestBody: {
        requests: [{ deleteObject: { objectId: defaultSlideId } }]
      }
    });
  }

  // Build all requests
  const requests = [];

  SLIDES.forEach((slide, slideIndex) => {
    const slideId = `slide_${slideIndex}`;

    // Create slide
    requests.push({
      createSlide: {
        objectId: slideId,
        insertionIndex: slideIndex,
        slideLayoutReference: { predefinedLayout: 'BLANK' }
      }
    });

    // Set background if specified
    if (slide.background) {
      requests.push({
        updatePageProperties: {
          objectId: slideId,
          pageProperties: {
            pageBackgroundFill: {
              solidFill: { color: { rgbColor: slide.background } }
            }
          },
          fields: 'pageBackgroundFill'
        }
      });
    }

    // Add text elements
    slide.elements.forEach((elem, elemIndex) => {
      const elementId = `${slideId}_text_${elemIndex}`;
      requests.push(...createTextBoxRequests(slideId, elementId, elem));
    });
  });

  console.log(`Applying ${requests.length} requests...`);

  // Apply in batches (API limit is ~100 per request)
  const BATCH_SIZE = 50;
  for (let i = 0; i < requests.length; i += BATCH_SIZE) {
    const batch = requests.slice(i, i + BATCH_SIZE);
    await slidesApi.presentations.batchUpdate({
      presentationId,
      requestBody: { requests: batch }
    });
    process.stdout.write('.');
  }

  // Add speaker notes
  console.log('\nAdding speaker notes...');
  const presentation = await slidesApi.presentations.get({ presentationId });
  const notesRequests = [];

  presentation.data.slides.forEach((slide, i) => {
    if (i >= SLIDES.length || !SLIDES[i].notes) return;

    const notesId = slide.slideProperties?.notesPage?.notesProperties?.speakerNotesObjectId;
    if (notesId) {
      // Insert new notes (just insert, no need to delete on fresh slides)
      notesRequests.push({
        insertText: {
          objectId: notesId,
          text: SLIDES[i].notes,
          insertionIndex: 0
        }
      });
    }
  });

  if (notesRequests.length > 0) {
    await slidesApi.presentations.batchUpdate({
      presentationId,
      requestBody: { requests: notesRequests }
    });
    console.log(`Added notes to ${notesRequests.length} slides`);
  }

  console.log('\n');
  const url = `https://docs.google.com/presentation/d/${presentationId}/edit`;
  console.log(`Done! View your presentation at:\n${url}`);
}

main().catch(err => {
  console.error('Error:', err.message);
  if (err.errors) console.error(JSON.stringify(err.errors, null, 2));
  process.exit(1);
});
