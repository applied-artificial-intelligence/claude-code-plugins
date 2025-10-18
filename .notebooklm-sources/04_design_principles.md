# Design Principles

Core architectural principles for building reliable Claude Code plugins. Understanding these principles will help you create plugins that work seamlessly with Claude Code's execution model.

## Table of Contents

- [Stateless Execution Model](#stateless-execution-model)
- [File-Based Persistence](#file-based-persistence)
- [Self-Containment](#self-containment)
- [Execution Context](#execution-context)
- [MCP Optional](#mcp-optional)
- [Design Philosophy](#design-philosophy)

---

## Stateless Execution Model

### The Fundamental Principle

**Every command invocation is completely independent.**

```
[Fresh Start] → [Read State] → [Do Work] → [Write State] → [Complete End]
```

Nothing carries over between invocations. No connections, no objects, no background processes. Everything must be explicitly persisted to files and reloaded on next execution.

### Why Statelessness Matters

Statelessness isn't a limitation—it's a fundamental design choice that provides:

- **Predictability**: Each execution starts clean, eliminating hidden state bugs
- **Reliability**: No corrupted state can persist across invocations
- **Simplicity**: No complex state synchronization required
- **Transparency**: All state is visible in files
- **Recoverability**: Easy to restore from any point
- **Debuggability**: State is always inspectable

### What Cannot Persist

Understanding what disappears between command invocations is crucial:

#### Connections and Sessions
❌ **Database connections** - Must reconnect for each operation
❌ **API sessions** - Re-authenticate every time
❌ **Network state** - WebSockets and HTTP sessions vanish
❌ **File handles** - Open files, streams, cursors disappear

#### Runtime State
❌ **Object instances** - No persistent objects or singletons
❌ **State machines** - Must be reconstructed from files
❌ **Background processes** - No daemons or watchers
❌ **Scheduled tasks** - No cron-like delayed execution

#### Technical Boundaries
❌ **No parallelism** - Async operations cannot span invocations
❌ **No real-time monitoring** - Cannot watch for changes
❌ **Terminal-only interface** - No persistent GUI
❌ **Text-based processing** - Limited to text and scripts

### Working With Statelessness

#### Patterns That Work

**1. File-Based State Management**

Store all state in JSON or Markdown files:

```json
// .claude/work/current/my-task/state.json
{
  "phase": "implementing",
  "current_task": "TASK-003",
  "completed_tasks": ["TASK-001", "TASK-002"],
  "last_updated": "2025-10-18T15:30:00Z"
}
```

**2. Idempotent Operations**

Design commands that can be safely repeated:

```bash
# Good: Check before creating
if [ ! -d "$WORK_DIR" ]; then
    mkdir -p "$WORK_DIR"
fi

# Bad: Assumes directory doesn't exist
mkdir "$WORK_DIR"  # Fails if already exists
```

**3. Atomic Transactions**

Complete operations within single invocation:

```bash
# Good: All changes in one command
update_state() {
    # Read current state
    local state=$(cat state.json)

    # Modify
    local new_state=$(echo "$state" | jq '.phase = "complete"')

    # Write atomically
    echo "$new_state" > state.json.tmp
    mv state.json.tmp state.json

    # Commit checkpoint
    git add state.json
    git commit -m "Update state to complete"
}
```

**4. Explicit Context Passing**

Store context in files, not memory:

```bash
# Good: Read context from file every time
load_context() {
    if [ -f ".claude/context.json" ]; then
        CONTEXT=$(cat .claude/context.json)
    fi
}

# Bad: Expect variable from previous run
echo "Continuing from $LAST_STEP"  # LAST_STEP doesn't exist
```

#### Anti-Patterns to Avoid

❌ **Trying to maintain connections**
```python
# WRONG: Expecting connection to persist
db = connect_to_database()
# Connection is lost on next invocation!
```

❌ **Assuming previous state**
```bash
# WRONG: Variable from previous run
echo "Count: $((COUNTER + 1))"  # COUNTER is undefined
```

❌ **Background processing**
```javascript
// WRONG: Watcher terminates immediately
fs.watch('/path', callback);  # Process ends, watcher dies
```

---

## File-Based Persistence

### The File System is Your Database

Claude Code plugins use the file system for all persistence:

```
.claude/
├── work/
│   ├── current/           # Active work units
│   │   └── task-001/
│   │       ├── state.json # Task state
│   │       └── metadata.json
│   └── archives/          # Completed work
├── memory/
│   ├── context.md         # Session context
│   └── decisions.md       # Key decisions
└── transitions/
    └── 2025-10-18_001/    # Handoff documents
        └── handoff.md
```

### State File Patterns

#### JSON for Structured Data

```json
{
  "id": "task-001",
  "status": "in_progress",
  "created_at": "2025-10-18T10:00:00Z",
  "metadata": {
    "priority": "high",
    "estimated_hours": 3
  },
  "dependencies": ["task-000"]
}
```

#### Markdown for Documentation

```markdown
# Task 001: Add User Authentication

## Status
- Phase: Implementation
- Progress: 60%
- Next: Write tests

## Context
User authentication is critical for...
```

#### YAML for Configuration

```yaml
plugin:
  name: my-plugin
  version: 1.0.0
  commands:
    - commands/*.md
  agents:
    - agents/*.md
```

### Git as State Machine

Use git commits as natural checkpoints:

- **Commits**: Provide recovery points
- **Branches**: Enable parallel work
- **History**: Enable rollback
- **Tags**: Mark milestones

Example from `/next` command:

```bash
# Complete task and create checkpoint
git add .
git commit -m "feat: Complete TASK-003 - Add user auth

Acceptance criteria met:
- JWT token generation ✅
- Login endpoint ✅
- Auth middleware ✅
"
```

---

## Self-Containment

### All Logic Must Be Inline

**Critical Design Constraint**: Commands cannot source external scripts.

#### Why Self-Containment is Required

Commands execute in the **project directory**, not in `~/.claude/commands/`. This means:

```bash
# Command file location
~/.claude/commands/my-command.md

# Execution directory
~/my-project/

# Therefore, relative paths fail:
source ../helpers/utils.sh  # File not found!
```

#### The Correct Approach: Inline Everything

Each command must contain all its logic:

```markdown
---
name: my-command
description: Example self-contained command
---

# My Command

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Standard constants (MUST be copied to each command)
readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"

# Error handling (MUST be copied to each command)
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

# Tool requirements (MUST be copied to each command)
require_tool() {
    local tool="$1"
    if ! command -v "$tool" >/dev/null 2>&1; then
        error_exit "$tool is required but not installed"
    fi
}

# Command-specific logic
main() {
    require_tool "jq"

    echo "Executing command..."
    # Implementation here
}

main
```
```

### Why Duplication is Acceptable

You might notice utility functions duplicated across commands. This is **intentional and correct**:

✅ **Advantages of duplication**:
- Each command is independently executable
- No dependency management complexity
- Clear what each command needs
- Easy to modify without breaking others

❌ **Problems with shared utilities**:
- Execution context makes sourcing impossible
- Dependency on file system layout
- Brittle when commands installed elsewhere
- Harder to understand command requirements

**See Also**: [Why Duplication Exists](../reference/why-duplication-exists.md) for complete rationale

---

## Execution Context

### Commands Are Templates, Not Scripts

A critical distinction: Claude Code commands are **templates** that get rendered, not scripts that get sourced.

### How Command Execution Works

1. **Template Rendering**: Claude reads `.md` file, substitutes variables
2. **Bash Extraction**: Extracts bash code from markdown
3. **Execution in Project**: Runs bash in user's project directory
4. **Return to Claude**: Output returned for Claude to process

```
~/.claude/commands/greet.md
    ↓ (Claude reads template)
    ↓ (Substitutes $ARGUMENTS)
    ↓ (Extracts bash)
    ↓ (Executes in ~/my-project/)
    ↓ (Returns output)
Claude processes results
```

### Variable Substitution

Commands use **runtime substitution**:

```markdown
---
name: greet
---

**Input**: $ARGUMENTS

```bash
#!/bin/bash
NAME="${1:-World}"
echo "Hello, $NAME!"
```
```

When user runs `/greet Alice`:
- `$ARGUMENTS` → `"Alice"`
- Command executes with `NAME="Alice"`
- Output: `"Hello, Alice!"`

### Working Directory Context

Commands always execute in the **user's project directory**:

```bash
# If user is in ~/my-project/
pwd
# Output: /home/user/my-project

# NOT:
# /home/user/.claude/commands/
```

This means:
- ✅ Can access project files: `cat README.md`
- ✅ Can modify project: `mkdir src/`
- ✅ Can use git: `git status`
- ❌ Cannot access command directory files
- ❌ Cannot source sibling scripts

---

## MCP Optional

### Model Context Protocol is an Enhancement, Not a Requirement

All plugin functionality must work **without** MCP tools. MCP tools enhance performance and capabilities but are always optional.

### Graceful Degradation Pattern

Every MCP-enhanced feature must have a fallback:

```bash
# Check if Serena MCP is available
if command -v serena-mcp &> /dev/null; then
    # Enhanced: Use semantic search (70-90% faster)
    serena-mcp find_symbol "MyClass"
else
    # Fallback: Use grep (slower but works)
    grep -r "class MyClass" src/
fi
```

### Common MCP Tool Degradation

#### Sequential Thinking
- **With MCP**: Structured step-by-step reasoning
- **Without MCP**: Standard analytical reasoning

```bash
# No code changes needed - Claude automatically degrades
```

#### Serena (Semantic Code Understanding)
- **With MCP**: Symbol-level search, -70-90% token usage
- **Without MCP**: File reading and grep search

```bash
if command -v serena &> /dev/null; then
    # Fast semantic search
    serena find_symbol "authenticate"
else
    # Fallback to grep
    grep -r "def authenticate" .
fi
```

#### Context7 (Documentation Access)
- **With MCP**: Real-time library docs
- **Without MCP**: Web search or cached docs

```bash
# Context7 is transparent to commands
# Claude handles degradation automatically
```

### MCP Declaration in plugin.json

Declare optional MCP tools in manifest:

```json
{
  "name": "my-plugin",
  "mcpTools": {
    "optional": ["serena", "sequential-thinking"],
    "gracefulDegradation": true
  }
}
```

**Never use**:
```json
{
  "mcpTools": {
    "required": ["serena"]  // ❌ WRONG - breaks without MCP
  }
}
```

---

## Design Philosophy

### Embrace Constraints, Don't Fight Them

Claude Code's architectural constraints aren't bugs to work around—they're features to design with.

#### Statelessness → Better Design

**Bad Reaction**: "I need to work around statelessness"
**Good Reaction**: "I'll design for statelessness from the start"

Stateless design leads to:
- Simpler code (no state synchronization)
- Easier testing (no hidden state)
- Better reliability (no state corruption)

#### Self-Containment → Independence

**Bad Reaction**: "I'll find a way to share utilities"
**Good Reaction**: "Each command will be independently executable"

Self-contained commands provide:
- No dependency management
- Clear requirements per command
- Easy to modify without side effects

#### File-Based Persistence → Transparency

**Bad Reaction**: "Files are primitive, I need a database"
**Good Reaction**: "Files make all state visible and inspectable"

File-based persistence gives:
- Easy debugging (just read the files)
- Version control (git tracks everything)
- User transparency (can see all state)

### Design for Reconstruction

Every command should be able to:

1. **Detect current state** from files
2. **Validate state consistency**
3. **Reconstruct necessary context**
4. **Proceed or fail gracefully**

Example from `/next` command:

```bash
# Load and validate state
if [ ! -f "${WORK_DIR}/ACTIVE_WORK" ]; then
    error_exit "No active work unit. Run /explore first."
fi

ACTIVE_WORK=$(cat "${WORK_DIR}/ACTIVE_WORK")
STATE_FILE="${WORK_DIR}/current/${ACTIVE_WORK}/state.json"

if [ ! -f "$STATE_FILE" ]; then
    error_exit "No state file. Run /plan first."
fi

# Validate state
STATUS=$(jq -r '.status' "$STATE_FILE")
if [ "$STATUS" != "implementing" ]; then
    error_exit "Work unit not ready. Current status: $STATUS"
fi
```

### Prefer Explicit Over Implicit

Make everything visible and traceable:

✅ **Good**: Explicit state in files
```bash
echo '{"phase": "complete"}' > .claude/state.json
```

❌ **Bad**: Implicit state in variables
```bash
PHASE="complete"  # Lost on next invocation
```

✅ **Good**: Explicit error messages
```bash
error_exit "state.json not found. Run /plan to create it."
```

❌ **Bad**: Silent failures
```bash
cat state.json 2>/dev/null  # Hides the problem
```

---

## Real Examples from Core Plugins

### Example 1: `/status` Command

Demonstrates stateless design and file-based state:

```bash
# From plugins/core/commands/status.md

# Load active work
ACTIVE_WORK=$(cat .claude/work/ACTIVE_WORK 2>/dev/null || echo "")

if [ -z "$ACTIVE_WORK" ]; then
    echo "No active work unit"
else
    # Reconstruct state from files
    STATE_FILE=".claude/work/current/${ACTIVE_WORK}/state.json"

    if [ -f "$STATE_FILE" ]; then
        STATUS=$(jq -r '.status' "$STATE_FILE")
        TASKS=$(jq '.tasks | length' "$STATE_FILE")
        COMPLETE=$(jq '[.tasks[] | select(.status=="completed")] | length' "$STATE_FILE")

        echo "Work Unit: $ACTIVE_WORK"
        echo "Status: $STATUS"
        echo "Progress: $COMPLETE/$TASKS tasks"
    fi
fi
```

**Design principles applied**:
- ✅ Stateless: Reads state from files every time
- ✅ File-based: All state in JSON files
- ✅ Self-contained: All logic inline
- ✅ Idempotent: Safe to run multiple times
- ✅ Graceful: Handles missing files

### Example 2: `/next` Command

Demonstrates atomic operations and git integration:

```bash
# From plugins/workflow/commands/next.md

# Select next task
NEXT_TASK=$(jq -r '.next_available[0]' state.json)

if [ -z "$NEXT_TASK" ]; then
    echo "✅ All tasks complete!"
    exit 0
fi

# Execute task
execute_task "$NEXT_TASK"

# Update state atomically
jq ".completed_tasks += [\"$NEXT_TASK\"]" state.json > state.json.tmp
mv state.json.tmp state.json

# Commit checkpoint
git add state.json
git commit -m "Complete $NEXT_TASK"

echo "✅ Task complete"
echo "→ Run /next again to continue"
```

**Design principles applied**:
- ✅ Atomic: Complete operation in one invocation
- ✅ Git checkpoint: Commit creates recovery point
- ✅ User guidance: Clear next steps
- ✅ State update: Explicit file modification

### Example 3: `/plan` Command

Demonstrates reconstruction from exploration:

```bash
# From plugins/workflow/commands/plan.md

# Find exploration document
EXPLORATION="exploration.md"

if [ ! -f "$EXPLORATION" ]; then
    error_exit "No exploration found. Run /explore first."
fi

# Reconstruct context from exploration
CONTEXT=$(cat "$EXPLORATION")

# Generate implementation plan
# (Claude processes exploration and creates plan)

# Write state file
cat > state.json <<EOF
{
  "status": "planning_complete",
  "tasks": [...],
  "created_at": "$(date -Iseconds)"
}
EOF

echo "✅ Implementation plan created"
echo "→ Run /next to start execution"
```

**Design principles applied**:
- ✅ Reconstruction: Builds context from files
- ✅ Clear dependencies: Requires /explore first
- ✅ State transition: Updates status file
- ✅ User guidance: Shows next action

---

## Summary

### The Five Core Principles

1. **Stateless Execution**: Nothing persists between invocations
2. **File-Based Persistence**: Use file system as database
3. **Self-Containment**: All logic inline, no external sourcing
4. **Execution Context**: Commands are templates executed in project directory
5. **MCP Optional**: All features work without MCP, graceful degradation

### Design Checklist

When creating commands, ensure:

- [ ] No persistent connections or background processes
- [ ] All state explicitly stored in files
- [ ] All utilities copied inline (no external sourcing)
- [ ] Idempotent operations (safe to repeat)
- [ ] Atomic transactions (complete in one invocation)
- [ ] Git commits for checkpoints
- [ ] Clear error messages
- [ ] Graceful MCP degradation
- [ ] User guidance on next steps

### Common Mistakes to Avoid

❌ Expecting variables to persist
❌ Trying to maintain connections
❌ Sourcing external utility scripts
❌ Assuming MCP tools are available
❌ Silent failures without clear errors
❌ Complex state synchronization
❌ Background processes or watchers

### Key Takeaways

1. **Statelessness is a feature** - Design with it, not against it
2. **Files are your database** - Embrace file-based persistence
3. **Git is your state machine** - Use commits as checkpoints
4. **Duplication is correct** - Self-containment requires it
5. **MCP enhances, not replaces** - Always provide fallbacks

---

## Further Reading

- [Plugin Patterns](patterns.md) - Common patterns for commands and agents
- [Framework Constraints](constraints.md) - Technical limitations and boundaries
- [Why Duplication Exists](../reference/why-duplication-exists.md) - Rationale for inline utilities
- [Quick Start Tutorial](../getting-started/quick-start.md) - See principles in action
- [First Plugin Tutorial](../getting-started/first-plugin.md) - Build with these principles

---

*These design principles enable reliable, predictable, and maintainable Claude Code plugins across all domains.*
