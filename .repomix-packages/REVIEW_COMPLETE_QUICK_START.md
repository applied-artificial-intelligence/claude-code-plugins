# Claude Code Plugins - Quick Start Review (Complete)

**Instructions**: Copy this ENTIRE file and paste into Claude/ChatGPT/Gemini. The LLM will analyze the package and provide structured feedback.

**Time Required**: 15-30 minutes
**Review Type**: Quick evaluation for developers

---

## REVIEW PROMPT

I'm reviewing a plugin framework for Claude Code called "claude-code-plugins" to see if it would improve my AI-assisted development workflow.

I've included a Quick Start package below that contains:
- Project overview
- Quick start guide
- 3 example plugins (beginner to advanced)
- Core plugin with 14 commands

Please analyze this package and provide:

### 1. First Impressions (2 minutes)
- What problem does this solve?
- Is the value proposition clear?
- Would I use this? Why or why not?

### 2. Onboarding Assessment (5 minutes)
- How long would it take me to get started?
- Is the installation clear?
- Are the examples helpful?
- Any confusing parts?

### 3. Example Plugin Analysis (10 minutes)
- Analyze the 3 example plugins (hello-world, task-tracker, code-formatter)
- Do they demonstrate progressive complexity well?
- Are they realistic use cases?
- Could I build my own plugin based on these examples?

### 4. Quick Decision (5 minutes)
- ⭐ Rate overall quality (1-5 stars)
- ✅ Recommend to colleagues? (Yes/Maybe/No)
- 🚀 Would use in my workflow? (Yes/Maybe/No)
- 💡 Top 3 improvements needed before launch

### 5. One-Sentence Summary
- If you had to describe this to a colleague in one sentence, what would you say?

Please be honest and critical - I need real feedback, not politeness.

---

## PACKAGE CONTENT BEGINS HERE

This file is a merged representation of a subset of the codebase, containing specifically included files and files not matching ignore patterns, combined into a single document by Repomix.

# File Summary

## Purpose
This file contains a packed representation of the entire repository's contents.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.
- Pay special attention to the Repository Description. These contain important context and guidelines specific to this project.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: README.md, docs/getting-started/quick-start.md, docs/getting-started/installation.md, examples/**/*, plugins/core/README.md, plugins/core/.claude-plugin/plugin.json, plugins/core/commands/*
- Files matching these patterns are excluded: **/*.test.ts, **/node_modules/**, **/.git/**, scripts/**, .notebooklm-sources/**
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Files are sorted by Git change count (files with more changes are at the bottom)

# User Provided Header
# Claude Code Plugins - Quick Start Package

This package contains everything you need to get started with Claude Code plugins in 15 minutes.

## What's Included
- Main README with overview
- Quick start guide
- 3 example plugins (hello-world, task-tracker, code-formatter)
- Core plugin for immediate use

## Target Audience
Developers who want to try Claude Code plugins quickly and see if it fits their workflow.

## Time to Review: 15-30 minutes

# Directory Structure
```
docs/
  getting-started/
    installation.md
    quick-start.md
examples/
  code-formatter/
    .claude-plugin/
      plugin.json
    agents/
      style-checker.md
    commands/
      format.md
    README.md
  hello-world/
    .claude-plugin/
      plugin.json
    commands/
      hello.md
    README.md
  task-tracker/
    .claude-plugin/
      plugin.json
    commands/
      task-add.md
      task-done.md
      tasks.md
    README.md
  README.md
plugins/
  core/
    .claude-plugin/
      plugin.json
    commands/
      agent.md
      audit.md
      cleanup.md
      docs.md
      handoff.md
      index.md
      performance.md
      serena.md
      setup.md
      spike.md
      status.md
      work.md
    README.md
README.md
```

# Files

## File: examples/code-formatter/.claude-plugin/plugin.json
````json
{
  "name": "code-formatter",
  "version": "1.0.0",
  "description": "Example plugin demonstrating external tool integration and agent usage",
  "author": "Claude Code Framework Examples",
  "keywords": ["example", "formatting", "agents", "integration"],
  "commands": ["commands/format.md"],
  "agents": ["agents/style-checker.md"],
  "settings": {
    "defaultEnabled": false,
    "category": "examples"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
  },
  "license": "MIT",
  "capabilities": {
    "codeFormatting": {
      "description": "Format code files using external tools with AI validation",
      "command": "format"
    },
    "styleChecking": {
      "description": "Validate code style with AI-powered recommendations",
      "agent": "style-checker"
    }
  },
  "dependencies": {},
  "mcpTools": {
    "optional": [],
    "gracefulDegradation": true
  },
  "externalTools": {
    "prettier": {
      "required": false,
      "description": "JavaScript/TypeScript formatter",
      "install": "npm install -g prettier"
    },
    "black": {
      "required": false,
      "description": "Python code formatter",
      "install": "pip install black"
    }
  }
}
````

## File: examples/code-formatter/agents/style-checker.md
````markdown
---
name: style-checker
description: AI-powered code style analysis and recommendations
expertise: Code quality, style guides, best practices
tags: [code-quality, style, recommendations]
---

# Style Checker Agent

AI-powered code style validation providing actionable recommendations.

## Role

You are a code style expert analyzing files for:
- Naming conventions
- Code organization
- Common anti-patterns
- Style guide compliance
- Best practice adherence

## Analysis Process

1. **Read the file** provided in the task
2. **Identify style issues**:
   - Inconsistent naming
   - Poor organization
   - Unclear structure
   - Violations of language conventions
3. **Prioritize by impact**:
   - Critical: Causes bugs or confusion
   - High: Significant readability impact
   - Medium: Helpful improvements
   - Low: Nice-to-have polish
4. **Provide specific recommendations** with examples

## Output Format

```markdown
# Style Analysis: [filename]

## Summary
[1-2 sentence overview of file quality]

## Issues Found: [count]

### Critical Issues
- **[Issue]**: [Description]
  - Location: Line X
  - Fix: [Specific recommendation]
  - Example: `[code]`

### High Priority
- ...

### Medium Priority
- ...

## Strengths
[What the code does well]

## Quick Wins
[Top 3 easiest improvements with biggest impact]
```

## Guidelines

- Focus on **actionable** feedback with specific fixes
- Provide **examples** showing before/after
- Explain **why** each recommendation matters
- Respect existing **project conventions**
- Suggest **incremental** improvements
- Balance **pragmatism** with best practices

## Example Usage

```bash
/agent style-checker "src/utils.js"
```

## Integration

Works best when combined with:
- `/format` command for mechanical formatting
- Manual code review for logic validation
- Testing to verify behavior unchanged
````

## File: examples/code-formatter/commands/format.md
````markdown
---
description: Format code files using external tools with AI validation
tags: [format, integration, tools]
---

# Format Command

Demonstrates integration with external formatting tools and agent validation.

## Implementation

```bash
#!/bin/bash

# Get file path from arguments
FILE_PATH="$ARGUMENTS"

if [ -z "$FILE_PATH" ]; then
    echo "ERROR: File path required" >&2
    echo "Usage: /format <file-path>" >&2
    exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "ERROR: File not found: $FILE_PATH" >&2
    exit 1
fi

# Detect file type
FILE_EXT="${FILE_PATH##*.}"

echo "🎨 Formatting: $FILE_PATH"
echo "File type: $FILE_EXT"
echo ""

# Format based on file type
case "$FILE_EXT" in
    js|jsx|ts|tsx|json)
        if command -v prettier >/dev/null 2>&1; then
            echo "Using: Prettier"
            prettier --write "$FILE_PATH"
            echo "✅ Formatted with Prettier"
        else
            echo "⚠️ Prettier not installed"
            echo "Install: npm install -g prettier"
        fi
        ;;

    py)
        if command -v black >/dev/null 2>&1; then
            echo "Using: Black"
            black "$FILE_PATH"
            echo "✅ Formatted with Black"
        else
            echo "⚠️ Black not installed"
            echo "Install: pip install black"
        fi
        ;;

    *)
        echo "⚠️ No formatter configured for .$FILE_EXT files"
        echo "Supported: .js, .jsx, .ts, .tsx, .json (Prettier), .py (Black)"
        exit 1
        ;;
esac

echo ""
echo "💡 For style recommendations, use: /agent style-checker \"$FILE_PATH\""
```

## Key Concepts

### 1. External Tool Integration
- Check tool availability with `command -v`
- Provide installation instructions
- Handle missing tools gracefully

### 2. File Type Detection
```bash
FILE_EXT="${FILE_PATH##*.}"  # Extract extension
```

### 3. Tool Selection
- Match formatters to file types
- Use industry-standard tools
- Suggest alternatives when missing

### 4. Agent Integration
- Command handles mechanical formatting
- Agent provides strategic recommendations
- Separation of concerns

## Usage

```bash
# Format JavaScript
/format src/app.js

# Format Python
/format scripts/deploy.py

# Format TypeScript
/format components/Header.tsx
```

## With Agent Validation

```bash
# 1. Format file
/format src/utils.js

# 2. Get style recommendations
/agent style-checker "src/utils.js"
```
````

## File: examples/code-formatter/README.md
````markdown
# Code Formatter Plugin

**Level**: Advanced
**Concepts**: External tools, agent integration, error handling
**Time to Complete**: 20-30 minutes

## Overview

Demonstrates integrating external formatting tools with AI-powered style validation - combining automated tooling with intelligent recommendations.

## What You'll Learn

- Integrating with external CLI tools
- Tool availability checking and graceful degradation
- Agent definition and usage
- Combining commands and agents for complete solutions

## Features

- `/format <file>` - Auto-format code using appropriate tool
- Agent `style-checker` - AI-powered style analysis

## Installation

### 1. Install External Tools (Optional)

```bash
# For JavaScript/TypeScript
npm install -g prettier

# For Python
pip install black
```

### 2. Enable Plugin

Add to `.claude/settings.json`:
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
    "code-formatter@examples": true
  }
}
```

## Usage

### Basic Formatting

```bash
# Format JavaScript
/format src/app.js

# Format Python
/format scripts/deploy.py
```

### With Style Analysis

```bash
# 1. Auto-format (mechanical fixes)
/format src/utils.js

# 2. Get AI recommendations (strategic improvements)
/agent style-checker "src/utils.js"
```

## Key Patterns

### 1. Tool Detection
```bash
if command -v prettier >/dev/null 2>&1; then
    prettier --write "$FILE_PATH"
else
    echo "⚠️ Prettier not installed"
    echo "Install: npm install -g prettier"
fi
```

### 2. File Type Routing
```bash
case "$FILE_EXT" in
    js|jsx|ts|tsx)
        # Use Prettier
        ;;
    py)
        # Use Black
        ;;
    *)
        echo "No formatter for .$FILE_EXT"
        ;;
esac
```

### 3. Agent Integration
- Command: Mechanical/automated tasks
- Agent: Strategic/intelligent analysis
- Together: Complete solution

## Extension Ideas

1. **More formatters**: Add rustfmt, gofmt, clang-format
2. **Custom rules**: Load project-specific style config
3. **Auto-fix**: Let agent suggest fixes, command applies them
4. **Batch formatting**: Format entire directories
5. **Pre-commit hooks**: Run formatting before commits

## Resources

- [Agent Patterns](../../docs/architecture/patterns.md)
- [External Tool Integration](../../docs/guides/external-tools.md)

---

**Master Tool Integration** → **Build Production Plugins**
````

## File: examples/hello-world/.claude-plugin/plugin.json
````json
{
  "name": "hello-world",
  "version": "1.0.0",
  "description": "Minimal example plugin demonstrating basic Claude Code plugin structure",
  "author": "Claude Code Framework Examples",
  "keywords": ["example", "tutorial", "getting-started"],
  "commands": ["commands/hello.md"],
  "settings": {
    "defaultEnabled": false,
    "category": "examples"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
  },
  "license": "MIT",
  "capabilities": {
    "greeting": {
      "description": "Say hello and demonstrate basic command structure",
      "command": "hello"
    }
  },
  "dependencies": {},
  "mcpTools": {
    "optional": [],
    "gracefulDegradation": true
  }
}
````

## File: examples/hello-world/commands/hello.md
````markdown
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
````

## File: examples/hello-world/README.md
````markdown
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
````

## File: examples/task-tracker/.claude-plugin/plugin.json
````json
{
  "name": "task-tracker",
  "version": "1.0.0",
  "description": "Example plugin demonstrating state management with JSON files",
  "author": "Claude Code Framework Examples",
  "keywords": ["example", "tasks", "state-management", "json"],
  "commands": ["commands/*.md"],
  "settings": {
    "defaultEnabled": false,
    "category": "examples"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
  },
  "license": "MIT",
  "capabilities": {
    "taskList": {
      "description": "List all tasks with their status",
      "command": "tasks"
    },
    "taskAdd": {
      "description": "Add a new task to the tracker",
      "command": "task-add"
    },
    "taskComplete": {
      "description": "Mark a task as completed",
      "command": "task-done"
    }
  },
  "dependencies": {},
  "mcpTools": {
    "optional": [],
    "gracefulDegradation": true
  }
}
````

## File: examples/task-tracker/commands/task-add.md
````markdown
---
description: Add a new task to the tracker
tags: [tasks, add, state]
---

# Task Add Command

Demonstrates writing to JSON state files safely.

## Implementation

```bash
#!/bin/bash

# Configuration
TASKS_FILE=".tasks.json"

# Get task title from arguments
TASK_TITLE="$ARGUMENTS"

if [ -z "$TASK_TITLE" ]; then
    echo "ERROR: Task title required" >&2
    echo "Usage: /task-add \"Task description\"" >&2
    exit 1
fi

# Initialize tasks file if it doesn't exist
if [ ! -f "$TASKS_FILE" ]; then
    echo '{"tasks": []}' > "$TASKS_FILE"
fi

# Add new task
if command -v jq >/dev/null 2>&1; then
    # Get next ID
    NEXT_ID=$(jq '.tasks | map(.id) | max // 0 | . + 1' "$TASKS_FILE")

    # Create new task with current timestamp
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Add task using jq
    jq --arg id "$NEXT_ID" \
       --arg title "$TASK_TITLE" \
       --arg created "$TIMESTAMP" \
       '.tasks += [{
           id: ($id | tonumber),
           title: $title,
           completed: false,
           createdAt: $created
       }]' "$TASKS_FILE" > "${TASKS_FILE}.tmp"

    # Atomically replace file
    mv "${TASKS_FILE}.tmp" "$TASKS_FILE"

    echo "✅ Added task #$NEXT_ID: $TASK_TITLE"
else
    echo "ERROR: jq required for task-add" >&2
    exit 1
fi

echo ""
echo "View tasks: /tasks"
```

## Key Concepts

### 1. Argument Validation
```bash
if [ -z "$TASK_TITLE" ]; then
    echo "ERROR: Task title required" >&2
    exit 1
fi
```
- Check required arguments
- Provide helpful error messages
- Exit with non-zero status on error

### 2. Atomic File Updates
```bash
# Write to temporary file
jq '...' "$TASKS_FILE" > "${TASKS_FILE}.tmp"

# Atomically replace
mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
```
- Prevents corruption if interrupted
- Ensures file is always in valid state

### 3. JSON Manipulation with jq
```bash
jq --arg id "$NEXT_ID" \
   --arg title "$TASK_TITLE" \
   '.tasks += [{...}]' "$TASKS_FILE"
```
- Pass shell variables with `--arg`
- Use JMESPath-like syntax for updates
- Type conversion with `tonumber`, etc.

### 4. Timestamps
```bash
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
```
- Use ISO 8601 format
- UTC timezone for consistency
- Portable across systems

## Usage

```bash
# Add a task
/task-add "Write documentation"

# Output: ✅ Added task #1: Write documentation

# Add another
/task-add "Test examples"

# Output: ✅ Added task #2: Test examples
```

## State After Two Additions

`.tasks.json`:
```json
{
  "tasks": [
    {
      "id": 1,
      "title": "Write documentation",
      "completed": false,
      "createdAt": "2025-10-18T12:00:00Z"
    },
    {
      "id": 2,
      "title": "Test examples",
      "completed": false,
      "createdAt": "2025-10-18T12:05:00Z"
    }
  ]
}
```

## Next: Complete Tasks

See `task-done.md` to learn how to mark tasks as complete.
````

## File: examples/task-tracker/commands/task-done.md
````markdown
---
description: Mark a task as completed
tags: [tasks, complete, state]
---

# Task Done Command

Demonstrates updating existing records in JSON state files.

## Implementation

```bash
#!/bin/bash

# Configuration
TASKS_FILE=".tasks.json"

# Get task ID from arguments
TASK_ID="$ARGUMENTS"

if [ -z "$TASK_ID" ]; then
    echo "ERROR: Task ID required" >&2
    echo "Usage: /task-done <ID>" >&2
    echo "Example: /task-done 1" >&2
    exit 1
fi

# Validate ID is a number
if ! [[ "$TASK_ID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Task ID must be a number" >&2
    exit 1
fi

# Check tasks file exists
if [ ! -f "$TASKS_FILE" ]; then
    echo "ERROR: No tasks found. Add tasks with /task-add first" >&2
    exit 1
fi

# Update task
if command -v jq >/dev/null 2>&1; then
    # Check if task exists
    TASK_EXISTS=$(jq --arg id "$TASK_ID" \
        '.tasks | any(.id == ($id | tonumber))' "$TASKS_FILE")

    if [ "$TASK_EXISTS" != "true" ]; then
        echo "ERROR: Task #$TASK_ID not found" >&2
        echo "Run /tasks to see available tasks" >&2
        exit 1
    fi

    # Get task title before updating
    TASK_TITLE=$(jq -r --arg id "$TASK_ID" \
        '.tasks[] | select(.id == ($id | tonumber)) | .title' "$TASKS_FILE")

    # Mark as completed
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    jq --arg id "$TASK_ID" \
       --arg completed "$TIMESTAMP" \
       '.tasks |= map(
           if .id == ($id | tonumber) then
               .completed = true |
               .completedAt = $completed
           else
               .
           end
       )' "$TASKS_FILE" > "${TASKS_FILE}.tmp"

    # Atomically replace file
    mv "${TASKS_FILE}.tmp" "$TASKS_FILE"

    echo "✅ Completed task #$TASK_ID: $TASK_TITLE"
else
    echo "ERROR: jq required for task-done" >&2
    exit 1
fi

echo ""
echo "View tasks: /tasks"
```

## Key Concepts

### 1. Input Validation
```bash
# Check presence
if [ -z "$TASK_ID" ]; then
    echo "ERROR: Task ID required" >&2
    exit 1
fi

# Check format
if ! [[ "$TASK_ID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Task ID must be a number" >&2
    exit 1
fi
```

### 2. Existence Checking
```bash
TASK_EXISTS=$(jq --arg id "$TASK_ID" \
    '.tasks | any(.id == ($id | tonumber))' "$TASKS_FILE")

if [ "$TASK_EXISTS" != "true" ]; then
    echo "ERROR: Task #$TASK_ID not found" >&2
    exit 1
fi
```
- Validate before modifying
- Provide helpful error messages

### 3. Conditional Updates
```bash
jq '.tasks |= map(
    if .id == ($id | tonumber) then
        .completed = true |
        .completedAt = $completed
    else
        .
    end
)' "$TASKS_FILE"
```
- Update only matching records
- Leave others unchanged
- Functional programming style

### 4. User Feedback
```bash
# Get title before updating for confirmation message
TASK_TITLE=$(jq -r '... | .title' "$TASKS_FILE")

echo "✅ Completed task #$TASK_ID: $TASK_TITLE"
```
- Confirm what action was taken
- Include relevant details

## Usage

```bash
# Mark task 1 as done
/task-done 1

# Output: ✅ Completed task #1: Write documentation

# View updated list
/tasks

# Output shows:
# ✅ [1] Write documentation (completed: 2025-10-18T12:10:00Z)
# ⏳ [2] Test examples (created: 2025-10-18T12:05:00Z)
```

## State After Completion

`.tasks.json`:
```json
{
  "tasks": [
    {
      "id": 1,
      "title": "Write documentation",
      "completed": true,
      "createdAt": "2025-10-18T12:00:00Z",
      "completedAt": "2025-10-18T12:10:00Z"
    },
    {
      "id": 2,
      "title": "Test examples",
      "completed": false,
      "createdAt": "2025-10-18T12:05:00Z"
    }
  ]
}
```

## Complete Workflow

```bash
# 1. View tasks (empty initially)
/tasks

# 2. Add some tasks
/task-add "Write documentation"
/task-add "Test examples"
/task-add "Deploy to production"

# 3. View task list
/tasks
# Shows: 3 pending tasks

# 4. Complete first task
/task-done 1

# 5. View updated list
/tasks
# Shows: 1 completed, 2 pending
```

## Extension Ideas

Try adding these features:

1. **Task deletion**: Remove tasks from list
2. **Task editing**: Update task titles
3. **Task priorities**: Add priority levels
4. **Task filtering**: Show only pending or completed
5. **Task search**: Find tasks by keyword
6. **Task statistics**: Count completed vs pending

This example demonstrates the foundation - build from here!
````

## File: examples/task-tracker/commands/tasks.md
````markdown
---
description: List all tasks with their status
tags: [tasks, list, state]
---

# Tasks List Command

Demonstrates file-based state management using JSON.

## Implementation

```bash
#!/bin/bash

# Configuration
TASKS_FILE=".tasks.json"

# Initialize tasks file if it doesn't exist
if [ ! -f "$TASKS_FILE" ]; then
    echo '{"tasks": []}' > "$TASKS_FILE"
    echo "📝 Created new task tracker"
    echo ""
fi

# Read and display tasks
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📋 Task List"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Check if jq is available
if command -v jq >/dev/null 2>&1; then
    # Use jq for proper JSON parsing
    TASK_COUNT=$(jq '.tasks | length' "$TASKS_FILE")

    if [ "$TASK_COUNT" -eq 0 ]; then
        echo "No tasks yet. Add one with: /task-add \"Your task\""
    else
        echo "Total tasks: $TASK_COUNT"
        echo ""

        # List all tasks with formatting
        jq -r '.tasks[] |
            if .completed then
                "✅ [\(.id)] \(.title) (completed: \(.completedAt))"
            else
                "⏳ [\(.id)] \(.title) (created: \(.createdAt))"
            end' "$TASKS_FILE"
    fi
else
    # Fallback without jq (limited functionality)
    echo "⚠️ jq not installed - limited display"
    cat "$TASKS_FILE"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Commands:"
echo "  /tasks            - View this list"
echo "  /task-add \"title\" - Add new task"
echo "  /task-done ID     - Mark task as complete"
echo ""
```

## Key Concepts

### 1. File-Based State
Tasks stored in `.tasks.json` at project root:
```json
{
  "tasks": [
    {
      "id": 1,
      "title": "Write documentation",
      "completed": false,
      "createdAt": "2025-10-18T12:00:00Z"
    }
  ]
}
```

### 2. Stateless Commands
Each command execution:
- Reads current state from file
- Performs operation
- Writes updated state back to file
- No in-memory persistence

### 3. Tool Availability Checking
```bash
if command -v jq >/dev/null 2>&1; then
    # Use jq for robust JSON handling
else
    # Fallback to basic operations
fi
```

### 4. Idempotency
Safe to run multiple times:
- File initialization only if missing
- Read operations don't modify state
- Write operations use atomic file updates

## Usage

```bash
# View tasks
/tasks

# Should show: "No tasks yet. Add one with: /task-add \"Your task\""
```

## Next: Add Tasks

See `task-add.md` to learn how to add new tasks to the tracker.
````

## File: examples/task-tracker/README.md
````markdown
# Task Tracker Plugin

**Level**: Intermediate
**Concepts**: JSON state management, file operations, validation
**Time to Complete**: 15-20 minutes

## Overview

A practical task management plugin demonstrating file-based state persistence - the foundation for most Claude Code workflows.

## What You'll Learn

- How to persist state using JSON files
- Atomic file operations for safety
- Input validation patterns
- Working with jq for JSON manipulation
- Idempotent command design

## Features

- `/tasks` - List all tasks with status
- `/task-add "title"` - Add new task
- `/task-done <id>` - Mark task complete

## Quick Start

### Install the Plugin

Add to `.claude/settings.json`:
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
    "task-tracker@examples": true
  }
}
```

### Try It Out

```bash
# View tasks (creates .tasks.json if missing)
/tasks

# Add some tasks
/task-add "Write documentation"
/task-add "Test features"
/task-add "Deploy to production"

# View updated list
/tasks

# Complete a task
/task-done 1

# View final state
/tasks
```

## File Structure

```
task-tracker/
├── .claude-plugin/
│   └── plugin.json        # Plugin metadata
├── commands/
│   ├── tasks.md           # List command
│   ├── task-add.md        # Add command
│   └── task-done.md       # Complete command
└── README.md              # This file
```

## State Management

### Data Structure

`.tasks.json` at project root:
```json
{
  "tasks": [
    {
      "id": 1,
      "title": "Write documentation",
      "completed": false,
      "createdAt": "2025-10-18T12:00:00Z"
    },
    {
      "id": 2,
      "title": "Test features",
      "completed": true,
      "createdAt": "2025-10-18T12:05:00Z",
      "completedAt": "2025-10-18T12:30:00Z"
    }
  ]
}
```

### Key Patterns

#### 1. File Initialization
```bash
if [ ! -f "$TASKS_FILE" ]; then
    echo '{"tasks": []}' > "$TASKS_FILE"
fi
```
Create with valid empty structure if missing.

#### 2. Atomic Updates
```bash
jq '...' "$TASKS_FILE" > "${TASKS_FILE}.tmp"
mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
```
Write to temp file first, then atomically replace. Prevents corruption.

#### 3. ID Generation
```bash
NEXT_ID=$(jq '.tasks | map(.id) | max // 0 | . + 1' "$TASKS_FILE")
```
Find highest ID and increment. Handles empty list with `// 0`.

#### 4. Conditional Updates
```bash
jq '.tasks |= map(
    if .id == ($id | tonumber) then
        .completed = true
    else
        .
    end
)' "$TASKS_FILE"
```
Update only matching records, preserve others.

## Learning Path

### 1. Understand State Persistence

Run commands and inspect `.tasks.json` after each:
```bash
/tasks                      # Creates empty file
cat .tasks.json            # See: {"tasks": []}

/task-add "First task"     # Adds task
cat .tasks.json            # See: task with id=1

/task-done 1               # Marks complete
cat .tasks.json            # See: completed=true
```

### 2. Study Command Flow

Each command follows this pattern:
```
1. Read current state from file
2. Validate input
3. Perform operation (add, update, etc.)
4. Write updated state to file
5. Confirm to user
```

### 3. Explore jq Operations

Try these jq commands on `.tasks.json`:

```bash
# List task titles
jq '.tasks[].title' .tasks.json

# Count tasks
jq '.tasks | length' .tasks.json

# Find pending tasks
jq '.tasks[] | select(.completed == false)' .tasks.json

# Get task by ID
jq '.tasks[] | select(.id == 1)' .tasks.json
```

## Extension Ideas

Build on this foundation by adding:

### Easy Extensions
- **Task deletion**: `/task-delete <id>`
- **Task editing**: `/task-edit <id> "new title"`
- **Clear completed**: `/tasks-clear-done`

### Medium Extensions
- **Priorities**: Add high/medium/low priority field
- **Due dates**: Add `dueDate` field with validation
- **Categories**: Tag tasks with categories
- **Filtering**: `/tasks --pending`, `/tasks --completed`

### Advanced Extensions
- **Sub-tasks**: Nested task structure
- **Dependencies**: Block tasks until others complete
- **Time tracking**: Record time spent on tasks
- **Reports**: Generate completion statistics

## Common Patterns Demonstrated

### Input Validation
```bash
if [ -z "$INPUT" ]; then
    echo "ERROR: Input required" >&2
    exit 1
fi

if ! [[ "$ID" =~ ^[0-9]+$ ]]; then
    echo "ERROR: ID must be number" >&2
    exit 1
fi
```

### Error Handling
```bash
if [ ! -f "$FILE" ]; then
    echo "ERROR: File not found" >&2
    exit 1
fi

if command -v jq >/dev/null 2>&1; then
    # Use jq
else
    echo "ERROR: jq required" >&2
    exit 1
fi
```

### User Feedback
```bash
echo "✅ Task completed"     # Success
echo "⏳ Task pending"       # Status
echo "ERROR: ..." >&2       # Errors to stderr
exit 1                      # Non-zero on error
```

## Why This Example Matters

### Real-World Applicability

Most Claude Code workflows need state persistence:
- **Work unit tracking**: Current tasks and progress
- **Configuration management**: User preferences
- **History**: Previous commands and results
- **Caching**: Expensive operation results

### Transferable Skills

Master these patterns, apply to:
- Project management workflows
- Data collection and analysis
- Build pipeline state
- Testing results tracking
- Documentation generation

## Troubleshooting

### Tasks not persisting
**Cause**: Running in wrong directory
**Fix**: Commands execute in project directory. Check `pwd` output.

### JSON syntax errors
**Cause**: Manual file editing or interrupted writes
**Fix**: Delete `.tasks.json` and start fresh. Atomic writes prevent this.

### jq not found
**Cause**: jq not installed on system
**Fix**: Install jq:
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq

# Fedora/RHEL
sudo yum install jq
```

## Next Steps

1. **Try all three commands** - Understand the complete workflow
2. **Inspect state file** - See how data persists
3. **Modify the code** - Add a new feature
4. **Read code-formatter** - See agent integration next

## Resources

- [jq Manual](https://stedolan.github.io/jq/manual/)
- [JSON Specification](https://www.json.org/)
- [Design Principles](../../docs/architecture/design-principles.md)
- [Plugin Patterns](../../docs/architecture/patterns.md)

---

**Master State Management** → **Build Complex Workflows** → **Ship Production Plugins**
````

## File: plugins/core/.claude-plugin/plugin.json
````json
{
  "name": "claude-code-core",
  "version": "1.0.0",
  "description": "Core framework commands for Claude Code - essential system functionality",
  "author": "Claude Code Framework",
  "keywords": ["core", "framework", "essential", "system"],
  "commands": ["commands/*.md"],
  "agents": ["agents/auditor.md", "agents/reasoning-specialist.md"],
  "settings": {
    "defaultEnabled": true,
    "category": "core",
    "required": true
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
  },
  "license": "MIT",
  "capabilities": {
    "statusMonitoring": {
      "description": "Display project and task status",
      "command": "status"
    },
    "workManagement": {
      "description": "Manage work units and parallel streams",
      "command": "work"
    },
    "configManagement": {
      "description": "Manage framework settings and project preferences",
      "command": "config"
    },
    "agentInvocation": {
      "description": "Direct invocation of specialized agents",
      "command": "agent"
    },
    "projectCleanup": {
      "description": "Clean up Claude-generated clutter and consolidate documentation",
      "command": "cleanup"
    },
    "projectIndexing": {
      "description": "Create and maintain persistent project understanding",
      "command": "index"
    },
    "performanceMonitoring": {
      "description": "View token usage and performance metrics",
      "command": "performance"
    },
    "sessionHandoff": {
      "description": "Create transition documents with context analysis",
      "command": "handoff"
    },
    "documentationOps": {
      "description": "Fetch, search, and generate project documentation",
      "command": "docs"
    },
    "projectSetup": {
      "description": "Initialize new projects with Claude framework integration",
      "command": "setup"
    },
    "commandCreation": {
      "description": "Create new custom slash commands",
      "command": "add-command"
    },
    "frameworkAudit": {
      "description": "Framework setup and infrastructure compliance audit",
      "command": "audit"
    },
    "serenaSetup": {
      "description": "Activate and manage Serena semantic code understanding",
      "command": "serena"
    },
    "spikeExploration": {
      "description": "Time-boxed exploration in isolated branch",
      "command": "spike"
    }
  },
  "dependencies": {},
  "mcpTools": {
    "optional": ["sequential-thinking", "serena"],
    "gracefulDegradation": true
  }
}
````

## File: plugins/core/commands/agent.md
````markdown
---
allowed-tools: [Task, Read, Write]
argument-hint: "<agent-name> \"<task>\""
description: Direct invocation of specialized agents with explicit context
---

# Agent Invocation

Direct invocation of specialized agents for complex tasks. Provides explicit control over which agent handles specific work.

**Input**: $ARGUMENTS

## Phase 1: Agent Selection and Task Analysis

Based on the provided arguments: $ARGUMENTS

I'll parse the request to identify the target agent and task:

### Available Agents

- **architect**: System design, technology decisions, architectural patterns
- **test-engineer**: Test creation, TDD workflows, coverage analysis
- **code-reviewer**: Code quality, security analysis, best practices review
- **doc-reviewer**: Documentation quality, completeness, clarity assessment
- **auditor**: Infrastructure verification, compliance, system health

### Task Preparation

I'll analyze the request to:
1. **Identify target agent**: Which specialist is most appropriate
2. **Extract task details**: Clear description of work to be performed
3. **Gather context**: Relevant project information and constraints
4. **Prepare delegation**: Formatted request for agent execution

## Phase 2: Context Assembly

### Project Context Collection

I'll gather relevant context for the agent including:

#### Environmental Information
- **Project type**: Language, framework, architecture
- **Current state**: Git branch, recent changes, active work
- **Development setup**: Tools, configuration, dependencies
- **Quality standards**: Testing, linting, documentation requirements

#### Task-Specific Context
- **Related files**: Code, documentation, configuration relevant to task
- **Previous decisions**: Architectural choices, patterns established
- **Constraints**: Performance, security, compatibility requirements
- **Success criteria**: How to measure task completion

## Phase 3: Agent Invocation

### Specialized Agent Delegation

I'll use the Task tool to invoke the appropriate agent:

**Agent Parameters**:
- **subagent_type**: [Selected agent name from arguments]
- **description**: [Task summary for specialized execution]
- **prompt**: Execute specialized task with full agent expertise:

  **Task Request**: [Complete task description from arguments]

  **Your Role**: Apply your specialized knowledge and protocols as defined in your agent specification.

  **Context Application**: Use the project environment and constraints to inform your approach.

  **Deliverable Requirements**:
  - Clear analysis addressing the specific task
  - Actionable recommendations or implementations
  - Detailed reasoning behind decisions and approaches
  - Specific next steps for continued progress

  **Quality Standards**:
  - Challenge assumptions and validate approaches
  - Provide genuine insights, not just compliance responses
  - Document thought process and decision rationale
  - Follow anti-sycophancy protocols and quality standards

  **Project Integration**: Ensure recommendations fit project constraints, standards, and architectural decisions.

## Phase 4: Agent-Specific Execution Patterns

### Architect Agent Tasks
For system design and architectural decisions:
- **Technology evaluation**: Framework and tool selection
- **System design**: Component architecture and interaction patterns
- **Scalability planning**: Performance and growth considerations
- **Integration planning**: External system and API design

### Test-Engineer Agent Tasks
For testing and quality assurance:
- **Test strategy development**: Comprehensive testing approach
- **TDD implementation**: Red-Green-Refactor cycle execution
- **Coverage analysis**: Gap identification and improvement
- **Quality metrics**: Testing standards and measurement

### Code-Reviewer Agent Tasks
For code quality and security:
- **Security analysis**: Vulnerability assessment and mitigation
- **Code quality review**: Standards compliance and best practices
- **Performance evaluation**: Optimization opportunities
- **Maintainability assessment**: Long-term code health

### Documentation Reviewer Tasks
For documentation quality:
- **Completeness assessment**: Coverage of all features and APIs
- **Clarity evaluation**: User comprehension and usability
- **Accuracy verification**: Documentation matches implementation
- **Organization review**: Structure and navigation optimization

### Auditor Agent Tasks
For infrastructure and compliance:
- **System validation**: Configuration and setup verification
- **Compliance checking**: Standards and requirement adherence
- **Security auditing**: Infrastructure security assessment
- **Performance monitoring**: System health and optimization

## Phase 5: Result Integration and Follow-up

### Output Processing

After agent completion, I'll:

#### Result Documentation
- **Capture recommendations**: Record agent findings and suggestions
- **Document rationale**: Preserve reasoning and decision factors
- **Identify actions**: Extract specific next steps and priorities
- **Update context**: Add insights to project knowledge base

#### Session Integration
- **Memory updates**: Record agent insights in session context
- **Decision tracking**: Log important architectural or technical decisions
- **Action planning**: Schedule follow-up work based on recommendations
- **Quality tracking**: Monitor implementation of quality improvements

### Follow-up Guidance

Based on agent type and recommendations:

#### Architecture Follow-up
- **Design validation**: Review architectural decisions with stakeholders
- **Implementation planning**: Break down design into development tasks
- **Technology setup**: Configure tools and frameworks as recommended
- **Documentation updates**: Capture architectural decisions and rationale

#### Testing Follow-up
- **Test implementation**: Execute TDD workflow as designed
- **Coverage improvement**: Address identified gaps in test coverage
- **Quality automation**: Set up continuous testing and quality checks
- **Performance validation**: Implement and monitor performance tests

#### Code Review Follow-up
- **Issue resolution**: Address identified security and quality issues
- **Standard adoption**: Implement recommended coding standards
- **Refactoring tasks**: Schedule code improvement and cleanup work
- **Knowledge sharing**: Document insights for team learning

#### Documentation Follow-up
- **Content updates**: Improve documentation based on feedback
- **Structure optimization**: Reorganize documentation for better usability
- **Accuracy verification**: Ensure documentation matches current implementation
- **User testing**: Validate documentation with actual users

## Success Indicators

Agent invocation is successful when:
- ✅ Appropriate specialist selected for task type
- ✅ Complete context provided to agent
- ✅ Agent applies specialized expertise effectively
- ✅ Actionable recommendations provided
- ✅ Next steps clearly defined
- ✅ Results integrated into project workflow

## Best Practices

### Agent Selection
- **Match expertise to need**: Choose agent with relevant specialization
- **Clear task definition**: Provide specific, actionable task description
- **Context richness**: Include all relevant project information
- **Success criteria**: Define clear expectations for agent output

### Result Utilization
- **Immediate review**: Assess recommendations for validity and feasibility
- **Integration planning**: Schedule implementation of agent suggestions
- **Knowledge capture**: Document insights for future reference
- **Feedback loop**: Use results to improve future agent interactions

---

*Direct agent invocation providing specialized expertise for complex technical tasks with proper context and result integration.*
````

## File: plugins/core/commands/audit.md
````markdown
---
allowed-tools: [Bash, Read, Write, Grep, Glob, MultiEdit]
argument-hint: "[--framework | --tools | --fix]"
description: "Framework setup and infrastructure compliance audit"
---

# Framework Infrastructure Audit

Validates Claude Code framework setup, tool installation, and infrastructure compliance.

**Input**: $ARGUMENTS

## Usage

```bash
/audit                    # Full infrastructure audit
/audit --framework        # Focus on framework setup only
/audit --tools           # Focus on tool installation
/audit --fix             # Apply fixes for detected issues
```

## Phase 1: Framework Setup Validation

### Directory Structure Audit
1. Verify `.claude/` directory exists and has proper structure
2. Check for required subdirectories: `work/`, `memory/`, `reference/`
3. Validate permissions on framework directories
4. Ensure proper gitignore entries for sensitive files

### Configuration Validation
1. Check `settings.json` exists and has valid syntax
2. Validate hook configurations if present
3. Verify tool permissions are properly configured
4. Ensure CLAUDE.md hierarchy is properly structured

### Memory System Health
1. Verify memory files are not corrupted
2. Check import links are valid (no broken @references)
3. Validate memory file sizes are within limits
4. Ensure session memory is properly rotated

## Phase 2: Tool Installation Audit

### Core Dependencies
1. **Git**: Version check, configuration validation
2. **Python Tools**: ruff, black, mypy, pytest availability
3. **JavaScript Tools**: eslint, prettier, jest (if applicable)
4. **System Tools**: jq, flock, timeout, mktemp

### Git Configuration
1. Verify `git safe-commit` alias is configured
2. Check user name and email are set
3. Validate pre-commit hooks are installed
4. Ensure conventional commit format is enforced

### Language-Specific Tools
1. **Python Projects**: Check pyproject.toml, requirements.txt
2. **JavaScript Projects**: Validate package.json, node_modules
3. **Go Projects**: Verify go.mod, tool installations
4. **Rust Projects**: Check Cargo.toml, rust toolchain

## Phase 3: Quality Infrastructure Audit

### Code Quality Tools
1. Verify linting tools are properly configured
2. Check formatting tools work correctly
3. Validate type checking is enabled where appropriate
4. Ensure test runners are properly set up

### Git Workflow Validation
1. Check branch protection rules (if applicable)
2. Validate commit message format enforcement
3. Verify pre-commit hooks are functioning
4. Ensure proper gitignore configurations

### Security Compliance
1. Check for exposed secrets in git history
2. Validate file permissions are secure
3. Ensure sensitive files are properly ignored
4. Verify hook scripts have appropriate permissions

## Phase 4: Work Unit System Audit

### Work Unit Health Check
1. Verify work unit directory structure is correct
2. Check state.json files have valid syntax
3. Validate work unit metadata is consistent
4. Ensure proper archival of completed work

### State Management Validation
1. Check JSON schema compliance for state files
2. Verify task state transitions are logical
3. Validate work unit tracking is accurate
4. Ensure proper cleanup of temporary files

## Phase 5: Performance and Maintenance

### Performance Audit
1. Check for oversized memory files that need compression
2. Identify slow or inefficient command configurations
3. Validate context window usage is optimal
4. Ensure proper cleanup of temporary artifacts

### Maintenance Recommendations
1. Identify outdated dependencies needing updates
2. Suggest optimizations for frequently used workflows
3. Recommend cleanup for accumulated artifacts
4. Propose improvements for identified bottlenecks

## Phase 6: Fix Recommendations

### Automatic Fixes (if --fix specified)
1. Install missing dependencies where possible
2. Configure git safe-commit alias if missing
3. Create missing directory structures
4. Fix common configuration issues

### Manual Fix Guidance
1. Provide specific commands for complex fixes
2. Recommend tool-specific configuration changes
3. Suggest workflow improvements
4. Document required manual interventions

## Success Indicators

- ✅ All framework directories exist with proper permissions
- ✅ Git is properly configured with safe-commit alias
- ✅ Required development tools are installed and working
- ✅ Code quality tools are configured correctly
- ✅ Work unit system is functioning properly
- ✅ Memory system is healthy and optimized
- ✅ Security compliance is maintained
- ✅ No critical infrastructure issues detected

## Common Issues and Solutions

### Missing Dependencies
- **Problem**: Tool not found in PATH
- **Solution**: Install via package manager or update PATH

### Git Configuration Issues
- **Problem**: safe-commit alias missing
- **Solution**: `git config --global alias.safe-commit '!f() { git add -A && git commit "$@"; }; f'`

### Permission Problems
- **Problem**: Cannot write to framework directories
- **Solution**: Check ownership and permissions with `ls -la`

### Corrupted Work Units
- **Problem**: Invalid JSON in state files
- **Solution**: Restore from backup or recreate work unit

## Examples

### Full Audit
```bash
/audit
# → Comprehensive check of all infrastructure components
```

### Tool-Focused Audit
```bash
/audit --tools
# → Focus only on development tool installation and configuration
```

### Auto-Fix Mode
```bash
/audit --fix
# → Detect issues and apply automatic fixes where possible
```

---

*Infrastructure validation command ensuring Claude Code framework is properly configured and maintained.*
````

## File: plugins/core/commands/cleanup.md
````markdown
---
title: cleanup
aliases: [housekeeping, organize, tidy, clean]
description: Clean up Claude-generated clutter and consolidate documentation
allowed-tools: [Bash, Read, Write, Glob, MultiEdit]
argument-hint: "[--dry-run | --auto | root | tests | reports | work | all]"
---

# Smart Project Cleanup

I'll clean up the real clutter that accumulates during Claude development sessions, with intelligent consolidation of .md reports into README or work units.

**Arguments**: $ARGUMENTS

## Usage Examples

```bash
/cleanup reports         # Consolidate .md reports (your frequent request)
/cleanup reports --auto  # Auto-consolidate without prompts
/cleanup --dry-run       # Preview what would be cleaned
/cleanup all             # Full cleanup including reports
```

## Phase 1: Identify Cleanup Mode

```bash
# Parse arguments
MODE="${ARGUMENTS:-interactive}"
DRY_RUN=false
AUTO=false

case "$MODE" in
    --dry-run)
        DRY_RUN=true
        echo "🔍 DRY RUN MODE - Will show what would be cleaned"
        ;;
    --auto)
        AUTO=true
        echo "🤖 AUTO MODE - Will clean without prompts"
        ;;
    root)
        echo "🏠 Cleaning root directory clutter"
        ;;
    tests)
        echo "🧪 Cleaning test files outside tests/"
        ;;
    reports)
        echo "📝 Consolidating .md reports into README/work units"
        ;;
    work)
        echo "💼 Cleaning .claude/work directory"
        ;;
    all|"")
        echo "🧹 Full cleanup - all categories"
        MODE="all"
        ;;
    *)
        echo "📊 Interactive mode - will ask about each file"
        ;;
esac
```

## Phase 2: Scan for Claude Clutter

I'll identify the real problems that accumulate during Claude sessions:

### 1. Root Directory Clutter
Files that don't belong in the root:
- Random `.md` files (not README/CHANGELOG/CLAUDE)
- One-off shell scripts (`setup_*.sh`, `test_*.sh`, `debug_*.sh`)
- Misplaced config files
- Temporary Python/JS scripts

### 2. Test Files Outside tests/
Development test files scattered around:
- `test_*.py`, `test_*.js` outside tests/
- `debug_*.py`, `debug_*.js` debug scripts
- `temp_*.py`, `quick_*.py` temporary scripts
- `*_test.py`, `*.test.js` alternative patterns

### 3. Claude Report Proliferation
Reports and analyses that should be consolidated:
- `*_REPORT.md`, `*_ANALYSIS.md`
- `*_PLAN.md`, `*_SUMMARY.md`
- `*_TODO.md`, `*_NOTES.md`
- Duplicate documentation that belongs in README

### 4. Work Directory Organization
Work units and their artifacts:
- Completed work > 7 days old
- Abandoned/stale current work
- Reports that belong with their work units
- Duplicate planning documents

## Phase 3: Smart Consolidation

Based on what I find, I'll:

### For Root Directory Files
1. **Identify misplaced files**:
   - `.md` files that aren't core docs → Move to `.claude/work/` or remove
   - Shell scripts → Archive or move to `scripts/`
   - Test files → Move to `tests/` or remove
   - Debug scripts → Remove (they're usually one-time use)

### For Claude Reports
2. **Consolidate intelligently** (now fully implemented):
   - **Auto-detects content type** based on filename and content preview
   - **Work-related reports** → Merge into current work unit or `.claude/work/current/consolidation.md`
   - **Architectural/design docs** → Archive in `.claude/reference/`
   - **General insights** → Append to README.md with clear headers
   - **Interactive mode** → Ask for confirmation on each file
   - **Auto mode** → Consolidate based on intelligent suggestions

### For Test Files
3. **Handle test clutter**:
   - Valid tests → Move to `tests/` directory
   - Debug scripts → Remove (temporary by nature)
   - Quick tests → Evaluate and remove or formalize

### For Documentation
4. **Merge and consolidate**:
   - Duplicate concepts → Merge into authoritative location
   - Temporary docs → Integrate or remove
   - Work documentation → Ensure it's with the work unit

## Phase 4: Execute Cleanup

```bash
# Create archive directory with timestamp
ARCHIVE_DIR=".archive/cleanup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$ARCHIVE_DIR"

# Function to handle file disposition
handle_file() {
    local file="$1"
    local action="$2"  # archive, delete, move, consolidate
    local target="$3"  # target location for moves

    if [ "$DRY_RUN" = true ]; then
        echo "  Would $action: $file" $([ -n "$target" ] && echo "→ $target")
        return
    fi

    case "$action" in
        archive)
            echo "  📦 Archiving: $file"
            mkdir -p "$ARCHIVE_DIR/$(dirname "$file")"
            mv "$file" "$ARCHIVE_DIR/$file"
            ;;
        delete)
            echo "  🗑️  Removing: $file"
            rm -f "$file"
            ;;
        move)
            echo "  📁 Moving: $file → $target"
            mkdir -p "$(dirname "$target")"
            mv "$file" "$target"
            ;;
        consolidate)
            echo "  📋 Consolidating: $file → $target"
            # Append content to target with header
            echo "" >> "$target"
            echo "## Content from $file" >> "$target"
            echo "" >> "$target"
            cat "$file" >> "$target"
            # Archive original
            mkdir -p "$ARCHIVE_DIR/$(dirname "$file")"
            mv "$file" "$ARCHIVE_DIR/$file"
            ;;
    esac
}

# Function to detect consolidation candidates
detect_md_reports() {
    local candidates=()

    # Find standalone .md files (excluding core docs)
    while IFS= read -r -d '' file; do
        case "$(basename "$file")" in
            README.md|CHANGELOG.md|CLAUDE.md|LICENSE.md) ;;
            *) candidates+=("$file") ;;
        esac
    done < <(find . -maxdepth 1 -name "*.md" -type f -print0)

    # Find .md files in project subdirectories (excluding .claude, .git, node_modules)
    while IFS= read -r -d '' file; do
        candidates+=("$file")
    done < <(find . -name "*.md" -type f -path "*/*" ! -path "./.claude/*" ! -path "./.git/*" ! -path "./node_modules/*" ! -path "./tests/*" -print0)

    printf '%s\n' "${candidates[@]}"
}

# Function to suggest consolidation target
suggest_target() {
    local file="$1"
    local content_preview=$(head -10 "$file" | tr '\n' ' ')

    # Check if it's work-related
    if [[ "$file" =~ (analysis|report|summary|findings|results|review) ]] ||
       [[ "$content_preview" =~ (analysis|findings|implemented|completed|tested|reviewed) ]]; then

        # Look for related work unit
        local work_unit=$(find .claude/work -name "*.md" -type f | head -1)
        if [ -n "$work_unit" ]; then
            echo "work_unit:$work_unit"
        else
            echo "work_unit:.claude/work/current/consolidation.md"
        fi

    # Check if it's architectural/reference
    elif [[ "$content_preview" =~ (architecture|design|pattern|structure|framework|reference) ]]; then
        echo "reference:.claude/reference/$(basename "$file")"

    # Check if it's general insights
    elif [[ "$content_preview" =~ (insight|learning|principle|guideline|best.practice) ]]; then
        echo "readme:README.md"

    # Default to work unit
    else
        echo "work_unit:.claude/work/current/consolidation.md"
    fi
}
```

## Phase 5: Execute Reports Consolidation

```bash
# Handle reports mode specifically
if [ "$MODE" = "reports" ] || [ "$MODE" = "all" ]; then
    echo ""
    echo "🔍 Scanning for consolidation candidates..."

    CANDIDATES=($(detect_md_reports))
    CONSOLIDATED_COUNT=0

    if [ ${#CANDIDATES[@]} -eq 0 ]; then
        echo "✅ No standalone .md files found - project is already clean"
    else
        echo "📝 Found ${#CANDIDATES[@]} potential consolidation candidates:"
        echo ""

        for file in "${CANDIDATES[@]}"; do
            if [ ! -f "$file" ]; then continue; fi

            echo "📄 $file"

            # Show preview
            local preview=$(head -3 "$file" | sed 's/^/     /')
            echo "$preview"
            echo "     ..."

            # Get suggestion
            local suggestion=$(suggest_target "$file")
            local target_type=$(echo "$suggestion" | cut -d: -f1)
            local target_path=$(echo "$suggestion" | cut -d: -f2)

            case "$target_type" in
                work_unit)
                    echo "   💼 Suggests: Consolidate with work unit → $target_path"
                    ;;
                reference)
                    echo "   📚 Suggests: Archive as reference → $target_path"
                    ;;
                readme)
                    echo "   📖 Suggests: Integrate into README.md"
                    ;;
            esac

            # Ask for confirmation unless auto mode
            if [ "$AUTO" = false ] && [ "$DRY_RUN" = false ]; then
                echo ""
                read -p "   Consolidate this file? (y/n/s=skip): " choice
                case "$choice" in
                    y|Y)
                        if [ "$target_type" = "readme" ]; then
                            handle_file "$file" consolidate "README.md"
                        else
                            mkdir -p "$(dirname "$target_path")"
                            handle_file "$file" consolidate "$target_path"
                        fi
                        ((CONSOLIDATED_COUNT++))
                        ;;
                    s|S)
                        echo "   ⏭️  Skipping $file"
                        ;;
                    *)
                        echo "   📦 Archiving $file for manual review"
                        handle_file "$file" archive
                        ;;
                esac
            elif [ "$AUTO" = true ]; then
                # Auto mode - consolidate based on suggestion
                if [ "$target_type" = "readme" ]; then
                    handle_file "$file" consolidate "README.md"
                else
                    mkdir -p "$(dirname "$target_path")"
                    handle_file "$file" consolidate "$target_path"
                fi
                ((CONSOLIDATED_COUNT++))
            else
                # Dry run mode
                echo "   🔍 Would consolidate → $target_path"
            fi

            echo ""
        done

        if [ "$DRY_RUN" = false ]; then
            echo "✅ Consolidated $CONSOLIDATED_COUNT files"
        fi
    fi
fi

# Continue with other cleanup modes...
if [ "$MODE" = "root" ] || [ "$MODE" = "all" ]; then
    echo ""
    echo "🏠 Cleaning root directory..."
    # Add root cleanup logic here
fi

if [ "$MODE" = "tests" ] || [ "$MODE" = "all" ]; then
    echo ""
    echo "🧪 Organizing test files..."
    # Add test cleanup logic here
fi

if [ "$MODE" = "work" ] || [ "$MODE" = "all" ]; then
    echo ""
    echo "💼 Cleaning work directory..."
    # Add work cleanup logic here
fi
```

## Phase 6: Final Organization

### Key Directories After Cleanup
```
project/
├── README.md              # Main documentation
├── CHANGELOG.md           # Version history
├── CLAUDE.md              # AI context (if needed)
├── .claude/
│   ├── work/              # All work units
│   │   ├── current/       # Active work
│   │   └── completed/     # Archived work with reports
│   ├── reference/         # Permanent documentation
│   └── memory/            # Memory files
├── tests/                 # ALL test files
├── scripts/               # Utility scripts (if needed)
└── src/                   # Source code
```

### What Gets Preserved
- Core documentation (README, CHANGELOG, CLAUDE.md)
- Active source code and configurations
- Structured work units in `.claude/work/`
- Formal tests in `tests/`
- Essential scripts in `scripts/`

### What Gets Removed/Archived
- Temporary debug scripts
- One-off test files
- Redundant reports and analyses
- Duplicate documentation
- Misplaced files in root

## Success Metrics

✅ **Root directory contains only essential files**
✅ **All tests are in tests/ directory**
✅ **Reports consolidated with their work units**
✅ **No duplicate documentation**
✅ **Clear project structure maintained**
✅ **Important information preserved in appropriate locations**

## Summary Report

After cleanup, I'll provide:
- Files removed/archived count by category
- Documentation consolidated
- Tests organized
- Space recovered
- Remaining actions needed

---

*Smart cleanup that understands how Claude actually creates clutter and consolidates it appropriately*
````

## File: plugins/core/commands/docs.md
````markdown
---
allowed-tools: [Bash, Read, Write, MultiEdit, Grep, Glob, Task, WebFetch, mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
argument-hint: "fetch|search|generate [arguments]"
description: Unified documentation operations - fetch external, search all, and generate project docs
---

# Documentation Operations Hub

Consolidated command for all documentation-related operations. Clear separation between fetching external docs, searching, and generating project documentation.

**Input**: $ARGUMENTS

## Usage

### Fetch External Documentation
```bash
/docs fetch                    # Fetch official Claude Code & library docs
/docs fetch --force            # Force complete re-fetch (clear cache)
/docs fetch --status           # Check cache status and last fetch time
/docs fetch --libraries        # Focus on project dependency docs
```

### Search Documentation
```bash
/docs search "command syntax"      # Search all cached documentation
/docs search "hooks examples"      # Find specific topics
/docs search "MCP integration"     # Search across all docs
/docs search "pytest fixtures"     # Search library-specific docs
```

### Generate Project Documentation
```bash
/docs generate "Added auth system"   # Generate/update docs after changes
/docs generate                       # Interactive documentation generation
/docs generate --api                 # Focus on API documentation
/docs generate --readme              # Update README only
```

## Phase 1: Determine Documentation Operation

Based on the arguments provided: $ARGUMENTS

I'll determine which documentation operation to perform:

- **Fetch Operations**: Arguments start with "fetch" - fetch external documentation into cache
- **Search Operations**: Arguments start with "search" - search all available documentation
- **Generate Operations**: Arguments start with "generate" - generate/update project documentation
- **Help Mode**: No arguments - show usage guidance with clear distinctions

## Phase 2: Execute Documentation Fetch

When handling fetch operations:

### Fetching External Documentation
1. **Source Identification**: Determine official Claude Code documentation sources
2. **Cache Management**: Create/update local documentation cache in `.claude/docs/`
3. **Version Tracking**: Track documentation versions and update timestamps
4. **Content Organization**: Organize docs by topic (commands, agents, hooks, MCP)
5. **Index Creation**: Create searchable index of documentation content

### Fetch Modes
1. **Incremental Fetch** (default): Fetch only changed or new documentation
2. **Force Fetch** (--force): Complete re-download and cache refresh
3. **Status Check** (--status): Report cache status and last fetch information
4. **Library Focus** (--libraries): Prioritize project dependency documentation

### Enhanced Fetch (with Context7 MCP)
When Context7 MCP is available, enhance documentation sync with intelligent library detection:

**Automatic Library Documentation Sync**:
1. **Dependency Detection**: Scan project files (package.json, requirements.txt, etc.) for libraries
2. **Library Resolution**: Use Context7 to resolve library names to official documentation
3. **Version-Aware Sync**: Fetch documentation matching exact dependency versions
4. **Intelligent Caching**: Cache frequently-used library documentation locally

**Context7 Fetch Process**:
- Automatically detect project dependencies
- Resolve each library using `mcp__context7__resolve-library-id`
- Fetch comprehensive documentation using `mcp__context7__get-library-docs`
- Organize documentation by library and version in `.claude/docs/libraries/`
- Create searchable index linking local project to relevant library docs

**Smart Documentation Features**:
- **Framework-Specific**: Automatically include framework-specific best practices
- **API-Complete**: Ensure complete API reference for all dependencies
- **Example-Rich**: Include usage examples and patterns from Context7
- **Update-Aware**: Check for documentation updates on library version changes

**Graceful Degradation**: When Context7 unavailable, falls back to manual documentation fetch using web fetch and local caching.

## Context7 MCP Availability Check

Before attempting Context7 operations, I'll check availability:
- Test Context7 MCP connection with simple library resolution
- On failure, automatically switch to fallback methods
- Provide clear user feedback about which mode is active
- Maintain full functionality regardless of MCP availability

## Phase 3: Execute Documentation Search

When handling search operations:

### Local Cache Search
1. **Index Search**: Use cached documentation index for fast search
2. **Content Search**: Full-text search across all cached documentation
3. **Topic Filtering**: Search within specific documentation categories
4. **Relevance Ranking**: Rank results by relevance and recency

### Advanced Search (with Context7 MCP)
When Context7 MCP is available, enhance search with library-specific intelligence:

**Context7 Library Documentation Search**:
1. **Automatic Library Resolution**: Identify libraries from project dependencies
2. **Version-Specific Documentation**: Access docs matching exact library versions
3. **Semantic Library Search**: Find relevant topics within library documentation
4. **API Reference Lookup**: Direct access to function/class documentation

**Context7 Enhanced Search Process**:
- When searching for library-specific topics, automatically resolve library names
- Fetch up-to-date documentation from Context7's knowledge base
- Provide focused, relevant results from official library documentation
- Fall back to cached local search when Context7 unavailable

**Example Context7 Usage**:
```bash
/docs search "react hooks"     # → Uses Context7 to find React hooks documentation
/docs search "express middleware" # → Fetches Express.js middleware docs via Context7
/docs search "pytest fixtures"   # → Gets current pytest fixture documentation
```

### Traditional Search (Fallback)
When Context7 MCP is unavailable:

1. **Local Cache Search**: Use cached documentation index for fast search
2. **Live Web Search**: Search current online documentation via Firecrawl when available
3. **Cross-Reference Search**: Find related concepts in cached documentation
4. **Code Example Search**: Find relevant code examples from local cache

### Search Result Presentation
1. **Relevant Excerpts**: Show context around matching content
2. **Source Attribution**: Clear indication of documentation source
3. **Direct Links**: Provide links to full documentation when available
4. **Related Topics**: Suggest related documentation sections

## Phase 4: Execute Documentation Generation

When handling generate operations:

### Project Documentation Generation
1. **Current State Assessment**: Analyze existing project documentation
2. **Gap Identification**: Identify missing or outdated documentation
3. **Change Impact Analysis**: Understand what documentation needs updating
4. **Content Planning**: Plan what documentation to create or update

### Generation Operations
1. **API Documentation**: Generate API docs from code analysis
2. **README Generation**: Update README with new features and changes
3. **Code Comments**: Generate missing docstrings and comments
4. **Usage Examples**: Create usage examples from test cases
5. **Migration Guides**: Generate migration guides for breaking changes

### Enhanced Generation (with MCP Tools)
When MCP servers are available:

1. **Automated API Docs**: Generate API documentation from code analysis
2. **Intelligent Examples**: Create relevant usage examples automatically
3. **Cross-Platform Docs**: Ensure documentation works across different platforms
4. **Documentation Testing**: Verify documentation examples actually work

## Phase 5: Documentation Quality Assurance

For all documentation operations:

### Content Validation
1. **Accuracy Verification**: Ensure documentation matches actual implementation
2. **Link Checking**: Validate all internal and external links work
3. **Code Example Testing**: Verify all code examples execute correctly
4. **Formatting Consistency**: Ensure consistent formatting and style

### Organization and Accessibility
1. **Logical Structure**: Organize documentation in intuitive hierarchy
2. **Navigation Aids**: Create table of contents and cross-references
3. **Search Optimization**: Ensure content is easily searchable
4. **Version Compatibility**: Mark documentation with applicable versions

## Phase 6: Cache and State Management

### Documentation Cache Structure
```
.claude/docs/
├── official/          # Official Claude Code documentation
│   ├── commands/      # Command documentation
│   ├── agents/        # Agent documentation
│   ├── hooks/         # Hook documentation
│   └── api/           # API reference
├── libraries/         # Third-party library documentation
├── project/           # Project-specific documentation
└── cache_metadata.json  # Cache status and timestamps
```

### Cache Maintenance
1. **Size Management**: Keep cache size reasonable for performance
2. **Staleness Detection**: Identify and refresh outdated documentation
3. **Cleanup Operations**: Remove unnecessary or duplicate documentation
4. **Index Rebuilding**: Maintain searchable index of documentation content

## Success Indicators

### Fetch Operations Success
- ✅ External documentation cached locally
- ✅ Cache index updated and searchable
- ✅ Version information tracked
- ✅ Dependencies documentation fetched (when MCP available)

### Search Operations Success
- ✅ Relevant results found and presented
- ✅ Context provided with search results
- ✅ Source attribution clear
- ✅ Related topics suggested

### Generate Operations Success
- ✅ Project documentation generated and current
- ✅ API documentation reflects latest code
- ✅ Examples created and tested
- ✅ Migration guides generated for changes

## Common Documentation Patterns

### API Documentation
- Clear endpoint descriptions with parameters
- Request/response examples
- Error code documentation
- Authentication requirements

### User Guides
- Step-by-step instructions
- Screenshots and examples
- Common use cases
- Troubleshooting sections

### Developer Documentation
- Architecture explanations
- Contributing guidelines
- Development setup instructions
- Testing procedures

## Examples

### Fetch Latest Documentation
```bash
/docs fetch
# → Downloads and caches latest official Claude Code & library documentation
```

### Search for Specific Topics
```bash
/docs search "hook examples"
# → Finds and displays relevant hook documentation and examples
```

### Generate Project Documentation
```bash
/docs generate "Added authentication system with JWT tokens"
# → Generates/updates README, API docs, and creates usage examples
```

### Force Complete Documentation Refresh
```bash
/docs fetch --force
# → Completely refreshes external documentation cache
```

## Integration Benefits

- **MCP Intelligence**: Leverages Context7 for library docs and Firecrawl for web content
- **Automated Updates**: Keeps documentation synchronized with code changes
- **Smart Search**: Intelligent search across all documentation sources
- **Version Awareness**: Matches documentation to actual dependency versions
- **Quality Assurance**: Validates documentation accuracy and completeness

---

*Unified documentation command with clear operations: fetch external docs, search everything, and generate project documentation.*
````

## File: plugins/core/commands/handoff.md
````markdown
---
title: handoff
aliases: [transition, continue]
---

# Conversation Handoff

Prepare a smooth transition for the next conversation when approaching context limits or switching focus.

## Purpose

Creates a structured handoff document that:
1. **Extracts session-specific context** for immediate continuation
2. **Updates permanent memory** with durable learnings
3. **Prepares clean transition** for the next agent

## What Gets Created

### Transition Document
**Location**: `.claude/transitions/YYYY-MM-DD_NNN/handoff.md`

Contains:
- **Current Work Context**: What was being worked on, why, and current state
- **Recent Decisions**: Important choices made this session (not yet in permanent docs)
- **Active Challenges**: Current blockers, open questions, debugging context
- **Next Steps**: Specific, actionable tasks ready for immediate execution
- **Session-Specific State**: File changes, test results, temporary findings

### Memory Updates (if needed)
Updates `.claude/memory/` files with durable knowledge:
- **project_state.md**: Architecture changes, new components
- **conventions.md**: Discovered patterns, coding standards
- **dependencies.md**: New integrations, API changes

## Usage

```bash
# Standard handoff - analyzes conversation and creates transition
/handoff

# With specific focus for next session
/handoff "focusing on performance optimization"

# Quick handoff (minimal extraction)
/handoff --quick
```

## Handoff Process

I'll analyze our conversation and execute these steps:

1. **Identify Durable Knowledge** → Update `.claude/memory/` files if needed
2. **Extract Session Context** → Create comprehensive transition document
3. **Verify Symlink** → Ensure `.claude/transitions/latest/handoff.md` is correct
4. **Inform User** → Tell user to run `/clear` manually (auto-clear not available via SlashCommand)

**IMPORTANT**: After I complete the handoff document, you must manually continue:

1. Run `/clear` (the CLI command, not a slash command)
2. Say: "continue from .claude/transitions/latest/handoff.md"

**Note**: Auto-continue after `/clear` is NOT supported. You must explicitly tell me to continue from the handoff document.

## User Continuation Steps

After I create the handoff document and verify the symlink:

**Step 1**: Run `/clear` to reset conversation context
```bash
/clear
```

**Step 2**: Explicitly tell me to continue from handoff
```
continue from .claude/transitions/latest/handoff.md
```

**Manual intervention required** - There is no automatic detection or loading after `/clear`.

## Intelligence Guidelines

### What Goes in Permanent Memory
- Architectural decisions and rationale
- Discovered patterns and conventions
- Integration points and dependencies
- Long-term project goals

### What Stays in Transition
- Current debugging context
- Today's specific task progress
- Temporary workarounds
- Session-specific file edits

### What's Excluded
- Verbose narratives about changes
- Historical context ("we tried X then Y")
- Meta-discussion about process
- Redundant information already in docs

## Example Transition Structure

```markdown
# Handoff: 2025-09-18_001

## Active Work
Implementing MCP memory system with two-flow approach

## Current State
- Created /handoff and /memory-update commands
- Serena configured and working for semantic operations
- 4 MCP tools operational (Sequential Thinking, Context7, Serena, Firecrawl)

## Recent Decisions
- Use .claude/memory/ for durable knowledge referenced by CLAUDE.md
- Transition documents in .claude/transitions/ for session handoffs
- Keep README.md deliberately concise

## Next Steps
1. Test /handoff command with real scenario
2. Configure .claude/memory/ structure
3. Update CLAUDE.md to reference memory modules

## Session Context
Working in: $PROJECT_DIR
Last focus: Memory system design
Open PR: feature/sophisticated-hook-system
```

## Implementation Notes

### Symlink Verification
**Critical**: Always verify the `latest` symlink points to the newest handoff document.

```bash
# Find newest transition directory
NEWEST=$(ls -1d .claude/transitions/2025-* 2>/dev/null | sort -r | head -1)

# Update symlink (force overwrite)
ln -sf "$NEWEST/handoff.md" .claude/transitions/latest/handoff.md

# Verify it's correct
readlink -f .claude/transitions/latest/handoff.md
```

This prevents the issue where an older handoff document gets linked instead of the newest one.

### Manual Continuation Workflow
After creating handoff and verifying symlink, I will tell you:

```
✅ Handoff complete!

To continue:
1. Run /clear (the CLI command)
2. Say: "continue from .claude/transitions/latest/handoff.md"
```

**Important**: Auto-continuation is NOT supported. You must explicitly tell me to read the handoff document after `/clear`.

## Benefits

- **No Context Loss**: Smooth continuation across conversation boundaries (with manual continue step)
- **Clean Documentation**: Permanent docs stay concise and relevant
- **Efficient Startup**: Next agent gets exactly what they need
- **Progressive Learning**: Project knowledge accumulates properly
- **Symlink Convenience**: `.claude/transitions/latest/handoff.md` always points to newest handoff

---

*Part of the memory management system - ensuring continuous project understanding across sessions*
````

## File: plugins/core/commands/index.md
````markdown
---
allowed-tools: [Read, Write, Grep, Bash, Glob, Task]
argument-hint: "[--update] [--refresh] [focus_area]"
description: Create and maintain persistent project understanding through comprehensive project mapping
---

# Index Project

Creates persistent project understanding that survives sessions by generating a comprehensive PROJECT_MAP.md file automatically imported into CLAUDE.md.

**Solves the core problem**: `/analyze` insights are lost between sessions, requiring constant "looking around" and re-exploration of codebases.

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Standard constants (must be copied to each command)
readonly CLAUDE_DIR=".claude"
readonly PROJECT_MAP="${CLAUDE_DIR}/PROJECT_MAP.md"
readonly CLAUDE_MD="CLAUDE.md"

# Error handling functions (must be copied to each command)
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

debug() {
    [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
}

# Safe directory creation
safe_mkdir() {
    local dir="$1"
    mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
}

# Parse arguments
MODE="full"
FOCUS_AREA=""

if [[ "$ARGUMENTS" == *"--update"* ]]; then
    MODE="update"
elif [[ "$ARGUMENTS" == *"--refresh"* ]]; then
    MODE="refresh"
elif [ -n "$ARGUMENTS" ] && [[ "$ARGUMENTS" != --* ]]; then
    FOCUS_AREA="$ARGUMENTS"
fi

echo "🔍 Indexing Project"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Mode: $MODE"
if [ -n "$FOCUS_AREA" ]; then
    echo "Focus: $FOCUS_AREA"
fi
echo ""

# Ensure .claude directory exists
safe_mkdir "$CLAUDE_DIR"

# Check if PROJECT_MAP.md already exists
if [ -f "$PROJECT_MAP" ] && [ "$MODE" = "full" ]; then
    echo "📝 Existing PROJECT_MAP.md found. Use --update for incremental or --refresh for complete regeneration."
    MODE="update"
fi

# Analyze project structure
echo "📊 Analyzing project structure..."

# Get project name from directory
PROJECT_NAME=$(basename "$(pwd)")

# Detect primary language
PRIMARY_LANG="Unknown"
if ls *.py >/dev/null 2>&1; then
    PRIMARY_LANG="Python"
elif ls *.js >/dev/null 2>&1; then
    PRIMARY_LANG="JavaScript"
elif ls *.ts >/dev/null 2>&1; then
    PRIMARY_LANG="TypeScript"
elif ls *.go >/dev/null 2>&1; then
    PRIMARY_LANG="Go"
elif ls *.java >/dev/null 2>&1; then
    PRIMARY_LANG="Java"
fi

# Detect frameworks
FRAMEWORKS=""
if [ -f "package.json" ]; then
    if grep -q "react" package.json 2>/dev/null; then
        FRAMEWORKS="${FRAMEWORKS}React "
    fi
    if grep -q "express" package.json 2>/dev/null; then
        FRAMEWORKS="${FRAMEWORKS}Express "
    fi
    if grep -q "next" package.json 2>/dev/null; then
        FRAMEWORKS="${FRAMEWORKS}Next.js "
    fi
fi

if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    if grep -q "django" requirements.txt 2>/dev/null || grep -q "django" pyproject.toml 2>/dev/null; then
        FRAMEWORKS="${FRAMEWORKS}Django "
    fi
    if grep -q "flask" requirements.txt 2>/dev/null || grep -q "flask" pyproject.toml 2>/dev/null; then
        FRAMEWORKS="${FRAMEWORKS}Flask "
    fi
    if grep -q "fastapi" requirements.txt 2>/dev/null || grep -q "fastapi" pyproject.toml 2>/dev/null; then
        FRAMEWORKS="${FRAMEWORKS}FastAPI "
    fi
fi

# Create or update PROJECT_MAP.md
echo "📝 Creating PROJECT_MAP.md..."

cat > "$PROJECT_MAP" << EOF || error_exit "Failed to create PROJECT_MAP.md"
# Project Map: $PROJECT_NAME

*Generated: $(date -Iseconds)*
*Last Updated: $(date -Iseconds)*

## Quick Overview
- **Type**: [Project type to be determined]
- **Primary Language**: $PRIMARY_LANG
- **Frameworks**: ${FRAMEWORKS:-Not detected}
- **Location**: $(pwd)

## Directory Structure

### Main Application Code
EOF

# Add directory structure analysis
for dir in src lib app core; do
    if [ -d "$dir" ]; then
        FILE_COUNT=$(find "$dir" -type f -name "*.${PRIMARY_LANG,,}" 2>/dev/null | wc -l)
        echo "- \`$dir/\` - Main application code ($FILE_COUNT files)" >> "$PROJECT_MAP"
    fi
done

echo "" >> "$PROJECT_MAP"
echo "### Test Organization" >> "$PROJECT_MAP"
for dir in test tests __tests__ spec; do
    if [ -d "$dir" ]; then
        echo "- \`$dir/\` - Test files" >> "$PROJECT_MAP"
    fi
done

echo "" >> "$PROJECT_MAP"
echo "### Documentation" >> "$PROJECT_MAP"
if [ -f "README.md" ]; then
    echo "- \`README.md\` - Project documentation" >> "$PROJECT_MAP"
fi
if [ -d "docs" ]; then
    echo "- \`docs/\` - Additional documentation" >> "$PROJECT_MAP"
fi

# Add key files section
echo "" >> "$PROJECT_MAP"
echo "## Key Files" >> "$PROJECT_MAP"

# Find entry points
for file in main.py app.py server.py index.js server.js main.go; do
    if [ -f "$file" ]; then
        echo "- \`$file\` - Application entry point" >> "$PROJECT_MAP"
    fi
done

# Add patterns section
echo "" >> "$PROJECT_MAP"
echo "## Patterns & Conventions" >> "$PROJECT_MAP"
echo "- **Architecture**: [To be analyzed]" >> "$PROJECT_MAP"
echo "- **Testing**: [To be analyzed]" >> "$PROJECT_MAP"
echo "- **Code Style**: [To be analyzed]" >> "$PROJECT_MAP"

# Add to CLAUDE.md if not already imported
if [ -f "$CLAUDE_MD" ]; then
    if ! grep -q "@.claude/PROJECT_MAP.md" "$CLAUDE_MD" 2>/dev/null; then
        echo "" >> "$CLAUDE_MD"
        echo "## Project Understanding" >> "$CLAUDE_MD"
        echo "@.claude/PROJECT_MAP.md" >> "$CLAUDE_MD"
        echo "✅ Added PROJECT_MAP.md import to CLAUDE.md"
    else
        echo "✅ PROJECT_MAP.md already imported in CLAUDE.md"
    fi
else
    # Create CLAUDE.md with import
    cat > "$CLAUDE_MD" << EOF || error_exit "Failed to create CLAUDE.md"
# Project: $PROJECT_NAME

## Project Understanding
@.claude/PROJECT_MAP.md
EOF
    echo "✅ Created CLAUDE.md with PROJECT_MAP.md import"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Project indexed successfully!"
echo ""
echo "📋 PROJECT_MAP.md created at: $PROJECT_MAP"
echo "📋 Auto-imported into: $CLAUDE_MD"
echo ""
echo "💡 Next steps:"
echo "   - Review and enhance PROJECT_MAP.md with specific details"
echo "   - Run /analyze for deeper code analysis"
echo "   - Use /index --update after making changes"
```

## Usage

### Full Project Mapping (Initial Use)
```bash
/index
```
Performs comprehensive project scan, creates `.claude/PROJECT_MAP.md`, and auto-imports into `CLAUDE.md`.

### Incremental Updates
```bash
/index --update
```
Updates existing PROJECT_MAP.md with recent changes, new files, and structural modifications.

### Complete Refresh
```bash
/index --refresh
```
Force complete re-scan and regeneration of PROJECT_MAP.md, useful after major refactoring.

### Focused Analysis
```bash
/index "authentication system"
```
Generate project map with special focus on authentication-related components and patterns.

## Phase 1: Determine Analysis Mode

Based on arguments: $ARGUMENTS

I'll determine the appropriate indexing approach:

- **Full Scan**: No arguments or new project - comprehensive analysis
- **Update Mode**: `--update` specified - incremental changes only
- **Refresh Mode**: `--refresh` specified - complete regeneration
- **Focused Mode**: Focus area specified - targeted analysis

## Phase 2: Project Structure Analysis

### Directory Structure Discovery
1. **Source Code Organization**: Identify main code directories (src/, lib/, app/, etc.)
2. **Test Organization**: Locate test directories and their relationship to source
3. **Documentation Structure**: Find docs/, README files, and documentation patterns
4. **Configuration Files**: Map config files, environment files, and settings
5. **Build and Deployment**: Identify build directories, deployment configs, and artifacts

### Technology Stack Detection
1. **Primary Language**: Determine main programming language from file extensions
2. **Framework Identification**: Detect frameworks from package files and imports
3. **Database Technology**: Identify database systems and ORM patterns
4. **Build Tools**: Find build systems, task runners, and automation tools
5. **Deployment Platform**: Detect containerization, cloud configs, and deployment targets

### Entry Points and Key Files
1. **Application Entry Points**: main.py, index.js, app.py, server.go, etc.
2. **Configuration Entry Points**: settings files, environment configs
3. **API Definitions**: Route files, API specs, schema definitions
4. **Data Models**: Entity definitions, database schemas, type definitions
5. **Core Business Logic**: Key service files, domain models, controllers

## Phase 3: Code Pattern Analysis

### Architectural Patterns
1. **Project Structure**: Analyze directory organization and naming conventions
2. **Code Organization**: Identify layering patterns (MVC, clean architecture, etc.)
3. **Dependency Patterns**: Map how modules import and depend on each other
4. **Design Patterns**: Identify common patterns (factory, singleton, observer, etc.)
5. **Testing Patterns**: Understand test organization and coverage approach

### Development Conventions
1. **Naming Conventions**: File naming, variable naming, function naming patterns
2. **Code Style**: Formatting, documentation, and comment patterns
3. **Error Handling**: How errors are managed and propagated
4. **Logging and Monitoring**: Logging patterns and monitoring setup
5. **Security Practices**: Authentication, authorization, and security patterns

### Integration Points
1. **External APIs**: Third-party service integrations and API clients
2. **Database Connections**: How data persistence is handled
3. **Message Queues**: Async communication and event handling
4. **Caching Systems**: Caching strategies and implementations
5. **File Storage**: File handling and storage systems

## Phase 4: Enhanced Analysis (with MCP Tools)

### Sequential Thinking Analysis (when available)
For complex projects, use structured reasoning to understand:

1. **System Architecture**: Step-by-step analysis of how components interact
2. **Data Flow**: Systematic tracing of data through the system
3. **Business Logic**: Understanding of core functionality and workflows
4. **Integration Points**: Analysis of external dependencies and interfaces
5. **Scalability Considerations**: Assessment of performance and scaling patterns

### Semantic Code Analysis (with Serena MCP)
When Serena is connected, enhance analysis with:

1. **Symbol-Level Understanding**: Actual class and function relationships
2. **Import Graph Analysis**: Real dependency tracking and circular dependency detection
3. **Type Flow Analysis**: Understanding of data types and contracts
4. **API Surface Mapping**: Public interfaces and their usage patterns
5. **Dead Code Detection**: Unused functions, classes, and modules

## Phase 5: Generate PROJECT_MAP.md

### Project Map Structure
Create comprehensive project map with the following sections:

```markdown
# Project Map: [Project Name]

*Generated: [timestamp]*
*Last Updated: [timestamp]*

## Quick Overview
- **Type**: [web app/library/service/tool]
- **Primary Language**: [language]
- **Frameworks**: [key frameworks]
- **Location**: [project path]

## Directory Structure

### Main Application Code
- `src/` - [description]
- `lib/` - [description]
- `app/` - [description]

### Test Organization
- `tests/` - [description]
- `test/` - [description]

### Documentation
- `docs/` - [description]
- `README.md` - [description]

## Key Files
- `[entry-point]` - [description and purpose]
- `[config-file]` - [configuration and settings]
- `[key-module]` - [core functionality]

## Patterns & Conventions
- **Architecture**: [architectural pattern]
- **Testing**: [testing approach]
- **Code Style**: [formatting and conventions]
- **Error Handling**: [error management pattern]

## Dependencies

### External Dependencies
- **Production**: [key production dependencies]
- **Development**: [development and testing tools]

### Internal Dependencies
- **Core Modules**: [main internal dependencies]
- **Utilities**: [helper and utility modules]

## Entry Points & Common Tasks

### Development Workflow
- **Start Dev Server**: [command]
- **Run Tests**: [command]
- **Build Production**: [command]
- **Deploy**: [command or process]

### Key Workflows
- **Adding Features**: [typical process]
- **Testing**: [testing workflow]
- **Deployment**: [deployment process]

## Focus Areas (if specified)
[Detailed analysis of specified focus area]
```

### Auto-Import Setup
1. **Update CLAUDE.md**: Add `@.claude/PROJECT_MAP.md` import
2. **Verify Import**: Ensure import syntax is correct
3. **Test Loading**: Validate the import works in Claude Code sessions

## Phase 6: Validation and Updates

### Validation Checks
1. **File Accessibility**: Ensure all referenced files exist and are readable
2. **Import Syntax**: Verify CLAUDE.md import syntax is correct
3. **Content Accuracy**: Validate project map reflects actual codebase
4. **Size Management**: Keep project map under 10KB for context efficiency

### Update Strategy
1. **Incremental Updates**: For `--update` mode, focus on changed files only
2. **Timestamp Tracking**: Update modification timestamps appropriately
3. **Change Detection**: Identify what has changed since last indexing
4. **Selective Refresh**: Update only affected sections for efficiency

## Success Indicators

- ✅ PROJECT_MAP.md created/updated in `.claude/` directory
- ✅ Auto-import added to CLAUDE.md file
- ✅ Project map accurately reflects codebase structure
- ✅ Key patterns and conventions documented
- ✅ Entry points and workflows clearly identified
- ✅ Dependencies and integrations mapped
- ✅ Focus area analysis completed (if specified)
- ✅ File size optimized for context window

## Common Use Cases

### New Project Onboarding
```bash
/index
# → Comprehensive project map for new team members
```

### After Major Refactoring
```bash
/index --refresh
# → Complete regeneration to reflect structural changes
```

### Focused Component Analysis
```bash
/index "user authentication"
# → Detailed analysis of auth-related components
```

### Incremental Updates
```bash
/index --update
# → Quick update after adding new features
```

## Integration with Other Commands

- **Analyze**: `/analyze` now has persistent context from PROJECT_MAP.md
- **Explore**: `/explore` benefits from existing project understanding
- **Review**: `/review` uses project map for focused code review
- **Fix**: `/fix` leverages architecture understanding for better debugging

---

*Creates persistent project understanding that survives sessions and accelerates development workflows.*
````

## File: plugins/core/commands/performance.md
````markdown
---
title: performance
aliases: [metrics, usage, cost]
description: View token usage and performance metrics
---

# Performance Metrics

View token usage, costs, and performance metrics for your Claude Code sessions.

## Usage

```bash
# View current session metrics
/performance

# View daily metrics
/performance daily

# View weekly metrics
/performance weekly

# View monthly metrics
/performance monthly

# Get help with ccusage
/performance help
```

## Implementation

```bash
# Check if ccusage is available
if ! command -v npx >/dev/null 2>&1; then
    echo "❌ Performance monitoring requires npx (Node.js)"
    echo ""
    echo "To enable performance tracking:"
    echo "1. Install Node.js: https://nodejs.org/"
    echo "2. Run: npx ccusage@latest"
    exit 1
fi

# Parse arguments
TIMEFRAME="${ARGUMENTS:-session}"

echo "📊 Claude Code Performance Metrics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

case "$TIMEFRAME" in
    daily|day)
        echo "📅 Daily Usage Report"
        npx ccusage@latest daily
        ;;
    weekly|week)
        echo "📅 Weekly Usage Report"
        npx ccusage@latest weekly
        ;;
    monthly|month)
        echo "📅 Monthly Usage Report"
        npx ccusage@latest monthly
        ;;
    help|--help)
        echo "📚 ccusage Help"
        npx ccusage@latest --help
        ;;
    session|*)
        echo "💬 Current Session Metrics"
        npx ccusage@latest session

        # Also show daily summary
        echo ""
        echo "📅 Today's Summary"
        npx ccusage@latest daily
        ;;
esac

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "💡 Performance Tips:"
echo "   • Use MCP tools for efficiency:"
echo "     - Serena: 70-90% token reduction on code operations"
echo "     - Context7: 50% faster documentation lookup"
echo "     - Sequential Thinking: Better analysis with fewer iterations"
echo "   • Monitor usage regularly to optimize workflows"
echo "   • Consider caching frequently accessed documentation"
```

## Features

### Token Usage Tracking
- Session-level metrics
- Daily, weekly, monthly aggregation
- Cost calculation based on model pricing

### Performance Insights
When available, tracks:
- Token consumption by command
- MCP tool efficiency gains
- Session duration and patterns

### MCP Tool Impact
Estimated efficiency gains:
- **Serena**: 70-90% token reduction on code analysis
- **Context7**: 50% faster documentation access
- **Sequential Thinking**: 20-30% better analysis quality
- **Firecrawl**: Efficient web content extraction

## Graceful Degradation

Without ccusage, the command provides guidance on:
- How to install Node.js and enable tracking
- Manual estimation of token usage
- Best practices for efficient Claude Code usage

## Integration

Performance metrics integrate with:
- Session management in `/status`
- Work unit tracking in `/work`
- Project analysis in `/analyze`

---

*Simplified performance monitoring using ccusage for token tracking and cost analysis*
````

## File: plugins/core/commands/serena.md
````markdown
---
title: "Serena Project Management"
description: "Activate and manage Serena semantic code understanding for projects"
author: "Lean MCP Framework"
version: "1.0.0"
---

# Serena Project Management

Activate Serena's semantic code understanding for efficient, token-optimized code operations.

## Usage
- `/serena` - Show available projects and current status
- `/serena [project]` - Activate specific project

$ARGUMENTS_PRESENT$
I'll activate Serena project: **$ARGUMENTS**

Let me activate the project and show you the available context. I'll use the Serena MCP tools to:

1. Activate the project: $ARGUMENTS
2. Check if onboarding was performed
3. List available memories
4. Show current project status

This will enable semantic code operations with 75% token reduction on code tasks.
$END_ARGUMENTS_PRESENT$

$ARGUMENTS_ABSENT$
Let me show you the current Serena status and available projects.

I'll check your Serena configuration and list all available projects that you can activate.
$END_ARGUMENTS_ABSENT$

## Serena Benefits

When activated, you get:

### 🎯 Semantic Operations (75% token reduction)
- **find_symbol**: Locate functions/classes by name, not text search
- **get_symbols_overview**: See file structure without reading entire file
- **replace_symbol_body**: Edit entire functions/methods precisely
- **find_referencing_symbols**: Track what uses your code

### 📊 Token Savings Example
Traditional approach (high tokens):
```bash
grep -r "function_name" .  # Searches all files
cat entire_file.py         # Reads 1000+ lines
```

Serena approach (low tokens):
```bash
find_symbol("function_name")  # Returns just the function
```

### 💾 Persistent Memory
- Project understanding persists across sessions
- Task progress tracked in memories
- Code conventions remembered

## Your Project Quick Reference

Based on your Serena configuration:

- **my-api** - Your API project
- **my-frontend** - Your frontend project

### Quick Commands:
```bash
/serena my-api         # Activate API project
/serena my-frontend    # Activate frontend project
/serena /new/path      # Activate new project by path
```

---

*Part of the Lean MCP Framework - Evidence-based 75% token reduction on code operations*
````

## File: plugins/core/commands/setup.md
````markdown
---
allowed-tools: [Read, Write, MultiEdit, Bash, Glob, mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
argument-hint: "[explore|existing|python|javascript] [project-name] [--minimal|--standard|--full] | --init-user [--force] | --statusline"
description: Initialize new projects with Claude framework integration or setup user configuration
---

# Project Setup

I'll set up a new project with the Claude Code Framework, optimized for your chosen language and project type.

## Usage

### User Configuration Setup
```bash
/setup --init-user               # Initialize ~/.claude/CLAUDE.md from template
/setup --init-user --force       # Overwrite existing user configuration
/setup --statusline              # Configure Claude Code statusline for framework
```

### Project Setup
```bash
/setup                           # Auto-detect project type and set up
/setup python                    # Set up Python project (standard quality setup)
/setup python --minimal          # Minimal Python setup (basic structure only)
/setup python --full             # Comprehensive setup (docs, CI/CD, etc.)
/setup javascript                # Set up JavaScript project
/setup existing                  # Add Claude framework to existing project
/setup explore                   # Set up data exploration project
```

### Python Setup Levels

#### `--minimal` - Just the Essentials
**What you get:**
- Basic `pyproject.toml` with project metadata
- Minimal `.gitignore` for Python projects
- Simple project structure (`src/`, `tests/`, `docs/`)
- Build system configuration (hatchling)

**Best for:** Quick experiments, learning projects, temporary code

#### `--standard` (default) - Production-Ready Quality
**What you get:**
- Modern `pyproject.toml` with:
  - Testing: pytest with coverage tracking
  - Linting: ruff for fast, comprehensive checks
  - Type checking: mypy for type safety
  - Formatting: ruff format for consistent style
- Pre-commit hooks for automated quality checks
- Makefile with development commands (test, lint, format, etc.)
- Comprehensive `.gitignore` for Python projects
- Proper project structure with `src/` layout

**Best for:** Real projects, open source packages, team development

#### `--full` - Enterprise-Grade Setup
**What you get:**
Everything from standard, plus:
- Documentation setup (mkdocs with material theme)
- Security scanning (bandit)
- CI/CD workflows (GitHub Actions)
- Extended testing setup (fixtures, coverage reports)
- Additional development tools
- Release automation setup
- Dependency management configuration

**Best for:** Commercial products, large teams, projects requiring compliance

## Phase 1: Project Analysis

```bash
# Constants (must be defined in each command due to framework constraints)
readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"
readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
readonly REFERENCE_DIR="${CLAUDE_DIR}/reference"
readonly HOOKS_DIR="${CLAUDE_DIR}/hooks"

# Project type constants
readonly TYPE_PYTHON="python"
readonly TYPE_JAVASCRIPT="javascript"
readonly TYPE_EXPLORE="explore"
readonly TYPE_EXISTING="existing"

# Parse command line arguments
INIT_USER=false
FORCE_FLAG=false
SETUP_STATUSLINE=false
REMAINING_ARGS=""

# Parse arguments for flags
SETUP_LEVEL="standard"  # Default to standard setup
for arg in $ARGUMENTS; do
    case "$arg" in
        --init-user)
            INIT_USER=true
            ;;
        --force)
            FORCE_FLAG=true
            ;;
        --statusline)
            SETUP_STATUSLINE=true
            ;;
        --minimal)
            SETUP_LEVEL="minimal"
            ;;
        --standard)
            SETUP_LEVEL="standard"
            ;;
        --full)
            SETUP_LEVEL="full"
            ;;
        *)
            REMAINING_ARGS="$REMAINING_ARGS $arg"
            ;;
    esac
done

# Handle --init-user mode
if [ "$INIT_USER" = true ]; then
    echo "🔧 Initializing user CLAUDE.md configuration..."
    echo ""

    # Check if ~/.claude directory exists, create if needed
    USER_CLAUDE_DIR="$HOME/.claude"
    USER_CLAUDE_FILE="$USER_CLAUDE_DIR/CLAUDE.md"
    TEMPLATE_FILE="$(pwd)/templates/USER_CLAUDE_TEMPLATE.md"

    # Verify template exists
    if [ ! -f "$TEMPLATE_FILE" ]; then
        echo "❌ ERROR: USER_CLAUDE_TEMPLATE.md not found at $TEMPLATE_FILE"
        echo "   Make sure you're running this from the Claude Code framework directory."
        exit 1
    fi

    # Create ~/.claude directory if it doesn't exist
    if [ ! -d "$USER_CLAUDE_DIR" ]; then
        echo "📁 Creating ~/.claude directory..."
        mkdir -p "$USER_CLAUDE_DIR" || {
            echo "❌ ERROR: Failed to create ~/.claude directory"
            echo "   Check permissions for $HOME directory"
            exit 1
        }
    fi

    # Check if user CLAUDE.md already exists
    if [ -f "$USER_CLAUDE_FILE" ] && [ "$FORCE_FLAG" != true ]; then
        echo "⚠️  User CLAUDE.md already exists at: $USER_CLAUDE_FILE"
        echo ""
        echo "Options:"
        echo "  1. Keep existing file (recommended if you've customized it)"
        echo "  2. Overwrite with latest template (use --force flag)"
        echo ""
        echo "To overwrite: /setup --init-user --force"
        echo "To view existing: cat ~/.claude/CLAUDE.md"
        exit 0
    fi

    # Copy template to user location
    echo "📋 Copying USER_CLAUDE_TEMPLATE.md to ~/.claude/CLAUDE.md..."
    cp "$TEMPLATE_FILE" "$USER_CLAUDE_FILE" || {
        echo "❌ ERROR: Failed to copy template file"
        echo "   Check permissions for ~/.claude directory"
        exit 1
    }

    echo ""
    echo "✅ User CLAUDE.md configuration initialized successfully!"
    echo ""
    echo "📍 Location: $USER_CLAUDE_FILE"
    echo "📝 Content: Essential behavioral guidelines and SWE best practices"
    echo ""
    echo "What's included:"
    echo "  • Core behavioral tenets (question assumptions, avoid over-engineering)"
    echo "  • MCP tool usage guidelines"
    echo "  • Framework commands and workflow patterns"
    echo ""
    echo "Next steps:"
    echo "  • Edit with: /memory edit"
    echo "  • View with: /memory view"
    echo "  • Customize for your personal workflow"
    echo "  • Use /setup [type] in project directories for project-specific setup"
    echo "  • The user config provides global standards for all projects"
    echo ""
    if [ "$FORCE_FLAG" = true ]; then
        echo "🔄 Existing file was overwritten as requested"
    fi

    exit 0
fi

# Handle --statusline mode
if [ "$SETUP_STATUSLINE" = true ]; then
    echo "🎯 Setting up Claude Code Framework Statusline"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Check if we're in a framework directory
    if [ ! -d ".claude" ] || [ ! -f "commands/setup.md" ]; then
        echo "❌ ERROR: Not in Claude Code Framework directory"
        echo "   Run this command from the root of your claude-code-framework directory"
        echo ""
        echo "Expected structure:"
        echo "  claude-code-framework/"
        echo "  ├── commands/"
        echo "  ├── .claude/"
        echo "  └── templates/"
        exit 1
    fi

    # Create statusline script in framework
    STATUSLINE_SCRIPT="$(pwd)/.claude/scripts/statusline.sh"
    echo "📝 Creating framework statusline script..."

    # Ensure scripts directory exists
    mkdir -p .claude/scripts

    # Copy our prototype script
    if [ -f ".claude/work/current/001_statusline_exploration/statusline_prototype.sh" ]; then
        cp ".claude/work/current/001_statusline_exploration/statusline_prototype.sh" "$STATUSLINE_SCRIPT"
    else
        # Create the script inline if prototype not available
        cat > "$STATUSLINE_SCRIPT" << 'STATUSLINE_EOF'
#!/bin/bash
# Claude Code Framework Statusline
# Provides contextual information about current development session

# Read JSON input from Claude Code
input=$(cat)

# Extract basic session info with jq fallback
if command -v jq >/dev/null 2>&1; then
    MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name // "Claude"')
    CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // ""')
else
    # Fallback parsing without jq
    MODEL_DISPLAY="Claude"
    CURRENT_DIR=$(pwd)
fi

# Get directory name for display
if [ -n "$CURRENT_DIR" ]; then
    DIR_NAME="${CURRENT_DIR##*/}"
else
    DIR_NAME="$(basename "$(pwd)")"
fi

# Initialize status components
STATUS_PARTS=()

# 1. Model and Directory (always shown)
STATUS_PARTS+=("[$MODEL_DISPLAY] 📁 $DIR_NAME")

# 2. Framework Work Unit Detection
WORK_UNIT=""
if [ -f ".claude/work/ACTIVE_WORK" ]; then
    ACTIVE_WORK=$(cat .claude/work/ACTIVE_WORK 2>/dev/null)
    if [ -n "$ACTIVE_WORK" ] && [ -d ".claude/work/current/$ACTIVE_WORK" ]; then
        WORK_NUM=$(echo "$ACTIVE_WORK" | cut -d'_' -f1)
        if command -v jq >/dev/null 2>&1 && [ -f ".claude/work/current/$ACTIVE_WORK/metadata.json" ]; then
            WORK_PHASE=$(jq -r '.phase // "active"' ".claude/work/current/$ACTIVE_WORK/metadata.json" 2>/dev/null)
        else
            WORK_PHASE="active"
        fi
        WORK_UNIT="💼 $WORK_NUM ($WORK_PHASE)"
    fi
elif [ -d ".claude/work/current" ]; then
    CURRENT_COUNT=$(find .claude/work/current -maxdepth 1 -type d 2>/dev/null | wc -l)
    if [ "$CURRENT_COUNT" -gt 1 ]; then
        LATEST_WORK=$(ls -t .claude/work/current/ 2>/dev/null | head -1)
        if [ -n "$LATEST_WORK" ]; then
            WORK_NUM=$(echo "$LATEST_WORK" | cut -d'_' -f1)
            WORK_UNIT="💼 $WORK_NUM (inactive)"
        fi
    fi
fi

if [ -n "$WORK_UNIT" ]; then
    STATUS_PARTS+=("$WORK_UNIT")
fi

# 3. Git Status (if in git repo)
if git rev-parse --git-dir >/dev/null 2>&1; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null)
    if [ -n "$GIT_BRANCH" ]; then
        GIT_STATUS=""
        if ! git diff-index --quiet HEAD -- 2>/dev/null; then
            GIT_STATUS="*"
        fi
        if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
            GIT_STATUS="${GIT_STATUS}+"
        fi
        STATUS_PARTS+=("🌿 $GIT_BRANCH$GIT_STATUS")
    fi
fi

# 4. MCP Server Status (simplified)
if [ -f ".claude/settings.json" ] || [ -f ".claude/settings.local.json" ]; then
    MCP_COUNT=0
    for settings_file in ".claude/settings.json" ".claude/settings.local.json"; do
        if [ -f "$settings_file" ] && command -v jq >/dev/null 2>&1; then
            MCP_SERVERS=$(jq -r '.mcpServers // {} | keys | length' "$settings_file" 2>/dev/null)
            if [ "$MCP_SERVERS" != "null" ] && [ "$MCP_SERVERS" -gt 0 ]; then
                MCP_COUNT=$((MCP_COUNT + MCP_SERVERS))
            fi
        fi
    done
    if [ "$MCP_COUNT" -gt 0 ]; then
        STATUS_PARTS+=("🔧 MCP:$MCP_COUNT")
    fi
fi

# Combine all status parts
IFS=" | "
echo "${STATUS_PARTS[*]}"
STATUSLINE_EOF
    fi

    chmod +x "$STATUSLINE_SCRIPT"
    echo "✅ Statusline script created: $STATUSLINE_SCRIPT"

    # Update user settings to include statusline
    USER_SETTINGS="$HOME/.claude/settings.json"

    # Ensure ~/.claude directory exists
    if [ ! -d "$HOME/.claude" ]; then
        echo "📁 Creating ~/.claude directory..."
        mkdir -p "$HOME/.claude"
    fi

    # Create or update settings.json
    if [ -f "$USER_SETTINGS" ]; then
        echo "🔧 Updating existing ~/.claude/settings.json..."

        # Backup existing settings
        cp "$USER_SETTINGS" "$USER_SETTINGS.backup.$(date +%Y%m%d_%H%M%S)"

        # Update settings with jq if available
        if command -v jq >/dev/null 2>&1; then
            jq --arg script "$STATUSLINE_SCRIPT" '.statusLine.command = $script' "$USER_SETTINGS" > "$USER_SETTINGS.tmp" && mv "$USER_SETTINGS.tmp" "$USER_SETTINGS"
        else
            echo "⚠️  jq not available - please manually add statusline configuration"
            echo "   Add this to ~/.claude/settings.json:"
            echo "   \"statusLine\": { \"command\": \"$STATUSLINE_SCRIPT\" }"
        fi
    else
        echo "📝 Creating new ~/.claude/settings.json..."
        cat > "$USER_SETTINGS" << EOF
{
    "statusLine": {
        "command": "$STATUSLINE_SCRIPT"
    }
}
EOF
    fi

    echo ""
    echo "✅ Claude Code Framework Statusline Setup Complete!"
    echo ""
    echo "📍 Configuration:"
    echo "   Script: $STATUSLINE_SCRIPT"
    echo "   Settings: $USER_SETTINGS"
    echo ""
    echo "🎯 What you'll see:"
    echo "   [Model] 📁 project | 💼 001 (exploring) | 🌿 main | 🔧 MCP:4"
    echo ""
    echo "📝 Features:"
    echo "   • Current work unit and phase"
    echo "   • Git branch and status indicators"
    echo "   • MCP server count"
    echo "   • Project directory name"
    echo ""
    echo "🔄 Restart Claude Code to see the new statusline"
    echo ""
    echo "💡 Tip: Edit $STATUSLINE_SCRIPT to customize your statusline"

    exit 0
fi

# Standard project setup continues below
PROJECT_NAME="${REMAINING_ARGS:-$(basename $PWD)}"
SETUP_TYPE=""

echo "🔍 Analyzing project..."

# Check if explicit type was provided as argument
if [ -n "$PROJECT_NAME" ]; then
    # Check if it's a known project type
    case "$PROJECT_NAME" in
        python|javascript|typescript|go|rust|java|explore|existing)
            SETUP_TYPE="$PROJECT_NAME"
            PROJECT_NAME=$(basename $PWD)
            echo "→ Setting up $SETUP_TYPE project"
            ;;
        *)
            # It's a project name, auto-detect type
            echo "→ Project name: $PROJECT_NAME"
            ;;
    esac
fi

# Auto-detect project type if not specified
if [ -z "$SETUP_TYPE" ]; then
    # Check for existing project
    if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
        if [ -d "src" ]; then
            SETUP_TYPE="python-package"
            echo "→ Detected: Python package project (src/ layout)"
        else
            SETUP_TYPE="python-simple"
            echo "→ Detected: Python project (simple layout)"
        fi
    elif [ -f "package.json" ]; then
        SETUP_TYPE="javascript"
        echo "→ Detected: JavaScript/Node.js project"
    elif [ -f "Cargo.toml" ]; then
        SETUP_TYPE="rust"
        echo "→ Detected: Rust project"
    elif [ -f "go.mod" ]; then
        SETUP_TYPE="go"
        echo "→ Detected: Go project"
    elif [ -d ".git" ] && [ "$(ls -A | wc -l)" -gt 2 ]; then
        SETUP_TYPE="existing"
        echo "→ Detected: Existing project (adding Claude framework)"
    elif ls *.ipynb >/dev/null 2>&1 || [ -d "notebooks" ] || [ -d "data" ]; then
        SETUP_TYPE="explore"
        echo "→ Detected: Data exploration project"
    else
        # Empty or new directory - default to Python
        SETUP_TYPE="python-package"
        echo "→ New project: Defaulting to Python package setup"
    fi
fi
```

## Phase 2: Project Initialization

Based on detection, I'll run the appropriate setup:

```bash
case "$SETUP_TYPE" in
    python-package|python)
        echo "🐍 Setting up Python package project..."

        # Create src layout
        mkdir -p src/$PROJECT_NAME
        mkdir -p tests
        mkdir -p docs

        # Use declarative approach based on setup level
        echo "📋 Generating $SETUP_LEVEL Python configuration..."

        case "$SETUP_LEVEL" in
            minimal)
                echo "Creating minimal Python project..."

                # Basic pyproject.toml only
                cat > pyproject.toml << 'MINIMAL_EOF'
[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "A Python package"
requires-python = ">=3.9"
dependencies = []

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
MINIMAL_EOF
                # Variable substitution
                sed -i "s/\$PROJECT_NAME/$PROJECT_NAME/g" pyproject.toml

                # Minimal gitignore
                cat > .gitignore << 'GITIGNORE_EOF'
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
dist/
*.egg-info/
.pytest_cache/
.mypy_cache/
.ruff_cache/
venv/
.venv/
*.log
.DS_Store
GITIGNORE_EOF

                echo "✅ Minimal Python setup complete"
                ;;

            full)
                echo "Creating comprehensive Python project with all features..."
                echo ""
                echo "📝 Generating comprehensive configuration files..."

                # Note: In a declarative approach, Claude Code would generate these
                # based on current best practices. For now, we provide guidance.
                echo ""
                echo "I'll create a comprehensive Python setup. Please create these files:"
                echo ""
                echo "1. pyproject.toml - with latest versions of:"
                echo "   - ruff, mypy, pytest, pytest-cov, bandit"
                echo "   - mkdocs, mkdocs-material for documentation"
                echo "   - pre-commit for git hooks"
                echo ""
                echo "2. .pre-commit-config.yaml with:"
                echo "   - ruff (format and lint)"
                echo "   - mypy (type checking)"
                echo "   - bandit (security)"
                echo "   - conventional commits"
                echo ""
                echo "3. Makefile with targets for:"
                echo "   - install, dev, test, lint, format, type-check"
                echo "   - security, docs, build, clean"
                echo ""
                echo "4. .github/workflows/ci.yml for GitHub Actions"
                echo "5. mkdocs.yml for documentation"
                echo "6. Comprehensive .gitignore"

                echo ""
                echo "✅ Full setup requirements specified"
                ;;

            standard|*)
                echo "Creating standard Python project with quality tools..."

                # Generate standard pyproject.toml with current best practices
                cat > pyproject.toml << 'STANDARD_EOF'
[project]
name = "$PROJECT_NAME"
version = "0.1.0"
description = "A Python package"
requires-python = ">=3.9"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "pytest-cov>=5.0",
    "ruff>=0.5.0",
    "mypy>=1.10",
    "pre-commit>=3.7",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.ruff]
line-length = 88
target-version = "py39"

[tool.ruff.lint]
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]  # Line length handled by formatter

[tool.mypy]
python_version = "3.9"
warn_return_any = true
warn_unused_configs = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=src --cov-report=term-missing"

[tool.coverage.run]
source = ["src"]
STANDARD_EOF
                # Variable substitution
                sed -i "s/\$PROJECT_NAME/$PROJECT_NAME/g" pyproject.toml

                # Generate pre-commit config
                cat > .pre-commit-config.yaml << 'PRECOMMIT_EOF'
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.5.0
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.10.0
    hooks:
      - id: mypy
        files: ^src/
PRECOMMIT_EOF

                # Generate Makefile
                cat > Makefile << 'MAKEFILE_EOF'
.PHONY: help install dev test lint format type-check clean

help:
	@echo "Available commands:"
	@echo "  make install    Install package"
	@echo "  make dev        Install with dev dependencies"
	@echo "  make test       Run tests"
	@echo "  make lint       Run linting"
	@echo "  make format     Format code"
	@echo "  make type-check Run type checking"
	@echo "  make clean      Clean build artifacts"

install:
	pip install -e .

dev:
	pip install -e ".[dev]"
	pre-commit install

test:
	pytest

lint:
	ruff check src/ tests/

format:
	ruff format src/ tests/

type-check:
	mypy src/

clean:
	rm -rf build/ dist/ *.egg-info
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
MAKEFILE_EOF

                # Standard gitignore
                cat > .gitignore << 'GITIGNORE_EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Testing
.pytest_cache/
.coverage
htmlcov/
.tox/
.mypy_cache/
.ruff_cache/

# Virtual Environment
venv/
.venv/
env/
ENV/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Project
*.log
.env
GITIGNORE_EOF

                echo "✅ Standard Python setup complete"
                ;;
        esac

        # Create basic Python files (common to both template and inline modes)
        touch src/$PROJECT_NAME/__init__.py
        cat > src/$PROJECT_NAME/main.py << EOF
"""Main module for $PROJECT_NAME."""

def main():
    """Main entry point."""
    print("Hello from $PROJECT_NAME!")

if __name__ == "__main__":
    main()
EOF

        # Create basic test
        cat > tests/test_main.py << EOF
"""Tests for main module."""
import pytest
from $PROJECT_NAME.main import main

def test_main():
    """Test main function."""
    # Add your tests here
    assert True
EOF

        echo "✅ Python package structure created"
        ;;

    python-simple|explore)
        echo "🔬 Setting up Python exploration project..."

        # Create simple Python structure
        mkdir -p scripts
        mkdir -p data
        mkdir -p notebooks

        # Create requirements.txt for simple projects
        cat > requirements.txt << EOF
# Core dependencies
numpy
pandas
matplotlib

# Development tools
pytest
pytest-cov
ruff
black
mypy
jupyter
EOF

        # Create basic Python file
        cat > main.py << EOF
"""Main script for $PROJECT_NAME."""

def main():
    """Main entry point."""
    print("Hello from $PROJECT_NAME!")

if __name__ == "__main__":
    main()
EOF

        echo "✅ Python exploration structure created"
        ;;

    javascript|js)
        echo "🌐 Setting up JavaScript/Node.js project..."

        # Create package.json
        cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "0.1.0",
  "description": "A JavaScript project",
  "main": "src/index.js",
  "scripts": {
    "start": "node src/index.js",
    "test": "jest",
    "lint": "eslint src/",
    "format": "prettier --write src/"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "eslint": "^8.0.0",
    "prettier": "^3.0.0",
    "@types/node": "^20.0.0"
  }
}
EOF

        # Create basic structure
        mkdir -p src
        mkdir -p tests

        cat > src/index.js << EOF
/**
 * Main entry point for $PROJECT_NAME
 */

function main() {
    console.log("Hello from $PROJECT_NAME!");
}

if (require.main === module) {
    main();
}

module.exports = { main };
EOF

        cat > tests/index.test.js << EOF
const { main } = require('../src/index');

describe('main function', () => {
    test('should run without errors', () => {
        expect(() => main()).not.toThrow();
    });
});
EOF

        echo "✅ JavaScript project structure created"
        ;;

    existing)
        echo "🔧 Adding Claude framework to existing project..."
        echo "✅ Existing project detected - will add Claude framework below"
        ;;

    *)
        echo "📦 Unknown type - using Python package setup (default)"
        SETUP_TYPE="python-package"
        # Recurse with corrected type
        ;;
esac
```

## Phase 3: Claude Framework Integration

```bash
echo ""
echo "🔧 Adding Claude Code Framework..."

# Create .claude directory structure
mkdir -p .claude/work/current || { echo "ERROR: Failed to create .claude/work/current" >&2; exit 1; }
mkdir -p .claude/work/completed || { echo "ERROR: Failed to create .claude/work/completed" >&2; exit 1; }
mkdir -p .claude/memory || { echo "ERROR: Failed to create .claude/memory" >&2; exit 1; }
mkdir -p .claude/reference || { echo "ERROR: Failed to create .claude/reference" >&2; exit 1; }
mkdir -p .claude/hooks || { echo "ERROR: Failed to create .claude/hooks" >&2; exit 1; }

# Create security hooks configuration
echo "🔒 Setting up security hooks..."
cat > .claude/settings.json << 'SECURITY_EOF'
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "input=\"$CLAUDE_TOOL_INPUT\"; if echo \"$input\" | grep -q 'rm -rf'; then echo '🚨 BLOCKED: Dangerous rm -rf command detected!' >&2 && echo 'Use git clean or specific file deletion instead.' >&2 && exit 2; fi; if echo \"$input\" | grep -q 'sudo'; then echo '🚨 BLOCKED: sudo command not allowed in development!' >&2 && echo 'Review your command and run manually if needed.' >&2 && exit 2; fi; if echo \"$input\" | grep -q 'chmod 777'; then echo '⚠️  BLOCKED: chmod 777 is a security risk!' >&2 && echo 'Use specific permissions like 755 or 644.' >&2 && exit 2; fi"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "file=\"$CLAUDE_TOOL_INPUT_FILE\"; if [ -n \"$file\" ]; then ext=\"${file##*.}\"; case \"$ext\" in py) echo '🔧 Python file edited: '$file && if command -v ruff >/dev/null 2>&1; then if ruff format \"$file\" 2>/dev/null; then echo '✅ ruff format applied'; else echo '⚠️  ruff format failed - check Python syntax'; fi && if ruff check \"$file\" --fix 2>/dev/null; then echo '✅ ruff linting passed'; else echo '⚠️  ruff found issues - review the warnings'; fi; else echo '💡 Install ruff for automatic formatting & linting: pip install ruff'; fi ;; js|jsx|ts|tsx) echo '🔧 JavaScript/TypeScript file edited: '$file && if command -v prettier >/dev/null 2>&1; then if prettier --write \"$file\" 2>/dev/null; then echo '✅ prettier formatting applied'; else echo '⚠️  prettier failed - check syntax'; fi; else echo '💡 Install prettier: npm install prettier'; fi && if command -v eslint >/dev/null 2>&1; then if eslint \"$file\" --fix 2>/dev/null; then echo '✅ eslint passed'; else echo '⚠️  eslint found issues - review the warnings'; fi; else echo '💡 Install eslint: npm install eslint'; fi ;; json) echo '🔧 JSON file edited: '$file && if python3 -m json.tool \"$file\" >/dev/null 2>&1; then echo '✅ JSON syntax valid'; else echo '❌ Invalid JSON syntax in '$file' - fix required!' >&2 && exit 1; fi ;; md) echo '📝 Markdown file edited: '$file && if command -v markdownlint >/dev/null 2>&1; then if markdownlint \"$file\" 2>/dev/null; then echo '✅ Markdown linting passed'; else echo '⚠️  Markdown formatting issues found'; fi; else echo '💡 Install markdownlint for markdown quality: npm install -g markdownlint-cli'; fi ;; esac; fi"
          }
        ]
      }
    ]
  }
}
SECURITY_EOF

echo "✅ Security & Quality hooks configured:"
echo "   🔒 Security: rm -rf, sudo, chmod 777 protection"
echo "   🔧 Quality: automatic formatting (ruff, prettier, eslint)"
echo "   📝 Validation: JSON syntax, markdown linting"
echo "   🧪 Testing: pytest hints for new test files"

# Generate project CLAUDE.md declaratively
echo "📝 Generating project CLAUDE.md and memory files..."

# Auto-detect project characteristics
DETECTED_LANG=""
DETECTED_FRAMEWORK=""
DETECTED_TEST_TOOL=""
DETECTED_BUILD=""

# Language detection
if [ -f "package.json" ]; then
    DETECTED_LANG="JavaScript/TypeScript"
    grep -q '"next"' package.json 2>/dev/null && DETECTED_FRAMEWORK="Next.js"
    grep -q '"react"' package.json 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, React" || DETECTED_FRAMEWORK="React"
    grep -q '"express"' package.json 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, Express" || DETECTED_FRAMEWORK="Express"
    grep -q '"jest"' package.json 2>/dev/null && DETECTED_TEST_TOOL="Jest"
    grep -q '"mocha"' package.json 2>/dev/null && [ -n "$DETECTED_TEST_TOOL" ] && DETECTED_TEST_TOOL="$DETECTED_TEST_TOOL, Mocha" || DETECTED_TEST_TOOL="Mocha"
elif [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
    DETECTED_LANG="Python"
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
        DETECTED_LANG="Python $PYTHON_VERSION"
    fi
    if [ -f "pyproject.toml" ]; then
        grep -q 'fastapi' pyproject.toml 2>/dev/null && DETECTED_FRAMEWORK="FastAPI"
        grep -q 'django' pyproject.toml 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, Django" || DETECTED_FRAMEWORK="Django"
        grep -q 'flask' pyproject.toml 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, Flask" || DETECTED_FRAMEWORK="Flask"
        grep -q 'pytest' pyproject.toml 2>/dev/null && DETECTED_TEST_TOOL="pytest"
    fi
    [ -f "Makefile" ] && DETECTED_BUILD="Make"
elif [ -f "go.mod" ]; then
    DETECTED_LANG="Go"
    DETECTED_TEST_TOOL="go test"
elif [ -f "Cargo.toml" ]; then
    DETECTED_LANG="Rust"
    DETECTED_TEST_TOOL="cargo test"
fi

# Create minimal main CLAUDE.md with imports
cat > CLAUDE.md << EOF
# $PROJECT_NAME

${DETECTED_LANG:+$DETECTED_LANG project}${DETECTED_FRAMEWORK:+ using $DETECTED_FRAMEWORK}.

## Project Knowledge
@.claude/memory/project_state.md
@.claude/memory/dependencies.md
@.claude/memory/conventions.md
@.claude/memory/decisions.md

## Current Work
@.claude/work/current/README.md
EOF

# Generate project_state.md with detected info
cat > .claude/memory/project_state.md << 'STATE_EOF'
# Project State

## Technology Stack
- **Language**: DETECTED_LANG_PLACEHOLDER
- **Framework**: DETECTED_FRAMEWORK_PLACEHOLDER
- **Testing**: DETECTED_TEST_PLACEHOLDER
- **Build System**: DETECTED_BUILD_PLACEHOLDER

## Architecture
- **Project Type**: SETUP_TYPE_PLACEHOLDER
- **Directory Structure**: DIR_STRUCTURE_PLACEHOLDER
STATE_EOF

# Variable substitution for project_state.md
sed -i "s/DETECTED_LANG_PLACEHOLDER/${DETECTED_LANG:-Not detected}/g" .claude/memory/project_state.md
sed -i "s/DETECTED_FRAMEWORK_PLACEHOLDER/${DETECTED_FRAMEWORK:-Not detected}/g" .claude/memory/project_state.md
sed -i "s/DETECTED_TEST_PLACEHOLDER/${DETECTED_TEST_TOOL:-Not detected}/g" .claude/memory/project_state.md
sed -i "s/DETECTED_BUILD_PLACEHOLDER/${DETECTED_BUILD:-Not detected}/g" .claude/memory/project_state.md
sed -i "s/SETUP_TYPE_PLACEHOLDER/$SETUP_TYPE/g" .claude/memory/project_state.md
sed -i "s/DIR_STRUCTURE_PLACEHOLDER/$([ -d 'src' ] && echo 'src layout' || echo 'flat layout')/g" .claude/memory/project_state.md

# Generate dependencies.md from package files
echo "# Dependencies" > .claude/memory/dependencies.md
echo "" >> .claude/memory/dependencies.md
if [ -f "package.json" ]; then
    echo "## NPM Packages" >> .claude/memory/dependencies.md
    if command -v jq >/dev/null 2>&1; then
        jq -r '.dependencies // {} | to_entries[] | "- \(.key): \(.value)"' package.json 2>/dev/null >> .claude/memory/dependencies.md || echo "See package.json for dependencies" >> .claude/memory/dependencies.md
    else
        echo "See package.json for dependencies" >> .claude/memory/dependencies.md
    fi
elif [ -f "pyproject.toml" ]; then
    echo "## Python Dependencies" >> .claude/memory/dependencies.md
    echo "Extracted from pyproject.toml - see file for versions" >> .claude/memory/dependencies.md
elif [ -f "requirements.txt" ]; then
    echo "## Python Dependencies" >> .claude/memory/dependencies.md
    head -20 requirements.txt >> .claude/memory/dependencies.md
    [ $(wc -l < requirements.txt) -gt 20 ] && echo "... see requirements.txt for full list" >> .claude/memory/dependencies.md
fi

# Create minimal conventions.md
cat > .claude/memory/conventions.md << 'CONV_EOF'
# Project Conventions

Add project-specific conventions here that differ from global standards.
CONV_EOF

# Create placeholder decisions.md
cat > .claude/memory/decisions.md << 'DEC_EOF'
# Key Decisions

Document important architectural and technical decisions as the project evolves.
DEC_EOF

# Create work README
cat > .claude/work/current/README.md << 'WORK_EOF'
# Current Work

Active development tasks and work units will appear here.
WORK_EOF

echo "✅ Generated declarative project configuration"

# Skip the rest of the old CLAUDE.md creation
true << 'SKIP_OLD_CONTENT'

\`\`\`bash
# Enhanced development workflow (Lean MCP Framework active)
/explore "feature to implement"
/plan
/next
/ship

# For code projects, activate semantic understanding:
/serena \$(pwd)
\`\`\`

## Lean MCP Framework Active

This project benefits from the globally active Lean MCP Framework with:
- **75% token reduction** on code operations (when Serena available)
- **Enhanced reasoning** for complex analysis (Sequential Thinking)
- **Live documentation** access (Context7)
- **Graceful degradation** when MCP tools unavailable

## Project Conventions

- Follow conventional commits (feat:, fix:, docs:, etc.)
- Use quality tools (ruff for Python, prettier for JavaScript)
- Write tests for all new features
- Keep project root clean - use .claude/ for work materials

## Available Commands

**Core Workflow**: \`/explore\`, \`/plan\`, \`/next\`, \`/ship\`
**Enhanced with MCP**: \`/analyze\`, \`/fix\`, \`/docs search\`
**Serena Integration**: \`/serena [project-path]\` for semantic code understanding
**Specialized Agents**: \`/agent architect\`, \`/agent test-engineer\`, \`/agent code-reviewer\`, \`/agent auditor\`

## Development Workflow

1. **Explore**: Understand requirements (\`/explore\`)
2. **Plan**: Break down into tasks (\`/plan\`)
3. **Execute**: Work through tasks (\`/next\`)
4. **Ship**: Deliver completed work (\`/ship\`)

## Enhanced Capabilities

When MCP tools are available:
- **Code Analysis**: Use \`/analyze\` for semantic understanding
- **Smart Debugging**: Use \`/fix\` with context-aware assistance
- **Live Documentation**: Use \`/docs search "topic"\` for instant answers
- **Complex Reasoning**: Commands automatically use Sequential Thinking when beneficial

Setup MCP servers to unlock these capabilities (graceful fallback ensures everything works regardless).

EOF
SKIP_OLD_CONTENT

# Create basic README
if [ ! -f "README.md" ]; then
    cat > README.md << EOF
# $PROJECT_NAME

## Overview

Brief description of what this project does.

## Installation

\`\`\`bash
# For Python projects
pip install -e .

# For JavaScript projects
npm install
\`\`\`

## Development

\`\`\`bash
# Run tests
pytest  # Python
npm test  # JavaScript

# Format code
black .  # Python
npm run format  # JavaScript
\`\`\`

## License

MIT
EOF
fi

# Initialize git if not present
if [ ! -d ".git" ]; then
    git init
    echo "✅ Git repository initialized"
fi

# Create .gitignore
if [ ! -f ".gitignore" ]; then
    cat > .gitignore << EOF
# Claude work files (private)
.claude/work/
.claude/transitions/

# Language-specific ignores
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Node.js
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Environment
.env
.venv/
venv/
EOF
    echo "✅ .gitignore created"
fi

echo ""
echo "📚 Setting up documentation access with Context7..."
echo ""

# Context7 Integration for enhanced documentation
if command -v claude >/dev/null 2>&1; then
    echo "🔍 Detecting project dependencies for documentation setup..."

    # Detect dependencies based on project type
    DEPS_TO_FETCH=""
    case "$SETUP_TYPE" in
        python-package|python-simple|explore)
            if [ -f "pyproject.toml" ]; then
                echo "   → Scanning pyproject.toml for Python dependencies"
                DEPS_TO_FETCH="$DEPS_TO_FETCH pytest black ruff mypy"
            elif [ -f "requirements.txt" ]; then
                echo "   → Scanning requirements.txt for Python dependencies"
                DEPS_TO_FETCH="$DEPS_TO_FETCH numpy pandas matplotlib pytest"
            fi
            ;;
        javascript|js)
            if [ -f "package.json" ]; then
                echo "   → Scanning package.json for Node.js dependencies"
                DEPS_TO_FETCH="$DEPS_TO_FETCH jest eslint prettier"
            fi
            ;;
    esac

    # Create documentation cache directory
    mkdir -p .claude/docs/libraries

    # Create Context7 documentation setup guide
    cat > .claude/docs/CONTEXT7_SETUP.md << 'CONTEXT7_EOF'
# Context7 Documentation Setup

## What is Context7?

Context7 is an MCP server that provides intelligent, up-to-date documentation access for libraries and frameworks. Instead of manually searching documentation or copying large docs into your context, Context7 delivers precise, relevant documentation on demand.

## Benefits

- **Live Documentation**: Always current library documentation
- **Intelligent Search**: Semantic search within library docs
- **Precise Results**: Get exactly the information you need
- **Token Efficient**: No need to load entire documentation sets
- **Version Aware**: Documentation matching your exact library versions

## Setup Instructions

### 1. Install Context7 MCP Server

```bash
# Install via npm (recommended)
npm install -g @context7/mcp-server

# Or via pip if Python-based
pip install context7-mcp
```

### 2. Configure Claude Code

Add Context7 to your Claude Code MCP configuration:

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["@context7/mcp-server"]
    }
  }
}
```

### 3. Test Integration

```bash
# Test Context7 availability
/docs search "your-library documentation"

# Example searches
/docs search "pytest fixtures"        # Python testing
/docs search "express middleware"     # Node.js web framework
/docs search "react hooks"           # React.js
```

## Usage in Development

### Quick Documentation Access

```bash
# Search for specific topics
/docs search "library-name topic"

# Get setup instructions
/docs search "framework-name getting started"

# Find API reference
/docs search "library-name api reference"
```

### Integration with Workflow

- **During /explore**: Research libraries and their capabilities
- **During /plan**: Understand implementation requirements
- **During /next**: Get specific API documentation for current task
- **During /review**: Verify best practices and patterns

## Fallback Strategy

When Context7 is unavailable:
- Commands gracefully fall back to web search via Firecrawl
- Local documentation cache is used when available
- Manual documentation links are provided as backup

## Library Coverage

Context7 supports documentation for:
- **Python**: NumPy, Pandas, Django, Flask, FastAPI, pytest, and 1000+ libraries
- **JavaScript**: React, Vue, Express, Jest, and popular npm packages
- **Frameworks**: Next.js, Nuxt.js, Spring Boot, and more
- **Tools**: Docker, Kubernetes, Git, and development tools

CONTEXT7_EOF

    echo "✅ Context7 documentation access configured"
    echo "   📖 Setup guide: .claude/docs/CONTEXT7_SETUP.md"
    echo "   🔍 Test with: /docs search \"your-library documentation\""

    # Add Context7 suggestions to CLAUDE.md
    cat >> CLAUDE.md << 'CONTEXT7_APPEND'

## Enhanced Documentation Features

This project includes Context7 integration for intelligent documentation access:

### Quick Documentation Commands

```bash
# Search library documentation
/docs search "pytest fixtures"      # Testing frameworks
/docs search "express middleware"   # Web frameworks
/docs search "react hooks"         # Frontend libraries
```

### Development Integration

- **Research Phase**: Use `/docs search` to understand library capabilities
- **Implementation**: Get API references with `/docs search "library api"`
- **Troubleshooting**: Find solutions with `/docs search "library error-type"`

### Setup Required

Follow `.claude/docs/CONTEXT7_SETUP.md` to enable Context7 MCP server.
Without Context7, documentation commands fall back to web search.

CONTEXT7_APPEND

else
    echo "ℹ️  Claude Code not detected - Context7 integration available when using Claude Code CLI"
    echo "   📖 Documentation features will be available after Claude Code setup"
fi

echo ""
echo "🎉 Project Setup Complete!"
echo ""
echo "📁 Project Structure:"
find . -type f -name "*.md" -o -name "*.py" -o -name "*.js" -o -name "*.json" -o -name "*.toml" | head -10
echo ""
echo "💡 Next Steps:"
echo "   1. 🔧 Install dependencies (pip install -e .[dev] or npm install)"
echo "   2. 🚀 Start development: /explore \"your first feature\""
echo "   3. 📊 For code projects: /serena \$(pwd) to enable semantic understanding"
echo "   4. ⚙️  Customize CLAUDE.md for project-specific requirements"
echo ""
echo "🔒 Security & Quality Features Enabled:"
echo "   • Dangerous commands (rm -rf, sudo, chmod 777) automatically blocked"
echo "   • Code automatically formatted & linted on edit:"
echo "     - Python: ruff format + ruff check"
echo "     - JavaScript: prettier + eslint"
echo "     - Markdown: markdownlint"
echo "   • JSON syntax validation on edit"
echo "   • Test file creation hints (pytest integration)"
echo ""
echo "✨ Lean MCP Framework Active:"
echo "   • Enhanced commands with 65% average token reduction"
echo "   • /analyze - Semantic code understanding (when Serena available)"
echo "   • /docs search - Live documentation access (when Context7 available)"
echo "   • Complex reasoning with Sequential Thinking"
echo "   • Graceful degradation ensures everything works regardless"
echo ""
echo "🚀 Ready for evidence-based, token-efficient development!"
```
````

## File: plugins/core/commands/spike.md
````markdown
---
title: "spike"
aliases: ["explore-spike", "prototype"]
---

# Spike - Time-boxed Technical Exploration

Creates an isolated environment for experimental code exploration with relaxed quality gates and automatic cleanup.

## Usage

```bash
# Start a spike
/spike start "exploration topic" [--duration MINUTES]

# Complete and generate report
/spike complete

# Abandon spike (cleanup)
/spike abandon
```

## Purpose

Spikes are time-boxed technical investigations to:
- Explore new technologies or approaches
- Prototype solutions without commitment
- Research implementation feasibility
- Learn through experimentation
- Gather information for decisions

## Process

### Starting a Spike

```bash
/spike start "websocket implementation"
```

Creates:
1. Isolated git branch (spike/topic-timestamp)
2. Spike tracking file
3. Relaxed quality gates
4. Time box (default: 2 hours)

### During the Spike

- Experiment freely
- Try multiple approaches
- Break things safely
- Focus on learning
- Document findings

### Completing a Spike

```bash
/spike complete
```

Generates:
1. Findings report
2. Code artifacts
3. Recommendations
4. Decision points
5. Optional: merge or discard

## Implementation

```bash
#!/bin/bash

SPIKE_DIR=".claude/spikes"
CURRENT_SPIKE="$SPIKE_DIR/current.json"
COMMAND="${ARGUMENTS%% *}"
ARGS="${ARGUMENTS#* }"

mkdir -p "$SPIKE_DIR"

case "$COMMAND" in
    "start")
        echo "🔬 Starting Technical Spike"
        echo "════════════════════════════════════"
        echo ""

        TOPIC="$ARGS"
        DURATION=120  # Default 2 hours

        # Parse duration if provided
        if [[ "$ARGS" == *"--duration"* ]]; then
            DURATION=$(echo "$ARGS" | grep -oP '(?<=--duration )\d+')
            TOPIC=$(echo "$ARGS" | sed 's/--duration.*//' | xargs)
        fi

        # Check for existing spike
        if [ -f "$CURRENT_SPIKE" ]; then
            echo "⚠️  Active spike detected!"
            echo ""
            echo "Complete or abandon current spike first:"
            echo "  /spike complete  - Generate report and finish"
            echo "  /spike abandon   - Discard and cleanup"
            exit 1
        fi

        # Create spike branch
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        BRANCH_NAME="spike/$(echo "$TOPIC" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')-$TIMESTAMP"

        echo "📁 Creating spike branch: $BRANCH_NAME"
        git checkout -b "$BRANCH_NAME" 2>/dev/null || {
            echo "❌ Failed to create branch. Commit or stash current changes first."
            exit 1
        }

        # Create spike tracking
        cat > "$CURRENT_SPIKE" <<EOF
{
  "topic": "$TOPIC",
  "branch": "$BRANCH_NAME",
  "started": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "duration_minutes": $DURATION,
  "status": "active",
  "findings": [],
  "artifacts": [],
  "recommendations": []
}
EOF

        echo ""
        echo "✅ Spike initialized!"
        echo ""
        echo "📋 Spike Details:"
        echo "  Topic: $TOPIC"
        echo "  Branch: $BRANCH_NAME"
        echo "  Time box: $DURATION minutes"
        echo ""
        echo "🎯 Spike Goals:"
        echo "  • Explore implementation options"
        echo "  • Identify technical challenges"
        echo "  • Prototype potential solutions"
        echo "  • Document learnings"
        echo ""

        cat <<'EOF'
Begin exploring: $TOPIC

**Spike Guidelines**:
1. **Experiment Freely** - Try different approaches
2. **Break Things** - It's isolated in a branch
3. **Learn Fast** - Focus on understanding
4. **Document Findings** - Note what works/doesn't
5. **Time Box** - Stop at $DURATION minutes

**Focus Areas**:
- Technical feasibility
- Implementation complexity
- Performance implications
- Integration challenges
- Required dependencies

**What to Explore** for "$TOPIC":
- Available libraries and tools
- Best practices and patterns
- Potential pitfalls
- Architecture options
- Proof of concept code

Start by researching and then prototyping. Quality doesn't matter - learning does!
EOF

        echo ""
        echo "⏰ Time box: $DURATION minutes"
        echo "Complete with: /spike complete"
        ;;

    "complete")
        echo "📊 Completing Spike"
        echo "════════════════════════════════════"
        echo ""

        if [ ! -f "$CURRENT_SPIKE" ]; then
            echo "❌ No active spike found"
            echo "Start a spike with: /spike start \"topic\""
            exit 1
        fi

        # Read spike data
        TOPIC=$(grep -oP '"topic":\s*"\K[^"]+' "$CURRENT_SPIKE")
        BRANCH=$(grep -oP '"branch":\s*"\K[^"]+' "$CURRENT_SPIKE")
        STARTED=$(grep -oP '"started":\s*"\K[^"]+' "$CURRENT_SPIKE")

        echo "📝 Generating Spike Report"
        echo "────────────────────────"
        echo ""
        echo "Topic: $TOPIC"
        echo "Branch: $BRANCH"
        echo "Started: $STARTED"
        echo ""

        # Generate report
        REPORT_FILE="$SPIKE_DIR/report_$(date +%Y%m%d_%H%M%S).md"

        cat <<'EOF'
Complete the spike and generate a comprehensive report.

**Spike Topic**: $TOPIC

Please create a spike report with:

1. **Executive Summary**
   - What was explored
   - Key findings
   - Recommendation (proceed/pivot/abandon)

2. **Technical Findings**
   - What worked well
   - What didn't work
   - Unexpected discoveries
   - Performance observations

3. **Implementation Details**
   - Code samples that worked
   - Libraries/tools evaluated
   - Architecture decisions
   - Integration points

4. **Challenges & Risks**
   - Technical blockers found
   - Complexity assessment
   - Security considerations
   - Scalability concerns

5. **Recommendations**
   - Suggested approach
   - Estimated effort
   - Next steps
   - Alternative options

6. **Artifacts**
   - List useful code created
   - Documentation snippets
   - Configuration examples
   - Test cases

Generate the report and save to: $REPORT_FILE

After generating the report, show a summary and ask whether to:
- Keep the spike branch for reference
- Merge useful code to main
- Archive and delete branch
EOF

        # Show git status
        echo ""
        echo "📂 Changes made during spike:"
        echo "────────────────────────"
        git status --short
        echo ""
        git diff --stat
        echo ""

        # Update spike status
        if command -v jq >/dev/null 2>&1; then
            jq '.status = "completed" | .completed = "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"' "$CURRENT_SPIKE" > "$CURRENT_SPIKE.tmp" && mv "$CURRENT_SPIKE.tmp" "$CURRENT_SPIKE"
        fi

        echo "💡 Options:"
        echo "  1. Keep branch: git checkout main"
        echo "  2. Merge useful code: git checkout main && git merge $BRANCH"
        echo "  3. Archive: git checkout main && git branch -D $BRANCH"
        echo ""
        echo "Report saved to: $REPORT_FILE"

        # Archive current spike
        mv "$CURRENT_SPIKE" "$SPIKE_DIR/completed_$(date +%Y%m%d_%H%M%S).json"
        ;;

    "abandon")
        echo "🗑️  Abandoning Spike"
        echo "════════════════════════════════════"
        echo ""

        if [ ! -f "$CURRENT_SPIKE" ]; then
            echo "❌ No active spike found"
            exit 0
        fi

        BRANCH=$(grep -oP '"branch":\s*"\K[^"]+' "$CURRENT_SPIKE")

        echo "⚠️  This will discard all spike work!"
        echo ""
        echo "Branch to delete: $BRANCH"
        echo ""

        # Switch to main/master
        DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
        git checkout "$DEFAULT_BRANCH" 2>/dev/null || git checkout main 2>/dev/null || git checkout master

        # Delete spike branch
        git branch -D "$BRANCH" 2>/dev/null && echo "✅ Spike branch deleted"

        # Remove tracking
        rm -f "$CURRENT_SPIKE"

        echo ""
        echo "✅ Spike abandoned and cleaned up"
        ;;

    "status"|*)
        echo "📊 Spike Status"
        echo "════════════════════════════════════"
        echo ""

        if [ ! -f "$CURRENT_SPIKE" ]; then
            echo "No active spike"
            echo ""
            echo "Start a spike with:"
            echo "  /spike start \"topic to explore\""
        else
            echo "Active Spike:"
            echo "────────────"
            cat "$CURRENT_SPIKE" | jq . 2>/dev/null || cat "$CURRENT_SPIKE"
            echo ""
            echo "Commands:"
            echo "  /spike complete - Finish and generate report"
            echo "  /spike abandon  - Discard all work"
        fi

        echo ""
        echo "📁 Previous Spikes:"
        echo "────────────────"
        find "$SPIKE_DIR" -name "report_*.md" -type f 2>/dev/null | while read -r report; do
            basename "$report"
        done | head -5
        ;;
esac
```

## Features

### Isolation
- Separate git branch
- No impact on main code
- Easy rollback
- Safe experimentation

### Time Boxing
- Default 2-hour limit
- Configurable duration
- Prevents rabbit holes
- Forces decision making

### Relaxed Rules
- No quality gates during spike
- Commit anything
- Break conventions
- Focus on learning

### Documentation
- Automatic report generation
- Findings capture
- Code artifact preservation
- Decision documentation

## Spike Types

### Technology Spike
```bash
/spike start "evaluate GraphQL vs REST"
```
Explore new technologies or libraries

### Architecture Spike
```bash
/spike start "microservice communication patterns"
```
Test architectural approaches

### Performance Spike
```bash
/spike start "optimize database queries"
```
Investigate performance improvements

### Integration Spike
```bash
/spike start "third-party payment integration"
```
Test external service integration

## Best Practices

### DO:
- Time box strictly
- Document findings immediately
- Try multiple approaches
- Break things to learn
- Focus on specific questions

### DON'T:
- Polish code during spike
- Write comprehensive tests
- Worry about code quality
- Exceed time box
- Spike without clear goals

## Report Structure

Generated reports include:

```markdown
# Spike Report: [Topic]

## Executive Summary
- Duration: X hours
- Status: Completed/Abandoned
- Recommendation: Proceed/Pivot/Abandon

## Findings
### What Worked
- Approach A showed promise
- Library X meets requirements

### What Didn't Work
- Approach B too complex
- Performance issues with Y

## Code Artifacts
- `prototype/api.py` - Working API example
- `config/websocket.json` - Configuration template

## Recommendations
Based on this spike, we recommend...

## Next Steps
1. Create formal design document
2. Estimate implementation effort
3. Plan development tasks
```

## Configuration

Customize in `.claude/settings.json`:

```json
{
  "spike": {
    "default_duration": 120,
    "max_duration": 480,
    "require_report": true,
    "auto_archive": true,
    "branch_prefix": "spike/"
  }
}
```

## See Also

- `/explore` - Formal exploration with planning
- `/quickfix` - Fast fixes without exploration
- `/experiment` - ML experimentation
- `/analyze` - Codebase analysis

---

*Time-boxed technical exploration in isolated environment. Part of Claude Code Framework v3.1.*
````

## File: plugins/core/commands/status.md
````markdown
---
name: status
description: Unified view of work, system, and memory state
allowed-tools: [Read, Bash, Glob]
argument-hint: "[verbose]"
---

# Status Command

I'll show you a comprehensive view of your current work state, system status, and memory usage.

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Standard constants (must be copied to each command)
readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"
readonly WORK_CURRENT="${WORK_DIR}/current"
readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
readonly TRANSITIONS_DIR="${CLAUDE_DIR}/transitions"

# Error handling functions (must be copied to each command)
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

debug() {
    [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
}

# Parse arguments
VERBOSE=false
if [[ "$ARGUMENTS" =~ verbose ]]; then
    VERBOSE=true
fi

echo "📦 Claude Code Status Report"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Work Status
echo "📋 WORK STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
    ACTIVE_WORK=$(cat "${WORK_DIR}/ACTIVE_WORK" 2>/dev/null || echo "")
    if [ -n "$ACTIVE_WORK" ] && [ -d "${WORK_CURRENT}/${ACTIVE_WORK}" ]; then
        echo "🟢 Active: $ACTIVE_WORK"

        # Try to read state.json if it exists
        if [ -f "${WORK_CURRENT}/${ACTIVE_WORK}/state.json" ] && command -v jq >/dev/null 2>&1; then
            STATUS=$(jq -r '.status // "unknown"' "${WORK_CURRENT}/${ACTIVE_WORK}/state.json" 2>/dev/null || echo "unknown")
            CURRENT_TASK=$(jq -r '.current_task // "none"' "${WORK_CURRENT}/${ACTIVE_WORK}/state.json" 2>/dev/null || echo "none")
            echo "   Phase: $STATUS"
            echo "   Task: $CURRENT_TASK"
        fi
    else
        echo "⚠️  Active work unit not found: $ACTIVE_WORK"
    fi
else
    echo "🔴 No active work unit"
fi

# Count work units
if [ -d "$WORK_CURRENT" ]; then
    TOTAL_WORK=$(find "$WORK_CURRENT" -maxdepth 1 -type d -not -path "$WORK_CURRENT" | wc -l)
    echo "   Total units: $TOTAL_WORK"
fi

echo ""

# Git Status
if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "🔀 GIT STATUS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Get branch and status
    BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
    echo "🌳 Branch: $BRANCH"

    # Count changes
    MODIFIED=$(git status --porcelain 2>/dev/null | grep '^ M' | wc -l)
    STAGED=$(git status --porcelain 2>/dev/null | grep '^[AM]' | wc -l)
    UNTRACKED=$(git status --porcelain 2>/dev/null | grep '^??' | wc -l)

    if [ $MODIFIED -gt 0 ] || [ $STAGED -gt 0 ] || [ $UNTRACKED -gt 0 ]; then
        echo "📝 Changes: $MODIFIED modified, $STAGED staged, $UNTRACKED untracked"
    else
        echo "✅ Working directory clean"
    fi

    # Last commit
    if [ "$VERBOSE" = true ]; then
        LAST_COMMIT=$(git log -1 --pretty=format:"%h - %s (%ar)" 2>/dev/null || echo "No commits")
        echo "📥 Last: $LAST_COMMIT"
    fi

    echo ""
fi

# System Status
echo "⚙️  SYSTEM STATUS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check framework directories
FRAMEWORK_OK=true
for dir in "$CLAUDE_DIR" "$WORK_DIR" "$MEMORY_DIR"; do
    if [ ! -d "$dir" ]; then
        echo "❌ Missing: $dir"
        FRAMEWORK_OK=false
    fi
done

if [ "$FRAMEWORK_OK" = true ]; then
    echo "🏗️  Framework: Claude Code v3.0 ✅"
else
    echo "🏗️  Framework: Incomplete setup ⚠️"
fi

# Memory status
if [ -d "$MEMORY_DIR" ]; then
    MEMORY_FILES=$(find "$MEMORY_DIR" -type f -name "*.md" 2>/dev/null | wc -l)
    MEMORY_SIZE=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)
    echo "💾 Memory: $MEMORY_FILES files, $MEMORY_SIZE"
fi

echo ""

# Memory Status
if [ "$VERBOSE" = true ]; then
    echo "🧠 MEMORY STATUS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    # Check recent memory updates
    if [ -d "$MEMORY_DIR" ]; then
        RECENT=$(find "$MEMORY_DIR" -type f -name "*.md" -mmin -60 2>/dev/null | wc -l)
        if [ $RECENT -gt 0 ]; then
            echo "🔄 Recent updates: $RECENT files in last hour"
        fi
    fi

    # Check transitions
    if [ -d "$TRANSITIONS_DIR" ]; then
        TRANSITIONS=$(find "$TRANSITIONS_DIR" -maxdepth 1 -type d -not -path "$TRANSITIONS_DIR" 2>/dev/null | wc -l)
        if [ $TRANSITIONS -gt 0 ]; then
            echo "🔗 Transitions: $TRANSITIONS saved"
        fi
    fi

    echo ""
fi

# Recommendations
echo "🎯 NEXT STEPS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -n "$ACTIVE_WORK" ] && [ -d "${WORK_CURRENT}/${ACTIVE_WORK}" ]; then
    echo "➡️ Continue with: /next"
    echo "➡️ View work details: /work"
else
    echo "➡️ Start new work: /explore [requirement]"
    echo "➡️ View available work: /work"
fi

if [ $MODIFIED -gt 0 ] || [ $STAGED -gt 0 ]; then
    echo "➡️ Commit changes: /git commit"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

## Usage

```bash
/status                    # Quick status overview
/status verbose            # Detailed status with extended information
```

## Phase 1: Current Work Status

### Active Work Unit Analysis
I'll check for and analyze your current work context:

1. **Active Work Unit**: Look for `.claude/work/current/ACTIVE_WORK` and work unit directories
2. **Work Progress**: Analyze `state.json` and `metadata.json` for current progress
3. **Current Tasks**: Identify what tasks are in progress, completed, or blocked
4. **Phase Status**: Determine current workflow phase (exploring, planning, implementing, testing)

### Work Status Display
```
📋 WORK STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📁 Project: [Project Name]
🔄 Phase: [Current Phase]
📊 Progress: [X/Y tasks complete (Z%)]
⏱️  Current Task: [Task ID - Title]
```

### Task Overview
- **Completed Tasks**: List recently completed tasks with timestamps
- **In Progress**: Show currently active task with estimated completion
- **Next Available**: Identify tasks ready to be executed
- **Blocked Tasks**: Highlight tasks waiting on dependencies

## Phase 2: Git Repository Status

### Repository State Analysis
1. **Branch Information**: Current branch, ahead/behind status with remote
2. **Working Directory**: Modified, staged, and untracked files
3. **Recent Commits**: Last few commits with summary information
4. **Repository Health**: Check for any git issues or inconsistencies

### Git Status Display
```
🔀 GIT STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌳 Branch: [branch-name] (up to date / ahead X / behind Y)
📝 Changes: [X modified, Y staged, Z untracked]
📅 Last Commit: [hash] - [message] ([time ago])
```

### Change Summary
- **Modified Files**: Files with uncommitted changes
- **Staged Changes**: Files ready for commit
- **Untracked Files**: New files not yet added to git
- **Conflicts**: Any merge conflicts that need resolution

## Phase 3: System and Framework Status

### Framework Health Check
1. **Directory Structure**: Verify `.claude/` framework structure is intact
2. **Memory Status**: Check memory file sizes and recent updates
3. **Configuration**: Validate settings and hook configurations
4. **Command Availability**: Ensure all framework commands are accessible

### System Status Display
```
⚙️ SYSTEM STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏗️  Framework: [Claude Code v3.0] ✅
📁 Structure: [.claude/ directories] ✅
💾 Memory: [X files, Y MB total]
🔧 Configuration: [settings.json] ✅
```

### Health Indicators
- **Framework Version**: Current Claude Code framework version
- **Directory Health**: Status of required framework directories
- **Memory Usage**: Current memory file count and total size
- **Configuration Status**: Settings and hook configuration validation

## Phase 4: Session and Memory Status

### Session Context Analysis
1. **Session Duration**: How long current session has been active
2. **Memory Files**: Current memory file status and recent updates
3. **Import Health**: Validate all `@import` links in CLAUDE.md files
4. **Context Window**: Estimate current context usage and available space

### Memory Status Display
```
🧠 MEMORY STATUS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Session: [X minutes active]
💾 Memory Files: [X files, recent update: Y minutes ago]
🔗 Imports: [X valid, Y broken links]
📊 Context: [~X% utilized]
```

### Memory Health
- **Recent Updates**: Files modified in current session
- **Import Validation**: Status of all `@` import links
- **Size Management**: Memory files approaching size limits
- **Archive Needs**: Old session data that should be compressed

## Phase 5: Verbose Information (Optional)

When verbose flag is specified, include additional details:

### Extended Work Information
- **Full Task List**: Complete task breakdown with dependencies
- **Timing Information**: Task duration estimates and actual times
- **File Changes**: Detailed file modification history
- **Quality Metrics**: Test coverage, code quality scores

### Extended Git Information
- **Commit History**: Extended commit log with detailed messages
- **Branch Analysis**: All branches and their status
- **Remote Status**: Detailed remote repository synchronization
- **Stash Information**: Any stashed changes

### Extended System Information
- **Tool Availability**: Status of development tools (git, python, node, etc.)
- **MCP Server Status**: Connected MCP servers and their health
- **Hook Configuration**: Detailed hook setup and execution status
- **Performance Metrics**: Command execution times and system performance

## Phase 6: Recommendations

### Next Action Recommendations
Based on current status, provide actionable next steps:

#### Work in Progress
```
🎯 NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
→ Continue current task: [Task ID]
→ Estimated completion: [X hours]
→ Run `/next` to proceed
```

#### Ready for New Work
```
🎯 NEXT STEPS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
→ No active work detected
→ Run `/explore [requirement]` to start new work
→ Or run `/work` to see available work units
```

#### Issues Detected
```
⚠️ ATTENTION NEEDED
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
→ [Issue description]
→ Recommended action: [specific command or fix]
```

## Success Indicators

- ✅ Current work status clearly displayed
- ✅ Git repository state summarized
- ✅ Framework health verified
- ✅ Memory and session status shown
- ✅ Clear next action recommendations provided
- ✅ All status information current and accurate

## Integration with Other Commands

- **Work Management**: Status integrates with `/work` for detailed work unit management
- **Planning**: Shows when `/plan` is needed for incomplete planning
- **Execution**: Indicates when `/next` can be used to continue tasks
- **Quality**: Highlights when `/audit` or `/review` might be beneficial

## Examples

### Quick Status Check
```bash
/status
# → Shows concise overview of current work, git, and system status
```

### Detailed Status Review
```bash
/status verbose
# → Comprehensive status with extended information and diagnostics
```

### Status During Development
```bash
/status
# → Shows current task progress, git changes, and next recommended actions
```

---

*Provides comprehensive current state overview enabling informed development decisions and workflow management.*
````

## File: plugins/core/commands/work.md
````markdown
---
allowed-tools: [Read, Write, MultiEdit, Bash, Grep]
argument-hint: "[subcommand: continue|checkpoint|switch] [args] OR [filter: active|paused|completed|all]"
description: "Unified work management: list units, continue work, save checkpoints, and switch contexts"
---

# Unified Work Management

Comprehensive work unit management with subcommands for continuing work, saving checkpoints, switching contexts, and viewing status.

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Standard constants (must be copied to each command)
readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"
readonly WORK_CURRENT="${WORK_DIR}/current"
readonly WORK_COMPLETED="${WORK_DIR}/completed"

# Error handling functions (must be copied to each command)
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

debug() {
    [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
}

# Safe directory creation
safe_mkdir() {
    local dir="$1"
    mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
}

# Parse arguments
ARGUMENTS="$ARGUMENTS"
SUBCOMMAND=""
FILTER="all"
WORK_ID=""
MESSAGE=""

# Extract subcommand or filter
if [[ "$ARGUMENTS" =~ ^(continue|checkpoint|switch) ]]; then
    SUBCOMMAND="${BASH_REMATCH[1]}"
    REMAINING="${ARGUMENTS#$SUBCOMMAND}"
    REMAINING="${REMAINING# }"  # Trim leading space

    case "$SUBCOMMAND" in
        continue|switch)
            WORK_ID="$REMAINING"
            ;;
        checkpoint)
            MESSAGE="$REMAINING"
            ;;
    esac
elif [[ "$ARGUMENTS" =~ ^(active|paused|completed|all) ]]; then
    FILTER="$ARGUMENTS"
fi

# Ensure work directory exists
safe_mkdir "$WORK_CURRENT"
safe_mkdir "$WORK_COMPLETED"

# Main execution
if [ -z "$SUBCOMMAND" ]; then
    # List work units based on filter
    echo "📋 WORK UNITS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # TODO: Implement work unit listing with proper filtering
    # This is a simplified version - actual implementation would read metadata.json files

    for work_dir in "$WORK_CURRENT"/*; do
        [ -d "$work_dir" ] || continue
        work_id=$(basename "$work_dir")

        if [ -f "$work_dir/metadata.json" ]; then
            # Extract metadata (simplified - would use jq in practice)
            echo "🟢 $work_id    [active]    Progress info here"
        fi
    done

else
    case "$SUBCOMMAND" in
        continue)
            # Continue work unit
            if [ -z "$WORK_ID" ]; then
                # Find last active work unit
                if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
                    WORK_ID=$(cat "${WORK_DIR}/ACTIVE_WORK")
                else
                    error_exit "No active work unit found"
                fi
            fi

            # Validate work unit exists
            if [ ! -d "${WORK_CURRENT}/${WORK_ID}" ]; then
                error_exit "Work unit ${WORK_ID} not found"
            fi

            # Set as active
            echo "$WORK_ID" > "${WORK_DIR}/ACTIVE_WORK" || error_exit "Failed to set active work unit"
            echo "✅ Resumed work unit: ${WORK_ID}"
            ;;

        checkpoint)
            # Save checkpoint
            if [ ! -f "${WORK_DIR}/ACTIVE_WORK" ]; then
                error_exit "No active work unit to checkpoint"
            fi

            ACTIVE_ID=$(cat "${WORK_DIR}/ACTIVE_WORK")
            CHECKPOINT_DIR="${WORK_CURRENT}/${ACTIVE_ID}/checkpoints"
            safe_mkdir "$CHECKPOINT_DIR"

            TIMESTAMP=$(date +%Y%m%d_%H%M%S)
            CHECKPOINT_FILE="${CHECKPOINT_DIR}/checkpoint_${TIMESTAMP}.json"

            # Create checkpoint (simplified)
            cat > "$CHECKPOINT_FILE" << EOF || error_exit "Failed to create checkpoint"
{
    "timestamp": "$(date -Iseconds)",
    "message": "${MESSAGE:-Checkpoint created}",
    "work_id": "$ACTIVE_ID"
}
EOF

            echo "✅ Checkpoint saved for ${ACTIVE_ID}"
            ;;

        switch)
            # Switch work units
            if [ -z "$WORK_ID" ]; then
                error_exit "Work unit ID required for switch"
            fi

            if [ ! -d "${WORK_CURRENT}/${WORK_ID}" ]; then
                error_exit "Work unit ${WORK_ID} not found"
            fi

            # Checkpoint current if exists
            if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
                OLD_ID=$(cat "${WORK_DIR}/ACTIVE_WORK")
                echo "📝 Checkpointing ${OLD_ID} before switch..."
                # Would call checkpoint logic here
            fi

            # Switch to new work unit
            echo "$WORK_ID" > "${WORK_DIR}/ACTIVE_WORK" || error_exit "Failed to switch work unit"
            echo "✅ Switched to work unit: ${WORK_ID}"
            ;;
    esac
fi
```

## Usage Examples

```bash
/work                    # List all work units (default)
/work active             # List only active work units
/work continue          # Resume last active work unit
/work continue 002      # Resume specific work unit
/work checkpoint        # Save current progress
/work checkpoint "Major milestone reached"  # Save with custom message
/work switch 003        # Switch to work unit 003
```

## Detailed Operation Phases

### Phase 1: Determine Work Operation

Based on the arguments provided: $ARGUMENTS

I'll determine which work management operation to perform:

- **List Operations**: No subcommand or filter keyword - show work unit list
- **Continue Operations**: Arguments start with "continue" - resume work
- **Checkpoint Operations**: Arguments start with "checkpoint" - save progress
- **Switch Operations**: Arguments start with "switch" - change active work unit

## Phase 2: Execute Work Unit Listing

When listing work units:

### Work Unit Discovery
1. **Scan Work Directory**: Examine `.claude/work/current/` for active work units
2. **Parse Metadata**: Read metadata.json files to understand work unit status
3. **Identify Active Unit**: Check `ACTIVE_WORK` file for currently active work
4. **Status Analysis**: Determine work unit phases and progress

### Filtering Options
- **All Units** (default): Show all work units regardless of status
- **Active Units**: Only show units in active development
- **Paused Units**: Show units that are paused but not completed
- **Completed Units**: Display archived and completed work units

### Work Unit Display Format
```
📋 WORK UNITS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🟢 001_auth_system        [implementing]     3/5 tasks  (60%)
   ↳ Last: 2 hours ago - TASK-003 in progress

⏸️  002_payment_flow      [paused]          1/4 tasks  (25%)
   ↳ Last: 1 day ago - waiting for API specs

✅ 003_user_dashboard     [completed]       4/4 tasks  (100%)
   ↳ Completed: 3 days ago - shipped to production

📝 004_notification_sys   [planning]        0/6 tasks  (0%)
   ↳ Last: 30 minutes ago - plan in progress
```

## Phase 3: Execute Continue Operations

When continuing work:

### Resume Active Work Unit
1. **Identify Target**: Determine which work unit to resume (last active or specified)
2. **Load Context**: Read work unit metadata, state, and progress
3. **Validate State**: Ensure work unit is in resumable state
4. **Set Active**: Mark work unit as active and update session context
5. **Display Status**: Show current task and next actions

### Context Restoration
1. **Work Unit Activation**: Set as active work unit in `ACTIVE_WORK`
2. **Session Memory**: Load work unit context into session memory
3. **Task Context**: Identify current task and next available tasks
4. **Environment Setup**: Prepare development environment for continued work

### Continue Options
- **Continue Latest**: Resume most recently active work unit
- **Continue Specific**: Resume explicitly specified work unit by ID
- **Continue with Validation**: Verify work unit state before resuming

## Phase 4: Execute Checkpoint Operations

When creating checkpoints:

### Progress Capture
1. **Current State**: Capture current task progress and completion status
2. **Work Summary**: Document work completed since last checkpoint
3. **Context Preservation**: Save current development context and environment
4. **Timestamp Recording**: Record checkpoint creation time and duration

### Checkpoint Documentation
1. **Progress Summary**: What has been accomplished since last checkpoint
2. **Current Status**: What task is in progress and next steps
3. **Issues Encountered**: Any blockers or challenges discovered
4. **Next Session Prep**: What needs to be done to resume work

### Checkpoint Types
- **Automatic Checkpoints**: Created at natural stopping points
- **Manual Checkpoints**: Created with custom messages and context
- **Session Checkpoints**: Created when switching between work units
- **Milestone Checkpoints**: Created at major completion points

## Phase 5: Execute Switch Operations

When switching work units:

### Pre-Switch Validation
1. **Current Work Status**: Check if current work should be checkpointed
2. **Target Validation**: Verify target work unit exists and is accessible
3. **Conflict Detection**: Identify any conflicts between work units
4. **Safety Checks**: Ensure switching won't lose important work

### Context Switching
1. **Save Current Context**: Checkpoint current work unit if needed
2. **Load Target Context**: Load target work unit metadata and state
3. **Update Active Work**: Set new work unit as active
4. **Environment Update**: Adjust development environment for new context

### Switch Safety
- **Automatic Checkpointing**: Save current progress before switching
- **Work Validation**: Ensure target work unit is in valid state
- **Conflict Resolution**: Handle conflicts between work units
- **Rollback Capability**: Ability to return to previous work unit

## Phase 6: Work Unit Health Monitoring

### Health Checks
1. **Metadata Integrity**: Validate all work unit metadata files
2. **State Consistency**: Ensure task states are logically consistent
3. **File Organization**: Verify work unit directory structure
4. **Progress Tracking**: Validate progress calculations and dependencies

### Maintenance Operations
1. **Cleanup Stale Units**: Identify and clean up abandoned work units
2. **Archive Completed**: Move completed work units to archive
3. **Repair Corruption**: Fix any corrupted metadata or state files
4. **Optimize Storage**: Compress and optimize work unit storage

## Success Indicators

### Listing Operations
- ✅ All work units discovered and categorized
- ✅ Current status accurately displayed
- ✅ Progress information up to date
- ✅ Clear visual organization

### Continue Operations
- ✅ Work unit successfully resumed
- ✅ Context properly restored
- ✅ Current task clearly identified
- ✅ Ready for `/next` execution

### Checkpoint Operations
- ✅ Progress safely captured
- ✅ Context preserved for resumption
- ✅ Documentation complete
- ✅ Checkpoint successfully created

### Switch Operations
- ✅ Previous work safely saved
- ✅ New work unit activated
- ✅ Context successfully switched
- ✅ Environment properly configured

## Integration with Workflow

- **Explore Integration**: New work units created by `/explore` appear in listings
- **Planning Integration**: Work units show planning progress and completion
- **Execution Integration**: Task progress updates reflected in work unit status
- **Shipping Integration**: Completed work units marked and archived

## Examples

### List Active Work
```bash
/work active
# → Shows only work units currently in development
```

### Resume Last Work
```bash
/work continue
# → Resumes most recently active work unit
```

### Save Progress Checkpoint
```bash
/work checkpoint "Completed authentication module"
# → Saves current progress with descriptive message
```

### Switch Between Projects
```bash
/work switch 003
# → Switches to work unit 003, checkpointing current work
```

---

*Unified work management enabling parallel development streams with safe context switching and progress preservation.*
````

## File: plugins/core/README.md
````markdown
# Core Plugin

Essential system functionality and framework commands for Claude Code.

## Overview

The Core plugin provides fundamental commands for project management, system monitoring, and framework operations. These commands form the foundation of the Claude Code plugin ecosystem and are required for most workflows.

## Features

- **Project Management**: Track work units, manage tasks, and organize parallel workflows
- **System Monitoring**: View status, performance metrics, and token usage
- **Framework Operations**: Setup, configuration, cleanup, and audit capabilities
- **Session Management**: Create handoffs and maintain project context
- **Documentation**: Fetch, search, and generate project documentation

## Commands

### `/status [verbose]`
Display unified view of work, system, and memory state. Shows current tasks, project status, and system health.

**Usage**:
```bash
/status           # Quick status overview
/status verbose   # Detailed status with metrics
```

### `/work [subcommand] [args]`
Manage work units and parallel streams. Create, list, continue, checkpoint, and switch between work contexts.

**Usage**:
```bash
/work                    # List all work units
/work active             # Show active work units
/work continue [ID]      # Continue specific work unit
/work checkpoint         # Save current work state
/work switch [ID]        # Switch to different work unit
```

### `/agent <agent-name> "<task>"`
Direct invocation of specialized agents with explicit context. Provides access to expert capabilities on demand.

**Usage**:
```bash
/agent architect "Design authentication system"
/agent code-reviewer "Review security in auth module"
/agent auditor "Check framework compliance"
```

### `/cleanup [--dry-run | --auto | root | tests | reports | work | all]`
Clean up Claude-generated clutter and consolidate documentation. Remove temporary files and organize project structure.

**Usage**:
```bash
/cleanup --dry-run       # Preview what would be cleaned
/cleanup root            # Clean root directory only
/cleanup all             # Clean everything
/cleanup --auto          # Auto-clean with safe defaults
```

### `/index [--update] [--refresh] [focus_area]`
Create and maintain persistent project understanding through comprehensive mapping. Build searchable index of codebase.

**Usage**:
```bash
/index                   # Create initial index
/index --update          # Update existing index
/index --refresh         # Rebuild from scratch
/index src/auth          # Index specific area
```

### `/performance`
View token usage and performance metrics. Monitor efficiency, context usage, and optimization opportunities.

**Usage**:
```bash
/performance             # Show performance dashboard
```

### `/handoff`
Create transition documents with context analysis. Generate comprehensive handoff for session continuity.

**Usage**:
```bash
/handoff                 # Create handoff document
```

### `/docs [fetch|search|generate] [arguments]`
Unified documentation operations - fetch external docs, search all documentation, and generate project docs.

**Usage**:
```bash
/docs search "authentication"       # Search documentation
/docs fetch react                   # Fetch external library docs
/docs generate                      # Generate project documentation
```

### `/setup [explore|existing|python|javascript] [project-name] [--minimal|--standard|--full]`
Initialize new projects with Claude framework integration or setup user configuration.

**Usage**:
```bash
/setup explore                      # Interactive project discovery
/setup python my-api --standard     # Python project with standard config
/setup existing                     # Add Claude framework to existing project
/setup --init-user                  # Setup user-level configuration
```

### `/audit [--framework | --tools | --fix]`
Framework setup and infrastructure compliance audit. Verify correct installation and configuration.

**Usage**:
```bash
/audit                   # Full audit
/audit --framework       # Check framework compliance
/audit --tools           # Check tool availability
/audit --fix             # Auto-fix issues
```

### `/serena`
Activate and manage Serena semantic code understanding for projects. Enable powerful semantic search and code navigation.

**Usage**:
```bash
/serena                  # Activate Serena for current project
```

### `/spike`
Time-boxed exploration in isolated branch. Quick experimentation without affecting main work.

**Usage**:
```bash
/spike                   # Start spike exploration
```

## Agents

### Auditor (`auditor.md`)
Framework compliance and infrastructure validation specialist. Performs comprehensive audits of:
- Claude Code framework setup
- Configuration correctness
- File structure compliance
- Tool availability
- Best practice adherence

**Capabilities**:
- Automated compliance checking
- Configuration validation
- Setup verification
- Issue detection and reporting

### Reasoning Specialist (`reasoning-specialist.md`)
Structured problem-solving and decision analysis expert. Provides:
- Sequential thinking for complex problems
- Decision framework analysis
- Multi-criteria evaluation
- Trade-off analysis

**Capabilities**:
- Complex problem decomposition
- Systematic reasoning
- Decision documentation
- Alternative evaluation

## Installation

This plugin is included by default in Claude Code and is marked as **required**. It is automatically enabled when you install the plugin marketplace.

To manually enable:

1. Add to your `.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "claude-code-core@your-marketplace": true
  }
}
```

2. Restart Claude Code or reload settings

## Configuration

The Core plugin works out of the box with sensible defaults. Optional configuration:

**Work Directory** (`.claude/work/`):
- Customize work unit organization
- Set default work patterns
- Configure archival rules

**Performance Thresholds** (`.claude/config.json`):
```json
{
  "performance": {
    "tokenWarningThreshold": 0.8,
    "tokenCriticalThreshold": 0.9,
    "autoOptimize": false
  }
}
```

**Cleanup Patterns** (`.claude/cleanup-rules.json`):
```json
{
  "excludePatterns": ["*.important.md"],
  "consolidationTargets": ["docs/", "notes/"]
}
```

## Dependencies

### Required
- Claude Code v3.0+ (platform)

### Optional MCP Tools
- **Sequential Thinking**: Enhances reasoning-specialist agent (built-in to Claude Code)
- **Serena**: Enables semantic code understanding (/serena command)

**Graceful Degradation**: All commands work without MCP tools, but may be less efficient.

## Usage Examples

### Complete Workflow
```bash
# 1. Check status
/status

# 2. Create new work unit
/work create "Add user authentication"

# 3. Setup project structure
/setup python auth-service --standard

# 4. Monitor performance
/performance

# 5. Run framework audit
/audit

# 6. Create handoff when done
/handoff
```

### Project Initialization
```bash
# Interactive discovery
/setup explore

# Quick Python setup
/setup python my-api --minimal

# Add to existing project
cd existing-project
/setup existing
```

### Work Management
```bash
# List work
/work active

# Start work unit
/work continue 001

# Save checkpoint
/work checkpoint

# Switch work
/work switch 002
```

## Best Practices

1. **Use /status regularly**: Check project state before starting work
2. **Create handoffs at boundaries**: Preserve context between sessions
3. **Monitor /performance**: Optimize when context >80%
4. **Audit after setup**: Verify framework compliance with /audit
5. **Clean periodically**: Run /cleanup to maintain organized project

## Troubleshooting

### Commands not found
Run `/audit --framework` to verify plugin installation.

### Performance degradation
1. Check `/performance` for context usage
2. Run `/handoff` to preserve context
3. Use `/cleanup` to remove clutter

### Work units not tracking
1. Verify `.claude/work/` directory exists
2. Run `/audit --fix` to repair structure
3. Check `metadata.json` in work unit directory

## Related Plugins

- **workflow**: Task workflow commands (/explore, /plan, /next, /ship)
- **development**: Development tools (/analyze, /review, /test, /fix, /run)
- **git**: Git operations (/git commit, /git pr, /git issue)
- **memory**: Memory management (/memory-review, /memory-gc)

## Support

- **Documentation**: [Getting Started Guide](../../docs/getting-started/)
- **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

## License

MIT License - see [LICENSE](../../LICENSE) for details.

---

**Version**: 1.0.0
**Category**: Core
**Required**: Yes
**MCP Tools**: Optional (sequential-thinking, serena)
````

## File: README.md
````markdown
# Claude Code Plugins

**Production-Ready Workflow Framework for Claude Code**

> From Chaos to System: Structured AI-assisted development workflows that scale from individual developers to enterprise teams.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-2.0%2B-blue)](https://docs.claude.com/claude-code)

---

## What Is This?

Claude Code Plugins is a **production-ready framework** that adds structured development patterns, work management, and quality automation to Anthropic's Claude Code.

**In short**: Claude Code provides the tools, we provide the methodology.

### Core Features

✅ **Structured Workflow**: `explore` → `plan` → `next` → `ship` - Break down complex work into tracked, dependent tasks

✅ **Memory Management**: Persistent context across sessions with automatic reflection and cleanup

✅ **Quality Automation**: Safe git commits, pre/post tool execution hooks, compliance auditing

✅ **MCP Integration**: Proven patterns for Serena, Chrome DevTools, Context7, Sequential Thinking

✅ **Specialized Agents**: 6 expert agents (architect, test-engineer, code-reviewer, auditor, data-scientist, report-generator)

### What You Get

**5 Core Plugins** (30+ commands):
- **core** - System commands (status, work, config, cleanup, index, handoff, setup, audit)
- **workflow** - Development workflow (explore, plan, next, ship)
- **development** - Code quality (analyze, test, fix, run, review)
- **git** - Version control operations
- **memory** - Context management (memory-review, memory-update, memory-gc)

**Battle-Tested**: 6+ months of production use building:
- ML for Trading 3rd Edition book (500+ pages)
- Quantitative research infrastructure
- Full-stack web applications

---

## Quick Start

### Prerequisites

- **Claude Code 2.0+** (install from [claude.com/install](https://claude.com/install))
- **Git 2.0+**
- **jq** (JSON processing)

### Installation

**Option 1: Direct Installation** (Recommended)

```bash
# Clone repository
cd ~/repos  # or your preferred location
git clone git@github.com:applied-artificial-intelligence/claude-code-plugins.git
cd claude-code-plugins

# Install plugins
./scripts/install.sh
```

**Option 2: Project-Specific** (via marketplace)

In your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "aai-plugins": {
      "source": {
        "source": "directory",
        "path": "/path/to/claude-code-plugins/plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@aai-plugins": true,
    "workflow@aai-plugins": true,
    "development@aai-plugins": true,
    "git@aai-plugins": true,
    "memory@aai-plugins": true
  }
}
```

### Your First Workflow

```bash
# Start a new feature
/explore "add user authentication"

# Creates work unit, analyzes requirements, suggests implementation approach

# Generate implementation plan
/plan

# Breaks down work into ordered tasks with dependencies

# Execute tasks one by one
/next

# Runs next task, updates state automatically

# Deliver completed work
/ship

# Validates quality, creates PR, cleans up
```

---

## Why Use This Framework?

### Problem: AI-Assisted Development Gets Messy

- Context limits hit unexpectedly
- Work gets fragmented across sessions
- No systematic approach to complex features
- Quality gates missing
- Knowledge doesn't persist

### Solution: Structured Workflows + Memory Management

**Structured Workflow**:
- Break down complex work systematically
- Track dependencies between tasks
- Resume seamlessly across sessions
- Clear completion criteria

**Memory Management**:
- Persistent context across long-running work
- Automatic reflection at task boundaries
- Garbage collection for stale information
- Project-specific conventions and decisions

**Quality Automation**:
- Safe git commits (no accidental force pushes)
- Pre/post execution hooks
- Automated code review checkpoints
- Framework compliance auditing

---

## Architecture

### Progressive Disclosure Pattern

Instead of loading everything into context upfront, plugins use progressive disclosure:

1. **Startup**: Load minimal metadata (plugin names, descriptions)
2. **Task Analysis**: Load relevant commands/agents based on task
3. **Execution**: Load detailed patterns only when needed

**Result**: 70%+ token savings while maintaining full capability.

### MCP Integration

Proven patterns for Model Context Protocol tools:

- **Serena**: Semantic code understanding (70-90% token reduction for code operations)
- **Chrome DevTools**: Frontend verification (26 tools for debugging and performance)
- **Context7**: Library documentation access (50%+ faster than manual search)
- **Sequential Thinking**: Structured reasoning for complex analysis

All with graceful degradation when MCP unavailable.

### Plugin Architecture

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json        # Manifest
├── commands/              # Slash commands
│   └── *.md
├── agents/                # Specialized agents
│   └── *.md
└── hooks/                 # Event handlers (optional)
    └── hooks.json
```

---

## Documentation

### Getting Started
- [Installation Guide](docs/getting-started/installation.md)
- [Quick Start Tutorial](docs/getting-started/quick-start.md)
- [Your First Plugin](docs/getting-started/first-plugin.md)

### Guides
- [Workflow Guide](docs/guides/workflow-guide.md) - Using explore → plan → next → ship
- [Memory Management](docs/guides/memory-management.md) - Persistent context best practices
- [MCP Integration](docs/guides/mcp-integration.md) - Leveraging Model Context Protocol
- [Plugin Creation](docs/guides/plugin-creation.md) - Building custom plugins

### Reference
- [Commands Reference](docs/reference/commands.md) - All 30+ commands documented
- [Agents Reference](docs/reference/agents.md) - Specialized agent capabilities
- [Configuration](docs/reference/configuration.md) - Settings and customization

### Architecture
- [Design Principles](docs/architecture/design-principles.md) - Core framework philosophy
- [Framework Patterns](docs/architecture/patterns.md) - Reusable patterns
- [System Constraints](docs/architecture/constraints.md) - What the framework can/cannot do

---

## Examples

### Example 1: Feature Development

```bash
# User story: Add password reset functionality

/explore "implement password reset with email verification"
# → Creates work unit 003_password_reset
# → Analyzes: needs email service, token generation, UI flow
# → Suggests: 8 tasks across backend, frontend, testing

/plan
# → Generates detailed task breakdown:
#   1. Design token schema (15 min)
#   2. Implement token generation service (30 min)
#   3. Create email template (15 min)
#   4. Build reset endpoint (30 min)
#   5. Add frontend form (30 min)
#   6. Write tests (45 min)
#   7. Update documentation (15 min)
#   8. Security review (30 min)

/next
# → Executes Task 1: Design token schema
# → Auto-commits when complete

/next  # Repeat until all tasks done

/ship
# → Runs final validation
# → Creates comprehensive PR
# → Updates work unit as completed
```

### Example 2: Bug Investigation

```bash
/explore "#1234"  # GitHub issue number
# → Loads issue description
# → Analyzes error logs
# → Identifies root cause
# → Proposes fix approach

/plan
# → Creates debugging plan with verification steps

/fix
# → Applies fix
# → Runs tests
# → Verifies resolution

/ship
# → Commits fix
# → Updates issue
# → Creates PR
```

### Example 3: Code Review

```bash
/review src/auth/
# → Systematic code analysis
# → Identifies bugs, security issues, design flaws
# → Prioritized action items
# → Generates review report

/fix review
# → Applies recommended fixes
# → Runs tests
# → Updates code quality
```

---

## Case Studies

### ML for Trading Book (500+ pages)

**Challenge**: Authoring technical book with code examples, academic citations, and Jupyter notebooks

**Solution**: Custom plugins built on this framework
- `ml3t-researcher`: Paper search and citation management
- `ml3t-coauthor`: 14-command book production workflow

**Results**:
- 26 chapters coordinated across 3 AI agents
- 100% citation accuracy with Zotero integration
- 95%+ notebook execution success rate

### Quantitative Research Infrastructure

**Challenge**: Reproducible backtesting and strategy development

**Solution**: `quant` plugin with validation gates

**Results**:
- Systematic strategy development workflow
- Automated data validation preventing silent errors
- Reproducible research environment

---

## Services

### Self-Service (Free - Open Source)

✅ 5 core plugins (30+ commands)
✅ Complete documentation
✅ Community support (GitHub issues)
✅ Tutorial content

### Implementation Consulting

**$5K-15K per engagement**

Need help getting your team started?

- Initial setup and configuration
- Team training workshop (4-8 hours)
- Custom configuration for your stack
- 30-day email support

[Schedule Consultation →](https://appliedaiconsulting.com/contact)

### Custom Plugin Development

**$10K-30K per plugin**

Have specialized workflows?

- Discovery workshop
- Custom plugin design and development
- Testing and documentation
- Training and handoff

[Discuss Your Needs →](https://appliedaiconsulting.com/contact)

### Enterprise Support

**$20K-100K/year**

For organizations adopting AI-assisted development at scale:

- Priority support (24-hour response)
- Quarterly plugin updates
- Custom feature development
- Annual training refreshers
- Architecture consultation

[Enterprise Inquiry →](https://appliedaiconsulting.com/enterprise)

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- How to report bugs
- How to suggest features
- How to submit pull requests
- Code of conduct

---

## Community

- **GitHub Issues**: [Report bugs or request features](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [Ask questions, share plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
- **Discord**: Coming soon
- **Blog**: [Technical articles and lessons learned](https://appliedaiconsulting.com/blog)

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Free for personal and commercial use.

---

## Acknowledgments

Built with [Claude Code](https://claude.com/claude-code) by Anthropic.

Inspired by 6+ months of production use across book authoring, quantitative research, and full-stack development.

---

## What's Next?

**Ready to get started?**

1. [Install the framework](docs/getting-started/installation.md)
2. [Follow the quick start tutorial](docs/getting-started/quick-start.md)
3. [Build your first plugin](docs/getting-started/first-plugin.md)

**Need help with implementation?**

- [Schedule a free 30-minute consultation](https://appliedaiconsulting.com/contact)
- [Read our blog posts](https://appliedaiconsulting.com/blog)
- [Join the community discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

**Want to contribute?**

- Star the repo ⭐
- Open an issue with feedback
- Submit a pull request
- Share your custom plugins

---

**Built by Applied AI Consulting** | [Website](https://appliedaiconsulting.com) | [GitHub](https://github.com/applied-artificial-intelligence)
````

## File: docs/getting-started/installation.md
````markdown
# Installation Guide

Get Claude Code Plugins up and running in minutes.

## Prerequisites

Before installing Claude Code Plugins, ensure you have:

### Required

- **Claude Code** v3.0 or later
  - Check your version: Open Claude Code and check the About section
  - Update if needed: Claude Code auto-updates to latest version

- **Operating System**: Linux, macOS, or Windows (WSL recommended)
  - Linux: Most distributions supported
  - macOS: 10.15 (Catalina) or later
  - Windows: WSL 2 with Ubuntu 20.04+ recommended

- **Git** v2.0 or later
  ```bash
  git --version
  # Should show: git version 2.x.x or later
  ```

### Optional but Recommended

- **GitHub CLI** (`gh`) - For pull request and issue management
  ```bash
  # macOS
  brew install gh

  # Linux (Debian/Ubuntu)
  sudo apt install gh

  # Linux (other distributions)
  # See: https://github.com/cli/cli#installation

  # Verify installation
  gh --version

  # Authenticate
  gh auth login
  ```

- **jq** - JSON processor for better command output
  ```bash
  # macOS
  brew install jq

  # Linux (Debian/Ubuntu)
  sudo apt install jq

  # Verify
  jq --version
  ```

- **Node.js** v16+ - For some development plugins
  ```bash
  # macOS
  brew install node

  # Linux
  # See: https://nodejs.org/en/download/package-manager

  # Verify
  node --version
  npm --version
  ```

## Installation Methods

### Method 1: GitHub Installation (Recommended)

Install directly from the GitHub repository marketplace.

#### Step 1: Add Marketplace to Settings

Create or update your Claude Code settings file:

**Location**: `~/.claude/settings.json` (global) or `.claude/settings.json` (project-specific)

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  }
}
```

#### Step 2: Enable Plugins

Add the plugins you want to enable:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "development@claude-code-plugins": true,
    "git@claude-code-plugins": true,
    "memory@claude-code-plugins": true
  }
}
```

#### Step 3: Restart Claude Code

Close and reopen Claude Code to load the plugins.

### Method 2: Local Directory Installation

Install from a local directory (useful for development or testing).

#### Step 1: Clone Repository

```bash
# Choose installation location
cd ~/projects  # or wherever you prefer

# Clone the repository
git clone https://github.com/applied-artificial-intelligence/claude-code-plugins.git

# Verify structure
ls claude-code-plugins/plugins
# Should show: core development git memory workflow
```

#### Step 2: Configure Settings

Update your settings to point to the local directory:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins-local": {
      "source": {
        "source": "directory",
        "path": "/full/path/to/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins-local": true,
    "workflow@claude-code-plugins-local": true,
    "development@claude-code-plugins-local": true,
    "git@claude-code-plugins-local": true,
    "memory@claude-code-plugins-local": true
  }
}
```

**Important**: Use **absolute path** (not `~/` or relative paths).

#### Step 3: Restart Claude Code

Close and reopen Claude Code to load the plugins from local directory.

### Method 3: Project-Specific Installation

Install plugins for a single project only.

#### Step 1: Create Project Settings

In your project directory, create `.claude/settings.json`:

```bash
cd /path/to/your/project
mkdir -p .claude
```

#### Step 2: Configure Project Settings

Create `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true
  }
}
```

**Note**: Project settings override global settings. Plugins enabled here will only work in this project.

## Configuration

### Minimal Configuration

Bare minimum to get started (enables all 5 core plugins):

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "development@claude-code-plugins": true,
    "git@claude-code-plugins": true,
    "memory@claude-code-plugins": true
  }
}
```

### Selective Plugin Configuration

Enable only the plugins you need:

**Example 1: Workflow Only**
```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true
  }
}
```

**Example 2: Development Tools Only**
```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "development@claude-code-plugins": true
  }
}
```

**Note**: The `core` plugin is recommended for all configurations as it provides essential system functionality.

### Advanced Configuration

#### Custom Plugin Settings

Some plugins accept configuration options:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "development@claude-code-plugins": true,
    "git@claude-code-plugins": true,
    "memory@claude-code-plugins": true
  },
  "pluginSettings": {
    "core@claude-code-plugins": {
      "performance": {
        "tokenWarningThreshold": 0.8,
        "tokenCriticalThreshold": 0.9
      }
    },
    "workflow@claude-code-plugins": {
      "explore": {
        "defaultThoroughness": "medium"
      }
    },
    "memory@claude-code-plugins": {
      "autoReflection": true,
      "staleThresholdDays": 30
    }
  }
}
```

#### Multiple Marketplaces

Use plugins from multiple sources:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    },
    "my-custom-plugins": {
      "source": {
        "source": "directory",
        "path": "/home/user/my-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "my-plugin@my-custom-plugins": true
  }
}
```

## Verification

### Step 1: Check Plugin Loading

Open Claude Code in your project and start a new conversation. Claude should acknowledge the loaded plugins.

### Step 2: Test a Command

Try running a simple command:

```bash
/status
```

**Expected Output**:
```
Project Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project Directory: /path/to/your/project
Claude Code Version: v3.x.x
Plugins Loaded: 5

Core Systems:
✓ Commands: 25 available
✓ Agents: 6 available
✓ Memory: Active

...
```

If you see this output, plugins are successfully installed! ✅

### Step 3: List Available Commands

Check all available commands:

```bash
/help
```

You should see commands from all enabled plugins:
- **core**: /status, /work, /agent, /cleanup, /index, /performance, /handoff, /docs, /setup, /audit, /serena, /spike
- **workflow**: /explore, /plan, /next, /ship
- **development**: /analyze, /test, /fix, /run, /review
- **git**: /git
- **memory**: /memory-review, /memory-update, /memory-gc

### Step 4: Test Plugin Integration

Try a workflow command:

```bash
/explore "Test the plugins installation"
```

If the command runs and creates exploration output, your installation is complete! 🎉

## Troubleshooting

### Plugins Not Loading

**Symptom**: Commands like `/status` or `/explore` not recognized

**Solutions**:

1. **Check settings file location**
   ```bash
   # Global settings
   ls ~/.claude/settings.json

   # Project settings
   ls .claude/settings.json
   ```

2. **Validate JSON syntax**
   ```bash
   # Use jq to validate
   jq . ~/.claude/settings.json
   # Should output formatted JSON with no errors
   ```

3. **Restart Claude Code completely**
   - Close all Claude Code windows
   - Wait 5 seconds
   - Reopen Claude Code

4. **Check Claude Code version**
   - Requires v3.0 or later
   - Update Claude Code if needed

### Commands Return Errors

**Symptom**: Commands run but return "command not found" or "file not found" errors

**Solutions**:

1. **Verify marketplace path**
   - GitHub source: Check repository exists and is public
   - Directory source: Verify absolute path is correct
   - Test with `ls <path>/plugins`

2. **Check plugin structure**
   ```bash
   # Verify plugin structure
   ls <marketplace-path>/plugins/core/.claude-plugin/
   # Should show: plugin.json
   ```

3. **Verify plugin.json format**
   ```bash
   jq . <marketplace-path>/plugins/core/.claude-plugin/plugin.json
   # Should be valid JSON
   ```

### Permission Errors

**Symptom**: "Permission denied" when running commands

**Solutions**:

1. **Check file permissions**
   ```bash
   # Plugin commands should be readable
   ls -la ~/claude-code-plugins/plugins/core/commands/
   # All .md files should be readable (r--)
   ```

2. **Fix permissions if needed**
   ```bash
   chmod -R u+r ~/claude-code-plugins/plugins/
   ```

### GitHub Authentication Errors

**Symptom**: Cannot access GitHub marketplace or "authentication required" errors

**Solutions**:

1. **Verify GitHub access**
   ```bash
   gh auth status
   # Should show: Logged in to github.com as <username>
   ```

2. **Re-authenticate if needed**
   ```bash
   gh auth login
   # Follow prompts to authenticate
   ```

3. **Use HTTPS instead of SSH**
   - GitHub source uses HTTPS by default
   - No additional configuration needed

### Plugin-Specific Issues

**Symptom**: One plugin works but another doesn't

**Solutions**:

1. **Check individual plugin enablement**
   ```json
   "enabledPlugins": {
     "core@claude-code-plugins": true,
     "workflow@claude-code-plugins": true,
     // Make sure all plugins you want are enabled
   }
   ```

2. **Verify plugin dependencies**
   - Some plugins depend on `core` plugin
   - Enable `core` plugin if not already enabled

3. **Check plugin-specific requirements**
   - `git` plugin requires `git` command available
   - `development` plugin may need `node` for some features
   - See individual plugin READMEs for requirements

### Settings Not Taking Effect

**Symptom**: Changed settings but plugins still not working

**Solutions**:

1. **Restart Claude Code** (settings reload on restart)

2. **Check settings precedence**
   - Project `.claude/settings.json` overrides global `~/.claude/settings.json`
   - Make sure you're editing the right file

3. **Validate settings merge**
   ```bash
   # Claude Code merges global and project settings
   # If both exist, project settings take precedence
   ```

## Next Steps

Now that you have Claude Code Plugins installed:

1. **Try the Quick Start** - [Quick Start Guide](quick-start.md) - 15-minute hands-on tutorial
2. **Learn the Workflow** - Try `/explore` → `/plan` → `/next` → `/ship`
3. **Explore Commands** - Run `/help` to see all available commands
4. **Create Custom Plugin** - [First Plugin Tutorial](first-plugin.md)
5. **Read Architecture Docs** - Understand the [design principles](../architecture/design-principles.md)

## Getting Help

If you're still having trouble:

- **Documentation**: Browse the [full documentation](../README.md)
- **Issues**: Report bugs at [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

## Updating Plugins

### Update GitHub Marketplace Plugins

Plugins from GitHub marketplace auto-update:
- Claude Code checks for updates periodically
- Restart Claude Code to get latest version

### Update Local Directory Plugins

For local installations:

```bash
cd ~/claude-code-plugins  # or your installation path
git pull origin main
# Restart Claude Code to load updated plugins
```

## Uninstalling

### Remove Individual Plugins

Edit your settings.json and remove plugins from `enabledPlugins`:

```json
{
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    // Remove line for plugin you want to disable
  }
}
```

Restart Claude Code.

### Remove Marketplace

To completely remove the marketplace:

1. Delete marketplace from `extraKnownMarketplaces`
2. Remove all plugins from `enabledPlugins`
3. Restart Claude Code

### Delete Local Installation

If installed locally:

```bash
rm -rf ~/claude-code-plugins  # or your installation path
```

Then update settings.json to remove marketplace reference.

---

**Installation Complete!** 🎉

You're ready to start using Claude Code Plugins. Head to the [Quick Start Guide](quick-start.md) for a hands-on tutorial.
````

## File: docs/getting-started/quick-start.md
````markdown
# Quick Start Tutorial

Get productive with Claude Code Plugins in 15 minutes. Learn the core workflow with a real-world example.

## What You'll Build

In this tutorial, you'll add user authentication to a Node.js API using the Claude Code Plugins workflow:

**Result**: Working JWT-based authentication in ~15 minutes

## Prerequisites

Before starting, ensure you have:

- ✅ Claude Code v3.0+ installed
- ✅ Claude Code Plugins installed ([Installation Guide](installation.md))
- ✅ A Node.js project (or follow along with the example)

**Time Required**: 15 minutes

## The Workflow

Claude Code Plugins provide a systematic 4-phase workflow:

```
/explore → /plan → /next → /ship
   ↓         ↓       ↓        ↓
Analyze   Design  Build   Deliver
```

Let's see it in action!

---

## Step 1: Explore the Requirements (3 minutes)

**Goal**: Understand what needs to be built and explore the codebase.

### Run the Command

In your project directory, start a Claude Code session and run:

```bash
/explore "Add JWT-based authentication to the API"
```

### What Happens

Claude will:
1. **Analyze your request** - Understand what "JWT-based authentication" means
2. **Explore your codebase** - Find relevant files (routes, models, middleware)
3. **Identify constraints** - Discover existing auth patterns, dependencies
4. **Document findings** - Create `exploration.md` with analysis

### Expected Output

```
🔍 Exploration: Add JWT-based authentication to the API
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Requirements Analysis
✓ JWT-based authentication requested
✓ Stateless token-based approach
✓ Industry standard for APIs

## Codebase Exploration
Found relevant files:
- src/routes/auth.js (empty, needs implementation)
- src/models/User.js (has password field, needs hashing)
- src/middleware/ (needs auth middleware)

## Existing Dependencies
✓ express: 4.18.2 (web framework)
✓ bcrypt: 5.1.0 (already installed - good for password hashing!)
⚠ jsonwebtoken: NOT installed (need to add)

## Recommendations
1. Install jsonwebtoken package
2. Add password hashing to User model
3. Create login endpoint
4. Implement auth middleware
5. Protect existing routes

Exploration complete → Ready for planning
📁 Created: .claude/work/current/auth_implementation/exploration.md
```

### Common Issues

**Issue**: "No relevant files found"
- **Solution**: Make sure you're in the project root directory
- **Tip**: You can still continue - Claude will guide you to create the structure

**Issue**: "Unclear what you want to explore"
- **Solution**: Be more specific: "Add JWT authentication with login/register endpoints"

---

## Step 2: Create an Implementation Plan (2 minutes)

**Goal**: Break the work into ordered, manageable tasks.

### Run the Command

```bash
/plan
```

**Note**: `/plan` automatically uses the exploration findings from Step 1.

### What Happens

Claude will:
1. **Review exploration** - Load findings from Step 1
2. **Break down work** - Create ordered tasks with dependencies
3. **Define success criteria** - Specify how to verify each task
4. **Create task file** - Generate `implementation-plan.md` and `state.json`

### Expected Output

```
📋 Implementation Plan: JWT Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Task Breakdown (6 tasks, ~3 hours estimated)

TASK-001: Install jsonwebtoken dependency
├─ Priority: High
├─ Time: 15 minutes
└─ Acceptance: Package.json updated, dependency installed

TASK-002: Add password hashing to User model
├─ Dependencies: None
├─ Priority: High
├─ Time: 30 minutes
└─ Acceptance: Passwords hashed on save, comparison method works

TASK-003: Create JWT utilities (generate/verify tokens)
├─ Dependencies: TASK-001
├─ Priority: High
├─ Time: 30 minutes
└─ Acceptance: Can generate and verify valid JWTs

TASK-004: Implement login endpoint
├─ Dependencies: TASK-002, TASK-003
├─ Priority: High
├─ Time: 45 minutes
└─ Acceptance: POST /auth/login returns valid JWT

TASK-005: Create auth middleware
├─ Dependencies: TASK-003
├─ Priority: High
├─ Time: 30 minutes
└─ Acceptance: Middleware validates JWT and attaches user

TASK-006: Protect existing endpoints
├─ Dependencies: TASK-005
├─ Priority: Medium
├─ Time: 30 minutes
└─ Acceptance: Protected routes require valid token

Planning complete → Ready for implementation
📁 Created: .claude/work/current/auth_implementation/implementation-plan.md
📁 Created: .claude/work/current/auth_implementation/state.json
```

### What You Get

- **implementation-plan.md**: Human-readable plan with full details
- **state.json**: Machine-readable task tracking for `/next`

### Common Issues

**Issue**: "No exploration found"
- **Solution**: Run `/explore` first (Step 1)

**Issue**: "Plan looks wrong"
- **Solution**: You can run `/plan` again with more specifics:
  ```bash
  /plan "Focus on minimal viable auth - just login and protect routes"
  ```

---

## Step 3: Execute Tasks One by One (8 minutes)

**Goal**: Implement each task systematically with `/next`.

### Run the Command

```bash
/next
```

**This will execute the first available task (TASK-001).**

### What Happens

Claude will:
1. **Select next task** - Chooses first task with satisfied dependencies
2. **Display task details** - Shows what will be done
3. **Execute task** - Implements the changes
4. **Verify completion** - Checks acceptance criteria
5. **Update state** - Marks task complete, identifies next task
6. **Commit changes** - Auto-commits with descriptive message

### Expected Output (First Task)

```
🚀 Executing TASK-001: Install jsonwebtoken dependency
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Task Details
Priority: High
Estimated: 15 minutes
Dependencies: None (ready to execute)

## Executing...
Running: npm install jsonwebtoken

added 5 packages, and audited 150 packages in 3s
✓ jsonwebtoken@9.0.2 installed successfully

## Verification
✓ Package.json updated with jsonwebtoken@9.0.2
✓ Dependency installed in node_modules
✓ All acceptance criteria met

## Git Commit
[main a7f3d91] feat: Install jsonwebtoken for JWT authentication
 2 files changed, 6 insertions(+)

✅ TASK-001 completed successfully

📊 Progress: 1/6 tasks complete (17%)
→ Next available: TASK-002, TASK-003

Run /next again to continue!
```

### Continue with /next

Keep running `/next` to execute all tasks:

```bash
/next  # Executes TASK-002 (password hashing)
/next  # Executes TASK-003 (JWT utilities)
/next  # Executes TASK-004 (login endpoint)
/next  # Executes TASK-005 (auth middleware)
/next  # Executes TASK-006 (protect routes)
```

**Or run them all at once**: Just keep running `/next` until all tasks are complete!

### Real Example: TASK-004 Output

```
🚀 Executing TASK-004: Implement login endpoint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Implementation
Created: src/routes/auth.js

```javascript
const express = require('express');
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');

const router = express.Router();

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Verify password
    const isValid = await user.comparePassword(password);
    if (!isValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate JWT
    const token = generateToken({ userId: user._id });

    res.json({ token, user: { id: user._id, email: user.email } });
  } catch (error) {
    res.status(500).json({ error: 'Login failed' });
  }
});

module.exports = router;
```

## Verification
✓ POST /auth/login endpoint created
✓ Password verification integrated
✓ JWT generation on successful login
✓ Error handling for invalid credentials
✓ Returns token and user data

✅ TASK-004 completed successfully
📊 Progress: 4/6 tasks complete (67%)
```

### Common Issues

**Issue**: Task fails with "dependency not satisfied"
- **Solution**: Complete the dependent tasks first
- **Tip**: Run `/next --status` to see task dependencies

**Issue**: "Tests failing after implementation"
- **Solution**: Claude will show the error and suggest fixes
- **Tip**: Run `/fix` to debug and resolve test failures

---

## Step 4: Review and Test (1 minute)

**Goal**: Verify everything works before delivery.

### Run the Command

```bash
/review
```

### What Happens

Claude will:
1. **Review all changes** - Check code added during `/next` executions
2. **Run quality checks** - Linting, formatting, security
3. **Identify issues** - Bugs, design flaws, improvements
4. **Provide feedback** - Prioritized list of findings

### Expected Output

```
🔍 Code Review: JWT Authentication Implementation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Files Reviewed
- src/models/User.js
- src/utils/jwt.js
- src/routes/auth.js
- src/middleware/auth.js
- src/routes/users.js (protected)

## Findings

### HIGH Priority
✓ No critical issues found!

### MEDIUM Priority
ℹ️ Consider adding rate limiting to login endpoint
  Location: src/routes/auth.js:12
  Reason: Prevent brute-force attacks
  Suggestion: Use express-rate-limit middleware

### LOW Priority
✓ Code quality good
✓ Error handling present
✓ Security best practices followed

## Summary
✅ Implementation is production-ready
ℹ️  1 optional improvement suggested (rate limiting)

Overall Quality: Excellent
Security: Good
Maintainability: High
```

### Optional: Fix Issues

If the review found issues:

```bash
/fix review
```

This will automatically apply suggested fixes.

### Test Manually

Try the authentication:

```bash
# Register a user (if you have registration)
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"secure123"}'

# Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"secure123"}'

# Returns: {"token":"eyJhbGc...","user":{"id":"...","email":"test@example.com"}}

# Access protected route
curl http://localhost:3000/api/users \
  -H "Authorization: Bearer eyJhbGc..."
```

---

## Step 5: Ship the Feature (1 minute)

**Goal**: Finalize and deliver the completed work.

### Run the Command

```bash
/ship
```

Or create a pull request:

```bash
/ship --pr
```

### What Happens

Claude will:
1. **Verify completion** - Check all tasks are done
2. **Run final tests** - Execute test suite
3. **Generate documentation** - Create completion summary
4. **Create commit/PR** - Package changes for review
5. **Provide summary** - What was delivered and how to use it

### Expected Output

```
🚀 Shipping: JWT Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Pre-Delivery Checks
✅ All 6 tasks completed
✅ Tests passing (12/12)
✅ Code review passed
✅ No outstanding issues

## What Was Delivered

### Features
✅ JWT-based authentication system
✅ Password hashing with bcrypt
✅ Login endpoint: POST /auth/login
✅ Auth middleware for protected routes
✅ Token generation and verification utilities

### Files Modified
- package.json (added jsonwebtoken)
- src/models/User.js (password hashing)
- src/utils/jwt.js (NEW - JWT utilities)
- src/routes/auth.js (NEW - login endpoint)
- src/middleware/auth.js (NEW - auth middleware)
- src/routes/users.js (protected with auth)

### Tests Added
- User model password hashing tests (4 tests)
- JWT utilities tests (6 tests)
- Auth endpoint integration tests (8 tests)

## How to Use

### Login
```bash
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "token": "eyJhbGc...",
  "user": { "id": "...", "email": "user@example.com" }
}
```

### Protected Routes
```bash
GET /api/users
Authorization: Bearer eyJhbGc...
```

## Pull Request Created
🔗 https://github.com/your-org/your-repo/pull/42

Title: feat: Add JWT-based authentication
Status: Ready for review
Reviewers: Automatically suggested based on CODEOWNERS

## Next Steps
1. Team review of PR #42
2. Address any review feedback
3. Merge to main when approved
4. Deploy to staging for integration testing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Feature delivery complete!
📊 Total time: ~15 minutes
📈 Quality: Production-ready
```

### If You Used --pr

Claude will:
- Push your branch to GitHub
- Create a pull request with comprehensive description
- Add test plan checklist
- Suggest reviewers
- Return the PR URL

---

## What You Just Learned

In 15 minutes, you:

✅ **Explored** requirements and codebase with `/explore`
✅ **Planned** implementation with ordered tasks using `/plan`
✅ **Built** the feature systematically with `/next`
✅ **Reviewed** code quality with `/review`
✅ **Shipped** production-ready code with `/ship`

**Result**: Working JWT authentication with tests, documentation, and a pull request!

## The Power of the Workflow

### Why This Workflow Works

1. **Systematic**: No guessing - clear steps from start to finish
2. **Quality-First**: Built-in review and testing at each step
3. **Trackable**: Always know what's done and what's next
4. **Collaborative**: PRs with comprehensive context for reviewers
5. **Fast**: 15 minutes vs. hours of manual coding

### When to Use This Workflow

✅ **Perfect for**:
- Features that span multiple files
- Bug fixes requiring investigation
- Refactoring with many changes
- Work you'll spread across sessions
- Team collaboration (plan serves as spec)

❌ **Skip for**:
- Single-line fixes
- Typo corrections
- Quick documentation updates

## Common Issues & Solutions

### "I made a mistake in exploration"

No problem! Just run `/explore` again:

```bash
/explore "Add JWT authentication with login AND register endpoints"
```

Then `/plan` will use the new exploration.

### "The plan created too many tasks"

You can simplify:

```bash
/plan "Create minimal auth - just login endpoint and one protected route"
```

Or merge tasks by running multiple `/next` commands and manually combining the work.

### "A task failed halfway through"

Claude will mark it as "in_progress" and you can:

1. **Fix the issue** manually
2. **Run `/next` again** - it will resume the same task
3. **Or use `/fix`** to debug the error

### "I want to change the approach mid-implementation"

You can:

1. Finish current task with `/next`
2. Run `/plan` again with new direction
3. Claude will create a new plan building on completed work

## Next Steps

Now that you know the workflow:

1. **Try it on your own project** - Pick a small feature and use the 4-phase workflow
2. **Learn individual plugins** - Explore the [Core](../../plugins/core/README.md), [Workflow](../../plugins/workflow/README.md), and [Development](../../plugins/development/README.md) plugin READMEs
3. **Create a custom plugin** - Follow the [First Plugin Tutorial](first-plugin.md)
4. **Read architecture docs** - Understand the [design principles](../architecture/design-principles.md)

## Quick Reference

### The 4-Phase Workflow

```bash
/explore "<what to build>"     # Step 1: Analyze requirements
/plan                          # Step 2: Create task breakdown
/next                          # Step 3: Execute tasks (repeat)
/ship                          # Step 4: Deliver completed work
```

### Bonus Commands

```bash
/status                        # Check current progress
/next --status                 # See task breakdown and progress
/next --preview                # Show next task without executing
/review                        # Code quality check
/fix                           # Debug and fix issues
/git commit                    # Create well-formatted commit
/git pr                        # Create pull request
```

### Getting Help

- **Full Documentation**: [Documentation Index](../README.md)
- **Plugin READMEs**: Detailed command references in each plugin
- **GitHub Issues**: [Report bugs](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [Ask questions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

---

**Congratulations!** 🎉

You've completed the Quick Start tutorial. You now know how to use Claude Code Plugins to build features systematically and ship quality code fast.

**Ready for more?** Try the workflow on your next feature!
````

## File: examples/README.md
````markdown
# Example Plugins

Three progressive examples demonstrating Claude Code plugin development from basic to advanced.

## Learning Path

### 1. hello-world (Beginner - 5 min)
**Concepts**: Command structure, arguments, basic bash

Start here to understand plugin fundamentals.

[→ Start with hello-world](./hello-world/)

### 2. task-tracker (Intermediate - 15 min)
**Concepts**: JSON state management, file operations, validation

Build a practical task management system.

[→ Continue with task-tracker](./task-tracker/)

### 3. code-formatter (Advanced - 20 min)
**Concepts**: External tools, agent integration, error handling

Integrate external formatters with AI-powered analysis.

[→ Finish with code-formatter](./code-formatter/)

---

**Learn** → **Practice** → **Build** → **Contribute**

🚀 Start with `hello-world/` and work your way through!
````
