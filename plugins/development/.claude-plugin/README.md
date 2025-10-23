# Claude Code Development Plugin

**Version**: 1.0.0
**Category**: Development
**Author**: Claude Code Framework

## Overview

The Development Plugin provides comprehensive code development and quality assurance tools. It includes commands for analysis, testing, debugging, documentation, version control, review, and reporting, powered by specialized AI agents.

## Commands

### `/analyze [focus_area] [options]`
Deep codebase analysis with semantic understanding and structured reasoning.

**Purpose**: Understand project structure, architecture, and patterns

**Options**:
- `[focus_area]`: Specific area to analyze (e.g., `src/auth/`, `database`)
- `[requirements_doc]`: Requirements document for analysis
- `--with-thinking`: Use structured reasoning (Sequential Thinking MCP)
- `--semantic`: Use semantic code understanding (Serena MCP)

**Usage**:
```bash
/analyze                                     # Analyze entire project
/analyze src/auth/                           # Analyze specific area
/analyze @requirements.md                    # Analyze against requirements
/analyze --with-thinking --semantic          # Full MCP analysis
```

**Outputs**:
- Architecture overview
- Pattern identification
- Dependency analysis
- Design recommendations
- Risk assessment

**Agent**: `architect` (system design specialist with structured reasoning)

**MCP Enhancements**:
- **Sequential Thinking**: Multi-step architectural analysis
- **Serena**: Semantic code understanding (70-90% token reduction)

---

### `/test [tdd] [pattern]`
Test-driven development workflow using test-engineer agent.

**Purpose**: Create tests, improve coverage, validate quality

**Modes**:
- `tdd`: Test-driven development mode (write tests first)
- `[pattern]`: Test files matching pattern

**Usage**:
```bash
/test tdd                                    # TDD workflow
/test "src/auth/**/*.test.ts"                # Test specific files
/test                                        # Interactive test creation
```

**TDD Workflow**:
1. Specify functionality to implement
2. Agent writes failing tests
3. Implement code to pass tests
4. Refactor with tests passing

**Outputs**:
- Test coverage analysis
- Missing test cases identified
- Test quality assessment
- Coverage improvement recommendations

**Agent**: `test-engineer` (test specialist with semantic code understanding)

**MCP Enhancements**:
- **Serena**: Semantic symbol finding for test targets
- **Context7**: Testing library documentation

---

### `/fix [target] [options]`
Universal debugging and fix application with semantic code analysis.

**Purpose**: Debug errors, apply review fixes, resolve issues

**Targets**:
- `error`: Debug runtime errors
- `review`: Apply code review fixes
- `audit`: Fix audit findings
- `all`: Fix all identified issues
- `[file/pattern]`: Fix specific files

**Usage**:
```bash
/fix error                                   # Debug last error
/fix review                                  # Apply review comments
/fix audit                                   # Fix audit findings
/fix src/auth/login.ts                       # Fix specific file
/fix all                                     # Fix all issues
```

**Capabilities**:
- Error analysis from logs/stack traces
- Root cause identification
- Automated fix generation
- Validation of fixes
- Regression prevention

**MCP Enhancements**:
- **Serena**: Semantic code navigation for debugging
- **Sequential Thinking**: Complex debugging reasoning

---

### `/docs [subcommand] [arguments]`
Unified documentation hub - fetch, search, and generate.

**Purpose**: Manage all documentation needs in one place

**Subcommands**:
- `fetch [url|package]`: Fetch external documentation
- `search [query]`: Search all documentation
- `generate`: Generate project documentation

**Usage**:
```bash
/docs fetch https://docs.example.com         # Fetch web docs
/docs fetch react                            # Fetch library docs
/docs search "API endpoints"                 # Search documentation
/docs generate                               # Generate project docs
```

**Features**:
- External documentation fetching with caching
- Cross-documentation search
- Auto-generated project documentation
- MCP Context7 integration for library docs

**MCP Enhancements**:
- **Context7**: Fast library documentation lookup
- **Firecrawl**: Web content extraction with caching

---

### `/git [operation] [arguments]`
Unified git operations - commits, pull requests, and issue management.

**Purpose**: All git workflows in one command

**Operations**:
- `commit [message]`: Create safe commits with validation
- `pr [--draft]`: Create pull requests
- `issue [#num|title]`: Work on GitHub issues

**Usage**:
```bash
/git commit "feat: Add authentication"       # Conventional commit
/git commit                                  # Interactive commit
/git pr                                      # Create PR from branch
/git pr --draft                              # Create draft PR
/git issue "#123"                            # Start work on issue
```

**Features**:
- Safe commits with pre-commit validation
- Conventional commit messages
- Comprehensive PR creation
- GitHub issue integration via gh CLI

**Quality Gates**:
- Test execution (if available)
- Linting checks (if configured)
- Secret detection
- Commit message validation

---

### `/review [file/directory] [options]`
Code review focused on bugs, design flaws, dead code, and quality.

**Purpose**: Systematic code quality review with actionable feedback

**Options**:
- `[file/directory]`: Specific scope to review
- `--spec requirements.md`: Review against requirements
- `--systematic`: Comprehensive systematic review
- `--semantic`: Use semantic code analysis

**Usage**:
```bash
/review                                      # Review recent changes
/review src/                                 # Review directory
/review --spec @requirements.md              # Against requirements
/review --systematic --semantic              # Full analysis
```

**Review Focus**:
- **Bugs**: Logic errors, edge cases, error handling
- **Design Flaws**: Architecture issues, coupling, complexity
- **Dead Code**: Unused code, unreachable paths
- **Code Quality**: Readability, maintainability, testability
- **Security**: Vulnerabilities, input validation

**Outputs**:
- Prioritized issues (Critical/High/Medium/Low)
- Specific line-by-line comments
- Actionable fix recommendations
- Refactoring suggestions

**Agent**: `code-reviewer` (quality specialist with structured reasoning and semantic analysis)

**MCP Enhancements**:
- **Sequential Thinking**: Comprehensive review reasoning
- **Serena**: Semantic code understanding for pattern detection

---

### `/report [data|results]`
Generate professional stakeholder reports from data.

**Purpose**: Create business, technical, or executive reports from project data

**Usage**:
```bash
/report @test-results.json                   # Test results report
/report @performance-data.csv                # Performance report
/report @experiment-results.json             # ML experiment report
```

**Report Types**:
- **Technical Reports**: Test results, performance metrics, code analysis
- **Business Reports**: Feature progress, delivery metrics, ROI
- **Executive Reports**: High-level summaries, key decisions, risks

**Outputs**:
- Professional markdown reports
- Visualizations and charts
- Executive summaries
- Actionable recommendations

---

## Specialized Agents

### Architect Agent
**Capability**: `codebaseAnalysis`
**Expertise**: System design and architectural decisions

**Capabilities**:
- Architecture pattern identification
- System design recommendations
- Technical debt assessment
- Scalability analysis
- Integration design

**MCP Tools**: Sequential Thinking for structured analysis

---

### Test Engineer Agent
**Capability**: `testCreation`
**Expertise**: Test creation, coverage analysis, quality assurance

**Capabilities**:
- TDD workflow support
- Test coverage analysis
- Test quality assessment
- Missing test identification
- Test strategy recommendations

**MCP Tools**: Serena for semantic code understanding

---

### Code Reviewer Agent
**Capability**: `codeReview`
**Expertise**: Code quality, security, design review

**Capabilities**:
- Multi-dimensional code review
- Security vulnerability detection
- Design flaw identification
- Dead code detection
- Prioritized issue reporting

**MCP Tools**: Sequential Thinking + Serena for comprehensive analysis

---

### Auditor Agent
**Capability**: Integrated with core and workflow
**Expertise**: Compliance and framework validation

**Capabilities**:
- Framework setup validation
- Tool installation checking
- Work progress auditing
- Documentation compliance
- Best practice verification

**MCP Tools**: Context7 for documentation verification

---

### Data Scientist Agent
**Capability**: `mlExperiments`, `mlEvaluation`
**Expertise**: ML experiments, data analysis, model evaluation

**Capabilities**:
- Experiment design and execution
- Hyperparameter tuning
- Model comparison and evaluation
- Statistical analysis
- Deployment recommendations

**MCP Tools**: Sequential Thinking for complex reasoning

## Configuration

### Plugin Settings

```json
{
  "settings": {
    "defaultEnabled": true,
    "category": "development"
  }
}
```

### Dependencies

```json
{
  "dependencies": {
    "claude-code-core": "^1.0.0"
  }
}
```

**Required**: `core` plugin for agent invocation and configuration

### MCP Tools

**Optional** (with graceful degradation):
- `sequential-thinking`: Enhanced reasoning for analysis and review
- `serena`: Semantic code understanding (70-90% token reduction)
- `context7`: Documentation access for libraries

## Best Practices

### Analysis
- ✅ Start with `/analyze` for new codebases
- ✅ Use `--semantic` for large codebases (token efficient)
- ✅ Focus analysis on specific areas when possible
- ❌ Don't analyze entire large codebase without focus

### Testing
- ✅ Use `/test tdd` for new features
- ✅ Run `/test` before shipping to identify coverage gaps
- ✅ Write tests for bugs before fixing (TDD)
- ❌ Don't skip test creation for complex logic

### Fixing
- ✅ Use `/fix error` immediately when errors occur
- ✅ Apply `/fix review` suggestions systematically
- ✅ Run `/fix audit` after audits
- ❌ Don't accumulate unfixed issues

### Review
- ✅ Run `/review --systematic` before major releases
- ✅ Review against specs with `--spec`
- ✅ Use `--semantic` for large reviews (token efficient)
- ❌ Don't skip reviews for "simple" changes

### Reporting
- ✅ Generate reports for stakeholders regularly
- ✅ Include executive summaries for leadership
- ✅ Use visualizations for complex data
- ❌ Don't present raw data without context

## Integration with Workflow

### With `/explore`
- Run `/analyze` during exploration phase
- Identify architecture patterns early
- Understand technical constraints

### With `/plan`
- Use `/analyze` output for planning
- Identify test requirements
- Plan fixes for identified issues

### With `/next`
- Run `/test` during task execution
- Use `/fix` when errors occur
- Execute `/run` for validation

### With `/ship`
- Run `/review --systematic` before delivery
- Execute `/test` for final coverage check
- Generate `/report` for stakeholders

## Workflow Examples

### Example 1: Feature Development with TDD

```bash
# Phase 1: Analysis
/analyze src/auth/ --semantic

# Phase 2: TDD
/test tdd                               # Write tests first
# Implement feature
/run tests                              # Verify tests pass

# Phase 3: Review
/review src/auth/ --systematic

# Phase 4: Fix issues
/fix review                             # Apply review fixes
```

### Example 2: Bug Fix

```bash
# Phase 1: Debug
/fix error                              # Analyze error

# Phase 2: Test
/test tdd                               # Write failing test
# Fix bug
/run tests                              # Verify fix

# Phase 3: Review
/review --semantic                      # Quick review
```

### Example 3: ML Experiment

```bash
# Phase 1: Design
/experiment @config.yaml                # Run experiment

# Phase 2: Evaluate
/evaluate @results/                     # Compare results

# Phase 3: Report
/report @experiment-results.json        # Generate report
```

## Performance

### Token Efficiency

**With Serena**:
- `/analyze --semantic`: 70-90% reduction vs standard analysis
- `/review --semantic`: 75-85% reduction for large reviews
- `/test` with Serena: 60-80% reduction for coverage analysis

**With Sequential Thinking**:
- `/analyze --with-thinking`: +15-30% tokens, +20-30% quality
- `/review --systematic`: +20-40% tokens, +25-35% quality

### Execution Times

- `/analyze`: 30-90 seconds (depends on codebase size)
- `/test tdd`: 20-60 seconds per test suite
- `/fix`: 10-30 seconds per issue
- `/run`: Depends on script (2-120 seconds typical)
- `/review`: 45-120 seconds (depends on scope)
- `/report`: 15-45 seconds
- `/experiment`: Minutes to hours (depends on experiment)
- `/evaluate`: 20-60 seconds

## Troubleshooting

### Agent Not Available

**Symptom**: `/agent architect` shows "Agent not found"

**Solution**: Verify development plugin enabled:
```bash
/config plugin status claude-code-development
/config plugin enable claude-code-development
```

### Serena Not Working

**Symptom**: `/analyze --semantic` shows "Serena not available"

**Solution**: Activate Serena for project:
```bash
/serena activate                        # Activate Serena
/serena status                          # Verify status
```

### Tests Not Running

**Symptom**: `/run tests` fails with "command not found"

**Solution**: Verify test command in package.json or setup:
```bash
cat package.json                        # Check test script
npm test                                # Verify manually
/run "npm test"                         # Explicit command
```

### Review Too Broad

**Symptom**: `/review` takes too long or uses too many tokens

**Solution**: Scope review to specific area:
```bash
/review src/auth/                       # Specific directory
/review src/auth/login.ts               # Specific file
/review --semantic                      # Use Serena (more efficient)
```

## Version History

### 1.0.0 (2025-10-11)
- Initial plugin release
- 8 development commands
- 5 specialized agents
- MCP integration (Sequential Thinking, Serena, Context7)
- TDD workflow support
- ML experiment capabilities

## License

MIT License - See project LICENSE file

## Related Plugins

- **core**: Required dependency
- **workflow**: Integrates with development cycle
- **git**: Code review integrates with PRs
- **memory**: Lessons learned from development

---

**Note**: This plugin provides comprehensive development capabilities. For workflow-driven development, use in conjunction with the workflow plugin (/explore, /plan, /next, /ship).
