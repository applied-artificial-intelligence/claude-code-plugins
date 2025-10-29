# Claude Code Plugins

**Structured workflow framework and plugin system for Claude Code**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-2.0%2B-blue)](https://docs.claude.com/claude-code)

---

## Overview

Claude Code Plugins extends Anthropic's Claude Code with structured development workflows, work management, and quality automation. The framework provides 25 commands, 3 agents, 3 AI/ML skills, and 2 proactive hooks across 5 core plugins.

### Design Goals

1. **Stateless architecture** - Commands execute independently, state persisted in files
2. **File-based persistence** - JSON and Markdown for all state management
3. **MCP integration** - Optional Model Context Protocol tools with graceful degradation
4. **Progressive disclosure** - Load context incrementally to optimize token usage
5. **Self-containment** - All logic inline, no external script dependencies

### Key Capabilities

- **Workflow management**: `explore` → `plan` → `next` → `ship` pattern
- **Memory persistence**: Cross-session context with automatic reflection
- **Quality automation**: Git safety, pre/post hooks, compliance auditing
- **Code intelligence**: Semantic code understanding (Serena MCP), 70-90% token reduction
- **Domain expertise**: AI/ML skills (RAG, Transformers, LLM Evaluation)

---

## Architecture

### Component Structure

```
claude-code-plugins/
├── plugins/                # Core plugin system
│   ├── system/            # System configuration (4 commands)
│   ├── workflow/          # Development workflow (6 commands)
│   ├── development/       # Code operations (6 commands)
│   ├── agents/            # Agent invocation (2 commands)
│   └── memory/            # Context management (7 commands)
├── skills/                # AI/ML domain skills (3 skills)
│   ├── rag-implementation/
│   ├── huggingface-transformers/
│   └── llm-evaluation/
├── hooks/                 # Proactive monitoring (2 hooks)
│   ├── ai-cost-guard.sh
│   └── gpu-memory-guard.sh
└── docs/                  # Documentation
    ├── mcp-setup.md       # MCP server integration guide
    └── [additional docs]
```

### Stateless Execution Model

All commands are **stateless markdown files** that execute in the project directory:

- No persistent processes or background services
- All state stored in `.claude/` directory (JSON/Markdown)
- Git serves as the state machine for work tracking
- Commands can be interrupted and resumed safely

**File-Based State Management**:
```
.claude/
├── work/
│   └── current/
│       └── [work-unit]/
│           ├── state.json              # Task tracking
│           ├── exploration.md          # Analysis
│           └── implementation-plan.md  # Task breakdown
├── memory/
│   ├── project-context.md              # Project knowledge
│   └── lessons-learned.md              # Accumulated insights
└── settings.json                       # Configuration
```

### MCP Integration Architecture

**Graceful Degradation Philosophy**: All functionality works without MCP, enhanced when available.

**Supported MCP Servers** (see [docs/mcp-setup.md](docs/mcp-setup.md)):

| MCP Server | Impact | Token Change | Status |
|------------|--------|--------------|--------|
| Sequential Thinking | Structured reasoning | +15-30% | Built-in (no setup) |
| Serena | Semantic code understanding | -70-90% | Optional (per-project) |
| Context7 | Documentation access | -50% | Optional (API key) |
| Chrome DevTools | Browser automation | Varies | Optional |
| FireCrawl | Web research | -40% | Optional (API key) |

**Commands auto-detect MCP availability** and fall back to standard operations when unavailable.

---

## Installation

### Prerequisites

- **Claude Code 2.0+** ([installation](https://claude.com/install))
- **Git 2.0+**
- **jq** (JSON processing)
- **Node.js v20+ or v22+** (for MCP servers, optional)

### Quick Install

```bash
# Clone repository
git clone https://github.com/[your-org]/claude-code-plugins.git
cd claude-code-plugins

# Install plugins to Claude Code
./scripts/install.sh

# Verify installation
claude
# Then type: /system:status
```

### Manual Configuration

Add to project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "local": {
      "source": {
        "source": "directory",
        "path": "/path/to/claude-code-plugins/plugins"
      }
    }
  },
  "enabledPlugins": {
    "system@local": true,
    "workflow@local": true,
    "development@local": true,
    "agents@local": true,
    "memory@local": true
  }
}
```

### MCP Setup (Optional)

For enhanced functionality, install MCP servers:

```bash
# Install Serena (semantic code understanding)
npm install -g @context7/serena-mcp

# Install Context7 (documentation access)
npm install -g @context7/context7-mcp

# Install Chrome DevTools (browser automation)
npm install -g @modelcontextprotocol/server-puppeteer

# Install FireCrawl (web research)
npm install -g @firecrawl/mcp-server
```

See [docs/mcp-setup.md](docs/mcp-setup.md) for complete MCP integration guide.

---

## Usage

### Basic Workflow Pattern

The framework follows an `explore` → `plan` → `next` → `ship` pattern:

```bash
# 1. Explore requirements and codebase
/workflow:explore "add user authentication with JWT"

# Creates work unit in .claude/work/current/
# Analyzes requirements, identifies files to modify
# Documents dependencies and integration points

# 2. Create implementation plan
/workflow:plan

# Generates task breakdown with dependencies
# Stores in state.json for execution tracking

# 3. Execute tasks sequentially
/workflow:next

# Selects next available task (dependency-aware)
# Executes task with quality checks
# Auto-commits changes with descriptive message

# Repeat /next until all tasks complete

# 4. Deliver completed work
/workflow:ship

# Validates quality gates
# Creates pull request (if configured)
# Archives work unit
```

### Command Reference

**System Commands**:
- `/system:setup` - Project initialization (auto-detects Python/JavaScript)
- `/system:status` - Project and system health check
- `/system:audit` - Framework compliance validation
- `/system:cleanup` - Remove generated clutter

**Workflow Commands**:
- `/workflow:explore` - Analyze requirements and create work breakdown
- `/workflow:plan` - Generate implementation plan with dependencies
- `/workflow:next` - Execute next available task
- `/workflow:ship` - Deliver completed work
- `/workflow:work` - Manage work units and parallel streams
- `/workflow:spike` - Time-boxed exploration in isolated branch

**Development Commands**:
- `/development:analyze` - Deep codebase analysis
- `/development:review` - Code quality and security review
- `/development:test` - Test creation and TDD workflow
- `/development:fix` - Automated debugging and fixes
- `/development:git` - Git operations (commit, PR, issues)
- `/development:docs` - Documentation operations

**Agent Commands**:
- `/agents:agent <name> "task"` - Invoke specialized agent
- `/agents:serena` - Activate Serena semantic code understanding

**Memory Commands**:
- `/memory:index` - Create persistent project understanding
- `/memory:memory-review` - Display current memory state
- `/memory:memory-gc` - Garbage collect stale entries
- `/memory:performance` - View token usage and metrics

### Specialized Agents

**Available Agents**:
- `architect` - System design and architectural decisions
- `test-engineer` - Test creation and coverage analysis
- `code-reviewer` - Code quality and security audit

**Usage**:
```bash
# Invoke architect agent for design decisions
/agents:agent architect "Design authentication system architecture"

# Use test-engineer for TDD workflow
/development:test tdd

# Perform systematic code review
/development:review src/ --systematic
```

### AI/ML Skills

**Domain Expertise Skills**:
- `rag-implementation` - RAG architecture and implementation guidance
- `huggingface-transformers` - Transformer models and fine-tuning
- `llm-evaluation` - LLM evaluation metrics and frameworks

**Skills activate automatically** when questions match domain:

```bash
# RAG Implementation Skill activates
"What's the best vector database for RAG with <1M documents?"

# HuggingFace Transformers Skill activates
"How do I fine-tune BERT for text classification?"

# LLM Evaluation Skill activates
"What metrics should I use to evaluate my language model?"
```

### Proactive Hooks

**Automated Monitoring**:
- `ai-cost-guard.sh` - Alerts when AI API costs exceed thresholds
- `gpu-memory-guard.sh` - Prevents GPU OOM errors

**Hooks run automatically** during relevant operations, no manual invocation required.

---

## Screenshots

### Context Management: /handoff → /continue

Managing context across sessions to prevent quality degradation:

![Handoff and Continue Workflow](screenshots/01_handoff_continue.png)

**Key features**:
- Context analysis at 70% perceived usage (~85% actual)
- Active work state preservation
- Recent decisions and outstanding items
- Clean continuation after `/clear`

---

### Complete Workflow: /explore → /plan → /next

Systematic task execution from requirements to implementation:

![Workflow Sequence](screenshots/02_workflow_sequence.png)

**Key features**:
- Requirements analysis with `/explore`
- Task breakdown with `/plan`
- Incremental execution with `/next`
- Progress tracking and state management

---

### Code Analysis: /analyze and /review

Deep codebase understanding and quality checks:

![Code Analysis and Review](screenshots/03_analyze_review.png)

**Key features**:
- Structural analysis with pattern identification
- Test coverage metrics
- Code quality review with actionable recommendations
- Security and performance assessment

---

## Technical Details

### State Management

**Work Unit Structure**:
```json
{
  "work_unit_id": "003_auth_feature",
  "status": "implementing",
  "current_phase": "2",
  "phases": [
    {"id": "1", "name": "Analysis", "status": "completed"},
    {"id": "2", "name": "Implementation", "status": "in_progress"}
  ],
  "tasks": [
    {
      "id": "TASK-001",
      "title": "Create User model",
      "status": "completed",
      "dependencies": [],
      "actual_hours": 0.5
    }
  ]
}
```

**State persisted in** `.claude/work/current/[work-unit]/state.json`

### Token Optimization

**Progressive Disclosure Pattern**:
1. **Startup**: Load minimal metadata (~2KB)
2. **Task Analysis**: Load relevant commands/agents (~10KB)
3. **Execution**: Load detailed patterns only when needed (~5KB)

**Result**: 70%+ token savings vs. loading all documentation upfront.

**With Serena MCP**: Additional 70-90% reduction for code operations.

### Quality Gates

**Automatic Quality Checks**:
- **Pre-execution**: Dependency verification, environment checks
- **During execution**: API verification (via Serena), linting, tests
- **Post-execution**: Acceptance criteria validation, integration tests
- **Commit time**: Conventional commit format, attribution

### Git Safety

**Protected Operations**:
- No `git push --force` to main/master
- No `git commit --amend` of other developers' commits
- Pre-commit hook validation
- Automatic commit attribution

**Commit Format**:
```
feat: Complete TASK-XXX - Add JWT authentication

Implements JWT-based authentication with:
- Token generation and validation
- Refresh token support
- Role-based access control

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

---

## Configuration

### Project Settings

Configure in `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "system@local": true,
    "workflow@local": true,
    "development@local": true,
    "agents@local": true,
    "memory@local": true
  },
  "mcpServers": {
    "serena": {
      "command": "npx",
      "args": ["-y", "@context7/serena-mcp"]
    },
    "context7": {
      "command": "npx",
      "args": ["-y", "@context7/context7-mcp"],
      "env": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

### User Configuration

Global user settings in `~/.claude/CLAUDE.md`:

```markdown
# My Development Preferences

## Git Preferences
- Always use conventional commit format
- Include issue numbers in commit messages
- Create draft PRs for WIP features

## Testing Preferences
- Run tests before committing
- Maintain >80% code coverage
- Use pytest for Python, Jest for JavaScript
```

---

## Documentation

### Getting Started

- **[5-Minute Demo](demo.claw.md)** - Quick-start demonstration
- **[MCP Setup Guide](docs/mcp-setup.md)** - MCP server integration

### Plugin Documentation

Each plugin has detailed README:

- [system plugin](plugins/system/README.md) - System utilities
- [workflow plugin](plugins/workflow/README.md) - Development workflow
- [development plugin](plugins/development/README.md) - Code operations
- [agents plugin](plugins/agents/README.md) - Agent invocation
- [memory plugin](plugins/memory/README.md) - Context management

### Architecture Documentation

- **Design Principles**: Stateless execution, file-based persistence, MCP integration
- **Framework Constraints**: What the system can and cannot do
- **Extension Patterns**: How to create custom plugins

---

## Development

### Building Custom Plugins

**Plugin Structure**:
```
my-plugin/
├── .claude-plugin/
│   └── plugin.json           # Manifest (required)
├── commands/                 # Slash commands (optional)
│   └── my-command.md
├── agents/                   # Specialized agents (optional)
│   └── my-agent.md
└── hooks/                    # Event handlers (optional)
    └── hooks.json
```

**Minimal plugin.json**:
```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "My custom plugin",
  "commands": [
    {
      "name": "my-command",
      "description": "Does something useful",
      "file": "commands/my-command.md"
    }
  ]
}
```

### Testing

```bash
# Run plugin tests
npm test

# Run specific test suite
npm test -- plugins/workflow

# Run with coverage
npm run test:coverage
```

### Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Code style guidelines
- Testing requirements
- Pull request process
- Code of conduct

---

## Performance

### Benchmarks

**Token Usage** (typical feature development):
- Without MCP: ~150K tokens
- With Serena: ~30K tokens (80% reduction)
- With Sequential Thinking: ~180K tokens (+20%, higher quality)

**Time to First Value**:
- Project setup: <2 minutes
- First workflow execution: <5 minutes
- MCP server setup: <15 minutes

### Optimization Tips

**Maximize Serena Benefits**:
- Activate per-project for code-heavy work
- Keep index updated after major changes
- Use for all file reading and symbol lookup

**Efficient Memory Management**:
- Archive completed work units regularly
- Use `.claude/memory/` for project-specific knowledge
- Run `/memory:memory-gc` to clean stale entries

**Token Conservation**:
- Use progressive disclosure (load context incrementally)
- Leverage MCP tools for documentation lookup
- Prefer `/workflow:spike` for exploratory work (isolated, time-boxed)

---

## Troubleshooting

### Common Issues

**Q: Commands not found**

**A**: Verify plugins enabled in `.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "system@local": true,
    "workflow@local": true,
    "development@local": true
  }
}
```

**Q: MCP tools not working**

**A**: MCP servers are optional. Commands work without them but with reduced features. See [docs/mcp-setup.md](docs/mcp-setup.md) for installation.

**Q: Serena not activating**

**A**: Serena requires per-project setup:
```bash
cd /path/to/project
/agents:serena  # Activates Serena for this project
```

**Q: Tasks not executing**

**A**: Check for dependency blockers:
```bash
/workflow:next --status  # Shows task dependencies
```

### Getting Help

- **Documentation**: Check plugin README files for detailed command usage
- **System Health**: Run `/system:status` to verify framework setup
- **Compliance**: Run `/system:audit` to check for issues
- **GitHub Issues**: https://github.com/[your-org]/claude-code-plugins/issues

---

## Versioning

### Current Version: 1.0.0

**Semantic Versioning**:
- **Major** (1.x.x): Breaking changes to plugin API or command structure
- **Minor** (x.1.x): New plugins, commands, or backward-compatible features
- **Patch** (x.x.1): Bug fixes, documentation updates

**Compatibility**: Generated work units and state files are forward-compatible within major versions.

---

## License

**MIT License**

Copyright (c) 2025 Applied AI Consulting

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---

## Acknowledgments

Built with [Claude Code](https://claude.com/claude-code) by Anthropic.

Framework developed through 6+ months of production use across book authoring, quantitative research, and full-stack development projects.

---

## References

- **Claude Code Documentation**: https://docs.claude.com/claude-code
- **MCP Specification**: https://modelcontextprotocol.io
- **Plugin Development**: See plugin README files for examples
- **GitHub Repository**: https://github.com/[your-org]/claude-code-plugins
