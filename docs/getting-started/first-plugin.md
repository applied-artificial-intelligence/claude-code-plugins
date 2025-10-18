# Creating Your First Plugin

Learn how to build a custom Claude Code plugin from scratch in 30 minutes. This hands-on tutorial walks you through creating, testing, and publishing a working plugin.

## What You'll Build

A simple "hello-world" plugin that demonstrates:
- Plugin structure and configuration
- Command creation with parameters
- Agent creation for specialized tasks
- Local testing and debugging
- Publishing to a marketplace

**Result**: A working plugin you can use and share

## Prerequisites

Before starting, ensure you have:

- ✅ Claude Code v3.0+ installed
- ✅ Basic familiarity with Claude Code (try the [Quick Start](quick-start.md) first)
- ✅ Text editor for writing markdown
- ✅ Git installed (for version control and publishing)
- ✅ 30 minutes of focused time

## Plugin Architecture Overview

A Claude Code plugin has this structure:

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json        # Required: Plugin manifest
├── commands/              # Optional: Slash commands
│   ├── greet.md
│   └── farewell.md
├── agents/                # Optional: Specialized agents
│   └── translator.md
├── hooks/                 # Optional: Event handlers
│   └── pre-commit.sh
├── .mcp.json             # Optional: MCP server config
└── README.md             # Recommended: Documentation
```

**Key Concepts**:
- **plugin.json**: Defines plugin metadata, capabilities, and what it provides
- **commands/**: Markdown files that become `/command-name` slash commands
- **agents/**: Specialized AI agents that perform focused tasks
- **hooks/**: Scripts that run on specific events (git hooks, tool hooks)

---

## Step 1: Create Plugin Structure (5 minutes)

### Create the Directory

Choose a location for your plugin development:

```bash
# Create plugin directory
mkdir -p ~/my-plugins/hello-world
cd ~/my-plugins/hello-world

# Create required structure
mkdir -p .claude-plugin
mkdir -p commands
mkdir -p agents

# Verify structure
tree -L 2
# Should show:
# .
# ├── .claude-plugin/
# ├── commands/
# └── agents/
```

### Create plugin.json

The manifest file tells Claude Code about your plugin.

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "hello-world",
  "version": "1.0.0",
  "description": "A simple hello-world plugin demonstrating Claude Code plugin basics",
  "author": "Your Name",
  "keywords": ["tutorial", "example", "hello-world"],
  "commands": ["commands/*.md"],
  "agents": ["agents/*.md"],
  "settings": {
    "defaultEnabled": false,
    "category": "tutorial"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/yourusername/hello-world-plugin"
  },
  "license": "MIT",
  "capabilities": {
    "greeting": {
      "description": "Personalized greetings",
      "command": "greet"
    },
    "translation": {
      "description": "Simple text translation",
      "agent": "translator"
    }
  },
  "dependencies": {},
  "mcpTools": {
    "optional": [],
    "gracefulDegradation": true
  }
}
```

**Field Explanations**:
- **name**: Unique identifier (lowercase, hyphens, no spaces)
- **version**: Semantic versioning (MAJOR.MINOR.PATCH)
- **commands**: Glob pattern for command files
- **agents**: Glob pattern for agent files
- **capabilities**: What your plugin provides (for documentation)
- **mcpTools**: Optional MCP tool dependencies

---

## Step 2: Create Your First Command (10 minutes)

Commands are markdown files with frontmatter and implementation.

### Command Structure

Create `commands/greet.md`:

```markdown
---
name: greet
description: Greet the user with a personalized message
allowed-tools: [Bash]
argument-hint: "[name] [--formal]"
---

# Greet Command

I'll greet you with a personalized message!

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Parse arguments
NAME="${1:-World}"
FORMAL=false

# Check for --formal flag
for arg in "$@"; do
    if [[ "$arg" == "--formal" ]]; then
        FORMAL=true
    fi
done

# Generate greeting
if [ "$FORMAL" = true ]; then
    echo "Good day, ${NAME}! It is a pleasure to make your acquaintance."
else
    echo "Hey ${NAME}! 👋 Great to see you!"
fi

# Show usage tip
echo ""
echo "💡 Tip: Use '/greet YourName --formal' for a formal greeting"
```
```

**Key Elements**:

1. **Frontmatter** (YAML between `---` markers):
   - `name`: Command name (becomes `/greet`)
   - `description`: Short description for help text
   - `allowed-tools`: Which Claude tools the command can use
   - `argument-hint`: Shown in help text

2. **Documentation Section**:
   - Explain what the command does
   - Use `$ARGUMENTS` to show user input

3. **Implementation**:
   - Bash script inside triple backticks
   - Must be self-contained (no external scripts)
   - Handle arguments gracefully

### Create a Second Command

Create `commands/farewell.md`:

```markdown
---
name: farewell
description: Say goodbye with style
allowed-tools: [Bash]
argument-hint: "[name]"
---

# Farewell Command

I'll say goodbye in a memorable way!

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

NAME="${1:-friend}"

# Random farewell style
STYLES=("See you later, ${NAME}! 🚀"
        "Farewell, ${NAME}! Until next time! 👋"
        "Goodbye, ${NAME}! Happy coding! 💻"
        "Catch you on the flip side, ${NAME}! ✨")

# Pick random style
RANDOM_INDEX=$(( RANDOM % ${#STYLES[@]} ))
echo "${STYLES[$RANDOM_INDEX]}"
```
```

---

## Step 3: Create a Specialized Agent (8 minutes)

Agents are AI assistants with focused responsibilities.

### Agent Structure

Create `agents/translator.md`:

```markdown
---
name: translator
description: Translate text between languages using AI understanding
capabilities: ["text-translation", "language-detection"]
allowed-tools: [Bash]
---

# Translator Agent

You are a specialized translation agent with expertise in multiple languages.

## Your Role

- Translate text accurately between languages
- Detect source language automatically if not specified
- Maintain tone and context during translation
- Explain cultural nuances when relevant

## Guidelines

1. **Accuracy First**: Prioritize correct translation over literal word-for-word
2. **Context Matters**: Consider context to choose appropriate translations
3. **Tone Preservation**: Maintain the original tone (formal, casual, technical)
4. **Cultural Sensitivity**: Note when direct translation loses cultural meaning

## Task Format

When invoked, you will receive:
- **Text**: The text to translate
- **Target Language**: Language to translate to
- **Source Language**: (Optional) Source language

## Example Invocation

User: "Translate 'Hello, how are you?' to Spanish"

You respond:
```
Translation: "Hola, ¿cómo estás?"

Notes:
- Informal "tú" form used (casual tone)
- For formal context, use "Hola, ¿cómo está?"
- Cultural note: Spanish greetings often include physical gestures
```

## Response Format

Always structure your response as:

```
Translation: [translated text]

Notes:
- [Any relevant context]
- [Alternative translations if applicable]
- [Cultural or usage notes]
```

## Limitations

- Cannot translate images or audio
- May need clarification for ambiguous phrases
- Cultural idioms may require explanation rather than direct translation
```

**Agent Best Practices**:
- Define clear role and responsibilities
- Provide concrete guidelines
- Show example interactions
- Specify response format
- State limitations clearly

---

## Step 4: Test Your Plugin Locally (5 minutes)

### Configure Claude Code Settings

Add your plugin to `.claude/settings.json` (create if doesn't exist):

```json
{
  "extraKnownMarketplaces": {
    "my-local-plugins": {
      "source": {
        "source": "directory",
        "path": "/home/youruser/my-plugins"
      }
    }
  },
  "enabledPlugins": {
    "hello-world@my-local-plugins": true
  }
}
```

**Important**: Use **absolute path** (not `~/` or relative paths).

### Restart Claude Code

Close and reopen Claude Code to load your plugin.

### Test Your Commands

```bash
# Test the greet command
/greet Alice

# Expected output:
# Hey Alice! 👋 Great to see you!
#
# 💡 Tip: Use '/greet YourName --formal' for a formal greeting

# Test formal greeting
/greet Bob --formal

# Expected output:
# Good day, Bob! It is a pleasure to make your acquaintance.
#
# 💡 Tip: Use '/greet YourName --formal' for a formal greeting

# Test farewell
/farewell Charlie

# Expected output (random):
# See you later, Charlie! 🚀
```

### Test Your Agent

In Claude Code, invoke the agent:

```
Use the translator agent to translate "Good morning" to French
```

Claude should use your translator agent and provide a structured translation.

### Verify Plugin Loading

Check that your plugin is recognized:

```bash
/help
```

You should see `/greet` and `/farewell` listed in available commands.

---

## Step 5: Add Documentation (2 minutes)

Create `README.md` in your plugin root:

```markdown
# Hello World Plugin

A simple tutorial plugin demonstrating Claude Code plugin basics.

## Features

- `/greet [name] [--formal]` - Personalized greetings
- `/farewell [name]` - Random farewell messages
- `translator` agent - Text translation with cultural context

## Installation

Add to your `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "hello-world": {
      "source": {
        "source": "github",
        "repo": "yourusername/hello-world-plugin"
      }
    }
  },
  "enabledPlugins": {
    "hello-world@hello-world": true
  }
}
```

Restart Claude Code.

## Usage

### Commands

```bash
# Basic greeting
/greet Alice

# Formal greeting
/greet Bob --formal

# Say goodbye
/farewell Charlie
```

### Agents

Ask Claude to use the translator agent:

```
Use the translator agent to translate this to Spanish: "Welcome to Claude Code"
```

## Development

This plugin was created following the [First Plugin Tutorial](https://github.com/applied-artificial-intelligence/claude-code-plugins/blob/main/docs/getting-started/first-plugin.md).

## License

MIT
```

---

## Step 6: Publish to GitHub (Optional)

### Initialize Git Repository

```bash
cd ~/my-plugins/hello-world

# Initialize git
git init

# Create .gitignore
cat > .gitignore << 'EOF'
# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# Temp files
*.tmp
*.log
EOF

# Initial commit
git add .
git commit -m "feat: Initial hello-world plugin

- Add greet and farewell commands
- Add translator agent
- Complete plugin.json manifest
- Add README documentation
"
```

### Push to GitHub

```bash
# Create repo on GitHub first, then:
git remote add origin https://github.com/yourusername/hello-world-plugin.git
git branch -M main
git push -u origin main
```

### Tag Your Release

```bash
# Create version tag
git tag -a v1.0.0 -m "Release v1.0.0: Initial hello-world plugin"
git push origin v1.0.0
```

### Share Your Plugin

Now others can install your plugin using:

```json
{
  "extraKnownMarketplaces": {
    "hello-world": {
      "source": {
        "source": "github",
        "repo": "yourusername/hello-world-plugin"
      }
    }
  },
  "enabledPlugins": {
    "hello-world@hello-world": true
  }
}
```

---

## Common Pitfalls and Debugging

### Plugin Not Loading

**Symptom**: Commands not available after restart

**Solutions**:

1. **Check plugin.json syntax**
   ```bash
   # Validate JSON
   jq . .claude-plugin/plugin.json
   # Should output formatted JSON with no errors
   ```

2. **Verify marketplace path**
   ```bash
   # Check path in settings.json
   cat ~/.claude/settings.json | jq '.extraKnownMarketplaces'

   # Verify directory exists and has correct structure
   ls -la /path/to/your/plugin/.claude-plugin/
   # Should show plugin.json
   ```

3. **Check plugin name format**
   - Use lowercase with hyphens only
   - No spaces, underscores, or special characters
   - Example: `hello-world` ✅, `Hello_World` ❌

### Commands Not Working

**Symptom**: Command runs but produces errors

**Solutions**:

1. **Check frontmatter format**
   ```markdown
   ---
   name: greet
   description: Greet the user
   allowed-tools: [Bash]
   ---
   ```
   - Must have three dashes `---` above and below
   - YAML syntax (colon after key, space before value)
   - List syntax for arrays: `[Tool1, Tool2]`

2. **Verify bash script syntax**
   ```bash
   # Extract and test bash section
   # Copy the implementation code to test.sh
   bash -n test.sh
   # Should show no syntax errors
   ```

3. **Check allowed-tools**
   - Command uses Bash but frontmatter doesn't allow it
   - Add `allowed-tools: [Bash]` to frontmatter

### Agent Not Being Invoked

**Symptom**: Claude doesn't use your agent

**Solutions**:

1. **Be explicit in invocation**
   ```
   ❌ "Translate this to French"
   ✅ "Use the translator agent to translate this to French"
   ```

2. **Check agent name**
   - Agent file: `agents/translator.md`
   - Name in frontmatter: `name: translator`
   - Both must match

3. **Verify agent is listed in plugin.json**
   ```json
   "agents": ["agents/*.md"]
   ```

### Settings Not Taking Effect

**Symptom**: Changed settings.json but plugin still not loaded

**Solutions**:

1. **Restart Claude Code completely**
   - Close ALL Claude Code windows
   - Wait 5 seconds
   - Reopen Claude Code

2. **Check settings precedence**
   - Project `.claude/settings.json` overrides global `~/.claude/settings.json`
   - Make sure you're editing the right file

3. **Validate JSON syntax**
   ```bash
   jq . ~/.claude/settings.json
   # Should output formatted JSON
   ```

---

## Advanced Topics

### Adding MCP Tool Support

If your plugin uses MCP tools, declare them:

```json
{
  "mcpTools": {
    "optional": ["sequential-thinking", "serena"],
    "gracefulDegradation": true
  }
}
```

**Graceful Degradation Example**:

```bash
#!/bin/bash

# Try to use Serena for semantic search
if command -v serena &> /dev/null; then
    # Use Serena (faster, more accurate)
    serena find_symbol "MyClass"
else
    # Fallback to grep (slower but works)
    grep -r "class MyClass" .
fi
```

### Adding Hooks

Hooks run on specific events. Create `hooks/pre-commit.sh`:

```bash
#!/bin/bash

# Run before git commit
echo "🔍 Running pre-commit checks..."

# Check for debug statements
if grep -r "console.log\|debugger" src/ 2>/dev/null; then
    echo "❌ Found debug statements. Remove before committing."
    exit 1
fi

echo "✅ Pre-commit checks passed"
exit 0
```

Declare in `plugin.json`:

```json
{
  "hooks": {
    "pre-commit": "hooks/pre-commit.sh"
  }
}
```

### Creating Parametric Commands

Commands with complex argument parsing:

```markdown
---
name: deploy
description: Deploy application to environment
allowed-tools: [Bash]
argument-hint: "[environment] [--dry-run] [--version VERSION]"
---

# Deploy Command

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Parse arguments
ENVIRONMENT=""
DRY_RUN=false
VERSION="latest"

# Simple argument parser
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --version)
            VERSION="$2"
            shift 2
            ;;
        *)
            ENVIRONMENT="$1"
            shift
            ;;
    esac
done

# Validate required arguments
if [ -z "$ENVIRONMENT" ]; then
    echo "ERROR: Environment required"
    echo "Usage: /deploy <environment> [--dry-run] [--version VERSION]"
    exit 1
fi

# Execute deployment
if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN: Would deploy version $VERSION to $ENVIRONMENT"
else
    echo "🚀 Deploying version $VERSION to $ENVIRONMENT..."
    # Actual deployment logic here
fi
```
```

---

## Next Steps

Now that you've created your first plugin:

1. **Explore Existing Plugins**: Study the [claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins) repository
   - Look at `plugins/core/` for command examples
   - Study `plugins/workflow/` for complex workflows
   - Review `plugins/development/` for agent patterns

2. **Read Architecture Docs**: Understand design principles
   - [Design Principles](../architecture/design-principles.md) - Stateless execution, file-based persistence
   - [Plugin Patterns](../architecture/patterns.md) - Common patterns and best practices
   - [Framework Constraints](../architecture/constraints.md) - What you can and cannot do

3. **Build Something Real**: Apply what you learned
   - Automate a repetitive task in your workflow
   - Create commands for your specific domain
   - Build agents for specialized tasks

4. **Share Your Work**: Contribute to the ecosystem
   - Publish your plugin to GitHub
   - Share in [Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
   - Consider submitting to the official marketplace

## Quick Reference

### Plugin Structure
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json        # REQUIRED: Manifest
├── commands/              # Slash commands
├── agents/                # AI agents
├── hooks/                 # Event handlers
└── README.md              # Documentation
```

### Minimal plugin.json
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What it does",
  "author": "Your Name",
  "commands": ["commands/*.md"],
  "license": "MIT"
}
```

### Command Template
```markdown
---
name: command-name
description: What it does
allowed-tools: [Bash]
---

# Command Name

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash
echo "Hello from command"
```
```

### Agent Template
```markdown
---
name: agent-name
description: What it does
capabilities: ["capability1", "capability2"]
---

# Agent Name

You are a specialized agent that [does something specific].

[Agent instructions and guidelines]
```

## Getting Help

- **Documentation**: [Full plugin documentation](../README.md)
- **Examples**: Browse [official plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins)
- **Issues**: Report bugs at [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

---

**Congratulations!** 🎉

You've created your first Claude Code plugin. You now understand:
- Plugin structure and configuration
- Command creation with parameters
- Agent creation for specialized tasks
- Local testing and debugging
- Publishing to GitHub

**Ready for more?** Build a plugin that solves a real problem in your workflow!
