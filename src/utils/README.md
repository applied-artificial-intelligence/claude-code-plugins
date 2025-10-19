# Claude Code Common Utilities

**Version**: 1.0.0
**File**: `src/utils/common.sh`
**Purpose**: Single source of truth for command utility functions

---

## Overview

This directory contains the canonical utilities that are injected into all Claude Code command files during the build process. Instead of duplicating ~44 lines of code across 30+ commands, we maintain a single source file that is automatically injected at build time.

## Architecture

### Build-Time Injection
```
Development                  Build                   Distribution
──────────────────          ──────────              ─────────────────
src/utils/common.sh    →    scripts/build.sh   →    plugins/*/commands/*.md
(this file)                 (preprocessor)          (self-contained)
```

### How It Works
1. **Development**: Edit `src/utils/common.sh` (this file)
2. **Build**: Run `scripts/build.sh` to inject into all commands
3. **Distribution**: Commands contain injected utilities (self-contained)
4. **Runtime**: Commands execute independently with full utilities

## Utility Reference

### Constants

#### `CLAUDE_DIR`
- **Type**: `readonly string`
- **Value**: `.claude`
- **Purpose**: Root directory for all Claude Code framework files
- **Usage**: Base path for work units, memory, transitions

```bash
# Example
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Not a Claude Code project"
fi
```

#### `WORK_DIR`
- **Type**: `readonly string`
- **Value**: `.claude/work`
- **Purpose**: Root directory for all work units
- **Usage**: Work unit management and storage

```bash
# Example
ACTIVE_WORK=$(cat "${WORK_DIR}/ACTIVE_WORK")
```

#### `WORK_CURRENT`
- **Type**: `readonly string`
- **Value**: `.claude/work/current`
- **Purpose**: Directory for active (non-archived) work units
- **Usage**: Current work unit access

```bash
# Example
WORK_UNIT_DIR="${WORK_CURRENT}/${WORK_UNIT_NAME}"
```

#### `MEMORY_DIR`
- **Type**: `readonly string`
- **Value**: `.claude/memory`
- **Purpose**: Long-term project knowledge storage
- **Usage**: Persistent memory files

```bash
# Example
if [ -f "${MEMORY_DIR}/project_context.md" ]; then
    # Load project context
fi
```

#### `TRANSITIONS_DIR`
- **Type**: `readonly string`
- **Value**: `.claude/transitions`
- **Purpose**: Session handoff documentation
- **Usage**: Storing handoff files between sessions

```bash
# Example
LATEST_HANDOFF="${TRANSITIONS_DIR}/latest/handoff.md"
```

---

### Error Handling Functions

#### `error_exit(message)`
Print error message to stderr and exit with status 1.

**Parameters**:
- `message` (string): Error message to display

**Exits**: Yes (status 1)

**Usage**:
```bash
# Example 1: Configuration validation
if [ ! -f "config.json" ]; then
    error_exit "Configuration file not found: config.json"
fi

# Example 2: Invalid input
if [ -z "$PROJECT_NAME" ]; then
    error_exit "Project name is required"
fi

# Example 3: Dependency check
if [ ! -d "${WORK_DIR}" ]; then
    error_exit "Claude Code framework not initialized. Run /setup first."
fi
```

**Output Format**:
```
ERROR: [message]
```

**Best Practices**:
- Use for fatal errors that prevent command execution
- Provide clear, actionable error messages
- Include context about what failed and why

---

#### `warn(message)`
Print warning message to stderr (does not exit).

**Parameters**:
- `message` (string): Warning message to display

**Exits**: No (continues execution)

**Usage**:
```bash
# Example 1: Deprecated feature
if [[ "$USE_OLD_API" = "true" ]]; then
    warn "Old API is deprecated. Use new API instead."
fi

# Example 2: Missing optional dependency
if ! command -v jq >/dev/null 2>&1; then
    warn "jq not installed - some features may be limited"
fi

# Example 3: Potential issue
if [ $FILE_COUNT -gt 100 ]; then
    warn "Large number of files may slow down processing"
fi
```

**Output Format**:
```
WARNING: [message]
```

**Best Practices**:
- Use for non-fatal issues or potential problems
- Inform user of deprecated features or best practices
- Alert about missing optional dependencies

---

#### `debug(message)`
Print debug message to stderr if `DEBUG=true`.

**Parameters**:
- `message` (string): Debug message to display

**Exits**: No (continues execution)

**Enabled**: Only when `DEBUG=true` environment variable is set

**Usage**:
```bash
# Example 1: Variable inspection
debug "WORK_UNIT_ID: ${WORK_UNIT_ID}"
debug "Processing file: ${file}"

# Example 2: Control flow tracking
debug "Entering task selection logic"
if [ -n "$CURRENT_TASK" ]; then
    debug "Resuming task: $CURRENT_TASK"
else
    debug "Selecting new task"
fi

# Example 3: State inspection
debug "State file contents: $(cat state.json)"
```

**Enabling Debug Mode**:
```bash
# Enable for single command
DEBUG=true /next

# Enable for entire session
export DEBUG=true
```

**Output Format**:
```
DEBUG: [message]
```

**Best Practices**:
- Use liberally for development and troubleshooting
- Include variable values and state information
- Track control flow through complex logic
- Zero runtime cost when DEBUG=false

---

### File System Utilities

#### `safe_mkdir(directory)`
Create directory with comprehensive error handling.

**Parameters**:
- `directory` (string): Path to directory to create

**Exits**: Yes (if creation fails)

**Features**:
- Creates parent directories automatically (`mkdir -p`)
- Validates directory creation succeeded
- Provides clear error message on failure

**Usage**:
```bash
# Example 1: Work unit creation
WORK_UNIT_DIR="${WORK_CURRENT}/${WORK_UNIT_NAME}"
safe_mkdir "$WORK_UNIT_DIR"

# Example 2: Nested directory structure
safe_mkdir "${WORK_UNIT_DIR}/artifacts"
safe_mkdir "${WORK_UNIT_DIR}/tests"

# Example 3: Temporary directory
TEMP_DIR="/tmp/claude_code_$$"
safe_mkdir "$TEMP_DIR"
```

**Error Handling**:
```bash
# On failure, exits with:
ERROR: Failed to create directory: /path/to/directory
```

**Best Practices**:
- Use instead of `mkdir -p` for better error handling
- Always use for critical directory creation
- Combine with error_exit for custom handling:
  ```bash
  mkdir -p "$DIR" || error_exit "Custom error message"
  ```

---

### Tool Requirement Checks

#### `require_tool(toolname)`
Verify that required command-line tool is installed.

**Parameters**:
- `toolname` (string): Name of the command to check

**Exits**: Yes (if tool not found)

**Usage**:
```bash
# Example 1: JSON processing
require_tool "jq"
# Now safe to use jq commands

# Example 2: Git operations
require_tool "git"
git status

# Example 3: Multiple tools
require_tool "jq"
require_tool "git"
require_tool "gh"
# All tools verified before proceeding

# Example 4: Conditional requirement
if [[ "$ADVANCED_MODE" = "true" ]]; then
    require_tool "ripgrep"
fi
```

**Error Message**:
```
ERROR: jq is required but not installed
```

**Best Practices**:
- Call at beginning of command (before using tool)
- Check all required tools upfront
- For optional tools, use `warn()` instead:
  ```bash
  if ! command -v jq >/dev/null 2>&1; then
      warn "jq not installed - using basic parsing"
  fi
  ```

---

## Usage in Commands

### Automatic Injection

Commands use the `<!-- INJECT_UTILITIES -->` marker:

```markdown
---
name: mycommand
description: My command description
---

# My Command

## Implementation

```bash
#!/bin/bash

<!-- INJECT_UTILITIES -->

# Command-specific code starts here
echo "Command logic..."
```
\`\`\`

### Build Process

When `scripts/build.sh` runs:
1. Reads `src/utils/common.sh` (this file)
2. Finds all commands with `<!-- INJECT_UTILITIES -->` marker
3. Replaces marker with utility content
4. Generates self-contained commands in `plugins/*/commands/`

### After Build

Command contains injected utilities:

```bash
#!/bin/bash

# Claude Code Common Utilities
# Version: 1.0.0
# [Full utilities content injected here]

readonly CLAUDE_DIR=".claude"
# ... [all utilities]

# End of injected utilities

# Command-specific code starts here
echo "Command logic..."
```

---

## Development Workflow

### Modifying Utilities

1. **Edit**: Modify `src/utils/common.sh`
   ```bash
   vim src/utils/common.sh
   ```

2. **Build**: Inject into all commands
   ```bash
   scripts/build.sh
   ```

3. **Test**: Validate all commands work
   ```bash
   scripts/test-build.sh
   ```

4. **Commit**: Include both source and built files
   ```bash
   git add src/utils/common.sh plugins/*/commands/*.md
   git commit -m "fix: Update error_exit to handle edge case"
   ```

### Adding New Utilities

1. **Add** to `src/utils/common.sh`:
   ```bash
   # New utility
   is_git_repo() {
       git rev-parse --is-inside-work-tree >/dev/null 2>&1
   }
   ```

2. **Document** in this README

3. **Build** and test:
   ```bash
   scripts/build.sh
   scripts/test-build.sh
   ```

4. **Update version** if needed (MINOR bump for new utilities)

---

## Versioning

### Semantic Versioning

- **MAJOR** (X.0.0): Breaking changes to utility signatures
- **MINOR** (1.X.0): New utilities added, backward compatible
- **PATCH** (1.0.X): Bug fixes, no new functionality

### Current Version

**1.0.0** (Initial release)

### Changelog

#### 1.0.0 (2025-10-18)
- Initial canonical utilities extraction
- 5 constants: CLAUDE_DIR, WORK_DIR, WORK_CURRENT, MEMORY_DIR, TRANSITIONS_DIR
- 3 error functions: error_exit(), warn(), debug()
- 1 file system utility: safe_mkdir()
- 1 tool check: require_tool()

---

## Testing

### Manual Testing

```bash
# Source utilities
source src/utils/common.sh

# Test error_exit
error_exit "Test error"  # Should print and exit

# Test warn
warn "Test warning"      # Should print, no exit

# Test debug
DEBUG=true debug "Test debug"  # Should print
DEBUG=false debug "Test debug" # Should not print

# Test safe_mkdir
safe_mkdir "/tmp/test_$$"      # Should create directory

# Test require_tool
require_tool "bash"            # Should succeed
require_tool "nonexistent"     # Should fail
```

### Automated Testing

See `scripts/test-build.sh` for comprehensive test suite covering:
- Syntax validation
- Injection verification
- Self-containment checks
- Cross-platform compatibility

---

## Best Practices

### For Utility Developers

1. **Single Responsibility**: Each utility does one thing well
2. **Clear Documentation**: Every function has usage examples
3. **Error Handling**: Utilities fail fast with clear messages
4. **Portability**: Use POSIX-compatible shell constructs
5. **No Side Effects**: Utilities don't modify global state (except readonly constants)

### For Command Developers

1. **Don't Modify**: Never edit utilities in individual commands
2. **Use Liberally**: These utilities exist to simplify command code
3. **Report Issues**: If utility doesn't fit your need, propose enhancement
4. **Add Tests**: Test commands work with injected utilities

---

## Migration Notes

### Pre-Build System (Before 1.0.0)

- Each command had duplicated utilities (~44 lines × 30 commands)
- Bug fixes required manual patching in every file
- Utilities could drift and become inconsistent

### Post-Build System (1.0.0+)

- Single source of truth: `src/utils/common.sh`
- Bug fixes: Edit once, rebuild, done
- Guaranteed consistency across all commands
- Self-contained at runtime (no behavioral changes)

---

## Future Enhancements

### Potential v2.0 Features

1. **Modular Utilities**: Split into categories
   - `src/utils/errors.sh` - Error handling
   - `src/utils/git.sh` - Git helpers
   - `src/utils/work.sh` - Work unit helpers
   - `src/utils/memory.sh` - Memory helpers

2. **Selective Injection**: Commands specify which utilities needed
   ```markdown
   <!-- INJECT_UTILITIES: errors,work -->
   ```

3. **Utility Versioning**: Track per-command utility versions
   ```bash
   # Injected utilities version: 1.2.0
   ```

### Not Planned

- ❌ Runtime loading (violates self-containment constraint)
- ❌ Dynamic sourcing (execution context prevents this)
- ❌ Shared library approach (Claude Code limitation)

---

## References

- **Architecture**: `docs/development/build-system.md`
- **Build Script**: `scripts/build.sh`
- **Test Script**: `scripts/test-build.sh`
- **Work Unit**: 009_review_feedback_iteration (TASK-002)

---

## Support

If you encounter issues with utilities:

1. **Check Version**: Ensure using latest `src/utils/common.sh`
2. **Rebuild**: Run `scripts/build.sh` to update all commands
3. **Test**: Run `scripts/test-build.sh` for validation
4. **Report**: Create issue with utility name and error details

---

**Maintained by**: Claude Code Framework Team
**Last Updated**: 2025-10-18
**Version**: 1.0.0
