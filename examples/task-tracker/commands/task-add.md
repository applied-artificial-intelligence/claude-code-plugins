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
