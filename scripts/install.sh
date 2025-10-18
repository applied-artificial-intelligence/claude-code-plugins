#!/bin/bash
# Installation script for Claude Code Plugins
# 🚧 Coming Soon: Full installation automation

set -e

echo "🚧 Installation script under development"
echo ""
echo "For now, please manually configure your project's .claude/settings.json:"
echo ""
echo "{"
echo "  \"extraKnownMarketplaces\": {"
echo "    \"aai-plugins\": {"
echo "      \"source\": {"
echo "        \"source\": \"directory\","
echo "        \"path\": \"$(pwd)/plugins\""
echo "      }"
echo "    }"
echo "  },"
echo "  \"enabledPlugins\": {"
echo "    \"core@aai-plugins\": true,"
echo "    \"workflow@aai-plugins\": true,"
echo "    \"development@aai-plugins\": true,"
echo "    \"git@aai-plugins\": true,"
echo "    \"memory@aai-plugins\": true"
echo "  }"
echo "}"
echo ""
echo "See docs/getting-started/installation.md for detailed instructions."
