# Code Formatter Plugin

**Level**: Advanced
**Concepts**: External tools, agent integration, error handling
**Time to Complete**: 20-30 minutes

## Overview

Demonstrates integrating external formatting tools with AI-powered style validation - combining automated tooling with intelligent recommendations.

## What You'll Learn

- Integrating with external CLI tools
- Tool availability checking and graceful degradation
- Agent definition and usage
- Combining commands and agents for complete solutions

## Features

- `/format <file>` - Auto-format code using appropriate tool
- Agent `style-checker` - AI-powered style analysis

## Installation

### 1. Install External Tools (Optional)

```bash
# For JavaScript/TypeScript
npm install -g prettier

# For Python
pip install black
```

### 2. Enable Plugin

Add to `.claude/settings.json`:
```json
{
  "extraKnownMarketplaces": {
    "examples": {
      "source": {
        "source": "directory",
        "path": "/path/to/claude-code-plugins/examples"
      }
    }
  },
  "enabledPlugins": {
    "code-formatter@examples": true
  }
}
```

## Usage

### Basic Formatting

```bash
# Format JavaScript
/format src/app.js

# Format Python
/format scripts/deploy.py
```

### With Style Analysis

```bash
# 1. Auto-format (mechanical fixes)
/format src/utils.js

# 2. Get AI recommendations (strategic improvements)
/agent style-checker "src/utils.js"
```

## Key Patterns

### 1. Tool Detection
```bash
if command -v prettier >/dev/null 2>&1; then
    prettier --write "$FILE_PATH"
else
    echo "⚠️ Prettier not installed"
    echo "Install: npm install -g prettier"
fi
```

### 2. File Type Routing
```bash
case "$FILE_EXT" in
    js|jsx|ts|tsx)
        # Use Prettier
        ;;
    py)
        # Use Black
        ;;
    *)
        echo "No formatter for .$FILE_EXT"
        ;;
esac
```

### 3. Agent Integration
- Command: Mechanical/automated tasks
- Agent: Strategic/intelligent analysis
- Together: Complete solution

## Extension Ideas

1. **More formatters**: Add rustfmt, gofmt, clang-format
2. **Custom rules**: Load project-specific style config
3. **Auto-fix**: Let agent suggest fixes, command applies them
4. **Batch formatting**: Format entire directories
5. **Pre-commit hooks**: Run formatting before commits

## Resources

- [Agent Patterns](../../docs/architecture/patterns.md)
- [External Tool Integration](../../docs/guides/external-tools.md)

---

**Master Tool Integration** → **Build Production Plugins**
