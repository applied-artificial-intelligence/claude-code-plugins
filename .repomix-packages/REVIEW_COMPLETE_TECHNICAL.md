# Claude Code Plugins - Technical Review (Complete)
**Time Required**: 2-3 hours
**Review Type**: Technical/Architecture review

---

## REVIEW PROMPT

I'm conducting a technical review of "claude-code-plugins" - an open-source plugin framework for Claude Code. This is a pre-launch review to identify critical issues before public release.

I've included a comprehensive Documentation package below with:
- Complete architecture documentation
- Design principles and patterns
- All 5 production plugin specifications
- Framework constraints

As an experienced software architect/engineer, please provide a thorough technical assessment:

### 1. Architecture Analysis (30 minutes)
- Are the stated design principles sound?
- Any architectural red flags?
- Is the stateless execution model the right choice?
- File-based persistence - appropriate or limitation?

### 2. Plugin Design Review (45 minutes)
Analyze each of the 5 production plugins:
- Core Plugin (14 commands): Command design quality, naming conventions, feature completeness
- Workflow Plugin (explore → plan → next → ship): Is this workflow practical?
- Development Plugin: Useful command set? Any redundancy?
- Git Plugin: Safe commit approach - too cautious or appropriate?
- Memory Plugin: Memory management - clever or complex?

### 3. Documentation Quality (30 minutes)
- Clarity: Is documentation clear and understandable?
- Completeness: Any critical gaps?
- Examples: Are examples helpful and realistic?

### 4. Critical Issues Identification (20 minutes)
Identify issues by severity:
- **BLOCKER** (Must fix before launch)
- **CRITICAL** (Should fix before launch)
- **MAJOR** (Fix soon after launch)
- **MINOR** (Nice to have)

### 5. Overall Technical Rating
Rate each dimension (1-5 stars):
- Architecture Design: ⭐⭐⭐⭐⭐
- Code Quality: ⭐⭐⭐⭐⭐
- Documentation: ⭐⭐⭐⭐⭐
- Extensibility: ⭐⭐⭐⭐⭐
- Production Readiness: ⭐⭐⭐⭐⭐

**Overall Recommendation**:
- [ ] Ready for launch
- [ ] Ready with minor fixes
- [ ] Needs significant work
- [ ] Not ready - major concerns

Please be thorough and critical - this is a pre-launch technical review.

---

## PACKAGE CONTENT BEGINS HERE

This file is a merged representation of a subset of the codebase, containing specifically included files and files not matching ignore patterns, combined into a single document by Repomix.
The content has been processed where line numbers have been added.

# File Summary

## Purpose
This file contains a packed representation of the entire repository's contents.
It is designed to be easily consumable by AI systems for analysis, code review,
or other automated processes.

## File Format
The content is organized as follows:
1. This summary section
2. Repository information
3. Directory structure
4. Repository files (if enabled)
5. Multiple file entries, each consisting of:
  a. A header with the file path (## File: path/to/file)
  b. The full contents of the file in a code block

## Usage Guidelines
- This file should be treated as read-only. Any changes should be made to the
  original repository files, not this packed version.
- When processing this file, use the file path to distinguish
  between different files in the repository.
- Be aware that this file may contain sensitive information. Handle it with
  the same level of security as you would the original repository.
- Pay special attention to the Repository Description. These contain important context and guidelines specific to this project.

## Notes
- Some files may have been excluded based on .gitignore rules and Repomix's configuration
- Binary files are not included in this packed representation. Please refer to the Repository Structure section for a complete list of file paths, including binary files
- Only files matching these patterns are included: README.md, CONTRIBUTING.md, docs/**/*, plugins/**/README.md, plugins/**/.claude-plugin/plugin.json, templates/**/*
- Files matching these patterns are excluded: **/*.test.ts, **/node_modules/**, **/.git/**, scripts/**, .notebooklm-sources/**, examples/**
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Line numbers have been added to the beginning of each line
- Files are sorted by Git change count (files with more changes are at the bottom)

# User Provided Header
# Claude Code Plugins - Complete Documentation Package

This package contains comprehensive documentation for understanding the entire Claude Code plugin ecosystem.

## What's Included
- All documentation (getting started, architecture, reference)
- All 5 production plugins with full READMEs
- Design principles and patterns
- Framework constraints and philosophy

## Target Audience
Technical reviewers who want deep understanding of the architecture, patterns, and design decisions.

## Time to Review: 2-3 hours

# Directory Structure
```
docs/
  architecture/
    constraints.md
    design-principles.md
    patterns.md
  getting-started/
    first-plugin.md
    installation.md
    quick-start.md
  reference/
    commands.md
  README.md
plugins/
  core/
    .claude-plugin/
      plugin.json
      README.md
    README.md
  development/
    .claude-plugin/
      plugin.json
      README.md
    README.md
  git/
    .claude-plugin/
      plugin.json
      README.md
    README.md
  memory/
    .claude-plugin/
      plugin.json
    README.md
  workflow/
    .claude-plugin/
      plugin.json
      README.md
    README.md
  README.md
templates/
  README.md
CONTRIBUTING.md
README.md
```

# Files

## File: docs/architecture/constraints.md
````markdown
  1: # Framework Constraints
  2: 
  3: Technical and architectural constraints that define what Claude Code plugins can and cannot do. Understanding these constraints is essential for building reliable, effective plugins.
  4: 
  5: ## Table of Contents
  6: 
  7: - [Stateless Execution](#stateless-execution)
  8: - [Command Execution Context](#command-execution-context)
  9: - [Template System](#template-system)
 10: - [File System Boundaries](#file-system-boundaries)
 11: - [MCP Integration](#mcp-integration)
 12: - [Token and Context Limits](#token-and-context-limits)
 13: - [Security and Permissions](#security-and-permissions)
 14: - [Design Philosophy](#design-philosophy)
 15: 
 16: ---
 17: 
 18: ## Stateless Execution
 19: 
 20: ### The Fundamental Constraint
 21: 
 22: **Every command invocation starts completely fresh.** This is not a bug or limitation—it's the foundation of Claude Code's architecture.
 23: 
 24: ### What Cannot Persist
 25: 
 26: #### Connections and Sessions
 27: ❌ Database connections terminate
 28: ❌ API sessions don't carry over
 29: ❌ WebSocket connections close
 30: ❌ File handles and streams disappear
 31: ❌ Network state resets
 32: 
 33: **Example**:
 34: ```bash
 35: # First /command invocation
 36: db = connect_to_database()
 37: query_result = db.query("SELECT * FROM users")
 38: 
 39: # Second /command invocation
 40: # db is undefined! Connection lost!
 41: # Must reconnect from scratch
 42: ```
 43: 
 44: #### Runtime State
 45: ❌ Object instances are recreated
 46: ❌ Global variables reset
 47: ❌ State machines restart
 48: ❌ Background processes terminate
 49: ❌ Scheduled tasks don't persist
 50: 
 51: **Example**:
 52: ```bash
 53: # First command
 54: COUNTER=5
 55: export PROGRESS="50%"
 56: 
 57: # Second command
 58: # COUNTER is undefined!
 59: # PROGRESS doesn't exist!
 60: ```
 61: 
 62: #### Async and Parallelism
 63: ❌ Async operations can't span commands
 64: ❌ Background jobs don't continue
 65: ❌ File watchers terminate
 66: ❌ Event listeners disappear
 67: ❌ Deferred execution fails
 68: 
 69: **Example**:
 70: ```javascript
 71: // This won't work:
 72: fs.watch('/path', callback);  // Watch terminates when command ends
 73: setTimeout(() => {...}, 5000); // Never executes across commands
 74: ```
 75: 
 76: ### Working With Statelessness
 77: 
 78: #### ✅ File-Based State
 79: ```bash
 80: # Save state
 81: echo '{"phase": "implementing", "task": "TASK-003"}' > .claude/state.json
 82: 
 83: # Load state (in next command)
 84: STATE=$(cat .claude/state.json)
 85: TASK=$(echo "$STATE" | jq -r '.task')
 86: ```
 87: 
 88: #### ✅ Idempotent Operations
 89: ```bash
 90: # Safe to run multiple times
 91: if [ ! -f "config.json" ]; then
 92:     create_config
 93: else
 94:     validate_config
 95: fi
 96: 
 97: # Or: create-or-update pattern
 98: mkdir -p output/
 99: echo "data" > output/result.txt  # Overwrites if exists
100: ```
101: 
102: #### ✅ Git as Checkpoints
103: ```bash
104: # Create recovery points
105: git add .
106: git commit -m "Checkpoint before risky operation"
107: 
108: # Revert if needed
109: git reset --hard HEAD~1
110: ```
111: 
112: ---
113: 
114: ## Command Execution Context
115: 
116: ### Commands Are Templates, Not Scripts
117: 
118: This is a critical distinction that affects how you write commands.
119: 
120: ### Execution Location
121: 
122: **Commands execute in the user's project directory, NOT in `~/.claude/commands/`**
123: 
124: ```bash
125: # When command runs:
126: pwd
127: # Returns: /home/user/my-project
128: 
129: # NOT:
130: # /home/user/.claude/commands/
131: ```
132: 
133: ### Why This Matters
134: 
135: #### ❌ Cannot Source External Scripts
136: 
137: All these attempts FAIL:
138: ```bash
139: # Relative to command location - FAILS
140: source "$(dirname "$0")/utils.sh"
141: 
142: # Absolute path to commands - FAILS
143: source ~/.claude/commands/helpers/common.sh
144: 
145: # Relative shared directory - FAILS
146: source ../lib/utilities.sh
147: ```
148: 
149: **Why they fail**: Command files exist in `~/.claude/commands/`, but bash executes in `/path/to/project/`. The files aren't there.
150: 
151: #### ✅ Must Use Inline Logic
152: 
153: Everything must be self-contained:
154: ```bash
155: # Copy this to EVERY command that needs it
156: error_exit() {
157:     echo "ERROR: $1" >&2
158:     exit 1
159: }
160: 
161: warn() {
162:     echo "WARNING: $1" >&2
163: }
164: 
165: require_tool() {
166:     command -v "$1" >/dev/null 2>&1 || error_exit "$1 not installed"
167: }
168: ```
169: 
170: ### Why Duplication Is Correct
171: 
172: You'll see the same utility functions in multiple commands. This is **intentional**:
173: 
174: **Reason 1**: Execution context prevents sourcing
175: **Reason 2**: Templates aren't programs (can't import)
176: **Reason 3**: Each command must be independently executable
177: **Reason 4**: No dependency management overhead
178: 
179: **Evidence**: Core plugins have ~44 lines of bash utilities duplicated across 23 commands. This is by design.
180: 
181: **See Also**: Factory project has complete explanation in `WHY_DUPLICATION_EXISTS.md`
182: 
183: ---
184: 
185: ## Template System
186: 
187: ### Markdown-Based Commands
188: 
189: Commands are Markdown files with frontmatter and implementation:
190: 
191: ```markdown
192: ---
193: name: my-command
194: description: What it does
195: allowed-tools: [Bash, Read, Write]
196: argument-hint: "[options]"
197: ---
198: 
199: # My Command
200: 
201: Documentation here...
202: 
203: ## Implementation
204: 
205: ```bash
206: #!/bin/bash
207: # Code here with $ARGUMENTS
208: ```
209: ```
210: 
211: ### Variable Substitution
212: 
213: The **only** dynamic element is `$ARGUMENTS`:
214: 
215: ```bash
216: # User types: /greet Alice
217: # Framework substitutes: $ARGUMENTS → "Alice"
218: 
219: NAME="${1:-World}"  # Extracts from $ARGUMENTS
220: echo "Hello, $NAME!"
221: ```
222: 
223: **No other substitution exists**:
224: - ❌ No {{TEMPLATE_VARS}}
225: - ❌ No preprocessing phase
226: - ❌ No build-time injection
227: - ❌ No conditional includes
228: 
229: ### Template Processing Flow
230: 
231: ```
232: User types: /command arg1 arg2
233:     ↓
234: Claude reads: ~/.claude/commands/command.md
235:     ↓
236: Substitutes: $ARGUMENTS → "arg1 arg2"
237:     ↓
238: Extracts bash: Code between ```bash blocks
239:     ↓
240: Executes in: /path/to/user/project/
241:     ↓
242: Returns output: Back to Claude for processing
243: ```
244: 
245: ### Constraints This Creates
246: 
247: #### ✅ DO: Keep logic in bash
248: ```bash
249: # Good: Logic in bash where it can execute
250: if [ "$DRY_RUN" = "true" ]; then
251:     echo "Would deploy..."
252: else
253:     deploy_actual
254: fi
255: ```
256: 
257: #### ❌ DON'T: Try template logic
258: ```markdown
259: <!-- Bad: This doesn't work -->
260: {{#if user.admin}}
261:   Admin panel
262: {{else}}
263:   User panel
264: {{/if}}
265: ```
266: 
267: Instead, let Claude handle logic:
268: ```markdown
269: <!-- Good: Claude decides based on context -->
270: I'll check the user's role and show the appropriate interface.
271: ```
272: 
273: ---
274: 
275: ## File System Boundaries
276: 
277: ### Working Directory
278: 
279: Commands ALWAYS execute in the user's project directory:
280: 
281: ```bash
282: # These paths are relative to project:
283: cat .claude/work/state.json        # ✅ Works
284: cat README.md                       # ✅ Works
285: ls src/                            # ✅ Works
286: 
287: # These paths may not exist:
288: cat ~/.claude/commands/utils.sh    # ❌ Might fail
289: ls /global/shared/lib/             # ❌ Might fail
290: ```
291: 
292: ### File-Based State is Required
293: 
294: Since nothing else persists, **files are the ONLY state mechanism**:
295: 
296: ```
297: .claude/
298: ├── work/
299: │   ├── ACTIVE_WORK              # Active work unit name
300: │   ├── current/
301: │   │   └── [work-unit]/
302: │   │       ├── state.json      # Task state
303: │   │       └── metadata.json   # Work unit info
304: │   └── archives/               # Completed work
305: ├── memory/
306: │   ├── context.md              # Session context
307: │   └── decisions.md            # Key decisions
308: └── transitions/
309:     └── latest/handoff.md       # Session handoffs
310: ```
311: 
312: ### Git as State Manager
313: 
314: Git provides critical state management:
315: 
316: ```bash
317: # Checkpoint before risky changes
318: git add .
319: git commit -m "Checkpoint: Before refactor"
320: 
321: # If things go wrong
322: git reset --hard HEAD~1  # Restore previous state
323: 
324: # Track progress
325: git log --oneline  # See what's been done
326: 
327: # Branching for parallel work
328: git checkout -b feature/experimental
329: ```
330: 
331: ### Permissions and Access
332: 
333: Commands can only access:
334: - ✅ Files in project directory
335: - ✅ User's home directory (with permission)
336: - ✅ System commands in PATH
337: - ❌ Arbitrary system files (restricted)
338: - ❌ Other users' directories (restricted)
339: 
340: ---
341: 
342: ## MCP Integration
343: 
344: ### MCP Tools Are Always Optional
345: 
346: **Critical Rule**: All functionality must work WITHOUT MCP tools.
347: 
348: ```bash
349: # ✅ Correct: Graceful degradation
350: if command -v serena &> /dev/null; then
351:     # Enhanced: Use Serena MCP (70-90% token reduction)
352:     serena find_symbol "MyClass"
353: else
354:     # Fallback: Use grep (slower but works)
355:     grep -r "class MyClass" src/
356: fi
357: ```
358: 
359: ```bash
360: # ❌ Wrong: Requiring MCP
361: serena find_symbol "MyClass"  # Fails without Serena!
362: ```
363: 
364: ### MCP State Doesn't Persist
365: 
366: Like all state, MCP connections reset between commands:
367: 
368: ```bash
369: # First command
370: serena_db = connect_serena_database()
371: result = query_symbols()
372: 
373: # Second command
374: # serena_db is gone! Must reconnect!
375: ```
376: 
377: ### MCP Tools Run in AI Context
378: 
379: MCP tools are executed by Claude, not directly in bash:
380: 
381: ```bash
382: # ❌ Cannot pipe MCP output to bash
383: serena find_symbol "MyClass" | grep "method"  # Doesn't work
384: 
385: # ✅ Claude processes MCP results, then bash runs
386: # (Claude invokes Serena, gets results, then bash processes)
387: ```
388: 
389: ### Declaration in plugin.json
390: 
391: Always declare MCP tools as optional:
392: 
393: ```json
394: {
395:   "name": "my-plugin",
396:   "mcpTools": {
397:     "optional": ["serena", "sequential-thinking"],
398:     "gracefulDegradation": true
399:   }
400: }
401: ```
402: 
403: **Never** use `"required"`:
404: ```json
405: {
406:   "mcpTools": {
407:     "required": ["serena"]  // ❌ WRONG - breaks without MCP
408:   }
409: }
410: ```
411: 
412: ---
413: 
414: ## Token and Context Limits
415: 
416: ### Limited Context Window
417: 
418: Claude has a finite context window that fills with:
419: - Conversation history
420: - Loaded memory files (CLAUDE.md, imports)
421: - Open file contents
422: - Command definitions
423: - MCP tool definitions
424: 
425: ### Context Management Strategies
426: 
427: #### ✅ DO: Be Selective
428: ```bash
429: # Good: Focused grep with limits
430: grep "specific_pattern" file.txt | head -20
431: 
432: # Good: Read specific sections
433: cat file.txt | sed -n '100,200p'
434: ```
435: 
436: #### ❌ DON'T: Load Everything
437: ```bash
438: # Bad: Loads entire large file
439: cat huge_database.sql  # May exhaust context
440: 
441: # Bad: Recursive file reading
442: find . -type f -exec cat {} \;  # Definitely too much
443: ```
444: 
445: ### Memory File Limits
446: 
447: ```markdown
448: # CLAUDE.md (keep concise)
449: ## Project Overview
450: Brief description...
451: 
452: @memory/details.md  # Use imports for details
453: 
454: # memory/details.md (stay focused)
455: ## Architecture Details
456: Only essential information...
457: ```
458: 
459: **Guidelines**:
460: - Keep CLAUDE.md < 10KB
461: - Each import file < 5KB
462: - Total imports < 50KB
463: - Archive old context regularly
464: 
465: ### Token Optimization with MCP
466: 
467: **Serena** provides 70-90% token reduction for code operations:
468: ```bash
469: # Standard approach: Read entire file
470: cat src/module.py  # 500 lines = ~2000 tokens
471: 
472: # Serena approach: Get just what you need
473: serena find_symbol "authenticate"  # Just the function = ~200 tokens
474: ```
475: 
476: ### Context Health Monitoring
477: 
478: ```bash
479: # Check context usage (hypothetical /context command)
480: /context
481: # Messages: 45% (23K tokens)
482: # Memory: 15% (8K tokens)
483: # Tools: 10% (5K tokens)
484: # Total: 70% (36K tokens)
485: 
486: # Optimize when > 80%:
487: # - Archive old conversation (/handoff)
488: # - Reduce memory imports
489: # - Clear completed work
490: ```
491: 
492: ---
493: 
494: ## Security and Permissions
495: 
496: ### Tool Permission Model
497: 
498: Claude Code uses pattern-based permissions:
499: 
500: ```json
501: {
502:   "permissions": {
503:     "deny": [
504:       "Bash(rm -rf /*:*)",      // Prevent dangerous rm
505:       "Read(.env)",              // Block secrets
506:       "Read(*.pem)"             // Block private keys
507:     ],
508:     "ask": [
509:       "Bash(git push:*)",       // Confirm before push
510:       "Write(*.py)",            // Ask before writing code
511:       "Bash(npm install:*)"     // Confirm installs
512:     ],
513:     "allow": [
514:       "Read(*.md)",             // Always allow doc reading
515:       "Grep(**)",               // Always allow search
516:       "Bash(git status:*)"      // Always allow git status
517:     ]
518:   }
519: }
520: ```
521: 
522: ### Execution Boundaries
523: 
524: Commands cannot:
525: - ❌ Execute with sudo/elevated privileges
526: - ❌ Modify system files outside project
527: - ❌ Access other users' files
528: - ❌ Execute arbitrary binaries without approval
529: - ❌ Bypass file permissions
530: - ❌ Create network servers that persist
531: 
532: ### Security Best Practices
533: 
534: #### ✅ DO: Validate inputs
535: ```bash
536: # Check arguments
537: if [[ ! "$FILE" =~ ^[a-zA-Z0-9._/-]+$ ]]; then
538:     error_exit "Invalid filename: $FILE"
539: fi
540: 
541: # Verify files exist before operations
542: if [ ! -f "$FILE" ]; then
543:     error_exit "File not found: $FILE"
544: fi
545: ```
546: 
547: #### ✅ DO: Use safe commands
548: ```bash
549: # Good: Specific rm
550: rm -f output.txt
551: 
552: # Bad: Dangerous rm
553: rm -rf *  # Will be blocked or require confirmation
554: ```
555: 
556: #### ✅ DO: Handle secrets properly
557: ```bash
558: # Read from secure storage
559: API_KEY=$(cat .env | grep API_KEY | cut -d= -f2)
560: 
561: # Don't echo secrets
562: if [ -z "$API_KEY" ]; then
563:     error_exit "API_KEY not found in .env"
564: fi
565: # Don't: echo "Using key: $API_KEY"
566: ```
567: 
568: ---
569: 
570: ## Design Philosophy
571: 
572: ### Embrace Constraints, Don't Fight Them
573: 
574: These constraints lead to **better design**:
575: 
576: 1. **Statelessness** → Predictable, reproducible behavior
577: 2. **Templates** → Simple, maintainable commands
578: 3. **Duplication** → Self-contained, reliable execution
579: 4. **File-based** → Transparent, debuggable state
580: 5. **MCP optional** → Graceful degradation, broader compatibility
581: 
582: ### Wrong Approaches (Don't Do This)
583: 
584: ❌ **Fighting Statelessness**:
585: ```bash
586: # Trying to maintain connections
587: # Building elaborate state machines
588: # Expecting variables to persist
589: ```
590: 
591: ❌ **Complex Workarounds**:
592: ```bash
593: # Attempting to source shared code
594: # Creating preprocessing systems
595: # Building dependency managers
596: ```
597: 
598: ❌ **Assuming MCP**:
599: ```bash
600: # Requiring MCP tools
601: # No fallback for missing tools
602: # Breaking without enhancement
603: ```
604: 
605: ### Right Approaches (Do This)
606: 
607: ✅ **Accept Statelessness**:
608: ```bash
609: # Use files for all state
610: # Design idempotent operations
611: # Create atomic transactions
612: ```
613: 
614: ✅ **Embrace Simplicity**:
615: ```bash
616: # Duplicate small utilities
617: # Keep commands focused
618: # One command, one purpose
619: ```
620: 
621: ✅ **Graceful Degradation**:
622: ```bash
623: # Check for MCP availability
624: # Provide standard fallbacks
625: # Never require enhancements
626: ```
627: 
628: ---
629: 
630: ## Summary
631: 
632: ### The 8 Core Constraints
633: 
634: 1. **Stateless Execution**: Every command starts fresh, nothing persists
635: 2. **Execution Context**: Commands run in project dir, not ~/.claude/
636: 3. **Template System**: Markdown with $ARGUMENTS substitution only
637: 4. **File System**: All persistence through files, git for checkpoints
638: 5. **MCP Optional**: Enhanced features must have fallbacks
639: 6. **Token Limits**: Finite context window, must manage carefully
640: 7. **Security**: Permission-based access, no elevated privileges
641: 8. **Duplication**: Self-contained commands, no shared utilities
642: 
643: ### Design Checklist
644: 
645: When creating commands, verify:
646: 
647: - [ ] No persistent connections or state
648: - [ ] All logic inline (no external sourcing)
649: - [ ] File-based state management
650: - [ ] Idempotent operations (safe to repeat)
651: - [ ] MCP graceful degradation
652: - [ ] Token-conscious file operations
653: - [ ] Input validation and error handling
654: - [ ] Security best practices followed
655: 
656: ### Common Mistakes
657: 
658: ❌ Expecting variables to persist
659: ❌ Trying to source external scripts
660: ❌ Assuming MCP tools available
661: ❌ Loading entire large files
662: ❌ Requiring elevated permissions
663: ❌ Building complex state machines
664: ❌ Fighting the framework's design
665: 
666: ### Key Insights
667: 
668: 1. **Constraints enable reliability**: Statelessness ensures predictability
669: 2. **Duplication is correct**: Execution context requires self-containment
670: 3. **Files are the database**: Only reliable persistence mechanism
671: 4. **MCP enhances, not replaces**: Always provide standard approach
672: 5. **Simplicity wins**: Work with constraints, not against them
673: 
674: ---
675: 
676: ## Further Reading
677: 
678: - [Design Principles](design-principles.md) - Philosophical foundation
679: - [Plugin Patterns](patterns.md) - Proven implementation patterns
680: - [Quick Start Tutorial](../getting-started/quick-start.md) - See constraints in practice
681: - [First Plugin Tutorial](../getting-started/first-plugin.md) - Build within constraints
682: 
683: ---
684: 
685: *These constraints define the boundaries of Claude Code plugins. Understanding and embracing them leads to reliable, maintainable, and powerful automation.*
````

## File: docs/architecture/design-principles.md
````markdown
  1: # Design Principles
  2: 
  3: Core architectural principles for building reliable Claude Code plugins. Understanding these principles will help you create plugins that work seamlessly with Claude Code's execution model.
  4: 
  5: ## Table of Contents
  6: 
  7: - [Stateless Execution Model](#stateless-execution-model)
  8: - [File-Based Persistence](#file-based-persistence)
  9: - [Self-Containment](#self-containment)
 10: - [Execution Context](#execution-context)
 11: - [MCP Optional](#mcp-optional)
 12: - [Design Philosophy](#design-philosophy)
 13: 
 14: ---
 15: 
 16: ## Stateless Execution Model
 17: 
 18: ### The Fundamental Principle
 19: 
 20: **Every command invocation is completely independent.**
 21: 
 22: ```
 23: [Fresh Start] → [Read State] → [Do Work] → [Write State] → [Complete End]
 24: ```
 25: 
 26: Nothing carries over between invocations. No connections, no objects, no background processes. Everything must be explicitly persisted to files and reloaded on next execution.
 27: 
 28: ### Why Statelessness Matters
 29: 
 30: Statelessness isn't a limitation—it's a fundamental design choice that provides:
 31: 
 32: - **Predictability**: Each execution starts clean, eliminating hidden state bugs
 33: - **Reliability**: No corrupted state can persist across invocations
 34: - **Simplicity**: No complex state synchronization required
 35: - **Transparency**: All state is visible in files
 36: - **Recoverability**: Easy to restore from any point
 37: - **Debuggability**: State is always inspectable
 38: 
 39: ### What Cannot Persist
 40: 
 41: Understanding what disappears between command invocations is crucial:
 42: 
 43: #### Connections and Sessions
 44: ❌ **Database connections** - Must reconnect for each operation
 45: ❌ **API sessions** - Re-authenticate every time
 46: ❌ **Network state** - WebSockets and HTTP sessions vanish
 47: ❌ **File handles** - Open files, streams, cursors disappear
 48: 
 49: #### Runtime State
 50: ❌ **Object instances** - No persistent objects or singletons
 51: ❌ **State machines** - Must be reconstructed from files
 52: ❌ **Background processes** - No daemons or watchers
 53: ❌ **Scheduled tasks** - No cron-like delayed execution
 54: 
 55: #### Technical Boundaries
 56: ❌ **No parallelism** - Async operations cannot span invocations
 57: ❌ **No real-time monitoring** - Cannot watch for changes
 58: ❌ **Terminal-only interface** - No persistent GUI
 59: ❌ **Text-based processing** - Limited to text and scripts
 60: 
 61: ### Working With Statelessness
 62: 
 63: #### Patterns That Work
 64: 
 65: **1. File-Based State Management**
 66: 
 67: Store all state in JSON or Markdown files:
 68: 
 69: ```json
 70: // .claude/work/current/my-task/state.json
 71: {
 72:   "phase": "implementing",
 73:   "current_task": "TASK-003",
 74:   "completed_tasks": ["TASK-001", "TASK-002"],
 75:   "last_updated": "2025-10-18T15:30:00Z"
 76: }
 77: ```
 78: 
 79: **2. Idempotent Operations**
 80: 
 81: Design commands that can be safely repeated:
 82: 
 83: ```bash
 84: # Good: Check before creating
 85: if [ ! -d "$WORK_DIR" ]; then
 86:     mkdir -p "$WORK_DIR"
 87: fi
 88: 
 89: # Bad: Assumes directory doesn't exist
 90: mkdir "$WORK_DIR"  # Fails if already exists
 91: ```
 92: 
 93: **3. Atomic Transactions**
 94: 
 95: Complete operations within single invocation:
 96: 
 97: ```bash
 98: # Good: All changes in one command
 99: update_state() {
100:     # Read current state
101:     local state=$(cat state.json)
102: 
103:     # Modify
104:     local new_state=$(echo "$state" | jq '.phase = "complete"')
105: 
106:     # Write atomically
107:     echo "$new_state" > state.json.tmp
108:     mv state.json.tmp state.json
109: 
110:     # Commit checkpoint
111:     git add state.json
112:     git commit -m "Update state to complete"
113: }
114: ```
115: 
116: **4. Explicit Context Passing**
117: 
118: Store context in files, not memory:
119: 
120: ```bash
121: # Good: Read context from file every time
122: load_context() {
123:     if [ -f ".claude/context.json" ]; then
124:         CONTEXT=$(cat .claude/context.json)
125:     fi
126: }
127: 
128: # Bad: Expect variable from previous run
129: echo "Continuing from $LAST_STEP"  # LAST_STEP doesn't exist
130: ```
131: 
132: #### Anti-Patterns to Avoid
133: 
134: ❌ **Trying to maintain connections**
135: ```python
136: # WRONG: Expecting connection to persist
137: db = connect_to_database()
138: # Connection is lost on next invocation!
139: ```
140: 
141: ❌ **Assuming previous state**
142: ```bash
143: # WRONG: Variable from previous run
144: echo "Count: $((COUNTER + 1))"  # COUNTER is undefined
145: ```
146: 
147: ❌ **Background processing**
148: ```javascript
149: // WRONG: Watcher terminates immediately
150: fs.watch('/path', callback);  # Process ends, watcher dies
151: ```
152: 
153: ---
154: 
155: ## File-Based Persistence
156: 
157: ### The File System is Your Database
158: 
159: Claude Code plugins use the file system for all persistence:
160: 
161: ```
162: .claude/
163: ├── work/
164: │   ├── current/           # Active work units
165: │   │   └── task-001/
166: │   │       ├── state.json # Task state
167: │   │       └── metadata.json
168: │   └── archives/          # Completed work
169: ├── memory/
170: │   ├── context.md         # Session context
171: │   └── decisions.md       # Key decisions
172: └── transitions/
173:     └── 2025-10-18_001/    # Handoff documents
174:         └── handoff.md
175: ```
176: 
177: ### State File Patterns
178: 
179: #### JSON for Structured Data
180: 
181: ```json
182: {
183:   "id": "task-001",
184:   "status": "in_progress",
185:   "created_at": "2025-10-18T10:00:00Z",
186:   "metadata": {
187:     "priority": "high",
188:     "estimated_hours": 3
189:   },
190:   "dependencies": ["task-000"]
191: }
192: ```
193: 
194: #### Markdown for Documentation
195: 
196: ```markdown
197: # Task 001: Add User Authentication
198: 
199: ## Status
200: - Phase: Implementation
201: - Progress: 60%
202: - Next: Write tests
203: 
204: ## Context
205: User authentication is critical for...
206: ```
207: 
208: #### YAML for Configuration
209: 
210: ```yaml
211: plugin:
212:   name: my-plugin
213:   version: 1.0.0
214:   commands:
215:     - commands/*.md
216:   agents:
217:     - agents/*.md
218: ```
219: 
220: ### Git as State Machine
221: 
222: Use git commits as natural checkpoints:
223: 
224: - **Commits**: Provide recovery points
225: - **Branches**: Enable parallel work
226: - **History**: Enable rollback
227: - **Tags**: Mark milestones
228: 
229: Example from `/next` command:
230: 
231: ```bash
232: # Complete task and create checkpoint
233: git add .
234: git commit -m "feat: Complete TASK-003 - Add user auth
235: 
236: Acceptance criteria met:
237: - JWT token generation ✅
238: - Login endpoint ✅
239: - Auth middleware ✅
240: "
241: ```
242: 
243: ---
244: 
245: ## Self-Containment
246: 
247: ### All Logic Must Be Inline
248: 
249: **Critical Design Constraint**: Commands cannot source external scripts.
250: 
251: #### Why Self-Containment is Required
252: 
253: Commands execute in the **project directory**, not in `~/.claude/commands/`. This means:
254: 
255: ```bash
256: # Command file location
257: ~/.claude/commands/my-command.md
258: 
259: # Execution directory
260: ~/my-project/
261: 
262: # Therefore, relative paths fail:
263: source ../helpers/utils.sh  # File not found!
264: ```
265: 
266: #### The Correct Approach: Inline Everything
267: 
268: Each command must contain all its logic:
269: 
270: ```markdown
271: ---
272: name: my-command
273: description: Example self-contained command
274: ---
275: 
276: # My Command
277: 
278: **Input**: $ARGUMENTS
279: 
280: ## Implementation
281: 
282: ```bash
283: #!/bin/bash
284: 
285: # Standard constants (MUST be copied to each command)
286: readonly CLAUDE_DIR=".claude"
287: readonly WORK_DIR="${CLAUDE_DIR}/work"
288: 
289: # Error handling (MUST be copied to each command)
290: error_exit() {
291:     echo "ERROR: $1" >&2
292:     exit 1
293: }
294: 
295: warn() {
296:     echo "WARNING: $1" >&2
297: }
298: 
299: # Tool requirements (MUST be copied to each command)
300: require_tool() {
301:     local tool="$1"
302:     if ! command -v "$tool" >/dev/null 2>&1; then
303:         error_exit "$tool is required but not installed"
304:     fi
305: }
306: 
307: # Command-specific logic
308: main() {
309:     require_tool "jq"
310: 
311:     echo "Executing command..."
312:     # Implementation here
313: }
314: 
315: main
316: ```
317: ```
318: 
319: ### Why Duplication is Acceptable
320: 
321: You might notice utility functions duplicated across commands. This is **intentional and correct**:
322: 
323: ✅ **Advantages of duplication**:
324: - Each command is independently executable
325: - No dependency management complexity
326: - Clear what each command needs
327: - Easy to modify without breaking others
328: 
329: ❌ **Problems with shared utilities**:
330: - Execution context makes sourcing impossible
331: - Dependency on file system layout
332: - Brittle when commands installed elsewhere
333: - Harder to understand command requirements
334: 
335: **See Also**: [Why Duplication Exists](../reference/why-duplication-exists.md) for complete rationale
336: 
337: ---
338: 
339: ## Execution Context
340: 
341: ### Commands Are Templates, Not Scripts
342: 
343: A critical distinction: Claude Code commands are **templates** that get rendered, not scripts that get sourced.
344: 
345: ### How Command Execution Works
346: 
347: 1. **Template Rendering**: Claude reads `.md` file, substitutes variables
348: 2. **Bash Extraction**: Extracts bash code from markdown
349: 3. **Execution in Project**: Runs bash in user's project directory
350: 4. **Return to Claude**: Output returned for Claude to process
351: 
352: ```
353: ~/.claude/commands/greet.md
354:     ↓ (Claude reads template)
355:     ↓ (Substitutes $ARGUMENTS)
356:     ↓ (Extracts bash)
357:     ↓ (Executes in ~/my-project/)
358:     ↓ (Returns output)
359: Claude processes results
360: ```
361: 
362: ### Variable Substitution
363: 
364: Commands use **runtime substitution**:
365: 
366: ```markdown
367: ---
368: name: greet
369: ---
370: 
371: **Input**: $ARGUMENTS
372: 
373: ```bash
374: #!/bin/bash
375: NAME="${1:-World}"
376: echo "Hello, $NAME!"
377: ```
378: ```
379: 
380: When user runs `/greet Alice`:
381: - `$ARGUMENTS` → `"Alice"`
382: - Command executes with `NAME="Alice"`
383: - Output: `"Hello, Alice!"`
384: 
385: ### Working Directory Context
386: 
387: Commands always execute in the **user's project directory**:
388: 
389: ```bash
390: # If user is in ~/my-project/
391: pwd
392: # Output: /home/user/my-project
393: 
394: # NOT:
395: # /home/user/.claude/commands/
396: ```
397: 
398: This means:
399: - ✅ Can access project files: `cat README.md`
400: - ✅ Can modify project: `mkdir src/`
401: - ✅ Can use git: `git status`
402: - ❌ Cannot access command directory files
403: - ❌ Cannot source sibling scripts
404: 
405: ---
406: 
407: ## MCP Optional
408: 
409: ### Model Context Protocol is an Enhancement, Not a Requirement
410: 
411: All plugin functionality must work **without** MCP tools. MCP tools enhance performance and capabilities but are always optional.
412: 
413: ### Graceful Degradation Pattern
414: 
415: Every MCP-enhanced feature must have a fallback:
416: 
417: ```bash
418: # Check if Serena MCP is available
419: if command -v serena-mcp &> /dev/null; then
420:     # Enhanced: Use semantic search (70-90% faster)
421:     serena-mcp find_symbol "MyClass"
422: else
423:     # Fallback: Use grep (slower but works)
424:     grep -r "class MyClass" src/
425: fi
426: ```
427: 
428: ### Common MCP Tool Degradation
429: 
430: #### Sequential Thinking
431: - **With MCP**: Structured step-by-step reasoning
432: - **Without MCP**: Standard analytical reasoning
433: 
434: ```bash
435: # No code changes needed - Claude automatically degrades
436: ```
437: 
438: #### Serena (Semantic Code Understanding)
439: - **With MCP**: Symbol-level search, -70-90% token usage
440: - **Without MCP**: File reading and grep search
441: 
442: ```bash
443: if command -v serena &> /dev/null; then
444:     # Fast semantic search
445:     serena find_symbol "authenticate"
446: else
447:     # Fallback to grep
448:     grep -r "def authenticate" .
449: fi
450: ```
451: 
452: #### Context7 (Documentation Access)
453: - **With MCP**: Real-time library docs
454: - **Without MCP**: Web search or cached docs
455: 
456: ```bash
457: # Context7 is transparent to commands
458: # Claude handles degradation automatically
459: ```
460: 
461: ### MCP Declaration in plugin.json
462: 
463: Declare optional MCP tools in manifest:
464: 
465: ```json
466: {
467:   "name": "my-plugin",
468:   "mcpTools": {
469:     "optional": ["serena", "sequential-thinking"],
470:     "gracefulDegradation": true
471:   }
472: }
473: ```
474: 
475: **Never use**:
476: ```json
477: {
478:   "mcpTools": {
479:     "required": ["serena"]  // ❌ WRONG - breaks without MCP
480:   }
481: }
482: ```
483: 
484: ---
485: 
486: ## Design Philosophy
487: 
488: ### Embrace Constraints, Don't Fight Them
489: 
490: Claude Code's architectural constraints aren't bugs to work around—they're features to design with.
491: 
492: #### Statelessness → Better Design
493: 
494: **Bad Reaction**: "I need to work around statelessness"
495: **Good Reaction**: "I'll design for statelessness from the start"
496: 
497: Stateless design leads to:
498: - Simpler code (no state synchronization)
499: - Easier testing (no hidden state)
500: - Better reliability (no state corruption)
501: 
502: #### Self-Containment → Independence
503: 
504: **Bad Reaction**: "I'll find a way to share utilities"
505: **Good Reaction**: "Each command will be independently executable"
506: 
507: Self-contained commands provide:
508: - No dependency management
509: - Clear requirements per command
510: - Easy to modify without side effects
511: 
512: #### File-Based Persistence → Transparency
513: 
514: **Bad Reaction**: "Files are primitive, I need a database"
515: **Good Reaction**: "Files make all state visible and inspectable"
516: 
517: File-based persistence gives:
518: - Easy debugging (just read the files)
519: - Version control (git tracks everything)
520: - User transparency (can see all state)
521: 
522: ### Design for Reconstruction
523: 
524: Every command should be able to:
525: 
526: 1. **Detect current state** from files
527: 2. **Validate state consistency**
528: 3. **Reconstruct necessary context**
529: 4. **Proceed or fail gracefully**
530: 
531: Example from `/next` command:
532: 
533: ```bash
534: # Load and validate state
535: if [ ! -f "${WORK_DIR}/ACTIVE_WORK" ]; then
536:     error_exit "No active work unit. Run /explore first."
537: fi
538: 
539: ACTIVE_WORK=$(cat "${WORK_DIR}/ACTIVE_WORK")
540: STATE_FILE="${WORK_DIR}/current/${ACTIVE_WORK}/state.json"
541: 
542: if [ ! -f "$STATE_FILE" ]; then
543:     error_exit "No state file. Run /plan first."
544: fi
545: 
546: # Validate state
547: STATUS=$(jq -r '.status' "$STATE_FILE")
548: if [ "$STATUS" != "implementing" ]; then
549:     error_exit "Work unit not ready. Current status: $STATUS"
550: fi
551: ```
552: 
553: ### Prefer Explicit Over Implicit
554: 
555: Make everything visible and traceable:
556: 
557: ✅ **Good**: Explicit state in files
558: ```bash
559: echo '{"phase": "complete"}' > .claude/state.json
560: ```
561: 
562: ❌ **Bad**: Implicit state in variables
563: ```bash
564: PHASE="complete"  # Lost on next invocation
565: ```
566: 
567: ✅ **Good**: Explicit error messages
568: ```bash
569: error_exit "state.json not found. Run /plan to create it."
570: ```
571: 
572: ❌ **Bad**: Silent failures
573: ```bash
574: cat state.json 2>/dev/null  # Hides the problem
575: ```
576: 
577: ---
578: 
579: ## Real Examples from Core Plugins
580: 
581: ### Example 1: `/status` Command
582: 
583: Demonstrates stateless design and file-based state:
584: 
585: ```bash
586: # From plugins/core/commands/status.md
587: 
588: # Load active work
589: ACTIVE_WORK=$(cat .claude/work/ACTIVE_WORK 2>/dev/null || echo "")
590: 
591: if [ -z "$ACTIVE_WORK" ]; then
592:     echo "No active work unit"
593: else
594:     # Reconstruct state from files
595:     STATE_FILE=".claude/work/current/${ACTIVE_WORK}/state.json"
596: 
597:     if [ -f "$STATE_FILE" ]; then
598:         STATUS=$(jq -r '.status' "$STATE_FILE")
599:         TASKS=$(jq '.tasks | length' "$STATE_FILE")
600:         COMPLETE=$(jq '[.tasks[] | select(.status=="completed")] | length' "$STATE_FILE")
601: 
602:         echo "Work Unit: $ACTIVE_WORK"
603:         echo "Status: $STATUS"
604:         echo "Progress: $COMPLETE/$TASKS tasks"
605:     fi
606: fi
607: ```
608: 
609: **Design principles applied**:
610: - ✅ Stateless: Reads state from files every time
611: - ✅ File-based: All state in JSON files
612: - ✅ Self-contained: All logic inline
613: - ✅ Idempotent: Safe to run multiple times
614: - ✅ Graceful: Handles missing files
615: 
616: ### Example 2: `/next` Command
617: 
618: Demonstrates atomic operations and git integration:
619: 
620: ```bash
621: # From plugins/workflow/commands/next.md
622: 
623: # Select next task
624: NEXT_TASK=$(jq -r '.next_available[0]' state.json)
625: 
626: if [ -z "$NEXT_TASK" ]; then
627:     echo "✅ All tasks complete!"
628:     exit 0
629: fi
630: 
631: # Execute task
632: execute_task "$NEXT_TASK"
633: 
634: # Update state atomically
635: jq ".completed_tasks += [\"$NEXT_TASK\"]" state.json > state.json.tmp
636: mv state.json.tmp state.json
637: 
638: # Commit checkpoint
639: git add state.json
640: git commit -m "Complete $NEXT_TASK"
641: 
642: echo "✅ Task complete"
643: echo "→ Run /next again to continue"
644: ```
645: 
646: **Design principles applied**:
647: - ✅ Atomic: Complete operation in one invocation
648: - ✅ Git checkpoint: Commit creates recovery point
649: - ✅ User guidance: Clear next steps
650: - ✅ State update: Explicit file modification
651: 
652: ### Example 3: `/plan` Command
653: 
654: Demonstrates reconstruction from exploration:
655: 
656: ```bash
657: # From plugins/workflow/commands/plan.md
658: 
659: # Find exploration document
660: EXPLORATION="exploration.md"
661: 
662: if [ ! -f "$EXPLORATION" ]; then
663:     error_exit "No exploration found. Run /explore first."
664: fi
665: 
666: # Reconstruct context from exploration
667: CONTEXT=$(cat "$EXPLORATION")
668: 
669: # Generate implementation plan
670: # (Claude processes exploration and creates plan)
671: 
672: # Write state file
673: cat > state.json <<EOF
674: {
675:   "status": "planning_complete",
676:   "tasks": [...],
677:   "created_at": "$(date -Iseconds)"
678: }
679: EOF
680: 
681: echo "✅ Implementation plan created"
682: echo "→ Run /next to start execution"
683: ```
684: 
685: **Design principles applied**:
686: - ✅ Reconstruction: Builds context from files
687: - ✅ Clear dependencies: Requires /explore first
688: - ✅ State transition: Updates status file
689: - ✅ User guidance: Shows next action
690: 
691: ---
692: 
693: ## Summary
694: 
695: ### The Five Core Principles
696: 
697: 1. **Stateless Execution**: Nothing persists between invocations
698: 2. **File-Based Persistence**: Use file system as database
699: 3. **Self-Containment**: All logic inline, no external sourcing
700: 4. **Execution Context**: Commands are templates executed in project directory
701: 5. **MCP Optional**: All features work without MCP, graceful degradation
702: 
703: ### Design Checklist
704: 
705: When creating commands, ensure:
706: 
707: - [ ] No persistent connections or background processes
708: - [ ] All state explicitly stored in files
709: - [ ] All utilities copied inline (no external sourcing)
710: - [ ] Idempotent operations (safe to repeat)
711: - [ ] Atomic transactions (complete in one invocation)
712: - [ ] Git commits for checkpoints
713: - [ ] Clear error messages
714: - [ ] Graceful MCP degradation
715: - [ ] User guidance on next steps
716: 
717: ### Common Mistakes to Avoid
718: 
719: ❌ Expecting variables to persist
720: ❌ Trying to maintain connections
721: ❌ Sourcing external utility scripts
722: ❌ Assuming MCP tools are available
723: ❌ Silent failures without clear errors
724: ❌ Complex state synchronization
725: ❌ Background processes or watchers
726: 
727: ### Key Takeaways
728: 
729: 1. **Statelessness is a feature** - Design with it, not against it
730: 2. **Files are your database** - Embrace file-based persistence
731: 3. **Git is your state machine** - Use commits as checkpoints
732: 4. **Duplication is correct** - Self-containment requires it
733: 5. **MCP enhances, not replaces** - Always provide fallbacks
734: 
735: ---
736: 
737: ## Further Reading
738: 
739: - [Plugin Patterns](patterns.md) - Common patterns for commands and agents
740: - [Framework Constraints](constraints.md) - Technical limitations and boundaries
741: - [Why Duplication Exists](../reference/why-duplication-exists.md) - Rationale for inline utilities
742: - [Quick Start Tutorial](../getting-started/quick-start.md) - See principles in action
743: - [First Plugin Tutorial](../getting-started/first-plugin.md) - Build with these principles
744: 
745: ---
746: 
747: *These design principles enable reliable, predictable, and maintainable Claude Code plugins across all domains.*
````

## File: docs/architecture/patterns.md
````markdown
   1: # Plugin Patterns
   2: 
   3: Common patterns for building effective Claude Code plugins. These patterns are proven approaches used in the core plugins and can be adapted to your domain-specific needs.
   4: 
   5: ## Table of Contents
   6: 
   7: - [Command Patterns](#command-patterns)
   8: - [Agent Patterns](#agent-patterns)
   9: - [Workflow Patterns](#workflow-patterns)
  10: - [Integration Patterns](#integration-patterns)
  11: - [Anti-Patterns](#anti-patterns)
  12: 
  13: ---
  14: 
  15: ## Command Patterns
  16: 
  17: Commands are the primary way users interact with plugins. These patterns help you create effective, user-friendly commands.
  18: 
  19: ### Simple Command Pattern
  20: 
  21: **Use When**: Single-purpose command with minimal logic
  22: 
  23: **Structure**:
  24: ```markdown
  25: ---
  26: name: greet
  27: description: Simple greeting command
  28: allowed-tools: [Bash]
  29: argument-hint: "[name]"
  30: ---
  31: 
  32: # Greet Command
  33: 
  34: **Input**: $ARGUMENTS
  35: 
  36: ## Implementation
  37: 
  38: ```bash
  39: #!/bin/bash
  40: NAME="${1:-World}"
  41: echo "Hello, $NAME!"
  42: ```
  43: ```
  44: 
  45: **Real Example**: `/status` from core plugin
  46: ```markdown
  47: ---
  48: name: status
  49: description: Unified view of work, system, and memory state
  50: allowed-tools: [Read, Bash, Glob]
  51: argument-hint: "[verbose]"
  52: ---
  53: 
  54: # Status Command
  55: 
  56: I'll show you a comprehensive view of your current work state.
  57: 
  58: ## Implementation
  59: 
  60: ```bash
  61: #!/bin/bash
  62: 
  63: # Standard constants (must be copied)
  64: readonly CLAUDE_DIR=".claude"
  65: readonly WORK_DIR="${CLAUDE_DIR}/work"
  66: 
  67: # Check for active work
  68: if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
  69:     ACTIVE=$(cat "${WORK_DIR}/ACTIVE_WORK")
  70:     echo "📁 Active Work: $ACTIVE"
  71: else
  72:     echo "No active work unit"
  73: fi
  74: ```
  75: ```
  76: 
  77: **When to Use**:
  78: - ✅ Single clear purpose
  79: - ✅ Minimal state management
  80: - ✅ Quick execution (<5 seconds)
  81: - ✅ No complex dependencies
  82: 
  83: ---
  84: 
  85: ### Parametric Command Pattern
  86: 
  87: **Use When**: Command needs multiple arguments or flags
  88: 
  89: **Structure**:
  90: ```markdown
  91: ---
  92: name: deploy
  93: description: Deploy application to environment
  94: allowed-tools: [Bash]
  95: argument-hint: "[environment] [--dry-run] [--version VERSION]"
  96: ---
  97: 
  98: # Deploy Command
  99: 
 100: **Input**: $ARGUMENTS
 101: 
 102: ## Implementation
 103: 
 104: ```bash
 105: #!/bin/bash
 106: 
 107: # Parse arguments
 108: ENVIRONMENT=""
 109: DRY_RUN=false
 110: VERSION="latest"
 111: 
 112: while [[ $# -gt 0 ]]; do
 113:     case $1 in
 114:         --dry-run)
 115:             DRY_RUN=true
 116:             shift
 117:             ;;
 118:         --version)
 119:             VERSION="$2"
 120:             shift 2
 121:             ;;
 122:         *)
 123:             ENVIRONMENT="$1"
 124:             shift
 125:             ;;
 126:     esac
 127: done
 128: 
 129: # Validate required
 130: if [ -z "$ENVIRONMENT" ]; then
 131:     echo "ERROR: Environment required"
 132:     exit 1
 133: fi
 134: 
 135: # Execute
 136: if [ "$DRY_RUN" = true ]; then
 137:     echo "🔍 DRY RUN: Would deploy $VERSION to $ENVIRONMENT"
 138: else
 139:     echo "🚀 Deploying $VERSION to $ENVIRONMENT..."
 140: fi
 141: ```
 142: ```
 143: 
 144: **Real Example**: `/explore` from workflow plugin
 145: ```markdown
 146: ---
 147: name: explore
 148: description: Explore requirements and codebase
 149: allowed-tools: [Task, Bash, Read, Write, Grep]
 150: argument-hint: "[source: @file, #issue, description] [--work-unit ID]"
 151: ---
 152: 
 153: # Requirements Exploration
 154: 
 155: ```bash
 156: #!/bin/bash
 157: 
 158: # Parse different source types
 159: REQUIREMENT_SOURCE=""
 160: REQUIREMENT_TYPE="description"
 161: WORK_UNIT_ID=""
 162: 
 163: # Check for @file reference
 164: if [[ "$ARGUMENTS" =~ @([^ ]+) ]]; then
 165:     REQUIREMENT_SOURCE="${BASH_REMATCH[1]}"
 166:     REQUIREMENT_TYPE="file"
 167: fi
 168: 
 169: # Check for #issue reference
 170: if [[ "$ARGUMENTS" =~ \#([0-9]+) ]]; then
 171:     REQUIREMENT_SOURCE="${BASH_REMATCH[1]}"
 172:     REQUIREMENT_TYPE="issue"
 173: fi
 174: 
 175: # Check for --work-unit flag
 176: if [[ "$ARGUMENTS" =~ --work-unit[[:space:]]+([^ ]+) ]]; then
 177:     WORK_UNIT_ID="${BASH_REMATCH[1]}"
 178: fi
 179: 
 180: # Process based on type
 181: case "$REQUIREMENT_TYPE" in
 182:     file)
 183:         cat "$REQUIREMENT_SOURCE"
 184:         ;;
 185:     issue)
 186:         gh issue view "$REQUIREMENT_SOURCE"
 187:         ;;
 188:     *)
 189:         # Use description directly
 190:         echo "$ARGUMENTS"
 191:         ;;
 192: esac
 193: ```
 194: ```
 195: 
 196: **When to Use**:
 197: - ✅ Multiple configuration options
 198: - ✅ Optional flags or modes
 199: - ✅ Different input sources
 200: - ✅ Complex user workflows
 201: 
 202: ---
 203: 
 204: ### Stateful Command Pattern
 205: 
 206: **Use When**: Command manages or transitions state
 207: 
 208: **Structure**:
 209: ```markdown
 210: ---
 211: name: next
 212: description: Execute next available task
 213: allowed-tools: [Bash, Read, Edit, Write]
 214: ---
 215: 
 216: # Next Task Execution
 217: 
 218: ## Implementation
 219: 
 220: ```bash
 221: #!/bin/bash
 222: 
 223: readonly STATE_FILE=".claude/work/current/ACTIVE/state.json"
 224: 
 225: # Read current state
 226: if [ ! -f "$STATE_FILE" ]; then
 227:     echo "ERROR: No state file found"
 228:     exit 1
 229: fi
 230: 
 231: CURRENT_STATUS=$(jq -r '.status' "$STATE_FILE")
 232: 
 233: # Select next task based on state
 234: NEXT_TASK=$(jq -r '.next_available[0]' "$STATE_FILE")
 235: 
 236: if [ -z "$NEXT_TASK" ]; then
 237:     echo "✅ All tasks complete!"
 238:     exit 0
 239: fi
 240: 
 241: echo "🚀 Executing: $NEXT_TASK"
 242: 
 243: # Execute task (Claude processes this)
 244: # ... task execution ...
 245: 
 246: # Update state atomically
 247: jq ".completed_tasks += [\"$NEXT_TASK\"]" "$STATE_FILE" > "$STATE_FILE.tmp"
 248: mv "$STATE_FILE.tmp" "$STATE_FILE"
 249: 
 250: # Commit checkpoint
 251: git add "$STATE_FILE"
 252: git commit -m "Complete $NEXT_TASK"
 253: 
 254: echo "✅ Task complete. Run /next to continue."
 255: ```
 256: ```
 257: 
 258: **Real Example**: `/next` from workflow plugin implements this exactly
 259: 
 260: **When to Use**:
 261: - ✅ Multi-step workflows
 262: - ✅ State transitions
 263: - ✅ Resumable operations
 264: - ✅ Progress tracking
 265: 
 266: ---
 267: 
 268: ### Phased Workflow Pattern
 269: 
 270: **Use When**: Command has distinct sequential phases
 271: 
 272: **Structure**:
 273: ```markdown
 274: ---
 275: name: analyze
 276: description: Analyze codebase with systematic phases
 277: allowed-tools: [Task, Grep, Read, Write]
 278: ---
 279: 
 280: # Codebase Analysis
 281: 
 282: ## Phase 1: Discovery
 283: Identify components and structure...
 284: 
 285: ## Phase 2: Deep Analysis
 286: Examine patterns and relationships...
 287: 
 288: ## Phase 3: Assessment
 289: Evaluate quality and maintainability...
 290: 
 291: ## Phase 4: Recommendations
 292: Provide actionable insights...
 293: 
 294: ## Phase 5: Documentation
 295: Create analysis report...
 296: 
 297: ## Implementation
 298: 
 299: ```bash
 300: #!/bin/bash
 301: 
 302: # Phase tracking
 303: PHASE_FILE=".claude/analysis_phase.txt"
 304: 
 305: # Determine current phase
 306: if [ ! -f "$PHASE_FILE" ]; then
 307:     PHASE="discovery"
 308: else
 309:     PHASE=$(cat "$PHASE_FILE")
 310: fi
 311: 
 312: echo "📊 Phase: $PHASE"
 313: 
 314: # Execute phase
 315: case "$PHASE" in
 316:     discovery)
 317:         # Discovery logic
 318:         echo "analysis" > "$PHASE_FILE"
 319:         ;;
 320:     analysis)
 321:         # Analysis logic
 322:         echo "assessment" > "$PHASE_FILE"
 323:         ;;
 324:     # ... more phases
 325: esac
 326: ```
 327: ```
 328: 
 329: **Real Example**: `/ship` from workflow plugin
 330: - Phase 1: Pre-delivery validation
 331: - Phase 2: Final tests
 332: - Phase 3: Documentation generation
 333: - Phase 4: Git operations (commit/PR)
 334: - Phase 5: Delivery summary
 335: 
 336: **When to Use**:
 337: - ✅ Complex multi-step processes
 338: - ✅ Each phase has clear purpose
 339: - ✅ Phases must execute in order
 340: - ✅ Resumable after interruption
 341: 
 342: ---
 343: 
 344: ## Agent Patterns
 345: 
 346: Agents are specialized AI assistants with focused expertise. These patterns help you create effective agents.
 347: 
 348: ### Specialist Agent Pattern
 349: 
 350: **Use When**: Need focused expertise in specific domain
 351: 
 352: **Structure**:
 353: ```markdown
 354: ---
 355: name: code-reviewer
 356: description: Code quality and security review specialist
 357: capabilities: ["code-review", "security-analysis", "best-practices"]
 358: allowed-tools: [Read, Grep, Bash]
 359: ---
 360: 
 361: # Code Reviewer Agent
 362: 
 363: You are a specialized code review agent with expertise in:
 364: - Code quality and maintainability
 365: - Security vulnerabilities
 366: - Performance issues
 367: - Best practices adherence
 368: 
 369: ## Your Role
 370: 
 371: Perform thorough code reviews focusing on:
 372: 1. **Bugs**: Logic errors and potential failures
 373: 2. **Security**: Vulnerabilities and attack vectors
 374: 3. **Performance**: Inefficiencies and bottlenecks
 375: 4. **Maintainability**: Code clarity and structure
 376: 
 377: ## Guidelines
 378: 
 379: 1. **Be Specific**: Point to exact line numbers
 380: 2. **Explain Why**: Don't just flag issues, explain impact
 381: 3. **Provide Fixes**: Suggest concrete improvements
 382: 4. **Prioritize**: Rank findings by severity
 383: 
 384: ## Output Format
 385: 
 386: ```
 387: ## High Priority Issues
 388: - [File:Line] Issue description and fix
 389: 
 390: ## Medium Priority Issues
 391: - [File:Line] Issue description and fix
 392: 
 393: ## Low Priority Issues
 394: - [File:Line] Issue description and fix
 395: 
 396: ## Summary
 397: X total issues found (X high, X medium, X low)
 398: ```
 399: 
 400: ## Limitations
 401: 
 402: - Cannot execute code or run tests
 403: - Cannot modify files (only recommend changes)
 404: - Focus on static analysis
 405: ```
 406: 
 407: **Real Example**: `code-reviewer` from development plugin
 408: 
 409: **When to Use**:
 410: - ✅ Specialized knowledge required
 411: - ✅ Consistent evaluation criteria
 412: - ✅ Repeatable analysis process
 413: - ✅ Well-defined boundaries
 414: 
 415: ---
 416: 
 417: ### Validator Agent Pattern
 418: 
 419: **Use When**: Need to verify specific criteria
 420: 
 421: **Structure**:
 422: ```markdown
 423: ---
 424: name: quant-validator
 425: description: Validate quantitative finance code
 426: capabilities: ["backtest-validation", "risk-checks"]
 427: ---
 428: 
 429: # Quantitative Finance Validator
 430: 
 431: You are a specialized validator for quantitative finance code.
 432: 
 433: ## Validation Criteria
 434: 
 435: ### Data Validation
 436: - [ ] No look-ahead bias in indicators
 437: - [ ] Proper timestamp handling
 438: - [ ] Missing data handled correctly
 439: 
 440: ### Risk Validation
 441: - [ ] Position sizing within limits
 442: - [ ] Stop-loss mechanisms present
 443: - [ ] Maximum drawdown calculated
 444: 
 445: ### Performance Validation
 446: - [ ] Sharpe ratio > 1.0
 447: - [ ] Win rate documented
 448: - [ ] Transaction costs included
 449: 
 450: ## Process
 451: 
 452: 1. **Read code**: Understand the strategy
 453: 2. **Check criteria**: Verify each validation point
 454: 3. **Report findings**: List violations with evidence
 455: 4. **Suggest fixes**: Provide specific corrections
 456: 
 457: ## Output Format
 458: 
 459: ```
 460: ✅ Passed: X/Y validations
 461: 
 462: ❌ Failed Validations:
 463: - [Criterion]: Evidence and fix
 464: 
 465: ⚠️ Warnings:
 466: - [Criterion]: Potential issue and recommendation
 467: ```
 468: ```
 469: 
 470: **When to Use**:
 471: - ✅ Domain-specific validation rules
 472: - ✅ Compliance checking
 473: - ✅ Quality gates
 474: - ✅ Repeatable verification
 475: 
 476: ---
 477: 
 478: ### Generator Agent Pattern
 479: 
 480: **Use When**: Need to create structured content
 481: 
 482: **Structure**:
 483: ```markdown
 484: ---
 485: name: test-engineer
 486: description: Generate comprehensive test suites
 487: capabilities: ["test-generation", "coverage-analysis"]
 488: allowed-tools: [Read, Write, Bash]
 489: ---
 490: 
 491: # Test Engineer Agent
 492: 
 493: You are a specialized test generation agent.
 494: 
 495: ## Your Role
 496: 
 497: Generate comprehensive test suites including:
 498: - Unit tests with edge cases
 499: - Integration tests
 500: - Test fixtures and mocks
 501: - Performance benchmarks
 502: 
 503: ## Test Generation Process
 504: 
 505: 1. **Analyze Code**: Understand functionality
 506: 2. **Identify Test Cases**: Edge cases, boundaries, failures
 507: 3. **Generate Tests**: Write complete test suite
 508: 4. **Create Fixtures**: Test data and mocks
 509: 5. **Document**: Explain test coverage
 510: 
 511: ## Test Quality Standards
 512: 
 513: - ✅ Each function has unit tests
 514: - ✅ Edge cases covered (null, empty, max/min)
 515: - ✅ Error conditions tested
 516: - ✅ Integration points verified
 517: - ✅ Test names are descriptive
 518: 
 519: ## Output Format
 520: 
 521: ```python
 522: # Test file: test_module.py
 523: 
 524: import pytest
 525: from module import function
 526: 
 527: class TestFunction:
 528:     """Tests for function."""
 529: 
 530:     def test_normal_case(self):
 531:         """Test normal operation."""
 532:         assert function(5) == 25
 533: 
 534:     def test_edge_case_zero(self):
 535:         """Test edge case: zero input."""
 536:         assert function(0) == 0
 537: 
 538:     def test_error_negative(self):
 539:         """Test error handling: negative input."""
 540:         with pytest.raises(ValueError):
 541:             function(-1)
 542: ```
 543: ```
 544: 
 545: **Real Example**: `test-engineer` from development plugin
 546: 
 547: **When to Use**:
 548: - ✅ Structured content generation
 549: - ✅ Template-based output
 550: - ✅ Consistent formatting needed
 551: - ✅ Scaffolding and boilerplate
 552: 
 553: ---
 554: 
 555: ## Workflow Patterns
 556: 
 557: Workflows combine commands and agents into cohesive processes.
 558: 
 559: ### Four-Phase Workflow Pattern
 560: 
 561: **The Core Pattern**: `EXPLORE → PLAN → EXECUTE → DELIVER`
 562: 
 563: This is the recommended workflow pattern used by Claude Code's core plugins.
 564: 
 565: #### Phase 1: EXPLORE (`/explore`)
 566: **Purpose**: Understand the problem and gather context
 567: 
 568: **Pattern**:
 569: ```markdown
 570: ## Exploration Phase
 571: 
 572: ### Requirement Analysis
 573: 1. Parse user input (description, @file, #issue)
 574: 2. Load relevant context and documentation
 575: 3. Identify constraints and dependencies
 576: 4. Document findings in exploration.md
 577: 
 578: ### Codebase Exploration
 579: 1. Identify relevant files and components
 580: 2. Understand existing patterns
 581: 3. Note integration points
 582: 4. Map dependencies
 583: 
 584: ### Output
 585: - exploration.md with structured analysis
 586: - requirements.md if needed
 587: - Work unit directory created
 588: ```
 589: 
 590: **Real Implementation**: `/explore` command
 591: - Supports multiple input sources (@file, #issue, description)
 592: - Uses Task tool for systematic exploration
 593: - Creates work unit with exploration.md
 594: - Loads project context from memory
 595: 
 596: #### Phase 2: PLAN (`/plan`)
 597: **Purpose**: Break work into manageable tasks
 598: 
 599: **Pattern**:
 600: ```markdown
 601: ## Planning Phase
 602: 
 603: ### Task Breakdown
 604: 1. Review exploration findings
 605: 2. Identify major components
 606: 3. Break into atomic tasks
 607: 4. Define dependencies
 608: 5. Set acceptance criteria
 609: 
 610: ### State Creation
 611: 1. Generate implementation-plan.md
 612: 2. Create state.json with tasks
 613: 3. Set estimated times
 614: 4. Mark initial status
 615: 
 616: ### Output
 617: - implementation-plan.md (human-readable)
 618: - state.json (machine-readable)
 619: - metadata.json (work unit info)
 620: ```
 621: 
 622: **Real Implementation**: `/plan` command
 623: - Reads exploration.md
 624: - Creates ordered task list
 625: - Defines dependencies
 626: - Sets acceptance criteria
 627: - Creates state.json for /next
 628: 
 629: #### Phase 3: EXECUTE (`/next`)
 630: **Purpose**: Work through tasks systematically
 631: 
 632: **Pattern**:
 633: ```markdown
 634: ## Execution Phase
 635: 
 636: ### Task Selection
 637: 1. Load state.json
 638: 2. Check dependencies
 639: 3. Select next available task
 640: 4. Verify prerequisites
 641: 
 642: ### Task Execution
 643: 1. Display task details
 644: 2. Execute implementation
 645: 3. Verify acceptance criteria
 646: 4. Handle errors gracefully
 647: 
 648: ### State Update
 649: 1. Mark task complete
 650: 2. Update state.json
 651: 3. Git commit checkpoint
 652: 4. Identify next tasks
 653: 
 654: ### Output
 655: - Completed task deliverables
 656: - Updated state.json
 657: - Git commit with attribution
 658: - Progress report
 659: ```
 660: 
 661: **Real Implementation**: `/next` command
 662: - Reads state.json
 663: - Selects based on dependencies
 664: - Executes one task at a time
 665: - Updates state atomically
 666: - Auto-commits with proper message
 667: 
 668: #### Phase 4: DELIVER (`/ship`)
 669: **Purpose**: Finalize and package work
 670: 
 671: **Pattern**:
 672: ```markdown
 673: ## Delivery Phase
 674: 
 675: ### Pre-Delivery Validation
 676: 1. Verify all tasks complete
 677: 2. Run final tests
 678: 3. Check code quality
 679: 4. Validate documentation
 680: 
 681: ### Packaging
 682: 1. Generate completion summary
 683: 2. Create pull request (if --pr)
 684: 3. Tag release (if --tag)
 685: 4. Update work unit status
 686: 
 687: ### Output
 688: - Completion summary
 689: - Pull request (optional)
 690: - Git tag (optional)
 691: - Delivery report
 692: ```
 693: 
 694: **Real Implementation**: `/ship` command
 695: - Validates completion
 696: - Runs quality checks
 697: - Creates PR with comprehensive description
 698: - Generates delivery summary
 699: - Marks work unit complete
 700: 
 701: **When to Use Four-Phase Workflow**:
 702: - ✅ Non-trivial features (>1 hour)
 703: - ✅ Multiple file changes
 704: - ✅ Complex requirements
 705: - ✅ Team collaboration needed
 706: 
 707: **When NOT to Use**:
 708: - ❌ Single-line fixes
 709: - ❌ Typo corrections
 710: - ❌ Quick documentation updates
 711: 
 712: ---
 713: 
 714: ### Progressive Refinement Pattern
 715: 
 716: **Use When**: Iterative improvement over multiple cycles
 717: 
 718: **Pattern**:
 719: ```
 720: DRAFT → REVIEW → REFINE → REVIEW → FINALIZE
 721:   ↓       ↓        ↓        ↓         ↓
 722: v0.1    v0.2     v0.3     v0.4      v1.0
 723: ```
 724: 
 725: **Example: Book Chapter Workflow**
 726: 1. **/outline**: Create chapter structure
 727: 2. **/draft**: Write first draft
 728: 3. **/review**: Analyze quality and clarity
 729: 4. **/refine**: Improve based on feedback
 730: 5. **/publish**: Finalize for publication
 731: 
 732: **When to Use**:
 733: - ✅ Creative content (writing, design)
 734: - ✅ Quality improvement cycles
 735: - ✅ Incremental refinement
 736: - ✅ Feedback incorporation
 737: 
 738: ---
 739: 
 740: ### Validation Gate Pattern
 741: 
 742: **Use When**: Quality checkpoints between phases
 743: 
 744: **Pattern**:
 745: ```
 746: DEVELOP → [GATE 1: Tests] → REVIEW → [GATE 2: Security] → DEPLOY
 747:            ✅ or ❌                    ✅ or ❌
 748: ```
 749: 
 750: **Implementation**:
 751: ```bash
 752: # Gate 1: Tests must pass
 753: run_tests() {
 754:     pytest tests/ || error_exit "Tests failed - fix before proceeding"
 755: }
 756: 
 757: # Gate 2: Security scan
 758: security_scan() {
 759:     bandit -r src/ || error_exit "Security issues found"
 760: }
 761: 
 762: # Only proceed if gates pass
 763: run_tests && security_scan && proceed_to_next_phase
 764: ```
 765: 
 766: **When to Use**:
 767: - ✅ Critical quality requirements
 768: - ✅ Compliance needs
 769: - ✅ High-risk changes
 770: - ✅ Production deployments
 771: 
 772: ---
 773: 
 774: ## Integration Patterns
 775: 
 776: Patterns for integrating with external systems and tools.
 777: 
 778: ### MCP Tool Integration Pattern
 779: 
 780: **Use When**: Enhancing commands with MCP capabilities
 781: 
 782: **Pattern**:
 783: ```bash
 784: # Check if MCP tool available
 785: if command -v serena &> /dev/null; then
 786:     # Enhanced path: Use MCP tool
 787:     serena find_symbol "MyClass"
 788: else
 789:     # Fallback path: Use standard tools
 790:     grep -r "class MyClass" src/
 791: fi
 792: ```
 793: 
 794: **Real Example**: From core plugins
 795: ```markdown
 796: ---
 797: allowed-tools: [Read, Grep, mcp__serena__find_symbol, mcp__serena__get_symbols_overview]
 798: ---
 799: 
 800: ```bash
 801: #!/bin/bash
 802: 
 803: # Try Serena for semantic search
 804: if command -v serena &> /dev/null; then
 805:     # 70-90% token reduction with semantic search
 806:     serena find_symbol "$SYMBOL_NAME"
 807: else
 808:     # Fallback to grep
 809:     grep -r "class $SYMBOL_NAME\|function $SYMBOL_NAME" .
 810: fi
 811: ```
 812: ```
 813: 
 814: **MCP Tools in Core Plugins**:
 815: - **Sequential Thinking**: Complex analysis (explore, analyze)
 816: - **Serena**: Semantic code search (analyze, review, fix)
 817: - **Context7**: Documentation access (docs fetch)
 818: - **Firecrawl**: Web research (explore with URLs)
 819: 
 820: **When to Use**:
 821: - ✅ Performance optimization available
 822: - ✅ Enhanced capabilities valuable
 823: - ✅ Graceful degradation possible
 824: - ✅ User experience improves
 825: 
 826: ---
 827: 
 828: ### Plugin-to-Plugin Integration Pattern
 829: 
 830: **Use When**: One plugin extends another
 831: 
 832: **Pattern**:
 833: ```markdown
 834: ---
 835: name: ml-experiment
 836: description: Run ML experiment (extends /run)
 837: ---
 838: 
 839: # ML Experiment Command
 840: 
 841: This extends the /run command with ML-specific features.
 842: 
 843: ## Implementation
 844: 
 845: ```bash
 846: #!/bin/bash
 847: 
 848: # 1. Setup ML environment
 849: setup_ml_env() {
 850:     # ML-specific setup
 851:     export CUDA_VISIBLE_DEVICES=0
 852:     source venv/bin/activate
 853: }
 854: 
 855: # 2. Use core /run functionality
 856: run_experiment() {
 857:     # Leverage /run command
 858:     # (user can invoke it manually or we set up files for it)
 859:     python train.py --config $CONFIG
 860: }
 861: 
 862: # 3. ML-specific post-processing
 863: track_metrics() {
 864:     # Log to MLflow, wandb, etc.
 865:     mlflow log-metric "accuracy" $ACCURACY
 866: }
 867: 
 868: setup_ml_env
 869: run_experiment
 870: track_metrics
 871: ```
 872: ```
 873: 
 874: **When to Use**:
 875: - ✅ Domain-specific extension
 876: - ✅ Core functionality exists
 877: - ✅ Additional features needed
 878: - ✅ Maintain plugin separation
 879: 
 880: ---
 881: 
 882: ### External System Integration Pattern
 883: 
 884: **Use When**: Integrating with APIs, databases, or services
 885: 
 886: **Pattern**:
 887: ```bash
 888: # Integrate with external API
 889: integrate_external_api() {
 890:     local api_key="${API_KEY:-$(cat .env | grep API_KEY | cut -d= -f2)}"
 891: 
 892:     if [ -z "$api_key" ]; then
 893:         error_exit "API_KEY not found in environment or .env"
 894:     fi
 895: 
 896:     # Make API call with error handling
 897:     response=$(curl -s -w "%{http_code}" \
 898:         -H "Authorization: Bearer $api_key" \
 899:         -H "Content-Type: application/json" \
 900:         -d '{"query":"data"}' \
 901:         https://api.example.com/v1/endpoint)
 902: 
 903:     http_code="${response: -3}"
 904:     body="${response:0:-3}"
 905: 
 906:     if [ "$http_code" != "200" ]; then
 907:         error_exit "API call failed: HTTP $http_code - $body"
 908:     fi
 909: 
 910:     echo "$body"
 911: }
 912: ```
 913: 
 914: **When to Use**:
 915: - ✅ External services required
 916: - ✅ API credentials managed
 917: - ✅ Error handling needed
 918: - ✅ Connection ephemeral (stateless)
 919: 
 920: ---
 921: 
 922: ## Anti-Patterns
 923: 
 924: Common mistakes to avoid when building plugins.
 925: 
 926: ### ❌ Fighting Statelessness
 927: 
 928: **Wrong**: Trying to maintain state between invocations
 929: ```bash
 930: # DON'T DO THIS
 931: COUNTER=0
 932: increment() {
 933:     COUNTER=$((COUNTER + 1))  # Lost on next invocation!
 934: }
 935: ```
 936: 
 937: **Right**: Use file-based state
 938: ```bash
 939: # DO THIS
 940: COUNTER_FILE=".claude/counter.txt"
 941: increment() {
 942:     local count=$(cat "$COUNTER_FILE" 2>/dev/null || echo 0)
 943:     echo $((count + 1)) > "$COUNTER_FILE"
 944: }
 945: ```
 946: 
 947: ---
 948: 
 949: ### ❌ External Script Sourcing
 950: 
 951: **Wrong**: Trying to source external utilities
 952: ```bash
 953: # DON'T DO THIS
 954: source ~/.claude/lib/utils.sh  # File not found! (wrong directory)
 955: ```
 956: 
 957: **Right**: Copy utilities inline
 958: ```bash
 959: # DO THIS
 960: error_exit() {
 961:     echo "ERROR: $1" >&2
 962:     exit 1
 963: }
 964: # (Copy this to every command that needs it)
 965: ```
 966: 
 967: **Why**: Commands execute in project directory, not ~/.claude/commands/
 968: 
 969: ---
 970: 
 971: ### ❌ Complex Logic in Markdown
 972: 
 973: **Wrong**: Trying to implement complex logic in templates
 974: ```markdown
 975: <!-- DON'T DO THIS -->
 976: {{#if user.isAdmin}}
 977:   Show admin panel
 978: {{else}}
 979:   Show user panel
 980: {{/if}}
 981: ```
 982: 
 983: **Right**: Let AI handle logic, template provides structure
 984: ```markdown
 985: <!-- DO THIS -->
 986: ## User Interface
 987: 
 988: I'll determine the appropriate interface based on user role and display accordingly.
 989: ```
 990: 
 991: ---
 992: 
 993: ### ❌ Assuming MCP Availability
 994: 
 995: **Wrong**: Requiring MCP tools
 996: ```bash
 997: # DON'T DO THIS
 998: serena find_symbol "MyClass"  # Fails if Serena not installed!
 999: ```
1000: 
1001: **Right**: Graceful degradation
1002: ```bash
1003: # DO THIS
1004: if command -v serena &> /dev/null; then
1005:     serena find_symbol "MyClass"
1006: else
1007:     grep -r "class MyClass" src/
1008: fi
1009: ```
1010: 
1011: ---
1012: 
1013: ### ❌ Silent Failures
1014: 
1015: **Wrong**: Ignoring errors
1016: ```bash
1017: # DON'T DO THIS
1018: cat file.txt 2>/dev/null  # Silently fails if file missing
1019: ```
1020: 
1021: **Right**: Explicit error handling
1022: ```bash
1023: # DO THIS
1024: if [ ! -f "file.txt" ]; then
1025:     error_exit "file.txt not found. Create it first with /init"
1026: fi
1027: cat file.txt
1028: ```
1029: 
1030: ---
1031: 
1032: ### ❌ Over-Engineering
1033: 
1034: **Wrong**: Building complex frameworks
1035: ```bash
1036: # DON'T DO THIS
1037: # Creating elaborate plugin dependency system
1038: # With plugin managers, loaders, and registries
1039: ```
1040: 
1041: **Right**: Simple, composable patterns
1042: ```bash
1043: # DO THIS
1044: # Each plugin is independent
1045: # Users enable what they need
1046: # Plugins work standalone
1047: ```
1048: 
1049: ---
1050: 
1051: ## Summary
1052: 
1053: ### Command Patterns Recap
1054: - **Simple**: Single-purpose, minimal logic
1055: - **Parametric**: Multiple arguments, flags, options
1056: - **Stateful**: Manages state transitions
1057: - **Phased**: Sequential workflow phases
1058: 
1059: ### Agent Patterns Recap
1060: - **Specialist**: Focused domain expertise
1061: - **Validator**: Verify specific criteria
1062: - **Generator**: Create structured content
1063: 
1064: ### Workflow Patterns Recap
1065: - **Four-Phase**: Explore → Plan → Execute → Deliver
1066: - **Progressive Refinement**: Iterative improvement
1067: - **Validation Gate**: Quality checkpoints
1068: 
1069: ### Integration Patterns Recap
1070: - **MCP Tools**: Enhanced capabilities with fallbacks
1071: - **Plugin-to-Plugin**: Domain-specific extensions
1072: - **External Systems**: API and service integration
1073: 
1074: ### Key Principles
1075: 
1076: 1. **Embrace Constraints**: Work with statelessness, not against it
1077: 2. **File-Centric**: All state persists to files
1078: 3. **Self-Contained**: Each command has all needed logic
1079: 4. **Graceful Degradation**: Always provide fallbacks
1080: 5. **Explicit Over Implicit**: Make everything clear
1081: 6. **Simple Over Complex**: Patterns that compose well
1082: 
1083: ---
1084: 
1085: ## Further Reading
1086: 
1087: - [Design Principles](design-principles.md) - Core architectural principles
1088: - [Framework Constraints](constraints.md) - Technical limitations
1089: - [Quick Start Tutorial](../getting-started/quick-start.md) - See patterns in action
1090: - [First Plugin Tutorial](../getting-started/first-plugin.md) - Build with these patterns
1091: 
1092: ---
1093: 
1094: *These patterns enable building effective, maintainable Claude Code plugins that work reliably across all use cases.*
````

## File: docs/getting-started/first-plugin.md
````markdown
  1: # Creating Your First Plugin
  2: 
  3: Learn how to build a custom Claude Code plugin from scratch in 30 minutes. This hands-on tutorial walks you through creating, testing, and publishing a working plugin.
  4: 
  5: ## What You'll Build
  6: 
  7: A simple "hello-world" plugin that demonstrates:
  8: - Plugin structure and configuration
  9: - Command creation with parameters
 10: - Agent creation for specialized tasks
 11: - Local testing and debugging
 12: - Publishing to a marketplace
 13: 
 14: **Result**: A working plugin you can use and share
 15: 
 16: ## Prerequisites
 17: 
 18: Before starting, ensure you have:
 19: 
 20: - ✅ Claude Code v3.0+ installed
 21: - ✅ Basic familiarity with Claude Code (try the [Quick Start](quick-start.md) first)
 22: - ✅ Text editor for writing markdown
 23: - ✅ Git installed (for version control and publishing)
 24: - ✅ 30 minutes of focused time
 25: 
 26: ## Plugin Architecture Overview
 27: 
 28: A Claude Code plugin has this structure:
 29: 
 30: ```
 31: my-plugin/
 32: ├── .claude-plugin/
 33: │   └── plugin.json        # Required: Plugin manifest
 34: ├── commands/              # Optional: Slash commands
 35: │   ├── greet.md
 36: │   └── farewell.md
 37: ├── agents/                # Optional: Specialized agents
 38: │   └── translator.md
 39: ├── hooks/                 # Optional: Event handlers
 40: │   └── pre-commit.sh
 41: ├── .mcp.json             # Optional: MCP server config
 42: └── README.md             # Recommended: Documentation
 43: ```
 44: 
 45: **Key Concepts**:
 46: - **plugin.json**: Defines plugin metadata, capabilities, and what it provides
 47: - **commands/**: Markdown files that become `/command-name` slash commands
 48: - **agents/**: Specialized AI agents that perform focused tasks
 49: - **hooks/**: Scripts that run on specific events (git hooks, tool hooks)
 50: 
 51: ---
 52: 
 53: ## Step 1: Create Plugin Structure (5 minutes)
 54: 
 55: ### Create the Directory
 56: 
 57: Choose a location for your plugin development:
 58: 
 59: ```bash
 60: # Create plugin directory
 61: mkdir -p ~/my-plugins/hello-world
 62: cd ~/my-plugins/hello-world
 63: 
 64: # Create required structure
 65: mkdir -p .claude-plugin
 66: mkdir -p commands
 67: mkdir -p agents
 68: 
 69: # Verify structure
 70: tree -L 2
 71: # Should show:
 72: # .
 73: # ├── .claude-plugin/
 74: # ├── commands/
 75: # └── agents/
 76: ```
 77: 
 78: ### Create plugin.json
 79: 
 80: The manifest file tells Claude Code about your plugin.
 81: 
 82: Create `.claude-plugin/plugin.json`:
 83: 
 84: ```json
 85: {
 86:   "name": "hello-world",
 87:   "version": "1.0.0",
 88:   "description": "A simple hello-world plugin demonstrating Claude Code plugin basics",
 89:   "author": "Your Name",
 90:   "keywords": ["tutorial", "example", "hello-world"],
 91:   "commands": ["commands/*.md"],
 92:   "agents": ["agents/*.md"],
 93:   "settings": {
 94:     "defaultEnabled": false,
 95:     "category": "tutorial"
 96:   },
 97:   "repository": {
 98:     "type": "git",
 99:     "url": "https://github.com/yourusername/hello-world-plugin"
100:   },
101:   "license": "MIT",
102:   "capabilities": {
103:     "greeting": {
104:       "description": "Personalized greetings",
105:       "command": "greet"
106:     },
107:     "translation": {
108:       "description": "Simple text translation",
109:       "agent": "translator"
110:     }
111:   },
112:   "dependencies": {},
113:   "mcpTools": {
114:     "optional": [],
115:     "gracefulDegradation": true
116:   }
117: }
118: ```
119: 
120: **Field Explanations**:
121: - **name**: Unique identifier (lowercase, hyphens, no spaces)
122: - **version**: Semantic versioning (MAJOR.MINOR.PATCH)
123: - **commands**: Glob pattern for command files
124: - **agents**: Glob pattern for agent files
125: - **capabilities**: What your plugin provides (for documentation)
126: - **mcpTools**: Optional MCP tool dependencies
127: 
128: ---
129: 
130: ## Step 2: Create Your First Command (10 minutes)
131: 
132: Commands are markdown files with frontmatter and implementation.
133: 
134: ### Command Structure
135: 
136: Create `commands/greet.md`:
137: 
138: ```markdown
139: ---
140: name: greet
141: description: Greet the user with a personalized message
142: allowed-tools: [Bash]
143: argument-hint: "[name] [--formal]"
144: ---
145: 
146: # Greet Command
147: 
148: I'll greet you with a personalized message!
149: 
150: **Input**: $ARGUMENTS
151: 
152: ## Implementation
153: 
154: ```bash
155: #!/bin/bash
156: 
157: # Parse arguments
158: NAME="${1:-World}"
159: FORMAL=false
160: 
161: # Check for --formal flag
162: for arg in "$@"; do
163:     if [[ "$arg" == "--formal" ]]; then
164:         FORMAL=true
165:     fi
166: done
167: 
168: # Generate greeting
169: if [ "$FORMAL" = true ]; then
170:     echo "Good day, ${NAME}! It is a pleasure to make your acquaintance."
171: else
172:     echo "Hey ${NAME}! 👋 Great to see you!"
173: fi
174: 
175: # Show usage tip
176: echo ""
177: echo "💡 Tip: Use '/greet YourName --formal' for a formal greeting"
178: ```
179: ```
180: 
181: **Key Elements**:
182: 
183: 1. **Frontmatter** (YAML between `---` markers):
184:    - `name`: Command name (becomes `/greet`)
185:    - `description`: Short description for help text
186:    - `allowed-tools`: Which Claude tools the command can use
187:    - `argument-hint`: Shown in help text
188: 
189: 2. **Documentation Section**:
190:    - Explain what the command does
191:    - Use `$ARGUMENTS` to show user input
192: 
193: 3. **Implementation**:
194:    - Bash script inside triple backticks
195:    - Must be self-contained (no external scripts)
196:    - Handle arguments gracefully
197: 
198: ### Create a Second Command
199: 
200: Create `commands/farewell.md`:
201: 
202: ```markdown
203: ---
204: name: farewell
205: description: Say goodbye with style
206: allowed-tools: [Bash]
207: argument-hint: "[name]"
208: ---
209: 
210: # Farewell Command
211: 
212: I'll say goodbye in a memorable way!
213: 
214: **Input**: $ARGUMENTS
215: 
216: ## Implementation
217: 
218: ```bash
219: #!/bin/bash
220: 
221: NAME="${1:-friend}"
222: 
223: # Random farewell style
224: STYLES=("See you later, ${NAME}! 🚀"
225:         "Farewell, ${NAME}! Until next time! 👋"
226:         "Goodbye, ${NAME}! Happy coding! 💻"
227:         "Catch you on the flip side, ${NAME}! ✨")
228: 
229: # Pick random style
230: RANDOM_INDEX=$(( RANDOM % ${#STYLES[@]} ))
231: echo "${STYLES[$RANDOM_INDEX]}"
232: ```
233: ```
234: 
235: ---
236: 
237: ## Step 3: Create a Specialized Agent (8 minutes)
238: 
239: Agents are AI assistants with focused responsibilities.
240: 
241: ### Agent Structure
242: 
243: Create `agents/translator.md`:
244: 
245: ```markdown
246: ---
247: name: translator
248: description: Translate text between languages using AI understanding
249: capabilities: ["text-translation", "language-detection"]
250: allowed-tools: [Bash]
251: ---
252: 
253: # Translator Agent
254: 
255: You are a specialized translation agent with expertise in multiple languages.
256: 
257: ## Your Role
258: 
259: - Translate text accurately between languages
260: - Detect source language automatically if not specified
261: - Maintain tone and context during translation
262: - Explain cultural nuances when relevant
263: 
264: ## Guidelines
265: 
266: 1. **Accuracy First**: Prioritize correct translation over literal word-for-word
267: 2. **Context Matters**: Consider context to choose appropriate translations
268: 3. **Tone Preservation**: Maintain the original tone (formal, casual, technical)
269: 4. **Cultural Sensitivity**: Note when direct translation loses cultural meaning
270: 
271: ## Task Format
272: 
273: When invoked, you will receive:
274: - **Text**: The text to translate
275: - **Target Language**: Language to translate to
276: - **Source Language**: (Optional) Source language
277: 
278: ## Example Invocation
279: 
280: User: "Translate 'Hello, how are you?' to Spanish"
281: 
282: You respond:
283: ```
284: Translation: "Hola, ¿cómo estás?"
285: 
286: Notes:
287: - Informal "tú" form used (casual tone)
288: - For formal context, use "Hola, ¿cómo está?"
289: - Cultural note: Spanish greetings often include physical gestures
290: ```
291: 
292: ## Response Format
293: 
294: Always structure your response as:
295: 
296: ```
297: Translation: [translated text]
298: 
299: Notes:
300: - [Any relevant context]
301: - [Alternative translations if applicable]
302: - [Cultural or usage notes]
303: ```
304: 
305: ## Limitations
306: 
307: - Cannot translate images or audio
308: - May need clarification for ambiguous phrases
309: - Cultural idioms may require explanation rather than direct translation
310: ```
311: 
312: **Agent Best Practices**:
313: - Define clear role and responsibilities
314: - Provide concrete guidelines
315: - Show example interactions
316: - Specify response format
317: - State limitations clearly
318: 
319: ---
320: 
321: ## Step 4: Test Your Plugin Locally (5 minutes)
322: 
323: ### Configure Claude Code Settings
324: 
325: Add your plugin to `.claude/settings.json` (create if doesn't exist):
326: 
327: ```json
328: {
329:   "extraKnownMarketplaces": {
330:     "my-local-plugins": {
331:       "source": {
332:         "source": "directory",
333:         "path": "/home/youruser/my-plugins"
334:       }
335:     }
336:   },
337:   "enabledPlugins": {
338:     "hello-world@my-local-plugins": true
339:   }
340: }
341: ```
342: 
343: **Important**: Use **absolute path** (not `~/` or relative paths).
344: 
345: ### Restart Claude Code
346: 
347: Close and reopen Claude Code to load your plugin.
348: 
349: ### Test Your Commands
350: 
351: ```bash
352: # Test the greet command
353: /greet Alice
354: 
355: # Expected output:
356: # Hey Alice! 👋 Great to see you!
357: #
358: # 💡 Tip: Use '/greet YourName --formal' for a formal greeting
359: 
360: # Test formal greeting
361: /greet Bob --formal
362: 
363: # Expected output:
364: # Good day, Bob! It is a pleasure to make your acquaintance.
365: #
366: # 💡 Tip: Use '/greet YourName --formal' for a formal greeting
367: 
368: # Test farewell
369: /farewell Charlie
370: 
371: # Expected output (random):
372: # See you later, Charlie! 🚀
373: ```
374: 
375: ### Test Your Agent
376: 
377: In Claude Code, invoke the agent:
378: 
379: ```
380: Use the translator agent to translate "Good morning" to French
381: ```
382: 
383: Claude should use your translator agent and provide a structured translation.
384: 
385: ### Verify Plugin Loading
386: 
387: Check that your plugin is recognized:
388: 
389: ```bash
390: /help
391: ```
392: 
393: You should see `/greet` and `/farewell` listed in available commands.
394: 
395: ---
396: 
397: ## Step 5: Add Documentation (2 minutes)
398: 
399: Create `README.md` in your plugin root:
400: 
401: ```markdown
402: # Hello World Plugin
403: 
404: A simple tutorial plugin demonstrating Claude Code plugin basics.
405: 
406: ## Features
407: 
408: - `/greet [name] [--formal]` - Personalized greetings
409: - `/farewell [name]` - Random farewell messages
410: - `translator` agent - Text translation with cultural context
411: 
412: ## Installation
413: 
414: Add to your `.claude/settings.json`:
415: 
416: ```json
417: {
418:   "extraKnownMarketplaces": {
419:     "hello-world": {
420:       "source": {
421:         "source": "github",
422:         "repo": "yourusername/hello-world-plugin"
423:       }
424:     }
425:   },
426:   "enabledPlugins": {
427:     "hello-world@hello-world": true
428:   }
429: }
430: ```
431: 
432: Restart Claude Code.
433: 
434: ## Usage
435: 
436: ### Commands
437: 
438: ```bash
439: # Basic greeting
440: /greet Alice
441: 
442: # Formal greeting
443: /greet Bob --formal
444: 
445: # Say goodbye
446: /farewell Charlie
447: ```
448: 
449: ### Agents
450: 
451: Ask Claude to use the translator agent:
452: 
453: ```
454: Use the translator agent to translate this to Spanish: "Welcome to Claude Code"
455: ```
456: 
457: ## Development
458: 
459: This plugin was created following the [First Plugin Tutorial](https://github.com/applied-artificial-intelligence/claude-code-plugins/blob/main/docs/getting-started/first-plugin.md).
460: 
461: ## License
462: 
463: MIT
464: ```
465: 
466: ---
467: 
468: ## Step 6: Publish to GitHub (Optional)
469: 
470: ### Initialize Git Repository
471: 
472: ```bash
473: cd ~/my-plugins/hello-world
474: 
475: # Initialize git
476: git init
477: 
478: # Create .gitignore
479: cat > .gitignore << 'EOF'
480: # IDE
481: .vscode/
482: .idea/
483: 
484: # OS
485: .DS_Store
486: Thumbs.db
487: 
488: # Temp files
489: *.tmp
490: *.log
491: EOF
492: 
493: # Initial commit
494: git add .
495: git commit -m "feat: Initial hello-world plugin
496: 
497: - Add greet and farewell commands
498: - Add translator agent
499: - Complete plugin.json manifest
500: - Add README documentation
501: "
502: ```
503: 
504: ### Push to GitHub
505: 
506: ```bash
507: # Create repo on GitHub first, then:
508: git remote add origin https://github.com/yourusername/hello-world-plugin.git
509: git branch -M main
510: git push -u origin main
511: ```
512: 
513: ### Tag Your Release
514: 
515: ```bash
516: # Create version tag
517: git tag -a v1.0.0 -m "Release v1.0.0: Initial hello-world plugin"
518: git push origin v1.0.0
519: ```
520: 
521: ### Share Your Plugin
522: 
523: Now others can install your plugin using:
524: 
525: ```json
526: {
527:   "extraKnownMarketplaces": {
528:     "hello-world": {
529:       "source": {
530:         "source": "github",
531:         "repo": "yourusername/hello-world-plugin"
532:       }
533:     }
534:   },
535:   "enabledPlugins": {
536:     "hello-world@hello-world": true
537:   }
538: }
539: ```
540: 
541: ---
542: 
543: ## Common Pitfalls and Debugging
544: 
545: ### Plugin Not Loading
546: 
547: **Symptom**: Commands not available after restart
548: 
549: **Solutions**:
550: 
551: 1. **Check plugin.json syntax**
552:    ```bash
553:    # Validate JSON
554:    jq . .claude-plugin/plugin.json
555:    # Should output formatted JSON with no errors
556:    ```
557: 
558: 2. **Verify marketplace path**
559:    ```bash
560:    # Check path in settings.json
561:    cat ~/.claude/settings.json | jq '.extraKnownMarketplaces'
562: 
563:    # Verify directory exists and has correct structure
564:    ls -la /path/to/your/plugin/.claude-plugin/
565:    # Should show plugin.json
566:    ```
567: 
568: 3. **Check plugin name format**
569:    - Use lowercase with hyphens only
570:    - No spaces, underscores, or special characters
571:    - Example: `hello-world` ✅, `Hello_World` ❌
572: 
573: ### Commands Not Working
574: 
575: **Symptom**: Command runs but produces errors
576: 
577: **Solutions**:
578: 
579: 1. **Check frontmatter format**
580:    ```markdown
581:    ---
582:    name: greet
583:    description: Greet the user
584:    allowed-tools: [Bash]
585:    ---
586:    ```
587:    - Must have three dashes `---` above and below
588:    - YAML syntax (colon after key, space before value)
589:    - List syntax for arrays: `[Tool1, Tool2]`
590: 
591: 2. **Verify bash script syntax**
592:    ```bash
593:    # Extract and test bash section
594:    # Copy the implementation code to test.sh
595:    bash -n test.sh
596:    # Should show no syntax errors
597:    ```
598: 
599: 3. **Check allowed-tools**
600:    - Command uses Bash but frontmatter doesn't allow it
601:    - Add `allowed-tools: [Bash]` to frontmatter
602: 
603: ### Agent Not Being Invoked
604: 
605: **Symptom**: Claude doesn't use your agent
606: 
607: **Solutions**:
608: 
609: 1. **Be explicit in invocation**
610:    ```
611:    ❌ "Translate this to French"
612:    ✅ "Use the translator agent to translate this to French"
613:    ```
614: 
615: 2. **Check agent name**
616:    - Agent file: `agents/translator.md`
617:    - Name in frontmatter: `name: translator`
618:    - Both must match
619: 
620: 3. **Verify agent is listed in plugin.json**
621:    ```json
622:    "agents": ["agents/*.md"]
623:    ```
624: 
625: ### Settings Not Taking Effect
626: 
627: **Symptom**: Changed settings.json but plugin still not loaded
628: 
629: **Solutions**:
630: 
631: 1. **Restart Claude Code completely**
632:    - Close ALL Claude Code windows
633:    - Wait 5 seconds
634:    - Reopen Claude Code
635: 
636: 2. **Check settings precedence**
637:    - Project `.claude/settings.json` overrides global `~/.claude/settings.json`
638:    - Make sure you're editing the right file
639: 
640: 3. **Validate JSON syntax**
641:    ```bash
642:    jq . ~/.claude/settings.json
643:    # Should output formatted JSON
644:    ```
645: 
646: ---
647: 
648: ## Advanced Topics
649: 
650: ### Adding MCP Tool Support
651: 
652: If your plugin uses MCP tools, declare them:
653: 
654: ```json
655: {
656:   "mcpTools": {
657:     "optional": ["sequential-thinking", "serena"],
658:     "gracefulDegradation": true
659:   }
660: }
661: ```
662: 
663: **Graceful Degradation Example**:
664: 
665: ```bash
666: #!/bin/bash
667: 
668: # Try to use Serena for semantic search
669: if command -v serena &> /dev/null; then
670:     # Use Serena (faster, more accurate)
671:     serena find_symbol "MyClass"
672: else
673:     # Fallback to grep (slower but works)
674:     grep -r "class MyClass" .
675: fi
676: ```
677: 
678: ### Adding Hooks
679: 
680: Hooks run on specific events. Create `hooks/pre-commit.sh`:
681: 
682: ```bash
683: #!/bin/bash
684: 
685: # Run before git commit
686: echo "🔍 Running pre-commit checks..."
687: 
688: # Check for debug statements
689: if grep -r "console.log\|debugger" src/ 2>/dev/null; then
690:     echo "❌ Found debug statements. Remove before committing."
691:     exit 1
692: fi
693: 
694: echo "✅ Pre-commit checks passed"
695: exit 0
696: ```
697: 
698: Declare in `plugin.json`:
699: 
700: ```json
701: {
702:   "hooks": {
703:     "pre-commit": "hooks/pre-commit.sh"
704:   }
705: }
706: ```
707: 
708: ### Creating Parametric Commands
709: 
710: Commands with complex argument parsing:
711: 
712: ```markdown
713: ---
714: name: deploy
715: description: Deploy application to environment
716: allowed-tools: [Bash]
717: argument-hint: "[environment] [--dry-run] [--version VERSION]"
718: ---
719: 
720: # Deploy Command
721: 
722: **Input**: $ARGUMENTS
723: 
724: ## Implementation
725: 
726: ```bash
727: #!/bin/bash
728: 
729: # Parse arguments
730: ENVIRONMENT=""
731: DRY_RUN=false
732: VERSION="latest"
733: 
734: # Simple argument parser
735: while [[ $# -gt 0 ]]; do
736:     case $1 in
737:         --dry-run)
738:             DRY_RUN=true
739:             shift
740:             ;;
741:         --version)
742:             VERSION="$2"
743:             shift 2
744:             ;;
745:         *)
746:             ENVIRONMENT="$1"
747:             shift
748:             ;;
749:     esac
750: done
751: 
752: # Validate required arguments
753: if [ -z "$ENVIRONMENT" ]; then
754:     echo "ERROR: Environment required"
755:     echo "Usage: /deploy <environment> [--dry-run] [--version VERSION]"
756:     exit 1
757: fi
758: 
759: # Execute deployment
760: if [ "$DRY_RUN" = true ]; then
761:     echo "🔍 DRY RUN: Would deploy version $VERSION to $ENVIRONMENT"
762: else
763:     echo "🚀 Deploying version $VERSION to $ENVIRONMENT..."
764:     # Actual deployment logic here
765: fi
766: ```
767: ```
768: 
769: ---
770: 
771: ## Next Steps
772: 
773: Now that you've created your first plugin:
774: 
775: 1. **Explore Existing Plugins**: Study the [claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins) repository
776:    - Look at `plugins/core/` for command examples
777:    - Study `plugins/workflow/` for complex workflows
778:    - Review `plugins/development/` for agent patterns
779: 
780: 2. **Read Architecture Docs**: Understand design principles
781:    - [Design Principles](../architecture/design-principles.md) - Stateless execution, file-based persistence
782:    - [Plugin Patterns](../architecture/patterns.md) - Common patterns and best practices
783:    - [Framework Constraints](../architecture/constraints.md) - What you can and cannot do
784: 
785: 3. **Build Something Real**: Apply what you learned
786:    - Automate a repetitive task in your workflow
787:    - Create commands for your specific domain
788:    - Build agents for specialized tasks
789: 
790: 4. **Share Your Work**: Contribute to the ecosystem
791:    - Publish your plugin to GitHub
792:    - Share in [Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
793:    - Consider submitting to the official marketplace
794: 
795: ## Quick Reference
796: 
797: ### Plugin Structure
798: ```
799: my-plugin/
800: ├── .claude-plugin/
801: │   └── plugin.json        # REQUIRED: Manifest
802: ├── commands/              # Slash commands
803: ├── agents/                # AI agents
804: ├── hooks/                 # Event handlers
805: └── README.md              # Documentation
806: ```
807: 
808: ### Minimal plugin.json
809: ```json
810: {
811:   "name": "my-plugin",
812:   "version": "1.0.0",
813:   "description": "What it does",
814:   "author": "Your Name",
815:   "commands": ["commands/*.md"],
816:   "license": "MIT"
817: }
818: ```
819: 
820: ### Command Template
821: ```markdown
822: ---
823: name: command-name
824: description: What it does
825: allowed-tools: [Bash]
826: ---
827: 
828: # Command Name
829: 
830: **Input**: $ARGUMENTS
831: 
832: ## Implementation
833: 
834: ```bash
835: #!/bin/bash
836: echo "Hello from command"
837: ```
838: ```
839: 
840: ### Agent Template
841: ```markdown
842: ---
843: name: agent-name
844: description: What it does
845: capabilities: ["capability1", "capability2"]
846: ---
847: 
848: # Agent Name
849: 
850: You are a specialized agent that [does something specific].
851: 
852: [Agent instructions and guidelines]
853: ```
854: 
855: ## Getting Help
856: 
857: - **Documentation**: [Full plugin documentation](../README.md)
858: - **Examples**: Browse [official plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins)
859: - **Issues**: Report bugs at [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
860: - **Discussions**: Ask questions in [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
861: 
862: ---
863: 
864: **Congratulations!** 🎉
865: 
866: You've created your first Claude Code plugin. You now understand:
867: - Plugin structure and configuration
868: - Command creation with parameters
869: - Agent creation for specialized tasks
870: - Local testing and debugging
871: - Publishing to GitHub
872: 
873: **Ready for more?** Build a plugin that solves a real problem in your workflow!
````

## File: docs/reference/commands.md
````markdown
  1: # Commands Reference
  2: 
  3: Complete reference for all commands across Claude Code plugins.
  4: 
  5: ## Overview
  6: 
  7: This reference is auto-generated from plugin manifests and provides comprehensive
  8: documentation for all available commands organized by plugin.
  9: 
 10: **Total Commands**: 30 across 5 plugins
 11: 
 12: ---
 13: 
 14: ## Quick Navigation
 15: 
 16: - [core](#core) (14 commands) - Core framework commands for Claude Code - essential system functionality
 17: - [development](#development) (8 commands) - Code development and quality assurance tools - analyze, test, fix, review
 18: - [git](#git) (1 commands) - Unified git operations - commits, pull requests, and issue management
 19: - [memory](#memory) (3 commands) - Active memory management and maintenance for Claude Code framework
 20: - [workflow](#workflow) (4 commands) - Structured development workflow - explore, plan, implement, deliver
 21: 
 22: ---
 23: 
 24: ## core
 25: 
 26: **Description**: Core framework commands for Claude Code - essential system functionality
 27: 
 28: **Version**: 1.0.0
 29: 
 30: **Category**: core
 31: 
 32: **Source**: [https://github.com/applied-artificial-intelligence/claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins/core)
 33: 
 34: ### Commands
 35: 
 36: #### `/add-command`
 37: 
 38: Create new custom slash commands
 39: 
 40: **Plugin**: core
 41: 
 42: **More Info**: See [plugin README](../../plugins/core/README.md)
 43: 
 44: ---
 45: 
 46: #### `/agent`
 47: 
 48: Direct invocation of specialized agents
 49: 
 50: **Plugin**: core
 51: 
 52: **More Info**: See [plugin README](../../plugins/core/README.md)
 53: 
 54: ---
 55: 
 56: #### `/audit`
 57: 
 58: Framework setup and infrastructure compliance audit
 59: 
 60: **Plugin**: core
 61: 
 62: **More Info**: See [plugin README](../../plugins/core/README.md)
 63: 
 64: ---
 65: 
 66: #### `/cleanup`
 67: 
 68: Clean up Claude-generated clutter and consolidate documentation
 69: 
 70: **Plugin**: core
 71: 
 72: **More Info**: See [plugin README](../../plugins/core/README.md)
 73: 
 74: ---
 75: 
 76: #### `/config`
 77: 
 78: Manage framework settings and project preferences
 79: 
 80: **Plugin**: core
 81: 
 82: **More Info**: See [plugin README](../../plugins/core/README.md)
 83: 
 84: ---
 85: 
 86: #### `/docs`
 87: 
 88: Fetch, search, and generate project documentation
 89: 
 90: **Plugin**: core
 91: 
 92: **More Info**: See [plugin README](../../plugins/core/README.md)
 93: 
 94: ---
 95: 
 96: #### `/handoff`
 97: 
 98: Create transition documents with context analysis
 99: 
100: **Plugin**: core
101: 
102: **More Info**: See [plugin README](../../plugins/core/README.md)
103: 
104: ---
105: 
106: #### `/index`
107: 
108: Create and maintain persistent project understanding
109: 
110: **Plugin**: core
111: 
112: **More Info**: See [plugin README](../../plugins/core/README.md)
113: 
114: ---
115: 
116: #### `/performance`
117: 
118: View token usage and performance metrics
119: 
120: **Plugin**: core
121: 
122: **More Info**: See [plugin README](../../plugins/core/README.md)
123: 
124: ---
125: 
126: #### `/serena`
127: 
128: Activate and manage Serena semantic code understanding
129: 
130: **Plugin**: core
131: 
132: **More Info**: See [plugin README](../../plugins/core/README.md)
133: 
134: ---
135: 
136: #### `/setup`
137: 
138: Initialize new projects with Claude framework integration
139: 
140: **Plugin**: core
141: 
142: **More Info**: See [plugin README](../../plugins/core/README.md)
143: 
144: ---
145: 
146: #### `/spike`
147: 
148: Time-boxed exploration in isolated branch
149: 
150: **Plugin**: core
151: 
152: **More Info**: See [plugin README](../../plugins/core/README.md)
153: 
154: ---
155: 
156: #### `/status`
157: 
158: Display project and task status
159: 
160: **Plugin**: core
161: 
162: **More Info**: See [plugin README](../../plugins/core/README.md)
163: 
164: ---
165: 
166: #### `/work`
167: 
168: Manage work units and parallel streams
169: 
170: **Plugin**: core
171: 
172: **More Info**: See [plugin README](../../plugins/core/README.md)
173: 
174: ---
175: 
176: ## development
177: 
178: **Description**: Code development and quality assurance tools - analyze, test, fix, review
179: 
180: **Version**: 1.0.0
181: 
182: **Category**: development
183: 
184: **Source**: [https://github.com/applied-artificial-intelligence/claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins/development)
185: 
186: ### Commands
187: 
188: #### `/analyze`
189: 
190: Deep codebase analysis with semantic understanding
191: 
192: **Plugin**: development
193: 
194: **More Info**: See [plugin README](../../plugins/development/README.md)
195: 
196: ---
197: 
198: #### `/evaluate`
199: 
200: Compare experiments and identify best performers
201: 
202: **Plugin**: development
203: 
204: **More Info**: See [plugin README](../../plugins/development/README.md)
205: 
206: ---
207: 
208: #### `/experiment`
209: 
210: Run ML experiments with tracking
211: 
212: **Plugin**: development
213: 
214: **More Info**: See [plugin README](../../plugins/development/README.md)
215: 
216: ---
217: 
218: #### `/fix`
219: 
220: Universal debugging and fix application with semantic analysis
221: 
222: **Plugin**: development
223: 
224: **More Info**: See [plugin README](../../plugins/development/README.md)
225: 
226: ---
227: 
228: #### `/report`
229: 
230: Generate professional stakeholder reports from data
231: 
232: **Plugin**: development
233: 
234: **More Info**: See [plugin README](../../plugins/development/README.md)
235: 
236: ---
237: 
238: #### `/review`
239: 
240: Code review focused on bugs, design flaws, and quality
241: 
242: **Plugin**: development
243: 
244: **More Info**: See [plugin README](../../plugins/development/README.md)
245: 
246: ---
247: 
248: #### `/run`
249: 
250: Execute code or scripts with monitoring and timeout control
251: 
252: **Plugin**: development
253: 
254: **More Info**: See [plugin README](../../plugins/development/README.md)
255: 
256: ---
257: 
258: #### `/test`
259: 
260: Test-driven development workflow using test-engineer agent
261: 
262: **Plugin**: development
263: 
264: **More Info**: See [plugin README](../../plugins/development/README.md)
265: 
266: ---
267: 
268: ## git
269: 
270: **Description**: Unified git operations - commits, pull requests, and issue management
271: 
272: **Version**: 1.0.0
273: 
274: **Category**: tools
275: 
276: **Source**: [https://github.com/applied-artificial-intelligence/claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins/git)
277: 
278: ### Commands
279: 
280: #### `/git`
281: 
282: Unified git operations including commits, pull requests, and issue management
283: 
284: **Plugin**: git
285: 
286: **More Info**: See [plugin README](../../plugins/git/README.md)
287: 
288: ---
289: 
290: ## memory
291: 
292: **Description**: Active memory management and maintenance for Claude Code framework
293: 
294: **Version**: 1.0.0
295: 
296: **Category**: core
297: 
298: **Source**: [https://github.com/applied-artificial-intelligence/claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins/memory)
299: 
300: ### Commands
301: 
302: #### `/memory-gc`
303: 
304: Identify and clean up stale memory entries
305: 
306: **Plugin**: memory
307: 
308: **More Info**: See [plugin README](../../plugins/memory/README.md)
309: 
310: ---
311: 
312: #### `/memory-review`
313: 
314: Display current memory state with timestamps and sizes
315: 
316: **Plugin**: memory
317: 
318: **More Info**: See [plugin README](../../plugins/memory/README.md)
319: 
320: ---
321: 
322: #### `/memory-update`
323: 
324: Interactive memory maintenance with add/update/remove/relocate operations
325: 
326: **Plugin**: memory
327: 
328: **More Info**: See [plugin README](../../plugins/memory/README.md)
329: 
330: ---
331: 
332: ## workflow
333: 
334: **Description**: Structured development workflow - explore, plan, implement, deliver
335: 
336: **Version**: 1.0.0
337: 
338: **Category**: workflow
339: 
340: **Source**: [https://github.com/applied-artificial-intelligence/claude-code-plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/tree/main/plugins/workflow)
341: 
342: ### Commands
343: 
344: #### `/explore`
345: 
346: Explore requirements and codebase with systematic analysis
347: 
348: **Plugin**: workflow
349: 
350: **More Info**: See [plugin README](../../plugins/workflow/README.md)
351: 
352: ---
353: 
354: #### `/next`
355: 
356: Execute next available task from implementation plan
357: 
358: **Plugin**: workflow
359: 
360: **More Info**: See [plugin README](../../plugins/workflow/README.md)
361: 
362: ---
363: 
364: #### `/plan`
365: 
366: Create detailed implementation plan with ordered tasks and dependencies
367: 
368: **Plugin**: workflow
369: 
370: **More Info**: See [plugin README](../../plugins/workflow/README.md)
371: 
372: ---
373: 
374: #### `/ship`
375: 
376: Deliver completed work with validation and comprehensive documentation
377: 
378: **Plugin**: workflow
379: 
380: **More Info**: See [plugin README](../../plugins/workflow/README.md)
381: 
382: ---
383: 
384: 
385: ## Usage Notes
386: 
387: ### Command Syntax
388: 
389: All commands follow the slash command pattern:
390: ```bash
391: /command-name [arguments] [--flags]
392: ```
393: 
394: ### Getting Help
395: 
396: For detailed usage of any command:
397: - Refer to the plugin README for comprehensive examples
398: - Check command inline help (if available)
399: - Visit the [getting started guide](../getting-started/quick-start.md)
400: 
401: ### Plugin Management
402: 
403: To enable/disable plugins and their commands, see the [installation guide](../getting-started/installation.md).
404: 
405: ---
406: 
407: **Auto-generated**: This reference is automatically generated from plugin manifests.
408: **Last Updated**: 2025-10-18 18:21:42
409: **Generator**: scripts/generate-commands-reference.py
````

## File: docs/README.md
````markdown
 1: # Documentation
 2: 
 3: Complete documentation for Claude Code Plugins framework.
 4: 
 5: ## Quick Navigation
 6: 
 7: ### Getting Started
 8: - [Installation Guide](getting-started/installation.md) - Set up the framework
 9: - [Quick Start Tutorial](getting-started/quick-start.md) - Your first workflow
10: - [Your First Plugin](getting-started/first-plugin.md) - Build a custom plugin
11: 
12: ### Guides
13: - [Workflow Guide](guides/workflow-guide.md) - Using explore → plan → next → ship
14: - [Memory Management](guides/memory-management.md) - Persistent context best practices
15: - [MCP Integration](guides/mcp-integration.md) - Model Context Protocol patterns
16: - [Plugin Creation](guides/plugin-creation.md) - Building custom plugins
17: 
18: ### Reference
19: - [Commands Reference](reference/commands.md) - All 30+ commands documented
20: - [Agents Reference](reference/agents.md) - Specialized agent capabilities
21: - [Configuration](reference/configuration.md) - Settings and customization
22: 
23: ### Architecture
24: - [Design Principles](architecture/design-principles.md) - Core framework philosophy
25: - [Framework Patterns](architecture/patterns.md) - Reusable patterns
26: - [System Constraints](architecture/constraints.md) - What the framework can/cannot do
27: 
28: ## Documentation Status
29: 
30: 🚧 **Under Construction**: Documentation is being actively developed.
31: 
32: - ✅ README and getting started
33: - 🚧 Guides (in progress)
34: - 📋 Reference (planned)
35: - 📋 Architecture (planned)
36: 
37: ## Contributing to Documentation
38: 
39: See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on improving documentation.
40: 
41: Quick tips:
42: - Fix typos or unclear language
43: - Add examples to clarify concepts
44: - Improve organization
45: - Add tutorials for common use cases
````

## File: plugins/core/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "claude-code-core",
 3:   "version": "1.0.0",
 4:   "description": "Core framework commands for Claude Code - essential system functionality",
 5:   "author": "Claude Code Framework",
 6:   "keywords": ["core", "framework", "essential", "system"],
 7:   "commands": ["commands/*.md"],
 8:   "agents": ["agents/auditor.md", "agents/reasoning-specialist.md"],
 9:   "settings": {
10:     "defaultEnabled": true,
11:     "category": "core",
12:     "required": true
13:   },
14:   "repository": {
15:     "type": "git",
16:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
17:   },
18:   "license": "MIT",
19:   "capabilities": {
20:     "statusMonitoring": {
21:       "description": "Display project and task status",
22:       "command": "status"
23:     },
24:     "workManagement": {
25:       "description": "Manage work units and parallel streams",
26:       "command": "work"
27:     },
28:     "configManagement": {
29:       "description": "Manage framework settings and project preferences",
30:       "command": "config"
31:     },
32:     "agentInvocation": {
33:       "description": "Direct invocation of specialized agents",
34:       "command": "agent"
35:     },
36:     "projectCleanup": {
37:       "description": "Clean up Claude-generated clutter and consolidate documentation",
38:       "command": "cleanup"
39:     },
40:     "projectIndexing": {
41:       "description": "Create and maintain persistent project understanding",
42:       "command": "index"
43:     },
44:     "performanceMonitoring": {
45:       "description": "View token usage and performance metrics",
46:       "command": "performance"
47:     },
48:     "sessionHandoff": {
49:       "description": "Create transition documents with context analysis",
50:       "command": "handoff"
51:     },
52:     "documentationOps": {
53:       "description": "Fetch, search, and generate project documentation",
54:       "command": "docs"
55:     },
56:     "projectSetup": {
57:       "description": "Initialize new projects with Claude framework integration",
58:       "command": "setup"
59:     },
60:     "commandCreation": {
61:       "description": "Create new custom slash commands",
62:       "command": "add-command"
63:     },
64:     "frameworkAudit": {
65:       "description": "Framework setup and infrastructure compliance audit",
66:       "command": "audit"
67:     },
68:     "serenaSetup": {
69:       "description": "Activate and manage Serena semantic code understanding",
70:       "command": "serena"
71:     },
72:     "spikeExploration": {
73:       "description": "Time-boxed exploration in isolated branch",
74:       "command": "spike"
75:     }
76:   },
77:   "dependencies": {},
78:   "mcpTools": {
79:     "optional": ["sequential-thinking", "serena"],
80:     "gracefulDegradation": true
81:   }
82: }
````

## File: plugins/core/.claude-plugin/README.md
````markdown
  1: # Claude Code Core Plugin
  2: 
  3: **Version**: 1.0.0
  4: **Category**: Core (Required)
  5: **Author**: Claude Code Framework
  6: 
  7: ## Overview
  8: 
  9: The Core Plugin provides essential system functionality for Claude Code. This plugin is **required** and cannot be disabled. It includes fundamental commands for project management, configuration, monitoring, and system operations.
 10: 
 11: ## Commands
 12: 
 13: ### Project Management
 14: 
 15: #### `/status [verbose]`
 16: Display current project and task status.
 17: 
 18: **Usage**:
 19: ```bash
 20: /status           # Quick status overview
 21: /status verbose   # Detailed status with metrics
 22: ```
 23: 
 24: **Shows**:
 25: - Current work unit and phase
 26: - Active tasks and completion status
 27: - Git branch and changes
 28: - Recent activity
 29: 
 30: #### `/work [subcommand] [args]`
 31: Manage work units and parallel work streams.
 32: 
 33: **Subcommands**:
 34: - `list [filter]`: List work units (active/paused/completed/all)
 35: - `continue [unit-id]`: Resume work on specific unit
 36: - `checkpoint`: Save current work state
 37: - `switch [unit-id]`: Switch to different work unit
 38: 
 39: **Usage**:
 40: ```bash
 41: /work list                    # List active work units
 42: /work list all                # List all work units
 43: /work continue 001            # Continue work unit 001
 44: /work checkpoint              # Save current state
 45: /work switch 002              # Switch to work unit 002
 46: ```
 47: 
 48: #### `/config [subcommand] [key] [value]`
 49: Manage framework settings and project preferences.
 50: 
 51: **Subcommands**:
 52: - `get [key]`: Get configuration value
 53: - `set [key] [value]`: Set configuration value
 54: - `list`: List all configuration values
 55: 
 56: **Usage**:
 57: ```bash
 58: /config list                          # List all settings
 59: /config get memory.max_size           # Get specific setting
 60: /config set git.auto_commit true      # Set configuration
 61: ```
 62: 
 63: ### System Operations
 64: 
 65: #### `/cleanup [options]`
 66: Clean up Claude-generated clutter and consolidate documentation.
 67: 
 68: **Options**:
 69: - `--dry-run`: Preview what would be cleaned
 70: - `--auto`: Auto-approve all cleanups
 71: - `root`: Clean project root duplicates
 72: - `tests`: Clean test output files
 73: - `reports`: Clean old reports
 74: - `work`: Clean completed work units
 75: - `all`: Clean everything
 76: 
 77: **Usage**:
 78: ```bash
 79: /cleanup --dry-run            # Preview cleanup
 80: /cleanup root                 # Clean project root
 81: /cleanup all                  # Clean everything
 82: ```
 83: 
 84: #### `/index [options]`
 85: Create and maintain persistent project understanding.
 86: 
 87: **Options**:
 88: - `--update`: Update existing index
 89: - `--refresh`: Rebuild index from scratch
 90: - `[focus_area]`: Index specific area
 91: 
 92: **Usage**:
 93: ```bash
 94: /index                        # Create initial index
 95: /index --update               # Update existing index
 96: /index src/                   # Index specific directory
 97: ```
 98: 
 99: #### `/performance`
100: View token usage and performance metrics.
101: 
102: **Shows**:
103: - Session token usage
104: - Command execution times
105: - MCP tool performance
106: - Memory efficiency metrics
107: 
108: ### Development Support
109: 
110: #### `/agent <agent-name> "<task>"`
111: Direct invocation of specialized agents.
112: 
113: **Available Agents**:
114: - `architect`: System design and architectural decisions
115: - `test-engineer`: Test creation and coverage analysis
116: - `code-reviewer`: Code review and quality assurance
117: - `auditor`: Compliance and framework validation
118: - `data-scientist`: ML experiments and data analysis
119: 
120: **Usage**:
121: ```bash
122: /agent architect "Design authentication system"
123: /agent test-engineer "Create tests for UserService"
124: /agent code-reviewer "Review changes in src/auth/"
125: ```
126: 
127: #### `/docs [subcommand] [args]`
128: Unified documentation operations.
129: 
130: **Subcommands**:
131: - `fetch [url]`: Fetch external documentation
132: - `search [query]`: Search all documentation
133: - `generate [scope]`: Generate project documentation
134: 
135: **Usage**:
136: ```bash
137: /docs search "authentication"         # Search docs
138: /docs fetch https://api-docs.com      # Fetch external docs
139: /docs generate api                    # Generate API docs
140: ```
141: 
142: #### `/add-command [name] [description]`
143: Create new custom slash commands.
144: 
145: **Usage**:
146: ```bash
147: /add-command deploy "Deploy application to production"
148: ```
149: 
150: Creates command template at `.claude/commands/deploy.md` ready for customization.
151: 
152: ### Quality & Maintenance
153: 
154: #### `/audit [options]`
155: Framework setup and infrastructure compliance audit.
156: 
157: **Options**:
158: - `--framework`: Audit framework setup
159: - `--tools`: Audit tool installations
160: - `--fix`: Auto-fix issues found
161: 
162: **Usage**:
163: ```bash
164: /audit                        # Full audit
165: /audit --framework            # Framework only
166: /audit --tools --fix          # Audit and fix tools
167: ```
168: 
169: #### `/serena [options]`
170: Activate and manage Serena semantic code understanding.
171: 
172: **Options**:
173: - `activate`: Enable Serena for project
174: - `status`: Check Serena status
175: - `reindex`: Rebuild semantic index
176: 
177: **Usage**:
178: ```bash
179: /serena activate              # Enable Serena
180: /serena status                # Check status
181: /serena reindex               # Rebuild index
182: ```
183: 
184: ### Session Management
185: 
186: #### `/handoff [message]`
187: Create transition documents with context analysis.
188: 
189: **Usage**:
190: ```bash
191: /handoff "Completed auth refactor, ready for testing"
192: ```
193: 
194: Creates handoff document in `.claude/transitions/` with:
195: - Current context and state
196: - Work completed
197: - Next steps
198: - Token usage analysis
199: 
200: #### `/spike [topic] [duration]`
201: Time-boxed exploration in isolated branch.
202: 
203: **Usage**:
204: ```bash
205: /spike "graphql-integration" 2h
206: ```
207: 
208: Creates isolated branch for exploration with time limit.
209: 
210: ### Project Setup
211: 
212: #### `/setup [type] [name] [options]`
213: Initialize new projects with Claude framework integration.
214: 
215: **Types**:
216: - `explore`: Explore project before setup
217: - `existing`: Setup in existing project
218: - `python`: New Python project
219: - `javascript`: New JavaScript project
220: 
221: **Options**:
222: - `--minimal`: Minimal setup
223: - `--standard`: Standard setup (default)
224: - `--full`: Full setup with all features
225: - `--init-user`: Initialize user configuration
226: - `--statusline`: Setup status line
227: 
228: **Usage**:
229: ```bash
230: /setup explore                        # Explore before setup
231: /setup existing my-project            # Setup existing project
232: /setup python new-app --standard      # New Python project
233: /setup --init-user                    # Initialize user config
234: ```
235: 
236: ## Capabilities
237: 
238: The core plugin provides 14 essential capabilities:
239: 
240: 1. **Status Monitoring**: Project and task status tracking
241: 2. **Work Management**: Parallel work stream management
242: 3. **Configuration Management**: Settings and preferences
243: 4. **Agent Invocation**: Direct agent access
244: 5. **Project Cleanup**: Clutter removal and consolidation
245: 6. **Project Indexing**: Persistent understanding
246: 7. **Performance Monitoring**: Token and efficiency metrics
247: 8. **Session Handoff**: Context preservation
248: 9. **Documentation Operations**: Unified doc management
249: 10. **Project Setup**: New project initialization
250: 11. **Command Creation**: Custom command scaffolding
251: 12. **Framework Audit**: Compliance checking
252: 13. **Serena Setup**: Semantic code understanding
253: 14. **Spike Exploration**: Time-boxed investigations
254: 
255: ## Configuration
256: 
257: ### Plugin Settings
258: 
259: ```json
260: {
261:   "settings": {
262:     "defaultEnabled": true,
263:     "category": "core",
264:     "required": true
265:   }
266: }
267: ```
268: 
269: **Note**: This plugin is **required** and always enabled.
270: 
271: ### MCP Integration
272: 
273: **Optional MCP Tools**:
274: - `sequential-thinking`: Enhanced structured reasoning
275: - `serena`: Semantic code understanding
276: 
277: **Graceful Degradation**: All features work without MCP tools, with fallback behavior.
278: 
279: ## Dependencies
280: 
281: **None** - Core plugin has no dependencies as it provides foundation for all other plugins.
282: 
283: ## File Organization
284: 
285: ```
286: plugins/core/
287: └── .claude-plugin/
288:     ├── plugin.json           # Plugin manifest
289:     ├── README.md             # This file
290:     └── commands/             # Command implementations
291:         ├── status.md
292:         ├── work.md
293:         ├── config.md
294:         ├── agent.md
295:         ├── cleanup.md
296:         ├── index.md
297:         ├── performance.md
298:         ├── handoff.md
299:         ├── docs.md
300:         ├── setup.md
301:         ├── add-command.md
302:         ├── audit.md
303:         ├── serena.md
304:         └── spike.md
305: ```
306: 
307: ## Integration Points
308: 
309: ### With Workflow Plugin
310: - Work management integrates with `/next` and `/ship`
311: - Handoff supports workflow transitions
312: - Status displays workflow state
313: 
314: ### With Development Plugin
315: - Agent invocation used by development commands
316: - Audit checks development tool setup
317: - Performance monitors development operations
318: 
319: ### With Memory Plugin
320: - Configuration includes memory settings
321: - Status shows memory usage
322: - Cleanup consolidates memory files
323: 
324: ### With Git Plugin
325: - Status shows git state
326: - Handoff creates git-friendly transitions
327: - Cleanup respects gitignore
328: 
329: ## Best Practices
330: 
331: ### Status Monitoring
332: - Run `/status` at session start
333: - Use `/status verbose` when context >80%
334: - Check status before handoffs
335: 
336: ### Work Management
337: - Use `/work checkpoint` regularly
338: - Switch work units to maintain focus
339: - List completed work for accountability
340: 
341: ### Configuration
342: - Review `/config list` periodically
343: - Set project-specific preferences in `.claude/settings.json`
344: - Use global settings in `~/.claude/settings.json`
345: 
346: ### Cleanup
347: - Run `/cleanup --dry-run` weekly
348: - Clean completed work quarterly
349: - Use `--auto` for trusted cleanups
350: 
351: ### Performance
352: - Monitor `/performance` every 10-15 interactions
353: - Optimize at 80% token threshold
354: - Use handoff when approaching limits
355: 
356: ## Troubleshooting
357: 
358: ### Command Not Found
359: 
360: **Symptom**: `/status` shows "Command not found"
361: 
362: **Solution**: Core plugin is required and should always be enabled. If missing:
363: ```bash
364: /config plugin enable claude-code-core
365: ```
366: 
367: ### Configuration Not Persisting
368: 
369: **Symptom**: Settings reset after restart
370: 
371: **Solution**: Check settings file permissions:
372: ```bash
373: ls -la ~/.claude/settings.json
374: ls -la .claude/settings.json
375: ```
376: 
377: ### Work Unit Corruption
378: 
379: **Symptom**: `/work list` shows corrupted state
380: 
381: **Solution**: Rebuild work unit state:
382: ```bash
383: # Backup current state
384: cp .claude/work/current/*/state.json ~/state-backup.json
385: 
386: # Reset work directory
387: /cleanup work
388: 
389: # Restore from backup
390: ```
391: 
392: ### Performance Degradation
393: 
394: **Symptom**: Commands running slowly
395: 
396: **Solutions**:
397: 1. Check token usage: `/performance`
398: 2. Run cleanup: `/cleanup all`
399: 3. Create handoff: `/handoff`
400: 4. Clear conversation after handoff
401: 
402: ## Version History
403: 
404: ### 1.0.0 (2025-10-11)
405: - Initial plugin release
406: - 14 core commands
407: - MCP integration support
408: - Work unit management
409: - Session handoff capabilities
410: 
411: ## License
412: 
413: MIT License - See project LICENSE file
414: 
415: ## Related Plugins
416: 
417: - **workflow**: Development workflow (depends on core)
418: - **development**: Development tools (depends on core)
419: - **git**: Version control (depends on core)
420: - **memory**: Context management (standalone, integrates with core)
421: 
422: ---
423: 
424: **Note**: This is a required plugin and provides foundation for all Claude Code functionality. Do not disable.
````

## File: plugins/core/README.md
````markdown
  1: # Core Plugin
  2: 
  3: Essential system functionality and framework commands for Claude Code.
  4: 
  5: ## Overview
  6: 
  7: The Core plugin provides fundamental commands for project management, system monitoring, and framework operations. These commands form the foundation of the Claude Code plugin ecosystem and are required for most workflows.
  8: 
  9: ## Features
 10: 
 11: - **Project Management**: Track work units, manage tasks, and organize parallel workflows
 12: - **System Monitoring**: View status, performance metrics, and token usage
 13: - **Framework Operations**: Setup, configuration, cleanup, and audit capabilities
 14: - **Session Management**: Create handoffs and maintain project context
 15: - **Documentation**: Fetch, search, and generate project documentation
 16: 
 17: ## Commands
 18: 
 19: ### `/status [verbose]`
 20: Display unified view of work, system, and memory state. Shows current tasks, project status, and system health.
 21: 
 22: **Usage**:
 23: ```bash
 24: /status           # Quick status overview
 25: /status verbose   # Detailed status with metrics
 26: ```
 27: 
 28: ### `/work [subcommand] [args]`
 29: Manage work units and parallel streams. Create, list, continue, checkpoint, and switch between work contexts.
 30: 
 31: **Usage**:
 32: ```bash
 33: /work                    # List all work units
 34: /work active             # Show active work units
 35: /work continue [ID]      # Continue specific work unit
 36: /work checkpoint         # Save current work state
 37: /work switch [ID]        # Switch to different work unit
 38: ```
 39: 
 40: ### `/agent <agent-name> "<task>"`
 41: Direct invocation of specialized agents with explicit context. Provides access to expert capabilities on demand.
 42: 
 43: **Usage**:
 44: ```bash
 45: /agent architect "Design authentication system"
 46: /agent code-reviewer "Review security in auth module"
 47: /agent auditor "Check framework compliance"
 48: ```
 49: 
 50: ### `/cleanup [--dry-run | --auto | root | tests | reports | work | all]`
 51: Clean up Claude-generated clutter and consolidate documentation. Remove temporary files and organize project structure.
 52: 
 53: **Usage**:
 54: ```bash
 55: /cleanup --dry-run       # Preview what would be cleaned
 56: /cleanup root            # Clean root directory only
 57: /cleanup all             # Clean everything
 58: /cleanup --auto          # Auto-clean with safe defaults
 59: ```
 60: 
 61: ### `/index [--update] [--refresh] [focus_area]`
 62: Create and maintain persistent project understanding through comprehensive mapping. Build searchable index of codebase.
 63: 
 64: **Usage**:
 65: ```bash
 66: /index                   # Create initial index
 67: /index --update          # Update existing index
 68: /index --refresh         # Rebuild from scratch
 69: /index src/auth          # Index specific area
 70: ```
 71: 
 72: ### `/performance`
 73: View token usage and performance metrics. Monitor efficiency, context usage, and optimization opportunities.
 74: 
 75: **Usage**:
 76: ```bash
 77: /performance             # Show performance dashboard
 78: ```
 79: 
 80: ### `/handoff`
 81: Create transition documents with context analysis. Generate comprehensive handoff for session continuity.
 82: 
 83: **Usage**:
 84: ```bash
 85: /handoff                 # Create handoff document
 86: ```
 87: 
 88: ### `/docs [fetch|search|generate] [arguments]`
 89: Unified documentation operations - fetch external docs, search all documentation, and generate project docs.
 90: 
 91: **Usage**:
 92: ```bash
 93: /docs search "authentication"       # Search documentation
 94: /docs fetch react                   # Fetch external library docs
 95: /docs generate                      # Generate project documentation
 96: ```
 97: 
 98: ### `/setup [explore|existing|python|javascript] [project-name] [--minimal|--standard|--full]`
 99: Initialize new projects with Claude framework integration or setup user configuration.
100: 
101: **Usage**:
102: ```bash
103: /setup explore                      # Interactive project discovery
104: /setup python my-api --standard     # Python project with standard config
105: /setup existing                     # Add Claude framework to existing project
106: /setup --init-user                  # Setup user-level configuration
107: ```
108: 
109: ### `/audit [--framework | --tools | --fix]`
110: Framework setup and infrastructure compliance audit. Verify correct installation and configuration.
111: 
112: **Usage**:
113: ```bash
114: /audit                   # Full audit
115: /audit --framework       # Check framework compliance
116: /audit --tools           # Check tool availability
117: /audit --fix             # Auto-fix issues
118: ```
119: 
120: ### `/serena`
121: Activate and manage Serena semantic code understanding for projects. Enable powerful semantic search and code navigation.
122: 
123: **Usage**:
124: ```bash
125: /serena                  # Activate Serena for current project
126: ```
127: 
128: ### `/spike`
129: Time-boxed exploration in isolated branch. Quick experimentation without affecting main work.
130: 
131: **Usage**:
132: ```bash
133: /spike                   # Start spike exploration
134: ```
135: 
136: ## Agents
137: 
138: ### Auditor (`auditor.md`)
139: Framework compliance and infrastructure validation specialist. Performs comprehensive audits of:
140: - Claude Code framework setup
141: - Configuration correctness
142: - File structure compliance
143: - Tool availability
144: - Best practice adherence
145: 
146: **Capabilities**:
147: - Automated compliance checking
148: - Configuration validation
149: - Setup verification
150: - Issue detection and reporting
151: 
152: ### Reasoning Specialist (`reasoning-specialist.md`)
153: Structured problem-solving and decision analysis expert. Provides:
154: - Sequential thinking for complex problems
155: - Decision framework analysis
156: - Multi-criteria evaluation
157: - Trade-off analysis
158: 
159: **Capabilities**:
160: - Complex problem decomposition
161: - Systematic reasoning
162: - Decision documentation
163: - Alternative evaluation
164: 
165: ## Installation
166: 
167: This plugin is included by default in Claude Code and is marked as **required**. It is automatically enabled when you install the plugin marketplace.
168: 
169: To manually enable:
170: 
171: 1. Add to your `.claude/settings.json`:
172: ```json
173: {
174:   "enabledPlugins": {
175:     "claude-code-core@your-marketplace": true
176:   }
177: }
178: ```
179: 
180: 2. Restart Claude Code or reload settings
181: 
182: ## Configuration
183: 
184: The Core plugin works out of the box with sensible defaults. Optional configuration:
185: 
186: **Work Directory** (`.claude/work/`):
187: - Customize work unit organization
188: - Set default work patterns
189: - Configure archival rules
190: 
191: **Performance Thresholds** (`.claude/config.json`):
192: ```json
193: {
194:   "performance": {
195:     "tokenWarningThreshold": 0.8,
196:     "tokenCriticalThreshold": 0.9,
197:     "autoOptimize": false
198:   }
199: }
200: ```
201: 
202: **Cleanup Patterns** (`.claude/cleanup-rules.json`):
203: ```json
204: {
205:   "excludePatterns": ["*.important.md"],
206:   "consolidationTargets": ["docs/", "notes/"]
207: }
208: ```
209: 
210: ## Dependencies
211: 
212: ### Required
213: - Claude Code v3.0+ (platform)
214: 
215: ### Optional MCP Tools
216: - **Sequential Thinking**: Enhances reasoning-specialist agent (built-in to Claude Code)
217: - **Serena**: Enables semantic code understanding (/serena command)
218: 
219: **Graceful Degradation**: All commands work without MCP tools, but may be less efficient.
220: 
221: ## Usage Examples
222: 
223: ### Complete Workflow
224: ```bash
225: # 1. Check status
226: /status
227: 
228: # 2. Create new work unit
229: /work create "Add user authentication"
230: 
231: # 3. Setup project structure
232: /setup python auth-service --standard
233: 
234: # 4. Monitor performance
235: /performance
236: 
237: # 5. Run framework audit
238: /audit
239: 
240: # 6. Create handoff when done
241: /handoff
242: ```
243: 
244: ### Project Initialization
245: ```bash
246: # Interactive discovery
247: /setup explore
248: 
249: # Quick Python setup
250: /setup python my-api --minimal
251: 
252: # Add to existing project
253: cd existing-project
254: /setup existing
255: ```
256: 
257: ### Work Management
258: ```bash
259: # List work
260: /work active
261: 
262: # Start work unit
263: /work continue 001
264: 
265: # Save checkpoint
266: /work checkpoint
267: 
268: # Switch work
269: /work switch 002
270: ```
271: 
272: ## Best Practices
273: 
274: 1. **Use /status regularly**: Check project state before starting work
275: 2. **Create handoffs at boundaries**: Preserve context between sessions
276: 3. **Monitor /performance**: Optimize when context >80%
277: 4. **Audit after setup**: Verify framework compliance with /audit
278: 5. **Clean periodically**: Run /cleanup to maintain organized project
279: 
280: ## Troubleshooting
281: 
282: ### Commands not found
283: Run `/audit --framework` to verify plugin installation.
284: 
285: ### Performance degradation
286: 1. Check `/performance` for context usage
287: 2. Run `/handoff` to preserve context
288: 3. Use `/cleanup` to remove clutter
289: 
290: ### Work units not tracking
291: 1. Verify `.claude/work/` directory exists
292: 2. Run `/audit --fix` to repair structure
293: 3. Check `metadata.json` in work unit directory
294: 
295: ## Related Plugins
296: 
297: - **workflow**: Task workflow commands (/explore, /plan, /next, /ship)
298: - **development**: Development tools (/analyze, /review, /test, /fix, /run)
299: - **git**: Git operations (/git commit, /git pr, /git issue)
300: - **memory**: Memory management (/memory-review, /memory-gc)
301: 
302: ## Support
303: 
304: - **Documentation**: [Getting Started Guide](../../docs/getting-started/)
305: - **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
306: - **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
307: 
308: ## License
309: 
310: MIT License - see [LICENSE](../../LICENSE) for details.
311: 
312: ---
313: 
314: **Version**: 1.0.0
315: **Category**: Core
316: **Required**: Yes
317: **MCP Tools**: Optional (sequential-thinking, serena)
````

## File: plugins/development/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "claude-code-development",
 3:   "version": "1.0.0",
 4:   "description": "Code development and quality assurance tools - analyze, test, fix, review",
 5:   "author": "Claude Code Framework",
 6:   "keywords": ["development", "testing", "quality", "analysis", "debugging"],
 7:   "commands": ["commands/*.md"],
 8:   "agents": ["agents/architect.md", "agents/code-reviewer.md", "agents/test-engineer.md"],
 9:   "settings": {
10:     "defaultEnabled": true,
11:     "category": "development"
12:   },
13:   "repository": {
14:     "type": "git",
15:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
16:   },
17:   "license": "MIT",
18:   "capabilities": {
19:     "codebaseAnalysis": {
20:       "description": "Deep codebase analysis with semantic understanding",
21:       "command": "analyze",
22:       "agent": "architect"
23:     },
24:     "testCreation": {
25:       "description": "Test-driven development workflow using test-engineer agent",
26:       "command": "test",
27:       "agent": "test-engineer"
28:     },
29:     "errorDebugging": {
30:       "description": "Universal debugging and fix application with semantic analysis",
31:       "command": "fix"
32:     },
33:     "scriptExecution": {
34:       "description": "Execute code or scripts with monitoring and timeout control",
35:       "command": "run"
36:     },
37:     "codeReview": {
38:       "description": "Code review focused on bugs, design flaws, and quality",
39:       "command": "review",
40:       "agent": "code-reviewer"
41:     },
42:     "reportGeneration": {
43:       "description": "Generate professional stakeholder reports from data",
44:       "command": "report"
45:     },
46:     "mlExperiments": {
47:       "description": "Run ML experiments with tracking",
48:       "command": "experiment"
49:     },
50:     "mlEvaluation": {
51:       "description": "Compare experiments and identify best performers",
52:       "command": "evaluate"
53:     }
54:   },
55:   "agents": {
56:     "architect": {
57:       "description": "System design and architectural decisions specialist",
58:       "structured_reasoning": true
59:     },
60:     "test-engineer": {
61:       "description": "Test creation, coverage analysis, and quality assurance specialist",
62:       "semantic_code_understanding": true
63:     },
64:     "code-reviewer": {
65:       "description": "Code review, documentation quality, security audit specialist",
66:       "structured_reasoning": true,
67:       "semantic_code_understanding": true
68:     },
69:     "auditor": {
70:       "description": "Compliance auditor for work progress and system setup",
71:       "integrated": true
72:     },
73:     "data-scientist": {
74:       "description": "ML experiments, data analysis, model evaluation specialist",
75:       "structured_reasoning": true
76:     }
77:   },
78:   "dependencies": {
79:     "claude-code-core": "^1.0.0"
80:   },
81:   "mcpTools": {
82:     "optional": ["sequential-thinking", "serena", "context7"],
83:     "gracefulDegradation": true
84:   }
85: }
````

## File: plugins/development/.claude-plugin/README.md
````markdown
  1: # Claude Code Development Plugin
  2: 
  3: **Version**: 1.0.0
  4: **Category**: Development
  5: **Author**: Claude Code Framework
  6: 
  7: ## Overview
  8: 
  9: The Development Plugin provides comprehensive code development and quality assurance tools. It includes commands for analysis, testing, debugging, execution, review, and reporting, powered by specialized AI agents.
 10: 
 11: ## Commands
 12: 
 13: ### `/analyze [focus_area] [options]`
 14: Deep codebase analysis with semantic understanding and structured reasoning.
 15: 
 16: **Purpose**: Understand project structure, architecture, and patterns
 17: 
 18: **Options**:
 19: - `[focus_area]`: Specific area to analyze (e.g., `src/auth/`, `database`)
 20: - `[requirements_doc]`: Requirements document for analysis
 21: - `--with-thinking`: Use structured reasoning (Sequential Thinking MCP)
 22: - `--semantic`: Use semantic code understanding (Serena MCP)
 23: 
 24: **Usage**:
 25: ```bash
 26: /analyze                                     # Analyze entire project
 27: /analyze src/auth/                           # Analyze specific area
 28: /analyze @requirements.md                    # Analyze against requirements
 29: /analyze --with-thinking --semantic          # Full MCP analysis
 30: ```
 31: 
 32: **Outputs**:
 33: - Architecture overview
 34: - Pattern identification
 35: - Dependency analysis
 36: - Design recommendations
 37: - Risk assessment
 38: 
 39: **Agent**: `architect` (system design specialist with structured reasoning)
 40: 
 41: **MCP Enhancements**:
 42: - **Sequential Thinking**: Multi-step architectural analysis
 43: - **Serena**: Semantic code understanding (70-90% token reduction)
 44: 
 45: ---
 46: 
 47: ### `/test [tdd] [pattern]`
 48: Test-driven development workflow using test-engineer agent.
 49: 
 50: **Purpose**: Create tests, improve coverage, validate quality
 51: 
 52: **Modes**:
 53: - `tdd`: Test-driven development mode (write tests first)
 54: - `[pattern]`: Test files matching pattern
 55: 
 56: **Usage**:
 57: ```bash
 58: /test tdd                                    # TDD workflow
 59: /test "src/auth/**/*.test.ts"                # Test specific files
 60: /test                                        # Interactive test creation
 61: ```
 62: 
 63: **TDD Workflow**:
 64: 1. Specify functionality to implement
 65: 2. Agent writes failing tests
 66: 3. Implement code to pass tests
 67: 4. Refactor with tests passing
 68: 
 69: **Outputs**:
 70: - Test coverage analysis
 71: - Missing test cases identified
 72: - Test quality assessment
 73: - Coverage improvement recommendations
 74: 
 75: **Agent**: `test-engineer` (test specialist with semantic code understanding)
 76: 
 77: **MCP Enhancements**:
 78: - **Serena**: Semantic symbol finding for test targets
 79: - **Context7**: Testing library documentation
 80: 
 81: ---
 82: 
 83: ### `/fix [target] [options]`
 84: Universal debugging and fix application with semantic code analysis.
 85: 
 86: **Purpose**: Debug errors, apply review fixes, resolve issues
 87: 
 88: **Targets**:
 89: - `error`: Debug runtime errors
 90: - `review`: Apply code review fixes
 91: - `audit`: Fix audit findings
 92: - `all`: Fix all identified issues
 93: - `[file/pattern]`: Fix specific files
 94: 
 95: **Usage**:
 96: ```bash
 97: /fix error                                   # Debug last error
 98: /fix review                                  # Apply review comments
 99: /fix audit                                   # Fix audit findings
100: /fix src/auth/login.ts                       # Fix specific file
101: /fix all                                     # Fix all issues
102: ```
103: 
104: **Capabilities**:
105: - Error analysis from logs/stack traces
106: - Root cause identification
107: - Automated fix generation
108: - Validation of fixes
109: - Regression prevention
110: 
111: **MCP Enhancements**:
112: - **Serena**: Semantic code navigation for debugging
113: - **Sequential Thinking**: Complex debugging reasoning
114: 
115: ---
116: 
117: ### `/run [script|file]`
118: Execute code or scripts with monitoring and timeout control.
119: 
120: **Purpose**: Run scripts, execute code, monitor output
121: 
122: **Usage**:
123: ```bash
124: /run tests                                   # Run test script
125: /run src/migration.py                        # Execute Python file
126: /run "npm run build"                         # Run npm script
127: ```
128: 
129: **Features**:
130: - Output monitoring with filtering
131: - Timeout control (default 2 min, max 10 min)
132: - Background execution support
133: - Error detection and reporting
134: 
135: **Options**:
136: - `--timeout SECONDS`: Set custom timeout
137: - `--background`: Run in background
138: - `--filter REGEX`: Filter output lines
139: 
140: ---
141: 
142: ### `/review [file/directory] [options]`
143: Code review focused on bugs, design flaws, dead code, and quality.
144: 
145: **Purpose**: Systematic code quality review with actionable feedback
146: 
147: **Options**:
148: - `[file/directory]`: Specific scope to review
149: - `--spec requirements.md`: Review against requirements
150: - `--systematic`: Comprehensive systematic review
151: - `--semantic`: Use semantic code analysis
152: 
153: **Usage**:
154: ```bash
155: /review                                      # Review recent changes
156: /review src/                                 # Review directory
157: /review --spec @requirements.md              # Against requirements
158: /review --systematic --semantic              # Full analysis
159: ```
160: 
161: **Review Focus**:
162: - **Bugs**: Logic errors, edge cases, error handling
163: - **Design Flaws**: Architecture issues, coupling, complexity
164: - **Dead Code**: Unused code, unreachable paths
165: - **Code Quality**: Readability, maintainability, testability
166: - **Security**: Vulnerabilities, input validation
167: 
168: **Outputs**:
169: - Prioritized issues (Critical/High/Medium/Low)
170: - Specific line-by-line comments
171: - Actionable fix recommendations
172: - Refactoring suggestions
173: 
174: **Agent**: `code-reviewer` (quality specialist with structured reasoning and semantic analysis)
175: 
176: **MCP Enhancements**:
177: - **Sequential Thinking**: Comprehensive review reasoning
178: - **Serena**: Semantic code understanding for pattern detection
179: 
180: ---
181: 
182: ### `/report [data|results]`
183: Generate professional stakeholder reports from data.
184: 
185: **Purpose**: Create business, technical, or executive reports from project data
186: 
187: **Usage**:
188: ```bash
189: /report @test-results.json                   # Test results report
190: /report @performance-data.csv                # Performance report
191: /report @experiment-results.json             # ML experiment report
192: ```
193: 
194: **Report Types**:
195: - **Technical Reports**: Test results, performance metrics, code analysis
196: - **Business Reports**: Feature progress, delivery metrics, ROI
197: - **Executive Reports**: High-level summaries, key decisions, risks
198: 
199: **Outputs**:
200: - Professional markdown reports
201: - Visualizations and charts
202: - Executive summaries
203: - Actionable recommendations
204: 
205: ---
206: 
207: ### `/experiment [config]`
208: Run ML experiments with tracking.
209: 
210: **Purpose**: Execute machine learning experiments with proper tracking and reproducibility
211: 
212: **Usage**:
213: ```bash
214: /experiment @experiment-config.yaml          # Run configured experiment
215: /experiment "test transformer architecture"  # Ad-hoc experiment
216: ```
217: 
218: **Features**:
219: - Experiment configuration management
220: - Hyperparameter tracking
221: - Result logging and comparison
222: - Reproducibility support
223: 
224: **Agent**: `data-scientist` (ML specialist with structured reasoning)
225: 
226: **MCP Enhancements**:
227: - **Sequential Thinking**: Complex experiment design reasoning
228: 
229: ---
230: 
231: ### `/evaluate [experiments]`
232: Compare experiments and identify best performers.
233: 
234: **Purpose**: Analyze experiment results, compare models, identify winners
235: 
236: **Usage**:
237: ```bash
238: /evaluate @experiment-results/                # Evaluate all results
239: /evaluate exp-001 exp-002 exp-003            # Compare specific experiments
240: ```
241: 
242: **Outputs**:
243: - Performance comparison tables
244: - Statistical significance analysis
245: - Best model identification
246: - Recommendation for deployment
247: 
248: **Agent**: `data-scientist`
249: 
250: ## Specialized Agents
251: 
252: ### Architect Agent
253: **Capability**: `codebaseAnalysis`
254: **Expertise**: System design and architectural decisions
255: 
256: **Capabilities**:
257: - Architecture pattern identification
258: - System design recommendations
259: - Technical debt assessment
260: - Scalability analysis
261: - Integration design
262: 
263: **MCP Tools**: Sequential Thinking for structured analysis
264: 
265: ---
266: 
267: ### Test Engineer Agent
268: **Capability**: `testCreation`
269: **Expertise**: Test creation, coverage analysis, quality assurance
270: 
271: **Capabilities**:
272: - TDD workflow support
273: - Test coverage analysis
274: - Test quality assessment
275: - Missing test identification
276: - Test strategy recommendations
277: 
278: **MCP Tools**: Serena for semantic code understanding
279: 
280: ---
281: 
282: ### Code Reviewer Agent
283: **Capability**: `codeReview`
284: **Expertise**: Code quality, security, design review
285: 
286: **Capabilities**:
287: - Multi-dimensional code review
288: - Security vulnerability detection
289: - Design flaw identification
290: - Dead code detection
291: - Prioritized issue reporting
292: 
293: **MCP Tools**: Sequential Thinking + Serena for comprehensive analysis
294: 
295: ---
296: 
297: ### Auditor Agent
298: **Capability**: Integrated with core and workflow
299: **Expertise**: Compliance and framework validation
300: 
301: **Capabilities**:
302: - Framework setup validation
303: - Tool installation checking
304: - Work progress auditing
305: - Documentation compliance
306: - Best practice verification
307: 
308: **MCP Tools**: Context7 for documentation verification
309: 
310: ---
311: 
312: ### Data Scientist Agent
313: **Capability**: `mlExperiments`, `mlEvaluation`
314: **Expertise**: ML experiments, data analysis, model evaluation
315: 
316: **Capabilities**:
317: - Experiment design and execution
318: - Hyperparameter tuning
319: - Model comparison and evaluation
320: - Statistical analysis
321: - Deployment recommendations
322: 
323: **MCP Tools**: Sequential Thinking for complex reasoning
324: 
325: ## Configuration
326: 
327: ### Plugin Settings
328: 
329: ```json
330: {
331:   "settings": {
332:     "defaultEnabled": true,
333:     "category": "development"
334:   }
335: }
336: ```
337: 
338: ### Dependencies
339: 
340: ```json
341: {
342:   "dependencies": {
343:     "claude-code-core": "^1.0.0"
344:   }
345: }
346: ```
347: 
348: **Required**: `core` plugin for agent invocation and configuration
349: 
350: ### MCP Tools
351: 
352: **Optional** (with graceful degradation):
353: - `sequential-thinking`: Enhanced reasoning for analysis and review
354: - `serena`: Semantic code understanding (70-90% token reduction)
355: - `context7`: Documentation access for libraries
356: 
357: ## Best Practices
358: 
359: ### Analysis
360: - ✅ Start with `/analyze` for new codebases
361: - ✅ Use `--semantic` for large codebases (token efficient)
362: - ✅ Focus analysis on specific areas when possible
363: - ❌ Don't analyze entire large codebase without focus
364: 
365: ### Testing
366: - ✅ Use `/test tdd` for new features
367: - ✅ Run `/test` before shipping to identify coverage gaps
368: - ✅ Write tests for bugs before fixing (TDD)
369: - ❌ Don't skip test creation for complex logic
370: 
371: ### Fixing
372: - ✅ Use `/fix error` immediately when errors occur
373: - ✅ Apply `/fix review` suggestions systematically
374: - ✅ Run `/fix audit` after audits
375: - ❌ Don't accumulate unfixed issues
376: 
377: ### Review
378: - ✅ Run `/review --systematic` before major releases
379: - ✅ Review against specs with `--spec`
380: - ✅ Use `--semantic` for large reviews (token efficient)
381: - ❌ Don't skip reviews for "simple" changes
382: 
383: ### Reporting
384: - ✅ Generate reports for stakeholders regularly
385: - ✅ Include executive summaries for leadership
386: - ✅ Use visualizations for complex data
387: - ❌ Don't present raw data without context
388: 
389: ## Integration with Workflow
390: 
391: ### With `/explore`
392: - Run `/analyze` during exploration phase
393: - Identify architecture patterns early
394: - Understand technical constraints
395: 
396: ### With `/plan`
397: - Use `/analyze` output for planning
398: - Identify test requirements
399: - Plan fixes for identified issues
400: 
401: ### With `/next`
402: - Run `/test` during task execution
403: - Use `/fix` when errors occur
404: - Execute `/run` for validation
405: 
406: ### With `/ship`
407: - Run `/review --systematic` before delivery
408: - Execute `/test` for final coverage check
409: - Generate `/report` for stakeholders
410: 
411: ## Workflow Examples
412: 
413: ### Example 1: Feature Development with TDD
414: 
415: ```bash
416: # Phase 1: Analysis
417: /analyze src/auth/ --semantic
418: 
419: # Phase 2: TDD
420: /test tdd                               # Write tests first
421: # Implement feature
422: /run tests                              # Verify tests pass
423: 
424: # Phase 3: Review
425: /review src/auth/ --systematic
426: 
427: # Phase 4: Fix issues
428: /fix review                             # Apply review fixes
429: ```
430: 
431: ### Example 2: Bug Fix
432: 
433: ```bash
434: # Phase 1: Debug
435: /fix error                              # Analyze error
436: 
437: # Phase 2: Test
438: /test tdd                               # Write failing test
439: # Fix bug
440: /run tests                              # Verify fix
441: 
442: # Phase 3: Review
443: /review --semantic                      # Quick review
444: ```
445: 
446: ### Example 3: ML Experiment
447: 
448: ```bash
449: # Phase 1: Design
450: /experiment @config.yaml                # Run experiment
451: 
452: # Phase 2: Evaluate
453: /evaluate @results/                     # Compare results
454: 
455: # Phase 3: Report
456: /report @experiment-results.json        # Generate report
457: ```
458: 
459: ## Performance
460: 
461: ### Token Efficiency
462: 
463: **With Serena**:
464: - `/analyze --semantic`: 70-90% reduction vs standard analysis
465: - `/review --semantic`: 75-85% reduction for large reviews
466: - `/test` with Serena: 60-80% reduction for coverage analysis
467: 
468: **With Sequential Thinking**:
469: - `/analyze --with-thinking`: +15-30% tokens, +20-30% quality
470: - `/review --systematic`: +20-40% tokens, +25-35% quality
471: 
472: ### Execution Times
473: 
474: - `/analyze`: 30-90 seconds (depends on codebase size)
475: - `/test tdd`: 20-60 seconds per test suite
476: - `/fix`: 10-30 seconds per issue
477: - `/run`: Depends on script (2-120 seconds typical)
478: - `/review`: 45-120 seconds (depends on scope)
479: - `/report`: 15-45 seconds
480: - `/experiment`: Minutes to hours (depends on experiment)
481: - `/evaluate`: 20-60 seconds
482: 
483: ## Troubleshooting
484: 
485: ### Agent Not Available
486: 
487: **Symptom**: `/agent architect` shows "Agent not found"
488: 
489: **Solution**: Verify development plugin enabled:
490: ```bash
491: /config plugin status claude-code-development
492: /config plugin enable claude-code-development
493: ```
494: 
495: ### Serena Not Working
496: 
497: **Symptom**: `/analyze --semantic` shows "Serena not available"
498: 
499: **Solution**: Activate Serena for project:
500: ```bash
501: /serena activate                        # Activate Serena
502: /serena status                          # Verify status
503: ```
504: 
505: ### Tests Not Running
506: 
507: **Symptom**: `/run tests` fails with "command not found"
508: 
509: **Solution**: Verify test command in package.json or setup:
510: ```bash
511: cat package.json                        # Check test script
512: npm test                                # Verify manually
513: /run "npm test"                         # Explicit command
514: ```
515: 
516: ### Review Too Broad
517: 
518: **Symptom**: `/review` takes too long or uses too many tokens
519: 
520: **Solution**: Scope review to specific area:
521: ```bash
522: /review src/auth/                       # Specific directory
523: /review src/auth/login.ts               # Specific file
524: /review --semantic                      # Use Serena (more efficient)
525: ```
526: 
527: ## Version History
528: 
529: ### 1.0.0 (2025-10-11)
530: - Initial plugin release
531: - 8 development commands
532: - 5 specialized agents
533: - MCP integration (Sequential Thinking, Serena, Context7)
534: - TDD workflow support
535: - ML experiment capabilities
536: 
537: ## License
538: 
539: MIT License - See project LICENSE file
540: 
541: ## Related Plugins
542: 
543: - **core**: Required dependency
544: - **workflow**: Integrates with development cycle
545: - **git**: Code review integrates with PRs
546: - **memory**: Lessons learned from development
547: 
548: ---
549: 
550: **Note**: This plugin provides comprehensive development capabilities. For workflow-driven development, use in conjunction with the workflow plugin (/explore, /plan, /next, /ship).
````

## File: plugins/development/README.md
````markdown
  1: # Development Plugin
  2: 
  3: Code development and quality assurance tools for systematic analysis, testing, debugging, and review.
  4: 
  5: ## Overview
  6: 
  7: The Development plugin provides essential tools for building high-quality code. It includes commands for codebase analysis, test-driven development, debugging, code execution, and comprehensive code review. Three specialized agents provide expert assistance for architecture, testing, and code quality.
  8: 
  9: ## Features
 10: 
 11: - **Deep Analysis**: Semantic codebase understanding with architecture insights
 12: - **Test-Driven Development**: Comprehensive TDD workflow with test generation
 13: - **Universal Debugging**: Fix errors, bugs, and code issues with semantic analysis
 14: - **Safe Execution**: Run scripts and code with monitoring and timeout control
 15: - **Code Review**: Systematic review for bugs, design flaws, and quality issues
 16: 
 17: ## Commands
 18: 
 19: ### `/analyze [focus_area] [--with-thinking] [--semantic]`
 20: Analyze ANY project to understand its structure and architecture with semantic code intelligence and structured reasoning.
 21: 
 22: **What it does**:
 23: - Analyzes codebase structure and organization
 24: - Identifies architectural patterns and design choices
 25: - Maps dependencies and relationships
 26: - Highlights potential issues and improvements
 27: - Generates comprehensive analysis report
 28: 
 29: **Usage**:
 30: ```bash
 31: /analyze                                    # Full project analysis
 32: /analyze src/auth                           # Analyze specific area
 33: /analyze --with-thinking                    # Use structured reasoning
 34: /analyze --semantic                         # Use Serena semantic analysis
 35: /analyze src/api --with-thinking --semantic # Deep analysis with all tools
 36: ```
 37: 
 38: **Analysis Types**:
 39: - **Structure**: Directory organization, module layout
 40: - **Architecture**: Design patterns, architectural style
 41: - **Dependencies**: Internal and external dependencies
 42: - **Quality**: Code quality metrics, technical debt
 43: - **Security**: Potential security issues
 44: - **Performance**: Performance bottlenecks
 45: 
 46: **Output**:
 47: - Comprehensive analysis document
 48: - Architectural diagrams (textual)
 49: - Dependency maps
 50: - Recommendations for improvements
 51: 
 52: **When to use**:
 53: - ✅ New codebase familiarization
 54: - ✅ Architecture review
 55: - ✅ Before major refactoring
 56: - ✅ Technical debt assessment
 57: - ✅ Onboarding new team members
 58: 
 59: ### `/test [tdd] [pattern]`
 60: Test-driven development workflow using test-engineer agent. Create tests, analyze coverage, and ensure quality.
 61: 
 62: **What it does**:
 63: - Creates comprehensive test suites
 64: - Analyzes test coverage
 65: - Identifies untested code paths
 66: - Generates test cases from specifications
 67: - Runs tests and reports results
 68: 
 69: **Usage**:
 70: ```bash
 71: /test                                       # Run existing tests
 72: /test tdd                                   # Start TDD workflow
 73: /test src/auth/*                            # Test specific pattern
 74: /test --coverage                            # Generate coverage report
 75: ```
 76: 
 77: **TDD Workflow**:
 78: 1. **Write test first**: Define expected behavior
 79: 2. **Run test** (should fail initially)
 80: 3. **Implement code**: Make test pass
 81: 4. **Refactor**: Improve while keeping tests green
 82: 5. **Repeat**: Next feature
 83: 
 84: **Test Types Supported**:
 85: - Unit tests
 86: - Integration tests
 87: - End-to-end tests
 88: - Property-based tests
 89: - Mutation tests
 90: 
 91: **When to use**:
 92: - ✅ New feature development (TDD)
 93: - ✅ Bug fixes (regression tests)
 94: - ✅ Refactoring (safety net)
 95: - ✅ Coverage improvements
 96: - ✅ Quality assurance
 97: 
 98: ### `/fix [error|review|audit|all] [file/pattern]`
 99: Universal debugging and fix application with semantic code analysis. Debug errors or apply review fixes automatically.
100: 
101: **What it does**:
102: - Analyzes errors and exceptions
103: - Identifies root causes
104: - Proposes and applies fixes
105: - Applies code review suggestions
106: - Fixes audit findings
107: 
108: **Usage**:
109: ```bash
110: /fix                                        # Fix latest error
111: /fix error src/auth/login.js               # Fix specific file errors
112: /fix review                                 # Apply review suggestions
113: /fix audit                                  # Fix audit findings
114: /fix all                                    # Fix everything
115: ```
116: 
117: **Fix Sources**:
118: - **error**: Runtime errors, exceptions, crashes
119: - **review**: Code review feedback
120: - **audit**: Audit findings and compliance issues
121: - **test**: Test failures
122: - **lint**: Linter warnings and errors
123: 
124: **Fix Process**:
125: 1. Identify issue and context
126: 2. Analyze root cause
127: 3. Propose fix with explanation
128: 4. Apply fix (with user confirmation if risky)
129: 5. Verify fix resolves issue
130: 6. Run tests to prevent regression
131: 
132: **When to use**:
133: - ✅ Debugging runtime errors
134: - ✅ Addressing review feedback
135: - ✅ Fixing test failures
136: - ✅ Resolving linter issues
137: - ✅ Quick fixes with confidence
138: 
139: ### `/run [script or file to run]`
140: Execute code or scripts with monitoring and timeout control. Safe execution with output capture.
141: 
142: **What it does**:
143: - Runs scripts, tests, builds, or any executable code
144: - Monitors execution with timeout protection
145: - Captures stdout/stderr output
146: - Reports execution status and errors
147: - Provides execution metrics
148: 
149: **Usage**:
150: ```bash
151: /run npm test                               # Run npm tests
152: /run python scripts/migrate.py              # Run Python script
153: /run make build                             # Run make command
154: /run --timeout 300 npm run long-task        # Custom timeout (5 min)
155: ```
156: 
157: **Features**:
158: - **Timeout Protection**: Prevents hanging processes (default: 2 min, max: 10 min)
159: - **Output Capture**: Full stdout/stderr capture with formatting
160: - **Error Handling**: Clear error reporting with exit codes
161: - **Background Mode**: Run long tasks in background
162: - **Output Monitoring**: Check output of background tasks
163: 
164: **When to use**:
165: - ✅ Running tests before commit
166: - ✅ Executing build scripts
167: - ✅ Database migrations
168: - ✅ Code generation scripts
169: - ✅ Any CLI tool or script
170: 
171: ### `/review [file/directory] [--spec requirements.md] [--systematic] [--semantic]`
172: Standard code review focused on bugs, design flaws, dead code, and code quality with prioritized action plan.
173: 
174: **What it does**:
175: - Reviews code for bugs and logic errors
176: - Identifies design flaws and anti-patterns
177: - Finds dead code and unused variables
178: - Checks code quality and maintainability
179: - Provides prioritized recommendations
180: 
181: **Usage**:
182: ```bash
183: /review                                     # Review recent changes
184: /review src/auth                            # Review directory
185: /review src/auth/login.js                   # Review specific file
186: /review --spec @requirements.md             # Review against spec
187: /review --systematic                        # Use structured reasoning
188: /review --semantic                          # Use semantic code analysis
189: ```
190: 
191: **Review Focus Areas**:
192: 1. **Bugs**: Logic errors, edge cases, null checks
193: 2. **Design**: Architecture, patterns, coupling
194: 3. **Dead Code**: Unused functions, variables, imports
195: 4. **Quality**: Readability, maintainability, naming
196: 5. **Security**: Vulnerabilities, input validation
197: 6. **Performance**: Inefficiencies, optimization opportunities
198: 7. **Testing**: Test coverage, test quality
199: 
200: **Output Format**:
201: ```
202: HIGH Priority:
203: - [BUG] Null pointer in login.js:45
204: - [SECURITY] SQL injection risk in query.js:120
205: 
206: MEDIUM Priority:
207: - [DESIGN] God class in UserService.js
208: - [PERFORMANCE] N+1 query in getUsers()
209: 
210: LOW Priority:
211: - [QUALITY] Inconsistent naming in helpers.js
212: - [DEAD CODE] Unused import in utils.js
213: ```
214: 
215: **When to use**:
216: - ✅ Before pull request submission
217: - ✅ After completing feature
218: - ✅ Regular code quality checks
219: - ✅ Onboarding review
220: - ✅ Security audits
221: 
222: ## Agents
223: 
224: ### Architect (`architect.md`)
225: System design and architectural decisions specialist. Provides high-level design guidance.
226: 
227: **Expertise**:
228: - System architecture and design patterns
229: - Technology selection and evaluation
230: - Scalability and performance architecture
231: - Security architecture
232: - API design and integration patterns
233: 
234: **Capabilities**:
235: - ✅ Structured reasoning for complex decisions
236: - ✅ Trade-off analysis for technology choices
237: - ✅ Architectural blueprint creation
238: - ✅ Design review and recommendations
239: - ✅ Technical specification writing
240: 
241: **When to use**:
242: ```bash
243: /agent architect "Design authentication system for multi-tenant SaaS"
244: /agent architect "Evaluate microservices vs monolith for our use case"
245: /agent architect "Review proposed API architecture"
246: ```
247: 
248: ### Test Engineer (`test-engineer.md`)
249: Test creation, coverage analysis, and quality assurance specialist.
250: 
251: **Expertise**:
252: - Test-driven development (TDD)
253: - Test suite design and organization
254: - Coverage analysis and improvement
255: - Testing strategies (unit, integration, e2e)
256: - Test framework selection
257: 
258: **Capabilities**:
259: - ✅ Semantic code understanding for test generation
260: - ✅ Coverage gap identification
261: - ✅ Test case generation from specs
262: - ✅ Testing best practices
263: - ✅ Test quality assessment
264: 
265: **When to use**:
266: ```bash
267: /agent test-engineer "Create comprehensive tests for auth module"
268: /agent test-engineer "Analyze test coverage and suggest improvements"
269: /agent test-engineer "Design testing strategy for new feature"
270: ```
271: 
272: ### Code Reviewer (`code-reviewer.md`)
273: Code review, documentation quality, and security audit specialist.
274: 
275: **Expertise**:
276: - Code quality and maintainability
277: - Security vulnerability detection
278: - Documentation completeness
279: - Best practices enforcement
280: - Refactoring recommendations
281: 
282: **Capabilities**:
283: - ✅ Structured reasoning for complex reviews
284: - ✅ Semantic code analysis
285: - ✅ Security-focused review
286: - ✅ Performance optimization suggestions
287: - ✅ Comprehensive feedback with priorities
288: 
289: **When to use**:
290: ```bash
291: /agent code-reviewer "Review authentication implementation for security"
292: /agent code-reviewer "Assess code quality of new payment module"
293: /agent code-reviewer "Review PR #123 for merge readiness"
294: ```
295: 
296: ## Integration with Other Plugins
297: 
298: ### Core Plugin
299: - Uses `/agent` for invoking development agents
300: - Uses `/status` to show analysis and review progress
301: - Uses `/performance` for execution metrics
302: 
303: ### Workflow Plugin
304: - `/analyze` used during `/explore` phase
305: - `/test` and `/review` used during `/ship` validation
306: - `/fix` helps resolve issues blocking `/next`
307: 
308: ### Git Plugin
309: - `/review` provides feedback before git commit
310: - `/fix` applies changes that git commit includes
311: - Quality gates integrated with git workflow
312: 
313: ## Configuration
314: 
315: ### Analysis Defaults (`.claude/config.json`)
316: ```json
317: {
318:   "development": {
319:     "analyze": {
320:       "defaultMode": "semantic",
321:       "useStructuredReasoning": true,
322:       "depthLevel": "comprehensive"
323:     }
324:   }
325: }
326: ```
327: 
328: ### Test Defaults
329: ```json
330: {
331:   "development": {
332:     "test": {
333:       "framework": "auto-detect",
334:       "coverageThreshold": 80,
335:       "runBeforeCommit": true
336:     }
337:   }
338: }
339: ```
340: 
341: ### Review Defaults
342: ```json
343: {
344:   "development": {
345:     "review": {
346:       "autoReview": false,
347:       "focusAreas": ["bugs", "security", "design"],
348:       "severityThreshold": "medium"
349:     }
350:   }
351: }
352: ```
353: 
354: ## Dependencies
355: 
356: ### Required Plugins
357: - **claude-code-core** (^1.0.0): Agent invocation, status tracking
358: 
359: ### Optional MCP Tools
360: - **Sequential Thinking**: Enhances architect and code-reviewer structured reasoning
361: - **Serena**: Enables semantic code understanding (70-90% token reduction for code ops)
362: - **Context7**: Library documentation access for best practices
363: 
364: **Graceful Degradation**: All commands work without MCP tools.
365: 
366: ## Best Practices
367: 
368: ### Analysis Workflow
369: ```bash
370: # 1. Start with high-level analysis
371: /analyze
372: 
373: # 2. Deep-dive into specific areas
374: /analyze src/auth --semantic --with-thinking
375: 
376: # 3. Review findings and plan improvements
377: ```
378: 
379: ### TDD Workflow
380: ```bash
381: # 1. Start TDD mode
382: /test tdd
383: 
384: # 2. Write test first
385: # (test-engineer helps generate test cases)
386: 
387: # 3. Run test (should fail)
388: /run npm test
389: 
390: # 4. Implement feature
391: 
392: # 5. Run test (should pass)
393: /run npm test
394: 
395: # 6. Refactor
396: 
397: # 7. Repeat
398: ```
399: 
400: ### Review Workflow
401: ```bash
402: # 1. Self-review before PR
403: /review --semantic
404: 
405: # 2. Fix HIGH priority issues
406: /fix review
407: 
408: # 3. Address MEDIUM priority
409: # (make changes manually or with /fix)
410: 
411: # 4. Re-review to verify
412: /review
413: 
414: # 5. Submit PR when clean
415: ```
416: 
417: ## Performance Considerations
418: 
419: ### Serena Semantic Analysis
420: When Serena MCP is available:
421: - **Token Reduction**: 70-90% fewer tokens for code operations
422: - **Accuracy**: More precise symbol understanding
423: - **Speed**: Faster code navigation and search
424: 
425: **Enable Serena**:
426: ```bash
427: /serena  # From core plugin
428: ```
429: 
430: ### Sequential Thinking
431: When Sequential Thinking is available:
432: - **Quality**: +20-30% better architectural decisions
433: - **Tokens**: +15-30% more tokens (but worth it for complex decisions)
434: 
435: **Automatic**: Used automatically by architect and code-reviewer when available
436: 
437: ## Troubleshooting
438: 
439: ### /analyze finds no issues
440: - Try `--with-thinking` for deeper analysis
441: - Use `--semantic` if Serena available
442: - Specify focus area: `/analyze src/problem-area`
443: 
444: ### /test can't find test files
445: - Verify test framework installed
446: - Check test file patterns in config
447: - Ensure tests exist in standard locations
448: 
449: ### /fix doesn't find errors
450: - Specify error source: `/fix error [file]`
451: - Try `/fix review` after running `/review`
452: - Check recent command output for errors
453: 
454: ### /review gives too much feedback
455: - Set severity threshold in config
456: - Focus on specific areas: `/review src/module`
457: - Address HIGH priority first, iterate on others
458: 
459: ## Metrics and Quality
460: 
461: The development plugin tracks:
462: - **Code quality**: Issues found, severity distribution
463: - **Test coverage**: Percentage covered, gaps identified
464: - **Review metrics**: Issues per 1000 lines, time to review
465: - **Fix success**: Fixes applied, tests passing after fix
466: 
467: View with:
468: ```bash
469: /status verbose
470: /performance
471: ```
472: 
473: ## Examples
474: 
475: ### Example 1: New Feature with TDD
476: ```bash
477: # Start TDD workflow
478: /test tdd
479: 
480: # Test-engineer generates test cases
481: # Implement feature to pass tests
482: 
483: # Run tests
484: /run npm test
485: 
486: # Review implementation
487: /review src/new-feature
488: 
489: # Fix any issues
490: /fix review
491: 
492: # Ship it
493: /ship --commit
494: ```
495: 
496: ### Example 2: Bug Investigation
497: ```bash
498: # Analyze problem area
499: /analyze src/buggy-module --semantic
500: 
501: # Review code for bugs
502: /review src/buggy-module
503: 
504: # Fix identified issues
505: /fix review
506: 
507: # Run tests
508: /run npm test
509: 
510: # Verify fix
511: /test src/buggy-module
512: ```
513: 
514: ### Example 3: Architecture Review
515: ```bash
516: # Get architect input
517: /agent architect "Review proposed microservices architecture"
518: 
519: # Analyze current architecture
520: /analyze --with-thinking
521: 
522: # Identify issues
523: /review --systematic
524: 
525: # Plan improvements based on findings
526: ```
527: 
528: ## Support
529: 
530: - **Documentation**: [Development Guide](../../docs/guides/development.md)
531: - **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
532: - **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
533: 
534: ## License
535: 
536: MIT License - see [LICENSE](../../LICENSE) for details.
537: 
538: ---
539: 
540: **Version**: 1.0.0
541: **Category**: Development
542: **Commands**: 5 (analyze, test, fix, run, review)
543: **Agents**: 3 (architect, test-engineer, code-reviewer)
544: **Dependencies**: core (^1.0.0)
545: **MCP Tools**: Optional (sequential-thinking, serena, context7)
````

## File: plugins/git/.claude-plugin/README.md
````markdown
  1: # Claude Code Git Plugin
  2: 
  3: **Version**: 1.0.0
  4: **Category**: Tools
  5: **Author**: Claude Code Framework
  6: 
  7: ## Overview
  8: 
  9: The Git Plugin provides unified git operations including commits, pull requests, and issue management. It ensures safe, validated git operations with proper attribution and comprehensive documentation.
 10: 
 11: ## Command
 12: 
 13: ### `/git [operation] [arguments]`
 14: Unified git operations - commits, pull requests, and issue management.
 15: 
 16: **Operations**:
 17: - `commit`: Create safe git commit with validation
 18: - `pr`: Create pull request with documentation
 19: - `issue`: Manage GitHub issues
 20: 
 21: ## Operations
 22: 
 23: ### Git Commit
 24: 
 25: Create safe git commits with validation and proper attribution.
 26: 
 27: **Usage**:
 28: ```bash
 29: /git commit -m "feat: Add user authentication"
 30: /git commit -m "fix: Resolve login timeout issue"
 31: /git commit -m "docs: Update API documentation"
 32: ```
 33: 
 34: **Features**:
 35: - **Safe Commits**: Uses `git safe-commit` to prevent common mistakes
 36: - **Validation**: Checks for uncommitted changes, conflicts, and issues
 37: - **Attribution**: Automatic co-authorship with Claude
 38: - **Conventional Commits**: Supports conventional commit format
 39: - **Pre-commit Hooks**: Respects repository hooks
 40: 
 41: **Commit Message Format**:
 42: ```
 43: <type>: <description>
 44: 
 45: [optional body]
 46: 
 47: 🤖 Generated with [Claude Code](https://claude.com/claude-code)
 48: 
 49: Co-Authored-By: Claude <noreply@anthropic.com>
 50: ```
 51: 
 52: **Common Types**:
 53: - `feat`: New feature
 54: - `fix`: Bug fix
 55: - `docs`: Documentation only
 56: - `style`: Formatting, missing semicolons, etc
 57: - `refactor`: Code change that neither fixes bug nor adds feature
 58: - `perf`: Performance improvement
 59: - `test`: Adding missing tests
 60: - `chore`: Changes to build process or auxiliary tools
 61: 
 62: **Safety Features**:
 63: 1. **Pre-commit Validation**: Runs checks before commit
 64: 2. **Conflict Detection**: Identifies merge conflicts
 65: 3. **Hook Execution**: Respects pre-commit hooks
 66: 4. **Amend Safety**: Only amends own commits, never others
 67: 5. **Attribution Check**: Verifies authorship before amend
 68: 
 69: **Integration with Ship**:
 70: - `/ship` command uses safe commit automatically
 71: - No need to run `/git commit` manually during delivery
 72: - Safe commit is integrated into workflow
 73: 
 74: ---
 75: 
 76: ### Pull Request Creation
 77: 
 78: Create pull requests with comprehensive documentation.
 79: 
 80: **Usage**:
 81: ```bash
 82: /git pr                                      # Create PR from current branch
 83: /git pr --draft                              # Create draft PR
 84: /git pr --title "Add OAuth2 support"         # Custom title
 85: ```
 86: 
 87: **PR Generation Process**:
 88: 
 89: 1. **Branch Analysis**: Review current branch changes
 90: 2. **Commit History**: Analyze all commits since divergence
 91: 3. **Change Summary**: Generate comprehensive summary
 92: 4. **Documentation**: Create detailed PR description
 93: 5. **Test Plan**: Include testing checklist
 94: 6. **Attribution**: Add Claude co-authorship note
 95: 
 96: **PR Description Format**:
 97: ```markdown
 98: ## Summary
 99: - [Bullet point summary of changes]
100: - [Key features added]
101: - [Issues resolved]
102: 
103: ## Changes
104: ### [Category 1]
105: - [Specific change 1]
106: - [Specific change 2]
107: 
108: ### [Category 2]
109: - [Specific change 3]
110: 
111: ## Test Plan
112: - [ ] Unit tests pass
113: - [ ] Integration tests pass
114: - [ ] Manual testing completed
115: - [ ] Documentation updated
116: 
117: ## Breaking Changes
118: [None or description of breaking changes]
119: 
120: ## Related Issues
121: Closes #123
122: Fixes #456
123: 
124: 🤖 Generated with [Claude Code](https://claude.com/claude-code)
125: ```
126: 
127: **Requirements**:
128: - GitHub CLI (`gh`) must be installed
129: - Repository must have GitHub remote
130: - User must be authenticated with `gh auth login`
131: 
132: **Options**:
133: - `--draft`: Create draft PR (not ready for review)
134: - `--title "Title"`: Custom PR title
135: - `--body "Description"`: Custom PR body
136: - `--base main`: Target branch (default: main/master)
137: 
138: **Integration with Ship**:
139: - `/ship --pr` creates PR automatically
140: - Recommended for delivery workflow
141: - Includes full validation before PR creation
142: 
143: ---
144: 
145: ### Issue Management
146: 
147: Create and manage GitHub issues.
148: 
149: **Usage**:
150: ```bash
151: /git issue create --title "Bug: Login fails"
152: /git issue create --title "Feature: Add OAuth" --label enhancement
153: /git issue list                              # List open issues
154: /git issue view 123                          # View issue #123
155: /git issue close 123                         # Close issue #123
156: ```
157: 
158: **Issue Creation**:
159: ```bash
160: /git issue create \
161:   --title "Bug: Login timeout after 30 seconds" \
162:   --body "Description of issue..." \
163:   --label bug \
164:   --assignee username
165: ```
166: 
167: **Issue Labels**:
168: - `bug`: Bug report
169: - `enhancement`: Feature request
170: - `documentation`: Documentation improvement
171: - `question`: Question or discussion
172: - `help wanted`: Community help needed
173: - `good first issue`: Good for newcomers
174: 
175: **Requirements**:
176: - GitHub CLI (`gh`) must be installed
177: - Repository must have GitHub remote
178: - User must be authenticated
179: 
180: ## Capabilities
181: 
182: ### Safe Commits
183: 
184: **Integrated With**: `/ship`, `/next` commands
185: 
186: **Safety Checks**:
187: 1. **Staged Changes**: Verifies files staged for commit
188: 2. **Conflicts**: Checks for merge conflicts
189: 3. **Hooks**: Respects pre-commit hooks
190: 4. **Attribution**: Validates authorship
191: 5. **Message Format**: Validates commit message
192: 
193: **Auto-Amend Logic**:
194: ```
195: If pre-commit hook modifies files:
196:   1. Check authorship (git log -1 --format='%an %ae')
197:   2. Check not pushed (git status shows "ahead")
198:   3. If both true: Amend commit
199:   4. Else: Create new commit
200: ```
201: 
202: **Never Amend When**:
203: - Commit authored by someone else
204: - Commit already pushed to remote
205: - User explicitly requests no amend
206: 
207: ---
208: 
209: ### Pull Request Creation
210: 
211: **Integrated With**: `/ship --pr` command
212: 
213: **PR Workflow**:
214: 1. **Validate State**: Ensure branch up-to-date, no uncommitted changes
215: 2. **Analyze Changes**: Review full diff from base branch
216: 3. **Generate Description**: Create comprehensive PR summary
217: 4. **Create PR**: Use `gh pr create` with generated content
218: 5. **Return URL**: Provide PR link to user
219: 
220: **PR Quality**:
221: - **Comprehensive Summary**: Covers all changes
222: - **Categorized Changes**: Organized by type
223: - **Test Plan**: Checklist for reviewers
224: - **Issue References**: Links to related issues
225: - **Attribution**: Claude co-authorship noted
226: 
227: ---
228: 
229: ### Issue Management
230: 
231: **Commands**:
232: - `create`: Create new issue
233: - `list`: List issues (open, closed, all)
234: - `view`: View issue details
235: - `close`: Close issue
236: - `reopen`: Reopen closed issue
237: - `comment`: Add comment to issue
238: 
239: **Use Cases**:
240: - Bug reporting during development
241: - Feature request tracking
242: - Discussion and questions
243: - Community engagement
244: 
245: ## Configuration
246: 
247: ### Plugin Settings
248: 
249: ```json
250: {
251:   "settings": {
252:     "defaultEnabled": true,
253:     "category": "tools"
254:   }
255: }
256: ```
257: 
258: ### Dependencies
259: 
260: ```json
261: {
262:   "dependencies": {
263:     "claude-code-core": "^1.0.0"
264:   }
265: }
266: ```
267: 
268: ### System Requirements
269: 
270: ```json
271: {
272:   "systemRequirements": {
273:     "git": {
274:       "required": true,
275:       "minVersion": "2.0.0"
276:     },
277:     "gh": {
278:       "required": false,
279:       "description": "GitHub CLI for pull request and issue management"
280:     }
281:   }
282: }
283: ```
284: 
285: **Git**: Required for all operations
286: **GitHub CLI**: Required only for PR and issue operations
287: 
288: ### MCP Tools
289: 
290: **None** - Git plugin operates independently of MCP tools.
291: 
292: **Graceful Degradation**: All features work in standard environments.
293: 
294: ## Best Practices
295: 
296: ### Commits
297: 
298: ✅ **Do**:
299: - Use conventional commit format
300: - Write clear, descriptive messages
301: - Commit related changes together
302: - Include "why" in commit body for complex changes
303: - Let `/ship` handle commits during delivery
304: 
305: ❌ **Don't**:
306: - Use `git commit` directly (use `git safe-commit` or `/git commit`)
307: - Commit without running tests first
308: - Make commits too large (split into logical chunks)
309: - Skip commit messages or use vague messages like "fixes"
310: - Amend commits authored by others
311: 
312: ### Pull Requests
313: 
314: ✅ **Do**:
315: - Create PR from feature branch
316: - Include comprehensive test plan
317: - Reference related issues
318: - Request review from appropriate team members
319: - Use `/ship --pr` for automatic PR creation
320: 
321: ❌ **Don't**:
322: - Create PR with failing tests
323: - Submit PR without description
324: - Include unrelated changes
325: - Push to PR after review without notification
326: - Create PR from main/master branch
327: 
328: ### Issues
329: 
330: ✅ **Do**:
331: - Use clear, specific titles
332: - Include reproduction steps for bugs
333: - Add appropriate labels
334: - Link related PRs and issues
335: - Respond to comments promptly
336: 
337: ❌ **Don't**:
338: - Create duplicate issues (search first)
339: - Use vague titles like "it doesn't work"
340: - Skip issue template sections
341: - Close issues without resolution
342: - Leave issues open indefinitely without updates
343: 
344: ## Integration with Workflow
345: 
346: ### With `/explore`
347: - Create issues for discovered requirements
348: - Reference issues in exploration notes
349: 
350: ### With `/plan`
351: - Link plan tasks to GitHub issues
352: - Create issues for identified work items
353: 
354: ### With `/next`
355: - Commit after each task completion
356: - Use safe commit automatically
357: 
358: ### With `/ship`
359: - Create final commit with all changes
360: - Generate PR with comprehensive docs
361: - Link PR to related issues
362: - Mark issues as resolved
363: 
364: ## Workflow Examples
365: 
366: ### Example 1: Feature Development with PR
367: 
368: ```bash
369: # Development
370: git checkout -b feature/oauth2
371: # ... implement feature ...
372: 
373: # Commit during development
374: /git commit -m "feat: Add OAuth2 authentication"
375: /git commit -m "test: Add OAuth2 integration tests"
376: /git commit -m "docs: Update authentication docs"
377: 
378: # Create PR
379: /git pr --title "Add OAuth2 authentication support"
380: # Or use ship command
381: /ship --pr
382: ```
383: 
384: ### Example 2: Bug Fix with Issue
385: 
386: ```bash
387: # Create issue
388: /git issue create \
389:   --title "Bug: Login timeout after 30 seconds" \
390:   --label bug
391: 
392: # Fix bug
393: git checkout -b fix/login-timeout
394: # ... fix issue ...
395: 
396: # Commit fix
397: /git commit -m "fix: Resolve login timeout issue
398: 
399: Increased timeout to 60 seconds and added retry logic.
400: 
401: Fixes #123"
402: 
403: # Ship fix
404: /ship --pr
405: ```
406: 
407: ### Example 3: Collaborative Development
408: 
409: ```bash
410: # Check open issues
411: /git issue list
412: 
413: # Pick issue
414: /git issue view 456
415: git checkout -b feature/issue-456
416: 
417: # Implement
418: # ... development ...
419: 
420: # Commit
421: /git commit -m "feat: Implement feature from #456"
422: 
423: # Create PR linking issue
424: /git pr --title "Implement feature XYZ" --body "Closes #456"
425: ```
426: 
427: ## Troubleshooting
428: 
429: ### GitHub CLI Not Found
430: 
431: **Symptom**: `/git pr` shows "gh command not found"
432: 
433: **Solution**: Install GitHub CLI:
434: ```bash
435: # macOS
436: brew install gh
437: 
438: # Linux
439: sudo apt install gh
440: 
441: # Authenticate
442: gh auth login
443: ```
444: 
445: ### Push Permission Denied
446: 
447: **Symptom**: Cannot push to remote
448: 
449: **Solution**: Set up authentication:
450: ```bash
451: # SSH
452: ssh-keygen -t ed25519
453: gh ssh-key add ~/.ssh/id_ed25519.pub
454: 
455: # HTTPS
456: gh auth login --web
457: ```
458: 
459: ### Pre-commit Hook Fails
460: 
461: **Symptom**: Commit fails with hook error
462: 
463: **Solution**: Fix hook issues or bypass if necessary:
464: ```bash
465: # Fix the issue (preferred)
466: # ... fix linting, tests, etc. ...
467: 
468: # Or skip hooks (use sparingly)
469: git commit --no-verify
470: ```
471: 
472: ### PR Creation Fails
473: 
474: **Symptom**: `/git pr` shows error
475: 
476: **Solutions**:
477: 1. Verify branch pushed to remote:
478:    ```bash
479:    git push -u origin feature-branch
480:    ```
481: 2. Check GitHub CLI authenticated:
482:    ```bash
483:    gh auth status
484:    ```
485: 3. Verify repository has GitHub remote:
486:    ```bash
487:    git remote -v
488:    ```
489: 
490: ### Wrong Remote Branch
491: 
492: **Symptom**: PR targets wrong branch
493: 
494: **Solution**: Specify base branch explicitly:
495: ```bash
496: /git pr --base develop
497: ```
498: 
499: ## Performance
500: 
501: ### Operation Times
502: 
503: - **Commit**: <1 second (excluding pre-commit hooks)
504: - **PR Creation**: 2-5 seconds (including analysis)
505: - **Issue Creation**: 1-2 seconds
506: - **Issue List**: 1-2 seconds
507: 
508: ### Pre-commit Hooks
509: 
510: Hook execution time depends on repository configuration:
511: - **Fast** (<5s): Linting, formatting
512: - **Medium** (5-30s): Unit tests
513: - **Slow** (>30s): Integration tests, builds
514: 
515: Consider hook optimization for frequently-committing workflows.
516: 
517: ## Security Considerations
518: 
519: ### Commit Attribution
520: 
521: All commits include Claude co-authorship:
522: ```
523: Co-Authored-By: Claude <noreply@anthropic.com>
524: ```
525: 
526: This ensures transparency about AI-assisted development.
527: 
528: ### Sensitive Information
529: 
530: **Never commit**:
531: - API keys, tokens, passwords
532: - Private keys, certificates
533: - Personal data
534: - Proprietary code (in public repos)
535: 
536: Use `.gitignore` and pre-commit hooks to prevent accidental commits.
537: 
538: ### Branch Protection
539: 
540: Recommended GitHub branch protection rules:
541: - Require pull request reviews
542: - Require status checks to pass
543: - Enforce linear history
544: - Require signed commits (optional)
545: 
546: ## Version History
547: 
548: ### 1.0.0 (2025-10-11)
549: - Initial plugin release
550: - Safe commit integration
551: - PR creation with comprehensive docs
552: - GitHub issue management
553: - Integration with workflow plugin
554: 
555: ## License
556: 
557: MIT License - See project LICENSE file
558: 
559: ## Related Plugins
560: 
561: - **core**: Required dependency
562: - **workflow**: Integrated with `/ship` for commits and PRs
563: - **development**: Code review integrates with PRs
564: 
565: ## Additional Resources
566: 
567: - Git Documentation: https://git-scm.com/doc
568: - GitHub CLI Documentation: https://cli.github.com/manual/
569: - Conventional Commits: https://www.conventionalcommits.org/
570: - GitHub Flow: https://guides.github.com/introduction/flow/
571: 
572: ---
573: 
574: **Note**: This plugin ensures safe, validated git operations with proper attribution. Always use `/git commit` or let workflow commands handle commits automatically.
````

## File: plugins/git/README.md
````markdown
  1: # Git Plugin
  2: 
  3: Unified git operations for commits, pull requests, and issue management with AI-assisted workflows.
  4: 
  5: ## Overview
  6: 
  7: The Git plugin provides a unified `/git` command that handles all git operations with intelligent automation. It creates well-formatted commits, generates comprehensive pull requests, and manages GitHub issues - all with proper attribution and best practices built-in.
  8: 
  9: ## Features
 10: 
 11: - **Smart Commits**: AI-generated commit messages following conventional commit format
 12: - **Pull Request Automation**: Comprehensive PR creation with summaries and test plans
 13: - **Issue Management**: Create and manage GitHub issues via gh CLI
 14: - **Safe Operations**: Never destructive, always reviewable before execution
 15: - **Proper Attribution**: Auto-adds Claude Code attribution to commits and PRs
 16: 
 17: ## Command
 18: 
 19: ### `/git [commit|pr|issue] [arguments]`
 20: Unified git operations - commits, pull requests, and issue management.
 21: 
 22: ## Git Commit
 23: 
 24: Create commits with AI-generated messages that follow best practices.
 25: 
 26: **Usage**:
 27: ```bash
 28: /git commit                                 # Commit staged changes with generated message
 29: /git commit -m "Custom message"            # Commit with custom message
 30: /git commit --amend                        # Amend last commit (with safety checks)
 31: /git commit --all                          # Stage all changes and commit
 32: ```
 33: 
 34: **What it does**:
 35: 1. Analyzes staged changes (or all changes with --all)
 36: 2. Reviews recent commits to match style
 37: 3. Generates descriptive commit message
 38: 4. Shows you the message for approval
 39: 5. Creates commit with Claude Code attribution
 40: 6. Runs pre-commit hooks if configured
 41: 
 42: **Commit Message Format**:
 43: ```
 44: feat: Add user authentication with JWT
 45: 
 46: Implements JWT-based authentication for API endpoints.
 47: - Add password hashing to User model
 48: - Create login endpoint with token generation
 49: - Protect existing endpoints with auth middleware
 50: - Add comprehensive integration tests
 51: 
 52: 🤖 Generated with [Claude Code](https://claude.com/claude-code)
 53: 
 54: Co-Authored-By: Claude <noreply@anthropic.com>
 55: ```
 56: 
 57: **Commit Types**:
 58: - `feat`: New feature
 59: - `fix`: Bug fix
 60: - `docs`: Documentation changes
 61: - `refactor`: Code refactoring
 62: - `test`: Test additions or modifications
 63: - `chore`: Maintenance tasks
 64: - `perf`: Performance improvements
 65: - `style`: Code style changes (formatting)
 66: 
 67: **Safety Features**:
 68: - Never uses `--force` flags
 69: - Never uses `--no-verify` (skipping hooks)
 70: - Checks authorship before amending
 71: - Warns on force push to main/master
 72: - Validates staged changes before committing
 73: 
 74: **When to use**:
 75: - ✅ After completing a feature or fix
 76: - ✅ Regular progress checkpoints
 77: - ✅ Before switching branches
 78: - ✅ Integrated with `/ship --commit`
 79: 
 80: **When NOT to use**:
 81: - ❌ No changes to commit (git will warn)
 82: - ❌ Unreviewed changes you don't understand
 83: - ❌ Temporary/experimental code
 84: 
 85: ## Git Pull Request
 86: 
 87: Create pull requests with comprehensive documentation.
 88: 
 89: **Usage**:
 90: ```bash
 91: /git pr                                     # Create PR from current branch
 92: /git pr "PR title"                         # Create PR with custom title
 93: /git pr --draft                            # Create draft PR
 94: /git pr --base develop                     # Target different base branch
 95: ```
 96: 
 97: **What it does**:
 98: 1. Analyzes all commits since branch diverged from base
 99: 2. Examines changed files and code
100: 3. Generates comprehensive PR summary
101: 4. Creates test plan checklist
102: 5. Pushes branch if needed
103: 6. Creates PR via gh CLI
104: 7. Returns PR URL
105: 
106: **PR Format**:
107: ```markdown
108: ## Summary
109: - Add JWT-based authentication to API
110: - Implement password hashing and token generation
111: - Protect endpoints with auth middleware
112: - Add comprehensive integration tests
113: 
114: ## Changes
115: - **Added**: JWT token generation utilities
116: - **Modified**: User model with password hashing
117: - **Added**: Login endpoint at /api/auth/login
118: - **Added**: Auth middleware for protected routes
119: - **Added**: Integration tests for auth flow
120: 
121: ## Test Plan
122: - [ ] Test user registration creates hashed password
123: - [ ] Test login generates valid JWT token
124: - [ ] Test protected endpoints reject without token
125: - [ ] Test protected endpoints accept with valid token
126: - [ ] Test token expiration handling
127: - [ ] Run full integration test suite
128: 
129: ## Breaking Changes
130: None
131: 
132: 🤖 Generated with [Claude Code](https://claude.com/claude-code)
133: ```
134: 
135: **Requirements**:
136: - **gh CLI**: GitHub CLI must be installed and authenticated
137: - **Remote branch**: Branch should be pushed or will auto-push
138: - **Git configured**: User name and email must be set
139: 
140: **Configuration**:
141: ```bash
142: # Install gh CLI (if not installed)
143: # macOS
144: brew install gh
145: 
146: # Linux
147: # See: https://github.com/cli/cli#installation
148: 
149: # Authenticate
150: gh auth login
151: ```
152: 
153: **When to use**:
154: - ✅ Feature development complete
155: - ✅ Ready for team review
156: - ✅ After `/ship` validation passes
157: - ✅ Integrated with `/ship --pr`
158: 
159: ## Git Issue
160: 
161: Create and manage GitHub issues.
162: 
163: **Usage**:
164: ```bash
165: /git issue "Bug: Login fails on Safari"    # Create new issue
166: /git issue "Feature: Add OAuth support" --label enhancement
167: /git issue --list                          # List open issues
168: /git issue --close 123                     # Close issue #123
169: ```
170: 
171: **What it does**:
172: - Creates well-formatted GitHub issues
173: - Assigns labels and milestones
174: - Adds issue templates if available
175: - Links to related PRs/commits
176: - Manages issue lifecycle
177: 
178: **Issue Format**:
179: ```markdown
180: ## Description
181: [Clear description of the issue]
182: 
183: ## Steps to Reproduce
184: 1. [First step]
185: 2. [Second step]
186: 3. [etc.]
187: 
188: ## Expected Behavior
189: [What should happen]
190: 
191: ## Actual Behavior
192: [What actually happens]
193: 
194: ## Environment
195: - OS: [e.g., macOS 13.0]
196: - Browser: [e.g., Safari 16.1]
197: - Version: [e.g., v1.2.3]
198: 
199: ## Additional Context
200: [Any additional information]
201: ```
202: 
203: **Requirements**:
204: - **gh CLI**: GitHub CLI must be installed and authenticated
205: 
206: **When to use**:
207: - ✅ Bug reports
208: - ✅ Feature requests
209: - ✅ Task tracking
210: - ✅ Documentation todos
211: 
212: ## Safety Protocol
213: 
214: The Git plugin follows these safety rules:
215: 
216: ### NEVER Do
217: - ❌ Run `git push --force` to main/master (warns user if requested)
218: - ❌ Skip hooks with `--no-verify` or `--no-gpg-sign`
219: - ❌ Update git config without user permission
220: - ❌ Amend commits by other developers
221: - ❌ Amend commits already pushed to shared branches
222: - ❌ Commit files that likely contain secrets (.env, credentials, etc.)
223: 
224: ### ALWAYS Do
225: - ✅ Validate staged changes before committing
226: - ✅ Check authorship before amending
227: - ✅ Run pre-commit hooks if configured
228: - ✅ Add Claude Code attribution
229: - ✅ Generate descriptive commit messages
230: - ✅ Review changes with user before committing
231: - ✅ Warn about sensitive files
232: - ✅ Verify tests pass before recommending PR
233: 
234: ## Integration with Other Plugins
235: 
236: ### Workflow Plugin
237: **Integrated with /ship**:
238: ```bash
239: /ship --commit              # Uses /git commit
240: /ship --pr                  # Uses /git pr
241: ```
242: 
243: The workflow plugin calls git plugin automatically during delivery.
244: 
245: ### Development Plugin
246: **Quality Gates**:
247: - `/review` runs before `/git commit` (recommended)
248: - `/test` runs before `/git pr` (recommended)
249: - `/fix` resolves issues blocking commit
250: 
251: **Recommended Flow**:
252: ```bash
253: # 1. Review code
254: /review
255: 
256: # 2. Fix issues
257: /fix review
258: 
259: # 3. Run tests
260: /run npm test
261: 
262: # 4. Commit when ready
263: /git commit
264: 
265: # 5. Create PR
266: /git pr
267: ```
268: 
269: ### Core Plugin
270: - Uses `/agent` for specialized git operations
271: - Uses `/status` to show git state
272: 
273: ## Configuration
274: 
275: ### Commit Defaults (`.claude/config.json`)
276: ```json
277: {
278:   "git": {
279:     "commit": {
280:       "conventionalCommits": true,
281:       "addAttribution": true,
282:       "analyzeRecentCommits": true,
283:       "commitCountToAnalyze": 5,
284:       "allowAmend": "with-checks"
285:     }
286:   }
287: }
288: ```
289: 
290: ### Pull Request Defaults
291: ```json
292: {
293:   "git": {
294:     "pr": {
295:       "defaultBase": "main",
296:       "includeSummary": true,
297:       "includeTestPlan": true,
298:       "autoLabels": true,
299:       "draftByDefault": false
300:     }
301:   }
302: }
303: ```
304: 
305: ### Safety Rules
306: ```json
307: {
308:   "git": {
309:     "safety": {
310:       "warnOnForceToMain": true,
311:       "preventSecretCommit": true,
312:       "secretPatterns": [".env", "credentials", "secrets", "*.key"],
313:       "requireTestsBeforePR": false
314:     }
315:   }
316: }
317: ```
318: 
319: ## System Requirements
320: 
321: ### Required
322: - **git** (v2.0.0+): Version control system
323:   ```bash
324:   git --version
325:   # Should be 2.0.0 or higher
326:   ```
327: 
328: ### Optional
329: - **gh** (GitHub CLI): For PR and issue management
330:   ```bash
331:   # Install
332:   brew install gh           # macOS
333:   # See https://github.com/cli/cli#installation for other platforms
334: 
335:   # Authenticate
336:   gh auth login
337: 
338:   # Verify
339:   gh --version
340:   ```
341: 
342: ## Best Practices
343: 
344: ### Commit Workflow
345: ```bash
346: # 1. Make changes
347: 
348: # 2. Stage changes
349: git add src/auth/login.js
350: 
351: # 3. Review what's staged
352: git diff --staged
353: 
354: # 4. Create commit
355: /git commit
356: 
357: # 5. Review generated message
358: 
359: # 6. Push when ready
360: git push
361: ```
362: 
363: ### Pull Request Workflow
364: ```bash
365: # 1. Ensure branch is up to date
366: git fetch origin
367: git rebase origin/main
368: 
369: # 2. Run tests
370: /run npm test
371: 
372: # 3. Review code
373: /review
374: 
375: # 4. Fix issues
376: /fix review
377: 
378: # 5. Commit changes
379: /git commit
380: 
381: # 6. Create PR
382: /git pr
383: 
384: # 7. Address review feedback
385: # (make changes, commit, push)
386: ```
387: 
388: ### Issue Workflow
389: ```bash
390: # Report bug
391: /git issue "Bug: User login fails on Firefox" --label bug
392: 
393: # Track feature
394: /git issue "Feature: Add OAuth support" --label enhancement
395: 
396: # Link PR to issue
397: /git pr "Fixes #123: Add Firefox compatibility"
398: 
399: # Close when done
400: /git issue --close 123
401: ```
402: 
403: ## Examples
404: 
405: ### Example 1: Feature Development
406: ```bash
407: # Create feature branch
408: git checkout -b feature/oauth-login
409: 
410: # Develop feature
411: # (write code)
412: 
413: # Review code
414: /review src/auth
415: 
416: # Fix issues
417: /fix review
418: 
419: # Run tests
420: /run npm test
421: 
422: # Commit
423: /git commit
424: # Generates: "feat: Add OAuth login support"
425: 
426: # Create PR
427: /git pr
428: # Creates comprehensive PR with summary and test plan
429: ```
430: 
431: ### Example 2: Bug Fix
432: ```bash
433: # Create issue
434: /git issue "Bug: Memory leak in data processing" --label bug
435: 
436: # Create branch
437: git checkout -b fix/memory-leak
438: 
439: # Fix bug
440: # (write code)
441: 
442: # Test fix
443: /run npm test
444: 
445: # Commit
446: /git commit
447: # Generates: "fix: Resolve memory leak in data processing"
448: 
449: # Create PR linking to issue
450: /git pr "Fixes #456: Memory leak in data processing"
451: ```
452: 
453: ### Example 3: Integrated Workflow
454: ```bash
455: # Use workflow plugin
456: /explore "Add user authentication"
457: /plan
458: /next  # Implement tasks
459: /next
460: /next
461: 
462: # Ship with git integration
463: /ship --pr
464: # Automatically:
465: # - Reviews code
466: # - Runs tests
467: # - Creates commit with /git commit
468: # - Creates PR with /git pr
469: # - Returns PR URL
470: ```
471: 
472: ## Troubleshooting
473: 
474: ### /git commit fails
475: **Issue**: "Nothing to commit"
476: - **Solution**: Stage changes with `git add` first
477: 
478: **Issue**: "Pre-commit hook failed"
479: - **Solution**: Fix issues identified by hook, or use `git commit --no-verify` (not recommended)
480: 
481: **Issue**: "Author mismatch on amend"
482: - **Solution**: Don't amend others' commits; create new commit instead
483: 
484: ### /git pr fails
485: **Issue**: "gh: command not found"
486: - **Solution**: Install GitHub CLI: `brew install gh`
487: 
488: **Issue**: "gh: not authenticated"
489: - **Solution**: Run `gh auth login` and follow prompts
490: 
491: **Issue**: "No commits on branch"
492: - **Solution**: Ensure you've committed changes on current branch
493: 
494: **Issue**: "Branch not pushed"
495: - **Solution**: Plugin will auto-push, or run `git push -u origin branch-name`
496: 
497: ### Commit message not generated
498: **Issue**: Git status not showing changes
499: - **Solution**: Verify changes exist with `git status` and stage with `git add`
500: 
501: **Issue**: Recent commit history unavailable
502: - **Solution**: Initialize git history, or provide custom message with `-m`
503: 
504: ## Advanced Usage
505: 
506: ### Amending Commits Safely
507: ```bash
508: # Only amend if:
509: # 1. You authored the commit
510: # 2. Commit not pushed to shared branch
511: 
512: /git commit --amend
513: 
514: # Plugin checks:
515: # - Author matches current user
516: # - Commit not on origin (or ahead of origin)
517: # - Confirms safe to amend
518: ```
519: 
520: ### Custom Commit Messages
521: ```bash
522: # Override AI generation
523: /git commit -m "fix: Resolve Safari compatibility issue
524: 
525: Fixes rendering bug on Safari 16+ by updating CSS Grid usage.
526: 
527: Fixes #123"
528: ```
529: 
530: ### Draft Pull Requests
531: ```bash
532: # Create draft PR for early feedback
533: /git pr --draft
534: 
535: # Benefits:
536: # - Signals "work in progress"
537: # - Prevents accidental merge
538: # - Allows early review/discussion
539: ```
540: 
541: ### Target Different Base Branch
542: ```bash
543: # PR to develop instead of main
544: /git pr --base develop
545: 
546: # PR to release branch
547: /git pr --base release/v2.0
548: ```
549: 
550: ## Metrics and Quality
551: 
552: The git plugin tracks:
553: - **Commit frequency**: Commits per day/week
554: - **Commit size**: Lines changed per commit
555: - **PR quality**: Summary completeness, test plan coverage
556: - **Attribution**: Claude Code usage in commits
557: 
558: View with:
559: ```bash
560: /status verbose
561: /performance
562: ```
563: 
564: ## Support
565: 
566: - **Documentation**: [Git Workflow Guide](../../docs/guides/git-workflow.md)
567: - **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
568: - **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
569: 
570: ## Related Resources
571: 
572: - [Conventional Commits](https://www.conventionalcommits.org/)
573: - [GitHub CLI Documentation](https://cli.github.com/manual/)
574: - [Git Best Practices](https://git-scm.com/book/en/v2)
575: 
576: ## License
577: 
578: MIT License - see [LICENSE](../../LICENSE) for details.
579: 
580: ---
581: 
582: **Version**: 1.0.0
583: **Category**: Tools
584: **System Requirements**: git (2.0.0+), gh CLI (optional)
585: **Dependencies**: core (^1.0.0)
586: **MCP Tools**: None
````

## File: plugins/memory/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "claude-code-memory",
 3:   "version": "1.0.0",
 4:   "description": "Active memory management and maintenance for Claude Code framework",
 5:   "author": "Claude Code Framework",
 6:   "keywords": ["memory", "maintenance", "context", "management"],
 7:   "commands": ["commands/*.md"],
 8:   "settings": {
 9:     "defaultEnabled": true,
10:     "category": "core"
11:   },
12:   "repository": {
13:     "type": "git",
14:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
15:   },
16:   "license": "MIT",
17:   "capabilities": {
18:     "memoryReview": {
19:       "description": "Display current memory state with timestamps and sizes",
20:       "command": "memory-review"
21:     },
22:     "memoryUpdate": {
23:       "description": "Interactive memory maintenance with add/update/remove/relocate operations",
24:       "command": "memory-update"
25:     },
26:     "memoryGarbageCollection": {
27:       "description": "Identify and clean up stale memory entries",
28:       "command": "memory-gc"
29:     },
30:     "autoReflection": {
31:       "description": "Auto-analyze work for memory updates at completion points",
32:       "integrated": "ship, fix, review commands"
33:     }
34:   },
35:   "dependencies": {},
36:   "mcpTools": {
37:     "optional": ["sequential-thinking"],
38:     "gracefulDegradation": true
39:   }
40: }
````

## File: plugins/memory/README.md
````markdown
  1: # Memory Plugin
  2: 
  3: Active memory management and maintenance for Claude Code framework. Keep project context fresh, organized, and relevant.
  4: 
  5: ## Overview
  6: 
  7: The Memory plugin provides tools to manage Claude Code's persistent memory system. It helps you review memory state, update memory files interactively, and clean up stale entries. This ensures Claude maintains accurate, relevant context across sessions while avoiding outdated information.
  8: 
  9: ## Memory System
 10: 
 11: Claude Code uses a file-based memory system located in `.claude/memory/`:
 12: 
 13: ```
 14: .claude/memory/
 15: ├── project_state.md       # Current project status and structure
 16: ├── decisions.md           # Architectural and design decisions
 17: ├── lessons_learned.md     # Insights and patterns discovered
 18: ├── conventions.md         # Code style and naming conventions
 19: ├── dependencies.md        # External libraries and tools
 20: └── [domain-specific].md   # Custom memory files
 21: ```
 22: 
 23: **How it works**:
 24: - Memory files are **loaded into every Claude Code session**
 25: - Files use **@import syntax** for modular organization
 26: - Content should be **concise, current, and actionable**
 27: - Stale information **degrades Claude's effectiveness**
 28: 
 29: ## Features
 30: 
 31: - **Memory Review**: Inspect current memory state with metadata
 32: - **Interactive Updates**: Add, update, remove, or relocate memory entries
 33: - **Garbage Collection**: Identify and clean stale entries automatically
 34: - **Auto-Reflection**: Suggest memory updates at task completion
 35: - **Context Optimization**: Keep memory lean and relevant
 36: 
 37: ## Commands
 38: 
 39: ### `/memory-review`
 40: Display current memory state with timestamps, sizes, and staleness indicators.
 41: 
 42: **What it does**:
 43: - Lists all memory files in `.claude/memory/`
 44: - Shows file sizes and line counts
 45: - Displays last modified timestamps
 46: - Identifies stale entries (>30 days old)
 47: - Calculates total memory usage
 48: - Highlights optimization opportunities
 49: 
 50: **Usage**:
 51: ```bash
 52: /memory-review              # Review all memory files
 53: ```
 54: 
 55: **Output Example**:
 56: ```
 57: Memory Files Review
 58: ===================
 59: 
 60: project_state.md
 61:   Size: 3.2 KB (82 lines)
 62:   Modified: 2 days ago
 63:   Status: ✅ Current
 64: 
 65: decisions.md
 66:   Size: 5.4 KB (148 lines)
 67:   Modified: 1 week ago
 68:   Status: ✅ Current
 69: 
 70: lessons_learned.md
 71:   Size: 8.1 KB (210 lines)
 72:   Modified: 45 days ago
 73:   Status: ⚠️  Stale (consider reviewing)
 74: 
 75: conventions.md
 76:   Size: 1.8 KB (52 lines)
 77:   Modified: 3 days ago
 78:   Status: ✅ Current
 79: 
 80: ---
 81: Total Memory: 18.5 KB (492 lines)
 82: Stale Files: 1
 83: Recommendation: Review lessons_learned.md
 84: ```
 85: 
 86: **When to use**:
 87: - ✅ Before starting new work (check current context)
 88: - ✅ After long breaks (verify memory is current)
 89: - ✅ When context feels off (audit memory state)
 90: - ✅ Before /memory-gc (see what will be cleaned)
 91: - ✅ Regular maintenance (monthly review)
 92: 
 93: ### `/memory-update`
 94: Interactive memory maintenance with add, update, remove, and relocate operations.
 95: 
 96: **What it does**:
 97: - Guides you through memory update workflow
 98: - Suggests updates based on recent work
 99: - Adds new knowledge to appropriate files
100: - Updates existing entries
101: - Removes outdated information
102: - Reorganizes memory structure
103: 
104: **Usage**:
105: ```bash
106: /memory-update              # Interactive memory update workflow
107: ```
108: 
109: **Workflow**:
110: 1. **Review Recent Work**: Analyzes recent commits, completions, decisions
111: 2. **Suggest Updates**: Proposes memory additions/updates
112: 3. **Interactive Editing**:
113:    - Add new entries
114:    - Update existing entries
115:    - Remove outdated entries
116:    - Relocate entries to better files
117: 4. **Apply Changes**: Updates memory files
118: 5. **Verify**: Shows what changed
119: 
120: **Operations**:
121: 
122: **Add New Entry**:
123: ```bash
124: /memory-update
125: > Operation: add
126: > File: decisions.md
127: > Entry: "Use PostgreSQL for data persistence (MongoDB too complex for our use case)"
128: ```
129: 
130: **Update Existing Entry**:
131: ```bash
132: /memory-update
133: > Operation: update
134: > File: dependencies.md
135: > Find: "React 17.0.2"
136: > Replace: "React 18.2.0 (upgraded for concurrent features)"
137: ```
138: 
139: **Remove Outdated Entry**:
140: ```bash
141: /memory-update
142: > Operation: remove
143: > File: lessons_learned.md
144: > Entry: "Initial SQLite approach was too slow (replaced with PostgreSQL)"
145: ```
146: 
147: **Relocate Entry**:
148: ```bash
149: /memory-update
150: > Operation: relocate
151: > From: lessons_learned.md
152: > To: decisions.md
153: > Entry: "GraphQL adoption decision"
154: > Reason: "More appropriate in decisions.md"
155: ```
156: 
157: **When to use**:
158: - ✅ After completing major feature (/ship auto-suggests)
159: - ✅ After making architectural decision
160: - ✅ After discovering important lesson
161: - ✅ After changing dependencies/conventions
162: - ✅ When /memory-review shows missing context
163: 
164: ### `/memory-gc`
165: Garbage collection for stale memory entries - identify and clean up obsolete content.
166: 
167: **What it does**:
168: - Scans all memory files for stale entries
169: - Identifies information >30 days old with no recent references
170: - Detects superseded decisions
171: - Finds completed temporary tasks
172: - Proposes removals with rationale
173: - Optionally auto-cleans with confirmation
174: 
175: **Usage**:
176: ```bash
177: /memory-gc                  # Analyze and suggest cleanup
178: /memory-gc --auto           # Auto-clean with confirmation
179: /memory-gc --dry-run        # Show what would be cleaned (no changes)
180: ```
181: 
182: **Staleness Criteria**:
183: - **>30 days**: No modification in last month
184: - **Superseded**: Newer decision contradicts old one
185: - **Completed**: Task/work unit finished
186: - **Irrelevant**: Context no longer applicable
187: - **Redundant**: Duplicate information
188: 
189: **Output Example**:
190: ```
191: Memory Garbage Collection
192: =========================
193: 
194: Stale Entries Found: 8
195: 
196: decisions.md
197:   ⚠️  "Use MongoDB for persistence" (45 days old)
198:       Superseded by: "Use PostgreSQL" (2 days ago)
199:       Recommendation: Remove
200: 
201: lessons_learned.md
202:   ⚠️  "TypeScript strict mode causes too many issues" (60 days old)
203:       Status: No longer relevant (now using strict mode successfully)
204:       Recommendation: Remove or update
205: 
206:   ⚠️  "Initial API design with REST" (90 days old)
207:       Superseded by: "GraphQL adoption" (10 days ago)
208:       Recommendation: Archive
209: 
210: ---
211: Suggested Removals: 3
212: Suggested Updates: 2
213: Suggested Archives: 3
214: 
215: Apply changes? [y/N]
216: ```
217: 
218: **Safety Features**:
219: - Shows what will be removed before doing it
220: - Requires confirmation for destructive operations
221: - Backs up before cleanup (`.claude/memory/.backup/`)
222: - Dry-run mode for safe preview
223: 
224: **When to use**:
225: - ✅ Monthly maintenance routine
226: - ✅ Before major milestones (keep memory lean)
227: - ✅ When memory grows >20KB (optimize)
228: - ✅ After pivots or major changes (clean old context)
229: - ✅ When Claude references outdated info
230: 
231: ## Auto-Reflection
232: 
233: The memory plugin integrates with other commands to suggest updates automatically:
234: 
235: **After /ship**:
236: ```
237: Feature shipped: User authentication
238: 
239: Memory Update Suggestions:
240: 1. Add to decisions.md:
241:    "Use JWT for authentication (bcrypt for password hashing)"
242: 
243: 2. Add to lessons_learned.md:
244:    "Pre-hashing passwords before validation improves security"
245: 
246: 3. Update dependencies.md:
247:    "Added: jsonwebtoken v9.0.0, bcrypt v5.1.0"
248: 
249: Run /memory-update to apply? [y/N]
250: ```
251: 
252: **After /fix**:
253: ```
254: Fixed: Memory leak in data processing
255: 
256: Memory Update Suggestion:
257: Add to lessons_learned.md:
258: "Large datasets must be processed in streams, not loaded entirely into memory"
259: 
260: Run /memory-update to apply? [y/N]
261: ```
262: 
263: **After /review**:
264: ```
265: Code review completed: Found 12 issues
266: 
267: Memory Update Suggestion:
268: Add to conventions.md:
269: "Always validate input before processing (3 validation issues found today)"
270: 
271: Run /memory-update to apply? [y/N]
272: ```
273: 
274: ## Memory File Guidelines
275: 
276: ### project_state.md
277: **Purpose**: Current project status and structure
278: **Update Frequency**: Weekly or at major milestones
279: **Contents**:
280: - Project overview
281: - Current phase/status
282: - Active work units
283: - Key metrics
284: - Recent changes
285: 
286: **Example**:
287: ```markdown
288: # Project State
289: 
290: ## Overview
291: Building user authentication system for SaaS platform.
292: 
293: ## Current Status
294: Phase: Implementation (Week 3 of 4)
295: Active Work: OAuth integration
296: Tests: 87% coverage
297: 
298: ## Structure
299: - `/src/auth` - Authentication modules
300: - `/src/users` - User management
301: - `/tests/integration` - Integration tests
302: 
303: ## Recent Changes
304: - 2024-10-15: Migrated from MongoDB to PostgreSQL
305: - 2024-10-12: Added JWT authentication
306: ```
307: 
308: ### decisions.md
309: **Purpose**: Architectural and design decisions
310: **Update Frequency**: When making decisions
311: **Contents**:
312: - Technology choices
313: - Architecture patterns
314: - Design tradeoffs
315: - Rationale for decisions
316: 
317: **Example**:
318: ```markdown
319: # Architectural Decisions
320: 
321: ## Database: PostgreSQL
322: **Decision**: Use PostgreSQL instead of MongoDB
323: **Rationale**:
324: - Need ACID transactions
325: - Complex relational data
326: - Team expertise in SQL
327: **Date**: 2024-10-15
328: 
329: ## Authentication: JWT
330: **Decision**: JWT-based authentication
331: **Rationale**:
332: - Stateless (scales better)
333: - Standard format
334: - Easy client integration
335: **Date**: 2024-10-12
336: ```
337: 
338: ### lessons_learned.md
339: **Purpose**: Insights and patterns discovered
340: **Update Frequency**: When learning something valuable
341: **Contents**:
342: - Mistakes and solutions
343: - Performance insights
344: - Best practices discovered
345: - "Next time" notes
346: 
347: **Example**:
348: ```markdown
349: # Lessons Learned
350: 
351: ## Stream Large Datasets
352: **Context**: Processing 10GB CSV files
353: **Problem**: Loading entire file into memory caused crashes
354: **Solution**: Use streaming with 100MB chunks
355: **Lesson**: Always stream data >1GB
356: **Date**: 2024-10-10
357: 
358: ## Pre-hash Passwords
359: **Context**: User authentication implementation
360: **Problem**: Hashing during validation was slow
361: **Solution**: Hash passwords before storing
362: **Lesson**: Expensive operations should happen once
363: **Date**: 2024-10-12
364: ```
365: 
366: ### conventions.md
367: **Purpose**: Code style and naming conventions
368: **Update Frequency**: When establishing patterns
369: **Contents**:
370: - Naming conventions
371: - Code style rules
372: - File organization
373: - Testing patterns
374: 
375: **Example**:
376: ```markdown
377: # Conventions
378: 
379: ## Naming
380: - **Files**: kebab-case (user-service.js)
381: - **Classes**: PascalCase (UserService)
382: - **Functions**: camelCase (getUserById)
383: - **Constants**: UPPER_SNAKE (MAX_RETRIES)
384: 
385: ## Testing
386: - Test files: `*.test.js`
387: - One describe block per function
388: - Test structure: Arrange, Act, Assert
389: - Coverage target: >80%
390: 
391: ## File Organization
392: - One class per file
393: - Max 300 lines per file
394: - Group related functions
395: ```
396: 
397: ### dependencies.md
398: **Purpose**: External libraries and tools
399: **Update Frequency**: When adding/updating dependencies
400: **Contents**:
401: - Libraries and versions
402: - CLI tools
403: - Services/APIs
404: - Configuration requirements
405: 
406: **Example**:
407: ```markdown
408: # Dependencies
409: 
410: ## Core Libraries
411: - **express**: 4.18.2 (Web framework)
412: - **postgresql**: 14.5 (Database)
413: - **jsonwebtoken**: 9.0.0 (Authentication)
414: - **bcrypt**: 5.1.0 (Password hashing)
415: 
416: ## Development Tools
417: - **jest**: 29.3.1 (Testing)
418: - **eslint**: 8.28.0 (Linting)
419: - **prettier**: 2.8.0 (Formatting)
420: 
421: ## Services
422: - **GitHub**: Code hosting
423: - **AWS RDS**: PostgreSQL hosting
424: - **Sentry**: Error monitoring
425: ```
426: 
427: ## Best Practices
428: 
429: ### Do
430: - ✅ Update memory after significant work
431: - ✅ Keep entries concise (2-4 lines max)
432: - ✅ Date important decisions
433: - ✅ Remove outdated information
434: - ✅ Run /memory-gc monthly
435: - ✅ Review memory before starting work
436: 
437: ### Don't
438: - ❌ Copy entire code snippets (link instead)
439: - ❌ Document temporary decisions
440: - ❌ Keep superseded information
441: - ❌ Let memory grow >25KB
442: - ❌ Forget to update after major changes
443: 
444: ### Optimization Tips
445: 
446: 1. **Keep It Lean**: Target <20KB total memory
447: 2. **Be Specific**: "Use PostgreSQL" > "Consider different databases"
448: 3. **Date Decisions**: Helps identify stale entries
449: 4. **One Topic Per Entry**: Easier to update/remove
450: 5. **Link, Don't Copy**: Reference code/docs instead of duplicating
451: 
452: ## Integration with Other Plugins
453: 
454: ### Workflow Plugin
455: **Auto-reflection points**:
456: - `/explore complete`: Suggest project_state update
457: - `/plan created`: Suggest decisions.md entries
458: - `/ship complete`: Prompt for lessons_learned
459: 
460: ### Development Plugin
461: **Auto-reflection points**:
462: - `/review complete`: Suggest conventions updates
463: - `/fix applied`: Prompt for lessons_learned
464: - `/test coverage`: Update quality metrics
465: 
466: ### Core Plugin
467: - `/handoff` includes memory review
468: - `/status` shows memory state
469: - `/cleanup` can archive old memory
470: 
471: ## Configuration
472: 
473: ### Memory Settings (`.claude/config.json`)
474: ```json
475: {
476:   "memory": {
477:     "autoReflection": true,
478:     "staleThresholdDays": 30,
479:     "maxMemorySizeKB": 25,
480:     "autoBackup": true,
481:     "gcFrequency": "monthly"
482:   }
483: }
484: ```
485: 
486: ### Auto-Reflection Triggers
487: ```json
488: {
489:   "memory": {
490:     "reflectionTriggers": {
491:       "ship": true,
492:       "fix": true,
493:       "review": true,
494:       "explore": false
495:     }
496:   }
497: }
498: ```
499: 
500: ### GC Settings
501: ```json
502: {
503:   "memory": {
504:     "gc": {
505:       "autoClean": false,
506:       "requireConfirmation": true,
507:       "createBackup": true,
508:       "staleThresholdDays": 30
509:     }
510:   }
511: }
512: ```
513: 
514: ## Dependencies
515: 
516: ### Required
517: None - Memory plugin is standalone
518: 
519: ### Optional MCP Tools
520: - **Sequential Thinking**: Enhances memory analysis and suggestions
521: 
522: **Graceful Degradation**: All commands work without MCP tools.
523: 
524: ## Metrics
525: 
526: The memory plugin tracks:
527: - **Memory size**: Total KB across all files
528: - **File count**: Number of memory files
529: - **Update frequency**: How often memory is updated
530: - **Stale entries**: Count of entries >30 days old
531: - **GC statistics**: Entries removed, size freed
532: 
533: View with:
534: ```bash
535: /memory-review
536: /status verbose
537: ```
538: 
539: ## Troubleshooting
540: 
541: ### Memory files not loading
542: - **Check location**: Files must be in `.claude/memory/`
543: - **Check syntax**: Valid markdown required
544: - **Check permissions**: Files must be readable
545: 
546: ### /memory-gc removes too much
547: - **Adjust threshold**: Increase `staleThresholdDays` in config
548: - **Use --dry-run**: Preview before actual cleanup
549: - **Manual review**: Review suggestions before confirming
550: 
551: ### Memory growing too large
552: - **Run /memory-gc**: Clean stale entries
553: - **Remove code snippets**: Link instead of copying
554: - **Archive old content**: Move to `.claude/archives/`
555: - **Split files**: Break large files into focused ones
556: 
557: ### Auto-reflection not working
558: - **Check config**: Verify `autoReflection: true`
559: - **Check triggers**: Ensure command triggers are enabled
560: - **Manual update**: Use `/memory-update` directly
561: 
562: ## Examples
563: 
564: ### Example 1: New Project Setup
565: ```bash
566: # Review current memory (likely empty)
567: /memory-review
568: 
569: # Add initial project state
570: /memory-update
571: > add project_state.md
572: > "New SaaS authentication project, using Node.js + PostgreSQL"
573: 
574: # Document initial decisions
575: /memory-update
576: > add decisions.md
577: > "Technology stack: Node.js, Express, PostgreSQL, JWT"
578: ```
579: 
580: ### Example 2: After Feature Completion
581: ```bash
582: # Ship feature
583: /ship --pr
584: 
585: # Auto-reflection suggests updates
586: Memory Update Suggestions:
587: 1. Add decision: "Use JWT for authentication"
588: 2. Add lesson: "Pre-hash passwords for performance"
589: 
590: # Apply suggestions
591: /memory-update
592: > (apply suggestions)
593: 
594: # Review updated state
595: /memory-review
596: ```
597: 
598: ### Example 3: Monthly Maintenance
599: ```bash
600: # Review current state
601: /memory-review
602: # Shows: lessons_learned.md is 45 days old
603: 
604: # Run garbage collection
605: /memory-gc --dry-run
606: # Shows: 5 stale entries found
607: 
608: # Apply cleanup
609: /memory-gc
610: > Confirm cleanup? y
611: 
612: # Verify
613: /memory-review
614: # Shows: Memory optimized, all files current
615: ```
616: 
617: ## Support
618: 
619: - **Documentation**: [Memory Management Guide](../../docs/guides/memory-management.md)
620: - **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
621: - **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
622: 
623: ## License
624: 
625: MIT License - see [LICENSE](../../LICENSE) for details.
626: 
627: ---
628: 
629: **Version**: 1.0.0
630: **Category**: Core
631: **Commands**: 3 (memory-review, memory-update, memory-gc)
632: **Dependencies**: None
633: **MCP Tools**: Optional (sequential-thinking)
````

## File: plugins/workflow/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "claude-code-workflow",
 3:   "version": "1.0.0",
 4:   "description": "Structured development workflow - explore, plan, implement, deliver",
 5:   "author": "Claude Code Framework",
 6:   "keywords": ["workflow", "explore", "plan", "next", "ship"],
 7:   "commands": ["commands/*.md"],
 8:   "settings": {
 9:     "defaultEnabled": true,
10:     "category": "workflow"
11:   },
12:   "repository": {
13:     "type": "git",
14:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
15:   },
16:   "license": "MIT",
17:   "capabilities": {
18:     "requirementExploration": {
19:       "description": "Explore requirements and codebase with systematic analysis",
20:       "command": "explore"
21:     },
22:     "implementationPlanning": {
23:       "description": "Create detailed implementation plan with ordered tasks and dependencies",
24:       "command": "plan"
25:     },
26:     "taskExecution": {
27:       "description": "Execute next available task from implementation plan",
28:       "command": "next"
29:     },
30:     "workDelivery": {
31:       "description": "Deliver completed work with validation and comprehensive documentation",
32:       "command": "ship"
33:     }
34:   },
35:   "dependencies": {
36:     "claude-code-core": "^1.0.0",
37:     "claude-code-memory": "^1.0.0"
38:   },
39:   "mcpTools": {
40:     "optional": ["sequential-thinking", "serena", "firecrawl"],
41:     "gracefulDegradation": true
42:   },
43:   "integrations": {
44:     "memory": {
45:       "description": "Auto-loads memory context via @imports",
46:       "files": ["decisions.md", "lessons_learned.md", "project_state.md", "conventions.md", "dependencies.md"]
47:     },
48:     "workUnits": {
49:       "description": "Integrated with work unit management",
50:       "directory": ".claude/work/current/"
51:     }
52:   }
53: }
````

## File: plugins/workflow/.claude-plugin/README.md
````markdown
  1: # Claude Code Workflow Plugin
  2: 
  3: **Version**: 1.0.0
  4: **Category**: Workflow
  5: **Author**: Claude Code Framework
  6: 
  7: ## Overview
  8: 
  9: The Workflow Plugin provides a structured four-phase development cycle: **Explore → Plan → Implement → Deliver**. This systematic approach ensures thorough understanding, careful planning, tracked execution, and validated delivery.
 10: 
 11: ## The Four-Phase Workflow
 12: 
 13: ```
 14: ┌─────────┐     ┌──────┐     ┌──────┐     ┌──────┐
 15: │ EXPLORE │ --> │ PLAN │ --> │ NEXT │ --> │ SHIP │
 16: └─────────┘     └──────┘     └──────┘     └──────┘
 17: Understand      Design       Execute      Deliver
 18: ```
 19: 
 20: ## Commands
 21: 
 22: ### `/explore [source]`
 23: Explore requirements and codebase with systematic analysis before planning.
 24: 
 25: **Purpose**: Understand problem space, gather context, identify constraints
 26: 
 27: **Sources**:
 28: - `@file`: Explore from requirements document
 29: - `#issue`: Explore from GitHub issue
 30: - `description`: Explore from natural language description
 31: - `empty`: Interactive exploration through questions
 32: 
 33: **Usage**:
 34: ```bash
 35: /explore @requirements.md                    # From document
 36: /explore #123                                # From issue
 37: /explore "Add user authentication system"    # From description
 38: /explore                                     # Interactive mode
 39: ```
 40: 
 41: **Outputs**:
 42: - `exploration.md`: Comprehensive analysis
 43: - Domain understanding
 44: - Technical constraints
 45: - Risk assessment
 46: - Initial approach options
 47: 
 48: **MCP Enhancements**:
 49: - **Sequential Thinking**: Structured multi-step analysis
 50: - **Serena**: Semantic code understanding for codebase exploration
 51: - **Firecrawl**: Web research for external context
 52: 
 53: ---
 54: 
 55: ### `/plan [options]`
 56: Create detailed implementation plan with ordered tasks and dependencies.
 57: 
 58: **Purpose**: Break down work into manageable, ordered tasks with clear success criteria
 59: 
 60: **Options**:
 61: - `--from-requirements`: Plan from requirements document
 62: - `--from-issue #123`: Plan from GitHub issue
 63: - `description`: Plan from description
 64: 
 65: **Usage**:
 66: ```bash
 67: /plan                                        # From exploration
 68: /plan --from-requirements @requirements.md   # Skip exploration
 69: /plan --from-issue #456                      # From GitHub issue
 70: /plan "Refactor authentication module"       # Direct planning
 71: ```
 72: 
 73: **Outputs**:
 74: - `implementation-plan.md`: Detailed task breakdown
 75: - `state.json`: Task tracking state
 76: - Ordered tasks with dependencies
 77: - Estimated effort per task
 78: - Validation gates between phases
 79: 
 80: **MCP Enhancements**:
 81: - **Sequential Thinking**: Complex planning with dependencies
 82: - **Serena**: Code analysis for technical planning
 83: 
 84: ---
 85: 
 86: ### `/next [options]`
 87: Execute next available task from implementation plan.
 88: 
 89: **Purpose**: Systematic task execution with progress tracking
 90: 
 91: **Options**:
 92: - `--task TASK-ID`: Execute specific task
 93: - `--batch BATCH-ID`: Execute batch of parallel tasks
 94: - `--preview`: Preview next task without executing
 95: - `--status`: Show current progress
 96: 
 97: **Usage**:
 98: ```bash
 99: /next                                        # Execute next task
100: /next --task TASK-105                        # Specific task
101: /next --preview                              # Preview only
102: /next --status                               # Show progress
103: ```
104: 
105: **Behavior**:
106: - Loads active work unit state
107: - Identifies next available task
108: - Executes task with progress tracking
109: - Updates state.json automatically
110: - Creates task completion summary
111: - Prompts for validation at phase boundaries
112: 
113: **MCP Enhancements**:
114: - **Sequential Thinking**: Complex task reasoning
115: - **Serena**: Semantic code operations (70-90% token reduction)
116: 
117: ---
118: 
119: ### `/ship [options]`
120: Deliver completed work with validation and comprehensive documentation.
121: 
122: **Purpose**: Validate, document, and deliver completed work professionally
123: 
124: **Options**:
125: - `--preview`: Preview delivery without executing
126: - `--pr`: Create pull request
127: - `--commit`: Create commit only (no PR)
128: - `--deploy`: Deploy after delivery
129: 
130: **Usage**:
131: ```bash
132: /ship                                        # Full delivery workflow
133: /ship --preview                              # Preview without delivery
134: /ship --pr                                   # Create pull request
135: /ship --commit                               # Commit only
136: ```
137: 
138: **Delivery Phases**:
139: 
140: 1. **Work Completion Verification**: Ensure all tasks complete
141: 2. **Quality Validation**: Run tests, lint, type checking
142: 3. **Documentation Generation**: Create comprehensive docs
143: 4. **Git Operations**: Commit with proper attribution
144: 5. **Memory Reflection**: Capture learnings (NEW in v1.0.0)
145: 6. **Pull Request Creation**: Generate PR with detailed description
146: 7. **Work Unit Archival**: Clean up and archive
147: 8. **Success Communication**: Report delivery status
148: 
149: **Memory Reflection**: Automated analysis of work unit to extract:
150: - **Decisions**: Architectural choices and rationale
151: - **Lessons Learned**: What worked, what didn't
152: - **Conventions**: Standards established
153: - **Dependencies**: Tools and versions
154: - **Project State**: Architecture updates
155: 
156: **MCP Enhancements**:
157: - **Sequential Thinking**: Comprehensive validation reasoning
158: - **Serena**: Code analysis for quality checks
159: 
160: ## Workflow Integration
161: 
162: ### Memory System Integration
163: 
164: The workflow plugin automatically loads memory context:
165: 
166: **Auto-loaded Memory Files**:
167: - `decisions.md`: Architectural decisions
168: - `lessons_learned.md`: Project learnings
169: - `project_state.md`: Current system state
170: - `conventions.md`: Code standards
171: - `dependencies.md`: External dependencies
172: 
173: **Memory Updates**: `/ship` prompts to update memory with new learnings captured during work unit.
174: 
175: ### Work Unit Management
176: 
177: **Work Unit Structure**:
178: ```
179: .claude/work/current/[work-unit-id]/
180: ├── metadata.json              # Work unit metadata
181: ├── state.json                 # Task tracking state
182: ├── exploration.md             # From /explore
183: ├── implementation-plan.md     # From /plan
184: ├── [task_summaries]/          # From /next
185: └── COMPLETION_SUMMARY.md      # From /ship
186: ```
187: 
188: **State Tracking**: All workflow commands update `state.json` automatically for progress tracking.
189: 
190: ## Best Practices
191: 
192: ### Exploration Phase
193: - ✅ Always run `/explore` for non-trivial tasks
194: - ✅ Review exploration before planning
195: - ✅ Ask clarifying questions when uncertain
196: - ✅ Document constraints discovered
197: - ❌ Don't skip exploration for complex work
198: - ❌ Don't assume you understand requirements
199: 
200: ### Planning Phase
201: - ✅ Break work into small, testable tasks
202: - ✅ Identify dependencies explicitly
203: - ✅ Set clear success criteria
204: - ✅ Include validation gates
205: - ❌ Don't create monolithic tasks
206: - ❌ Don't plan implementation details upfront
207: 
208: ### Execution Phase
209: - ✅ Execute one task at a time (unless parallel)
210: - ✅ Create completion summaries per task
211: - ✅ Run validation at phase boundaries
212: - ✅ Adapt plan based on discoveries
213: - ❌ Don't skip tasks without updating plan
214: - ❌ Don't accumulate many changes without commits
215: 
216: ### Delivery Phase
217: - ✅ Run full validation before delivery
218: - ✅ Create comprehensive documentation
219: - ✅ Update memory with learnings
220: - ✅ Write clear commit messages
221: - ❌ Don't skip quality checks
222: - ❌ Don't forget to capture learnings
223: 
224: ## Configuration
225: 
226: ### Plugin Settings
227: 
228: ```json
229: {
230:   "settings": {
231:     "defaultEnabled": true,
232:     "category": "workflow"
233:   }
234: }
235: ```
236: 
237: ### Dependencies
238: 
239: ```json
240: {
241:   "dependencies": {
242:     "claude-code-core": "^1.0.0",
243:     "claude-code-memory": "^1.0.0"
244:   }
245: }
246: ```
247: 
248: **Required Plugins**:
249: - `core`: Work management, status, handoff
250: - `memory`: Context persistence and reflection
251: 
252: ### MCP Tools
253: 
254: **Optional** (with graceful degradation):
255: - `sequential-thinking`: Enhanced reasoning for exploration and planning
256: - `serena`: Semantic code understanding for implementation
257: - `firecrawl`: Web research for external context
258: 
259: ## Workflow Examples
260: 
261: ### Example 1: Feature Development
262: 
263: ```bash
264: # Phase 1: Explore
265: /explore "Add OAuth2 authentication support"
266: # Review exploration.md, ask questions
267: 
268: # Phase 2: Plan
269: /plan
270: # Review implementation-plan.md, adjust if needed
271: 
272: # Phase 3: Execute
273: /next                    # Task 1: Research OAuth2 libraries
274: /next                    # Task 2: Design auth flow
275: /next                    # Task 3: Implement authentication
276: /next                    # Task 4: Add tests
277: # Validation gate: Test coverage >80%
278: 
279: /next                    # Task 5: Integration testing
280: /next                    # Task 6: Documentation
281: 
282: # Phase 4: Deliver
283: /ship --pr              # Create pull request with full docs
284: ```
285: 
286: ### Example 2: Bug Fix
287: 
288: ```bash
289: # Phase 1: Explore
290: /explore #789           # From GitHub issue
291: # Understand bug, identify root cause
292: 
293: # Phase 2: Plan
294: /plan --from-issue #789
295: # Break down fix into tasks
296: 
297: # Phase 3: Execute
298: /next                   # Task 1: Add failing test
299: /next                   # Task 2: Fix bug
300: /next                   # Task 3: Verify fix
301: 
302: # Phase 4: Deliver
303: /ship --commit          # Commit fix (no PR needed)
304: ```
305: 
306: ### Example 3: Refactoring
307: 
308: ```bash
309: # Phase 1: Explore
310: /explore @refactoring-proposal.md
311: # Understand scope and risks
312: 
313: # Phase 2: Plan
314: /plan
315: # Identify safe refactoring steps
316: 
317: # Phase 3: Execute (with parallel tasks)
318: /next --task TASK-101   # Refactor module A
319: /next --task TASK-102   # Refactor module B (parallel)
320: /next                   # Integration after parallel work
321: /next                   # Update tests
322: 
323: # Phase 4: Deliver
324: /ship --preview         # Preview first
325: /ship --pr              # Create PR after preview
326: ```
327: 
328: ## Advanced Features
329: 
330: ### Parallel Task Execution
331: 
332: When tasks are independent, `/next` can execute them in parallel:
333: 
334: ```bash
335: # Plan creates parallel tasks
336: # Batch 1.1: TASK-101, TASK-102 (parallel)
337: # Batch 1.2: TASK-103 (depends on 1.1)
338: 
339: /next --task TASK-101 /next --task TASK-102   # Execute in parallel
340: /next                                          # Execute TASK-103 after
341: ```
342: 
343: ### Adaptive Planning
344: 
345: Plans can be adapted during execution:
346: 
347: ```bash
348: /next                   # Discover new constraint during task
349: # Update implementation-plan.md
350: /next                   # Continue with updated plan
351: ```
352: 
353: ### Validation Gates
354: 
355: Validation gates ensure quality between phases:
356: 
357: ```bash
358: /next                   # Complete batch
359: # Validation gate: Run tests
360: # If validation fails, fix issues before continuing
361: /next                   # Continue after validation passes
362: ```
363: 
364: ### Work Unit Switching
365: 
366: Support for parallel work streams:
367: 
368: ```bash
369: /work switch 002        # Switch to different work unit
370: /next                   # Execute task in unit 002
371: /work switch 001        # Switch back to unit 001
372: /next                   # Continue unit 001
373: ```
374: 
375: ## Troubleshooting
376: 
377: ### Exploration Not Found
378: 
379: **Symptom**: `/plan` shows "No exploration found"
380: 
381: **Solution**: Run `/explore` first or use `--from-requirements`:
382: ```bash
383: /explore                                     # Create exploration
384: /plan                                        # Now works
385: # OR
386: /plan --from-requirements @requirements.md   # Skip exploration
387: ```
388: 
389: ### Task State Corruption
390: 
391: **Symptom**: `/next` shows incorrect next task
392: 
393: **Solution**: Review `state.json` and fix manually:
394: ```bash
395: cat .claude/work/current/*/state.json       # Review state
396: # Edit state.json to fix
397: /next --status                              # Verify fix
398: ```
399: 
400: ### Memory Not Loading
401: 
402: **Symptom**: `/ship` doesn't show memory integration
403: 
404: **Solution**: Verify memory plugin enabled:
405: ```bash
406: /config plugin status claude-code-memory
407: /config plugin enable claude-code-memory    # If disabled
408: ```
409: 
410: ### Ship Validation Fails
411: 
412: **Symptom**: `/ship` stops at validation phase
413: 
414: **Solution**: Fix validation issues first:
415: ```bash
416: /ship --preview                             # See what will be validated
417: # Fix issues (tests, lint, etc.)
418: /ship                                       # Retry after fixes
419: ```
420: 
421: ## Performance
422: 
423: ### Token Efficiency
424: 
425: - **With Serena**: 70-90% token reduction for code operations
426: - **With Sequential Thinking**: +15-30% tokens, +20-30% quality
427: - **Without MCP**: Standard performance, all features work
428: 
429: ### Recommended Limits
430: 
431: - **Tasks per phase**: 5-10 tasks (break into smaller phases if more)
432: - **Task size**: 1-4 hours each (split larger tasks)
433: - **Work unit duration**: 1-2 weeks (create new unit for longer work)
434: 
435: ## Version History
436: 
437: ### 1.0.0 (2025-10-11)
438: - Initial plugin release
439: - Four-phase workflow (explore, plan, next, ship)
440: - Memory system integration
441: - Work unit management
442: - Memory reflection in ship command
443: - Parallel task execution
444: - Validation gates
445: 
446: ## License
447: 
448: MIT License - See project LICENSE file
449: 
450: ## Related Plugins
451: 
452: - **core**: Required dependency for work and status
453: - **memory**: Required dependency for context persistence
454: - **development**: Integrates with /test, /fix, /review
455: - **git**: Integrates with /ship for commits and PRs
456: 
457: ---
458: 
459: **Note**: This plugin implements the recommended development workflow. For ad-hoc tasks, individual commands from other plugins can be used directly.
````

## File: plugins/workflow/README.md
````markdown
  1: # Workflow Plugin
  2: 
  3: Structured development workflow for systematic task completion - explore, plan, implement, and deliver.
  4: 
  5: ## Overview
  6: 
  7: The Workflow plugin provides a proven 4-phase development methodology for Claude Code. It guides you from initial requirements exploration through systematic planning, task execution, and final delivery. This workflow ensures thorough analysis, organized implementation, and quality delivery.
  8: 
  9: ## The 4-Phase Workflow
 10: 
 11: ```
 12: /explore → /plan → /next (repeat) → /ship
 13:    ↓         ↓          ↓             ↓
 14: Analyze   Design   Implement      Deliver
 15: ```
 16: 
 17: ### Phase 1: Explore
 18: Understand requirements, analyze codebase, identify constraints and opportunities.
 19: 
 20: ### Phase 2: Plan
 21: Create detailed implementation plan with ordered tasks, dependencies, and acceptance criteria.
 22: 
 23: ### Phase 3: Execute
 24: Implement tasks one at a time with /next, completing the plan systematically.
 25: 
 26: ### Phase 4: Deliver
 27: Ship completed work with validation, documentation, and quality assurance.
 28: 
 29: ## Commands
 30: 
 31: ### `/explore [source] [--work-unit ID]`
 32: Explore requirements and codebase with systematic analysis before planning. This is Anthropic's recommended first step for any significant task.
 33: 
 34: **What it does**:
 35: - Analyzes requirements from multiple sources (@file, #issue, description, or interactive)
 36: - Explores relevant codebase areas to understand context
 37: - Identifies constraints, dependencies, and risks
 38: - Documents findings for planning phase
 39: - Creates work unit for tracking
 40: 
 41: **Usage**:
 42: ```bash
 43: /explore                                    # Interactive exploration
 44: /explore "Add user authentication"          # From description
 45: /explore @requirements.md                   # From requirements doc
 46: /explore #123                               # From GitHub issue
 47: /explore --work-unit 001                    # Use existing work unit
 48: ```
 49: 
 50: **Thoroughness Levels**:
 51: - `quick`: Basic search and analysis (5-10 minutes)
 52: - `medium`: Moderate exploration with multiple angles (15-25 minutes)
 53: - `very thorough`: Comprehensive analysis across codebase (30-45 minutes)
 54: 
 55: **Output**:
 56: - `exploration.md`: Detailed findings and analysis
 57: - `metadata.json`: Work unit tracking information
 58: 
 59: **When to use**:
 60: - ✅ Starting any non-trivial feature or bug fix
 61: - ✅ Unclear requirements that need investigation
 62: - ✅ Unfamiliar codebase areas
 63: - ✅ Complex changes with many dependencies
 64: 
 65: **When to skip**:
 66: - ❌ Trivial changes (typo fixes, simple updates)
 67: - ❌ Very clear requirements in familiar code
 68: - ❌ Quick experiments or spikes
 69: 
 70: ### `/plan [--from-requirements | --from-issue #123 | description]`
 71: Create detailed implementation plan with ordered tasks and dependencies using structured reasoning.
 72: 
 73: **What it does**:
 74: - Reviews exploration findings (or analyzes requirements directly)
 75: - Breaks work into ordered, manageable tasks
 76: - Identifies dependencies and sequencing
 77: - Defines acceptance criteria for each task
 78: - Creates task tracking state file
 79: 
 80: **Usage**:
 81: ```bash
 82: /plan                                       # From latest /explore
 83: /plan --from-requirements @specs.md         # From requirements doc
 84: /plan --from-issue #123                     # From GitHub issue
 85: /plan "Implement OAuth login"               # From description
 86: ```
 87: 
 88: **Plan Structure**:
 89: - **Tasks**: Ordered list with IDs, descriptions, dependencies
 90: - **Dependencies**: Task relationships and sequencing
 91: - **Acceptance Criteria**: How to verify completion
 92: - **Risks**: Potential issues and mitigation strategies
 93: - **Estimates**: Rough time/complexity estimates
 94: 
 95: **Output**:
 96: - `implementation-plan.md`: Complete task breakdown
 97: - `state.json`: Task tracking state (pending, in_progress, completed)
 98: 
 99: **When to use**:
100: - ✅ After /explore for complex work
101: - ✅ Multi-step features requiring coordination
102: - ✅ Changes affecting multiple files/systems
103: - ✅ Work that will span multiple sessions
104: 
105: **When to skip**:
106: - ❌ Single-file, single-function changes
107: - ❌ Immediate fixes that are obvious
108: - ❌ Exploratory work without clear endpoint
109: 
110: ### `/next [--task TASK-ID | --preview | --status]`
111: Execute the next available task from the implementation plan.
112: 
113: **What it does**:
114: - Loads implementation plan and current state
115: - Identifies next task based on dependencies
116: - Executes the task completely
117: - Updates state.json automatically
118: - Moves to next task when ready
119: 
120: **Usage**:
121: ```bash
122: /next                                       # Execute next available task
123: /next --preview                             # Show what's next without executing
124: /next --status                              # Show plan progress
125: /next --task TASK-005                       # Execute specific task
126: ```
127: 
128: **Task Execution Flow**:
129: 1. Load plan and check dependencies
130: 2. Display current task details
131: 3. Execute implementation
132: 4. Verify completion against acceptance criteria
133: 5. Update state.json (pending → in_progress → completed)
134: 6. Show progress and next task
135: 
136: **States**:
137: - `pending`: Not yet started
138: - `in_progress`: Currently working on
139: - `completed`: Finished and verified
140: - `blocked`: Waiting on dependencies
141: 
142: **When to use**:
143: - ✅ Systematic implementation of planned work
144: - ✅ Multiple tasks that should be done in order
145: - ✅ Work that needs tracking across sessions
146: - ✅ Complex features with many steps
147: 
148: **Tips**:
149: - Run `/next --status` frequently to see progress
150: - Use `/next --preview` before starting if unsure
151: - Tasks complete in dependency order automatically
152: 
153: ### `/ship [--preview | --pr | --commit | --deploy]`
154: Deliver completed work with validation and comprehensive documentation.
155: 
156: **What it does**:
157: - Reviews completed implementation plan
158: - Validates all acceptance criteria met
159: - Runs tests and quality checks
160: - Creates comprehensive documentation
161: - Generates git commits or pull requests
162: - Produces delivery summary
163: 
164: **Usage**:
165: ```bash
166: /ship                                       # Full delivery workflow
167: /ship --preview                             # Preview what will be delivered
168: /ship --commit                              # Create git commit only
169: /ship --pr                                  # Create pull request
170: /ship --deploy                              # Prepare for deployment
171: ```
172: 
173: **Delivery Checklist**:
174: - ✅ All planned tasks completed
175: - ✅ Tests passing
176: - ✅ Code reviewed (self or automated)
177: - ✅ Documentation updated
178: - ✅ Breaking changes documented
179: - ✅ Migration guides (if needed)
180: 
181: **Output**:
182: - `COMPLETION_SUMMARY.md`: What was delivered and how to use it
183: - Git commit or pull request (if requested)
184: - Test results and quality metrics
185: - Deployment instructions (if applicable)
186: 
187: **When to use**:
188: - ✅ Implementation plan complete
189: - ✅ Feature ready for review/merge
190: - ✅ All acceptance criteria met
191: - ✅ Quality checks passed
192: 
193: **Options**:
194: - `--preview`: See what will be shipped without doing it
195: - `--commit`: Create git commit with generated message
196: - `--pr`: Create GitHub pull request with summary
197: - `--deploy`: Include deployment checklist and instructions
198: 
199: ## Complete Workflow Example
200: 
201: ### Example: Adding User Authentication
202: 
203: ```bash
204: # Phase 1: Explore
205: /explore "Add JWT-based authentication to API"
206: 
207: # Output: exploration.md with findings:
208: # - Existing auth middleware
209: # - JWT library already in dependencies
210: # - 3 endpoints need protection
211: # - User model needs password hashing
212: 
213: # Phase 2: Plan
214: /plan
215: 
216: # Output: implementation-plan.md with 6 tasks:
217: # TASK-001: Add password hashing to User model
218: # TASK-002: Create JWT token generation utilities
219: # TASK-003: Implement login endpoint
220: # TASK-004: Create auth middleware
221: # TASK-005: Protect existing endpoints
222: # TASK-006: Add integration tests
223: 
224: # Phase 3: Execute
225: /next --status
226: # Shows: TASK-001 ready, others pending
227: 
228: /next
229: # Implements TASK-001, updates state.json
230: 
231: /next
232: # Implements TASK-002 (dependency of TASK-001 complete)
233: 
234: /next
235: # ... continues through all tasks
236: 
237: # Phase 4: Deliver
238: /ship --pr
239: # Creates pull request with:
240: # - Summary of 6 completed tasks
241: # - Test results (all passing)
242: # - Breaking changes documentation
243: # - Migration guide for existing users
244: ```
245: 
246: ## Integration with Other Plugins
247: 
248: ### Core Plugin
249: - Uses `/status` to show plan progress
250: - Uses `/work` for work unit management
251: - Uses `/agent` for specialized exploration
252: 
253: ### Development Plugin
254: - `/test` runs during /ship validation
255: - `/review` provides code quality feedback
256: - `/fix` helps resolve issues found during execution
257: 
258: ### Memory Plugin
259: - Auto-loads memory context via @imports
260: - Preserves decisions in `decisions.md`
261: - Documents lessons in `lessons_learned.md`
262: 
263: ### Git Plugin
264: - `/ship --commit` uses `/git commit`
265: - `/ship --pr` uses `/git pr`
266: - Automatic commit message generation
267: 
268: ## Work Unit Structure
269: 
270: The workflow creates and maintains this structure:
271: 
272: ```
273: .claude/work/current/[work-unit]/
274: ├── metadata.json              # Work unit metadata
275: ├── exploration.md             # /explore findings
276: ├── implementation-plan.md     # /plan task breakdown
277: ├── state.json                # /next task tracking
278: └── COMPLETION_SUMMARY.md     # /ship delivery summary
279: ```
280: 
281: ## Configuration
282: 
283: ### Exploration Defaults (`.claude/config.json`)
284: ```json
285: {
286:   "workflow": {
287:     "explore": {
288:       "defaultThoroughness": "medium",
289:       "autoCreateWorkUnit": true,
290:       "explorationAgent": "Explore"
291:     }
292:   }
293: }
294: ```
295: 
296: ### Planning Defaults
297: ```json
298: {
299:   "workflow": {
300:     "plan": {
301:       "useSequentialThinking": true,
302:       "includeTestTasks": true,
303:       "includeDocTasks": true
304:     }
305:   }
306: }
307: ```
308: 
309: ### Delivery Defaults
310: ```json
311: {
312:   "workflow": {
313:     "ship": {
314:       "requireTests": true,
315:       "requireDocs": true,
316:       "autoCommit": false,
317:       "autoPR": false
318:     }
319:   }
320: }
321: ```
322: 
323: ## Dependencies
324: 
325: ### Required Plugins
326: - **claude-code-core** (^1.0.0): Work unit management, status
327: - **claude-code-memory** (^1.0.0): Memory context loading
328: 
329: ### Optional MCP Tools
330: - **Sequential Thinking**: Enhanced planning and exploration analysis
331: - **Serena**: Semantic code understanding for exploration
332: - **Firecrawl**: Web research for requirements gathering
333: 
334: **Graceful Degradation**: All commands work without MCP tools.
335: 
336: ## Best Practices
337: 
338: ### When to Use Full Workflow
339: 
340: ✅ **Use /explore → /plan → /next → /ship for**:
341: - Multi-file features
342: - Unfamiliar codebase areas
343: - Complex business logic
344: - Work spanning multiple sessions
345: - Team collaboration (plan serves as spec)
346: 
347: ### When to Skip Workflow
348: 
349: ❌ **Skip workflow for**:
350: - Single-line fixes
351: - Documentation updates
352: - Typo corrections
353: - Configuration tweaks
354: - Quick experiments
355: 
356: ### Workflow Variations
357: 
358: **Quick Mode** (skip /explore):
359: ```bash
360: /plan "Simple, clear task"
361: /next
362: /ship --commit
363: ```
364: 
365: **Investigation Mode** (explore only):
366: ```bash
367: /explore "Complex problem"
368: # Review findings, decide approach
369: # May not lead to implementation
370: ```
371: 
372: **Iterative Mode** (re-plan as you learn):
373: ```bash
374: /explore
375: /plan
376: /next
377: # Discover new requirements
378: /plan --update  # Adjust plan
379: /next
380: /ship
381: ```
382: 
383: ## Troubleshooting
384: 
385: ### /explore finds nothing
386: - Broaden search terms
387: - Use `very thorough` mode
388: - Manually specify file patterns to search
389: - Check if you're in correct directory
390: 
391: ### /plan creates too many tasks
392: - Tasks should be 30min - 2hr each
393: - Merge small tasks
394: - Use subtasks in descriptions
395: 
396: ### /next shows "no tasks available"
397: - Run `/next --status` to check dependencies
398: - Tasks may be blocked waiting on others
399: - Check `state.json` for task states
400: 
401: ### /ship validation fails
402: - Review acceptance criteria in plan
403: - Run tests manually: `/test`
404: - Check code quality: `/review`
405: - Fix issues: `/fix`
406: 
407: ## Metrics and Success
408: 
409: The workflow tracks:
410: - **Exploration time**: How long /explore takes
411: - **Task completion rate**: Completed vs. total tasks
412: - **Plan accuracy**: How often plan matches reality
413: - **Quality metrics**: Test coverage, review feedback
414: 
415: View with:
416: ```bash
417: /status verbose
418: /performance
419: ```
420: 
421: ## Examples
422: 
423: See `examples/` directory for complete workflow examples:
424: - `examples/feature-development/` - Full feature workflow
425: - `examples/bug-fix/` - Systematic bug resolution
426: - `examples/refactoring/` - Code improvement workflow
427: 
428: ## Support
429: 
430: - **Documentation**: [Workflow Guide](../../docs/guides/workflow.md)
431: - **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
432: - **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
433: 
434: ## License
435: 
436: MIT License - see [LICENSE](../../LICENSE) for details.
437: 
438: ---
439: 
440: **Version**: 1.0.0
441: **Category**: Workflow
442: **Dependencies**: core (^1.0.0), memory (^1.0.0)
443: **MCP Tools**: Optional (sequential-thinking, serena, firecrawl)
````

## File: plugins/README.md
````markdown
 1: # Core Plugins
 2: 
 3: This directory contains the 5 core plugins that provide the foundation of the Claude Code Plugins framework.
 4: 
 5: ## Available Plugins
 6: 
 7: ### core
 8: **30+ system commands** for essential functionality:
 9: - status, work, config, cleanup
10: - index, handoff, setup, audit
11: - docs, agent, performance, serena, spike
12: 
13: ### workflow
14: **4 development workflow commands**:
15: - `explore` - Analyze requirements and create work breakdown
16: - `plan` - Create detailed implementation plan
17: - `next` - Execute next available task
18: - `ship` - Deliver completed work with validation
19: 
20: ### development
21: **8 code quality commands**:
22: - `analyze` - Deep codebase analysis
23: - `test` - Test-driven development
24: - `fix` - Universal debugging and fixes
25: - `run` - Execute scripts with monitoring
26: - `review` - Code review and quality analysis
27: - `report` - Generate stakeholder reports
28: - `experiment` - Run ML experiments
29: - `evaluate` - Compare experiments
30: 
31: ### git
32: **1 unified git command**:
33: - `git` - Commits, pull requests, issue management
34: 
35: ### memory
36: **3 context management commands**:
37: - `memory-review` - Display current memory state
38: - `memory-update` - Interactive memory maintenance
39: - `memory-gc` - Garbage collection for stale entries
40: 
41: ## Installation
42: 
43: These plugins will be synced from the private development repository.
44: 
45: 🚧 **Status**: Plugins will be added during the public launch preparation phase.
46: 
47: ## Plugin Structure
48: 
49: Each plugin follows the official Claude Code plugin structure:
50: 
51: ```
52: plugin-name/
53: ├── .claude-plugin/
54: │   └── plugin.json        # Required manifest
55: ├── commands/              # Slash commands
56: │   └── *.md
57: ├── agents/                # Specialized agents (optional)
58: │   └── *.md
59: └── README.md              # Plugin documentation
60: ```
61: 
62: ## What's Next?
63: 
64: - [Plugin Creation Guide](../docs/guides/plugin-creation.md)
65: - [Commands Reference](../docs/reference/commands.md)
````

## File: templates/README.md
````markdown
 1: # Plugin Templates
 2: 
 3: This directory contains templates to help you create new plugins quickly.
 4: 
 5: ## Available Templates
 6: 
 7: 🚧 **Coming Soon**: Plugin templates will be added here.
 8: 
 9: ### Planned Templates
10: 
11: **basic-plugin/**
12: - Starter template for any plugin
13: - Includes all required files
14: - Minimal configuration
15: - Good starting point for most use cases
16: 
17: **command-only/**
18: - Template for command-only plugins (no agents)
19: - Perfect for automation workflows
20: - State management examples included
21: 
22: **agent-plugin/**
23: - Template for agent-based plugins
24: - Includes agent configuration
25: - Command + agent integration examples
26: 
27: ## Using Templates
28: 
29: ```bash
30: # Copy template to start a new plugin
31: cp -r templates/basic-plugin plugins/my-new-plugin
32: 
33: # Customize the plugin
34: cd plugins/my-new-plugin
35: # Edit .claude-plugin/plugin.json
36: # Add commands to commands/
37: # Update README.md
38: ```
39: 
40: ## What's Next?
41: 
42: - [Plugin Creation Guide](../docs/guides/plugin-creation.md)
43: - [Example Plugins](../examples/)
44: - [CONTRIBUTING.md](../CONTRIBUTING.md)
````

## File: CONTRIBUTING.md
````markdown
  1: # Contributing to Claude Code Plugins
  2: 
  3: Thank you for your interest in contributing to Claude Code Plugins! This document provides guidelines for contributing to the project.
  4: 
  5: ## Code of Conduct
  6: 
  7: By participating in this project, you agree to abide by our Code of Conduct:
  8: 
  9: - **Be respectful**: Treat everyone with respect. No harassment, discrimination, or unprofessional behavior.
 10: - **Be constructive**: Provide helpful feedback. Focus on improving the project.
 11: - **Be collaborative**: Work together. We're building something valuable for the community.
 12: 
 13: ## How to Contribute
 14: 
 15: ### Reporting Bugs
 16: 
 17: Before submitting a bug report:
 18: 
 19: 1. **Search existing issues** to see if the problem has already been reported
 20: 2. **Check the documentation** to ensure you're using the framework correctly
 21: 3. **Test with the latest version** to see if the issue has been resolved
 22: 
 23: When submitting a bug report, include:
 24: 
 25: - **Clear title and description** of the issue
 26: - **Steps to reproduce** the behavior
 27: - **Expected behavior** vs what actually happened
 28: - **Environment details** (Claude Code version, OS, plugins enabled)
 29: - **Relevant logs or error messages**
 30: - **Screenshots** if applicable
 31: 
 32: ### Suggesting Features
 33: 
 34: We love feature suggestions! Before submitting:
 35: 
 36: 1. **Search existing issues** to see if it's already been suggested
 37: 2. **Check the roadmap** to see if it's planned
 38: 3. **Consider if it fits the project scope** (general workflow vs domain-specific)
 39: 
 40: When suggesting a feature:
 41: 
 42: - **Describe the problem** you're trying to solve
 43: - **Explain your proposed solution** and why it's the best approach
 44: - **Provide examples** of how it would be used
 45: - **Consider backwards compatibility**
 46: 
 47: ### Submitting Pull Requests
 48: 
 49: #### Before You Start
 50: 
 51: 1. **Open an issue** first to discuss significant changes
 52: 2. **Fork the repository** and create a branch from `main`
 53: 3. **Read the architecture docs** to understand the framework design
 54: 
 55: #### Development Process
 56: 
 57: 1. **Create a feature branch**:
 58:    ```bash
 59:    git checkout -b feature/your-feature-name
 60:    ```
 61: 
 62: 2. **Make your changes**:
 63:    - Follow existing code style and patterns
 64:    - Add tests if applicable
 65:    - Update documentation
 66:    - Ensure all tests pass
 67: 
 68: 3. **Write good commit messages**:
 69:    ```
 70:    feat: add memory-import command for bulk memory loading
 71: 
 72:    - Supports JSON and Markdown file imports
 73:    - Validates structure before importing
 74:    - Updates memory-review to show imported files
 75:    ```
 76: 
 77:    Use conventional commits:
 78:    - `feat:` - New feature
 79:    - `fix:` - Bug fix
 80:    - `docs:` - Documentation only
 81:    - `style:` - Formatting, missing semicolons, etc
 82:    - `refactor:` - Code restructuring
 83:    - `test:` - Adding tests
 84:    - `chore:` - Maintenance
 85: 
 86: 4. **Test your changes**:
 87:    ```bash
 88:    # Test in a real project
 89:    cd ~/test-project
 90:    # Enable your modified plugin
 91:    # Test all affected commands
 92:    ```
 93: 
 94: 5. **Submit your pull request**:
 95:    - Provide a clear description of what changed and why
 96:    - Reference any related issues
 97:    - Include screenshots/examples if relevant
 98:    - Ensure CI passes
 99: 
100: #### Pull Request Checklist
101: 
102: - [ ] Code follows existing style and patterns
103: - [ ] Tests added/updated (if applicable)
104: - [ ] Documentation updated (if applicable)
105: - [ ] All tests pass
106: - [ ] Commit messages follow conventional commits
107: - [ ] Branch is up to date with main
108: - [ ] No merge conflicts
109: 
110: ### Creating New Plugins
111: 
112: Want to contribute a new plugin? Great! Here's the process:
113: 
114: 1. **Propose the plugin** by opening an issue:
115:    - Describe what problem it solves
116:    - Explain why it belongs in the core framework (vs a separate plugin)
117:    - Outline the commands and capabilities
118: 
119: 2. **Wait for approval** before starting development
120: 
121: 3. **Use the plugin template**:
122:    ```bash
123:    cp -r templates/basic-plugin plugins/your-plugin-name
124:    ```
125: 
126: 4. **Follow plugin structure**:
127:    ```
128:    your-plugin/
129:    ├── .claude-plugin/
130:    │   └── plugin.json      # Required manifest
131:    ├── commands/            # Slash commands
132:    │   └── *.md
133:    ├── agents/              # Specialized agents (optional)
134:    │   └── *.md
135:    └── README.md            # Plugin documentation
136:    ```
137: 
138: 5. **Test thoroughly**:
139:    - Test all commands in isolation
140:    - Test integration with other plugins
141:    - Test in multiple projects
142:    - Document any dependencies or requirements
143: 
144: 6. **Document well**:
145:    - Clear README with examples
146:    - Command reference
147:    - Agent capabilities (if any)
148:    - Configuration options
149:    - Known limitations
150: 
151: ### Improving Documentation
152: 
153: Documentation improvements are always welcome!
154: 
155: - **Fix typos or unclear language**
156: - **Add examples** to clarify concepts
157: - **Improve organization** for better navigation
158: - **Add tutorials** for common use cases
159: - **Update outdated information**
160: 
161: For documentation changes:
162: 
163: 1. Edit files in `docs/`
164: 2. Test links work correctly
165: 3. Ensure markdown renders properly
166: 4. Submit a pull request
167: 
168: ### Code Style
169: 
170: - **Follow existing patterns**: Look at similar code in the project
171: - **Keep it simple**: Prefer clarity over cleverness
172: - **Comment when needed**: Explain "why", not "what"
173: - **Use descriptive names**: Variables, functions, commands should be self-documenting
174: - **Maintain consistency**: Match the style of the file you're editing
175: 
176: **Command Files** (`.md`):
177: - Use YAML frontmatter for metadata
178: - Start with clear description
179: - Provide usage examples
180: - Include error handling
181: - Document all parameters
182: 
183: **Agent Files** (`.md`):
184: - Clear role definition in frontmatter
185: - Structured sections with markdown headers
186: - Examples of agent capabilities
187: - Clear boundaries (what the agent does/doesn't do)
188: 
189: ### Testing
190: 
191: Currently, testing is manual. We're working on automated testing.
192: 
193: **Manual Testing Process**:
194: 
195: 1. **Create a test project**:
196:    ```bash
197:    mkdir ~/test-claude-code-plugins
198:    cd ~/test-claude-code-plugins
199:    git init
200:    ```
201: 
202: 2. **Enable your modified plugin**:
203:    ```json
204:    // .claude/settings.json
205:    {
206:      "extraKnownMarketplaces": {
207:        "local": {
208:          "source": {
209:            "source": "directory",
210:            "path": "/path/to/your/fork/plugins"
211:          }
212:        }
213:      },
214:      "enabledPlugins": {
215:        "your-plugin@local": true
216:      }
217:    }
218:    ```
219: 
220: 3. **Test all affected commands**:
221:    - Run each command with typical inputs
222:    - Test error cases
223:    - Test integration with other commands
224:    - Check state management (if applicable)
225: 
226: 4. **Verify backwards compatibility**:
227:    - Test with existing work units
228:    - Ensure no breaking changes to APIs
229:    - Update version if breaking changes required
230: 
231: ## Community
232: 
233: - **GitHub Discussions**: For questions and general discussion
234: - **GitHub Issues**: For bug reports and feature requests
235: - **Pull Requests**: For code contributions
236: - **Blog**: Share your plugins and use cases
237: 
238: ## Recognition
239: 
240: Contributors will be:
241: 
242: - Listed in [CONTRIBUTORS.md](CONTRIBUTORS.md)
243: - Mentioned in release notes for their contributions
244: - Credited in documentation they author
245: 
246: ## Questions?
247: 
248: If you have questions about contributing:
249: 
250: - Open a GitHub Discussion
251: - Check the [documentation](docs/)
252: - Review existing issues and pull requests
253: 
254: ---
255: 
256: Thank you for helping make Claude Code Plugins better!
````

## File: README.md
````markdown
  1: # Claude Code Plugins
  2: 
  3: **Production-Ready Workflow Framework for Claude Code**
  4: 
  5: > From Chaos to System: Structured AI-assisted development workflows that scale from individual developers to enterprise teams.
  6: 
  7: [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
  8: [![Claude Code](https://img.shields.io/badge/Claude%20Code-2.0%2B-blue)](https://docs.claude.com/claude-code)
  9: 
 10: ---
 11: 
 12: ## What Is This?
 13: 
 14: Claude Code Plugins is a **production-ready framework** that adds structured development patterns, work management, and quality automation to Anthropic's Claude Code.
 15: 
 16: **In short**: Claude Code provides the tools, we provide the methodology.
 17: 
 18: ### Core Features
 19: 
 20: ✅ **Structured Workflow**: `explore` → `plan` → `next` → `ship` - Break down complex work into tracked, dependent tasks
 21: 
 22: ✅ **Memory Management**: Persistent context across sessions with automatic reflection and cleanup
 23: 
 24: ✅ **Quality Automation**: Safe git commits, pre/post tool execution hooks, compliance auditing
 25: 
 26: ✅ **MCP Integration**: Proven patterns for Serena, Chrome DevTools, Context7, Sequential Thinking
 27: 
 28: ✅ **Specialized Agents**: 6 expert agents (architect, test-engineer, code-reviewer, auditor, data-scientist, report-generator)
 29: 
 30: ### What You Get
 31: 
 32: **5 Core Plugins** (30+ commands):
 33: - **core** - System commands (status, work, config, cleanup, index, handoff, setup, audit)
 34: - **workflow** - Development workflow (explore, plan, next, ship)
 35: - **development** - Code quality (analyze, test, fix, run, review)
 36: - **git** - Version control operations
 37: - **memory** - Context management (memory-review, memory-update, memory-gc)
 38: 
 39: **Battle-Tested**: 6+ months of production use building:
 40: - ML for Trading 3rd Edition book (500+ pages)
 41: - Quantitative research infrastructure
 42: - Full-stack web applications
 43: 
 44: ---
 45: 
 46: ## Quick Start
 47: 
 48: ### Prerequisites
 49: 
 50: - **Claude Code 2.0+** (install from [claude.com/install](https://claude.com/install))
 51: - **Git 2.0+**
 52: - **jq** (JSON processing)
 53: 
 54: ### Installation
 55: 
 56: **Option 1: Direct Installation** (Recommended)
 57: 
 58: ```bash
 59: # Clone repository
 60: cd ~/repos  # or your preferred location
 61: git clone git@github.com:applied-artificial-intelligence/claude-code-plugins.git
 62: cd claude-code-plugins
 63: 
 64: # Install plugins
 65: ./scripts/install.sh
 66: ```
 67: 
 68: **Option 2: Project-Specific** (via marketplace)
 69: 
 70: In your project's `.claude/settings.json`:
 71: 
 72: ```json
 73: {
 74:   "extraKnownMarketplaces": {
 75:     "aai-plugins": {
 76:       "source": {
 77:         "source": "directory",
 78:         "path": "/path/to/claude-code-plugins/plugins"
 79:       }
 80:     }
 81:   },
 82:   "enabledPlugins": {
 83:     "core@aai-plugins": true,
 84:     "workflow@aai-plugins": true,
 85:     "development@aai-plugins": true,
 86:     "git@aai-plugins": true,
 87:     "memory@aai-plugins": true
 88:   }
 89: }
 90: ```
 91: 
 92: ### Your First Workflow
 93: 
 94: ```bash
 95: # Start a new feature
 96: /explore "add user authentication"
 97: 
 98: # Creates work unit, analyzes requirements, suggests implementation approach
 99: 
100: # Generate implementation plan
101: /plan
102: 
103: # Breaks down work into ordered tasks with dependencies
104: 
105: # Execute tasks one by one
106: /next
107: 
108: # Runs next task, updates state automatically
109: 
110: # Deliver completed work
111: /ship
112: 
113: # Validates quality, creates PR, cleans up
114: ```
115: 
116: ---
117: 
118: ## Why Use This Framework?
119: 
120: ### Problem: AI-Assisted Development Gets Messy
121: 
122: - Context limits hit unexpectedly
123: - Work gets fragmented across sessions
124: - No systematic approach to complex features
125: - Quality gates missing
126: - Knowledge doesn't persist
127: 
128: ### Solution: Structured Workflows + Memory Management
129: 
130: **Structured Workflow**:
131: - Break down complex work systematically
132: - Track dependencies between tasks
133: - Resume seamlessly across sessions
134: - Clear completion criteria
135: 
136: **Memory Management**:
137: - Persistent context across long-running work
138: - Automatic reflection at task boundaries
139: - Garbage collection for stale information
140: - Project-specific conventions and decisions
141: 
142: **Quality Automation**:
143: - Safe git commits (no accidental force pushes)
144: - Pre/post execution hooks
145: - Automated code review checkpoints
146: - Framework compliance auditing
147: 
148: ---
149: 
150: ## Architecture
151: 
152: ### Progressive Disclosure Pattern
153: 
154: Instead of loading everything into context upfront, plugins use progressive disclosure:
155: 
156: 1. **Startup**: Load minimal metadata (plugin names, descriptions)
157: 2. **Task Analysis**: Load relevant commands/agents based on task
158: 3. **Execution**: Load detailed patterns only when needed
159: 
160: **Result**: 70%+ token savings while maintaining full capability.
161: 
162: ### MCP Integration
163: 
164: Proven patterns for Model Context Protocol tools:
165: 
166: - **Serena**: Semantic code understanding (70-90% token reduction for code operations)
167: - **Chrome DevTools**: Frontend verification (26 tools for debugging and performance)
168: - **Context7**: Library documentation access (50%+ faster than manual search)
169: - **Sequential Thinking**: Structured reasoning for complex analysis
170: 
171: All with graceful degradation when MCP unavailable.
172: 
173: ### Plugin Architecture
174: 
175: ```
176: plugin-name/
177: ├── .claude-plugin/
178: │   └── plugin.json        # Manifest
179: ├── commands/              # Slash commands
180: │   └── *.md
181: ├── agents/                # Specialized agents
182: │   └── *.md
183: └── hooks/                 # Event handlers (optional)
184:     └── hooks.json
185: ```
186: 
187: ---
188: 
189: ## Documentation
190: 
191: ### Getting Started
192: - [Installation Guide](docs/getting-started/installation.md)
193: - [Quick Start Tutorial](docs/getting-started/quick-start.md)
194: - [Your First Plugin](docs/getting-started/first-plugin.md)
195: 
196: ### Guides
197: - [Workflow Guide](docs/guides/workflow-guide.md) - Using explore → plan → next → ship
198: - [Memory Management](docs/guides/memory-management.md) - Persistent context best practices
199: - [MCP Integration](docs/guides/mcp-integration.md) - Leveraging Model Context Protocol
200: - [Plugin Creation](docs/guides/plugin-creation.md) - Building custom plugins
201: 
202: ### Reference
203: - [Commands Reference](docs/reference/commands.md) - All 30+ commands documented
204: - [Agents Reference](docs/reference/agents.md) - Specialized agent capabilities
205: - [Configuration](docs/reference/configuration.md) - Settings and customization
206: 
207: ### Architecture
208: - [Design Principles](docs/architecture/design-principles.md) - Core framework philosophy
209: - [Framework Patterns](docs/architecture/patterns.md) - Reusable patterns
210: - [System Constraints](docs/architecture/constraints.md) - What the framework can/cannot do
211: 
212: ---
213: 
214: ## Examples
215: 
216: ### Example 1: Feature Development
217: 
218: ```bash
219: # User story: Add password reset functionality
220: 
221: /explore "implement password reset with email verification"
222: # → Creates work unit 003_password_reset
223: # → Analyzes: needs email service, token generation, UI flow
224: # → Suggests: 8 tasks across backend, frontend, testing
225: 
226: /plan
227: # → Generates detailed task breakdown:
228: #   1. Design token schema (15 min)
229: #   2. Implement token generation service (30 min)
230: #   3. Create email template (15 min)
231: #   4. Build reset endpoint (30 min)
232: #   5. Add frontend form (30 min)
233: #   6. Write tests (45 min)
234: #   7. Update documentation (15 min)
235: #   8. Security review (30 min)
236: 
237: /next
238: # → Executes Task 1: Design token schema
239: # → Auto-commits when complete
240: 
241: /next  # Repeat until all tasks done
242: 
243: /ship
244: # → Runs final validation
245: # → Creates comprehensive PR
246: # → Updates work unit as completed
247: ```
248: 
249: ### Example 2: Bug Investigation
250: 
251: ```bash
252: /explore "#1234"  # GitHub issue number
253: # → Loads issue description
254: # → Analyzes error logs
255: # → Identifies root cause
256: # → Proposes fix approach
257: 
258: /plan
259: # → Creates debugging plan with verification steps
260: 
261: /fix
262: # → Applies fix
263: # → Runs tests
264: # → Verifies resolution
265: 
266: /ship
267: # → Commits fix
268: # → Updates issue
269: # → Creates PR
270: ```
271: 
272: ### Example 3: Code Review
273: 
274: ```bash
275: /review src/auth/
276: # → Systematic code analysis
277: # → Identifies bugs, security issues, design flaws
278: # → Prioritized action items
279: # → Generates review report
280: 
281: /fix review
282: # → Applies recommended fixes
283: # → Runs tests
284: # → Updates code quality
285: ```
286: 
287: ---
288: 
289: ## Case Studies
290: 
291: ### ML for Trading Book (500+ pages)
292: 
293: **Challenge**: Authoring technical book with code examples, academic citations, and Jupyter notebooks
294: 
295: **Solution**: Custom plugins built on this framework
296: - `ml3t-researcher`: Paper search and citation management
297: - `ml3t-coauthor`: 14-command book production workflow
298: 
299: **Results**:
300: - 26 chapters coordinated across 3 AI agents
301: - 100% citation accuracy with Zotero integration
302: - 95%+ notebook execution success rate
303: 
304: ### Quantitative Research Infrastructure
305: 
306: **Challenge**: Reproducible backtesting and strategy development
307: 
308: **Solution**: `quant` plugin with validation gates
309: 
310: **Results**:
311: - Systematic strategy development workflow
312: - Automated data validation preventing silent errors
313: - Reproducible research environment
314: 
315: ---
316: 
317: ## Services
318: 
319: ### Self-Service (Free - Open Source)
320: 
321: ✅ 5 core plugins (30+ commands)
322: ✅ Complete documentation
323: ✅ Community support (GitHub issues)
324: ✅ Tutorial content
325: 
326: ### Implementation Consulting
327: 
328: **$5K-15K per engagement**
329: 
330: Need help getting your team started?
331: 
332: - Initial setup and configuration
333: - Team training workshop (4-8 hours)
334: - Custom configuration for your stack
335: - 30-day email support
336: 
337: [Schedule Consultation →](https://appliedaiconsulting.com/contact)
338: 
339: ### Custom Plugin Development
340: 
341: **$10K-30K per plugin**
342: 
343: Have specialized workflows?
344: 
345: - Discovery workshop
346: - Custom plugin design and development
347: - Testing and documentation
348: - Training and handoff
349: 
350: [Discuss Your Needs →](https://appliedaiconsulting.com/contact)
351: 
352: ### Enterprise Support
353: 
354: **$20K-100K/year**
355: 
356: For organizations adopting AI-assisted development at scale:
357: 
358: - Priority support (24-hour response)
359: - Quarterly plugin updates
360: - Custom feature development
361: - Annual training refreshers
362: - Architecture consultation
363: 
364: [Enterprise Inquiry →](https://appliedaiconsulting.com/enterprise)
365: 
366: ---
367: 
368: ## Contributing
369: 
370: We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:
371: 
372: - How to report bugs
373: - How to suggest features
374: - How to submit pull requests
375: - Code of conduct
376: 
377: ---
378: 
379: ## Community
380: 
381: - **GitHub Issues**: [Report bugs or request features](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
382: - **Discussions**: [Ask questions, share plugins](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
383: - **Discord**: Coming soon
384: - **Blog**: [Technical articles and lessons learned](https://appliedaiconsulting.com/blog)
385: 
386: ---
387: 
388: ## License
389: 
390: MIT License - see [LICENSE](LICENSE) for details.
391: 
392: Free for personal and commercial use.
393: 
394: ---
395: 
396: ## Acknowledgments
397: 
398: Built with [Claude Code](https://claude.com/claude-code) by Anthropic.
399: 
400: Inspired by 6+ months of production use across book authoring, quantitative research, and full-stack development.
401: 
402: ---
403: 
404: ## What's Next?
405: 
406: **Ready to get started?**
407: 
408: 1. [Install the framework](docs/getting-started/installation.md)
409: 2. [Follow the quick start tutorial](docs/getting-started/quick-start.md)
410: 3. [Build your first plugin](docs/getting-started/first-plugin.md)
411: 
412: **Need help with implementation?**
413: 
414: - [Schedule a free 30-minute consultation](https://appliedaiconsulting.com/contact)
415: - [Read our blog posts](https://appliedaiconsulting.com/blog)
416: - [Join the community discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
417: 
418: **Want to contribute?**
419: 
420: - Star the repo ⭐
421: - Open an issue with feedback
422: - Submit a pull request
423: - Share your custom plugins
424: 
425: ---
426: 
427: **Built by Applied AI Consulting** | [Website](https://appliedaiconsulting.com) | [GitHub](https://github.com/applied-artificial-intelligence)
````

## File: docs/getting-started/installation.md
````markdown
  1: # Installation Guide
  2: 
  3: Get Claude Code Plugins up and running in minutes.
  4: 
  5: ## Prerequisites
  6: 
  7: Before installing Claude Code Plugins, ensure you have:
  8: 
  9: ### Required
 10: 
 11: - **Claude Code** v3.0 or later
 12:   - Check your version: Open Claude Code and check the About section
 13:   - Update if needed: Claude Code auto-updates to latest version
 14: 
 15: - **Operating System**: Linux, macOS, or Windows (WSL recommended)
 16:   - Linux: Most distributions supported
 17:   - macOS: 10.15 (Catalina) or later
 18:   - Windows: WSL 2 with Ubuntu 20.04+ recommended
 19: 
 20: - **Git** v2.0 or later
 21:   ```bash
 22:   git --version
 23:   # Should show: git version 2.x.x or later
 24:   ```
 25: 
 26: ### Optional but Recommended
 27: 
 28: - **GitHub CLI** (`gh`) - For pull request and issue management
 29:   ```bash
 30:   # macOS
 31:   brew install gh
 32: 
 33:   # Linux (Debian/Ubuntu)
 34:   sudo apt install gh
 35: 
 36:   # Linux (other distributions)
 37:   # See: https://github.com/cli/cli#installation
 38: 
 39:   # Verify installation
 40:   gh --version
 41: 
 42:   # Authenticate
 43:   gh auth login
 44:   ```
 45: 
 46: - **jq** - JSON processor for better command output
 47:   ```bash
 48:   # macOS
 49:   brew install jq
 50: 
 51:   # Linux (Debian/Ubuntu)
 52:   sudo apt install jq
 53: 
 54:   # Verify
 55:   jq --version
 56:   ```
 57: 
 58: - **Node.js** v16+ - For some development plugins
 59:   ```bash
 60:   # macOS
 61:   brew install node
 62: 
 63:   # Linux
 64:   # See: https://nodejs.org/en/download/package-manager
 65: 
 66:   # Verify
 67:   node --version
 68:   npm --version
 69:   ```
 70: 
 71: ## Installation Methods
 72: 
 73: ### Method 1: GitHub Installation (Recommended)
 74: 
 75: Install directly from the GitHub repository marketplace.
 76: 
 77: #### Step 1: Add Marketplace to Settings
 78: 
 79: Create or update your Claude Code settings file:
 80: 
 81: **Location**: `~/.claude/settings.json` (global) or `.claude/settings.json` (project-specific)
 82: 
 83: ```json
 84: {
 85:   "extraKnownMarketplaces": {
 86:     "claude-code-plugins": {
 87:       "source": {
 88:         "source": "github",
 89:         "repo": "applied-artificial-intelligence/claude-code-plugins"
 90:       }
 91:     }
 92:   }
 93: }
 94: ```
 95: 
 96: #### Step 2: Enable Plugins
 97: 
 98: Add the plugins you want to enable:
 99: 
100: ```json
101: {
102:   "extraKnownMarketplaces": {
103:     "claude-code-plugins": {
104:       "source": {
105:         "source": "github",
106:         "repo": "applied-artificial-intelligence/claude-code-plugins"
107:       }
108:     }
109:   },
110:   "enabledPlugins": {
111:     "core@claude-code-plugins": true,
112:     "workflow@claude-code-plugins": true,
113:     "development@claude-code-plugins": true,
114:     "git@claude-code-plugins": true,
115:     "memory@claude-code-plugins": true
116:   }
117: }
118: ```
119: 
120: #### Step 3: Restart Claude Code
121: 
122: Close and reopen Claude Code to load the plugins.
123: 
124: ### Method 2: Local Directory Installation
125: 
126: Install from a local directory (useful for development or testing).
127: 
128: #### Step 1: Clone Repository
129: 
130: ```bash
131: # Choose installation location
132: cd ~/projects  # or wherever you prefer
133: 
134: # Clone the repository
135: git clone https://github.com/applied-artificial-intelligence/claude-code-plugins.git
136: 
137: # Verify structure
138: ls claude-code-plugins/plugins
139: # Should show: core development git memory workflow
140: ```
141: 
142: #### Step 2: Configure Settings
143: 
144: Update your settings to point to the local directory:
145: 
146: ```json
147: {
148:   "extraKnownMarketplaces": {
149:     "claude-code-plugins-local": {
150:       "source": {
151:         "source": "directory",
152:         "path": "/full/path/to/claude-code-plugins"
153:       }
154:     }
155:   },
156:   "enabledPlugins": {
157:     "core@claude-code-plugins-local": true,
158:     "workflow@claude-code-plugins-local": true,
159:     "development@claude-code-plugins-local": true,
160:     "git@claude-code-plugins-local": true,
161:     "memory@claude-code-plugins-local": true
162:   }
163: }
164: ```
165: 
166: **Important**: Use **absolute path** (not `~/` or relative paths).
167: 
168: #### Step 3: Restart Claude Code
169: 
170: Close and reopen Claude Code to load the plugins from local directory.
171: 
172: ### Method 3: Project-Specific Installation
173: 
174: Install plugins for a single project only.
175: 
176: #### Step 1: Create Project Settings
177: 
178: In your project directory, create `.claude/settings.json`:
179: 
180: ```bash
181: cd /path/to/your/project
182: mkdir -p .claude
183: ```
184: 
185: #### Step 2: Configure Project Settings
186: 
187: Create `.claude/settings.json`:
188: 
189: ```json
190: {
191:   "extraKnownMarketplaces": {
192:     "claude-code-plugins": {
193:       "source": {
194:         "source": "github",
195:         "repo": "applied-artificial-intelligence/claude-code-plugins"
196:       }
197:     }
198:   },
199:   "enabledPlugins": {
200:     "core@claude-code-plugins": true,
201:     "workflow@claude-code-plugins": true
202:   }
203: }
204: ```
205: 
206: **Note**: Project settings override global settings. Plugins enabled here will only work in this project.
207: 
208: ## Configuration
209: 
210: ### Minimal Configuration
211: 
212: Bare minimum to get started (enables all 5 core plugins):
213: 
214: ```json
215: {
216:   "extraKnownMarketplaces": {
217:     "claude-code-plugins": {
218:       "source": {
219:         "source": "github",
220:         "repo": "applied-artificial-intelligence/claude-code-plugins"
221:       }
222:     }
223:   },
224:   "enabledPlugins": {
225:     "core@claude-code-plugins": true,
226:     "workflow@claude-code-plugins": true,
227:     "development@claude-code-plugins": true,
228:     "git@claude-code-plugins": true,
229:     "memory@claude-code-plugins": true
230:   }
231: }
232: ```
233: 
234: ### Selective Plugin Configuration
235: 
236: Enable only the plugins you need:
237: 
238: **Example 1: Workflow Only**
239: ```json
240: {
241:   "extraKnownMarketplaces": {
242:     "claude-code-plugins": {
243:       "source": {
244:         "source": "github",
245:         "repo": "applied-artificial-intelligence/claude-code-plugins"
246:       }
247:     }
248:   },
249:   "enabledPlugins": {
250:     "core@claude-code-plugins": true,
251:     "workflow@claude-code-plugins": true
252:   }
253: }
254: ```
255: 
256: **Example 2: Development Tools Only**
257: ```json
258: {
259:   "extraKnownMarketplaces": {
260:     "claude-code-plugins": {
261:       "source": {
262:         "source": "github",
263:         "repo": "applied-artificial-intelligence/claude-code-plugins"
264:       }
265:     }
266:   },
267:   "enabledPlugins": {
268:     "core@claude-code-plugins": true,
269:     "development@claude-code-plugins": true
270:   }
271: }
272: ```
273: 
274: **Note**: The `core` plugin is recommended for all configurations as it provides essential system functionality.
275: 
276: ### Advanced Configuration
277: 
278: #### Custom Plugin Settings
279: 
280: Some plugins accept configuration options:
281: 
282: ```json
283: {
284:   "extraKnownMarketplaces": {
285:     "claude-code-plugins": {
286:       "source": {
287:         "source": "github",
288:         "repo": "applied-artificial-intelligence/claude-code-plugins"
289:       }
290:     }
291:   },
292:   "enabledPlugins": {
293:     "core@claude-code-plugins": true,
294:     "workflow@claude-code-plugins": true,
295:     "development@claude-code-plugins": true,
296:     "git@claude-code-plugins": true,
297:     "memory@claude-code-plugins": true
298:   },
299:   "pluginSettings": {
300:     "core@claude-code-plugins": {
301:       "performance": {
302:         "tokenWarningThreshold": 0.8,
303:         "tokenCriticalThreshold": 0.9
304:       }
305:     },
306:     "workflow@claude-code-plugins": {
307:       "explore": {
308:         "defaultThoroughness": "medium"
309:       }
310:     },
311:     "memory@claude-code-plugins": {
312:       "autoReflection": true,
313:       "staleThresholdDays": 30
314:     }
315:   }
316: }
317: ```
318: 
319: #### Multiple Marketplaces
320: 
321: Use plugins from multiple sources:
322: 
323: ```json
324: {
325:   "extraKnownMarketplaces": {
326:     "claude-code-plugins": {
327:       "source": {
328:         "source": "github",
329:         "repo": "applied-artificial-intelligence/claude-code-plugins"
330:       }
331:     },
332:     "my-custom-plugins": {
333:       "source": {
334:         "source": "directory",
335:         "path": "/home/user/my-plugins"
336:       }
337:     }
338:   },
339:   "enabledPlugins": {
340:     "core@claude-code-plugins": true,
341:     "workflow@claude-code-plugins": true,
342:     "my-plugin@my-custom-plugins": true
343:   }
344: }
345: ```
346: 
347: ## Verification
348: 
349: ### Step 1: Check Plugin Loading
350: 
351: Open Claude Code in your project and start a new conversation. Claude should acknowledge the loaded plugins.
352: 
353: ### Step 2: Test a Command
354: 
355: Try running a simple command:
356: 
357: ```bash
358: /status
359: ```
360: 
361: **Expected Output**:
362: ```
363: Project Status
364: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
365: 
366: Project Directory: /path/to/your/project
367: Claude Code Version: v3.x.x
368: Plugins Loaded: 5
369: 
370: Core Systems:
371: ✓ Commands: 25 available
372: ✓ Agents: 6 available
373: ✓ Memory: Active
374: 
375: ...
376: ```
377: 
378: If you see this output, plugins are successfully installed! ✅
379: 
380: ### Step 3: List Available Commands
381: 
382: Check all available commands:
383: 
384: ```bash
385: /help
386: ```
387: 
388: You should see commands from all enabled plugins:
389: - **core**: /status, /work, /agent, /cleanup, /index, /performance, /handoff, /docs, /setup, /audit, /serena, /spike
390: - **workflow**: /explore, /plan, /next, /ship
391: - **development**: /analyze, /test, /fix, /run, /review
392: - **git**: /git
393: - **memory**: /memory-review, /memory-update, /memory-gc
394: 
395: ### Step 4: Test Plugin Integration
396: 
397: Try a workflow command:
398: 
399: ```bash
400: /explore "Test the plugins installation"
401: ```
402: 
403: If the command runs and creates exploration output, your installation is complete! 🎉
404: 
405: ## Troubleshooting
406: 
407: ### Plugins Not Loading
408: 
409: **Symptom**: Commands like `/status` or `/explore` not recognized
410: 
411: **Solutions**:
412: 
413: 1. **Check settings file location**
414:    ```bash
415:    # Global settings
416:    ls ~/.claude/settings.json
417: 
418:    # Project settings
419:    ls .claude/settings.json
420:    ```
421: 
422: 2. **Validate JSON syntax**
423:    ```bash
424:    # Use jq to validate
425:    jq . ~/.claude/settings.json
426:    # Should output formatted JSON with no errors
427:    ```
428: 
429: 3. **Restart Claude Code completely**
430:    - Close all Claude Code windows
431:    - Wait 5 seconds
432:    - Reopen Claude Code
433: 
434: 4. **Check Claude Code version**
435:    - Requires v3.0 or later
436:    - Update Claude Code if needed
437: 
438: ### Commands Return Errors
439: 
440: **Symptom**: Commands run but return "command not found" or "file not found" errors
441: 
442: **Solutions**:
443: 
444: 1. **Verify marketplace path**
445:    - GitHub source: Check repository exists and is public
446:    - Directory source: Verify absolute path is correct
447:    - Test with `ls <path>/plugins`
448: 
449: 2. **Check plugin structure**
450:    ```bash
451:    # Verify plugin structure
452:    ls <marketplace-path>/plugins/core/.claude-plugin/
453:    # Should show: plugin.json
454:    ```
455: 
456: 3. **Verify plugin.json format**
457:    ```bash
458:    jq . <marketplace-path>/plugins/core/.claude-plugin/plugin.json
459:    # Should be valid JSON
460:    ```
461: 
462: ### Permission Errors
463: 
464: **Symptom**: "Permission denied" when running commands
465: 
466: **Solutions**:
467: 
468: 1. **Check file permissions**
469:    ```bash
470:    # Plugin commands should be readable
471:    ls -la ~/claude-code-plugins/plugins/core/commands/
472:    # All .md files should be readable (r--)
473:    ```
474: 
475: 2. **Fix permissions if needed**
476:    ```bash
477:    chmod -R u+r ~/claude-code-plugins/plugins/
478:    ```
479: 
480: ### GitHub Authentication Errors
481: 
482: **Symptom**: Cannot access GitHub marketplace or "authentication required" errors
483: 
484: **Solutions**:
485: 
486: 1. **Verify GitHub access**
487:    ```bash
488:    gh auth status
489:    # Should show: Logged in to github.com as <username>
490:    ```
491: 
492: 2. **Re-authenticate if needed**
493:    ```bash
494:    gh auth login
495:    # Follow prompts to authenticate
496:    ```
497: 
498: 3. **Use HTTPS instead of SSH**
499:    - GitHub source uses HTTPS by default
500:    - No additional configuration needed
501: 
502: ### Plugin-Specific Issues
503: 
504: **Symptom**: One plugin works but another doesn't
505: 
506: **Solutions**:
507: 
508: 1. **Check individual plugin enablement**
509:    ```json
510:    "enabledPlugins": {
511:      "core@claude-code-plugins": true,
512:      "workflow@claude-code-plugins": true,
513:      // Make sure all plugins you want are enabled
514:    }
515:    ```
516: 
517: 2. **Verify plugin dependencies**
518:    - Some plugins depend on `core` plugin
519:    - Enable `core` plugin if not already enabled
520: 
521: 3. **Check plugin-specific requirements**
522:    - `git` plugin requires `git` command available
523:    - `development` plugin may need `node` for some features
524:    - See individual plugin READMEs for requirements
525: 
526: ### Settings Not Taking Effect
527: 
528: **Symptom**: Changed settings but plugins still not working
529: 
530: **Solutions**:
531: 
532: 1. **Restart Claude Code** (settings reload on restart)
533: 
534: 2. **Check settings precedence**
535:    - Project `.claude/settings.json` overrides global `~/.claude/settings.json`
536:    - Make sure you're editing the right file
537: 
538: 3. **Validate settings merge**
539:    ```bash
540:    # Claude Code merges global and project settings
541:    # If both exist, project settings take precedence
542:    ```
543: 
544: ## Next Steps
545: 
546: Now that you have Claude Code Plugins installed:
547: 
548: 1. **Try the Quick Start** - [Quick Start Guide](quick-start.md) - 15-minute hands-on tutorial
549: 2. **Learn the Workflow** - Try `/explore` → `/plan` → `/next` → `/ship`
550: 3. **Explore Commands** - Run `/help` to see all available commands
551: 4. **Create Custom Plugin** - [First Plugin Tutorial](first-plugin.md)
552: 5. **Read Architecture Docs** - Understand the [design principles](../architecture/design-principles.md)
553: 
554: ## Getting Help
555: 
556: If you're still having trouble:
557: 
558: - **Documentation**: Browse the [full documentation](../README.md)
559: - **Issues**: Report bugs at [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
560: - **Discussions**: Ask questions in [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
561: 
562: ## Updating Plugins
563: 
564: ### Update GitHub Marketplace Plugins
565: 
566: Plugins from GitHub marketplace auto-update:
567: - Claude Code checks for updates periodically
568: - Restart Claude Code to get latest version
569: 
570: ### Update Local Directory Plugins
571: 
572: For local installations:
573: 
574: ```bash
575: cd ~/claude-code-plugins  # or your installation path
576: git pull origin main
577: # Restart Claude Code to load updated plugins
578: ```
579: 
580: ## Uninstalling
581: 
582: ### Remove Individual Plugins
583: 
584: Edit your settings.json and remove plugins from `enabledPlugins`:
585: 
586: ```json
587: {
588:   "enabledPlugins": {
589:     "core@claude-code-plugins": true,
590:     // Remove line for plugin you want to disable
591:   }
592: }
593: ```
594: 
595: Restart Claude Code.
596: 
597: ### Remove Marketplace
598: 
599: To completely remove the marketplace:
600: 
601: 1. Delete marketplace from `extraKnownMarketplaces`
602: 2. Remove all plugins from `enabledPlugins`
603: 3. Restart Claude Code
604: 
605: ### Delete Local Installation
606: 
607: If installed locally:
608: 
609: ```bash
610: rm -rf ~/claude-code-plugins  # or your installation path
611: ```
612: 
613: Then update settings.json to remove marketplace reference.
614: 
615: ---
616: 
617: **Installation Complete!** 🎉
618: 
619: You're ready to start using Claude Code Plugins. Head to the [Quick Start Guide](quick-start.md) for a hands-on tutorial.
````

## File: docs/getting-started/quick-start.md
````markdown
  1: # Quick Start Tutorial
  2: 
  3: Get productive with Claude Code Plugins in 15 minutes. Learn the core workflow with a real-world example.
  4: 
  5: ## What You'll Build
  6: 
  7: In this tutorial, you'll add user authentication to a Node.js API using the Claude Code Plugins workflow:
  8: 
  9: **Result**: Working JWT-based authentication in ~15 minutes
 10: 
 11: ## Prerequisites
 12: 
 13: Before starting, ensure you have:
 14: 
 15: - ✅ Claude Code v3.0+ installed
 16: - ✅ Claude Code Plugins installed ([Installation Guide](installation.md))
 17: - ✅ A Node.js project (or follow along with the example)
 18: 
 19: **Time Required**: 15 minutes
 20: 
 21: ## The Workflow
 22: 
 23: Claude Code Plugins provide a systematic 4-phase workflow:
 24: 
 25: ```
 26: /explore → /plan → /next → /ship
 27:    ↓         ↓       ↓        ↓
 28: Analyze   Design  Build   Deliver
 29: ```
 30: 
 31: Let's see it in action!
 32: 
 33: ---
 34: 
 35: ## Step 1: Explore the Requirements (3 minutes)
 36: 
 37: **Goal**: Understand what needs to be built and explore the codebase.
 38: 
 39: ### Run the Command
 40: 
 41: In your project directory, start a Claude Code session and run:
 42: 
 43: ```bash
 44: /explore "Add JWT-based authentication to the API"
 45: ```
 46: 
 47: ### What Happens
 48: 
 49: Claude will:
 50: 1. **Analyze your request** - Understand what "JWT-based authentication" means
 51: 2. **Explore your codebase** - Find relevant files (routes, models, middleware)
 52: 3. **Identify constraints** - Discover existing auth patterns, dependencies
 53: 4. **Document findings** - Create `exploration.md` with analysis
 54: 
 55: ### Expected Output
 56: 
 57: ```
 58: 🔍 Exploration: Add JWT-based authentication to the API
 59: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 60: 
 61: ## Requirements Analysis
 62: ✓ JWT-based authentication requested
 63: ✓ Stateless token-based approach
 64: ✓ Industry standard for APIs
 65: 
 66: ## Codebase Exploration
 67: Found relevant files:
 68: - src/routes/auth.js (empty, needs implementation)
 69: - src/models/User.js (has password field, needs hashing)
 70: - src/middleware/ (needs auth middleware)
 71: 
 72: ## Existing Dependencies
 73: ✓ express: 4.18.2 (web framework)
 74: ✓ bcrypt: 5.1.0 (already installed - good for password hashing!)
 75: ⚠ jsonwebtoken: NOT installed (need to add)
 76: 
 77: ## Recommendations
 78: 1. Install jsonwebtoken package
 79: 2. Add password hashing to User model
 80: 3. Create login endpoint
 81: 4. Implement auth middleware
 82: 5. Protect existing routes
 83: 
 84: Exploration complete → Ready for planning
 85: 📁 Created: .claude/work/current/auth_implementation/exploration.md
 86: ```
 87: 
 88: ### Common Issues
 89: 
 90: **Issue**: "No relevant files found"
 91: - **Solution**: Make sure you're in the project root directory
 92: - **Tip**: You can still continue - Claude will guide you to create the structure
 93: 
 94: **Issue**: "Unclear what you want to explore"
 95: - **Solution**: Be more specific: "Add JWT authentication with login/register endpoints"
 96: 
 97: ---
 98: 
 99: ## Step 2: Create an Implementation Plan (2 minutes)
100: 
101: **Goal**: Break the work into ordered, manageable tasks.
102: 
103: ### Run the Command
104: 
105: ```bash
106: /plan
107: ```
108: 
109: **Note**: `/plan` automatically uses the exploration findings from Step 1.
110: 
111: ### What Happens
112: 
113: Claude will:
114: 1. **Review exploration** - Load findings from Step 1
115: 2. **Break down work** - Create ordered tasks with dependencies
116: 3. **Define success criteria** - Specify how to verify each task
117: 4. **Create task file** - Generate `implementation-plan.md` and `state.json`
118: 
119: ### Expected Output
120: 
121: ```
122: 📋 Implementation Plan: JWT Authentication
123: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
124: 
125: ## Task Breakdown (6 tasks, ~3 hours estimated)
126: 
127: TASK-001: Install jsonwebtoken dependency
128: ├─ Priority: High
129: ├─ Time: 15 minutes
130: └─ Acceptance: Package.json updated, dependency installed
131: 
132: TASK-002: Add password hashing to User model
133: ├─ Dependencies: None
134: ├─ Priority: High
135: ├─ Time: 30 minutes
136: └─ Acceptance: Passwords hashed on save, comparison method works
137: 
138: TASK-003: Create JWT utilities (generate/verify tokens)
139: ├─ Dependencies: TASK-001
140: ├─ Priority: High
141: ├─ Time: 30 minutes
142: └─ Acceptance: Can generate and verify valid JWTs
143: 
144: TASK-004: Implement login endpoint
145: ├─ Dependencies: TASK-002, TASK-003
146: ├─ Priority: High
147: ├─ Time: 45 minutes
148: └─ Acceptance: POST /auth/login returns valid JWT
149: 
150: TASK-005: Create auth middleware
151: ├─ Dependencies: TASK-003
152: ├─ Priority: High
153: ├─ Time: 30 minutes
154: └─ Acceptance: Middleware validates JWT and attaches user
155: 
156: TASK-006: Protect existing endpoints
157: ├─ Dependencies: TASK-005
158: ├─ Priority: Medium
159: ├─ Time: 30 minutes
160: └─ Acceptance: Protected routes require valid token
161: 
162: Planning complete → Ready for implementation
163: 📁 Created: .claude/work/current/auth_implementation/implementation-plan.md
164: 📁 Created: .claude/work/current/auth_implementation/state.json
165: ```
166: 
167: ### What You Get
168: 
169: - **implementation-plan.md**: Human-readable plan with full details
170: - **state.json**: Machine-readable task tracking for `/next`
171: 
172: ### Common Issues
173: 
174: **Issue**: "No exploration found"
175: - **Solution**: Run `/explore` first (Step 1)
176: 
177: **Issue**: "Plan looks wrong"
178: - **Solution**: You can run `/plan` again with more specifics:
179:   ```bash
180:   /plan "Focus on minimal viable auth - just login and protect routes"
181:   ```
182: 
183: ---
184: 
185: ## Step 3: Execute Tasks One by One (8 minutes)
186: 
187: **Goal**: Implement each task systematically with `/next`.
188: 
189: ### Run the Command
190: 
191: ```bash
192: /next
193: ```
194: 
195: **This will execute the first available task (TASK-001).**
196: 
197: ### What Happens
198: 
199: Claude will:
200: 1. **Select next task** - Chooses first task with satisfied dependencies
201: 2. **Display task details** - Shows what will be done
202: 3. **Execute task** - Implements the changes
203: 4. **Verify completion** - Checks acceptance criteria
204: 5. **Update state** - Marks task complete, identifies next task
205: 6. **Commit changes** - Auto-commits with descriptive message
206: 
207: ### Expected Output (First Task)
208: 
209: ```
210: 🚀 Executing TASK-001: Install jsonwebtoken dependency
211: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
212: 
213: ## Task Details
214: Priority: High
215: Estimated: 15 minutes
216: Dependencies: None (ready to execute)
217: 
218: ## Executing...
219: Running: npm install jsonwebtoken
220: 
221: added 5 packages, and audited 150 packages in 3s
222: ✓ jsonwebtoken@9.0.2 installed successfully
223: 
224: ## Verification
225: ✓ Package.json updated with jsonwebtoken@9.0.2
226: ✓ Dependency installed in node_modules
227: ✓ All acceptance criteria met
228: 
229: ## Git Commit
230: [main a7f3d91] feat: Install jsonwebtoken for JWT authentication
231:  2 files changed, 6 insertions(+)
232: 
233: ✅ TASK-001 completed successfully
234: 
235: 📊 Progress: 1/6 tasks complete (17%)
236: → Next available: TASK-002, TASK-003
237: 
238: Run /next again to continue!
239: ```
240: 
241: ### Continue with /next
242: 
243: Keep running `/next` to execute all tasks:
244: 
245: ```bash
246: /next  # Executes TASK-002 (password hashing)
247: /next  # Executes TASK-003 (JWT utilities)
248: /next  # Executes TASK-004 (login endpoint)
249: /next  # Executes TASK-005 (auth middleware)
250: /next  # Executes TASK-006 (protect routes)
251: ```
252: 
253: **Or run them all at once**: Just keep running `/next` until all tasks are complete!
254: 
255: ### Real Example: TASK-004 Output
256: 
257: ```
258: 🚀 Executing TASK-004: Implement login endpoint
259: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
260: 
261: ## Implementation
262: Created: src/routes/auth.js
263: 
264: ```javascript
265: const express = require('express');
266: const User = require('../models/User');
267: const { generateToken } = require('../utils/jwt');
268: 
269: const router = express.Router();
270: 
271: router.post('/login', async (req, res) => {
272:   try {
273:     const { email, password } = req.body;
274: 
275:     // Find user
276:     const user = await User.findOne({ email });
277:     if (!user) {
278:       return res.status(401).json({ error: 'Invalid credentials' });
279:     }
280: 
281:     // Verify password
282:     const isValid = await user.comparePassword(password);
283:     if (!isValid) {
284:       return res.status(401).json({ error: 'Invalid credentials' });
285:     }
286: 
287:     // Generate JWT
288:     const token = generateToken({ userId: user._id });
289: 
290:     res.json({ token, user: { id: user._id, email: user.email } });
291:   } catch (error) {
292:     res.status(500).json({ error: 'Login failed' });
293:   }
294: });
295: 
296: module.exports = router;
297: ```
298: 
299: ## Verification
300: ✓ POST /auth/login endpoint created
301: ✓ Password verification integrated
302: ✓ JWT generation on successful login
303: ✓ Error handling for invalid credentials
304: ✓ Returns token and user data
305: 
306: ✅ TASK-004 completed successfully
307: 📊 Progress: 4/6 tasks complete (67%)
308: ```
309: 
310: ### Common Issues
311: 
312: **Issue**: Task fails with "dependency not satisfied"
313: - **Solution**: Complete the dependent tasks first
314: - **Tip**: Run `/next --status` to see task dependencies
315: 
316: **Issue**: "Tests failing after implementation"
317: - **Solution**: Claude will show the error and suggest fixes
318: - **Tip**: Run `/fix` to debug and resolve test failures
319: 
320: ---
321: 
322: ## Step 4: Review and Test (1 minute)
323: 
324: **Goal**: Verify everything works before delivery.
325: 
326: ### Run the Command
327: 
328: ```bash
329: /review
330: ```
331: 
332: ### What Happens
333: 
334: Claude will:
335: 1. **Review all changes** - Check code added during `/next` executions
336: 2. **Run quality checks** - Linting, formatting, security
337: 3. **Identify issues** - Bugs, design flaws, improvements
338: 4. **Provide feedback** - Prioritized list of findings
339: 
340: ### Expected Output
341: 
342: ```
343: 🔍 Code Review: JWT Authentication Implementation
344: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
345: 
346: ## Files Reviewed
347: - src/models/User.js
348: - src/utils/jwt.js
349: - src/routes/auth.js
350: - src/middleware/auth.js
351: - src/routes/users.js (protected)
352: 
353: ## Findings
354: 
355: ### HIGH Priority
356: ✓ No critical issues found!
357: 
358: ### MEDIUM Priority
359: ℹ️ Consider adding rate limiting to login endpoint
360:   Location: src/routes/auth.js:12
361:   Reason: Prevent brute-force attacks
362:   Suggestion: Use express-rate-limit middleware
363: 
364: ### LOW Priority
365: ✓ Code quality good
366: ✓ Error handling present
367: ✓ Security best practices followed
368: 
369: ## Summary
370: ✅ Implementation is production-ready
371: ℹ️  1 optional improvement suggested (rate limiting)
372: 
373: Overall Quality: Excellent
374: Security: Good
375: Maintainability: High
376: ```
377: 
378: ### Optional: Fix Issues
379: 
380: If the review found issues:
381: 
382: ```bash
383: /fix review
384: ```
385: 
386: This will automatically apply suggested fixes.
387: 
388: ### Test Manually
389: 
390: Try the authentication:
391: 
392: ```bash
393: # Register a user (if you have registration)
394: curl -X POST http://localhost:3000/auth/register \
395:   -H "Content-Type: application/json" \
396:   -d '{"email":"test@example.com","password":"secure123"}'
397: 
398: # Login
399: curl -X POST http://localhost:3000/auth/login \
400:   -H "Content-Type: application/json" \
401:   -d '{"email":"test@example.com","password":"secure123"}'
402: 
403: # Returns: {"token":"eyJhbGc...","user":{"id":"...","email":"test@example.com"}}
404: 
405: # Access protected route
406: curl http://localhost:3000/api/users \
407:   -H "Authorization: Bearer eyJhbGc..."
408: ```
409: 
410: ---
411: 
412: ## Step 5: Ship the Feature (1 minute)
413: 
414: **Goal**: Finalize and deliver the completed work.
415: 
416: ### Run the Command
417: 
418: ```bash
419: /ship
420: ```
421: 
422: Or create a pull request:
423: 
424: ```bash
425: /ship --pr
426: ```
427: 
428: ### What Happens
429: 
430: Claude will:
431: 1. **Verify completion** - Check all tasks are done
432: 2. **Run final tests** - Execute test suite
433: 3. **Generate documentation** - Create completion summary
434: 4. **Create commit/PR** - Package changes for review
435: 5. **Provide summary** - What was delivered and how to use it
436: 
437: ### Expected Output
438: 
439: ```
440: 🚀 Shipping: JWT Authentication
441: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
442: 
443: ## Pre-Delivery Checks
444: ✅ All 6 tasks completed
445: ✅ Tests passing (12/12)
446: ✅ Code review passed
447: ✅ No outstanding issues
448: 
449: ## What Was Delivered
450: 
451: ### Features
452: ✅ JWT-based authentication system
453: ✅ Password hashing with bcrypt
454: ✅ Login endpoint: POST /auth/login
455: ✅ Auth middleware for protected routes
456: ✅ Token generation and verification utilities
457: 
458: ### Files Modified
459: - package.json (added jsonwebtoken)
460: - src/models/User.js (password hashing)
461: - src/utils/jwt.js (NEW - JWT utilities)
462: - src/routes/auth.js (NEW - login endpoint)
463: - src/middleware/auth.js (NEW - auth middleware)
464: - src/routes/users.js (protected with auth)
465: 
466: ### Tests Added
467: - User model password hashing tests (4 tests)
468: - JWT utilities tests (6 tests)
469: - Auth endpoint integration tests (8 tests)
470: 
471: ## How to Use
472: 
473: ### Login
474: ```bash
475: POST /auth/login
476: Content-Type: application/json
477: 
478: {
479:   "email": "user@example.com",
480:   "password": "password123"
481: }
482: 
483: Response:
484: {
485:   "token": "eyJhbGc...",
486:   "user": { "id": "...", "email": "user@example.com" }
487: }
488: ```
489: 
490: ### Protected Routes
491: ```bash
492: GET /api/users
493: Authorization: Bearer eyJhbGc...
494: ```
495: 
496: ## Pull Request Created
497: 🔗 https://github.com/your-org/your-repo/pull/42
498: 
499: Title: feat: Add JWT-based authentication
500: Status: Ready for review
501: Reviewers: Automatically suggested based on CODEOWNERS
502: 
503: ## Next Steps
504: 1. Team review of PR #42
505: 2. Address any review feedback
506: 3. Merge to main when approved
507: 4. Deploy to staging for integration testing
508: 
509: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
510: ✅ Feature delivery complete!
511: 📊 Total time: ~15 minutes
512: 📈 Quality: Production-ready
513: ```
514: 
515: ### If You Used --pr
516: 
517: Claude will:
518: - Push your branch to GitHub
519: - Create a pull request with comprehensive description
520: - Add test plan checklist
521: - Suggest reviewers
522: - Return the PR URL
523: 
524: ---
525: 
526: ## What You Just Learned
527: 
528: In 15 minutes, you:
529: 
530: ✅ **Explored** requirements and codebase with `/explore`
531: ✅ **Planned** implementation with ordered tasks using `/plan`
532: ✅ **Built** the feature systematically with `/next`
533: ✅ **Reviewed** code quality with `/review`
534: ✅ **Shipped** production-ready code with `/ship`
535: 
536: **Result**: Working JWT authentication with tests, documentation, and a pull request!
537: 
538: ## The Power of the Workflow
539: 
540: ### Why This Workflow Works
541: 
542: 1. **Systematic**: No guessing - clear steps from start to finish
543: 2. **Quality-First**: Built-in review and testing at each step
544: 3. **Trackable**: Always know what's done and what's next
545: 4. **Collaborative**: PRs with comprehensive context for reviewers
546: 5. **Fast**: 15 minutes vs. hours of manual coding
547: 
548: ### When to Use This Workflow
549: 
550: ✅ **Perfect for**:
551: - Features that span multiple files
552: - Bug fixes requiring investigation
553: - Refactoring with many changes
554: - Work you'll spread across sessions
555: - Team collaboration (plan serves as spec)
556: 
557: ❌ **Skip for**:
558: - Single-line fixes
559: - Typo corrections
560: - Quick documentation updates
561: 
562: ## Common Issues & Solutions
563: 
564: ### "I made a mistake in exploration"
565: 
566: No problem! Just run `/explore` again:
567: 
568: ```bash
569: /explore "Add JWT authentication with login AND register endpoints"
570: ```
571: 
572: Then `/plan` will use the new exploration.
573: 
574: ### "The plan created too many tasks"
575: 
576: You can simplify:
577: 
578: ```bash
579: /plan "Create minimal auth - just login endpoint and one protected route"
580: ```
581: 
582: Or merge tasks by running multiple `/next` commands and manually combining the work.
583: 
584: ### "A task failed halfway through"
585: 
586: Claude will mark it as "in_progress" and you can:
587: 
588: 1. **Fix the issue** manually
589: 2. **Run `/next` again** - it will resume the same task
590: 3. **Or use `/fix`** to debug the error
591: 
592: ### "I want to change the approach mid-implementation"
593: 
594: You can:
595: 
596: 1. Finish current task with `/next`
597: 2. Run `/plan` again with new direction
598: 3. Claude will create a new plan building on completed work
599: 
600: ## Next Steps
601: 
602: Now that you know the workflow:
603: 
604: 1. **Try it on your own project** - Pick a small feature and use the 4-phase workflow
605: 2. **Learn individual plugins** - Explore the [Core](../../plugins/core/README.md), [Workflow](../../plugins/workflow/README.md), and [Development](../../plugins/development/README.md) plugin READMEs
606: 3. **Create a custom plugin** - Follow the [First Plugin Tutorial](first-plugin.md)
607: 4. **Read architecture docs** - Understand the [design principles](../architecture/design-principles.md)
608: 
609: ## Quick Reference
610: 
611: ### The 4-Phase Workflow
612: 
613: ```bash
614: /explore "<what to build>"     # Step 1: Analyze requirements
615: /plan                          # Step 2: Create task breakdown
616: /next                          # Step 3: Execute tasks (repeat)
617: /ship                          # Step 4: Deliver completed work
618: ```
619: 
620: ### Bonus Commands
621: 
622: ```bash
623: /status                        # Check current progress
624: /next --status                 # See task breakdown and progress
625: /next --preview                # Show next task without executing
626: /review                        # Code quality check
627: /fix                           # Debug and fix issues
628: /git commit                    # Create well-formatted commit
629: /git pr                        # Create pull request
630: ```
631: 
632: ### Getting Help
633: 
634: - **Full Documentation**: [Documentation Index](../README.md)
635: - **Plugin READMEs**: Detailed command references in each plugin
636: - **GitHub Issues**: [Report bugs](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
637: - **Discussions**: [Ask questions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)
638: 
639: ---
640: 
641: **Congratulations!** 🎉
642: 
643: You've completed the Quick Start tutorial. You now know how to use Claude Code Plugins to build features systematically and ship quality code fast.
644: 
645: **Ready for more?** Try the workflow on your next feature!
````

## File: plugins/git/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "claude-code-git",
 3:   "version": "1.0.0",
 4:   "description": "Unified git operations - commits, pull requests, and issue management",
 5:   "author": "Claude Code Framework",
 6:   "keywords": ["git", "version-control", "commits", "pull-requests", "issues"],
 7:   "commands": ["commands/*.md"],
 8:   "settings": {
 9:     "defaultEnabled": true,
10:     "category": "tools"
11:   },
12:   "repository": {
13:     "type": "git",
14:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
15:   },
16:   "license": "MIT",
17:   "capabilities": {
18:     "gitOperations": {
19:       "description": "Unified git operations including commits, pull requests, and issue management",
20:       "command": "git"
21:     },
22:     "safeCommits": {
23:       "description": "Safe git commits with validation and proper attribution",
24:       "integrated": "ship, next commands"
25:     },
26:     "pullRequestCreation": {
27:       "description": "Create pull requests with comprehensive documentation",
28:       "integrated": "ship command"
29:     },
30:     "issueManagement": {
31:       "description": "GitHub issue creation and management",
32:       "tool": "gh CLI"
33:     }
34:   },
35:   "dependencies": {
36:     "claude-code-core": "^1.0.0"
37:   },
38:   "mcpTools": {
39:     "optional": [],
40:     "gracefulDegradation": true
41:   },
42:   "systemRequirements": {
43:     "git": {
44:       "required": true,
45:       "minVersion": "2.0.0"
46:     },
47:     "gh": {
48:       "required": false,
49:       "description": "GitHub CLI for pull request and issue management"
50:     }
51:   },
52:   "integrations": {
53:     "workflow": {
54:       "description": "Integrated with ship command for delivery",
55:       "commands": ["ship"]
56:     }
57:   }
58: }
````
