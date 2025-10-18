# Installation Guide

Get Claude Code Plugins up and running in minutes.

## Prerequisites

Before installing Claude Code Plugins, ensure you have:

### Required

- **Claude Code** v3.0 or later
  - Check your version: Open Claude Code and check the About section
  - Update if needed: Claude Code auto-updates to latest version

- **Operating System**: Linux, macOS, or Windows (WSL recommended)
  - Linux: Most distributions supported
  - macOS: 10.15 (Catalina) or later
  - Windows: WSL 2 with Ubuntu 20.04+ recommended

- **Git** v2.0 or later
  ```bash
  git --version
  # Should show: git version 2.x.x or later
  ```

### Optional but Recommended

- **GitHub CLI** (`gh`) - For pull request and issue management
  ```bash
  # macOS
  brew install gh

  # Linux (Debian/Ubuntu)
  sudo apt install gh

  # Linux (other distributions)
  # See: https://github.com/cli/cli#installation

  # Verify installation
  gh --version

  # Authenticate
  gh auth login
  ```

- **jq** - JSON processor for better command output
  ```bash
  # macOS
  brew install jq

  # Linux (Debian/Ubuntu)
  sudo apt install jq

  # Verify
  jq --version
  ```

- **Node.js** v16+ - For some development plugins
  ```bash
  # macOS
  brew install node

  # Linux
  # See: https://nodejs.org/en/download/package-manager

  # Verify
  node --version
  npm --version
  ```

## Installation Methods

### Method 1: GitHub Installation (Recommended)

Install directly from the GitHub repository marketplace.

#### Step 1: Add Marketplace to Settings

Create or update your Claude Code settings file:

**Location**: `~/.claude/settings.json` (global) or `.claude/settings.json` (project-specific)

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  }
}
```

#### Step 2: Enable Plugins

Add the plugins you want to enable:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "development@claude-code-plugins": true,
    "git@claude-code-plugins": true,
    "memory@claude-code-plugins": true
  }
}
```

#### Step 3: Restart Claude Code

Close and reopen Claude Code to load the plugins.

### Method 2: Local Directory Installation

Install from a local directory (useful for development or testing).

#### Step 1: Clone Repository

```bash
# Choose installation location
cd ~/projects  # or wherever you prefer

# Clone the repository
git clone https://github.com/applied-artificial-intelligence/claude-code-plugins.git

# Verify structure
ls claude-code-plugins/plugins
# Should show: core development git memory workflow
```

#### Step 2: Configure Settings

Update your settings to point to the local directory:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins-local": {
      "source": {
        "source": "directory",
        "path": "/full/path/to/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins-local": true,
    "workflow@claude-code-plugins-local": true,
    "development@claude-code-plugins-local": true,
    "git@claude-code-plugins-local": true,
    "memory@claude-code-plugins-local": true
  }
}
```

**Important**: Use **absolute path** (not `~/` or relative paths).

#### Step 3: Restart Claude Code

Close and reopen Claude Code to load the plugins from local directory.

### Method 3: Project-Specific Installation

Install plugins for a single project only.

#### Step 1: Create Project Settings

In your project directory, create `.claude/settings.json`:

```bash
cd /path/to/your/project
mkdir -p .claude
```

#### Step 2: Configure Project Settings

Create `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true
  }
}
```

**Note**: Project settings override global settings. Plugins enabled here will only work in this project.

## Configuration

### Minimal Configuration

Bare minimum to get started (enables all 5 core plugins):

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "development@claude-code-plugins": true,
    "git@claude-code-plugins": true,
    "memory@claude-code-plugins": true
  }
}
```

### Selective Plugin Configuration

Enable only the plugins you need:

**Example 1: Workflow Only**
```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true
  }
}
```

**Example 2: Development Tools Only**
```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "development@claude-code-plugins": true
  }
}
```

**Note**: The `core` plugin is recommended for all configurations as it provides essential system functionality.

### Advanced Configuration

#### Custom Plugin Settings

Some plugins accept configuration options:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "development@claude-code-plugins": true,
    "git@claude-code-plugins": true,
    "memory@claude-code-plugins": true
  },
  "pluginSettings": {
    "core@claude-code-plugins": {
      "performance": {
        "tokenWarningThreshold": 0.8,
        "tokenCriticalThreshold": 0.9
      }
    },
    "workflow@claude-code-plugins": {
      "explore": {
        "defaultThoroughness": "medium"
      }
    },
    "memory@claude-code-plugins": {
      "autoReflection": true,
      "staleThresholdDays": 30
    }
  }
}
```

#### Multiple Marketplaces

Use plugins from multiple sources:

```json
{
  "extraKnownMarketplaces": {
    "claude-code-plugins": {
      "source": {
        "source": "github",
        "repo": "applied-artificial-intelligence/claude-code-plugins"
      }
    },
    "my-custom-plugins": {
      "source": {
        "source": "directory",
        "path": "/home/user/my-plugins"
      }
    }
  },
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    "workflow@claude-code-plugins": true,
    "my-plugin@my-custom-plugins": true
  }
}
```

## Verification

### Step 1: Check Plugin Loading

Open Claude Code in your project and start a new conversation. Claude should acknowledge the loaded plugins.

### Step 2: Test a Command

Try running a simple command:

```bash
/status
```

**Expected Output**:
```
Project Status
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Project Directory: /path/to/your/project
Claude Code Version: v3.x.x
Plugins Loaded: 5

Core Systems:
✓ Commands: 25 available
✓ Agents: 6 available
✓ Memory: Active

...
```

If you see this output, plugins are successfully installed! ✅

### Step 3: List Available Commands

Check all available commands:

```bash
/help
```

You should see commands from all enabled plugins:
- **core**: /status, /work, /agent, /cleanup, /index, /performance, /handoff, /docs, /setup, /audit, /serena, /spike
- **workflow**: /explore, /plan, /next, /ship
- **development**: /analyze, /test, /fix, /run, /review
- **git**: /git
- **memory**: /memory-review, /memory-update, /memory-gc

### Step 4: Test Plugin Integration

Try a workflow command:

```bash
/explore "Test the plugins installation"
```

If the command runs and creates exploration output, your installation is complete! 🎉

## Troubleshooting

### Plugins Not Loading

**Symptom**: Commands like `/status` or `/explore` not recognized

**Solutions**:

1. **Check settings file location**
   ```bash
   # Global settings
   ls ~/.claude/settings.json

   # Project settings
   ls .claude/settings.json
   ```

2. **Validate JSON syntax**
   ```bash
   # Use jq to validate
   jq . ~/.claude/settings.json
   # Should output formatted JSON with no errors
   ```

3. **Restart Claude Code completely**
   - Close all Claude Code windows
   - Wait 5 seconds
   - Reopen Claude Code

4. **Check Claude Code version**
   - Requires v3.0 or later
   - Update Claude Code if needed

### Commands Return Errors

**Symptom**: Commands run but return "command not found" or "file not found" errors

**Solutions**:

1. **Verify marketplace path**
   - GitHub source: Check repository exists and is public
   - Directory source: Verify absolute path is correct
   - Test with `ls <path>/plugins`

2. **Check plugin structure**
   ```bash
   # Verify plugin structure
   ls <marketplace-path>/plugins/core/.claude-plugin/
   # Should show: plugin.json
   ```

3. **Verify plugin.json format**
   ```bash
   jq . <marketplace-path>/plugins/core/.claude-plugin/plugin.json
   # Should be valid JSON
   ```

### Permission Errors

**Symptom**: "Permission denied" when running commands

**Solutions**:

1. **Check file permissions**
   ```bash
   # Plugin commands should be readable
   ls -la ~/claude-code-plugins/plugins/core/commands/
   # All .md files should be readable (r--)
   ```

2. **Fix permissions if needed**
   ```bash
   chmod -R u+r ~/claude-code-plugins/plugins/
   ```

### GitHub Authentication Errors

**Symptom**: Cannot access GitHub marketplace or "authentication required" errors

**Solutions**:

1. **Verify GitHub access**
   ```bash
   gh auth status
   # Should show: Logged in to github.com as <username>
   ```

2. **Re-authenticate if needed**
   ```bash
   gh auth login
   # Follow prompts to authenticate
   ```

3. **Use HTTPS instead of SSH**
   - GitHub source uses HTTPS by default
   - No additional configuration needed

### Plugin-Specific Issues

**Symptom**: One plugin works but another doesn't

**Solutions**:

1. **Check individual plugin enablement**
   ```json
   "enabledPlugins": {
     "core@claude-code-plugins": true,
     "workflow@claude-code-plugins": true,
     // Make sure all plugins you want are enabled
   }
   ```

2. **Verify plugin dependencies**
   - Some plugins depend on `core` plugin
   - Enable `core` plugin if not already enabled

3. **Check plugin-specific requirements**
   - `git` plugin requires `git` command available
   - `development` plugin may need `node` for some features
   - See individual plugin READMEs for requirements

### Settings Not Taking Effect

**Symptom**: Changed settings but plugins still not working

**Solutions**:

1. **Restart Claude Code** (settings reload on restart)

2. **Check settings precedence**
   - Project `.claude/settings.json` overrides global `~/.claude/settings.json`
   - Make sure you're editing the right file

3. **Validate settings merge**
   ```bash
   # Claude Code merges global and project settings
   # If both exist, project settings take precedence
   ```

## Next Steps

Now that you have Claude Code Plugins installed:

1. **Try the Quick Start** - [Quick Start Guide](quick-start.md) - 15-minute hands-on tutorial
2. **Learn the Workflow** - Try `/explore` → `/plan` → `/next` → `/ship`
3. **Explore Commands** - Run `/help` to see all available commands
4. **Create Custom Plugin** - [First Plugin Tutorial](first-plugin.md)
5. **Read Architecture Docs** - Understand the [design principles](../architecture/design-principles.md)

## Getting Help

If you're still having trouble:

- **Documentation**: Browse the [full documentation](../README.md)
- **Issues**: Report bugs at [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: Ask questions in [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

## Updating Plugins

### Update GitHub Marketplace Plugins

Plugins from GitHub marketplace auto-update:
- Claude Code checks for updates periodically
- Restart Claude Code to get latest version

### Update Local Directory Plugins

For local installations:

```bash
cd ~/claude-code-plugins  # or your installation path
git pull origin main
# Restart Claude Code to load updated plugins
```

## Uninstalling

### Remove Individual Plugins

Edit your settings.json and remove plugins from `enabledPlugins`:

```json
{
  "enabledPlugins": {
    "core@claude-code-plugins": true,
    // Remove line for plugin you want to disable
  }
}
```

Restart Claude Code.

### Remove Marketplace

To completely remove the marketplace:

1. Delete marketplace from `extraKnownMarketplaces`
2. Remove all plugins from `enabledPlugins`
3. Restart Claude Code

### Delete Local Installation

If installed locally:

```bash
rm -rf ~/claude-code-plugins  # or your installation path
```

Then update settings.json to remove marketplace reference.

---

**Installation Complete!** 🎉

You're ready to start using Claude Code Plugins. Head to the [Quick Start Guide](quick-start.md) for a hands-on tutorial.
