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
