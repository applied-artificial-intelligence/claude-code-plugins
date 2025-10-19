#!/bin/bash
# Claude Code Common Utilities
# Version: 1.0.0
#
# WARNING: This file is the single source of truth for command utilities.
#          DO NOT modify utilities in individual command files.
#          Edit this file and run `scripts/build.sh` to inject into all commands.
#
# This file is injected into command markdown files during the build process
# via the <!-- INJECT_UTILITIES --> marker.

# ============================================================================
# STANDARD CONSTANTS
# ============================================================================
# These paths define the Claude Code framework structure and are used
# throughout all commands for consistent file organization.

readonly CLAUDE_DIR=".claude"
readonly WORK_DIR="${CLAUDE_DIR}/work"
readonly WORK_CURRENT="${WORK_DIR}/current"
readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
readonly TRANSITIONS_DIR="${CLAUDE_DIR}/transitions"

# ============================================================================
# ERROR HANDLING FUNCTIONS
# ============================================================================

# error_exit: Print error message to stderr and exit with status 1
# Usage: error_exit "Error message"
# Example: error_exit "Configuration file not found"
error_exit() {
    echo "ERROR: $1" >&2
    exit 1
}

# warn: Print warning message to stderr (does not exit)
# Usage: warn "Warning message"
# Example: warn "Deprecated feature used"
warn() {
    echo "WARNING: $1" >&2
}

# debug: Print debug message to stderr if DEBUG=true
# Usage: debug "Debug message"
# Example: DEBUG=true command.md  # Shows debug output
debug() {
    [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
}

# ============================================================================
# FILE SYSTEM UTILITIES
# ============================================================================

# safe_mkdir: Create directory with error handling
# Usage: safe_mkdir "/path/to/directory"
# Example: safe_mkdir "${WORK_DIR}/new_unit"
# Exits with error if directory creation fails
safe_mkdir() {
    local dir="$1"
    mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
}

# ============================================================================
# TOOL REQUIREMENT CHECKS
# ============================================================================

# require_tool: Check if required command-line tool is installed
# Usage: require_tool "toolname"
# Example: require_tool "jq"  # Ensures jq is available
# Exits with error if tool is not found in PATH
require_tool() {
    local tool="$1"
    if ! command -v "$tool" >/dev/null 2>&1; then
        error_exit "$tool is required but not installed"
    fi
}

# End of injected utilities
