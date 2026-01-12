# CrowdLeague Notion Sync

Syncs content from Notion pages to local markdown/JSON files.

## Setup

### 1. Create a Notion Integration

1. Go to [My Integrations](https://www.notion.so/my-integrations)
2. Click "New integration"
3. Name it (e.g., "CrowdLeague Sync")
4. Select your workspace
5. Copy the "Internal Integration Token" (starts with `secret_`)

### 2. Share Pages with Your Integration

For each Notion page you want to sync:

1. Open the page in Notion
2. Click "Share" (top right)
3. Click "Invite"
4. Select your integration from the list

### 3. Create .env File

Create a `.env` file in this directory:

```bash
echo 'NOTION_API_KEY=secret_your_token_here' > .env
```

The `.env` file is gitignored and loaded automatically by the npm scripts.

### 4. Install Dependencies

```bash
cd tools/notion-sync
npm install
```

## Usage

### List Available Pages

See all pages shared with your integration:

```bash
npm run list
```

### Fetch a Specific Page

Fetch a page and save as both JSON and Markdown:

```bash
npm run fetch -- --page=PAGE_ID
```

The page ID is the long string in the Notion URL:
`https://notion.so/Your-Page-Title-abc123def456` → `abc123def456`

Files are saved to `.cache/`:
- `page-title.json` - Full page data with blocks
- `page-title.md` - Converted markdown

### Configure Auto-Sync

Create `.config.json` to define pages to sync:

```json
{
  "pages": [
    {
      "id": "abc123def456",
      "output": "../../docs/wiki-page.md"
    },
    {
      "id": "xyz789ghi012",
      "output": "../../docs/another-page.md"
    }
  ]
}
```

Then run:

```bash
npm run sync
```

## Supported Block Types

- Paragraphs, headings (1-3)
- Bulleted and numbered lists
- To-do items (checkboxes)
- Code blocks (with language)
- Quotes and callouts
- Dividers
- Images (external and uploaded)
- Bookmarks and link previews
- Toggle blocks
- Nested content

## Output Formats

### JSON

Full Notion API response including:
- Page metadata (id, created_time, last_edited_time, etc.)
- All blocks with their properties
- Nested children blocks

### Markdown

Converted markdown with:
- Headings preserved
- Rich text formatting (bold, italic, code, links)
- Lists and checkboxes
- Code blocks with syntax highlighting hints
- Images as markdown image syntax

## Troubleshooting

### "unauthorized" error

Your API key is invalid or expired. Generate a new one at https://www.notion.so/my-integrations

### "object_not_found" error

The page hasn't been shared with your integration. Open the page in Notion → Share → Invite → Select your integration.

### No pages found

Make sure you've shared at least one page with your integration. Parent pages don't automatically share children - each page needs to be shared individually (or share the parent database/page to include all children).
