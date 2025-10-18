# Plugin Templates

This directory contains templates to help you create new plugins quickly.

## Available Templates

🚧 **Coming Soon**: Plugin templates will be added here.

### Planned Templates

**basic-plugin/**
- Starter template for any plugin
- Includes all required files
- Minimal configuration
- Good starting point for most use cases

**command-only/**
- Template for command-only plugins (no agents)
- Perfect for automation workflows
- State management examples included

**agent-plugin/**
- Template for agent-based plugins
- Includes agent configuration
- Command + agent integration examples

## Using Templates

```bash
# Copy template to start a new plugin
cp -r templates/basic-plugin plugins/my-new-plugin

# Customize the plugin
cd plugins/my-new-plugin
# Edit .claude-plugin/plugin.json
# Add commands to commands/
# Update README.md
```

## What's Next?

- [Plugin Creation Guide](../docs/guides/plugin-creation.md)
- [Example Plugins](../examples/)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
