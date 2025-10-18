# Technical Glossary for Demo

Key terms and concepts to ensure accurate AI-hosted discussion.

## Core Concepts

### Claude Code
The official Anthropic CLI (command-line interface) for interacting with Claude AI. Think of it as "Claude in your terminal" - a powerful environment for AI-assisted software development.

### Plugin
A packaged collection of commands, agents, and configurations that extend Claude Code with domain-specific workflows. Plugins are self-contained, version-controlled, and shareable.

### Slash Command
Commands prefixed with `/` that trigger specific workflows (e.g., `/explore`, `/plan`, `/next`). These provide structure to interactions with Claude, replacing ad-hoc prompting with systematic workflows.

### Agent
Specialized AI persona with focused expertise (e.g., test-engineer, code-reviewer, architect). Agents have specific instructions, tools, and knowledge domains optimized for particular tasks.

## Framework Architecture

### Stateless Execution
Each command starts fresh with no persistent in-memory state. All context is loaded from files, ensuring reliability and reproducibility. This is a core design constraint.

### File-Based Persistence
All state, memory, and configuration stored in files (JSON, Markdown). No databases, no APIs requiring persistent connections. Work survives Claude Code restarts.

### .claude Directory
The framework's home within a project:
```
.claude/
├── commands/          # Custom slash commands
├── agents/            # Specialized agents
├── memory/            # Persistent knowledge
├── work/              # Active work units
└── settings.json      # Configuration
```

### Work Unit
A focused piece of work with requirements, plan, tasks, and state. Work units provide structure for complex projects and enable task management.

## Plugin Categories

### Core Plugin (14 commands)
Essential system functionality: status, work management, cleanup, audit, handoff, documentation, setup, project indexing.

### Workflow Plugin (4 commands)
Structured development workflow:
- `/explore` - Requirements analysis and codebase exploration
- `/plan` - Implementation planning with task breakdown
- `/next` - Sequential task execution
- `/ship` - Quality-assured delivery

### Development Plugin (8 commands, 3 agents)
Code quality tools: analyze, test, fix, run, review
Agents: architect, test-engineer, code-reviewer

### Git Plugin (1 command)
Unified git operations: commits with proper attribution, pull requests, issue management. Ensures safe, auditable version control.

### Memory Plugin (3 commands)
Active memory management: review current state, update knowledge, garbage collection for stale entries.

## MCP Integration

### MCP (Model Context Protocol)
Anthropic's protocol for extending Claude with external tools and data sources. Think of it as "plugins for Claude itself" - standardized way to add capabilities.

### Serena MCP
Semantic code understanding tool. Instead of reading entire files (expensive), Serena understands code structure and loads only relevant symbols. **Result: 70-90% token reduction** for code operations.

**Example:**
- Traditional: Read entire 2000-line file (2000 tokens)
- Serena: Load only `UserAuth` class definition (200 tokens)

### Sequential Thinking MCP
Structured reasoning tool for complex problems. Breaks down decisions into explicit thought chains, improving quality of analysis and planning. Built into Claude Code.

### Context7 MCP
Real-time library documentation access. Fetch up-to-date API docs for any library without leaving Claude. Faster than web search, more accurate than LLM memory.

### Graceful Degradation
All MCP features are **optional**. If a tool isn't available, commands fall back to standard approaches. You never hit a hard dependency on external services.

## Quality Automation

### Safe Commits
Git commits with built-in safety:
- Proper conventional commit format
- Claude attribution (Co-Authored-By)
- Pre-commit hook validation
- Protection against committing secrets

### Framework Audit
Validation that project follows Claude Code best practices:
- Correct directory structure
- Valid configuration files
- Required files present
- Tool availability checks

### Idempotency
Commands can be run multiple times safely. Running `/plan` twice doesn't create duplicate tasks. Running `/cleanup` twice doesn't delete valid files. Reduces risk of mistakes.

## Workflow Concepts

### Explore → Plan → Next → Ship
The core four-phase workflow:

1. **Explore**: Understand requirements and codebase
2. **Plan**: Break down work into tasks with dependencies
3. **Next**: Execute tasks one at a time with quality gates
4. **Ship**: Validate, document, and deliver completed work

This replaces "ask Claude to do everything at once and hope" with systematic progression.

### Task State Management
Tasks tracked in JSON with statuses:
- `pending` - Not started yet
- `in_progress` - Currently being worked on
- `completed` - Finished and validated
- `blocked` - Waiting on dependencies

### Progressive Disclosure
Load only the information needed at each step. Don't explain everything upfront - reveal capabilities as users need them. Prevents overwhelming new users while keeping power available.

## Business Model

### Open Source Core
5 core plugins (30+ commands) are **MIT licensed** and free forever. No paywalls, no feature limitations, no telemetry.

### Consulting Services
Custom plugin development, team training, enterprise support available for specialized needs. Open source builds community, services generate revenue.

### Community-First
GitHub as the hub: issues for bugs, discussions for help, pull requests for contributions. Success measured by adoption and contributions, not just revenue.

## Common Analogies

**For Non-Technical:**
- "Like Gmail filters for your Claude conversations"
- "IDE for AI-assisted development"
- "Recipe cards instead of freestyle cooking"

**For Technical:**
- "Plugin system like VS Code extensions"
- "Stateless like REST APIs"
- "Workflow DSL for Claude interactions"
- "Convention over configuration for AI coding"

## Success Metrics

**Community Goals (Year 1):**
- 500+ GitHub stars
- 50+ community contributions
- 10+ companies using in production

**Technical Goals:**
- 70-90% token reduction (with Serena)
- 10x faster context preparation vs ad-hoc prompting
- Zero context limit hits for typical workflows

**Business Goals:**
- $55K-365K from consulting/custom plugins/enterprise
- Sustainable open source maintenance
- Growing community of plugin creators

---

**Key Message**: Claude Code Plugins transform ad-hoc AI coding into systematic, quality-focused workflows with persistent knowledge and community-driven extensibility.
