# Migration Guide: v0.9.x → v1.0.0

**Plugin Reorganization: Core Plugin Split into Focused Plugins**

This guide helps you migrate from the old plugin structure (with bloated `core` plugin) to the new organized structure with 6 focused plugins.

---

## Summary of Changes

### What Changed

**Old Structure** (v0.9.x):
- ❌ `core` plugin - 14 mixed commands (system, workflow, agents, memory)
- ✅ `workflow` plugin - 4 commands
- ✅ `development` plugin - 5 commands
- ✅ `memory` plugin - 3 commands
- ✅ `git` plugin - 1 command

**New Structure** (v1.0.0):
- ✅ `system` plugin - 4 commands (system configuration and health)
- ✅ `workflow` plugin - 6 commands (development workflow)
- ✅ `development` plugin - 6 commands (code quality)
- ✅ `agents` plugin - 2 commands (agent invocation)
- ✅ `memory` plugin - 6 commands (knowledge and context)
- ✅ `git` plugin - 1 command (version control)

### What Stayed the Same

✅ **Command Names**: All commands have the same names (`/status`, `/work`, `/agent`, etc.)
✅ **Command Behavior**: All commands work exactly the same way
✅ **Command Arguments**: All arguments and options unchanged
✅ **Work Units**: Existing work units continue to function
✅ **Memory Files**: Memory structure unchanged

---

## Breaking Changes

### Plugin Names

You need to update plugin references in your configuration:

**`.claude/settings.json` - BEFORE**:
```json
{
  "enabledPlugins": {
    "core@aai-plugins": true,
    "workflow@aai-plugins": true,
    "development@aai-plugins": true,
    "memory@aai-plugins": true,
    "git@aai-plugins": true
  }
}
```

**`.claude/settings.json` - AFTER**:
```json
{
  "enabledPlugins": {
    "system@aai-plugins": true,
    "workflow@aai-plugins": true,
    "development@aai-plugins": true,
    "agents@aai-plugins": true,
    "memory@aai-plugins": true,
    "git@aai-plugins": true
  }
}
```

### Command Migration Map

All commands moved to new locations but keep the same names:

| Command | Old Plugin | New Plugin | Notes |
|---------|-----------|-----------|-------|
| `/status` | core | **system** | System status view |
| `/setup` | core | **system** | Project initialization |
| `/audit` | core | **system** | Framework compliance |
| `/cleanup` | core | **system** | Cleanup operations |
| `/work` | core | **workflow** | Work unit management |
| `/spike` | core | **workflow** | Time-boxed exploration |
| `/agent` | core | **agents** | Agent invocation |
| `/serena` | core | **agents** | Semantic code understanding |
| `/index` | core | **memory** | Project indexing |
| `/handoff` | core | **memory** | Session transitions |
| `/performance` | core | **memory** | Performance metrics |
| `/docs` | core | **development** | Documentation operations |

---

## Migration Steps

### Step 1: Update Plugin Configuration

**Required Action**: Update `.claude/settings.json` in each project

1. Open `.claude/settings.json`
2. Replace `"core@aai-plugins": true` with:
   ```json
   "system@aai-plugins": true,
   "agents@aai-plugins": true
   ```
3. Save file

**Before**:
```json
{
  "enabledPlugins": {
    "core@aai-plugins": true
  }
}
```

**After**:
```json
{
  "enabledPlugins": {
    "system@aai-plugins": true,
    "agents@aai-plugins": true
  }
}
```

### Step 2: Pull Latest Changes

**Required Action**: Update plugin installation

```bash
cd /path/to/claude-code-plugins
git pull origin main
```

All command files have been moved (using `git mv`) so history is preserved.

### Step 3: Restart Claude Code

**Required Action**: Restart for new plugin structure to load

```bash
# In Claude Code:
/help  # Verify new plugins loaded correctly
```

You should see:
- ✅ `system` plugin commands
- ✅ `agents` plugin commands
- ❌ No `core` plugin (removed)

### Step 4: Verify Commands Work

**Recommended**: Test commands in each new plugin

```bash
# System plugin
/status              # Should work (now in system plugin)

# Workflow plugin
/work                # Should work (now in workflow plugin)

# Agents plugin
/agent architect "test invocation"  # Should work (now in agents plugin)

# Memory plugin
/performance         # Should work (now in memory plugin)
```

---

## Troubleshooting

### "Plugin not found: core"

**Problem**: Claude Code can't find the `core` plugin (it's been removed)

**Solution**: Update `.claude/settings.json` to use `system` and `agents` instead of `core`

```json
// Remove this:
"core@aai-plugins": true

// Add these:
"system@aai-plugins": true,
"agents@aai-plugins": true
```

### "/status command not found"

**Problem**: Commands not loading from new plugins

**Solutions**:
1. Verify `.claude/settings.json` enables `system@aai-plugins`
2. Restart Claude Code
3. Run `/help` to see available commands
4. Check plugin installation: `ls ~/path/to/claude-code-plugins/plugins/`

### "Unknown command /work"

**Problem**: Workflow plugin not loading the new commands

**Solution**:
1. Verify `.claude/settings.json` enables `workflow@aai-plugins`
2. Restart Claude Code
3. `workflow` plugin now includes `/work` and `/spike` (moved from core)

### Existing work units broken

**Problem**: Work units created before migration reference old plugin structure

**Solution**: Work units should continue to function normally. If issues occur:
1. Check `.claude/work/current/` for your work units
2. Verify `state.json` files are intact
3. Run `/status` to see active work
4. Continue with `/next` as normal

### Commands behave differently

**Not Expected**: Commands should behave identically

**If this happens**:
1. Check you're on v1.0.0: `git log -1` in plugin repo
2. Report issue: https://github.com/applied-artificial-intelligence/claude-code-plugins/issues
3. Include: command name, expected behavior, actual behavior

---

## FAQ

### Do I need to recreate my work units?

**No**. Existing work units in `.claude/work/current/` continue to work without changes.

### Will my memory files still load?

**Yes**. Memory structure (`.claude/memory/`) is unchanged. All memory files continue to load.

### Are command names changing?

**No**. All commands keep the same names. Only the plugin they belong to changed.

### Do I need to update my hooks?

**Maybe**. If your hooks reference plugin names (e.g., `@core/status`), update to new plugin names (`@system/status`).

### Can I keep using v0.9.x?

**Not recommended**. The `core` plugin is deleted in v1.0.0. Staying on v0.9.x means:
- No future updates
- Missing bug fixes
- Can't get support

### What about custom plugins that depend on core?

**Action Required**: Update plugin.json dependencies:

**Before**:
```json
"dependencies": {
  "claude-code-core": "^1.0.0"
}
```

**After**:
```json
"dependencies": {
  "claude-code-system": "^1.0.0"
}
```

Most dependencies on `core` should reference `system` instead (for status, setup, audit).

---

## Rollback Plan

If you encounter issues and need to rollback:

### Rollback to v0.9.x

```bash
cd /path/to/claude-code-plugins
git checkout v0.9.x  # (tag for last v0.9.x release)
```

Then revert `.claude/settings.json`:
```json
{
  "enabledPlugins": {
    "core@aai-plugins": true
  }
}
```

### Report Issue

Please report any migration problems:
- **GitHub Issues**: https://github.com/applied-artificial-intelligence/claude-code-plugins/issues
- **Include**: Error message, steps to reproduce, environment details

---

## Benefits of New Structure

After migration, you'll benefit from:

✅ **Better Organization**: Commands grouped by purpose (system, workflow, agents, memory)
✅ **Clearer Documentation**: Each plugin has focused README
✅ **Easier Discovery**: Plugin names describe what they do
✅ **Better Separation**: System operations separate from workflow operations
✅ **Extensibility**: Clear patterns for adding new plugins

---

## Support

Need help with migration?

- **Documentation**: https://github.com/applied-artificial-intelligence/claude-code-plugins
- **Issues**: https://github.com/applied-artificial-intelligence/claude-code-plugins/issues
- **Discussions**: https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions

---

**Migration should take < 5 minutes per project**

1. Update `.claude/settings.json` (replace `core` with `system` + `agents`)
2. Pull latest changes (`git pull`)
3. Restart Claude Code
4. Verify commands work (`/status`, `/work`, `/agent`, `/performance`)

**That's it!** All your work units, memory, and workflows continue working.
