---
description: Say hello and demonstrate basic command structure
tags: [example, tutorial]
---

# Hello Command

Demonstrates the minimal structure of a Claude Code command.

## What This Example Shows

- Basic command file format (Markdown with frontmatter)
- Simple bash script execution
- User argument handling
- Output formatting

## Implementation

```bash
#!/bin/bash

# Get user's name from arguments (or use default)
USER_NAME="${ARGUMENTS:-World}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Hello, ${USER_NAME}!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This is a minimal Claude Code plugin example."
echo ""
echo "What you're seeing:"
echo "  • A command defined in commands/hello.md"
echo "  • Frontmatter with metadata (description, tags)"
echo "  • Bash script implementation"
echo "  • User argument access via \$ARGUMENTS"
echo ""
echo "Key Concepts:"
echo "  ✓ Commands are Markdown files with embedded bash"
echo "  ✓ Frontmatter provides metadata for plugin system"
echo "  ✓ Scripts execute in project directory context"
echo "  ✓ $ARGUMENTS variable passes user input"
echo ""
echo "Try it:"
echo "  /hello              # Uses default 'World'"
echo "  /hello Alice        # Says hello to Alice"
echo "  /hello \"Team\"      # Says hello to Team"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

## Usage

```bash
# Basic usage
/hello

# With custom name
/hello Alice

# With multiple words (use quotes)
/hello "Development Team"
```

## Learning Points

### 1. File Structure
```
hello-world/
├── .claude-plugin/
│   └── plugin.json        # Plugin metadata and configuration
└── commands/
    └── hello.md           # This command file
```

### 2. Frontmatter
The YAML block at the top provides metadata:
- `description`: What the command does
- `tags`: Categorization for discovery

### 3. Bash Implementation
Everything after the frontmatter is executed as a bash script when the command runs.

### 4. Arguments
Access user arguments via `$ARGUMENTS` environment variable.

### 5. Execution Context
- Commands run in the **project directory**, not in `~/.claude/commands/`
- Each invocation starts fresh (stateless)
- No persistent process or background execution

## Next Steps

After understanding this basic example:

1. **Explore task-tracker** - See state management with JSON files
2. **Explore code-formatter** - See agent integration and external tools
3. **Create your own** - Use this as a template for custom commands

## Common Patterns

### Error Handling
```bash
if [ -z "$REQUIRED_ARG" ]; then
    echo "ERROR: Missing required argument" >&2
    exit 1
fi
```

### Checking Tools
```bash
if ! command -v jq >/dev/null 2>&1; then
    echo "WARNING: jq not installed, using fallback" >&2
fi
```

### File Operations
```bash
if [ ! -f "config.json" ]; then
    echo '{"setting": "value"}' > config.json
fi
```

## Resources

- [Plugin Development Guide](../../docs/getting-started/first-plugin.md)
- [Design Principles](../../docs/architecture/design-principles.md)
- [Command Template](../../plugins/core/README.md)

---

**Example Plugin** | Version 1.0.0 | MIT License
