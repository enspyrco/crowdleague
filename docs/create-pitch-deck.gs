/**
 * CrowdLeague Pitch Deck Generator
 *
 * To use:
 * 1. Go to https://script.google.com
 * 2. Create a new project
 * 3. Paste this entire script
 * 4. Run the createPitchDeck() function
 * 5. Authorize when prompted
 * 6. Find the new presentation in your Google Drive
 */

function createPitchDeck() {
  // Create a new presentation
  const presentation = SlidesApp.create('CrowdLeague Pitch Deck');
  const slides = presentation.getSlides();

  // Remove the default blank slide
  slides[0].remove();

  // Color scheme
  const DARK_BLUE = '#1a365d';
  const ACCENT_BLUE = '#3182ce';
  const WHITE = '#ffffff';
  const LIGHT_GRAY = '#f7fafc';

  // Slide 1: Title
  let slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  slide.getBackground().setSolidFill(DARK_BLUE);

  addTextBox(slide, 'CrowdLeague', 50, 150, 620, 80, 48, WHITE, true);
  addTextBox(slide, 'Find players. Find venues. Play more.', 50, 240, 620, 40, 24, ACCENT_BLUE, false);
  addTextBox(slide, 'Building the grassroots sports communities\nthat create champions', 50, 320, 620, 60, 18, WHITE, false);

  // Slide 2: The Problem
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'The Problem', 50, 30, 620, 50, 36, DARK_BLUE, true);
  addTextBox(slide, 'Young Australians are dropping out of sport', 50, 90, 620, 40, 24, ACCENT_BLUE, true);

  const problemText = `• 34% of young Australians want to quit organized sports

• Finding pickup games and connecting with players is fragmented

• Too much focus on performance, not enough on fun and social

The Gap: No single platform connects grassroots players with venues and each other.`;
  addTextBox(slide, problemText, 50, 150, 620, 250, 18, '#2d3748', false);

  // Slide 3: The Solution
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'The Solution', 50, 30, 620, 50, 36, DARK_BLUE, true);
  addTextBox(slide, 'CrowdLeague connects players with venues and each other', 50, 90, 620, 40, 20, ACCENT_BLUE, true);

  const solutionText = `🗺️  Discover Venues
     Interactive map with photos and facility details

👥  Build Your Crew
     Connect with players who share your interests

💬  Coordinate Play
     Message your crew, get notified when friends are playing

🏀  Grassroots-First
     Designed for casual players, not elite athletes`;
  addTextBox(slide, solutionText, 50, 150, 620, 250, 16, '#2d3748', false);

  // Slide 4: Market Opportunity
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'Market Opportunity', 50, 30, 620, 50, 36, DARK_BLUE, true);

  const marketText = `Australian Sports Tech Market

  2024 Market Size:     $632 million AUD
  2034 Projected:        $2.16 billion AUD
  Growth Rate:            13.1% CAGR

Participation Numbers

  • 90% of Australian adults participate in sports annually
  • 4.8 million Australians aged 0-14
  • 3.4 million Australians aged 15-24
  • Brisbane 2032 driving $7.1B+ investment`;
  addTextBox(slide, marketText, 50, 100, 620, 300, 16, '#2d3748', false);

  // Slide 5: Brisbane 2032
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  slide.getBackground().setSolidFill(DARK_BLUE);
  addTextBox(slide, 'Brisbane 2032 Olympics', 50, 30, 620, 50, 36, WHITE, true);
  addTextBox(slide, '"Today\'s teenagers are tomorrow\'s Olympic athletes"', 50, 90, 620, 40, 20, ACCENT_BLUE, false);

  const olympicsText = `Unprecedented grassroots investment:

  Games On! Program:     $250 million
  Go for Gold Fund:         $100 million
  Venue Infrastructure:    $7.1 billion

CrowdLeague builds the grassroots communities
that feed into Olympic pathways.`;
  addTextBox(slide, olympicsText, 50, 160, 620, 220, 18, WHITE, false);

  // Slide 6: Competition
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'Competitive Landscape', 50, 30, 620, 50, 36, DARK_BLUE, true);

  const compText = `Competitor          Focus                        Gap
─────────────────────────────────────────────────
OpenSports         Event registration      No venue discovery, US-focused
Strava                  Fitness tracking         Individual, not social play
Meetup                General events          Not sports-specific
Facebook            Community forums    Fragmented, not purpose-built

CrowdLeague Differentiators:
  ✓ Venue-first discovery
  ✓ Trusted crew network (not random strangers)
  ✓ Australian-built for Australian sports culture`;
  addTextBox(slide, compText, 50, 100, 620, 280, 14, '#2d3748', false);

  // Slide 7: Business Model
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'Business Model', 50, 30, 620, 50, 36, DARK_BLUE, true);

  const bizText = `Phase 1: Community Building (Current)
  • Free for all players
  • Build user base and venue database
  • Focus on Brisbane / South East Queensland

Phase 2: Venue Partnerships
  • Premium venue listings and booking integration
  • Commission on court/facility bookings
  • Event promotion and sponsored listings

Phase 3: Scale & Monetize
  • National expansion (Sydney, Melbourne, Perth)
  • B2B offerings for sports clubs
  • Sponsorship and targeted advertising`;
  addTextBox(slide, bizText, 50, 100, 620, 290, 15, '#2d3748', false);

  // Slide 8: Current Status
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'Current Status', 50, 30, 620, 50, 36, DARK_BLUE, true);
  addTextBox(slide, 'Product Ready', 50, 85, 620, 35, 22, ACCENT_BLUE, true);

  const statusText = `✓ Fully functional iOS and Android app
✓ Google & Apple Sign-In authentication
✓ Interactive venue map with photo uploads
✓ Player profiles and crew connections
✓ Real-time messaging between crew members
✓ Push notifications

Stage: Pre-Launch
Seeking funding for user acquisition and marketing

Next Milestones:
  1. Seed 100+ Brisbane venues
  2. Beta launch with 500+ users
  3. Partner with 3 state sporting organizations`;
  addTextBox(slide, statusText, 50, 130, 620, 270, 15, '#2d3748', false);

  // Slide 9: The Ask
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'The Ask', 50, 30, 620, 50, 36, DARK_BLUE, true);
  addTextBox(slide, 'Seeking: $50,000 - $100,000', 50, 85, 620, 35, 24, ACCENT_BLUE, true);

  const askText = `Use of Funds:

  Marketing & User Acquisition     40%
  Venue Database Seeding           30%
  Operations (18 months)               20%
  Contingency                                  10%

This Enables:
  • Launch with 100+ venues, 500+ users in Brisbane
  • Validate product-market fit
  • Build foundation for Series Seed
  • Establish state sporting body partnerships`;
  addTextBox(slide, askText, 50, 135, 620, 260, 15, '#2d3748', false);

  // Slide 10: Team
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  addTextBox(slide, 'Team', 50, 30, 620, 50, 36, DARK_BLUE, true);

  const teamText = `[Founder Name]
Founder & Developer

• [X] years software development experience
• Flutter & Firebase expertise
• Passionate recreational sports player
• Based in Brisbane, Queensland


Development accelerated with Claude Code AI assistance
• Rapid iteration and code review
• 24/7 development capability`;
  addTextBox(slide, teamText, 50, 100, 620, 280, 16, '#2d3748', false);

  // Slide 11: Vision
  slide = presentation.appendSlide(SlidesApp.PredefinedLayout.BLANK);
  slide.getBackground().setSolidFill(DARK_BLUE);
  addTextBox(slide, 'The Vision', 50, 30, 620, 50, 36, WHITE, true);

  const visionText = `By 2032, CrowdLeague will be:

• The platform young Australians use to find
  sports venues and players

• A key part of the Brisbane 2032 grassroots legacy

• Connecting communities across every new
  Olympic venue

• Helping the next generation stay connected to sport`;
  addTextBox(slide, visionText, 50, 100, 620, 200, 18, WHITE, false);

  addTextBox(slide, 'The Games are coming to Brisbane.\nLet\'s build the community that stays.', 50, 330, 620, 60, 20, ACCENT_BLUE, true);

  // Log the URL
  Logger.log('Presentation created: ' + presentation.getUrl());

  // Show a dialog with the link
  const ui = SlidesApp.getUi();
  ui.alert('Pitch Deck Created!',
           'Your presentation has been created.\n\nURL: ' + presentation.getUrl(),
           ui.ButtonSet.OK);

  return presentation.getUrl();
}

function addTextBox(slide, text, left, top, width, height, fontSize, color, bold) {
  const shape = slide.insertShape(SlidesApp.ShapeType.TEXT_BOX, left, top, width, height);
  const textRange = shape.getText();
  textRange.setText(text);

  const style = textRange.getTextStyle();
  style.setFontSize(fontSize);
  style.setForegroundColor(color);
  style.setBold(bold);
  style.setFontFamily('Arial');

  shape.setContentAlignment(SlidesApp.ContentAlignment.TOP);
}
