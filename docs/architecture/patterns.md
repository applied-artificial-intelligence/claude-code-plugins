# Plugin Patterns

Common patterns for building effective Claude Code plugins. These patterns are proven approaches used in the 6 core plugins (system, agents, workflow, development, git, memory) and can be adapted to your domain-specific needs.

## Table of Contents

- [Command Patterns](#command-patterns)
- [Agent Patterns](#agent-patterns)
- [Workflow Patterns](#workflow-patterns)
- [Integration Patterns](#integration-patterns)
- [Anti-Patterns](#anti-patterns)

---

## Command Patterns

Commands are the primary way users interact with plugins. These patterns help you create effective, user-friendly commands.

### Simple Command Pattern

**Use When**: Single-purpose command with minimal logic

**Structure**:
```markdown
---
name: greet
description: Simple greeting command
allowed-tools: [Bash]
argument-hint: "[name]"
---

# Greet Command

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash
NAME="${1:-World}"
echo "Hello, $NAME!"
```
```

**Real Example**: `/status` from system plugin
```markdown
---
name: status
description: Unified view of work, system, and memory state
allowed-tools: [Read, Bash, Glob]
argument-hint: "[verbose]"
---

# Status Command

I'll show you a comprehensive view of your current work state.

## Implementation

```bash
#!/bin/bash

# Standard constants (must be copied)
readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"

# Check for active work
if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
    ACTIVE=$(cat "${WORK_DIR}/ACTIVE_WORK")
    echo "📁 Active Work: $ACTIVE"
else
    echo "No active work unit"
fi
```
```

**When to Use**:
- ✅ Single clear purpose
- ✅ Minimal state management
- ✅ Quick execution (<5 seconds)
- ✅ No complex dependencies

---

### Parametric Command Pattern

**Use When**: Command needs multiple arguments or flags

**Structure**:
```markdown
---
name: deploy
description: Deploy application to environment
allowed-tools: [Bash]
argument-hint: "[environment] [--dry-run] [--version VERSION]"
---

# Deploy Command

**Input**: $ARGUMENTS

## Implementation

```bash
#!/bin/bash

# Parse arguments
ENVIRONMENT=""
DRY_RUN=false
VERSION="latest"

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --version)
            VERSION="$2"
            shift 2
            ;;
        *)
            ENVIRONMENT="$1"
            shift
            ;;
    esac
done

# Validate required
if [ -z "$ENVIRONMENT" ]; then
    echo "ERROR: Environment required"
    exit 1
fi

# Execute
if [ "$DRY_RUN" = true ]; then
    echo "🔍 DRY RUN: Would deploy $VERSION to $ENVIRONMENT"
else
    echo "🚀 Deploying $VERSION to $ENVIRONMENT..."
fi
```
```

**Real Example**: `/explore` from workflow plugin
```markdown
---
name: explore
description: Explore requirements and codebase
allowed-tools: [Task, Bash, Read, Write, Grep]
argument-hint: "[source: @file, #issue, description] [--work-unit ID]"
---

# Requirements Exploration

```bash
#!/bin/bash

# Parse different source types
REQUIREMENT_SOURCE=""
REQUIREMENT_TYPE="description"
WORK_UNIT_ID=""

# Check for @file reference
if [[ "$ARGUMENTS" =~ @([^ ]+) ]]; then
    REQUIREMENT_SOURCE="${BASH_REMATCH[1]}"
    REQUIREMENT_TYPE="file"
fi

# Check for #issue reference
if [[ "$ARGUMENTS" =~ \#([0-9]+) ]]; then
    REQUIREMENT_SOURCE="${BASH_REMATCH[1]}"
    REQUIREMENT_TYPE="issue"
fi

# Check for --work-unit flag
if [[ "$ARGUMENTS" =~ --work-unit[[:space:]]+([^ ]+) ]]; then
    WORK_UNIT_ID="${BASH_REMATCH[1]}"
fi

# Process based on type
case "$REQUIREMENT_TYPE" in
    file)
        cat "$REQUIREMENT_SOURCE"
        ;;
    issue)
        gh issue view "$REQUIREMENT_SOURCE"
        ;;
    *)
        # Use description directly
        echo "$ARGUMENTS"
        ;;
esac
```
```

**When to Use**:
- ✅ Multiple configuration options
- ✅ Optional flags or modes
- ✅ Different input sources
- ✅ Complex user workflows

---

### Stateful Command Pattern

**Use When**: Command manages or transitions state

**Structure**:
```markdown
---
name: next
description: Execute next available task
allowed-tools: [Bash, Read, Edit, Write]
---

# Next Task Execution

## Implementation

```bash
#!/bin/bash

readonly STATE_FILE=".claude/work/current/ACTIVE/state.json"

# Read current state
if [ ! -f "$STATE_FILE" ]; then
    echo "ERROR: No state file found"
    exit 1
fi

CURRENT_STATUS=$(jq -r '.status' "$STATE_FILE")

# Select next task based on state
NEXT_TASK=$(jq -r '.next_available[0]' "$STATE_FILE")

if [ -z "$NEXT_TASK" ]; then
    echo "✅ All tasks complete!"
    exit 0
fi

echo "🚀 Executing: $NEXT_TASK"

# Execute task (Claude processes this)
# ... task execution ...

# Update state atomically
jq ".completed_tasks += [\"$NEXT_TASK\"]" "$STATE_FILE" > "$STATE_FILE.tmp"
mv "$STATE_FILE.tmp" "$STATE_FILE"

# Commit checkpoint
git add "$STATE_FILE"
git commit -m "Complete $NEXT_TASK"

echo "✅ Task complete. Run /next to continue."
```
```

**Real Example**: `/next` from workflow plugin implements this exactly

**When to Use**:
- ✅ Multi-step workflows
- ✅ State transitions
- ✅ Resumable operations
- ✅ Progress tracking

---

### Phased Workflow Pattern

**Use When**: Command has distinct sequential phases

**Structure**:
```markdown
---
name: analyze
description: Analyze codebase with systematic phases
allowed-tools: [Task, Grep, Read, Write]
---

# Codebase Analysis

## Phase 1: Discovery
Identify components and structure...

## Phase 2: Deep Analysis
Examine patterns and relationships...

## Phase 3: Assessment
Evaluate quality and maintainability...

## Phase 4: Recommendations
Provide actionable insights...

## Phase 5: Documentation
Create analysis report...

## Implementation

```bash
#!/bin/bash

# Phase tracking
PHASE_FILE=".claude/analysis_phase.txt"

# Determine current phase
if [ ! -f "$PHASE_FILE" ]; then
    PHASE="discovery"
else
    PHASE=$(cat "$PHASE_FILE")
fi

echo "📊 Phase: $PHASE"

# Execute phase
case "$PHASE" in
    discovery)
        # Discovery logic
        echo "analysis" > "$PHASE_FILE"
        ;;
    analysis)
        # Analysis logic
        echo "assessment" > "$PHASE_FILE"
        ;;
    # ... more phases
esac
```
```

**Real Example**: `/ship` from workflow plugin
- Phase 1: Pre-delivery validation
- Phase 2: Final tests
- Phase 3: Documentation generation
- Phase 4: Git operations (commit/PR)
- Phase 5: Delivery summary

**When to Use**:
- ✅ Complex multi-step processes
- ✅ Each phase has clear purpose
- ✅ Phases must execute in order
- ✅ Resumable after interruption

---

## Agent Patterns

Agents are specialized AI assistants with focused expertise. These patterns help you create effective agents.

### Specialist Agent Pattern

**Use When**: Need focused expertise in specific domain

**Structure**:
```markdown
---
name: code-reviewer
description: Code quality and security review specialist
capabilities: ["code-review", "security-analysis", "best-practices"]
allowed-tools: [Read, Grep, Bash]
---

# Code Reviewer Agent

You are a specialized code review agent with expertise in:
- Code quality and maintainability
- Security vulnerabilities
- Performance issues
- Best practices adherence

## Your Role

Perform thorough code reviews focusing on:
1. **Bugs**: Logic errors and potential failures
2. **Security**: Vulnerabilities and attack vectors
3. **Performance**: Inefficiencies and bottlenecks
4. **Maintainability**: Code clarity and structure

## Guidelines

1. **Be Specific**: Point to exact line numbers
2. **Explain Why**: Don't just flag issues, explain impact
3. **Provide Fixes**: Suggest concrete improvements
4. **Prioritize**: Rank findings by severity

## Output Format

```
## High Priority Issues
- [File:Line] Issue description and fix

## Medium Priority Issues
- [File:Line] Issue description and fix

## Low Priority Issues
- [File:Line] Issue description and fix

## Summary
X total issues found (X high, X medium, X low)
```

## Limitations

- Cannot execute code or run tests
- Cannot modify files (only recommend changes)
- Focus on static analysis
```

**Real Example**: `code-reviewer` from development plugin

**When to Use**:
- ✅ Specialized knowledge required
- ✅ Consistent evaluation criteria
- ✅ Repeatable analysis process
- ✅ Well-defined boundaries

---

### Validator Agent Pattern

**Use When**: Need to verify specific criteria

**Structure**:
```markdown
---
name: quant-validator
description: Validate quantitative finance code
capabilities: ["backtest-validation", "risk-checks"]
---

# Quantitative Finance Validator

You are a specialized validator for quantitative finance code.

## Validation Criteria

### Data Validation
- [ ] No look-ahead bias in indicators
- [ ] Proper timestamp handling
- [ ] Missing data handled correctly

### Risk Validation
- [ ] Position sizing within limits
- [ ] Stop-loss mechanisms present
- [ ] Maximum drawdown calculated

### Performance Validation
- [ ] Sharpe ratio > 1.0
- [ ] Win rate documented
- [ ] Transaction costs included

## Process

1. **Read code**: Understand the strategy
2. **Check criteria**: Verify each validation point
3. **Report findings**: List violations with evidence
4. **Suggest fixes**: Provide specific corrections

## Output Format

```
✅ Passed: X/Y validations

❌ Failed Validations:
- [Criterion]: Evidence and fix

⚠️ Warnings:
- [Criterion]: Potential issue and recommendation
```
```

**When to Use**:
- ✅ Domain-specific validation rules
- ✅ Compliance checking
- ✅ Quality gates
- ✅ Repeatable verification

---

### Generator Agent Pattern

**Use When**: Need to create structured content

**Structure**:
```markdown
---
name: test-engineer
description: Generate comprehensive test suites
capabilities: ["test-generation", "coverage-analysis"]
allowed-tools: [Read, Write, Bash]
---

# Test Engineer Agent

You are a specialized test generation agent.

## Your Role

Generate comprehensive test suites including:
- Unit tests with edge cases
- Integration tests
- Test fixtures and mocks
- Performance benchmarks

## Test Generation Process

1. **Analyze Code**: Understand functionality
2. **Identify Test Cases**: Edge cases, boundaries, failures
3. **Generate Tests**: Write complete test suite
4. **Create Fixtures**: Test data and mocks
5. **Document**: Explain test coverage

## Test Quality Standards

- ✅ Each function has unit tests
- ✅ Edge cases covered (null, empty, max/min)
- ✅ Error conditions tested
- ✅ Integration points verified
- ✅ Test names are descriptive

## Output Format

```python
# Test file: test_module.py

import pytest
from module import function

class TestFunction:
    """Tests for function."""

    def test_normal_case(self):
        """Test normal operation."""
        assert function(5) == 25

    def test_edge_case_zero(self):
        """Test edge case: zero input."""
        assert function(0) == 0

    def test_error_negative(self):
        """Test error handling: negative input."""
        with pytest.raises(ValueError):
            function(-1)
```
```

**Real Example**: `test-engineer` from development plugin

**When to Use**:
- ✅ Structured content generation
- ✅ Template-based output
- ✅ Consistent formatting needed
- ✅ Scaffolding and boilerplate

---

## Workflow Patterns

Workflows combine commands and agents into cohesive processes.

### Four-Phase Workflow Pattern

**The Core Pattern**: `EXPLORE → PLAN → EXECUTE → DELIVER`

This is the recommended workflow pattern used by Claude Code's core plugins.

#### Phase 1: EXPLORE (`/explore`)
**Purpose**: Understand the problem and gather context

**Pattern**:
```markdown
## Exploration Phase

### Requirement Analysis
1. Parse user input (description, @file, #issue)
2. Load relevant context and documentation
3. Identify constraints and dependencies
4. Document findings in exploration.md

### Codebase Exploration
1. Identify relevant files and components
2. Understand existing patterns
3. Note integration points
4. Map dependencies

### Output
- exploration.md with structured analysis
- requirements.md if needed
- Work unit directory created
```

**Real Implementation**: `/explore` command
- Supports multiple input sources (@file, #issue, description)
- Uses Task tool for systematic exploration
- Creates work unit with exploration.md
- Loads project context from memory

#### Phase 2: PLAN (`/plan`)
**Purpose**: Break work into manageable tasks

**Pattern**:
```markdown
## Planning Phase

### Task Breakdown
1. Review exploration findings
2. Identify major components
3. Break into atomic tasks
4. Define dependencies
5. Set acceptance criteria

### State Creation
1. Generate implementation-plan.md
2. Create state.json with tasks
3. Set estimated times
4. Mark initial status

### Output
- implementation-plan.md (human-readable)
- state.json (machine-readable)
- metadata.json (work unit info)
```

**Real Implementation**: `/plan` command
- Reads exploration.md
- Creates ordered task list
- Defines dependencies
- Sets acceptance criteria
- Creates state.json for /next

#### Phase 3: EXECUTE (`/next`)
**Purpose**: Work through tasks systematically

**Pattern**:
```markdown
## Execution Phase

### Task Selection
1. Load state.json
2. Check dependencies
3. Select next available task
4. Verify prerequisites

### Task Execution
1. Display task details
2. Execute implementation
3. Verify acceptance criteria
4. Handle errors gracefully

### State Update
1. Mark task complete
2. Update state.json
3. Git commit checkpoint
4. Identify next tasks

### Output
- Completed task deliverables
- Updated state.json
- Git commit with attribution
- Progress report
```

**Real Implementation**: `/next` command
- Reads state.json
- Selects based on dependencies
- Executes one task at a time
- Updates state atomically
- Auto-commits with proper message

#### Phase 4: DELIVER (`/ship`)
**Purpose**: Finalize and package work

**Pattern**:
```markdown
## Delivery Phase

### Pre-Delivery Validation
1. Verify all tasks complete
2. Run final tests
3. Check code quality
4. Validate documentation

### Packaging
1. Generate completion summary
2. Create pull request (if --pr)
3. Tag release (if --tag)
4. Update work unit status

### Output
- Completion summary
- Pull request (optional)
- Git tag (optional)
- Delivery report
```

**Real Implementation**: `/ship` command
- Validates completion
- Runs quality checks
- Creates PR with comprehensive description
- Generates delivery summary
- Marks work unit complete

**When to Use Four-Phase Workflow**:
- ✅ Non-trivial features (>1 hour)
- ✅ Multiple file changes
- ✅ Complex requirements
- ✅ Team collaboration needed

**When NOT to Use**:
- ❌ Single-line fixes
- ❌ Typo corrections
- ❌ Quick documentation updates

---

### Progressive Refinement Pattern

**Use When**: Iterative improvement over multiple cycles

**Pattern**:
```
DRAFT → REVIEW → REFINE → REVIEW → FINALIZE
  ↓       ↓        ↓        ↓         ↓
v0.1    v0.2     v0.3     v0.4      v1.0
```

**Example: Book Chapter Workflow**
1. **/outline**: Create chapter structure
2. **/draft**: Write first draft
3. **/review**: Analyze quality and clarity
4. **/refine**: Improve based on feedback
5. **/publish**: Finalize for publication

**When to Use**:
- ✅ Creative content (writing, design)
- ✅ Quality improvement cycles
- ✅ Incremental refinement
- ✅ Feedback incorporation

---

### Validation Gate Pattern

**Use When**: Quality checkpoints between phases

**Pattern**:
```
DEVELOP → [GATE 1: Tests] → REVIEW → [GATE 2: Security] → DEPLOY
           ✅ or ❌                    ✅ or ❌
```

**Implementation**:
```bash
# Gate 1: Tests must pass
run_tests() {
    pytest tests/ || error_exit "Tests failed - fix before proceeding"
}

# Gate 2: Security scan
security_scan() {
    bandit -r src/ || error_exit "Security issues found"
}

# Only proceed if gates pass
run_tests && security_scan && proceed_to_next_phase
```

**When to Use**:
- ✅ Critical quality requirements
- ✅ Compliance needs
- ✅ High-risk changes
- ✅ Production deployments

---

## Integration Patterns

Patterns for integrating with external systems and tools.

### MCP Tool Integration Pattern

**Use When**: Enhancing commands with MCP capabilities

**Pattern**:
```bash
# Check if MCP tool available
if command -v serena &> /dev/null; then
    # Enhanced path: Use MCP tool
    serena find_symbol "MyClass"
else
    # Fallback path: Use standard tools
    grep -r "class MyClass" src/
fi
```

**Real Example**: From core plugins
```markdown
---
allowed-tools: [Read, Grep, mcp__serena__find_symbol, mcp__serena__get_symbols_overview]
---

```bash
#!/bin/bash

# Try Serena for semantic search
if command -v serena &> /dev/null; then
    # 70-90% token reduction with semantic search
    serena find_symbol "$SYMBOL_NAME"
else
    # Fallback to grep
    grep -r "class $SYMBOL_NAME\|function $SYMBOL_NAME" .
fi
```
```

**MCP Tools in Core Plugins**:
- **Sequential Thinking**: Complex analysis (explore, analyze)
- **Serena**: Semantic code search (analyze, review, fix)
- **Context7**: Documentation access (docs fetch)
- **Firecrawl**: Web research (explore with URLs)

**When to Use**:
- ✅ Performance optimization available
- ✅ Enhanced capabilities valuable
- ✅ Graceful degradation possible
- ✅ User experience improves

---

### Plugin-to-Plugin Integration Pattern

**Use When**: One plugin extends another

**Pattern**:
```markdown
---
name: ml-experiment
description: Run ML experiment (extends /run)
---

# ML Experiment Command

This extends the /run command with ML-specific features.

## Implementation

```bash
#!/bin/bash

# 1. Setup ML environment
setup_ml_env() {
    # ML-specific setup
    export CUDA_VISIBLE_DEVICES=0
    source venv/bin/activate
}

# 2. Use core /run functionality
run_experiment() {
    # Leverage /run command
    # (user can invoke it manually or we set up files for it)
    python train.py --config $CONFIG
}

# 3. ML-specific post-processing
track_metrics() {
    # Log to MLflow, wandb, etc.
    mlflow log-metric "accuracy" $ACCURACY
}

setup_ml_env
run_experiment
track_metrics
```
```

**When to Use**:
- ✅ Domain-specific extension
- ✅ Core functionality exists
- ✅ Additional features needed
- ✅ Maintain plugin separation

---

### External System Integration Pattern

**Use When**: Integrating with APIs, databases, or services

**Pattern**:
```bash
# Integrate with external API
integrate_external_api() {
    local api_key="${API_KEY:-$(cat .env | grep API_KEY | cut -d= -f2)}"

    if [ -z "$api_key" ]; then
        error_exit "API_KEY not found in environment or .env"
    fi

    # Make API call with error handling
    response=$(curl -s -w "%{http_code}" \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d '{"query":"data"}' \
        https://api.example.com/v1/endpoint)

    http_code="${response: -3}"
    body="${response:0:-3}"

    if [ "$http_code" != "200" ]; then
        error_exit "API call failed: HTTP $http_code - $body"
    fi

    echo "$body"
}
```

**When to Use**:
- ✅ External services required
- ✅ API credentials managed
- ✅ Error handling needed
- ✅ Connection ephemeral (stateless)

---

## Anti-Patterns

Common mistakes to avoid when building plugins.

### ❌ Fighting Statelessness

**Wrong**: Trying to maintain state between invocations
```bash
# DON'T DO THIS
COUNTER=0
increment() {
    COUNTER=$((COUNTER + 1))  # Lost on next invocation!
}
```

**Right**: Use file-based state
```bash
# DO THIS
COUNTER_FILE=".claude/counter.txt"
increment() {
    local count=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
    echo $((count + 1)) > "$COUNTER_FILE"
}
```

---

### ❌ External Script Sourcing

**Wrong**: Trying to source external utilities
```bash
# DON'T DO THIS
source ~/.claude/lib/utils.sh  # File not found! (wrong directory)
```

**Right**: Copy utilities inline
```bash
# DO THIS
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}
# (Copy this to every command that needs it)
```

**Why**: Commands execute in project directory, not ~/.claude/commands/

---

### ❌ Complex Logic in Markdown

**Wrong**: Trying to implement complex logic in templates
```markdown
<!-- DON'T DO THIS -->
{{#if user.isAdmin}}
  Show admin panel
{{else}}
  Show user panel
{{/if}}
```

**Right**: Let AI handle logic, template provides structure
```markdown
<!-- DO THIS -->
## User Interface

I'll determine the appropriate interface based on user role and display accordingly.
```

---

### ❌ Assuming MCP Availability

**Wrong**: Requiring MCP tools
```bash
# DON'T DO THIS
serena find_symbol "MyClass"  # Fails if Serena not installed!
```

**Right**: Graceful degradation
```bash
# DO THIS
if command -v serena &> /dev/null; then
    serena find_symbol "MyClass"
else
    grep -r "class MyClass" src/
fi
```

---

### ❌ Silent Failures

**Wrong**: Ignoring errors
```bash
# DON'T DO THIS
cat file.txt 2>/dev/null  # Silently fails if file missing
```

**Right**: Explicit error handling
```bash
# DO THIS
if [ ! -f "file.txt" ]; then
    error_exit "file.txt not found. Create it first with /init"
fi
cat file.txt
```

---

### ❌ Over-Engineering

**Wrong**: Building complex frameworks
```bash
# DON'T DO THIS
# Creating elaborate plugin dependency system
# With plugin managers, loaders, and registries
```

**Right**: Simple, composable patterns
```bash
# DO THIS
# Each plugin is independent
# Users enable what they need
# Plugins work standalone
```

---

## Summary

### Command Patterns Recap
- **Simple**: Single-purpose, minimal logic
- **Parametric**: Multiple arguments, flags, options
- **Stateful**: Manages state transitions
- **Phased**: Sequential workflow phases

### Agent Patterns Recap
- **Specialist**: Focused domain expertise
- **Validator**: Verify specific criteria
- **Generator**: Create structured content

### Workflow Patterns Recap
- **Four-Phase**: Explore → Plan → Execute → Deliver
- **Progressive Refinement**: Iterative improvement
- **Validation Gate**: Quality checkpoints

### Integration Patterns Recap
- **MCP Tools**: Enhanced capabilities with fallbacks
- **Plugin-to-Plugin**: Domain-specific extensions
- **External Systems**: API and service integration

### Key Principles

1. **Embrace Constraints**: Work with statelessness, not against it
2. **File-Centric**: All state persists to files
3. **Self-Contained**: Each command has all needed logic
4. **Graceful Degradation**: Always provide fallbacks
5. **Explicit Over Implicit**: Make everything clear
6. **Simple Over Complex**: Patterns that compose well

---

## Further Reading

- [Design Principles](design-principles.md) - Core architectural principles
- [Framework Constraints](constraints.md) - Technical limitations
- [Quick Start Tutorial](../getting-started/quick-start.md) - See patterns in action
- [First Plugin Tutorial](../getting-started/first-plugin.md) - Build with these patterns

---

*These patterns enable building effective, maintainable Claude Code plugins that work reliably across all use cases.*
