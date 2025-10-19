# Core Plugins

This directory contains the 6 core plugins that provide the foundation of the Claude Code Plugins framework.

## Available Plugins

### system
**System configuration and health** (5 commands):
- `status` - Unified view of work, system, and memory state
- `setup` - Initialize Claude Code in new projects
- `audit` - Framework compliance validation
- `cleanup` - Clean up generated files and temporary data
- `config` - Manage configuration settings

### agents
**Agent invocation** (2 commands):
- `agent` - Direct invocation of specialized agents
- `serena` - Activate and manage Serena semantic code understanding

### workflow
**Development workflow** (6 commands):
- `explore` - Analyze requirements and create work breakdown
- `plan` - Create detailed implementation plan
- `next` - Execute next available task
- `ship` - Deliver completed work with validation
- `work` - Manage work units and parallel streams
- `spike` - Time-boxed exploration in isolated branch

### development
**Code quality** (6 commands):
- `analyze` - Deep codebase analysis
- `test` - Test-driven development
- `fix` - Universal debugging and fixes
- `run` - Execute scripts with monitoring
- `review` - Code review and quality analysis
- `docs` - Fetch, search, and generate documentation

### git
**Version control** (1 command):
- `git` - Unified git operations (commit, PR, issue management)

### memory
**Context and knowledge management** (6 commands):
- `memory-review` - Display current memory state
- `memory-update` - Interactive memory maintenance
- `memory-gc` - Garbage collection for stale entries
- `index` - Create and maintain persistent project understanding
- `handoff` - Create transition documents with context analysis
- `performance` - View token usage and performance metrics

## Total Commands
**26 commands** across 6 focused plugins, providing comprehensive support for AI-assisted development workflows.

## Plugin Structure

Each plugin follows the official Claude Code plugin structure:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json        # Required manifest
├── commands/              # Slash commands
│   └── *.md
├── agents/                # Specialized agents (optional)
│   └── *.md
└── README.md              # Plugin documentation
```

## Installation

Install all plugins:
```bash
./scripts/install.sh
```

Or enable specific plugins in `.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "system@aai-plugins": true,
    "workflow@aai-plugins": true,
    "development@aai-plugins": true
  }
}
```

## What's Next?

- [Plugin Creation Guide](../docs/guides/plugin-creation.md)
- [Commands Reference](../docs/reference/commands.md)
- [Developer Guide](../docs/development/DEVELOPER_GUIDE.md)
