---
layout: default
title: Home
nav_order: 1
description: "Production-ready workflow framework for Claude Code - structured development patterns, work management, and quality automation"
permalink: /
---

# Claude Code Plugins
{: .fs-9 }

Production-ready workflow framework that adds structured development patterns, work management, and quality automation to Anthropic's Claude Code.
{: .fs-6 .fw-300 }

[Get Started](getting-started/installation){: .btn .btn-primary .fs-5 .mb-4 .mb-md-0 .mr-2 }
[View on GitHub](https://github.com/applied-artificial-intelligence/claude-code-plugins){: .btn .fs-5 .mb-4 .mb-md-0 }

---

## From Chaos to System

Claude Code provides the tools, we provide the methodology.

### The Problem

AI-assisted coding is powerful but chaotic:
- ❌ **Context limits** force you to restart mid-task
- ❌ **Memory loss** when switching between features
- ❌ **No systematic preservation** of decisions and patterns
- ❌ **Quality inconsistencies** - sometimes amazing, sometimes breaks things

### The Solution

**Structured workflows + Persistent memory + Quality automation**

Claude Code Plugins transforms AI-assisted development from freestyle conversations into a systematic, repeatable process.

---

## Core Features

### 🔄 Structured Workflow
```bash
/explore → /plan → /next → /ship
```
Break down complex work into tracked, dependent tasks with the proven 4-phase methodology.

### 💾 Memory Management
Persistent context across sessions with automatic reflection and cleanup. Never lose project knowledge again.

### ✅ Quality Automation
Safe git commits, pre/post tool execution hooks, compliance auditing. Built-in quality gates prevent mistakes.

### 🔌 MCP Integration
Proven patterns for Serena (70-90% token reduction), Chrome DevTools, Context7, Sequential Thinking.

### 🤖 Specialized Agents
6 expert agents: architect, test-engineer, code-reviewer, auditor, data-scientist, report-generator.

---

## 6 Core Plugins (26 Commands)

<div class="code-example" markdown="1">

### System
**Configuration and health monitoring**

`status` · `setup` · `audit` · `cleanup` · `config`

### Agents
**Expert invocation and semantic code**

`agent` · `serena`

### Workflow
**Development lifecycle**

`explore` · `plan` · `next` · `ship` · `work` · `spike`

### Development
**Code quality tools**

`analyze` · `test` · `fix` · `run` · `review` · `docs`

### Git
**Version control operations**

`commit` · `pr` · `issue` (unified under `/git`)

### Memory
**Context and knowledge**

`memory-review` · `memory-update` · `memory-gc` · `index` · `handoff` · `performance`

</div>

---

## Battle-Tested

**6+ months of production use** building:
- ML for Trading 3rd Edition book (500+ pages)
- Quantitative research infrastructure
- Full-stack web applications

---

## Quick Start

### Prerequisites
- **Claude Code 2.0+** ([install](https://claude.com/install))
- **Git 2.0+**
- **jq** (JSON processing)

### Installation

```bash
# Clone repository
cd ~/repos
git clone git@github.com:applied-artificial-intelligence/claude-code-plugins.git
cd claude-code-plugins

# Install plugins
./scripts/install.sh
```

### Your First Workflow

```bash
# Start a new feature
/explore "add user authentication"

# Creates work unit, analyzes requirements, suggests approach
# Review exploration.md

# Create implementation plan
/plan

# Review implementation-plan.md with ordered tasks
# Execute tasks one by one

/next  # Implements TASK-001
/next  # Implements TASK-002
# ... continue through all tasks

# Ship completed work
/ship --pr

# Creates pull request with comprehensive summary
```

---

## Why Claude Code Plugins?

### Open Source
**MIT Licensed** - All 6 core plugins (26 commands) are free forever. No paywalls, no feature limitations, no telemetry.

### Community-Driven
Built with real-world learnings from months of production use. Contributions welcome.

### Consulting Available
Custom plugin development, team training, enterprise support for specialized needs.

---

## Learn More

<div class="grid" markdown="1">

<div class="grid-item" markdown="1">
### Getting Started
- [Installation Guide](getting-started/installation)
- [Quick Start Tutorial](getting-started/quick-start)
- [Your First Plugin](getting-started/first-plugin)
</div>

<div class="grid-item" markdown="1">
### Reference
- [Commands Reference](reference/commands)
- [Architecture](architecture/design-principles)
- [Developer Guide](development/DEVELOPER_GUIDE)
</div>

</div>

---

## Community

- **GitHub**: [Report issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Website**: [Applied AI](https://applied-ai.com)
- **Email**: [stefan@applied-ai.com](mailto:stefan@applied-ai.com)

---

{: .note }
> Claude Code Plugins is production-ready (v1.0.0) but documentation is actively being improved. Contributions welcome!
