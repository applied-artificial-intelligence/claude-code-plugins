# Claude Code Plugins - 5-Minute Demo

**Quick-start demonstration of core plugin functionality**

Time: 5 minutes | Prerequisites: Claude Code installed | Level: Beginner

---

## What You'll Learn

This demo shows you how to use the Claude Code Plugins framework to:

1. **Explore and plan work** - Systematic project analysis and task breakdown
2. **Execute structured workflows** - Track and complete tasks with built-in quality gates
3. **Analyze code intelligently** - Deep codebase understanding with MCP tools
4. **Leverage AI/ML skills** - Domain expertise for RAG, transformers, and LLM evaluation
5. **Automated quality checks** - Proactive hooks for cost and resource management

---

## Demo Flow

### Step 1: Project Setup (30 seconds)

Initialize Claude Code framework in your project:

```bash
# Navigate to your project
cd ~/my-project

# Initialize project (auto-detects Python/JavaScript)
/system:setup
```

**What happens**:
- Detects project type (Python, JavaScript, or existing)
- Creates `.claude/` directory structure
- Sets up memory files and configuration
- Configures user preferences (first time only)

**Expected output**:
```
✅ Project type detected: Python
✅ Created .claude/ structure
✅ Initialized memory files
✅ Ready to use Claude Code Plugins
```

---

### Step 2: Explore and Plan Work (90 seconds)

Start a new feature using the workflow pattern:

```bash
# Explore: Analyze requirements and codebase
/workflow:explore "Add user authentication with JWT"

# After exploration completes, create implementation plan
/workflow:plan

# View task breakdown
/workflow:next --preview
```

**What happens**:
- `/explore` creates comprehensive analysis in `.claude/work/current/[work-unit]/`
- Identifies files to modify, dependencies, and potential issues
- `/plan` breaks work into concrete tasks with dependencies
- Creates `state.json` for task tracking

**Expected output** (from `/next --preview`):
```
📋 Available Tasks
──────────────────
TASK-001 - Create User model with JWT fields [pending]
TASK-002 - Implement JWT authentication middleware [pending]
TASK-003 - Add login/logout endpoints [pending]
TASK-004 - Write authentication tests [pending]
```

---

### Step 3: Execute Tasks Systematically (60 seconds)

Execute tasks in dependency order with automatic tracking:

```bash
# Execute next available task
/workflow:next

# After task completes, continue with next
/workflow:next

# Check progress anytime
/workflow:next --status
```

**What happens**:
- Selects next task based on priorities and dependencies
- Executes task with quality checks
- Automatically commits changes with descriptive messages
- Updates task tracking in `state.json`

**Expected output** (from `/next --status`):
```
📊 Task Progress
────────────────
Total Tasks: 4
✅ Completed: 2
🔄 In Progress: 1
⏳ Pending: 1

Progress: 50%
```

---

### Step 4: Intelligent Code Analysis (60 seconds)

Use development tools for deep codebase understanding:

```bash
# Analyze project architecture
/development:analyze

# Review code quality (with semantic understanding via Serena MCP)
/development:review src/

# Fix issues automatically
/development:fix error
```

**What happens**:
- `/analyze` provides architectural overview and recommendations
- `/review` finds bugs, code smells, and security issues
- `/fix` automatically resolves common problems
- MCP tools (Serena) enable 70-90% faster code operations

**Expected output** (from `/review`):
```
🔍 Code Review: src/

Issues Found: 3

🔴 HIGH - Potential SQL injection in auth.py:42
🟡 MEDIUM - Unused import in utils.py:5
🟢 LOW - Consider using f-string in logger.py:18

💡 Recommendations:
  - Use parameterized queries for database access
  - Remove unused imports for cleaner code
  - Update string formatting for consistency
```

---

### Step 5: Leverage AI/ML Skills (45 seconds)

Access domain expertise for AI/ML tasks:

```bash
# Get guidance on RAG implementation
What's the best approach for implementing RAG with vector search?

# Claude activates rag-implementation skill automatically
# Provides decision tree and best practices

# Ask about transformer models
How do I fine-tune a BERT model for classification?

# Claude activates huggingface-transformers skill
# Provides code examples and guidance

# Get LLM evaluation advice
What metrics should I use to evaluate my LLM?

# Claude activates llm-evaluation skill
# Provides comprehensive evaluation framework
```

**What happens**:
- Skills provide specialized domain knowledge
- Decision trees guide technology selection
- Working code examples and best practices
- Progressive disclosure (simple → advanced)

**Expected output**:
```
🎯 RAG Implementation Skill Activated

Based on your requirements, I recommend:

Architecture: Retrieval-Augmented Generation with Vector Search

Components:
1. Document Chunking: 512 tokens with 50-token overlap
2. Embeddings: sentence-transformers/all-mpnet-base-v2
3. Vector Store: FAISS for < 1M docs, Qdrant for > 1M docs
4. Retrieval: Top-k with k=5, re-rank with cross-encoder

[Followed by code examples and implementation steps]
```

---

### Step 6: Automated Quality Checks (30 seconds)

Proactive hooks monitor resource usage:

```bash
# Hooks run automatically during AI operations

# Example: AI Cost Guard Hook
# Triggers when estimated cost > $1.00
```

**What happens**:
- **AI Cost Guard**: Alerts when AI API calls exceed cost thresholds
- **GPU Memory Guard**: Prevents OOM errors by monitoring GPU usage
- Hooks run automatically, no manual invocation needed

**Expected output** (when cost threshold exceeded):
```
⚠️  AI Cost Guard Alert

Estimated Cost: $1.25 (threshold: $1.00)
Total Tokens: 125,000
Model: claude-sonnet-3.5

Options:
  [A]pprove and continue
  [S]witch to smaller model
  [C]ancel operation

Choice:
```

---

## What You've Learned

In 5 minutes, you've seen how to:

✅ **Set up projects** - Automatic detection and configuration
✅ **Explore and plan** - Systematic analysis and task breakdown
✅ **Execute workflows** - Structured task execution with tracking
✅ **Analyze code** - Deep understanding with MCP semantic tools
✅ **Use AI/ML skills** - Domain expertise on demand
✅ **Monitor resources** - Proactive cost and memory management

---

## Next Steps

### Learn More

- **README.md** - Complete technical documentation
- **docs/mcp-setup.md** - MCP server integration guide
- **Plugin READMEs** - Detailed command and agent documentation
  - `plugins/workflow/README.md` - Workflow patterns
  - `plugins/development/README.md` - Development tools
  - `plugins/system/README.md` - System utilities
  - `plugins/agents/README.md` - Specialized agents

### Try These Workflows

**Web Development**:
```bash
/workflow:explore "Add REST API endpoints"
/workflow:plan
/workflow:next
```

**Testing**:
```bash
/development:test tdd  # Test-driven development
/development:review --spec requirements.md
```

**Documentation**:
```bash
/development:docs generate
/development:docs search "authentication"
```

**Git Operations**:
```bash
/development:git commit
/development:git pr
```

---

## Architecture Overview

### Plugin System

```
claude-code-plugins/
├── plugins/                  # Core plugins
│   ├── system/              # System utilities (4 commands)
│   ├── workflow/            # Task workflows (6 commands)
│   ├── development/         # Development tools (6 commands)
│   ├── agents/              # Specialized agents (2 commands)
│   └── memory/              # Memory management (4 commands)
├── skills/                  # AI/ML domain expertise
│   ├── rag-implementation/
│   ├── huggingface-transformers/
│   └── llm-evaluation/
└── hooks/                   # Proactive monitoring
    ├── ai-cost-guard.sh
    └── gpu-memory-guard.sh
```

### Command Categories

**Workflow Commands** (explore → plan → next → ship):
- `/workflow:explore` - Analyze requirements and codebase
- `/workflow:plan` - Create task breakdown with dependencies
- `/workflow:next` - Execute next task in sequence
- `/workflow:ship` - Finalize and deliver work
- `/workflow:work` - Manage multiple work streams
- `/workflow:spike` - Time-boxed exploration

**Development Commands**:
- `/development:analyze` - Deep codebase analysis
- `/development:review` - Code quality and security review
- `/development:test` - Test creation and TDD workflow
- `/development:fix` - Automated debugging and fixes
- `/development:git` - Git operations (commit, PR, issues)
- `/development:docs` - Documentation operations

**System Commands**:
- `/system:setup` - Project initialization
- `/system:audit` - Framework compliance check
- `/system:cleanup` - Remove generated clutter
- `/system:status` - Project and system health

**Agent Commands**:
- `/agents:agent` - Invoke specialized agents
- `/agents:serena` - Semantic code understanding setup

**Memory Commands**:
- `/memory:index` - Create persistent project understanding
- `/memory:memory-review` - Display memory state
- `/memory:memory-gc` - Clean stale entries
- `/memory:performance` - View token usage

### MCP Integration

**Optional MCP Tools** (graceful degradation when unavailable):

1. **Sequential Thinking** (built-in) - Structured reasoning for complex analysis
2. **Serena** (optional) - Semantic code understanding, 70-90% token reduction
3. **Context7** (optional) - Real-time library documentation access
4. **Chrome DevTools** (optional) - Browser automation and debugging
5. **FireCrawl** (optional) - Web content extraction

All commands work without MCP, with enhanced features when available.

---

## Key Features

### 1. Stateless Execution Model

Commands are **stateless** - each invocation starts fresh:

- No persistent processes or background services
- All state stored in files (JSON, Markdown)
- Git serves as the state machine
- Safe to interrupt and resume at any point

### 2. File-Based Persistence

All work tracked in `.claude/` directory:

```
.claude/
├── work/
│   └── current/
│       └── [work-unit]/
│           ├── state.json          # Task tracking
│           ├── exploration.md      # Analysis
│           └── implementation-plan.md
├── memory/
│   ├── project-context.md
│   └── lessons-learned.md
└── settings.json
```

### 3. Quality Gates

Automatic quality checks throughout workflows:

- **Pre-execution**: Dependency verification, environment checks
- **During execution**: API verification (via Serena), tests, linting
- **Post-execution**: Acceptance criteria validation, integration tests
- **Commit time**: Conventional commit messages, attribution

### 4. Progressive Disclosure

Skills reveal complexity gradually:

- **Beginners**: Simple examples, clear guidance
- **Intermediate**: Trade-offs, alternatives, best practices
- **Advanced**: Optimization, edge cases, custom configurations

---

## Troubleshooting

### Common Issues

**Q: Command not found**
**A**: Ensure plugins are enabled in `.claude/settings.json`:

```json
{
  "enabledPlugins": {
    "system@local": true,
    "workflow@local": true,
    "development@local": true,
    "agents@local": true,
    "memory@local": true
  }
}
```

**Q: MCP tools not working**
**A**: MCP tools are optional. Commands work without them but with reduced features. See `docs/mcp-setup.md` for installation.

**Q: Tasks not executing**
**A**: Run `/workflow:next --status` to check for dependency blockers or incomplete planning.

**Q: Serena not activating**
**A**: Serena requires per-project setup. Run `/agents:serena` in project directory.

### Getting Help

- **Documentation**: Check plugin README files
- **Status**: Run `/system:status` for health check
- **Audit**: Run `/system:audit` to verify framework setup
- **Issues**: https://github.com/[your-org]/claude-code-plugins/issues

---

## Philosophy

### Workflows Are Discovered, Not Designed

This framework follows a **consultative approach**:

1. **Explore** actual needs through investigation
2. **Propose** minimal workflows (3-5 commands)
3. **Generate** starting point frameworks
4. **Evolve** based on real-world use

**Not** a rigid template system that assumes patterns transfer uniformly.

### Evidence-Based Automation

Automate only after observing patterns:

- ✅ Pattern repeated ≥3 times
- ✅ Takes >30 minutes each occurrence
- ✅ Automation can be reliable

**Don't** build validators or automation for theoretical needs.

### Graceful Degradation

All features work without MCP:

- Core functionality always available
- Enhanced features when MCP tools present
- No hard dependencies on external services

---

## Performance Expectations

### With MCP Tools

**Serena (Semantic Code Understanding)**:
- 70-90% token reduction for code operations
- Faster file navigation and symbol search
- Precise API verification before code generation

**Context7 (Documentation Access)**:
- 50%+ faster than manual web search
- Real-time library documentation
- Cached for offline access

**Sequential Thinking**:
- 15-30% more tokens used
- 20-30% higher quality analysis
- Better handling of complex scenarios

### Without MCP Tools

All commands work with standard Claude Code features:
- File reading and grep search instead of Serena
- Web search instead of Context7
- Standard reasoning instead of Sequential Thinking

**Performance impact**: 2-3x slower for large codebases, but fully functional.

---

## What's Next?

This framework is **open source** and actively developed.

### Roadmap

**Current** (v1.0):
- 5 core plugins, 25 commands
- 3 specialized agents
- 3 AI/ML skills
- 2 proactive hooks
- MCP integration with graceful degradation

**Planned** (v1.1):
- Web development plugin (frontend, backend, deployment)
- Report generation plugin (technical, business, executive)
- Additional AI/ML skills (prompt engineering, model deployment)
- Enhanced testing and CI/CD integration

### Contributing

See `CONTRIBUTING.md` for:
- Plugin development guidelines
- Command and agent templates
- Testing requirements
- Code review process

---

## Feedback

We value your input! Please share:

- **What works well** - Successes and productivity wins
- **What doesn't work** - Pain points and friction
- **What's missing** - Features you wish existed
- **How you use it** - Real-world workflows and patterns

**GitHub Issues**: https://github.com/[your-org]/claude-code-plugins/issues
**Discussions**: https://github.com/[your-org]/claude-code-plugins/discussions

---

**Happy coding with Claude Code Plugins!**

*Built with evidence-based automation, consultative design, and graceful degradation.*
