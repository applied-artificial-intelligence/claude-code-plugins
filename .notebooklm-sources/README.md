# NotebookLM Source Collection for Demo Audio

This directory contains curated documentation for generating the demo audio using Google NotebookLM.

## Purpose

Generate a 10-minute "Introduction to Claude Code Plugins" audio overview using NotebookLM's AI-hosted podcast feature.

## Upload Instructions

1. Go to https://notebooklm.google.com/
2. Create new notebook: "Claude Code Plugins Demo"
3. Upload these 8 source files:
   - 01_value_proposition.md (main README)
   - 02_installation_guide.md
   - 03_quick_start.md
   - 04_design_principles.md
   - 05_core_plugin.md
   - 06_workflow_plugin.md
   - 07_demo_script_guide.md
   - 08_glossary.md

## Focus Instructions for NotebookLM

Use these custom instructions when generating the Audio Overview:

```
Create an engaging 10-minute introduction to Claude Code Plugins for software developers.

Structure:
1. Problem Statement (2 min): Challenges developers face with AI-assisted coding - context limits, memory loss, quality consistency
2. Solution Overview (2 min): Claude Code plugin framework - structured workflows, memory management, quality automation
3. Quick Start Demo (3 min): Installation walkthrough and first workflow (explore → plan → next → ship)
4. Advanced Features (2 min): MCP integration, Serena semantic code understanding, memory persistence
5. Call to Action (1 min): Try it, contribute, consulting services available

Tone: Conversational but technically accurate. Assume audience is experienced developers familiar with AI coding assistants. Emphasize practical benefits and real-world workflow improvements.
```

## Expected Output

- 10-minute AI-hosted podcast-style audio file
- Natural conversation between two AI hosts
- Technical accuracy with accessible explanations
- Ready to use as standalone podcast OR combine with visuals for video

## Post-Generation

After NotebookLM generates audio:
1. Download MP3 file
2. Create slide deck with screenshots (matching audio narrative)
3. Produce two versions:
   - Full 10-min podcast (docs site + podcast platforms)
   - Short 2-min highlight video (GitHub + social media)

