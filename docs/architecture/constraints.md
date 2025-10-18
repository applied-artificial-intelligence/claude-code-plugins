# Framework Constraints

Technical and architectural constraints that define what Claude Code plugins can and cannot do. Understanding these constraints is essential for building reliable, effective plugins.

## Table of Contents

- [Stateless Execution](#stateless-execution)
- [Command Execution Context](#command-execution-context)
- [Template System](#template-system)
- [File System Boundaries](#file-system-boundaries)
- [MCP Integration](#mcp-integration)
- [Token and Context Limits](#token-and-context-limits)
- [Security and Permissions](#security-and-permissions)
- [Design Philosophy](#design-philosophy)

---

## Stateless Execution

### The Fundamental Constraint

**Every command invocation starts completely fresh.** This is not a bug or limitation—it's the foundation of Claude Code's architecture.

### What Cannot Persist

#### Connections and Sessions
❌ Database connections terminate
❌ API sessions don't carry over
❌ WebSocket connections close
❌ File handles and streams disappear
❌ Network state resets

**Example**:
```bash
# First /command invocation
db = connect_to_database()
query_result = db.query("SELECT * FROM users")

# Second /command invocation
# db is undefined! Connection lost!
# Must reconnect from scratch
```

#### Runtime State
❌ Object instances are recreated
❌ Global variables reset
❌ State machines restart
❌ Background processes terminate
❌ Scheduled tasks don't persist

**Example**:
```bash
# First command
COUNTER=5
export PROGRESS="50%"

# Second command
# COUNTER is undefined!
# PROGRESS doesn't exist!
```

#### Async and Parallelism
❌ Async operations can't span commands
❌ Background jobs don't continue
❌ File watchers terminate
❌ Event listeners disappear
❌ Deferred execution fails

**Example**:
```javascript
// This won't work:
fs.watch('/path', callback);  // Watch terminates when command ends
setTimeout(() => {...}, 5000); // Never executes across commands
```

### Working With Statelessness

#### ✅ File-Based State
```bash
# Save state
echo '{"phase": "implementing", "task": "TASK-003"}' > .claude/state.json

# Load state (in next command)
STATE=$(cat .claude/state.json)
TASK=$(echo "$STATE" | jq -r '.task')
```

#### ✅ Idempotent Operations
```bash
# Safe to run multiple times
if [ ! -f "config.json" ]; then
    create_config
else
    validate_config
fi

# Or: create-or-update pattern
mkdir -p output/
echo "data" > output/result.txt  # Overwrites if exists
```

#### ✅ Git as Checkpoints
```bash
# Create recovery points
git add .
git commit -m "Checkpoint before risky operation"

# Revert if needed
git reset --hard HEAD~1
```

---

## Command Execution Context

### Commands Are Templates, Not Scripts

This is a critical distinction that affects how you write commands.

### Execution Location

**Commands execute in the user's project directory, NOT in `~/.claude/commands/`**

```bash
# When command runs:
pwd
# Returns: /home/user/my-project

# NOT:
# /home/user/.claude/commands/
```

### Why This Matters

#### ❌ Cannot Source External Scripts

All these attempts FAIL:
```bash
# Relative to command location - FAILS
source "$(dirname "$0")/utils.sh"

# Absolute path to commands - FAILS
source ~/.claude/commands/helpers/common.sh

# Relative shared directory - FAILS
source ../lib/utilities.sh
```

**Why they fail**: Command files exist in `~/.claude/commands/`, but bash executes in `/path/to/project/`. The files aren't there.

#### ✅ Must Use Inline Logic

Everything must be self-contained:
```bash
# Copy this to EVERY command that needs it
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

require_tool() {
    command -v "$1" >/dev/null 2>&1 || error_exit "$1 not installed"
}
```

### Why Duplication Is Correct

You'll see the same utility functions in multiple commands. This is **intentional**:

**Reason 1**: Execution context prevents sourcing
**Reason 2**: Templates aren't programs (can't import)
**Reason 3**: Each command must be independently executable
**Reason 4**: No dependency management overhead

**Evidence**: Core plugins have ~44 lines of bash utilities duplicated across 23 commands. This is by design.

**See Also**: Factory project has complete explanation in `WHY_DUPLICATION_EXISTS.md`

---

## Template System

### Markdown-Based Commands

Commands are Markdown files with frontmatter and implementation:

```markdown
---
name: my-command
description: What it does
allowed-tools: [Bash, Read, Write]
argument-hint: "[options]"
---

# My Command

Documentation here...

## Implementation

```bash
#!/bin/bash
# Code here with $ARGUMENTS
```
```

### Variable Substitution

The **only** dynamic element is `$ARGUMENTS`:

```bash
# User types: /greet Alice
# Framework substitutes: $ARGUMENTS → "Alice"

NAME="${1:-World}"  # Extracts from $ARGUMENTS
echo "Hello, $NAME!"
```

**No other substitution exists**:
- ❌ No {{TEMPLATE_VARS}}
- ❌ No preprocessing phase
- ❌ No build-time injection
- ❌ No conditional includes

### Template Processing Flow

```
User types: /command arg1 arg2
    ↓
Claude reads: ~/.claude/commands/command.md
    ↓
Substitutes: $ARGUMENTS → "arg1 arg2"
    ↓
Extracts bash: Code between ```bash blocks
    ↓
Executes in: /path/to/user/project/
    ↓
Returns output: Back to Claude for processing
```

### Constraints This Creates

#### ✅ DO: Keep logic in bash
```bash
# Good: Logic in bash where it can execute
if [ "$DRY_RUN" = "true" ]; then
    echo "Would deploy..."
else
    deploy_actual
fi
```

#### ❌ DON'T: Try template logic
```markdown
<!-- Bad: This doesn't work -->
{{#if user.admin}}
  Admin panel
{{else}}
  User panel
{{/if}}
```

Instead, let Claude handle logic:
```markdown
<!-- Good: Claude decides based on context -->
I'll check the user's role and show the appropriate interface.
```

---

## File System Boundaries

### Working Directory

Commands ALWAYS execute in the user's project directory:

```bash
# These paths are relative to project:
cat .claude/work/state.json        # ✅ Works
cat README.md                       # ✅ Works
ls src/                            # ✅ Works

# These paths may not exist:
cat ~/.claude/commands/utils.sh    # ❌ Might fail
ls /global/shared/lib/             # ❌ Might fail
```

### File-Based State is Required

Since nothing else persists, **files are the ONLY state mechanism**:

```
.claude/
├── work/
│   ├── ACTIVE_WORK              # Active work unit name
│   ├── current/
│   │   └── [work-unit]/
│   │       ├── state.json      # Task state
│   │       └── metadata.json   # Work unit info
│   └── archives/               # Completed work
├── memory/
│   ├── context.md              # Session context
│   └── decisions.md            # Key decisions
└── transitions/
    └── latest/handoff.md       # Session handoffs
```

### Git as State Manager

Git provides critical state management:

```bash
# Checkpoint before risky changes
git add .
git commit -m "Checkpoint: Before refactor"

# If things go wrong
git reset --hard HEAD~1  # Restore previous state

# Track progress
git log --oneline  # See what's been done

# Branching for parallel work
git checkout -b feature/experimental
```

### Permissions and Access

Commands can only access:
- ✅ Files in project directory
- ✅ User's home directory (with permission)
- ✅ System commands in PATH
- ❌ Arbitrary system files (restricted)
- ❌ Other users' directories (restricted)

---

## MCP Integration

### MCP Tools Are Always Optional

**Critical Rule**: All functionality must work WITHOUT MCP tools.

```bash
# ✅ Correct: Graceful degradation
if command -v serena &> /dev/null; then
    # Enhanced: Use Serena MCP (70-90% token reduction)
    serena find_symbol "MyClass"
else
    # Fallback: Use grep (slower but works)
    grep -r "class MyClass" src/
fi
```

```bash
# ❌ Wrong: Requiring MCP
serena find_symbol "MyClass"  # Fails without Serena!
```

### MCP State Doesn't Persist

Like all state, MCP connections reset between commands:

```bash
# First command
serena_db = connect_serena_database()
result = query_symbols()

# Second command
# serena_db is gone! Must reconnect!
```

### MCP Tools Run in AI Context

MCP tools are executed by Claude, not directly in bash:

```bash
# ❌ Cannot pipe MCP output to bash
serena find_symbol "MyClass" | grep "method"  # Doesn't work

# ✅ Claude processes MCP results, then bash runs
# (Claude invokes Serena, gets results, then bash processes)
```

### Declaration in plugin.json

Always declare MCP tools as optional:

```json
{
  "name": "my-plugin",
  "mcpTools": {
    "optional": ["serena", "sequential-thinking"],
    "gracefulDegradation": true
  }
}
```

**Never** use `"required"`:
```json
{
  "mcpTools": {
    "required": ["serena"]  // ❌ WRONG - breaks without MCP
  }
}
```

---

## Token and Context Limits

### Limited Context Window

Claude has a finite context window that fills with:
- Conversation history
- Loaded memory files (CLAUDE.md, imports)
- Open file contents
- Command definitions
- MCP tool definitions

### Context Management Strategies

#### ✅ DO: Be Selective
```bash
# Good: Focused grep with limits
grep "specific_pattern" file.txt | head -20

# Good: Read specific sections
cat file.txt | sed -n '100,200p'
```

#### ❌ DON'T: Load Everything
```bash
# Bad: Loads entire large file
cat huge_database.sql  # May exhaust context

# Bad: Recursive file reading
find . -type f -exec cat {} \;  # Definitely too much
```

### Memory File Limits

```markdown
# CLAUDE.md (keep concise)
## Project Overview
Brief description...

@memory/details.md  # Use imports for details

# memory/details.md (stay focused)
## Architecture Details
Only essential information...
```

**Guidelines**:
- Keep CLAUDE.md < 10KB
- Each import file < 5KB
- Total imports < 50KB
- Archive old context regularly

### Token Optimization with MCP

**Serena** provides 70-90% token reduction for code operations:
```bash
# Standard approach: Read entire file
cat src/module.py  # 500 lines = ~2000 tokens

# Serena approach: Get just what you need
serena find_symbol "authenticate"  # Just the function = ~200 tokens
```

### Context Health Monitoring

```bash
# Check context usage (hypothetical /context command)
/context
# Messages: 45% (23K tokens)
# Memory: 15% (8K tokens)
# Tools: 10% (5K tokens)
# Total: 70% (36K tokens)

# Optimize when > 80%:
# - Archive old conversation (/handoff)
# - Reduce memory imports
# - Clear completed work
```

---

## Security and Permissions

### Tool Permission Model

Claude Code uses pattern-based permissions:

```json
{
  "permissions": {
    "deny": [
      "Bash(rm -rf /*:*)",      // Prevent dangerous rm
      "Read(.env)",              // Block secrets
      "Read(*.pem)"             // Block private keys
    ],
    "ask": [
      "Bash(git push:*)",       // Confirm before push
      "Write(*.py)",            // Ask before writing code
      "Bash(npm install:*)"     // Confirm installs
    ],
    "allow": [
      "Read(*.md)",             // Always allow doc reading
      "Grep(**)",               // Always allow search
      "Bash(git status:*)"      // Always allow git status
    ]
  }
}
```

### Execution Boundaries

Commands cannot:
- ❌ Execute with sudo/elevated privileges
- ❌ Modify system files outside project
- ❌ Access other users' files
- ❌ Execute arbitrary binaries without approval
- ❌ Bypass file permissions
- ❌ Create network servers that persist

### Security Best Practices

#### ✅ DO: Validate inputs
```bash
# Check arguments
if [[ ! "$FILE" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
    error_exit "Invalid filename: $FILE"
fi

# Verify files exist before operations
if [ ! -f "$FILE" ]; then
    error_exit "File not found: $FILE"
fi
```

#### ✅ DO: Use safe commands
```bash
# Good: Specific rm
rm -f output.txt

# Bad: Dangerous rm
rm -rf *  # Will be blocked or require confirmation
```

#### ✅ DO: Handle secrets properly
```bash
# Read from secure storage
API_KEY=$(cat .env | grep API_KEY | cut -d= -f2)

# Don't echo secrets
if [ -z "$API_KEY" ]; then
    error_exit "API_KEY not found in .env"
fi
# Don't: echo "Using key: $API_KEY"
```

---

## Design Philosophy

### Embrace Constraints, Don't Fight Them

These constraints lead to **better design**:

1. **Statelessness** → Predictable, reproducible behavior
2. **Templates** → Simple, maintainable commands
3. **Duplication** → Self-contained, reliable execution
4. **File-based** → Transparent, debuggable state
5. **MCP optional** → Graceful degradation, broader compatibility

### Wrong Approaches (Don't Do This)

❌ **Fighting Statelessness**:
```bash
# Trying to maintain connections
# Building elaborate state machines
# Expecting variables to persist
```

❌ **Complex Workarounds**:
```bash
# Attempting to source shared code
# Creating preprocessing systems
# Building dependency managers
```

❌ **Assuming MCP**:
```bash
# Requiring MCP tools
# No fallback for missing tools
# Breaking without enhancement
```

### Right Approaches (Do This)

✅ **Accept Statelessness**:
```bash
# Use files for all state
# Design idempotent operations
# Create atomic transactions
```

✅ **Embrace Simplicity**:
```bash
# Duplicate small utilities
# Keep commands focused
# One command, one purpose
```

✅ **Graceful Degradation**:
```bash
# Check for MCP availability
# Provide standard fallbacks
# Never require enhancements
```

---

## Summary

### The 8 Core Constraints

1. **Stateless Execution**: Every command starts fresh, nothing persists
2. **Execution Context**: Commands run in project dir, not ~/.claude/
3. **Template System**: Markdown with $ARGUMENTS substitution only
4. **File System**: All persistence through files, git for checkpoints
5. **MCP Optional**: Enhanced features must have fallbacks
6. **Token Limits**: Finite context window, must manage carefully
7. **Security**: Permission-based access, no elevated privileges
8. **Duplication**: Self-contained commands, no shared utilities

### Design Checklist

When creating commands, verify:

- [ ] No persistent connections or state
- [ ] All logic inline (no external sourcing)
- [ ] File-based state management
- [ ] Idempotent operations (safe to repeat)
- [ ] MCP graceful degradation
- [ ] Token-conscious file operations
- [ ] Input validation and error handling
- [ ] Security best practices followed

### Common Mistakes

❌ Expecting variables to persist
❌ Trying to source external scripts
❌ Assuming MCP tools available
❌ Loading entire large files
❌ Requiring elevated permissions
❌ Building complex state machines
❌ Fighting the framework's design

### Key Insights

1. **Constraints enable reliability**: Statelessness ensures predictability
2. **Duplication is correct**: Execution context requires self-containment
3. **Files are the database**: Only reliable persistence mechanism
4. **MCP enhances, not replaces**: Always provide standard approach
5. **Simplicity wins**: Work with constraints, not against them

---

## Further Reading

- [Design Principles](design-principles.md) - Philosophical foundation
- [Plugin Patterns](patterns.md) - Proven implementation patterns
- [Quick Start Tutorial](../getting-started/quick-start.md) - See constraints in practice
- [First Plugin Tutorial](../getting-started/first-plugin.md) - Build within constraints

---

*These constraints define the boundaries of Claude Code plugins. Understanding and embracing them leads to reliable, maintainable, and powerful automation.*
