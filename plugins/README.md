# Core Plugins

This directory contains the 5 core plugins that provide the foundation of the Claude Code Plugins framework.

## Available Plugins

### core
**30+ system commands** for essential functionality:
- status, work, config, cleanup
- index, handoff, setup, audit
- docs, agent, performance, serena, spike

### workflow
**4 development workflow commands**:
- `explore` - Analyze requirements and create work breakdown
- `plan` - Create detailed implementation plan
- `next` - Execute next available task
- `ship` - Deliver completed work with validation

### development
**8 code quality commands**:
- `analyze` - Deep codebase analysis
- `test` - Test-driven development
- `fix` - Universal debugging and fixes
- `run` - Execute scripts with monitoring
- `review` - Code review and quality analysis
- `report` - Generate stakeholder reports
- `experiment` - Run ML experiments
- `evaluate` - Compare experiments

### git
**1 unified git command**:
- `git` - Commits, pull requests, issue management

### memory
**3 context management commands**:
- `memory-review` - Display current memory state
- `memory-update` - Interactive memory maintenance
- `memory-gc` - Garbage collection for stale entries

## Installation

These plugins will be synced from the private development repository.

🚧 **Status**: Plugins will be added during the public launch preparation phase.

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

## What's Next?

- [Plugin Creation Guide](../docs/guides/plugin-creation.md)
- [Commands Reference](../docs/reference/commands.md)
