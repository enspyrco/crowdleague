#!/usr/bin/env node
/**
 * CrowdLeague Notion Sync Tool
 *
 * Fetches content from Notion pages and converts to markdown/JSON.
 *
 * Usage:
 *   npm run sync                    # Sync all configured pages
 *   npm run fetch -- --page=PAGE_ID # Fetch a specific page as JSON
 *   npm run list                    # List pages in the workspace
 */

import { Client } from '@notionhq/client';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const CONFIG_PATH = path.join(__dirname, '.config.json');
const CACHE_DIR = path.join(__dirname, '.cache');

// Initialize Notion client
function getNotionClient() {
  const apiKey = process.env.NOTION_API_KEY;
  if (!apiKey) {
    console.error('Error: NOTION_API_KEY environment variable is required');
    console.error('Get your API key from: https://www.notion.so/my-integrations');
    process.exit(1);
  }
  return new Client({ auth: apiKey });
}

/**
 * Convert Notion rich text to plain text
 */
function richTextToPlain(richText) {
  if (!richText) return '';
  return richText.map(t => t.plain_text).join('');
}

/**
 * Convert Notion rich text to markdown
 */
function richTextToMarkdown(richText) {
  if (!richText) return '';
  return richText.map(t => {
    let text = t.plain_text;
    if (t.annotations.bold) text = `**${text}**`;
    if (t.annotations.italic) text = `*${text}*`;
    if (t.annotations.strikethrough) text = `~~${text}~~`;
    if (t.annotations.code) text = `\`${text}\``;
    if (t.href) text = `[${text}](${t.href})`;
    return text;
  }).join('');
}

/**
 * Convert a Notion block to markdown
 */
function blockToMarkdown(block, indent = '') {
  const type = block.type;
  const content = block[type];

  switch (type) {
    case 'paragraph':
      return richTextToMarkdown(content.rich_text) + '\n';

    case 'heading_1':
      return `# ${richTextToMarkdown(content.rich_text)}\n`;

    case 'heading_2':
      return `## ${richTextToMarkdown(content.rich_text)}\n`;

    case 'heading_3':
      return `### ${richTextToMarkdown(content.rich_text)}\n`;

    case 'bulleted_list_item':
      return `${indent}- ${richTextToMarkdown(content.rich_text)}\n`;

    case 'numbered_list_item':
      return `${indent}1. ${richTextToMarkdown(content.rich_text)}\n`;

    case 'to_do':
      const checkbox = content.checked ? '[x]' : '[ ]';
      return `${indent}- ${checkbox} ${richTextToMarkdown(content.rich_text)}\n`;

    case 'toggle':
      return `<details>\n<summary>${richTextToMarkdown(content.rich_text)}</summary>\n\n</details>\n`;

    case 'code':
      const lang = content.language || '';
      return `\`\`\`${lang}\n${richTextToPlain(content.rich_text)}\n\`\`\`\n`;

    case 'quote':
      return `> ${richTextToMarkdown(content.rich_text)}\n`;

    case 'callout':
      const emoji = content.icon?.emoji || '';
      return `> ${emoji} ${richTextToMarkdown(content.rich_text)}\n`;

    case 'divider':
      return '---\n';

    case 'image':
      const url = content.type === 'external' ? content.external.url : content.file.url;
      const caption = content.caption ? richTextToPlain(content.caption) : 'image';
      return `![${caption}](${url})\n`;

    case 'bookmark':
      return `[${content.url}](${content.url})\n`;

    case 'link_preview':
      return `[${content.url}](${content.url})\n`;

    case 'table':
      return '[Table - not yet supported]\n';

    case 'child_page':
      return `**[${content.title}]**\n`;

    case 'child_database':
      return `**[Database: ${content.title}]**\n`;

    default:
      return `[${type} block]\n`;
  }
}

/**
 * Fetch all blocks from a page (handles pagination)
 */
async function fetchAllBlocks(notion, blockId) {
  const blocks = [];
  let cursor;

  do {
    const response = await notion.blocks.children.list({
      block_id: blockId,
      start_cursor: cursor,
      page_size: 100,
    });

    blocks.push(...response.results);
    cursor = response.has_more ? response.next_cursor : null;
  } while (cursor);

  // Recursively fetch children for blocks that have them
  for (const block of blocks) {
    if (block.has_children) {
      block.children = await fetchAllBlocks(notion, block.id);
    }
  }

  return blocks;
}

/**
 * Convert blocks to markdown recursively
 */
function blocksToMarkdown(blocks, indent = '') {
  let markdown = '';

  for (const block of blocks) {
    markdown += blockToMarkdown(block, indent);

    if (block.children) {
      markdown += blocksToMarkdown(block.children, indent + '  ');
    }
  }

  return markdown;
}

/**
 * Fetch a page and its content
 */
async function fetchPage(notion, pageId) {
  console.log(`Fetching page: ${pageId}`);

  // Get page metadata
  const page = await notion.pages.retrieve({ page_id: pageId });

  // Get page title
  let title = 'Untitled';
  if (page.properties.title) {
    title = richTextToPlain(page.properties.title.title);
  } else if (page.properties.Name) {
    title = richTextToPlain(page.properties.Name.title);
  }

  // Get page content (blocks)
  const blocks = await fetchAllBlocks(notion, pageId);

  return { page, title, blocks };
}

/**
 * Save page as JSON
 */
function saveAsJson(data, filename) {
  if (!fs.existsSync(CACHE_DIR)) {
    fs.mkdirSync(CACHE_DIR, { recursive: true });
  }
  const filepath = path.join(CACHE_DIR, filename);
  fs.writeFileSync(filepath, JSON.stringify(data, null, 2));
  console.log(`Saved: ${filepath}`);
  return filepath;
}

/**
 * Save page as Markdown
 */
function saveAsMarkdown(title, blocks, filename) {
  const markdown = `# ${title}\n\n${blocksToMarkdown(blocks)}`;
  const filepath = path.join(CACHE_DIR, filename);
  if (!fs.existsSync(CACHE_DIR)) {
    fs.mkdirSync(CACHE_DIR, { recursive: true });
  }
  fs.writeFileSync(filepath, markdown);
  console.log(`Saved: ${filepath}`);
  return filepath;
}

/**
 * List pages the integration has access to
 */
async function listPages(notion) {
  console.log('Searching for pages...\n');

  const response = await notion.search({
    filter: { property: 'object', value: 'page' },
    page_size: 50,
  });

  if (response.results.length === 0) {
    console.log('No pages found. Make sure you have shared pages with your integration.');
    console.log('To share: Open page in Notion → Share → Invite → Select your integration');
    return;
  }

  console.log('Pages accessible to this integration:\n');
  for (const page of response.results) {
    let title = 'Untitled';
    if (page.properties.title) {
      title = richTextToPlain(page.properties.title.title);
    } else if (page.properties.Name) {
      title = richTextToPlain(page.properties.Name.title);
    }

    // Extract page ID without hyphens for easier use
    const shortId = page.id.replace(/-/g, '');
    console.log(`  ${title}`);
    console.log(`    ID: ${shortId}`);
    console.log(`    URL: ${page.url}`);
    console.log('');
  }
}

/**
 * Main function
 */
async function main() {
  const args = process.argv.slice(2);
  const notion = getNotionClient();

  // List pages
  if (args.includes('--list')) {
    await listPages(notion);
    return;
  }

  // Fetch specific page
  const pageArg = args.find(a => a.startsWith('--page='));
  if (pageArg || args.includes('--fetch')) {
    const pageId = pageArg ? pageArg.split('=')[1] : args[args.indexOf('--fetch') + 1];

    if (!pageId) {
      console.error('Error: Please provide a page ID');
      console.error('Usage: npm run fetch -- --page=PAGE_ID');
      process.exit(1);
    }

    const { page, title, blocks } = await fetchPage(notion, pageId);

    // Save both JSON and Markdown
    const safeTitle = title.replace(/[^a-z0-9]/gi, '-').toLowerCase();
    saveAsJson({ page, blocks }, `${safeTitle}.json`);
    saveAsMarkdown(title, blocks, `${safeTitle}.md`);

    console.log(`\nFetched: "${title}"`);
    return;
  }

  // Default: sync configured pages
  console.log('CrowdLeague Notion Sync\n');

  if (fs.existsSync(CONFIG_PATH)) {
    const config = JSON.parse(fs.readFileSync(CONFIG_PATH, 'utf-8'));

    if (config.pages && config.pages.length > 0) {
      for (const pageConfig of config.pages) {
        const { page, title, blocks } = await fetchPage(notion, pageConfig.id);
        const outputPath = pageConfig.output || path.join(CACHE_DIR, `${pageConfig.id}.md`);

        const markdown = `# ${title}\n\n${blocksToMarkdown(blocks)}`;
        fs.writeFileSync(outputPath, markdown);
        console.log(`Synced: ${title} → ${outputPath}`);
      }
      return;
    }
  }

  // No config, show help
  console.log('No pages configured. Options:\n');
  console.log('  1. List available pages:');
  console.log('     npm run list\n');
  console.log('  2. Fetch a specific page:');
  console.log('     npm run fetch -- --page=PAGE_ID\n');
  console.log('  3. Configure pages to sync in .config.json:');
  console.log('     {');
  console.log('       "pages": [');
  console.log('         { "id": "PAGE_ID", "output": "../docs/wiki.md" }');
  console.log('       ]');
  console.log('     }');
}

main().catch(err => {
  console.error('Error:', err.message);
  if (err.code === 'unauthorized') {
    console.error('\nMake sure your NOTION_API_KEY is valid.');
  }
  if (err.code === 'object_not_found') {
    console.error('\nPage not found. Make sure the page is shared with your integration.');
  }
  process.exit(1);
});
