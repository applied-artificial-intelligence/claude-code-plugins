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
