# Core Plugin

Essential system functionality and framework commands for Claude Code.

## Overview

The Core plugin provides fundamental commands for project management, system monitoring, and framework operations. These commands form the foundation of the Claude Code plugin ecosystem and are required for most workflows.

## Features

- **Project Management**: Track work units, manage tasks, and organize parallel workflows
- **System Monitoring**: View status, performance metrics, and token usage
- **Framework Operations**: Setup, configuration, cleanup, and audit capabilities
- **Session Management**: Create handoffs and maintain project context
- **Documentation**: Fetch, search, and generate project documentation

## Commands

### `/status [verbose]`
Display unified view of work, system, and memory state. Shows current tasks, project status, and system health.

**Usage**:
```bash
/status           # Quick status overview
/status verbose   # Detailed status with metrics
```

### `/work [subcommand] [args]`
Manage work units and parallel streams. Create, list, continue, checkpoint, and switch between work contexts.

**Usage**:
```bash
/work                    # List all work units
/work active             # Show active work units
/work continue [ID]      # Continue specific work unit
/work checkpoint         # Save current work state
/work switch [ID]        # Switch to different work unit
```

### `/agent <agent-name> "<task>"`
Direct invocation of specialized agents with explicit context. Provides access to expert capabilities on demand.

**Usage**:
```bash
/agent architect "Design authentication system"
/agent code-reviewer "Review security in auth module"
/agent auditor "Check framework compliance"
```

### `/cleanup [--dry-run | --auto | root | tests | reports | work | all]`
Clean up Claude-generated clutter and consolidate documentation. Remove temporary files and organize project structure.

**Usage**:
```bash
/cleanup --dry-run       # Preview what would be cleaned
/cleanup root            # Clean root directory only
/cleanup all             # Clean everything
/cleanup --auto          # Auto-clean with safe defaults
```

### `/index [--update] [--refresh] [focus_area]`
Create and maintain persistent project understanding through comprehensive mapping. Build searchable index of codebase.

**Usage**:
```bash
/index                   # Create initial index
/index --update          # Update existing index
/index --refresh         # Rebuild from scratch
/index src/auth          # Index specific area
```

### `/performance`
View token usage and performance metrics. Monitor efficiency, context usage, and optimization opportunities.

**Usage**:
```bash
/performance             # Show performance dashboard
```

### `/handoff`
Create transition documents with context analysis. Generate comprehensive handoff for session continuity.

**Usage**:
```bash
/handoff                 # Create handoff document
```

### `/docs [fetch|search|generate] [arguments]`
Unified documentation operations - fetch external docs, search all documentation, and generate project docs.

**Usage**:
```bash
/docs search "authentication"       # Search documentation
/docs fetch react                   # Fetch external library docs
/docs generate                      # Generate project documentation
```

### `/setup [explore|existing|python|javascript] [project-name] [--minimal|--standard|--full]`
Initialize new projects with Claude framework integration or setup user configuration.

**Usage**:
```bash
/setup explore                      # Interactive project discovery
/setup python my-api --standard     # Python project with standard config
/setup existing                     # Add Claude framework to existing project
/setup --init-user                  # Setup user-level configuration
```

### `/audit [--framework | --tools | --fix]`
Framework setup and infrastructure compliance audit. Verify correct installation and configuration.

**Usage**:
```bash
/audit                   # Full audit
/audit --framework       # Check framework compliance
/audit --tools           # Check tool availability
/audit --fix             # Auto-fix issues
```

### `/serena`
Activate and manage Serena semantic code understanding for projects. Enable powerful semantic search and code navigation.

**Usage**:
```bash
/serena                  # Activate Serena for current project
```

### `/spike`
Time-boxed exploration in isolated branch. Quick experimentation without affecting main work.

**Usage**:
```bash
/spike                   # Start spike exploration
```

## Agents

### Auditor (`auditor.md`)
Framework compliance and infrastructure validation specialist. Performs comprehensive audits of:
- Claude Code framework setup
- Configuration correctness
- File structure compliance
- Tool availability
- Best practice adherence

**Capabilities**:
- Automated compliance checking
- Configuration validation
- Setup verification
- Issue detection and reporting

### Reasoning Specialist (`reasoning-specialist.md`)
Structured problem-solving and decision analysis expert. Provides:
- Sequential thinking for complex problems
- Decision framework analysis
- Multi-criteria evaluation
- Trade-off analysis

**Capabilities**:
- Complex problem decomposition
- Systematic reasoning
- Decision documentation
- Alternative evaluation

## Installation

This plugin is included by default in Claude Code and is marked as **required**. It is automatically enabled when you install the plugin marketplace.

To manually enable:

1. Add to your `.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "claude-code-core@your-marketplace": true
  }
}
```

2. Restart Claude Code or reload settings

## Configuration

The Core plugin works out of the box with sensible defaults. Optional configuration:

**Work Directory** (`.claude/work/`):
- Customize work unit organization
- Set default work patterns
- Configure archival rules

**Performance Thresholds** (`.claude/config.json`):
```json
{
  "performance": {
    "tokenWarningThreshold": 0.8,
    "tokenCriticalThreshold": 0.9,
    "autoOptimize": false
  }
}
```

**Cleanup Patterns** (`.claude/cleanup-rules.json`):
```json
{
  "excludePatterns": ["*.important.md"],
  "consolidationTargets": ["docs/", "notes/"]
}
```

## Dependencies

### Required
- Claude Code v3.0+ (platform)

### Optional MCP Tools
- **Sequential Thinking**: Enhances reasoning-specialist agent (built-in to Claude Code)
- **Serena**: Enables semantic code understanding (/serena command)

**Graceful Degradation**: All commands work without MCP tools, but may be less efficient.

## Usage Examples

### Complete Workflow
```bash
# 1. Check status
/status

# 2. Create new work unit
/work create "Add user authentication"

# 3. Setup project structure
/setup python auth-service --standard

# 4. Monitor performance
/performance

# 5. Run framework audit
/audit

# 6. Create handoff when done
/handoff
```

### Project Initialization
```bash
# Interactive discovery
/setup explore

# Quick Python setup
/setup python my-api --minimal

# Add to existing project
cd existing-project
/setup existing
```

### Work Management
```bash
# List work
/work active

# Start work unit
/work continue 001

# Save checkpoint
/work checkpoint

# Switch work
/work switch 002
```

## Best Practices

1. **Use /status regularly**: Check project state before starting work
2. **Create handoffs at boundaries**: Preserve context between sessions
3. **Monitor /performance**: Optimize when context >80%
4. **Audit after setup**: Verify framework compliance with /audit
5. **Clean periodically**: Run /cleanup to maintain organized project

## Troubleshooting

### Commands not found
Run `/audit --framework` to verify plugin installation.

### Performance degradation
1. Check `/performance` for context usage
2. Run `/handoff` to preserve context
3. Use `/cleanup` to remove clutter

### Work units not tracking
1. Verify `.claude/work/` directory exists
2. Run `/audit --fix` to repair structure
3. Check `metadata.json` in work unit directory

## Related Plugins

- **workflow**: Task workflow commands (/explore, /plan, /next, /ship)
- **development**: Development tools (/analyze, /review, /test, /fix, /run)
- **git**: Git operations (/git commit, /git pr, /git issue)
- **memory**: Memory management (/memory-review, /memory-gc)

## Support

- **Documentation**: [Getting Started Guide](../../docs/getting-started/)
- **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

## License

MIT License - see [LICENSE](../../LICENSE) for details.

---

**Version**: 1.0.0
**Category**: Core
**Required**: Yes
**MCP Tools**: Optional (sequential-thinking, serena)
