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
