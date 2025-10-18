# Claude Code Plugins

**Production-Ready Workflow Framework for Claude Code**

> From Chaos to System: Structured AI-assisted development workflows that scale from individual developers to enterprise teams.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-2.0%2B-blue)](https://docs.claude.com/claude-code)

---

## What Is This?

Claude Code Plugins is a **production-ready framework** that adds structured development patterns, work management, and quality automation to Anthropic's Claude Code.

**In short**: Claude Code provides the tools, we provide the methodology.

### Core Features

✅ **Structured Workflow**: `explore` → `plan` → `next` → `ship` - Break down complex work into tracked, dependent tasks

✅ **Memory Management**: Persistent context across sessions with automatic reflection and cleanup

✅ **Quality Automation**: Safe git commits, pre/post tool execution hooks, compliance auditing

✅ **MCP Integration**: Proven patterns for Serena, Chrome DevTools, Context7, Sequential Thinking

✅ **Specialized Agents**: 6 expert agents (architect, test-engineer, code-reviewer, auditor, data-scientist, report-generator)

### What You Get

**5 Core Plugins** (30+ commands):
- **core** - System commands (status, work, config, cleanup, index, handoff, setup, audit)
- **workflow** - Development workflow (explore, plan, next, ship)
- **development** - Code quality (analyze, test, fix, run, review)
- **git** - Version control operations
- **memory** - Context management (memory-review, memory-update, memory-gc)

**Battle-Tested**: 6+ months of production use building:
- ML for Trading 3rd Edition book (500+ pages)
- Quantitative research infrastructure
- Full-stack web applications

---

## Quick Start

### Prerequisites

- **Claude Code 2.0+** (install from [claude.com/install](https://claude.com/install))
- **Git 2.0+**
- **jq** (JSON processing)

### Installation

**Option 1: Direct Installation** (Recommended)

```bash
# Clone repository
cd ~/repos  # or your preferred location
git clone git@github.com:applied-artificial-intelligence/claude-code-plugins.git
cd claude-code-plugins

# Install plugins
./scripts/install.sh
```

**Option 2: Project-Specific** (via marketplace)

In your project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "aai-plugins": {
      "source": {
        "source": "directory",
        "path": "/path/to/claude-code-plugins/plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@aai-plugins": true,
    "workflow@aai-plugins": true,
    "development@aai-plugins": true,
    "git@aai-plugins": true,
    "memory@aai-plugins": true
  }
}
```

### Your First Workflow

```bash
# Start a new feature
/explore "add user authentication"

# Creates work unit, analyzes requirements, suggests implementation approach

# Generate implementation plan
/plan

# Breaks down work into ordered tasks with dependencies

# Execute tasks one by one
/next

# Runs next task, updates state automatically

# Deliver completed work
/ship

# Validates quality, creates PR, cleans up
```

---

## Why Use This Framework?

### Problem: AI-Assisted Development Gets Messy

- Context limits hit unexpectedly
- Work gets fragmented across sessions
- No systematic approach to complex features
- Quality gates missing
- Knowledge doesn't persist

### Solution: Structured Workflows + Memory Management

**Structured Workflow**:
- Break down complex work systematically
- Track dependencies between tasks
- Resume seamlessly across sessions
- Clear completion criteria

**Memory Management**:
- Persistent context across long-running work
- Automatic reflection at task boundaries
- Garbage collection for stale information
- Project-specific conventions and decisions

**Quality Automation**:
- Safe git commits (no accidental force pushes)
- Pre/post execution hooks
- Automated code review checkpoints
- Framework compliance auditing

---

## Architecture

### Progressive Disclosure Pattern

Instead of loading everything into context upfront, plugins use progressive disclosure:

1. **Startup**: Load minimal metadata (plugin names, descriptions)
2. **Task Analysis**: Load relevant commands/agents based on task
3. **Execution**: Load detailed patterns only when needed

**Result**: 70%+ token savings while maintaining full capability.

### MCP Integration

Proven patterns for Model Context Protocol tools:

- **Serena**: Semantic code understanding (70-90% token reduction for code operations)
- **Chrome DevTools**: Frontend verification (26 tools for debugging and performance)
- **Context7**: Library documentation access (50%+ faster than manual search)
- **Sequential Thinking**: Structured reasoning for complex analysis

All with graceful degradation when MCP unavailable.

### Plugin Architecture

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json        # Manifest
├── commands/              # Slash commands
│   └── *.md
├── agents/                # Specialized agents
│   └── *.md
└── hooks/                 # Event handlers (optional)
    └── hooks.json
```

---

## Documentation

### Getting Started
- [Installation Guide](docs/getting-started/installation.md)
- [Quick Start Tutorial](docs/getting-started/quick-start.md)
- [Your First Plugin](docs/getting-started/first-plugin.md)

### Guides
- [Workflow Guide](docs/guides/workflow-guide.md) - Using explore → plan → next → ship
- [Memory Management](docs/guides/memory-management.md) - Persistent context best practices
- [MCP Integration](docs/guides/mcp-integration.md) - Leveraging Model Context Protocol
- [Plugin Creation](docs/guides/plugin-creation.md) - Building custom plugins

### Reference
- [Commands Reference](docs/reference/commands.md) - All 30+ commands documented
- [Agents Reference](docs/reference/agents.md) - Specialized agent capabilities
- [Configuration](docs/reference/configuration.md) - Settings and customization

### Architecture
- [Design Principles](docs/architecture/design-principles.md) - Core framework philosophy
- [Framework Patterns](docs/architecture/patterns.md) - Reusable patterns
- [System Constraints](docs/architecture/constraints.md) - What the framework can/cannot do

---

## Examples

### Example 1: Feature Development

```bash
# User story: Add password reset functionality

/explore "implement password reset with email verification"
# → Creates work unit 003_password_reset
# → Analyzes: needs email service, token generation, UI flow
# → Suggests: 8 tasks across backend, frontend, testing

/plan
# → Generates detailed task breakdown:
#   1. Design token schema (15 min)
#   2. Implement token generation service (30 min)
#   3. Create email template (15 min)
#   4. Build reset endpoint (30 min)
#   5. Add frontend form (30 min)
#   6. Write tests (45 min)
#   7. Update documentation (15 min)
#   8. Security review (30 min)

/next
# → Executes Task 1: Design token schema
# → Auto-commits when complete

/next  # Repeat until all tasks done

/ship
# → Runs final validation
# → Creates comprehensive PR
# → Updates work unit as completed
```

### Example 2: Bug Investigation

```bash
/explore "#1234"  # GitHub issue number
# → Loads issue description
# → Analyzes error logs
# → Identifies root cause
# → Proposes fix approach

/plan
# → Creates debugging plan with verification steps

/fix
# → Applies fix
# → Runs tests
# → Verifies resolution

/ship
# → Commits fix
# → Updates issue
# → Creates PR
```

### Example 3: Code Review

```bash
/review src/auth/
# → Systematic code analysis
# → Identifies bugs, security issues, design flaws
# → Prioritized action items
# → Generates review report

/fix review
# → Applies recommended fixes
# → Runs tests
# → Updates code quality
```

---

## Case Studies

### ML for Trading Book (500+ pages)

**Challenge**: Authoring technical book with code examples, academic citations, and Jupyter notebooks

**Solution**: Custom plugins built on this framework
- `ml3t-researcher`: Paper search and citation management
- `ml3t-coauthor`: 14-command book production workflow

**Results**:
- 26 chapters coordinated across 3 AI agents
- 100% citation accuracy with Zotero integration
- 95%+ notebook execution success rate

### Quantitative Research Infrastructure

**Challenge**: Reproducible backtesting and strategy development

**Solution**: `quant` plugin with validation gates

**Results**:
- Systematic strategy development workflow
- Automated data validation preventing silent errors
- Reproducible research environment

---

## Services

### Self-Service (Free - Open Source)

✅ 5 core plugins (30+ commands)
✅ Complete documentation
✅ Community support (GitHub issues)
✅ Tutorial content

### Implementation Consulting

**$5K-15K per engagement**

Need help getting your team started?

- Initial setup and configuration
- Team training workshop (4-8 hours)
- Custom configuration for your stack
- 30-day email support

[Schedule Consultation →](https://appliedaiconsulting.com/contact)

### Custom Plugin Development

**$10K-30K per plugin**

Have specialized workflows?

- Discovery workshop
- Custom plugin design and development
- Testing and documentation
- Training and handoff

[Discuss Your Needs →](https://appliedaiconsulting.com/contact)

### Enterprise Support

**$20K-100K/year**

For organizations adopting AI-assisted development at scale:

- Priority support (24-hour response)
- Quarterly plugin updates
- Custom feature development
- Annual training refreshers
- Architecture consultation

[Enterprise Inquiry →](https://appliedaiconsulting.com/enterprise)

---

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:

- How to report bugs
- How to suggest features
- How to submit pull requests
- Code of conduct

---

## Community

- **GitHub Issues**: [Report bugs or request features](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [Ask questions, share plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
- **Discord**: Coming soon
- **Blog**: [Technical articles and lessons learned](https://appliedaiconsulting.com/blog)

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Free for personal and commercial use.

---

## Acknowledgments

Built with [Claude Code](https://claude.com/claude-code) by Anthropic.

Inspired by 6+ months of production use across book authoring, quantitative research, and full-stack development.

---

## What's Next?

**Ready to get started?**

1. [Install the framework](docs/getting-started/installation.md)
2. [Follow the quick start tutorial](docs/getting-started/quick-start.md)
3. [Build your first plugin](docs/getting-started/first-plugin.md)

**Need help with implementation?**

- [Schedule a free 30-minute consultation](https://appliedaiconsulting.com/contact)
- [Read our blog posts](https://appliedaiconsulting.com/blog)
- [Join the community discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

**Want to contribute?**

- Star the repo ⭐
- Open an issue with feedback
- Submit a pull request
- Share your custom plugins

---

**Built by Applied AI Consulting** | [Website](https://appliedaiconsulting.com) | [GitHub](https://github.com/applied-artificial-intelligence)
