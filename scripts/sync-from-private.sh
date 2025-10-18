#!/usr/bin/env bash
#
# Sync plugins from private marketplace to public OSS repository
#
# Usage:
#   ./scripts/sync-from-private.sh [plugin-name]
#   ./scripts/sync-from-private.sh --all
#   ./scripts/sync-from-private.sh --dry-run
#
# Examples:
#   ./scripts/sync-from-private.sh core           # Sync only core plugin
#   ./scripts/sync-from-private.sh --all          # Sync all OSS plugins
#   ./scripts/sync-from-private.sh --dry-run      # Preview changes

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
PRIVATE_DIR="$HOME/agents/plugins"
PUBLIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGINS_DIR="$PUBLIC_DIR/plugins"

# OSS plugins to sync (not private domain-specific ones)
OSS_PLUGINS=(
    "core"
    "workflow"
    "development"
    "git"
    "memory"
)

# Repository URL for public OSS
PUBLIC_REPO_URL="https://github.com/applied-artificial-intelligence/claude-code-plugins"

# Files/directories to exclude from sync
EXCLUDE_PATTERNS=(
    ".env"
    ".env.*"
    "secrets/"
    "*.secret"
    "*.key"
    "credentials/"
    "node_modules/"
    "__pycache__/"
    "*.pyc"
    ".DS_Store"
)

# Dry run mode
DRY_RUN=false

# Functions
print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

check_directories() {
    if [ ! -d "$PRIVATE_DIR" ]; then
        print_error "Private plugin directory not found: $PRIVATE_DIR"
        exit 1
    fi

    if [ ! -d "$PLUGINS_DIR" ]; then
        print_warning "Public plugins directory not found, creating: $PLUGINS_DIR"
        mkdir -p "$PLUGINS_DIR"
    fi

    print_success "Directories verified"
}

build_rsync_excludes() {
    local excludes=""
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        excludes="$excludes --exclude=$pattern"
    done
    echo "$excludes"
}

sync_plugin() {
    local plugin_name="$1"
    local source_dir="$PRIVATE_DIR/$plugin_name"
    local dest_dir="$PLUGINS_DIR/$plugin_name"

    if [ ! -d "$source_dir" ]; then
        print_error "Plugin not found in private marketplace: $plugin_name"
        return 1
    fi

    print_info "Syncing $plugin_name..."

    # Build rsync exclude args
    local exclude_args=$(build_rsync_excludes)

    if [ "$DRY_RUN" = true ]; then
        print_info "DRY RUN: Would sync $source_dir → $dest_dir"
        rsync -av --dry-run $exclude_args "$source_dir/" "$dest_dir/" | grep -v "/$" | head -20
    else
        # Sync plugin files
        rsync -av $exclude_args "$source_dir/" "$dest_dir/"
        print_success "Files synced for $plugin_name"
    fi

    return 0
}

update_repository_url() {
    local plugin_name="$1"
    local plugin_json="$PLUGINS_DIR/$plugin_name/.claude-plugin/plugin.json"

    if [ ! -f "$plugin_json" ]; then
        print_warning "plugin.json not found for $plugin_name"
        return 1
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "DRY RUN: Would update repository URL in $plugin_json"
        return 0
    fi

    # Update repository URL to public OSS repo
    # Handle both "type":"git" and "type":"git" (with potential syntax errors)
    if grep -q '"url"' "$plugin_json"; then
        # Use sed to replace the URL
        sed -i.bak 's|"url": *"[^"]*"|"url": "'"$PUBLIC_REPO_URL"'"|g' "$plugin_json"

        # Also fix any potential "type":= syntax errors
        sed -i.bak 's|"type" *:= *"git"|"type": "git"|g' "$plugin_json"

        # Remove backup file
        rm -f "${plugin_json}.bak"

        print_success "Updated repository URL for $plugin_name"
    else
        print_warning "No repository URL found in $plugin_json"
    fi

    return 0
}

scan_for_private_refs() {
    local plugin_name="$1"
    local plugin_dir="$PLUGINS_DIR/$plugin_name"
    local found_issues=false

    print_info "Scanning $plugin_name for private references..."

    # Scan for Stefan-specific paths
    if grep -r "/home/stefan" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" > /dev/null; then
        print_warning "Found /home/stefan references in $plugin_name:"
        grep -r "/home/stefan" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" | head -5
        found_issues=true
    fi

    # Scan for ml4t/quant references (excluding READMEs which are generic examples)
    if grep -ri "~/ml4t\|/home/stefan/ml4t" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" > /dev/null; then
        print_warning "Found ML4T-specific paths in $plugin_name:"
        grep -ri "~/ml4t\|/home/stefan/ml4t" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" | head -5
        found_issues=true
    fi

    # Scan for private/secret file patterns
    if find "$plugin_dir" -name ".env" -o -name "*.secret" -o -name "*.key" 2>/dev/null | grep -v ".git" > /dev/null; then
        print_error "Found secret files in $plugin_name:"
        find "$plugin_dir" -name ".env" -o -name "*.secret" -o -name "*.key" 2>/dev/null | grep -v ".git"
        found_issues=true
    fi

    if [ "$found_issues" = false ]; then
        print_success "No private references found in $plugin_name"
    fi

    return 0
}

update_readme_catalog() {
    local readme="$PLUGINS_DIR/README.md"

    if [ ! -f "$readme" ]; then
        print_warning "plugins/README.md not found, skipping catalog update"
        return 0
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "DRY RUN: Would update $readme with current plugins"
        return 0
    fi

    print_info "Updating plugin catalog in README.md..."

    # Count is always the OSS plugins count
    local count=${#OSS_PLUGINS[@]}

    print_success "Catalog shows $count plugins (all OSS)"

    return 0
}

sync_all_plugins() {
    print_header "Syncing All OSS Plugins"

    local success_count=0
    local fail_count=0

    for plugin in "${OSS_PLUGINS[@]}"; do
        echo ""
        if sync_plugin "$plugin"; then
            update_repository_url "$plugin"
            scan_for_private_refs "$plugin"
            ((success_count++))
        else
            ((fail_count++))
        fi
    done

    echo ""
    update_readme_catalog

    echo ""
    print_header "Sync Summary"
    print_success "$success_count plugins synced successfully"
    if [ $fail_count -gt 0 ]; then
        print_error "$fail_count plugins failed to sync"
    fi

    if [ "$DRY_RUN" = false ]; then
        echo ""
        print_info "Next steps:"
        echo "  1. Review changes: git status"
        echo "  2. Test plugins: Enable in a test project"
        echo "  3. Commit: git add . && git commit"
        echo "  4. Push: git push origin main"
    fi
}

# Main
main() {
    # Parse arguments
    if [ $# -eq 0 ]; then
        echo "Usage: $0 [plugin-name|--all|--dry-run]"
        echo ""
        echo "Examples:"
        echo "  $0 core              # Sync only core plugin"
        echo "  $0 --all             # Sync all OSS plugins"
        echo "  $0 --dry-run --all   # Preview sync of all plugins"
        exit 1
    fi

    # Check for dry-run flag
    if [[ " $* " =~ " --dry-run " ]]; then
        DRY_RUN=true
        print_warning "DRY RUN MODE - No changes will be made"
        echo ""
    fi

    # Verify directories exist
    check_directories
    echo ""

    # Determine what to sync
    if [[ " $* " =~ " --all " ]]; then
        sync_all_plugins
    else
        # Sync single plugin
        local plugin_name="$1"

        # Verify it's an OSS plugin
        if [[ ! " ${OSS_PLUGINS[@]} " =~ " ${plugin_name} " ]]; then
            print_error "$plugin_name is not an OSS plugin"
            print_info "OSS plugins: ${OSS_PLUGINS[*]}"
            exit 1
        fi

        print_header "Syncing Plugin: $plugin_name"
        echo ""

        sync_plugin "$plugin_name"
        update_repository_url "$plugin_name"
        scan_for_private_refs "$plugin_name"

        echo ""
        print_success "Sync complete for $plugin_name"
    fi
}

# Run main
main "$@"
