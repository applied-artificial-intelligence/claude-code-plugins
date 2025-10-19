# GitHub Pages Setup Guide

This guide explains how to enable and maintain the GitHub Pages documentation site for Claude Code Plugins.

## Current Setup

**Documentation Site**: https://applied-artificial-intelligence.github.io/claude-code-plugins/

**Source**: `/docs` directory on `main` branch

**Theme**: [Just the Docs](https://just-the-docs.com/) v0.8.2 (clean, documentation-focused)

## Enabling GitHub Pages (One-Time Setup)

### Via GitHub Web Interface

1. Go to repository: https://github.com/applied-artificial-intelligence/claude-code-plugins
2. Click **Settings** tab
3. Navigate to **Pages** (left sidebar)
4. Under **Source**:
   - Branch: `main`
   - Folder: `/docs`
   - Click **Save**
5. Wait 1-2 minutes for initial build
6. Site will be live at: `https://applied-artificial-intelligence.github.io/claude-code-plugins/`

### Via GitHub CLI (Alternative)

```bash
gh repo edit --enable-pages --pages-branch main --pages-path /docs
```

## Local Development

### Prerequisites

- Ruby 3.x
- Bundler

### Setup

```bash
cd docs/

# Install dependencies
bundle install

# Run local server
bundle exec jekyll serve

# Open in browser
open http://localhost:4000/claude-code-plugins/
```

### Live Reload

Jekyll watches for file changes and automatically rebuilds. Just refresh your browser to see updates.

## File Structure

```
docs/
├── _config.yml              # Jekyll configuration
├── index.md                 # Landing page (home)
├── Gemfile                  # Ruby dependencies
├── getting-started/         # Installation and tutorials
├── guides/                  # How-to guides
├── reference/               # Command and API reference
├── architecture/            # Design principles and patterns
└── development/             # Contributor documentation
```

## Adding New Pages

### Create Markdown File

```markdown
---
layout: default
title: Your Page Title
nav_order: 5
parent: Parent Section
---

# Your Page Title

Content here...
```

### Navigation Order

- `nav_order`: Controls position in sidebar (lower numbers appear first)
- `parent`: Groups pages under sections
- `has_children`: Set to `true` for parent pages

### Example

```markdown
---
layout: default
title: Memory Management
nav_order: 3
parent: Guides
---

# Memory Management Guide

...
```

## Updating Documentation

### Standard Workflow

1. Edit markdown files in `docs/`
2. Test locally: `bundle exec jekyll serve`
3. Commit and push to `main`
4. GitHub Actions builds and deploys automatically (2-3 minutes)
5. Check live site: https://applied-artificial-intelligence.github.io/claude-code-plugins/

### Quick Edits

For typos or small changes, edit directly on GitHub:
1. Navigate to file on github.com
2. Click pencil icon (Edit)
3. Make changes
4. Commit directly to `main`
5. Auto-deploys in 2-3 minutes

## Theme Customization

### Colors

Edit `_config.yml`:
```yaml
color_scheme: dark  # or light, or custom
```

### Custom CSS

Create `docs/assets/css/custom.css`:
```css
/* Your custom styles */
```

Reference in `_config.yml`:
```yaml
custom_css:
  - assets/css/custom.css
```

### Logo

1. Add logo image to `docs/assets/images/logo.png`
2. Already referenced in `_config.yml`:
   ```yaml
   logo: "/assets/images/logo.png"
   ```

## Search

Search is **enabled by default** and indexes:
- Page titles
- Headings (h2 level)
- Page content

No configuration needed - it just works.

## Analytics (Optional)

To add Google Analytics:

1. Get GA tracking ID
2. Add to `_config.yml`:
   ```yaml
   ga_tracking: UA-XXXXXXXXX-X
   # or for GA4:
   ga_tracking: G-XXXXXXXXXX
   ```

## Custom Domain (Optional)

To use custom domain (e.g., docs.applied-ai.com):

1. Add `CNAME` file to `docs/`:
   ```
   docs.applied-ai.com
   ```

2. Configure DNS:
   - Type: `CNAME`
   - Name: `docs`
   - Value: `applied-artificial-intelligence.github.io`

3. Update `_config.yml`:
   ```yaml
   url: "https://docs.applied-ai.com"
   baseurl: ""
   ```

## Troubleshooting

### Build Failures

Check GitHub Actions:
1. Go to **Actions** tab
2. Click latest workflow run
3. Review build logs

Common issues:
- **Liquid syntax errors**: Check template tags
- **YAML frontmatter errors**: Validate YAML syntax
- **Broken links**: Use relative paths

### Local Build Issues

```bash
# Clear Jekyll cache
rm -rf docs/_site docs/.jekyll-cache

# Reinstall gems
cd docs/
bundle install --force

# Retry
bundle exec jekyll serve
```

### Page Not Updating

1. Hard refresh browser (Ctrl+Shift+R / Cmd+Shift+R)
2. Check GitHub Actions - build might have failed
3. Verify changes committed and pushed
4. Wait 2-3 minutes for deployment

## Best Practices

### Writing Documentation

- ✅ **Use clear headings** - h2 for sections, h3 for subsections
- ✅ **Code examples** - Syntax highlighting with triple backticks
- ✅ **Navigation hints** - Link to related pages
- ✅ **Screenshots** - Store in `assets/images/`
- ✅ **Keep it concise** - Developers skim, not read

### Organization

- ✅ **Group related content** - Use parent/child relationships
- ✅ **Logical nav_order** - Most important pages first
- ✅ **Consistent naming** - kebab-case for filenames
- ✅ **One topic per page** - Better than mega-pages

### Maintenance

- ✅ **Review quarterly** - Keep docs current with codebase
- ✅ **Fix broken links** - Test periodically
- ✅ **Update screenshots** - When UI changes
- ✅ **Archive old versions** - In separate sections

## Resources

- **Just the Docs Documentation**: https://just-the-docs.com/
- **Jekyll Documentation**: https://jekyllrb.com/docs/
- **GitHub Pages Documentation**: https://docs.github.com/en/pages
- **Markdown Guide**: https://www.markdownguide.org/

---

**Maintained by**: Applied AI Team
**Last Updated**: 2025-10-19
