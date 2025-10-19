# Build System Architecture

**Purpose**: Eliminate utility code duplication while maintaining command self-containment
**Version**: 1.0.0
**Status**: Design Complete
**Created**: 2025-10-18

---

## Problem Statement

### Current Situation
- **Utility Duplication**: ~44 lines of bash utilities duplicated across 30+ commands
- **Maintenance Burden**: Bug fixes require manual patching in every command file
- **Consistency Risk**: Easy for utilities to drift across different commands
- **Developer Friction**: Contributors must copy/paste utilities for new commands

### Root Cause
Commands execute in the user's project directory (not the plugin directory), making `source ../utils.sh` impossible. Claude Code's execution model requires each command to be entirely self-contained.

### Technical Review Feedback
> "This is a **critical maintainability liability**. A bug in error_exit must be patched in 20+ files."
> — External Technical Reviewer (⭐⭐⭐⭐ 4/5 rating)

**Proposed Solution**: Build-time preprocessor

---

## Architecture Overview

### Design Philosophy
1. **Single Source of Truth**: One canonical utility file in development
2. **Self-Contained at Runtime**: Commands remain independent after build
3. **Developer Workflow**: Edit canonical utilities, build injects into commands
4. **Zero Runtime Cost**: No performance impact, no additional dependencies

### High-Level Flow

```
Development (Source)              Build Process               Distribution (Output)
─────────────────────            ─────────────────           ─────────────────────

src/utils/common.sh              scripts/build.sh            plugins/*/commands/*.md
(canonical utilities)            (preprocessor)              (self-contained)
                                        │
src/commands/*.md                       │
(source with markers)                   │
         │                              ▼
         └─────────────────────►  Injection Process
                                        │
                                        ▼
                                plugins/*/commands/*.md
                                (built with injected utils)
```

---

## Directory Structure

### Proposed Structure

```
claude-code-plugins/
├── src/                              # Development source
│   ├── utils/
│   │   ├── common.sh                 # Canonical utilities (single source of truth)
│   │   └── README.md                 # Utility documentation
│   └── commands/                     # Source commands (optional - see "Implementation Options")
│       └── *.md                      # Commands with <!-- INJECT_UTILITIES --> markers
│
├── scripts/                          # Build tooling
│   ├── build.sh                      # Main build script (preprocessor)
│   ├── test-build.sh                 # Validation script
│   ├── extract-utils.sh              # Extract utils from existing commands (one-time)
│   └── README.md                     # Build system usage guide
│
├── plugins/                          # Distribution output (git-committed)
│   ├── system/commands/*.md          # Built commands (self-contained)
│   ├── workflow/commands/*.md
│   ├── memory/commands/*.md
│   ├── development/commands/*.md
│   └── .../
│
└── docs/
    └── development/
        ├── build-system.md           # This document
        └── contributing.md           # Updated contributor guide
```

### Implementation Options

**Option A: In-Place Injection** (Recommended for v1.0)
- Source commands: `plugins/*/commands/*.md` (with markers)
- Build: Inject utilities directly into existing files
- Git: Commit built files (with injected utilities)
- Pro: Simpler migration, fewer directories
- Con: Source and built files are the same

**Option B: Separate Source Directory**
- Source commands: `src/commands/*.md` (with markers)
- Build: Generate to `plugins/*/commands/*.md`
- Git: Commit only built files OR both source and built
- Pro: Clear separation of source vs built
- Con: More complex migration, duplicate file structure

**Decision**: Start with **Option A** for simplicity. Can evolve to Option B in v2.0 if needed.

---

## Injection Mechanism

### Marker Syntax

#### In Source Commands (*.md files)
```markdown
---
name: status
description: Show system status
---

# Status Command

## Implementation

```bash
#!/bin/bash

<!-- INJECT_UTILITIES -->

# Command-specific code starts here
echo "📦 Status Report"
# ... rest of command logic
```

### Canonical Utilities (src/utils/common.sh)

```bash
#!/bin/bash
# Claude Code Common Utilities
# Version: 1.0.0
# WARNING: This file is injected into commands during build.
#          DO NOT modify utilities in individual commands.
#          Edit this file and run scripts/build.sh.

# Standard constants
readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"
readonly WORK_CURRENT="${WORK_DIR}/current"
readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
readonly TRANSITIONS_DIR="${CLAUDE_DIR}/transitions"

# Error handling functions
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

warn() {
    echo "WARNING: $1" >&2
}

debug() {
    [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
}

# Safe directory creation
safe_mkdir() {
    local dir="$1"
    mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
}

# Tool requirement check
require_tool() {
    local tool="$1"
    if ! command -v "$tool" >/dev/null 2>&1; then
        error_exit "$tool is required but not installed"
    fi
}

# End of injected utilities
```

### Build Process

#### scripts/build.sh
```bash
#!/bin/bash
set -euo pipefail

# Build script for claude-code-plugins
# Injects canonical utilities into command markdown files

readonly SRC_UTILS="src/utils/common.sh"
readonly PLUGINS_DIR="plugins"
readonly MARKER="<!-- INJECT_UTILITIES -->"

echo "🔨 Building claude-code-plugins"
echo "════════════════════════════════"

# Validate canonical utilities exist
if [ ! -f "$SRC_UTILS" ]; then
    echo "ERROR: Canonical utilities not found: $SRC_UTILS" >&2
    exit 1
fi

# Read canonical utilities (skip shebang and comments)
UTILS_CONTENT=$(grep -v '^#!/bin/bash' "$SRC_UTILS" | grep -v '^# End of injected utilities')

# Find all command markdown files
COMMAND_FILES=$(find "$PLUGINS_DIR" -name "*.md" -path "*/commands/*")
TOTAL=$(echo "$COMMAND_FILES" | wc -l)
PROCESSED=0
UPDATED=0

echo "Found $TOTAL command files"
echo ""

for cmd_file in $COMMAND_FILES; do
    PROCESSED=$((PROCESSED + 1))

    # Check if file contains injection marker
    if grep -q "$MARKER" "$cmd_file"; then
        echo "[$PROCESSED/$TOTAL] Injecting: $(basename "$cmd_file")"

        # Create temporary file with injected utilities
        awk -v marker="$MARKER" -v utils="$UTILS_CONTENT" '
            {
                if ($0 ~ marker) {
                    print utils
                } else {
                    print $0
                }
            }
        ' "$cmd_file" > "${cmd_file}.tmp"

        # Replace original file
        mv "${cmd_file}.tmp" "$cmd_file"
        UPDATED=$((UPDATED + 1))
    else
        echo "[$PROCESSED/$TOTAL] Skipping: $(basename "$cmd_file") (no marker)"
    fi
done

echo ""
echo "✅ Build complete"
echo "   Processed: $TOTAL files"
echo "   Updated: $UPDATED files"
```

---

## Developer Workflow

### Initial Setup (One-Time)

1. **Extract Canonical Utilities**
   ```bash
   # Run extraction script to create src/utils/common.sh from existing commands
   scripts/extract-utils.sh
   ```

2. **Add Injection Markers**
   ```bash
   # Add <!-- INJECT_UTILITIES --> to all command files
   # Remove duplicated utility code
   # (See TASK-004 for detailed process)
   ```

3. **Initial Build**
   ```bash
   # Inject utilities into all commands
   scripts/build.sh
   ```

4. **Validate**
   ```bash
   # Test all commands work with injected utilities
   scripts/test-build.sh
   ```

### Ongoing Development

#### Editing Utilities
```bash
# 1. Edit canonical utilities
vim src/utils/common.sh

# 2. Rebuild all commands
scripts/build.sh

# 3. Test
scripts/test-build.sh

# 4. Commit (includes built files with injected utilities)
git add src/utils/common.sh plugins/*/commands/*.md
git commit -m "fix: Update error_exit utility to handle edge case"
```

#### Creating New Commands
```bash
# 1. Create command file in appropriate plugin
cat > plugins/system/commands/mynew.md << 'EOF'
---
name: mynew
description: My new command
---

# My New Command

## Implementation

```bash
#!/bin/bash

<!-- INJECT_UTILITIES -->

# Your command logic here
echo "Hello, World!"
```
EOF

# 2. Build (injects utilities automatically)
scripts/build.sh

# 3. Test
# (command is now self-contained and ready to use)
```

#### Modifying Commands
```bash
# Just edit command-specific logic below <!-- INJECT_UTILITIES -->
# DO NOT modify injected utilities in individual commands
# Rebuild automatically injects latest utilities
vim plugins/system/commands/status.md
scripts/build.sh
```

---

## Build Script Details

### scripts/build.sh

**Responsibilities**:
1. Validate canonical utilities exist
2. Read utilities content (excluding shebang and markers)
3. Find all command markdown files
4. For each file with `<!-- INJECT_UTILITIES -->`:
   - Replace marker with utilities content
   - Preserve all other content
5. Report build statistics

**Features**:
- Dry-run mode: `--dry-run` to preview without modifying files
- Verbose mode: `--verbose` for detailed logging
- Validation: Ensure all markers found and replaced
- Error handling: Exit on any failure

**Usage**:
```bash
scripts/build.sh                 # Standard build
scripts/build.sh --dry-run       # Preview changes
scripts/build.sh --verbose       # Detailed logging
```

### scripts/test-build.sh

**Responsibilities**:
1. Verify all commands have utilities injected correctly
2. Check for any remaining utility duplication
3. Validate bash syntax of all commands
4. Test self-containment (commands run independently)

**Tests**:
- **Syntax Check**: All bash blocks are syntactically valid
- **Injection Verification**: All markers replaced with utilities
- **No Duplication**: No old utility code remains
- **Self-Containment**: Commands don't reference external files
- **Consistency**: All utilities match canonical source

**Usage**:
```bash
scripts/test-build.sh            # Run all validation tests
```

### scripts/extract-utils.sh

**Purpose**: One-time extraction of canonical utilities from existing commands

**Process**:
1. Analyze all existing commands
2. Identify common utility patterns
3. Extract most complete version of each utility
4. Generate `src/utils/common.sh`
5. Create backup of original files

**Usage** (run once during migration):
```bash
scripts/extract-utils.sh
# Review generated src/utils/common.sh
# Adjust if needed
# Then run build.sh
```

---

## Migration Plan

### Phase 1: Extract and Validate (TASK-002)
1. Create `src/utils/` directory
2. Run `scripts/extract-utils.sh`
3. Review and refine `src/utils/common.sh`
4. Version: 1.0.0

### Phase 2: Build Tooling (TASK-003)
1. Create `scripts/build.sh` preprocessor
2. Create `scripts/test-build.sh` validator
3. Test on sample commands
4. Validate injection works correctly

### Phase 3: Command Migration (TASK-004)
1. Add `<!-- INJECT_UTILITIES -->` to all 30 commands
2. Remove duplicated utility code below marker
3. Run `scripts/build.sh`
4. Verify each command individually

### Phase 4: Validation (TASK-005)
1. Run `scripts/test-build.sh`
2. Test all commands in isolation
3. Verify no behavior changes
4. Cross-platform testing (macOS, Linux)

---

## Testing Strategy

### Unit Tests
- Each utility function tested independently
- Edge cases and boundary conditions
- Error handling scenarios

### Integration Tests
- Commands work with injected utilities
- No conflicts between utilities and command code
- Cross-command consistency

### Self-Containment Tests
- Commands run without external dependencies
- No `source` statements to external files
- All utilities present in each command

### Regression Tests
- All commands behave identically pre/post migration
- No functionality changes
- Same outputs for same inputs

### Cross-Platform Tests
- Works on macOS (BSD bash/utils)
- Works on Linux (GNU bash/utils)
- Portable shell constructs only

---

## Rollback Plan

If issues discovered during migration:

### Option 1: Rollback to Pre-Build State
```bash
git revert <build-commit>
# All commands revert to duplicated utilities
```

### Option 2: Fix Forward
```bash
# Fix issue in src/utils/common.sh
# Rebuild all commands
scripts/build.sh
# Test and commit fix
```

### Option 3: Selective Rollback
```bash
# Revert specific commands to pre-build state
git checkout HEAD~1 -- plugins/system/commands/problematic.md
```

---

## Success Metrics

### Pre-Migration Baseline
- ⚠️ Utility duplication: ~44 lines × 30 commands = ~1,320 duplicated lines
- ⚠️ Maintenance: Bug fixes require 30 manual edits
- ⚠️ Consistency: Utilities can drift across commands
- ⚠️ Developer experience: Must copy/paste utilities for new commands

### Post-Migration Target
- ✅ Single source of truth: 1 file (`src/utils/common.sh`)
- ✅ Maintenance: Bug fixes require 1 edit + rebuild
- ✅ Consistency: All utilities guaranteed identical
- ✅ Developer experience: Add marker, build auto-injects
- ✅ Self-containment: Commands remain independent at runtime
- ✅ No behavior changes: All commands work identically

### Technical Review Impact
- **Architecture**: 4/5 → 5/5 (single source of truth)
- **Extensibility**: 3/5 → 4/5 (easier plugin development)
- **Production Readiness**: 4/5 → 5/5 (maintenance solved)
- **Overall**: 4.2/5 → 4.6/5

---

## Future Enhancements (v2.0)

### Potential Improvements
1. **Modular Utilities**: Split `common.sh` into categories (errors, git, work, memory)
2. **Selective Injection**: Commands specify which utilities they need
3. **Utility Versioning**: Track utility versions per command
4. **Pre-commit Hook**: Automatically rebuild on commit
5. **CI/CD Integration**: Validate builds in continuous integration
6. **Source Separation**: Move to `src/commands/` structure (Option B)

### Not Planned (Complexity vs Benefit)
- ❌ Runtime loading (violates self-containment)
- ❌ Dynamic sourcing (execution context prevents this)
- ❌ Shared library file (can't source across directories)

---

## Documentation Updates

### Files to Update
1. **docs/development/contributing.md**: Add build system workflow
2. **docs/architecture/overview.md**: Document build process
3. **README.md**: Mention build system in development section
4. **CHANGELOG.md**: Record build system addition

### New Documentation
1. **src/utils/README.md**: Utility reference and guidelines
2. **scripts/README.md**: Build script usage guide
3. **This file**: Complete build system architecture

---

## References

### Related Work
- **TASK-001**: Design Build System Architecture (this document)
- **TASK-002**: Create Canonical Utilities
- **TASK-003**: Implement Build Script
- **TASK-004**: Update All Commands with Markers
- **TASK-005**: Test Build System

### Technical Review
- **Reviewer Recommendation**: "Implement a build-time pre-processor"
- **Issue Severity**: MAJOR (fix soon after launch)
- **Impact Area**: Maintainability, consistency, developer experience

### Constraints
- **Self-Containment**: Commands must work in isolation (Claude Code requirement)
- **Execution Context**: Commands run in project directory, not plugin directory
- **Backward Compatibility**: Existing users shouldn't notice any changes

---

## Conclusion

This build system architecture solves the utility duplication problem while respecting Claude Code's execution constraints. It provides:

1. **Single Source of Truth**: One canonical utilities file
2. **Zero Runtime Cost**: Commands remain self-contained
3. **Developer Friendly**: Simple workflow (edit, build, test)
4. **Maintainable**: Bug fixes in one place
5. **Production Ready**: No breaking changes for users

**Next Steps**:
1. ✅ Architecture design complete (TASK-001)
2. → Create canonical utilities (TASK-002)
3. → Implement build script (TASK-003)
4. → Migrate all commands (TASK-004)
5. → Validate and test (TASK-005)

---

**Status**: ✅ Design Complete, Ready for Implementation
**Version**: 1.0.0
**Created**: 2025-10-18
**Work Unit**: 009_review_feedback_iteration
