# Developer Guide

Complete guide for contributing to Claude Code Plugins.

## Table of Contents

- [Plugin Architecture](#plugin-architecture)
- [Adding Commands](#adding-commands)
- [Creating Plugins](#creating-plugins)
- [Testing](#testing)
- [Best Practices](#best-practices)

---

## Plugin Architecture

### Plugin Organization (v1.0.0+)

Claude Code Plugins uses a **focused plugin architecture** with 6 core plugins:

| Plugin | Purpose | Commands | Dependencies |
|--------|---------|----------|--------------|
| **system** | System configuration and health | 4 (status, setup, audit, cleanup) | None |
| **workflow** | Development workflow | 6 (explore, plan, next, ship, work, spike) | memory, system |
| **development** | Code quality tools | 6 (analyze, test, fix, run, review, docs) | system |
| **agents** | Agent invocation | 2 (agent, serena) | None |
| **memory** | Knowledge and context | 6 (memory-*, index, handoff, performance) | None |
| **git** | Version control | 1 (git) | None |

**Design Principles**:
- ✅ **Single Responsibility**: Each plugin has clear, focused purpose
- ✅ **Meaningful Names**: Plugin names describe what they do
- ✅ **Minimal Dependencies**: Plugins depend only on what they need
- ✅ **Graceful Degradation**: MCP tools optional, fallbacks always work

### Plugin Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Required manifest
├── commands/                # Slash commands (optional)
│   ├── command-one.md
│   └── command-two.md
├── agents/                  # Specialized agents (optional)
│   ├── agent-one.md
│   └── agent-two.md
└── README.md               # Plugin documentation
```

### Plugin Manifest (plugin.json)

**Required fields**:
```json
{
  "name": "claude-code-your-plugin",
  "version": "1.0.0",
  "description": "Clear, concise plugin description",
  "capabilities": {
    "capabilityName": {
      "description": "What this capability does",
      "command": "command-name"
    }
  }
}
```

**Optional fields**:
```json
{
  "dependencies": {
    "claude-code-system": "^1.0.0"
  },
  "mcpTools": {
    "optional": ["serena", "sequential-thinking"],
    "gracefulDegradation": true
  },
  "keywords": ["workflow", "development"],
  "author": "Your Name",
  "license": "MIT"
}
```

---

## Adding Commands

### Step 1: Choose the Right Plugin

Ask yourself:

- **System operations?** → `system` plugin (configuration, health checks)
- **Workflow orchestration?** → `workflow` plugin (task management, delivery)
- **Code quality?** → `development` plugin (analysis, testing, review)
- **Agent invocation?** → `agents` plugin (specialized agents)
- **Memory/context?** → `memory` plugin (knowledge persistence)
- **Git operations?** → `git` plugin (version control)

**If unsure**, open an issue for discussion before starting.

### Step 2: Create Command File

```bash
# Create command in appropriate plugin
touch plugins/workflow/commands/my-command.md
```

### Step 3: Command Structure

**Template**:
```markdown
---
name: my-command
description: Brief description of what this command does
---

# My Command Implementation

#!/bin/bash
set -euo pipefail

# === REQUIRED UTILITIES (copy inline) ===
# See src/utils/README.md and WHY_DUPLICATION_EXISTS.md

# Constants
readonly CLAUDE_DIR="${CLAUDE_DIR:-.claude}"
readonly WORK_DIR="$CLAUDE_DIR/work"
readonly WORK_CURRENT="$WORK_DIR/current"
readonly MEMORY_DIR="$CLAUDE_DIR/memory"
readonly TRANSITIONS_DIR="$CLAUDE_DIR/transitions"

# Error handling
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo "DEBUG: $1" >&2
    fi
}

# File system utilities
safe_mkdir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
    fi
}

# Tool requirement checking
require_tool() {
    local tool="$1"
    local install_hint="${2:-}"

    if ! command -v "$tool" &> /dev/null; then
        if [[ -n "$install_hint" ]]; then
            error_exit "$tool is required. Install: $install_hint"
        else
            error_exit "$tool is required but not found"
        fi
    fi
}

# === COMMAND LOGIC ===

# Your implementation here
echo "My command is working!"
```

**Why inline utilities?** See `src/utils/WHY_DUPLICATION_EXISTS.md` - commands execute in project directory, not in `.claude/commands/`, so external script sourcing doesn't work.

### Step 4: Update Plugin Manifest

Add capability to `plugin.json`:

```json
{
  "capabilities": {
    "myCapability": {
      "description": "Clear description of what this does",
      "command": "my-command"
    }
  }
}
```

### Step 5: Update Plugin README

Add to command reference section:

```markdown
### `/my-command [args]`
Brief description of what this command does.

**What it does**:
- Action 1
- Action 2
- Action 3

**Usage**:
\```bash
/my-command                  # Basic usage
/my-command --option value   # With options
\```

**When to use**:
- ✅ Use case 1
- ✅ Use case 2
- ❌ Don't use for...
```

### Step 6: Test

See [Testing](#testing) section below.

---

## Creating Plugins

### When to Create a New Plugin

Create a new plugin when:

✅ **New focused capability area** not covered by existing plugins
✅ **3+ related commands** that work together
✅ **Clear domain boundary** separating it from other plugins
✅ **Reusable across projects** (not project-specific)

**Don't create** when:

❌ Adding to existing plugin makes more sense
❌ Only 1-2 commands
❌ Domain-specific (consider separate plugin marketplace)
❌ Experimental/unproven concept

### Plugin Creation Process

**1. Propose via issue**:
```markdown
**Plugin Name**: claude-code-your-plugin
**Purpose**: One-sentence description
**Commands**: List of 3-5 proposed commands
**Why new plugin**: Explain why not adding to existing plugin
**Dependencies**: List any required plugins
```

**2. Wait for approval** before development

**3. Create plugin structure**:
```bash
mkdir -p plugins/your-plugin/{.claude-plugin,commands,agents}
```

**4. Create plugin.json**:
```json
{
  "name": "claude-code-your-plugin",
  "version": "1.0.0",
  "description": "Clear, focused description",
  "author": "Your Name",
  "keywords": ["relevant", "keywords"],
  "commands": ["commands/*.md"],
  "settings": {
    "defaultEnabled": true,
    "category": "tools"
  },
  "capabilities": {
    "capability1": {
      "description": "What this does",
      "command": "command-name"
    }
  },
  "dependencies": {
    "claude-code-system": "^1.0.0"
  },
  "mcpTools": {
    "optional": [],
    "gracefulDegradation": true
  },
  "license": "MIT"
}
```

**5. Create commands** (see [Adding Commands](#adding-commands))

**6. Create README.md**:
```markdown
# Your Plugin

Brief plugin description.

## Overview

What problem this plugin solves.

## Commands

### /command-one
Description and usage

### /command-two
Description and usage

## Configuration

Optional configuration details.

## Integration with Other Plugins

How this integrates with system, workflow, etc.

## Dependencies

- **claude-code-system** (^1.0.0): Why needed
```

**7. Test thoroughly** (see [Testing](#testing))

**8. Submit PR** with:
- Plugin code
- Documentation
- Test results
- Migration notes (if deprecating old commands)

---

## Testing

### Manual Testing (Current Approach)

**Setup test project**:
```bash
mkdir ~/test-claude-code-plugins
cd ~/test-claude-code-plugins
git init
```

**Configure to use your fork**:
```json
// .claude/settings.json
{
  "extraKnownMarketplaces": {
    "local-dev": {
      "source": {
        "source": "directory",
        "path": "/path/to/your/fork"
      }
    }
  },
  "enabledPlugins": {
    "system@local-dev": true,
    "workflow@local-dev": true,
    "your-plugin@local-dev": true
  }
}
```

**Test checklist**:

- [ ] **Command validation**:
  ```bash
  # Test each command with typical inputs
  /my-command basic-input
  /my-command --with-options value
  ```

- [ ] **Error handling**:
  ```bash
  # Test with invalid inputs
  /my-command invalid-arg
  /my-command # missing required arg
  ```

- [ ] **Integration testing**:
  ```bash
  # Test with dependent plugins
  /workflow-command  # Uses your plugin
  /my-command        # Uses system plugin
  ```

- [ ] **State management** (if applicable):
  ```bash
  # Verify state files created correctly
  ls -la .claude/work/current/
  cat .claude/work/current/*/state.json
  ```

- [ ] **Backwards compatibility**:
  ```bash
  # Test with existing work units
  /next  # Should work with old work units
  ```

- [ ] **MCP graceful degradation** (if using MCP):
  ```bash
  # Disable MCP, verify fallback works
  # (temporarily rename .mcp.json)
  /my-command  # Should still work
  ```

### Testing Matrix

**Core plugins** (system, workflow, development, agents, memory, git):
- Test in isolation
- Test all cross-plugin integrations
- Test with/without MCP tools
- Test backwards compatibility

**New plugins**:
- Test all commands individually
- Test integration with dependencies
- Test in 2-3 different projects
- Document any edge cases or limitations

### Validation Script

Quick validation of plugin.json files:

```bash
# Validate all plugin manifests
for plugin in plugins/*/. claude-plugin/plugin.json; do
    echo "Validating $plugin..."
    jq empty "$plugin" 2>&1 || echo "INVALID JSON: $plugin"
done

# Check for required fields
jq -r '.name, .version, .description' plugin.json

# Validate capabilities match commands
diff <(jq -r '.capabilities[].command' plugin.json | sort) \
     <(ls commands/*.md | xargs -n1 basename -s .md | sort)
```

---

## Best Practices

### Command Design

**Do**:
- ✅ **Single responsibility**: One clear purpose per command
- ✅ **Descriptive names**: `/analyze` not `/a`, `/test` not `/t`
- ✅ **Inline utilities**: Copy required functions (see WHY_DUPLICATION_EXISTS.md)
- ✅ **Error handling**: Use error_exit(), warn(), debug()
- ✅ **User feedback**: Echo what's happening
- ✅ **Idempotent**: Safe to run multiple times

**Don't**:
- ❌ **External dependencies**: No sourcing external scripts
- ❌ **Hardcoded paths**: Use $CLAUDE_DIR, $PWD
- ❌ **Silent failures**: Always report errors
- ❌ **Complex logic**: Keep commands focused and simple
- ❌ **Persistent state**: Use file-based state, not process state

### Plugin Design

**Do**:
- ✅ **Focused scope**: Clear, single responsibility
- ✅ **Meaningful names**: Describe what the plugin does
- ✅ **Minimal dependencies**: Only depend on what you need
- ✅ **Graceful degradation**: Work without optional MCP tools
- ✅ **Clear documentation**: README with examples

**Don't**:
- ❌ **Kitchen sink**: Don't cram unrelated commands together
- ❌ **Generic names**: Avoid "core", "utils", "misc"
- ❌ **Tight coupling**: Minimize cross-plugin dependencies
- ❌ **MCP required**: Always provide fallbacks

### Code Style

**Bash Commands**:
```bash
#!/bin/bash
set -euo pipefail  # Fail fast, undefined vars error, pipefail

# Constants in SCREAMING_SNAKE_CASE
readonly MY_CONSTANT="value"

# Functions in snake_case
my_function() {
    local param="$1"
    echo "Result: $param"
}

# Always quote variables
echo "$MY_VAR"  # Not: echo $MY_VAR

# Use [[ ]] for conditionals (not [ ])
if [[ -f "$file" ]]; then
    echo "File exists"
fi
```

**Markdown Documentation**:
- Clear headers (## for main sections, ### for subsections)
- Code blocks with language hints (```bash, ```json, ```markdown)
- Examples for every command
- Usage patterns (✅ Do, ❌ Don't)

### Documentation

**Command README sections**:
1. Brief description (1 sentence)
2. What it does (bullet points)
3. Usage examples (code blocks)
4. When to use (✅/❌ patterns)
5. Configuration (if applicable)
6. Integration (cross-plugin usage)

**Plugin README sections**:
1. Overview (what problem it solves)
2. Commands (complete reference)
3. Agents (if any)
4. Configuration
5. Dependencies
6. MCP Tools (if using)
7. Examples

### Version Management

**Semantic Versioning** (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes (plugin reorganization, API changes)
- **MINOR**: New features (new commands, capabilities)
- **PATCH**: Bug fixes, documentation updates

**Plugin Compatibility**:
```json
"dependencies": {
  "claude-code-system": "^1.0.0"  // Compatible with 1.x.x
}
```

### Commit Messages

**Conventional Commits**:
```
feat(workflow): add spike command for time-boxed exploration

- Isolated branch creation
- Time-limited investigation
- Automatic cleanup option

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code restructuring (no behavior change)
- `test`: Adding/updating tests
- `chore`: Maintenance

**Scope**: Plugin name (workflow, development, system, etc.)

---

## Migration Guide for Contributors

### v0.9.x → v1.0.0 Changes

**Plugin reorganization**:
- **Removed**: `core` plugin (bloated, 14 mixed commands)
- **Added**: `system` and `agents` plugins (focused)
- **Updated**: `workflow`, `development`, `memory` plugins (expanded)

**Command migrations**:
| Command | Old Plugin | New Plugin |
|---------|-----------|-----------|
| `/status`, `/setup`, `/audit`, `/cleanup` | core | system |
| `/agent`, `/serena` | core | agents |
| `/work`, `/spike` | core | workflow |
| `/index`, `/handoff`, `/performance` | core | memory |
| `/docs` | core | development |

**Dependency changes**:
- Use `claude-code-system` for system dependencies in plugin.json

**For complete migration details**, see [MIGRATION.md](../../MIGRATION.md).

---

## Resources

### Internal Documentation
- [src/utils/README.md](../../src/utils/README.md) - Utility functions reference
- [src/utils/WHY_DUPLICATION_EXISTS.md](../../src/utils/WHY_DUPLICATION_EXISTS.md) - Duplication rationale
- [MIGRATION.md](../../MIGRATION.md) - v1.0.0 migration guide
- [CHANGELOG.md](../../CHANGELOG.md) - Version history

### Plugin Examples
- `plugins/system/` - System configuration plugin
- `plugins/workflow/` - Development workflow plugin
- `plugins/development/` - Code quality plugin

### Getting Help
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions and general discussion
- **CONTRIBUTING.md**: General contribution guidelines

---

**Version**: 1.0.0
**Last Updated**: 2025-10-18
**Status**: ✅ Production Ready
