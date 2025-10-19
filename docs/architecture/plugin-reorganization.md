# Plugin Reorganization Design

**Purpose**: Replace generic "core" plugin with meaningful names and logical organization
**Status**: Design Complete
**Version**: 1.0.0
**Created**: 2025-10-18

---

## Problem Statement

### Current Issues
- **Generic Name**: "core" plugin doesn't describe its purpose
- **Bloated Scope**: 14 commands mixing 4-5 distinct functional areas
- **Violates SoC**: Separation of concerns principle violated
- **Poor Discoverability**: Users struggle to find commands
- **Reviewer Feedback**: "Bloated and lacks focus" (MAJOR issue)

### Current Plugin Structure

```
plugins/
├── core/               # 14 commands (❌ BLOATED, VAGUE)
│   ├── status
│   ├── config
│   ├── setup
│   ├── audit
│   ├── cleanup
│   ├── work
│   ├── spike
│   ├── index
│   ├── handoff
│   ├── performance
│   ├── agent
│   ├── serena
│   ├── add-command
│   └── docs
├── workflow/           # 4 commands
│   ├── explore
│   ├── plan
│   ├── next
│   └── ship
├── development/        # 8 commands
│   ├── analyze
│   ├── review
│   ├── test
│   ├── fix
│   ├── run
│   ├── experiment
│   ├── evaluate
│   └── report
├── git/                # 1 command
│   └── git
└── memory/             # 3 commands
    ├── memory-review
    ├── memory-update
    └── memory-gc
```

### Functional Areas Mixed in "core"
1. **System**: status, config, setup, audit, cleanup (5)
2. **Work/PM**: work, spike (2)
3. **Memory/Context**: index, handoff, performance (3)
4. **Dev Tools**: add-command, docs (2)
5. **Agents**: agent, serena (2)

---

## Proposed Plugin Structure

### New Organization

```
plugins/
├── system/             # 5 commands - System configuration and health
│   ├── status          # Unified system status view
│   ├── config          # Configuration management
│   ├── setup           # Project initialization
│   ├── audit           # Framework compliance checks
│   └── cleanup         # Cleanup operations
│
├── workflow/           # 6 commands - Task workflow management
│   ├── explore         # Requirement exploration
│   ├── plan            # Implementation planning
│   ├── next            # Execute next task
│   ├── ship            # Deliver completed work
│   ├── work            # Work unit management (from core)
│   └── spike           # Time-boxed experiments (from core)
│
├── memory/             # 6 commands - Knowledge and context management
│   ├── memory-review   # Review memory state
│   ├── memory-update   # Update memory entries
│   ├── memory-gc       # Garbage collection
│   ├── index           # Project indexing (from core)
│   ├── handoff         # Session transitions (from core)
│   └── performance     # Performance metrics (from core)
│
├── development/        # 7 commands - Development tools
│   ├── analyze         # Codebase analysis
│   ├── review          # Code review
│   ├── test            # Testing workflows
│   ├── fix             # Bug fixing
│   ├── run             # Script execution
│   ├── add-command     # Create new commands (from core)
│   └── docs            # Documentation operations (from core)
│
├── agents/             # 2 commands - Agent invocation
│   ├── agent           # Specialized agent invocation (from core)
│   └── serena          # Semantic code understanding (from core)
│
├── git/                # 1 command - Version control
│   └── git             # Unified git operations
│
└── ml/                 # 3 commands - ML/Data science (optional)
    ├── experiment      # Run ML experiments (from development)
    ├── evaluate        # Compare experiments (from development)
    └── report          # Generate reports (from development)
```

---

## Plugin Descriptions

### system - System Configuration and Health

**Purpose**: System-level operations and health monitoring
**Commands**: 5
**Focus**: Configuration, setup, status, compliance

**Commands**:
- `status` - Unified view of work, system, and memory state
- `config` - Manage Claude Code configuration settings
- `setup` - Initialize Claude Code in new projects
- `audit` - Validate framework compliance and configuration
- `cleanup` - Clean up generated files and temporary data

**Rationale**: System-focused operations that configure or monitor Claude Code itself.

---

### workflow - Task Workflow Management

**Purpose**: End-to-end task execution workflow
**Commands**: 6 (4 existing + 2 from core)
**Focus**: Explore → Plan → Execute → Ship

**Commands**:
- `explore` - Analyze requirements and create work breakdown
- `plan` - Create implementation plan with dependencies
- `next` - Execute next available task
- `ship` - Deliver completed work with validation
- `work` - Manage work units and parallel streams (from core)
- `spike` - Time-boxed exploration in isolated branch (from core)

**Rationale**: Complete workflow for structured development. Adding `work` and `spike` completes the workflow toolkit.

**Reviewer Quote**: "The star of the framework. Brilliant. Perfect pattern for AI-driven development."

---

### memory - Knowledge and Context Management

**Purpose**: Long-term project knowledge and session context
**Commands**: 6 (3 existing + 3 from core)
**Focus**: Persistent memory and session transitions

**Commands**:
- `memory-review` - Review current memory state
- `memory-update` - Update or create memory entries
- `memory-gc` - Garbage collection for stale entries
- `index` - Create and maintain project understanding (from core)
- `handoff` - Session transition documentation (from core)
- `performance` - Token usage and performance metrics (from core)

**Rationale**: Memory and context operations form a cohesive toolkit. Index, handoff, and performance all relate to knowledge management.

**Reviewer Quote**: "Very clever. Auto-reflection creates a closed loop where the AI learns from completed work."

---

### development - Development Tools

**Purpose**: Core development operations
**Commands**: 7 (5 existing + 2 from core, or 4 if ML split)
**Focus**: Analyze, review, test, fix, run

**Commands**:
- `analyze` - Codebase analysis with semantic understanding
- `review` - Code review focused on bugs and quality
- `test` - Testing workflows and TDD support
- `fix` - Debug errors and apply fixes automatically
- `run` - Execute scripts with monitoring
- `add-command` - Create new Claude Code commands (from core)
- `docs` - Documentation operations (from core)

**Rationale**: General-purpose development tools. Adding `add-command` and `docs` keeps tooling together.

**Reviewer Quote**: "Strong, useful command set. High-value AI tasks."

**ML Split Decision**: If ML commands split out, development becomes 4 commands (analyze, review, test, fix, run). Evaluate during implementation.

---

### agents - Agent Invocation

**Purpose**: Specialized agent management
**Commands**: 2 (from core)
**Focus**: Agent orchestration and semantic understanding

**Commands**:
- `agent` - Direct invocation of specialized agents
- `serena` - Activate semantic code understanding

**Rationale**: Agent-related operations deserve their own plugin. These are meta-tools that invoke other capabilities.

---

### git - Version Control

**Purpose**: Git operations with AI safety
**Commands**: 1 (unchanged)
**Focus**: Safe commits, PRs, issue management

**Commands**:
- `git` - Unified git operations with validation

**Rationale**: Git operations are distinct enough to warrant separate plugin.

**Reviewer Quote**: "Absolutely appropriate. Safe commit philosophy is essential for AI."

---

### ml - Machine Learning (Optional)

**Purpose**: ML/Data science workflows
**Commands**: 3 (from development)
**Focus**: Experiment tracking and evaluation

**Commands**:
- `experiment` - Run ML experiments with tracking
- `evaluate` - Compare experiments and identify best
- `report` - Generate professional reports

**Decision**: **Optional** - Evaluate during implementation
- Pro: Cleaner development plugin (more general-purpose)
- Con: Only 3 commands, might be too small
- Recommendation: Defer to v1.1 if time-constrained

---

## Migration Mapping

### Commands Moving FROM core

**To system** (5 commands):
- status
- config
- setup
- audit
- cleanup

**To workflow** (2 commands):
- work
- spike

**To memory** (3 commands):
- index
- handoff
- performance

**To development** (2 commands):
- add-command
- docs

**To agents** (2 commands):
- agent
- serena

**Total**: 14 commands redistributed

### Commands Moving FROM development (Optional)

**To ml** (3 commands):
- experiment
- evaluate
- report

---

## Plugin Sizes After Reorganization

| Plugin | Commands | Change | Focus |
|--------|----------|--------|-------|
| system | 5 | New (was part of core) | System operations |
| workflow | 6 | +2 from core | Task workflow |
| memory | 6 | +3 from core | Knowledge/context |
| development | 7 (or 4) | +2 from core (or -3 if ML split) | Dev tools |
| agents | 2 | New (was part of core) | Agent invocation |
| git | 1 | No change | Version control |
| ml | 3 (optional) | New (from development) | ML/Data science |
| **core** | ~~14~~ | **DELETED** | ❌ Bloated, vague |

**Result**: 6-7 focused plugins instead of 1 bloated + 4 others

---

## Benefits

### Improved Discoverability
- Users know where to find commands
- Plugin names describe purpose
- Logical grouping by function

### Better Separation of Concerns
- Each plugin has clear, focused purpose
- No mixing of unrelated functionality
- Easier to understand and maintain

### Enhanced Extensibility
- Clear patterns for adding new commands
- Plugin boundaries well-defined
- Easier for contributors to navigate

### User Experience
- More intuitive command organization
- Better plugin descriptions in help
- Clearer mental model

### Technical Review Impact
- Addresses "bloated core" MAJOR issue
- Shows commitment to quality organization
- Demonstrates thoughtful architecture

---

## Implementation Phases

### Phase 1: Create New Plugin Structures (TASK-007)
- Create `plugins/system/` with plugin.json
- Create `plugins/agents/` with plugin.json
- Create `plugins/ml/` with plugin.json (optional)
- Set up directory structure for each

### Phase 2: Move Commands (TASK-008)
- Move 5 commands to system
- Move 2 commands to workflow
- Move 3 commands to memory
- Move 2 commands to development
- Move 2 commands to agents
- Optionally move 3 to ml

### Phase 3: Update Metadata (TASK-009)
- Update all plugin.json files
- Update README.md listings
- Update documentation references
- Create migration guide for users

### Phase 4: Remove Core Plugin
- Verify all commands moved
- Delete `plugins/core/` directory
- Update all references
- Final validation

---

## Backward Compatibility

### Breaking Changes
**Yes** - Plugin names change, command paths change

### Migration Strategy
1. **Announcement**: Document change in CHANGELOG.md
2. **Migration Guide**: Create MIGRATION.md
3. **Gradual Rollout**: Can keep both structures temporarily (not recommended - confusing)
4. **Clear Communication**: Explain rationale and benefits

### User Impact
- Users must update plugin enablement in settings
- Commands themselves unchanged (same names, same behavior)
- Only organizational change

---

## Testing Strategy

### Validation Checklist
- [ ] All 14 commands moved from core
- [ ] All plugin.json files updated
- [ ] No broken command references
- [ ] Plugin descriptions accurate
- [ ] README.md updated
- [ ] Documentation updated
- [ ] Migration guide created
- [ ] All commands tested individually
- [ ] Cross-plugin references verified

---

## Documentation Updates

### Files to Update
1. **README.md** - Plugin listing and descriptions
2. **docs/architecture/overview.md** - Plugin structure
3. **docs/getting-started/quick-start.md** - Plugin references
4. **Each plugin's README.md** - Command listings
5. **CHANGELOG.md** - Record reorganization
6. **MIGRATION.md** - User migration guide (new)

---

## Decision Log

### ML Plugin Split: Deferred to Implementation
**Decision**: Evaluate during TASK-008
**Rationale**:
- Pro: Cleaner development plugin
- Con: Only 3 commands, possibly too small
- Can decide when we see the reorganization in practice

### Core Plugin: Delete
**Decision**: Delete entirely, redistribute all commands
**Rationale**:
- "core" is meaningless name
- Better to have focused plugins
- Reviewer specifically called out this issue

### Agent Plugin: Create
**Decision**: New plugin for agent-related commands
**Rationale**:
- Agent and serena are meta-tools
- Distinct enough for separate plugin
- Room to grow (more agents in future)

---

## Success Metrics

### Pre-Reorganization
- ⚠️ 1 bloated plugin (14 commands, generic name)
- ⚠️ Poor discoverability
- ⚠️ Mixed concerns

### Post-Reorganization
- ✅ 6-7 focused plugins
- ✅ Clear, meaningful names
- ✅ Logical grouping by function
- ✅ Better user experience
- ✅ Addresses reviewer feedback

### Technical Review Impact
- Architecture: 4/5 → maintain (good design)
- Organization: Improved significantly
- User Experience: Better discoverability

---

## References

- **Technical Review**: REVIEW_COMPLETE_TECHNICAL_RESPONSE.md
- **Exploration**: .claude/work/current/009_review_feedback_iteration/exploration.md
- **Work Unit**: 009_review_feedback_iteration (TASK-006)

---

## Next Steps

1. ✅ Design complete (this document)
2. → TASK-007: Create new plugin structures
3. → TASK-008: Move commands to new plugins
4. → TASK-009: Update documentation
5. → TASK-010: Test refactored plugins

---

**Status**: ✅ Design Complete, Ready for Implementation
**Version**: 1.0.0
**Created**: 2025-10-18
**Approved By**: User (deferred build system, proceed with plugin refactoring)
