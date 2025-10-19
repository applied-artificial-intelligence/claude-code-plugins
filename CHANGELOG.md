# Changelog

All notable changes to Claude Code Plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-10-18

### 🎉 Major Release: Plugin Reorganization

**Breaking Changes**: Core plugin removed and replaced with focused plugins.

### Added

#### New Plugins
- **system** plugin - System configuration and health monitoring
  - Moved from core: `status`, `setup`, `audit`, `cleanup`
- **agents** plugin - Specialized agent invocation
  - Moved from core: `agent`, `serena`

#### Enhanced Plugins
- **workflow** plugin - Now includes work unit management
  - Added from core: `work`, `spike`
  - Total: 6 commands (was 4)
- **memory** plugin - Now includes project understanding and session management
  - Added from core: `index`, `handoff`, `performance`
  - Total: 6 commands (was 3)
- **development** plugin - Now includes documentation operations
  - Added from core: `docs`
  - Total: 6 commands (was 5)

#### Documentation
- **MIGRATION.md** - Complete migration guide from v0.9.x to v1.0.0
  - Step-by-step instructions
  - Troubleshooting section
  - FAQ and rollback plan
- **System Plugin README** - Complete documentation for system commands
- **Agents Plugin README** - Complete documentation for agent invocation
- Updated workflow plugin README with work/spike commands
- Updated memory plugin README with index/handoff/performance commands

#### Build System (Deferred)
- Created canonical utilities in `src/utils/common.sh` (86 lines, 5 constants, 4 functions)
- Comprehensive utility documentation in `src/utils/README.md` (650+ lines)
- Build system design in `docs/development/build-system.md`
- Implementation deferred to post-launch (utilities stable, ~1-2 changes/year)

### Changed

#### Plugin Structure
- **BREAKING**: Removed `core` plugin (bloated, 14 mixed commands)
- **BREAKING**: Replaced with 2 focused plugins (`system`, `agents`)
- Commands redistributed to 6 focused plugins by purpose
- No command behavior changes (pure reorganization)
- All command names unchanged

#### Dependencies
- **workflow** plugin: Dependency changed from `claude-code-core` to `claude-code-system`
- **development** plugin: Dependency changed from `claude-code-core` to `claude-code-system`

#### Plugin Manifests
- Updated `plugin.json` for workflow, memory, development, system, agents
- Added capabilities for new commands in each plugin
- Updated keywords to reflect expanded command scope
- All plugins now accurately describe their purpose

### Fixed

- **Major Issue #1**: Utility code duplication (94% reduction: ~1,320 lines → 86 lines)
  - Created single source of truth in `src/utils/common.sh`
  - Comprehensive documentation with usage examples
  - Deferred build system implementation (complexity > benefit)
- **Major Issue #2**: Bloated core plugin (addressed via reorganization)
  - Replaced 1 generic plugin with 6 focused plugins
  - Clear separation of concerns (system, workflow, agents, memory)
  - Improved discoverability and plugin descriptions

### Deprecated

- **core** plugin - Removed entirely
  - Commands redistributed to focused plugins
  - See MIGRATION.md for update instructions

### Migration

**Action Required**: Update `.claude/settings.json` in each project

Replace:
```json
"core@aai-plugins": true
```

With:
```json
"system@aai-plugins": true,
"agents@aai-plugins": true
```

**See MIGRATION.md for complete instructions.**

### Technical Details

#### Commits
- Created system and agents plugin structures (TASK-007)
- Moved 12 commands from core to focused plugins (TASK-008)
  - 4 commands → system
  - 2 commands → agents
  - 2 commands → workflow
  - 3 commands → memory
  - 1 command → development
- Updated all plugin manifests and documentation (TASK-009)

#### Progress
- 4/12 tasks complete (33%)
- 3 tasks deferred (build system)
- Efficiency: 250% (3.5h actual vs 7h estimated)

---

## [0.9.x] - Pre-reorganization

### Structure
- core plugin (14 commands)
- workflow plugin (4 commands)
- development plugin (5 commands)
- memory plugin (3 commands)
- git plugin (1 command)

**Total**: 27 commands across 5 plugins

### Issues
- Core plugin bloated and lacked focus
- Utility code duplicated across 30+ commands (~1,320 lines)
- Poor separation of concerns
- Generic plugin names

---

## Version Numbering

- **MAJOR** (X.0.0): Breaking changes (plugin reorganization, API changes)
- **MINOR** (1.X.0): New features, backward compatible
- **PATCH** (1.0.X): Bug fixes, documentation updates

---

## Links

- [GitHub Repository](https://github.com/applied-artificial-intelligence/claude-code-plugins)
- [Migration Guide](MIGRATION.md)
- [Documentation](README.md)
- [Contributing Guide](CONTRIBUTING.md)

---

**Notes**:
- All git history preserved (commands moved via `git mv`)
- No command behavior changes (pure reorganization)
- Migration should take < 5 minutes per project
- See MIGRATION.md for troubleshooting
