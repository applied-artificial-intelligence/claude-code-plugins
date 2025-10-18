#!/usr/bin/env python3
"""
Generate commands reference documentation from plugin.json files.

Scans all plugins and creates a comprehensive commands reference
with categorization, descriptions, and cross-references.
"""

import json
import os
from pathlib import Path
from typing import Dict, List, Any
from collections import defaultdict

# Configuration
PLUGINS_DIR = Path(__file__).parent.parent / "plugins"
OUTPUT_FILE = Path(__file__).parent.parent / "docs" / "reference" / "commands.md"

def load_plugin_manifest(plugin_path: Path) -> Dict[str, Any]:
    """Load and parse plugin.json manifest."""
    manifest_path = plugin_path / ".claude-plugin" / "plugin.json"
    if not manifest_path.exists():
        return None
    
    with open(manifest_path, 'r') as f:
        return json.load(f)

def extract_commands_from_manifest(manifest: Dict[str, Any], plugin_name: str) -> List[Dict[str, Any]]:
    """Extract command information from plugin manifest."""
    commands = []
    
    # Get capabilities which describe commands
    capabilities = manifest.get('capabilities', {})
    
    for cap_key, cap_data in capabilities.items():
        if isinstance(cap_data, dict) and 'command' in cap_data:
            cmd_name = cap_data['command']
            commands.append({
                'name': cmd_name,
                'description': cap_data.get('description', ''),
                'plugin': plugin_name,
                'category': manifest.get('settings', {}).get('category', 'general'),
                'capability_key': cap_key
            })
    
    return commands

def categorize_commands(commands: List[Dict[str, Any]]) -> Dict[str, List[Dict[str, Any]]]:
    """Group commands by plugin for organization."""
    categorized = defaultdict(list)
    
    for cmd in commands:
        plugin_name = cmd['plugin']
        categorized[plugin_name].append(cmd)
    
    return dict(categorized)

def generate_markdown(categorized_commands: Dict[str, List[Dict[str, Any]]], 
                     plugin_info: Dict[str, Dict[str, Any]]) -> str:
    """Generate markdown documentation from command data."""
    
    md = """# Commands Reference

Complete reference for all commands across Claude Code plugins.

## Overview

This reference is auto-generated from plugin manifests and provides comprehensive
documentation for all available commands organized by plugin.

**Total Commands**: {total_commands} across {total_plugins} plugins

---

""".format(
        total_commands=sum(len(cmds) for cmds in categorized_commands.values()),
        total_plugins=len(categorized_commands)
    )
    
    # Table of contents
    md += "## Quick Navigation\n\n"
    for plugin_name in sorted(categorized_commands.keys()):
        info = plugin_info.get(plugin_name, {})
        cmd_count = len(categorized_commands[plugin_name])
        md += f"- [{plugin_name}](#{plugin_name.replace('-', '')}) ({cmd_count} commands) - {info.get('description', '')}\n"
    
    md += "\n---\n\n"
    
    # Detailed command documentation
    for plugin_name in sorted(categorized_commands.keys()):
        info = plugin_info.get(plugin_name, {})
        commands = categorized_commands[plugin_name]
        
        md += f"## {plugin_name}\n\n"
        md += f"**Description**: {info.get('description', 'No description available')}\n\n"
        md += f"**Version**: {info.get('version', 'Unknown')}\n\n"
        md += f"**Category**: {info.get('category', 'general')}\n\n"
        
        if info.get('repository'):
            repo_url = info['repository'].get('url', '')
            if repo_url:
                md += f"**Source**: [{repo_url}]({repo_url}/tree/main/plugins/{plugin_name})\n\n"
        
        md += "### Commands\n\n"
        
        for cmd in sorted(commands, key=lambda x: x['name']):
            md += f"#### `/{cmd['name']}`\n\n"
            md += f"{cmd['description']}\n\n"
            md += f"**Plugin**: {plugin_name}\n\n"
            
            # Add link to plugin README for more details
            md += f"**More Info**: See [plugin README](../../plugins/{plugin_name}/README.md)\n\n"
            md += "---\n\n"
    
    # Footer
    md += """
## Usage Notes

### Command Syntax

All commands follow the slash command pattern:
```bash
/command-name [arguments] [--flags]
```

### Getting Help

For detailed usage of any command:
- Refer to the plugin README for comprehensive examples
- Check command inline help (if available)
- Visit the [getting started guide](../getting-started/quick-start.md)

### Plugin Management

To enable/disable plugins and their commands, see the [installation guide](../getting-started/installation.md).

---

**Auto-generated**: This reference is automatically generated from plugin manifests.
**Last Updated**: {timestamp}
**Generator**: scripts/generate-commands-reference.py
""".format(timestamp=__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
    
    return md

def main():
    """Main execution function."""
    print("🔍 Scanning plugins...")
    
    # Find all plugin directories
    plugin_dirs = [d for d in PLUGINS_DIR.iterdir() if d.is_dir() and not d.name.startswith('.')]
    print(f"Found {len(plugin_dirs)} plugins")
    
    # Load all plugin manifests
    all_commands = []
    plugin_info = {}
    
    for plugin_dir in plugin_dirs:
        plugin_name = plugin_dir.name
        manifest = load_plugin_manifest(plugin_dir)
        
        if manifest is None:
            print(f"⚠️  Skipping {plugin_name} (no manifest)")
            continue
        
        print(f"✓ Processing {plugin_name}")
        
        # Store plugin info
        plugin_info[plugin_name] = {
            'name': manifest.get('name', plugin_name),
            'version': manifest.get('version', 'Unknown'),
            'description': manifest.get('description', ''),
            'category': manifest.get('settings', {}).get('category', 'general'),
            'repository': manifest.get('repository', {})
        }
        
        # Extract commands
        commands = extract_commands_from_manifest(manifest, plugin_name)
        all_commands.extend(commands)
        print(f"  Found {len(commands)} commands")
    
    print(f"\n📊 Total commands: {len(all_commands)}")
    
    # Categorize commands
    categorized = categorize_commands(all_commands)
    
    # Generate markdown
    print("\n📝 Generating markdown...")
    markdown = generate_markdown(categorized, plugin_info)
    
    # Ensure output directory exists
    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    
    # Write output
    with open(OUTPUT_FILE, 'w') as f:
        f.write(markdown)
    
    print(f"✅ Commands reference generated: {OUTPUT_FILE}")
    print(f"   {len(all_commands)} commands documented")
    print(f"   {len(categorized)} plugins covered")

if __name__ == '__main__':
    main()
