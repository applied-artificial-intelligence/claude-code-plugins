# Hello World Plugin

**Level**: Beginner
**Concepts**: Command structure, arguments, basic bash
**Time to Complete**: 5 minutes

## Overview

The simplest possible Claude Code plugin. Perfect for understanding the fundamental structure before building more complex functionality.

## What You'll Learn

- How plugin.json defines plugin metadata
- How command files combine Markdown and bash
- How to access user arguments
- Basic command execution flow

## Installation

### Option 1: Try It Directly (No Installation)

Since this is a learning example, you can run the command directly:

```bash
cd examples/hello-world
cat commands/hello.md | sed '1,/^```bash/d;/^```$/,$d' | bash
```

### Option 2: Install as Plugin

1. Add to your `.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "examples": {
      "source": {
        "source": "directory",
        "path": "/path/to/claude-code-plugins/examples"
      }
    }
  },
  "enabledPlugins": {
    "hello-world@examples": true
  }
}
```

2. Restart Claude Code or reload settings

3. Use the command:
```bash
/hello
/hello Alice
/hello "Team"
```

## File Structure

```
hello-world/
├── .claude-plugin/
│   └── plugin.json        # Plugin metadata
├── commands/
│   └── hello.md           # The /hello command
└── README.md              # This file
```

## Plugin.json Explained

```json
{
  "name": "hello-world",           // Plugin identifier
  "version": "1.0.0",              // Semantic versioning
  "description": "...",             // Short plugin description
  "commands": ["commands/*.md"],    // Glob pattern for command files
  "capabilities": {                 // What the plugin can do
    "greeting": {
      "description": "...",
      "command": "hello"            // Maps to /hello
    }
  }
}
```

**Key Points**:
- `name` is used as plugin identifier in settings
- `commands` uses glob patterns to find command files
- `capabilities` describes what the plugin does (used for discovery)

## Command File Explained

**Structure**:
1. **Frontmatter** (YAML between `---`):
   - Provides command metadata
   - Accessed by plugin system

2. **Documentation** (Markdown):
   - Explains what the command does
   - Shows usage examples
   - Provides context

3. **Implementation** (Bash in code blocks):
   - Executed when command runs
   - Has access to `$ARGUMENTS` variable
   - Runs in project directory

## Execution Flow

```
User types: /hello Alice
    ↓
Claude Code reads: hello.md
    ↓
Extracts bash from markdown
    ↓
Sets $ARGUMENTS = "Alice"
    ↓
Executes bash in project directory
    ↓
Output displayed to user
```

## Customization Ideas

Try modifying this example to:

1. **Add a timestamp**: Show when hello was called
2. **Read from a config file**: Personalize the greeting
3. **Use colors**: Add ANSI colors to output
4. **Add validation**: Check if name is provided
5. **Create a log**: Record greetings to a file

### Example: Add Timestamp

```bash
#!/bin/bash
USER_NAME="${ARGUMENTS:-World}"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "🎉 Hello, ${USER_NAME}!"
echo "Time: $TIMESTAMP"
```

## Next Examples

Once you understand hello-world:

1. **task-tracker** (Intermediate):
   - File-based state management
   - JSON data handling
   - List/add/complete workflows

2. **code-formatter** (Advanced):
   - Integration with external tools
   - Agent usage
   - Error handling patterns

## Common Beginner Questions

### Q: Why Markdown for commands?
**A**: Markdown allows documentation and code in one file. Claude can read the docs to understand context when helping you use commands.

### Q: Can commands have multiple bash blocks?
**A**: Yes, all bash blocks are concatenated and executed together.

### Q: Where do commands execute?
**A**: In the project directory where Claude Code is running, not in `~/.claude/commands/`.

### Q: How do I debug command execution?
**A**: Add `echo "DEBUG: ..."` statements or check stdout/stderr in Claude's response.

### Q: Can I use other languages?
**A**: Yes! You can execute Python, Node.js, etc. from bash:
```bash
#!/bin/bash
python3 << 'PYTHON'
print(f"Hello from Python!")
PYTHON
```

## Resources

- [First Plugin Tutorial](../../docs/getting-started/first-plugin.md)
- [Design Principles](../../docs/architecture/design-principles.md)
- [Plugin Patterns](../../docs/architecture/patterns.md)

---

**Start Here** → **Understand Basics** → **Move to task-tracker** → **Build Your Own**
