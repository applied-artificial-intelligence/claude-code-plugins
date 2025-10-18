# Demo Script Guide for NotebookLM

This guide structures the demo narrative to help NotebookLM AI hosts create an engaging, demo-appropriate conversation.

## Demo Flow (10 minutes)

### Act 1: The Problem (2 minutes)

**Setup:** Host 1 asks about common frustrations with AI-assisted coding

**Key Points for Host 2 to Cover:**
- Context window limits force you to restart conversations mid-task
- Losing project context when switching between features
- No systematic way to preserve decisions and patterns
- Quality inconsistencies - sometimes amazing, sometimes breaks things
- "It's like having a brilliant assistant with amnesia"

**Developer Pain Point:** "You're deep in a complex refactoring, Claude understands your entire architecture, then BAM - context limit. Start over, re-explain everything."

### Act 2: The Solution (2 minutes)

**Setup:** Host 1 asks "What if there was a better way?"

**Key Points for Host 2:**
- Claude Code Plugins = structured workflow framework
- Think of it as "workflow automation meets knowledge persistence"
- Five core plugins providing 30+ commands
- Built-in quality gates and memory management
- Open source, MIT licensed, community-driven

**Analogy:** "It's like going from freestyle conversation to a well-designed IDE - structure that enhances rather than constrains."

### Act 3: Quick Start Demo (3 minutes)

**Setup:** Host 1 says "Show me how it works in practice"

**Host 2 Walks Through:**

**Installation (30 seconds):**
```bash
# Clone repository
git clone https://github.com/applied-artificial-intelligence/claude-code-plugins

# Add to Claude Code settings
{
  "extraKnownMarketplaces": {
    "claude-plugins": {
      "source": "directory",
      "path": "/path/to/claude-code-plugins"
    }
  }
}
```

**First Workflow (2.5 minutes):**

1. **/explore** - "Let's say I want to add authentication to my app"
   - Claude analyzes requirements
   - Explores existing codebase
   - Creates work breakdown

2. **/plan** - "Now create implementation plan"
   - Generates task list with dependencies
   - Estimates effort
   - Identifies risks

3. **/next** - "Execute first task"
   - Runs tests
   - Implements changes
   - Auto-commits with proper attribution
   - Updates task status

4. **/ship** - "When all tasks complete"
   - Quality validation
   - Documentation check
   - Creates pull request
   - Preserves all context

**Key Message:** "You go from vague idea to production-ready PR with systematic quality at every step."

### Act 4: Advanced Features (2 minutes)

**Setup:** Host 1 asks "What about power users?"

**Host 2 Covers:**

**Memory Management:**
- Persistent project knowledge in `.claude/memory/`
- Auto-garbage collection for stale content
- Context optimization to prevent limit hits

**MCP Integration:**
- Serena: 70-90% token reduction with semantic code understanding
- Sequential Thinking: Structured reasoning for complex problems
- Context7: Real-time library documentation
- All optional with graceful degradation

**Custom Plugins:**
- Domain-specific workflows (ML, fintech, web dev)
- Template system for rapid plugin creation
- Framework constraints ensure quality

**Quality Automation:**
- Safe commits with hooks
- Framework auditing
- Comprehensive testing integration

### Act 5: Call to Action (1 minute)

**Setup:** Host 1 asks "How do people get started?"

**Host 2:**
- "Visit github.com/applied-artificial-intelligence/claude-code-plugins"
- "Start with core plugins - free, open source, MIT licensed"
- "Complete docs, tutorials, examples"
- "Join community - issues, discussions, contributions welcome"
- "For custom workflows: consulting and enterprise support available"

**Closing:** "Transform chaos into system. Build workflows that persist. Code with Claude that remembers."

---

## Tone Guidelines

**Do:**
- Use conversational language ("you" not "one")
- Share developer relatable moments
- Emphasize practical benefits over theory
- Include specific code examples
- Maintain enthusiasm without hype

**Don't:**
- Use marketing speak or buzzwords
- Make unrealistic claims
- Overwhelm with too many features at once
- Assume non-technical audience
- Skip the "why" for the "what"

## Technical Accuracy

Ensure these specifics are accurate:
- 30+ commands across 5 plugins
- MIT license
- GitHub organization: applied-artificial-intelligence
- Plugin categories: core, workflow, development, git, memory
- MCP tools: Serena, Sequential Thinking, Context7
- Token reduction: 70-90% (Serena)
- File locations: `.claude/` directory structure

## Success Metric

If a developer listening can:
1. Understand the problem Claude Code Plugins solve
2. Install and run their first workflow
3. Appreciate the advanced features
4. Know where to find help

...then the demo succeeds.
