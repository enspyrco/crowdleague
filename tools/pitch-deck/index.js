/**
 * CrowdLeague Pitch Deck Generator
 *
 * Creates Google Slides presentation from config file.
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
const SLIDES_CONFIG_PATH = path.join(__dirname, 'pitch-deck.config.json');

// Conversion: points to EMU (English Metric Units)
const PT_TO_EMU = 12700;

function pt(points) {
  return points * PT_TO_EMU;
}

/**
 * Resolve color reference to RGB object
 */
function resolveColor(color, themeColors) {
  if (typeof color === 'object') return color;
  if (themeColors && themeColors[color]) return themeColors[color];
  // Default colors
  const defaults = {
    white: { red: 1, green: 1, blue: 1 },
    black: { red: 0, green: 0, blue: 0 },
  };
  return defaults[color] || defaults.black;
}

/**
 * Create a text box on a slide
 */
function createTextBoxRequests(slideId, elementId, elem, themeColors) {
  const color = resolveColor(elem.color, themeColors);

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
          foregroundColor: { opaqueColor: { rgbColor: color } },
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

  // Load slide config
  if (!fs.existsSync(SLIDES_CONFIG_PATH)) {
    console.error('Error: pitch-deck.config.json not found');
    process.exit(1);
  }
  const config = JSON.parse(fs.readFileSync(SLIDES_CONFIG_PATH, 'utf-8'));
  const themeColors = config.theme?.colors || {};
  const SLIDES = config.slides;

  console.log(`Loaded ${SLIDES.length} slides from config\n`);

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
    const savedConfig = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));
    presentationId = savedConfig.presentationId;
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
      requestBody: { title: config.title || 'CrowdLeague Pitch Deck' }
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
      const bgColor = resolveColor(slide.background, themeColors);
      requests.push({
        updatePageProperties: {
          objectId: slideId,
          pageProperties: {
            pageBackgroundFill: {
              solidFill: { color: { rgbColor: bgColor } }
            }
          },
          fields: 'pageBackgroundFill'
        }
      });
    }

    // Add text elements
    slide.elements.forEach((elem, elemIndex) => {
      const elementId = `${slideId}_text_${elemIndex}`;
      requests.push(...createTextBoxRequests(slideId, elementId, elem, themeColors));
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
