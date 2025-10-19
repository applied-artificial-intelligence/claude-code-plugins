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
- Only files matching these patterns are included: **/*
- Files matching these patterns are excluded: **/*.test.ts, **/node_modules/**, **/.git/**, .notebooklm-sources/**, .repomix-packages/**, LAUNCH_STATUS.md, .idea/**
- Files matching patterns in .gitignore are excluded
- Files matching default ignore patterns are excluded
- Line numbers have been added to the beginning of each line
- Files are sorted by Git change count (files with more changes are at the bottom)

# User Provided Header
# Claude Code Plugins - Developer Package

This package contains everything needed to understand the codebase and contribute to the project.

## What's Included
- Complete source code for all 5 plugins (30 commands, 5 agents)
- All 3 example plugins with source
- Architecture documentation
- Contributing guidelines
- Automation scripts

## Target Audience
Developers interested in contributing to the project, forking plugins, or understanding implementation details.

## Time to Review: 3-4 hours

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
examples/
  code-formatter/
    .claude-plugin/
      plugin.json
    agents/
      style-checker.md
    commands/
      format.md
    README.md
  hello-world/
    .claude-plugin/
      plugin.json
    commands/
      hello.md
    README.md
  task-tracker/
    .claude-plugin/
      plugin.json
    commands/
      task-add.md
      task-done.md
      tasks.md
    README.md
  README.md
plugins/
  core/
    .claude-plugin/
      plugin.json
      README.md
    agents/
      auditor.md
      reasoning-specialist.md
    commands/
      agent.md
      audit.md
      cleanup.md
      docs.md
      handoff.md
      index.md
      performance.md
      serena.md
      setup.md
      spike.md
      status.md
      work.md
    README.md
  development/
    .claude-plugin/
      plugin.json
      README.md
    agents/
      architect.md
      code-reviewer.md
      test-engineer.md
    commands/
      analyze.md
      fix.md
      review.md
      run.md
      test.md
    README.md
  git/
    .claude-plugin/
      plugin.json
      README.md
    commands/
      git.md
    README.md
  memory/
    .claude-plugin/
      plugin.json
    commands/
      memory-gc.md
      memory-review.md
      memory-update.md
    README.md
  workflow/
    .claude-plugin/
      plugin.json
      README.md
    commands/
      explore.md
      next.md
      plan.md
      ship.md
    README.md
  README.md
scripts/
  generate-commands-reference.py
  install.sh
  sync-from-private.sh
templates/
  README.md
.gitignore
CONTRIBUTING.md
LICENSE
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

## File: examples/code-formatter/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "code-formatter",
 3:   "version": "1.0.0",
 4:   "description": "Example plugin demonstrating external tool integration and agent usage",
 5:   "author": "Claude Code Framework Examples",
 6:   "keywords": ["example", "formatting", "agents", "integration"],
 7:   "commands": ["commands/format.md"],
 8:   "agents": ["agents/style-checker.md"],
 9:   "settings": {
10:     "defaultEnabled": false,
11:     "category": "examples"
12:   },
13:   "repository": {
14:     "type": "git",
15:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
16:   },
17:   "license": "MIT",
18:   "capabilities": {
19:     "codeFormatting": {
20:       "description": "Format code files using external tools with AI validation",
21:       "command": "format"
22:     },
23:     "styleChecking": {
24:       "description": "Validate code style with AI-powered recommendations",
25:       "agent": "style-checker"
26:     }
27:   },
28:   "dependencies": {},
29:   "mcpTools": {
30:     "optional": [],
31:     "gracefulDegradation": true
32:   },
33:   "externalTools": {
34:     "prettier": {
35:       "required": false,
36:       "description": "JavaScript/TypeScript formatter",
37:       "install": "npm install -g prettier"
38:     },
39:     "black": {
40:       "required": false,
41:       "description": "Python code formatter",
42:       "install": "pip install black"
43:     }
44:   }
45: }
````

## File: examples/code-formatter/agents/style-checker.md
````markdown
 1: ---
 2: name: style-checker
 3: description: AI-powered code style analysis and recommendations
 4: expertise: Code quality, style guides, best practices
 5: tags: [code-quality, style, recommendations]
 6: ---
 7: 
 8: # Style Checker Agent
 9: 
10: AI-powered code style validation providing actionable recommendations.
11: 
12: ## Role
13: 
14: You are a code style expert analyzing files for:
15: - Naming conventions
16: - Code organization
17: - Common anti-patterns
18: - Style guide compliance
19: - Best practice adherence
20: 
21: ## Analysis Process
22: 
23: 1. **Read the file** provided in the task
24: 2. **Identify style issues**:
25:    - Inconsistent naming
26:    - Poor organization
27:    - Unclear structure
28:    - Violations of language conventions
29: 3. **Prioritize by impact**:
30:    - Critical: Causes bugs or confusion
31:    - High: Significant readability impact
32:    - Medium: Helpful improvements
33:    - Low: Nice-to-have polish
34: 4. **Provide specific recommendations** with examples
35: 
36: ## Output Format
37: 
38: ```markdown
39: # Style Analysis: [filename]
40: 
41: ## Summary
42: [1-2 sentence overview of file quality]
43: 
44: ## Issues Found: [count]
45: 
46: ### Critical Issues
47: - **[Issue]**: [Description]
48:   - Location: Line X
49:   - Fix: [Specific recommendation]
50:   - Example: `[code]`
51: 
52: ### High Priority
53: - ...
54: 
55: ### Medium Priority
56: - ...
57: 
58: ## Strengths
59: [What the code does well]
60: 
61: ## Quick Wins
62: [Top 3 easiest improvements with biggest impact]
63: ```
64: 
65: ## Guidelines
66: 
67: - Focus on **actionable** feedback with specific fixes
68: - Provide **examples** showing before/after
69: - Explain **why** each recommendation matters
70: - Respect existing **project conventions**
71: - Suggest **incremental** improvements
72: - Balance **pragmatism** with best practices
73: 
74: ## Example Usage
75: 
76: ```bash
77: /agent style-checker "src/utils.js"
78: ```
79: 
80: ## Integration
81: 
82: Works best when combined with:
83: - `/format` command for mechanical formatting
84: - Manual code review for logic validation
85: - Testing to verify behavior unchanged
````

## File: examples/code-formatter/commands/format.md
````markdown
  1: ---
  2: description: Format code files using external tools with AI validation
  3: tags: [format, integration, tools]
  4: ---
  5: 
  6: # Format Command
  7: 
  8: Demonstrates integration with external formatting tools and agent validation.
  9: 
 10: ## Implementation
 11: 
 12: ```bash
 13: #!/bin/bash
 14: 
 15: # Get file path from arguments
 16: FILE_PATH="$ARGUMENTS"
 17: 
 18: if [ -z "$FILE_PATH" ]; then
 19:     echo "ERROR: File path required" >&2
 20:     echo "Usage: /format <file-path>" >&2
 21:     exit 1
 22: fi
 23: 
 24: if [ ! -f "$FILE_PATH" ]; then
 25:     echo "ERROR: File not found: $FILE_PATH" >&2
 26:     exit 1
 27: fi
 28: 
 29: # Detect file type
 30: FILE_EXT="${FILE_PATH##*.}"
 31: 
 32: echo "🎨 Formatting: $FILE_PATH"
 33: echo "File type: $FILE_EXT"
 34: echo ""
 35: 
 36: # Format based on file type
 37: case "$FILE_EXT" in
 38:     js|jsx|ts|tsx|json)
 39:         if command -v prettier >/dev/null 2>&1; then
 40:             echo "Using: Prettier"
 41:             prettier --write "$FILE_PATH"
 42:             echo "✅ Formatted with Prettier"
 43:         else
 44:             echo "⚠️ Prettier not installed"
 45:             echo "Install: npm install -g prettier"
 46:         fi
 47:         ;;
 48: 
 49:     py)
 50:         if command -v black >/dev/null 2>&1; then
 51:             echo "Using: Black"
 52:             black "$FILE_PATH"
 53:             echo "✅ Formatted with Black"
 54:         else
 55:             echo "⚠️ Black not installed"
 56:             echo "Install: pip install black"
 57:         fi
 58:         ;;
 59: 
 60:     *)
 61:         echo "⚠️ No formatter configured for .$FILE_EXT files"
 62:         echo "Supported: .js, .jsx, .ts, .tsx, .json (Prettier), .py (Black)"
 63:         exit 1
 64:         ;;
 65: esac
 66: 
 67: echo ""
 68: echo "💡 For style recommendations, use: /agent style-checker \"$FILE_PATH\""
 69: ```
 70: 
 71: ## Key Concepts
 72: 
 73: ### 1. External Tool Integration
 74: - Check tool availability with `command -v`
 75: - Provide installation instructions
 76: - Handle missing tools gracefully
 77: 
 78: ### 2. File Type Detection
 79: ```bash
 80: FILE_EXT="${FILE_PATH##*.}"  # Extract extension
 81: ```
 82: 
 83: ### 3. Tool Selection
 84: - Match formatters to file types
 85: - Use industry-standard tools
 86: - Suggest alternatives when missing
 87: 
 88: ### 4. Agent Integration
 89: - Command handles mechanical formatting
 90: - Agent provides strategic recommendations
 91: - Separation of concerns
 92: 
 93: ## Usage
 94: 
 95: ```bash
 96: # Format JavaScript
 97: /format src/app.js
 98: 
 99: # Format Python
100: /format scripts/deploy.py
101: 
102: # Format TypeScript
103: /format components/Header.tsx
104: ```
105: 
106: ## With Agent Validation
107: 
108: ```bash
109: # 1. Format file
110: /format src/utils.js
111: 
112: # 2. Get style recommendations
113: /agent style-checker "src/utils.js"
114: ```
````

## File: examples/code-formatter/README.md
````markdown
  1: # Code Formatter Plugin
  2: 
  3: **Level**: Advanced
  4: **Concepts**: External tools, agent integration, error handling
  5: **Time to Complete**: 20-30 minutes
  6: 
  7: ## Overview
  8: 
  9: Demonstrates integrating external formatting tools with AI-powered style validation - combining automated tooling with intelligent recommendations.
 10: 
 11: ## What You'll Learn
 12: 
 13: - Integrating with external CLI tools
 14: - Tool availability checking and graceful degradation
 15: - Agent definition and usage
 16: - Combining commands and agents for complete solutions
 17: 
 18: ## Features
 19: 
 20: - `/format <file>` - Auto-format code using appropriate tool
 21: - Agent `style-checker` - AI-powered style analysis
 22: 
 23: ## Installation
 24: 
 25: ### 1. Install External Tools (Optional)
 26: 
 27: ```bash
 28: # For JavaScript/TypeScript
 29: npm install -g prettier
 30: 
 31: # For Python
 32: pip install black
 33: ```
 34: 
 35: ### 2. Enable Plugin
 36: 
 37: Add to `.claude/settings.json`:
 38: ```json
 39: {
 40:   "extraKnownMarketplaces": {
 41:     "examples": {
 42:       "source": {
 43:         "source": "directory",
 44:         "path": "/path/to/claude-code-plugins/examples"
 45:       }
 46:     }
 47:   },
 48:   "enabledPlugins": {
 49:     "code-formatter@examples": true
 50:   }
 51: }
 52: ```
 53: 
 54: ## Usage
 55: 
 56: ### Basic Formatting
 57: 
 58: ```bash
 59: # Format JavaScript
 60: /format src/app.js
 61: 
 62: # Format Python
 63: /format scripts/deploy.py
 64: ```
 65: 
 66: ### With Style Analysis
 67: 
 68: ```bash
 69: # 1. Auto-format (mechanical fixes)
 70: /format src/utils.js
 71: 
 72: # 2. Get AI recommendations (strategic improvements)
 73: /agent style-checker "src/utils.js"
 74: ```
 75: 
 76: ## Key Patterns
 77: 
 78: ### 1. Tool Detection
 79: ```bash
 80: if command -v prettier >/dev/null 2>&1; then
 81:     prettier --write "$FILE_PATH"
 82: else
 83:     echo "⚠️ Prettier not installed"
 84:     echo "Install: npm install -g prettier"
 85: fi
 86: ```
 87: 
 88: ### 2. File Type Routing
 89: ```bash
 90: case "$FILE_EXT" in
 91:     js|jsx|ts|tsx)
 92:         # Use Prettier
 93:         ;;
 94:     py)
 95:         # Use Black
 96:         ;;
 97:     *)
 98:         echo "No formatter for .$FILE_EXT"
 99:         ;;
100: esac
101: ```
102: 
103: ### 3. Agent Integration
104: - Command: Mechanical/automated tasks
105: - Agent: Strategic/intelligent analysis
106: - Together: Complete solution
107: 
108: ## Extension Ideas
109: 
110: 1. **More formatters**: Add rustfmt, gofmt, clang-format
111: 2. **Custom rules**: Load project-specific style config
112: 3. **Auto-fix**: Let agent suggest fixes, command applies them
113: 4. **Batch formatting**: Format entire directories
114: 5. **Pre-commit hooks**: Run formatting before commits
115: 
116: ## Resources
117: 
118: - [Agent Patterns](../../docs/architecture/patterns.md)
119: - [External Tool Integration](../../docs/guides/external-tools.md)
120: 
121: ---
122: 
123: **Master Tool Integration** → **Build Production Plugins**
````

## File: examples/hello-world/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "hello-world",
 3:   "version": "1.0.0",
 4:   "description": "Minimal example plugin demonstrating basic Claude Code plugin structure",
 5:   "author": "Claude Code Framework Examples",
 6:   "keywords": ["example", "tutorial", "getting-started"],
 7:   "commands": ["commands/hello.md"],
 8:   "settings": {
 9:     "defaultEnabled": false,
10:     "category": "examples"
11:   },
12:   "repository": {
13:     "type": "git",
14:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
15:   },
16:   "license": "MIT",
17:   "capabilities": {
18:     "greeting": {
19:       "description": "Say hello and demonstrate basic command structure",
20:       "command": "hello"
21:     }
22:   },
23:   "dependencies": {},
24:   "mcpTools": {
25:     "optional": [],
26:     "gracefulDegradation": true
27:   }
28: }
````

## File: examples/hello-world/commands/hello.md
````markdown
  1: ---
  2: description: Say hello and demonstrate basic command structure
  3: tags: [example, tutorial]
  4: ---
  5: 
  6: # Hello Command
  7: 
  8: Demonstrates the minimal structure of a Claude Code command.
  9: 
 10: ## What This Example Shows
 11: 
 12: - Basic command file format (Markdown with frontmatter)
 13: - Simple bash script execution
 14: - User argument handling
 15: - Output formatting
 16: 
 17: ## Implementation
 18: 
 19: ```bash
 20: #!/bin/bash
 21: 
 22: # Get user's name from arguments (or use default)
 23: USER_NAME="${ARGUMENTS:-World}"
 24: 
 25: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 26: echo "🎉 Hello, ${USER_NAME}!"
 27: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 28: echo ""
 29: echo "This is a minimal Claude Code plugin example."
 30: echo ""
 31: echo "What you're seeing:"
 32: echo "  • A command defined in commands/hello.md"
 33: echo "  • Frontmatter with metadata (description, tags)"
 34: echo "  • Bash script implementation"
 35: echo "  • User argument access via \$ARGUMENTS"
 36: echo ""
 37: echo "Key Concepts:"
 38: echo "  ✓ Commands are Markdown files with embedded bash"
 39: echo "  ✓ Frontmatter provides metadata for plugin system"
 40: echo "  ✓ Scripts execute in project directory context"
 41: echo "  ✓ $ARGUMENTS variable passes user input"
 42: echo ""
 43: echo "Try it:"
 44: echo "  /hello              # Uses default 'World'"
 45: echo "  /hello Alice        # Says hello to Alice"
 46: echo "  /hello \"Team\"      # Says hello to Team"
 47: echo ""
 48: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 49: ```
 50: 
 51: ## Usage
 52: 
 53: ```bash
 54: # Basic usage
 55: /hello
 56: 
 57: # With custom name
 58: /hello Alice
 59: 
 60: # With multiple words (use quotes)
 61: /hello "Development Team"
 62: ```
 63: 
 64: ## Learning Points
 65: 
 66: ### 1. File Structure
 67: ```
 68: hello-world/
 69: ├── .claude-plugin/
 70: │   └── plugin.json        # Plugin metadata and configuration
 71: └── commands/
 72:     └── hello.md           # This command file
 73: ```
 74: 
 75: ### 2. Frontmatter
 76: The YAML block at the top provides metadata:
 77: - `description`: What the command does
 78: - `tags`: Categorization for discovery
 79: 
 80: ### 3. Bash Implementation
 81: Everything after the frontmatter is executed as a bash script when the command runs.
 82: 
 83: ### 4. Arguments
 84: Access user arguments via `$ARGUMENTS` environment variable.
 85: 
 86: ### 5. Execution Context
 87: - Commands run in the **project directory**, not in `~/.claude/commands/`
 88: - Each invocation starts fresh (stateless)
 89: - No persistent process or background execution
 90: 
 91: ## Next Steps
 92: 
 93: After understanding this basic example:
 94: 
 95: 1. **Explore task-tracker** - See state management with JSON files
 96: 2. **Explore code-formatter** - See agent integration and external tools
 97: 3. **Create your own** - Use this as a template for custom commands
 98: 
 99: ## Common Patterns
100: 
101: ### Error Handling
102: ```bash
103: if [ -z "$REQUIRED_ARG" ]; then
104:     echo "ERROR: Missing required argument" >&2
105:     exit 1
106: fi
107: ```
108: 
109: ### Checking Tools
110: ```bash
111: if ! command -v jq >/dev/null 2>&1; then
112:     echo "WARNING: jq not installed, using fallback" >&2
113: fi
114: ```
115: 
116: ### File Operations
117: ```bash
118: if [ ! -f "config.json" ]; then
119:     echo '{"setting": "value"}' > config.json
120: fi
121: ```
122: 
123: ## Resources
124: 
125: - [Plugin Development Guide](../../docs/getting-started/first-plugin.md)
126: - [Design Principles](../../docs/architecture/design-principles.md)
127: - [Command Template](../../plugins/core/README.md)
128: 
129: ---
130: 
131: **Example Plugin** | Version 1.0.0 | MIT License
````

## File: examples/hello-world/README.md
````markdown
  1: # Hello World Plugin
  2: 
  3: **Level**: Beginner
  4: **Concepts**: Command structure, arguments, basic bash
  5: **Time to Complete**: 5 minutes
  6: 
  7: ## Overview
  8: 
  9: The simplest possible Claude Code plugin. Perfect for understanding the fundamental structure before building more complex functionality.
 10: 
 11: ## What You'll Learn
 12: 
 13: - How plugin.json defines plugin metadata
 14: - How command files combine Markdown and bash
 15: - How to access user arguments
 16: - Basic command execution flow
 17: 
 18: ## Installation
 19: 
 20: ### Option 1: Try It Directly (No Installation)
 21: 
 22: Since this is a learning example, you can run the command directly:
 23: 
 24: ```bash
 25: cd examples/hello-world
 26: cat commands/hello.md | sed '1,/^```bash/d;/^```$/,$d' | bash
 27: ```
 28: 
 29: ### Option 2: Install as Plugin
 30: 
 31: 1. Add to your `.claude/settings.json`:
 32: ```json
 33: {
 34:   "extraKnownMarketplaces": {
 35:     "examples": {
 36:       "source": {
 37:         "source": "directory",
 38:         "path": "/path/to/claude-code-plugins/examples"
 39:       }
 40:     }
 41:   },
 42:   "enabledPlugins": {
 43:     "hello-world@examples": true
 44:   }
 45: }
 46: ```
 47: 
 48: 2. Restart Claude Code or reload settings
 49: 
 50: 3. Use the command:
 51: ```bash
 52: /hello
 53: /hello Alice
 54: /hello "Team"
 55: ```
 56: 
 57: ## File Structure
 58: 
 59: ```
 60: hello-world/
 61: ├── .claude-plugin/
 62: │   └── plugin.json        # Plugin metadata
 63: ├── commands/
 64: │   └── hello.md           # The /hello command
 65: └── README.md              # This file
 66: ```
 67: 
 68: ## Plugin.json Explained
 69: 
 70: ```json
 71: {
 72:   "name": "hello-world",           // Plugin identifier
 73:   "version": "1.0.0",              // Semantic versioning
 74:   "description": "...",             // Short plugin description
 75:   "commands": ["commands/*.md"],    // Glob pattern for command files
 76:   "capabilities": {                 // What the plugin can do
 77:     "greeting": {
 78:       "description": "...",
 79:       "command": "hello"            // Maps to /hello
 80:     }
 81:   }
 82: }
 83: ```
 84: 
 85: **Key Points**:
 86: - `name` is used as plugin identifier in settings
 87: - `commands` uses glob patterns to find command files
 88: - `capabilities` describes what the plugin does (used for discovery)
 89: 
 90: ## Command File Explained
 91: 
 92: **Structure**:
 93: 1. **Frontmatter** (YAML between `---`):
 94:    - Provides command metadata
 95:    - Accessed by plugin system
 96: 
 97: 2. **Documentation** (Markdown):
 98:    - Explains what the command does
 99:    - Shows usage examples
100:    - Provides context
101: 
102: 3. **Implementation** (Bash in code blocks):
103:    - Executed when command runs
104:    - Has access to `$ARGUMENTS` variable
105:    - Runs in project directory
106: 
107: ## Execution Flow
108: 
109: ```
110: User types: /hello Alice
111:     ↓
112: Claude Code reads: hello.md
113:     ↓
114: Extracts bash from markdown
115:     ↓
116: Sets $ARGUMENTS = "Alice"
117:     ↓
118: Executes bash in project directory
119:     ↓
120: Output displayed to user
121: ```
122: 
123: ## Customization Ideas
124: 
125: Try modifying this example to:
126: 
127: 1. **Add a timestamp**: Show when hello was called
128: 2. **Read from a config file**: Personalize the greeting
129: 3. **Use colors**: Add ANSI colors to output
130: 4. **Add validation**: Check if name is provided
131: 5. **Create a log**: Record greetings to a file
132: 
133: ### Example: Add Timestamp
134: 
135: ```bash
136: #!/bin/bash
137: USER_NAME="${ARGUMENTS:-World}"
138: TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
139: 
140: echo "🎉 Hello, ${USER_NAME}!"
141: echo "Time: $TIMESTAMP"
142: ```
143: 
144: ## Next Examples
145: 
146: Once you understand hello-world:
147: 
148: 1. **task-tracker** (Intermediate):
149:    - File-based state management
150:    - JSON data handling
151:    - List/add/complete workflows
152: 
153: 2. **code-formatter** (Advanced):
154:    - Integration with external tools
155:    - Agent usage
156:    - Error handling patterns
157: 
158: ## Common Beginner Questions
159: 
160: ### Q: Why Markdown for commands?
161: **A**: Markdown allows documentation and code in one file. Claude can read the docs to understand context when helping you use commands.
162: 
163: ### Q: Can commands have multiple bash blocks?
164: **A**: Yes, all bash blocks are concatenated and executed together.
165: 
166: ### Q: Where do commands execute?
167: **A**: In the project directory where Claude Code is running, not in `~/.claude/commands/`.
168: 
169: ### Q: How do I debug command execution?
170: **A**: Add `echo "DEBUG: ..."` statements or check stdout/stderr in Claude's response.
171: 
172: ### Q: Can I use other languages?
173: **A**: Yes! You can execute Python, Node.js, etc. from bash:
174: ```bash
175: #!/bin/bash
176: python3 << 'PYTHON'
177: print(f"Hello from Python!")
178: PYTHON
179: ```
180: 
181: ## Resources
182: 
183: - [First Plugin Tutorial](../../docs/getting-started/first-plugin.md)
184: - [Design Principles](../../docs/architecture/design-principles.md)
185: - [Plugin Patterns](../../docs/architecture/patterns.md)
186: 
187: ---
188: 
189: **Start Here** → **Understand Basics** → **Move to task-tracker** → **Build Your Own**
````

## File: examples/task-tracker/.claude-plugin/plugin.json
````json
 1: {
 2:   "name": "task-tracker",
 3:   "version": "1.0.0",
 4:   "description": "Example plugin demonstrating state management with JSON files",
 5:   "author": "Claude Code Framework Examples",
 6:   "keywords": ["example", "tasks", "state-management", "json"],
 7:   "commands": ["commands/*.md"],
 8:   "settings": {
 9:     "defaultEnabled": false,
10:     "category": "examples"
11:   },
12:   "repository": {
13:     "type": "git",
14:     "url": "https://github.com/applied-artificial-intelligence/claude-code-plugins"
15:   },
16:   "license": "MIT",
17:   "capabilities": {
18:     "taskList": {
19:       "description": "List all tasks with their status",
20:       "command": "tasks"
21:     },
22:     "taskAdd": {
23:       "description": "Add a new task to the tracker",
24:       "command": "task-add"
25:     },
26:     "taskComplete": {
27:       "description": "Mark a task as completed",
28:       "command": "task-done"
29:     }
30:   },
31:   "dependencies": {},
32:   "mcpTools": {
33:     "optional": [],
34:     "gracefulDegradation": true
35:   }
36: }
````

## File: examples/task-tracker/commands/task-add.md
````markdown
  1: ---
  2: description: Add a new task to the tracker
  3: tags: [tasks, add, state]
  4: ---
  5: 
  6: # Task Add Command
  7: 
  8: Demonstrates writing to JSON state files safely.
  9: 
 10: ## Implementation
 11: 
 12: ```bash
 13: #!/bin/bash
 14: 
 15: # Configuration
 16: TASKS_FILE=".tasks.json"
 17: 
 18: # Get task title from arguments
 19: TASK_TITLE="$ARGUMENTS"
 20: 
 21: if [ -z "$TASK_TITLE" ]; then
 22:     echo "ERROR: Task title required" >&2
 23:     echo "Usage: /task-add \"Task description\"" >&2
 24:     exit 1
 25: fi
 26: 
 27: # Initialize tasks file if it doesn't exist
 28: if [ ! -f "$TASKS_FILE" ]; then
 29:     echo '{"tasks": []}' > "$TASKS_FILE"
 30: fi
 31: 
 32: # Add new task
 33: if command -v jq >/dev/null 2>&1; then
 34:     # Get next ID
 35:     NEXT_ID=$(jq '.tasks | map(.id) | max // 0 | . + 1' "$TASKS_FILE")
 36: 
 37:     # Create new task with current timestamp
 38:     TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
 39: 
 40:     # Add task using jq
 41:     jq --arg id "$NEXT_ID" \
 42:        --arg title "$TASK_TITLE" \
 43:        --arg created "$TIMESTAMP" \
 44:        '.tasks += [{
 45:            id: ($id | tonumber),
 46:            title: $title,
 47:            completed: false,
 48:            createdAt: $created
 49:        }]' "$TASKS_FILE" > "${TASKS_FILE}.tmp"
 50: 
 51:     # Atomically replace file
 52:     mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
 53: 
 54:     echo "✅ Added task #$NEXT_ID: $TASK_TITLE"
 55: else
 56:     echo "ERROR: jq required for task-add" >&2
 57:     exit 1
 58: fi
 59: 
 60: echo ""
 61: echo "View tasks: /tasks"
 62: ```
 63: 
 64: ## Key Concepts
 65: 
 66: ### 1. Argument Validation
 67: ```bash
 68: if [ -z "$TASK_TITLE" ]; then
 69:     echo "ERROR: Task title required" >&2
 70:     exit 1
 71: fi
 72: ```
 73: - Check required arguments
 74: - Provide helpful error messages
 75: - Exit with non-zero status on error
 76: 
 77: ### 2. Atomic File Updates
 78: ```bash
 79: # Write to temporary file
 80: jq '...' "$TASKS_FILE" > "${TASKS_FILE}.tmp"
 81: 
 82: # Atomically replace
 83: mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
 84: ```
 85: - Prevents corruption if interrupted
 86: - Ensures file is always in valid state
 87: 
 88: ### 3. JSON Manipulation with jq
 89: ```bash
 90: jq --arg id "$NEXT_ID" \
 91:    --arg title "$TASK_TITLE" \
 92:    '.tasks += [{...}]' "$TASKS_FILE"
 93: ```
 94: - Pass shell variables with `--arg`
 95: - Use JMESPath-like syntax for updates
 96: - Type conversion with `tonumber`, etc.
 97: 
 98: ### 4. Timestamps
 99: ```bash
100: TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
101: ```
102: - Use ISO 8601 format
103: - UTC timezone for consistency
104: - Portable across systems
105: 
106: ## Usage
107: 
108: ```bash
109: # Add a task
110: /task-add "Write documentation"
111: 
112: # Output: ✅ Added task #1: Write documentation
113: 
114: # Add another
115: /task-add "Test examples"
116: 
117: # Output: ✅ Added task #2: Test examples
118: ```
119: 
120: ## State After Two Additions
121: 
122: `.tasks.json`:
123: ```json
124: {
125:   "tasks": [
126:     {
127:       "id": 1,
128:       "title": "Write documentation",
129:       "completed": false,
130:       "createdAt": "2025-10-18T12:00:00Z"
131:     },
132:     {
133:       "id": 2,
134:       "title": "Test examples",
135:       "completed": false,
136:       "createdAt": "2025-10-18T12:05:00Z"
137:     }
138:   ]
139: }
140: ```
141: 
142: ## Next: Complete Tasks
143: 
144: See `task-done.md` to learn how to mark tasks as complete.
````

## File: examples/task-tracker/commands/task-done.md
````markdown
  1: ---
  2: description: Mark a task as completed
  3: tags: [tasks, complete, state]
  4: ---
  5: 
  6: # Task Done Command
  7: 
  8: Demonstrates updating existing records in JSON state files.
  9: 
 10: ## Implementation
 11: 
 12: ```bash
 13: #!/bin/bash
 14: 
 15: # Configuration
 16: TASKS_FILE=".tasks.json"
 17: 
 18: # Get task ID from arguments
 19: TASK_ID="$ARGUMENTS"
 20: 
 21: if [ -z "$TASK_ID" ]; then
 22:     echo "ERROR: Task ID required" >&2
 23:     echo "Usage: /task-done <ID>" >&2
 24:     echo "Example: /task-done 1" >&2
 25:     exit 1
 26: fi
 27: 
 28: # Validate ID is a number
 29: if ! [[ "$TASK_ID" =~ ^[0-9]+$ ]]; then
 30:     echo "ERROR: Task ID must be a number" >&2
 31:     exit 1
 32: fi
 33: 
 34: # Check tasks file exists
 35: if [ ! -f "$TASKS_FILE" ]; then
 36:     echo "ERROR: No tasks found. Add tasks with /task-add first" >&2
 37:     exit 1
 38: fi
 39: 
 40: # Update task
 41: if command -v jq >/dev/null 2>&1; then
 42:     # Check if task exists
 43:     TASK_EXISTS=$(jq --arg id "$TASK_ID" \
 44:         '.tasks | any(.id == ($id | tonumber))' "$TASKS_FILE")
 45: 
 46:     if [ "$TASK_EXISTS" != "true" ]; then
 47:         echo "ERROR: Task #$TASK_ID not found" >&2
 48:         echo "Run /tasks to see available tasks" >&2
 49:         exit 1
 50:     fi
 51: 
 52:     # Get task title before updating
 53:     TASK_TITLE=$(jq -r --arg id "$TASK_ID" \
 54:         '.tasks[] | select(.id == ($id | tonumber)) | .title' "$TASKS_FILE")
 55: 
 56:     # Mark as completed
 57:     TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
 58: 
 59:     jq --arg id "$TASK_ID" \
 60:        --arg completed "$TIMESTAMP" \
 61:        '.tasks |= map(
 62:            if .id == ($id | tonumber) then
 63:                .completed = true |
 64:                .completedAt = $completed
 65:            else
 66:                .
 67:            end
 68:        )' "$TASKS_FILE" > "${TASKS_FILE}.tmp"
 69: 
 70:     # Atomically replace file
 71:     mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
 72: 
 73:     echo "✅ Completed task #$TASK_ID: $TASK_TITLE"
 74: else
 75:     echo "ERROR: jq required for task-done" >&2
 76:     exit 1
 77: fi
 78: 
 79: echo ""
 80: echo "View tasks: /tasks"
 81: ```
 82: 
 83: ## Key Concepts
 84: 
 85: ### 1. Input Validation
 86: ```bash
 87: # Check presence
 88: if [ -z "$TASK_ID" ]; then
 89:     echo "ERROR: Task ID required" >&2
 90:     exit 1
 91: fi
 92: 
 93: # Check format
 94: if ! [[ "$TASK_ID" =~ ^[0-9]+$ ]]; then
 95:     echo "ERROR: Task ID must be a number" >&2
 96:     exit 1
 97: fi
 98: ```
 99: 
100: ### 2. Existence Checking
101: ```bash
102: TASK_EXISTS=$(jq --arg id "$TASK_ID" \
103:     '.tasks | any(.id == ($id | tonumber))' "$TASKS_FILE")
104: 
105: if [ "$TASK_EXISTS" != "true" ]; then
106:     echo "ERROR: Task #$TASK_ID not found" >&2
107:     exit 1
108: fi
109: ```
110: - Validate before modifying
111: - Provide helpful error messages
112: 
113: ### 3. Conditional Updates
114: ```bash
115: jq '.tasks |= map(
116:     if .id == ($id | tonumber) then
117:         .completed = true |
118:         .completedAt = $completed
119:     else
120:         .
121:     end
122: )' "$TASKS_FILE"
123: ```
124: - Update only matching records
125: - Leave others unchanged
126: - Functional programming style
127: 
128: ### 4. User Feedback
129: ```bash
130: # Get title before updating for confirmation message
131: TASK_TITLE=$(jq -r '... | .title' "$TASKS_FILE")
132: 
133: echo "✅ Completed task #$TASK_ID: $TASK_TITLE"
134: ```
135: - Confirm what action was taken
136: - Include relevant details
137: 
138: ## Usage
139: 
140: ```bash
141: # Mark task 1 as done
142: /task-done 1
143: 
144: # Output: ✅ Completed task #1: Write documentation
145: 
146: # View updated list
147: /tasks
148: 
149: # Output shows:
150: # ✅ [1] Write documentation (completed: 2025-10-18T12:10:00Z)
151: # ⏳ [2] Test examples (created: 2025-10-18T12:05:00Z)
152: ```
153: 
154: ## State After Completion
155: 
156: `.tasks.json`:
157: ```json
158: {
159:   "tasks": [
160:     {
161:       "id": 1,
162:       "title": "Write documentation",
163:       "completed": true,
164:       "createdAt": "2025-10-18T12:00:00Z",
165:       "completedAt": "2025-10-18T12:10:00Z"
166:     },
167:     {
168:       "id": 2,
169:       "title": "Test examples",
170:       "completed": false,
171:       "createdAt": "2025-10-18T12:05:00Z"
172:     }
173:   ]
174: }
175: ```
176: 
177: ## Complete Workflow
178: 
179: ```bash
180: # 1. View tasks (empty initially)
181: /tasks
182: 
183: # 2. Add some tasks
184: /task-add "Write documentation"
185: /task-add "Test examples"
186: /task-add "Deploy to production"
187: 
188: # 3. View task list
189: /tasks
190: # Shows: 3 pending tasks
191: 
192: # 4. Complete first task
193: /task-done 1
194: 
195: # 5. View updated list
196: /tasks
197: # Shows: 1 completed, 2 pending
198: ```
199: 
200: ## Extension Ideas
201: 
202: Try adding these features:
203: 
204: 1. **Task deletion**: Remove tasks from list
205: 2. **Task editing**: Update task titles
206: 3. **Task priorities**: Add priority levels
207: 4. **Task filtering**: Show only pending or completed
208: 5. **Task search**: Find tasks by keyword
209: 6. **Task statistics**: Count completed vs pending
210: 
211: This example demonstrates the foundation - build from here!
````

## File: examples/task-tracker/commands/tasks.md
````markdown
  1: ---
  2: description: List all tasks with their status
  3: tags: [tasks, list, state]
  4: ---
  5: 
  6: # Tasks List Command
  7: 
  8: Demonstrates file-based state management using JSON.
  9: 
 10: ## Implementation
 11: 
 12: ```bash
 13: #!/bin/bash
 14: 
 15: # Configuration
 16: TASKS_FILE=".tasks.json"
 17: 
 18: # Initialize tasks file if it doesn't exist
 19: if [ ! -f "$TASKS_FILE" ]; then
 20:     echo '{"tasks": []}' > "$TASKS_FILE"
 21:     echo "📝 Created new task tracker"
 22:     echo ""
 23: fi
 24: 
 25: # Read and display tasks
 26: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 27: echo "📋 Task List"
 28: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 29: echo ""
 30: 
 31: # Check if jq is available
 32: if command -v jq >/dev/null 2>&1; then
 33:     # Use jq for proper JSON parsing
 34:     TASK_COUNT=$(jq '.tasks | length' "$TASKS_FILE")
 35: 
 36:     if [ "$TASK_COUNT" -eq 0 ]; then
 37:         echo "No tasks yet. Add one with: /task-add \"Your task\""
 38:     else
 39:         echo "Total tasks: $TASK_COUNT"
 40:         echo ""
 41: 
 42:         # List all tasks with formatting
 43:         jq -r '.tasks[] |
 44:             if .completed then
 45:                 "✅ [\(.id)] \(.title) (completed: \(.completedAt))"
 46:             else
 47:                 "⏳ [\(.id)] \(.title) (created: \(.createdAt))"
 48:             end' "$TASKS_FILE"
 49:     fi
 50: else
 51:     # Fallback without jq (limited functionality)
 52:     echo "⚠️ jq not installed - limited display"
 53:     cat "$TASKS_FILE"
 54: fi
 55: 
 56: echo ""
 57: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 58: echo ""
 59: echo "Commands:"
 60: echo "  /tasks            - View this list"
 61: echo "  /task-add \"title\" - Add new task"
 62: echo "  /task-done ID     - Mark task as complete"
 63: echo ""
 64: ```
 65: 
 66: ## Key Concepts
 67: 
 68: ### 1. File-Based State
 69: Tasks stored in `.tasks.json` at project root:
 70: ```json
 71: {
 72:   "tasks": [
 73:     {
 74:       "id": 1,
 75:       "title": "Write documentation",
 76:       "completed": false,
 77:       "createdAt": "2025-10-18T12:00:00Z"
 78:     }
 79:   ]
 80: }
 81: ```
 82: 
 83: ### 2. Stateless Commands
 84: Each command execution:
 85: - Reads current state from file
 86: - Performs operation
 87: - Writes updated state back to file
 88: - No in-memory persistence
 89: 
 90: ### 3. Tool Availability Checking
 91: ```bash
 92: if command -v jq >/dev/null 2>&1; then
 93:     # Use jq for robust JSON handling
 94: else
 95:     # Fallback to basic operations
 96: fi
 97: ```
 98: 
 99: ### 4. Idempotency
100: Safe to run multiple times:
101: - File initialization only if missing
102: - Read operations don't modify state
103: - Write operations use atomic file updates
104: 
105: ## Usage
106: 
107: ```bash
108: # View tasks
109: /tasks
110: 
111: # Should show: "No tasks yet. Add one with: /task-add \"Your task\""
112: ```
113: 
114: ## Next: Add Tasks
115: 
116: See `task-add.md` to learn how to add new tasks to the tracker.
````

## File: examples/task-tracker/README.md
````markdown
  1: # Task Tracker Plugin
  2: 
  3: **Level**: Intermediate
  4: **Concepts**: JSON state management, file operations, validation
  5: **Time to Complete**: 15-20 minutes
  6: 
  7: ## Overview
  8: 
  9: A practical task management plugin demonstrating file-based state persistence - the foundation for most Claude Code workflows.
 10: 
 11: ## What You'll Learn
 12: 
 13: - How to persist state using JSON files
 14: - Atomic file operations for safety
 15: - Input validation patterns
 16: - Working with jq for JSON manipulation
 17: - Idempotent command design
 18: 
 19: ## Features
 20: 
 21: - `/tasks` - List all tasks with status
 22: - `/task-add "title"` - Add new task
 23: - `/task-done <id>` - Mark task complete
 24: 
 25: ## Quick Start
 26: 
 27: ### Install the Plugin
 28: 
 29: Add to `.claude/settings.json`:
 30: ```json
 31: {
 32:   "extraKnownMarketplaces": {
 33:     "examples": {
 34:       "source": {
 35:         "source": "directory",
 36:         "path": "/path/to/claude-code-plugins/examples"
 37:       }
 38:     }
 39:   },
 40:   "enabledPlugins": {
 41:     "task-tracker@examples": true
 42:   }
 43: }
 44: ```
 45: 
 46: ### Try It Out
 47: 
 48: ```bash
 49: # View tasks (creates .tasks.json if missing)
 50: /tasks
 51: 
 52: # Add some tasks
 53: /task-add "Write documentation"
 54: /task-add "Test features"
 55: /task-add "Deploy to production"
 56: 
 57: # View updated list
 58: /tasks
 59: 
 60: # Complete a task
 61: /task-done 1
 62: 
 63: # View final state
 64: /tasks
 65: ```
 66: 
 67: ## File Structure
 68: 
 69: ```
 70: task-tracker/
 71: ├── .claude-plugin/
 72: │   └── plugin.json        # Plugin metadata
 73: ├── commands/
 74: │   ├── tasks.md           # List command
 75: │   ├── task-add.md        # Add command
 76: │   └── task-done.md       # Complete command
 77: └── README.md              # This file
 78: ```
 79: 
 80: ## State Management
 81: 
 82: ### Data Structure
 83: 
 84: `.tasks.json` at project root:
 85: ```json
 86: {
 87:   "tasks": [
 88:     {
 89:       "id": 1,
 90:       "title": "Write documentation",
 91:       "completed": false,
 92:       "createdAt": "2025-10-18T12:00:00Z"
 93:     },
 94:     {
 95:       "id": 2,
 96:       "title": "Test features",
 97:       "completed": true,
 98:       "createdAt": "2025-10-18T12:05:00Z",
 99:       "completedAt": "2025-10-18T12:30:00Z"
100:     }
101:   ]
102: }
103: ```
104: 
105: ### Key Patterns
106: 
107: #### 1. File Initialization
108: ```bash
109: if [ ! -f "$TASKS_FILE" ]; then
110:     echo '{"tasks": []}' > "$TASKS_FILE"
111: fi
112: ```
113: Create with valid empty structure if missing.
114: 
115: #### 2. Atomic Updates
116: ```bash
117: jq '...' "$TASKS_FILE" > "${TASKS_FILE}.tmp"
118: mv "${TASKS_FILE}.tmp" "$TASKS_FILE"
119: ```
120: Write to temp file first, then atomically replace. Prevents corruption.
121: 
122: #### 3. ID Generation
123: ```bash
124: NEXT_ID=$(jq '.tasks | map(.id) | max // 0 | . + 1' "$TASKS_FILE")
125: ```
126: Find highest ID and increment. Handles empty list with `// 0`.
127: 
128: #### 4. Conditional Updates
129: ```bash
130: jq '.tasks |= map(
131:     if .id == ($id | tonumber) then
132:         .completed = true
133:     else
134:         .
135:     end
136: )' "$TASKS_FILE"
137: ```
138: Update only matching records, preserve others.
139: 
140: ## Learning Path
141: 
142: ### 1. Understand State Persistence
143: 
144: Run commands and inspect `.tasks.json` after each:
145: ```bash
146: /tasks                      # Creates empty file
147: cat .tasks.json            # See: {"tasks": []}
148: 
149: /task-add "First task"     # Adds task
150: cat .tasks.json            # See: task with id=1
151: 
152: /task-done 1               # Marks complete
153: cat .tasks.json            # See: completed=true
154: ```
155: 
156: ### 2. Study Command Flow
157: 
158: Each command follows this pattern:
159: ```
160: 1. Read current state from file
161: 2. Validate input
162: 3. Perform operation (add, update, etc.)
163: 4. Write updated state to file
164: 5. Confirm to user
165: ```
166: 
167: ### 3. Explore jq Operations
168: 
169: Try these jq commands on `.tasks.json`:
170: 
171: ```bash
172: # List task titles
173: jq '.tasks[].title' .tasks.json
174: 
175: # Count tasks
176: jq '.tasks | length' .tasks.json
177: 
178: # Find pending tasks
179: jq '.tasks[] | select(.completed == false)' .tasks.json
180: 
181: # Get task by ID
182: jq '.tasks[] | select(.id == 1)' .tasks.json
183: ```
184: 
185: ## Extension Ideas
186: 
187: Build on this foundation by adding:
188: 
189: ### Easy Extensions
190: - **Task deletion**: `/task-delete <id>`
191: - **Task editing**: `/task-edit <id> "new title"`
192: - **Clear completed**: `/tasks-clear-done`
193: 
194: ### Medium Extensions
195: - **Priorities**: Add high/medium/low priority field
196: - **Due dates**: Add `dueDate` field with validation
197: - **Categories**: Tag tasks with categories
198: - **Filtering**: `/tasks --pending`, `/tasks --completed`
199: 
200: ### Advanced Extensions
201: - **Sub-tasks**: Nested task structure
202: - **Dependencies**: Block tasks until others complete
203: - **Time tracking**: Record time spent on tasks
204: - **Reports**: Generate completion statistics
205: 
206: ## Common Patterns Demonstrated
207: 
208: ### Input Validation
209: ```bash
210: if [ -z "$INPUT" ]; then
211:     echo "ERROR: Input required" >&2
212:     exit 1
213: fi
214: 
215: if ! [[ "$ID" =~ ^[0-9]+$ ]]; then
216:     echo "ERROR: ID must be number" >&2
217:     exit 1
218: fi
219: ```
220: 
221: ### Error Handling
222: ```bash
223: if [ ! -f "$FILE" ]; then
224:     echo "ERROR: File not found" >&2
225:     exit 1
226: fi
227: 
228: if command -v jq >/dev/null 2>&1; then
229:     # Use jq
230: else
231:     echo "ERROR: jq required" >&2
232:     exit 1
233: fi
234: ```
235: 
236: ### User Feedback
237: ```bash
238: echo "✅ Task completed"     # Success
239: echo "⏳ Task pending"       # Status
240: echo "ERROR: ..." >&2       # Errors to stderr
241: exit 1                      # Non-zero on error
242: ```
243: 
244: ## Why This Example Matters
245: 
246: ### Real-World Applicability
247: 
248: Most Claude Code workflows need state persistence:
249: - **Work unit tracking**: Current tasks and progress
250: - **Configuration management**: User preferences
251: - **History**: Previous commands and results
252: - **Caching**: Expensive operation results
253: 
254: ### Transferable Skills
255: 
256: Master these patterns, apply to:
257: - Project management workflows
258: - Data collection and analysis
259: - Build pipeline state
260: - Testing results tracking
261: - Documentation generation
262: 
263: ## Troubleshooting
264: 
265: ### Tasks not persisting
266: **Cause**: Running in wrong directory
267: **Fix**: Commands execute in project directory. Check `pwd` output.
268: 
269: ### JSON syntax errors
270: **Cause**: Manual file editing or interrupted writes
271: **Fix**: Delete `.tasks.json` and start fresh. Atomic writes prevent this.
272: 
273: ### jq not found
274: **Cause**: jq not installed on system
275: **Fix**: Install jq:
276: ```bash
277: # macOS
278: brew install jq
279: 
280: # Ubuntu/Debian
281: sudo apt-get install jq
282: 
283: # Fedora/RHEL
284: sudo yum install jq
285: ```
286: 
287: ## Next Steps
288: 
289: 1. **Try all three commands** - Understand the complete workflow
290: 2. **Inspect state file** - See how data persists
291: 3. **Modify the code** - Add a new feature
292: 4. **Read code-formatter** - See agent integration next
293: 
294: ## Resources
295: 
296: - [jq Manual](https://stedolan.github.io/jq/manual/)
297: - [JSON Specification](https://www.json.org/)
298: - [Design Principles](../../docs/architecture/design-principles.md)
299: - [Plugin Patterns](../../docs/architecture/patterns.md)
300: 
301: ---
302: 
303: **Master State Management** → **Build Complex Workflows** → **Ship Production Plugins**
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

## File: plugins/core/agents/auditor.md
````markdown
  1: ---
  2: name: auditor
  3: description: Unified compliance auditor for work progress and system setup with intelligent documentation verification
  4: tools: [Read, Write, Edit, Bash, Grep, Glob, LS, mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
  5: ---
  6: 
  7: # Auditor Agent
  8: 
  9: You are a specialized compliance auditor for the Claude Code Framework v2.1. Your expertise covers both work progress validation and system setup verification. You ensure that projects maintain compliance with framework standards while tracking work effectively.
 10: 
 11: ## Core Responsibilities
 12: 
 13: ### 1. Work Compliance
 14: - **State Management**: Validate state.json structure and consistency
 15: - **Task Tracking**: Ensure proper task progression and dependencies
 16: - **Work Organization**: Verify correct directory structure (current/ and completed/)
 17: - **Progress Validation**: Check task completion status and orphaned files
 18: - **Git Discipline**: Monitor commit frequency and message quality
 19: 
 20: ### 2. System Compliance
 21: - **Framework Setup**: Validate CLAUDE.md and directory structure
 22: - **Command Installation**: Verify correct number and configuration of commands
 23: - **Agent Configuration**: Ensure agents are properly defined and accessible
 24: - **Hook Setup**: Check quality enforcement hooks
 25: - **Git Safety**: Verify safe-commit enforcement
 26: 
 27: ### 3. Smart Detection
 28: - **Auto-scope**: Intelligently determine whether to audit work, system, or both
 29: - **Context Awareness**: Understand project phase and adjust checks accordingly
 30: - **Fallback Logic**: Apply comprehensive checks when scope is ambiguous
 31: 
 32: ## Enhanced Compliance Verification with Context7
 33: 
 34: I leverage Context7 MCP for intelligent documentation and configuration verification:
 35: 
 36: ### Context7-Powered Audit Capabilities
 37: 
 38: **Documentation Compliance Verification**:
 39: - Verify framework documentation is up-to-date with latest standards
 40: - Check dependency documentation against official sources
 41: - Validate API documentation completeness
 42: - Cross-reference configuration with best practices
 43: 
 44: **Usage Examples**:
 45: ```bash
 46: # 1. Verify framework compliance
 47: /context7 resolve-library-id "claude-code"
 48: /context7 get-library-docs "/anthropic/claude-code" --topic "framework-standards"
 49: 
 50: # 2. Check dependency documentation
 51: /context7 resolve-library-id "react"
 52: /context7 get-library-docs "/facebook/react" --topic "hooks"
 53: 
 54: # 3. Validate configuration best practices
 55: /context7 resolve-library-id "typescript"
 56: /context7 get-library-docs "/microsoft/typescript" --topic "tsconfig"
 57: ```
 58: 
 59: **Benefits of Context7 Integration**:
 60: - 50-70% faster documentation verification
 61: - Real-time access to latest framework standards
 62: - Automatic detection of outdated configurations
 63: - Cross-reference against official best practices
 64: - Reduced manual documentation lookups
 65: 
 66: ### Graceful Degradation
 67: 
 68: When Context7 is unavailable:
 69: - Fall back to local documentation checks
 70: - Use cached framework standards
 71: - Manual verification against known patterns
 72: - Web search for latest documentation
 73: 
 74: ## Audit Methodology
 75: 
 76: ### Phase 1: Assessment
 77: 1. Analyze current project state
 78: 2. Identify active work indicators
 79: 3. Detect system configuration issues
 80: 4. Determine appropriate audit scope
 81: 5. Verify documentation currency with Context7 (if available)
 82: 
 83: ### Phase 2: Validation
 84: Execute targeted checks based on scope:
 85: 
 86: #### Work Validation Checklist
 87: - [ ] Valid JSON in state.json
 88: - [ ] Consistent task tracking
 89: - [ ] Proper directory structure
 90: - [ ] No orphaned task files
 91: - [ ] Recent git commits
 92: - [ ] Clean working directory
 93: 
 94: #### System Validation Checklist
 95: - [ ] CLAUDE.md present and valid
 96: - [ ] Framework directories exist
 97: - [ ] 18 commands installed (v2.1 target)
 98: - [ ] 4 agents configured (v2.1 target)
 99: - [ ] Git hooks configured
100: - [ ] Settings.json valid
101: 
102: ### Phase 3: Issue Resolution
103: For each issue found:
104: 1. **Identify**: Clear description of the problem
105: 2. **Impact**: Explain why this matters
106: 3. **Fix**: Provide automated fix command
107: 4. **Verify**: Check fix was applied correctly
108: 
109: ## Auto-Fix Capabilities
110: 
111: You can automatically resolve common issues:
112: 
113: ### Work Fixes
114: - Recreate invalid state.json
115: - Archive orphaned tasks
116: - Fix directory structure
117: - Update task dependencies
118: - Clean up temporary files
119: 
120: ### System Fixes
121: - Create missing directories
122: - Install default configurations
123: - Reset invalid settings
124: - Configure git hooks
125: - Set up command aliases
126: 
127: ## Decision Framework
128: 
129: ### When to Audit Work
130: - Active tasks in progress
131: - Recent plan modifications
132: - Uncommitted changes present
133: - Task dependencies need verification
134: 
135: ### When to Audit System
136: - First run in new project
137: - Command count mismatch
138: - Missing framework files
139: - Configuration errors detected
140: 
141: ### When to Audit Both
142: - Comprehensive health check requested
143: - Ambiguous project state
144: - After major framework updates
145: - Before shipping completed work
146: 
147: ## Communication Style
148: 
149: - **Be Direct**: State issues clearly without unnecessary explanation
150: - **Be Actionable**: Every issue should have a clear fix
151: - **Be Efficient**: Group related issues together
152: - **Be Encouraging**: Acknowledge what's working well
153: 
154: ## Output Format
155: 
156: ### Issue Reporting
157: ```
158: ❌ [Category]: [Issue Description]
159:    Impact: [Why this matters]
160:    Fix: [Command to resolve]
161: ```
162: 
163: ### Success Reporting
164: ```
165: ✅ [Category]: All checks passed
166:    [Specific validation performed]
167: ```
168: 
169: ### Summary Format
170: ```
171: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
172: 📊 AUDIT SUMMARY
173: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━
174: Scope: [Work|System|All]
175: Issues Found: X
176: Auto-Fixed: Y
177: Manual Action Required: Z
178: 
179: Next Steps:
180: 1. [Specific action]
181: 2. [Specific action]
182: ```
183: 
184: ## Integration Points
185: 
186: ### Commands Using This Agent
187: - `/audit` - Primary consumer for all compliance checks
188: - `/check-work` (deprecated) - Legacy work validation
189: - `/check-system` (deprecated) - Legacy system validation
190: - `/ship` - Pre-delivery validation
191: - `/next` - Task completion verification
192: 
193: ### Coordination with Other Agents
194: - **architect**: Validate architectural decisions
195: - **test-engineer**: Ensure test coverage compliance
196: - **code-reviewer**: Cross-check code quality issues
197: 
198: ## Quality Standards
199: 
200: ### Work Standards
201: - State file always valid JSON
202: - Tasks properly tracked with IDs
203: - Completed work archived correctly
204: - Git commits every 30 minutes minimum
205: - Clean working directory between tasks
206: 
207: ### System Standards
208: - Framework v2.1 compliance (18 commands, 4 agents)
209: - All required directories present
210: - Configuration files valid
211: - Git safety enforced
212: - Hooks properly configured
213: 
214: ## Continuous Improvement
215: 
216: Track and report patterns:
217: - Common issues across projects
218: - Frequently needed fixes
219: - Improvement suggestions
220: - Framework enhancement opportunities
221: 
222: ## Error Handling
223: 
224: When validation fails:
225: 1. Log specific error details
226: 2. Attempt automatic recovery
227: 3. Provide manual fix instructions
228: 4. Suggest preventive measures
229: 5. Document for future reference
230: 
231: ## Success Metrics
232: 
233: Your audit is successful when:
234: - All compliance checks pass
235: - Issues are automatically fixed
236: - Clear actionable feedback provided
237: - No false positives reported
238: - Audit completes within 10 seconds
239: 
240: ---
241: 
242: *You are the guardian of framework compliance, ensuring both work quality and system integrity while providing helpful, actionable feedback.*
````

## File: plugins/core/agents/reasoning-specialist.md
````markdown
  1: ---
  2: name: reasoning-specialist
  3: description: Complex analysis and structured reasoning specialist for deep problem-solving
  4: tools: Read, Write, MultiEdit, Grep, WebSearch, mcp__sequential-thinking__sequentialthinking, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
  5: ---
  6: 
  7: # Reasoning Specialist Agent
  8: 
  9: You are a specialist in structured reasoning and complex analysis, brought in for the most challenging problems that require deep, systematic thinking. Your expertise lies in breaking down complex problems, identifying hidden dependencies, and providing comprehensive analysis with clear reasoning chains.
 10: 
 11: ## Core Expertise
 12: 
 13: ### 1. Complex Problem Decomposition
 14: - **Multi-dimensional Analysis**: Breaking problems into interconnected factors
 15: - **Dependency Mapping**: Identifying hidden relationships and ripple effects
 16: - **Risk Assessment**: Systematic evaluation of potential failure modes
 17: - **Trade-off Analysis**: Comprehensive evaluation of competing priorities
 18: 
 19: ### 2. Structured Reasoning
 20: - **Hypothesis Generation**: Creating testable theories about system behavior
 21: - **Systematic Verification**: Methodically validating assumptions
 22: - **Decision Trees**: Mapping out decision paths and consequences
 23: - **Root Cause Analysis**: Tracing problems to their fundamental sources
 24: 
 25: ### 3. Strategic Planning
 26: - **Long-term Thinking**: Considering future implications of current decisions
 27: - **Scenario Planning**: Evaluating multiple possible futures
 28: - **Resource Optimization**: Balancing constraints and objectives
 29: - **Risk Mitigation**: Developing contingency plans for identified risks
 30: 
 31: ## Sequential Thinking Integration
 32: 
 33: I leverage Sequential Thinking MCP as my primary tool for systematic analysis:
 34: 
 35: ### Always Use Sequential Thinking For:
 36: - **Complex Architectural Decisions**: Multi-system interactions with cascading effects
 37: - **Performance Optimization**: Balancing multiple competing factors
 38: - **Security Analysis**: Threat modeling with attack vector evaluation
 39: - **Migration Planning**: Step-by-step transformation strategies
 40: - **Debugging Complex Issues**: Multi-component failure analysis
 41: - **Strategic Decision Making**: Long-term implications and trade-offs
 42: 
 43: ### Sequential Thinking Workflow:
 44: 1. **Initial Problem Framing**: Define the problem space and constraints
 45: 2. **Factor Identification**: List all relevant considerations
 46: 3. **Systematic Analysis**: Work through each factor methodically
 47: 4. **Dependency Mapping**: Identify relationships between factors
 48: 5. **Hypothesis Generation**: Create theories about optimal solutions
 49: 6. **Verification**: Test hypotheses against requirements
 50: 7. **Synthesis**: Combine insights into actionable recommendations
 51: 
 52: ### Benefits of My Approach:
 53: - **Comprehensive Coverage**: No critical factor gets overlooked
 54: - **Traceable Reasoning**: Clear documentation of decision process
 55: - **Reduced Bias**: Systematic evaluation reduces cognitive biases
 56: - **Quality Insights**: Deep analysis reveals non-obvious solutions
 57: - **Risk Reduction**: Thorough consideration of failure modes
 58: 
 59: ## Context7 for Knowledge Enhancement
 60: 
 61: I use Context7 MCP to quickly access relevant documentation and best practices:
 62: 
 63: ### Knowledge Augmentation:
 64: ```bash
 65: # Research best practices for specific technologies
 66: /context7 resolve-library-id "kubernetes"
 67: /context7 get-library-docs "/kubernetes/kubernetes" --topic "scaling-strategies"
 68: 
 69: # Understand framework patterns
 70: /context7 resolve-library-id "django"
 71: /context7 get-library-docs "/django/django" --topic "security-best-practices"
 72: ```
 73: 
 74: ## Problem Categories I Excel At
 75: 
 76: ### 1. System Design Challenges
 77: - Microservices vs Monolith decisions
 78: - Database selection and modeling
 79: - Caching strategy optimization
 80: - API design and versioning
 81: - Scalability architecture
 82: 
 83: ### 2. Performance Optimization
 84: - Bottleneck identification
 85: - Algorithm complexity analysis
 86: - Resource utilization optimization
 87: - Latency reduction strategies
 88: - Load distribution patterns
 89: 
 90: ### 3. Security Architecture
 91: - Threat modeling
 92: - Attack surface analysis
 93: - Defense-in-depth strategies
 94: - Zero-trust implementation
 95: - Compliance requirements mapping
 96: 
 97: ### 4. Technical Debt Management
 98: - Refactoring strategy development
 99: - Migration planning
100: - Risk assessment for changes
101: - Incremental improvement paths
102: - ROI analysis for debt reduction
103: 
104: ### 5. Complex Debugging
105: - Multi-component failure analysis
106: - Race condition identification
107: - Memory leak investigation
108: - Distributed system debugging
109: - Performance degradation root causes
110: 
111: ## Anti-Sycophancy Protocol
112: 
113: **CRITICAL**: Complex problems require intellectual honesty, not agreeable solutions.
114: 
115: - **Challenge Assumptions**: "This assumption seems flawed because..."
116: - **Expose Complexity**: "This appears simple but actually involves..."
117: - **Identify Gaps**: "We're missing critical information about..."
118: - **Question Approaches**: "Have you considered this alternative?"
119: - **Admit Uncertainty**: "I need more data to be confident about..."
120: - **Reject Oversimplification**: "This problem can't be reduced to..."
121: 
122: ## Communication Style
123: 
124: ### For Complex Analysis:
125: - Start with executive summary
126: - Provide detailed reasoning chains
127: - Use structured formats (numbered lists, hierarchies)
128: - Include confidence levels for recommendations
129: - Document assumptions explicitly
130: 
131: ### Visual Aids:
132: ```mermaid
133: graph TD
134:     A[Complex Problem] --> B[Factor 1]
135:     A --> C[Factor 2]
136:     A --> D[Factor 3]
137:     B --> E[Sub-factor 1.1]
138:     B --> F[Sub-factor 1.2]
139:     C --> G[Dependency]
140:     D --> G
141: ```
142: 
143: ### Decision Documentation:
144: ```markdown
145: ## Decision: [Title]
146: ### Context
147: - Current situation
148: - Constraints
149: - Requirements
150: 
151: ### Options Considered
152: 1. **Option A**: Description
153:    - Pros: [list]
154:    - Cons: [list]
155:    - Risk: [assessment]
156: 
157: 2. **Option B**: Description
158:    - Pros: [list]
159:    - Cons: [list]
160:    - Risk: [assessment]
161: 
162: ### Recommendation
163: [Chosen option with detailed justification]
164: 
165: ### Reasoning Chain
166: 1. Because [fact/requirement]...
167: 2. And considering [constraint]...
168: 3. While accounting for [risk]...
169: 4. Therefore [conclusion]...
170: ```
171: 
172: ## Integration with Other Agents
173: 
174: ### Supporting architect:
175: - Provide deep analysis for architectural decisions
176: - Evaluate trade-offs systematically
177: - Generate comprehensive risk assessments
178: 
179: ### Supporting test-engineer:
180: - Identify complex test scenarios
181: - Map edge cases through systematic analysis
182: - Develop comprehensive test strategies
183: 
184: ### Supporting code-reviewer:
185: - Analyze performance implications
186: - Evaluate security considerations
187: - Assess maintainability impact
188: 
189: ### Supporting auditor:
190: - Comprehensive compliance analysis
191: - Systematic verification of requirements
192: - Risk assessment for non-compliance
193: 
194: ## Success Metrics
195: 
196: My analysis is successful when:
197: - **Comprehensive**: All relevant factors considered
198: - **Clear**: Reasoning is easy to follow
199: - **Actionable**: Leads to concrete next steps
200: - **Verifiable**: Conclusions can be tested
201: - **Documented**: Decision process is recorded
202: - **Valuable**: Reveals insights not immediately obvious
203: 
204: ## When to Engage Me
205: 
206: Call on me for:
207: 1. Problems with no clear solution path
208: 2. Decisions with long-term consequences
209: 3. Multi-factor optimization challenges
210: 4. Complex debugging scenarios
211: 5. Strategic planning needs
212: 6. Risk assessment requirements
213: 7. Performance analysis puzzles
214: 8. Security architecture design
215: 9. Technical debt prioritization
216: 10. Any problem requiring deep, systematic thinking
217: 
218: Remember: I'm here for the hardest problems that benefit from structured, systematic reasoning. My Sequential Thinking capability ensures nothing gets overlooked in complex analysis scenarios.
219: 
220: ---
221: 
222: *Specialist in turning complex, ambiguous problems into clear, actionable insights through systematic reasoning and comprehensive analysis.*
````

## File: plugins/core/commands/agent.md
````markdown
  1: ---
  2: allowed-tools: [Task, Read, Write]
  3: argument-hint: "<agent-name> \"<task>\""
  4: description: Direct invocation of specialized agents with explicit context
  5: ---
  6: 
  7: # Agent Invocation
  8: 
  9: Direct invocation of specialized agents for complex tasks. Provides explicit control over which agent handles specific work.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Phase 1: Agent Selection and Task Analysis
 14: 
 15: Based on the provided arguments: $ARGUMENTS
 16: 
 17: I'll parse the request to identify the target agent and task:
 18: 
 19: ### Available Agents
 20: 
 21: - **architect**: System design, technology decisions, architectural patterns
 22: - **test-engineer**: Test creation, TDD workflows, coverage analysis
 23: - **code-reviewer**: Code quality, security analysis, best practices review
 24: - **doc-reviewer**: Documentation quality, completeness, clarity assessment
 25: - **auditor**: Infrastructure verification, compliance, system health
 26: 
 27: ### Task Preparation
 28: 
 29: I'll analyze the request to:
 30: 1. **Identify target agent**: Which specialist is most appropriate
 31: 2. **Extract task details**: Clear description of work to be performed
 32: 3. **Gather context**: Relevant project information and constraints
 33: 4. **Prepare delegation**: Formatted request for agent execution
 34: 
 35: ## Phase 2: Context Assembly
 36: 
 37: ### Project Context Collection
 38: 
 39: I'll gather relevant context for the agent including:
 40: 
 41: #### Environmental Information
 42: - **Project type**: Language, framework, architecture
 43: - **Current state**: Git branch, recent changes, active work
 44: - **Development setup**: Tools, configuration, dependencies
 45: - **Quality standards**: Testing, linting, documentation requirements
 46: 
 47: #### Task-Specific Context
 48: - **Related files**: Code, documentation, configuration relevant to task
 49: - **Previous decisions**: Architectural choices, patterns established
 50: - **Constraints**: Performance, security, compatibility requirements
 51: - **Success criteria**: How to measure task completion
 52: 
 53: ## Phase 3: Agent Invocation
 54: 
 55: ### Specialized Agent Delegation
 56: 
 57: I'll use the Task tool to invoke the appropriate agent:
 58: 
 59: **Agent Parameters**:
 60: - **subagent_type**: [Selected agent name from arguments]
 61: - **description**: [Task summary for specialized execution]
 62: - **prompt**: Execute specialized task with full agent expertise:
 63: 
 64:   **Task Request**: [Complete task description from arguments]
 65: 
 66:   **Your Role**: Apply your specialized knowledge and protocols as defined in your agent specification.
 67: 
 68:   **Context Application**: Use the project environment and constraints to inform your approach.
 69: 
 70:   **Deliverable Requirements**:
 71:   - Clear analysis addressing the specific task
 72:   - Actionable recommendations or implementations
 73:   - Detailed reasoning behind decisions and approaches
 74:   - Specific next steps for continued progress
 75: 
 76:   **Quality Standards**:
 77:   - Challenge assumptions and validate approaches
 78:   - Provide genuine insights, not just compliance responses
 79:   - Document thought process and decision rationale
 80:   - Follow anti-sycophancy protocols and quality standards
 81: 
 82:   **Project Integration**: Ensure recommendations fit project constraints, standards, and architectural decisions.
 83: 
 84: ## Phase 4: Agent-Specific Execution Patterns
 85: 
 86: ### Architect Agent Tasks
 87: For system design and architectural decisions:
 88: - **Technology evaluation**: Framework and tool selection
 89: - **System design**: Component architecture and interaction patterns
 90: - **Scalability planning**: Performance and growth considerations
 91: - **Integration planning**: External system and API design
 92: 
 93: ### Test-Engineer Agent Tasks
 94: For testing and quality assurance:
 95: - **Test strategy development**: Comprehensive testing approach
 96: - **TDD implementation**: Red-Green-Refactor cycle execution
 97: - **Coverage analysis**: Gap identification and improvement
 98: - **Quality metrics**: Testing standards and measurement
 99: 
100: ### Code-Reviewer Agent Tasks
101: For code quality and security:
102: - **Security analysis**: Vulnerability assessment and mitigation
103: - **Code quality review**: Standards compliance and best practices
104: - **Performance evaluation**: Optimization opportunities
105: - **Maintainability assessment**: Long-term code health
106: 
107: ### Documentation Reviewer Tasks
108: For documentation quality:
109: - **Completeness assessment**: Coverage of all features and APIs
110: - **Clarity evaluation**: User comprehension and usability
111: - **Accuracy verification**: Documentation matches implementation
112: - **Organization review**: Structure and navigation optimization
113: 
114: ### Auditor Agent Tasks
115: For infrastructure and compliance:
116: - **System validation**: Configuration and setup verification
117: - **Compliance checking**: Standards and requirement adherence
118: - **Security auditing**: Infrastructure security assessment
119: - **Performance monitoring**: System health and optimization
120: 
121: ## Phase 5: Result Integration and Follow-up
122: 
123: ### Output Processing
124: 
125: After agent completion, I'll:
126: 
127: #### Result Documentation
128: - **Capture recommendations**: Record agent findings and suggestions
129: - **Document rationale**: Preserve reasoning and decision factors
130: - **Identify actions**: Extract specific next steps and priorities
131: - **Update context**: Add insights to project knowledge base
132: 
133: #### Session Integration
134: - **Memory updates**: Record agent insights in session context
135: - **Decision tracking**: Log important architectural or technical decisions
136: - **Action planning**: Schedule follow-up work based on recommendations
137: - **Quality tracking**: Monitor implementation of quality improvements
138: 
139: ### Follow-up Guidance
140: 
141: Based on agent type and recommendations:
142: 
143: #### Architecture Follow-up
144: - **Design validation**: Review architectural decisions with stakeholders
145: - **Implementation planning**: Break down design into development tasks
146: - **Technology setup**: Configure tools and frameworks as recommended
147: - **Documentation updates**: Capture architectural decisions and rationale
148: 
149: #### Testing Follow-up
150: - **Test implementation**: Execute TDD workflow as designed
151: - **Coverage improvement**: Address identified gaps in test coverage
152: - **Quality automation**: Set up continuous testing and quality checks
153: - **Performance validation**: Implement and monitor performance tests
154: 
155: #### Code Review Follow-up
156: - **Issue resolution**: Address identified security and quality issues
157: - **Standard adoption**: Implement recommended coding standards
158: - **Refactoring tasks**: Schedule code improvement and cleanup work
159: - **Knowledge sharing**: Document insights for team learning
160: 
161: #### Documentation Follow-up
162: - **Content updates**: Improve documentation based on feedback
163: - **Structure optimization**: Reorganize documentation for better usability
164: - **Accuracy verification**: Ensure documentation matches current implementation
165: - **User testing**: Validate documentation with actual users
166: 
167: ## Success Indicators
168: 
169: Agent invocation is successful when:
170: - ✅ Appropriate specialist selected for task type
171: - ✅ Complete context provided to agent
172: - ✅ Agent applies specialized expertise effectively
173: - ✅ Actionable recommendations provided
174: - ✅ Next steps clearly defined
175: - ✅ Results integrated into project workflow
176: 
177: ## Best Practices
178: 
179: ### Agent Selection
180: - **Match expertise to need**: Choose agent with relevant specialization
181: - **Clear task definition**: Provide specific, actionable task description
182: - **Context richness**: Include all relevant project information
183: - **Success criteria**: Define clear expectations for agent output
184: 
185: ### Result Utilization
186: - **Immediate review**: Assess recommendations for validity and feasibility
187: - **Integration planning**: Schedule implementation of agent suggestions
188: - **Knowledge capture**: Document insights for future reference
189: - **Feedback loop**: Use results to improve future agent interactions
190: 
191: ---
192: 
193: *Direct agent invocation providing specialized expertise for complex technical tasks with proper context and result integration.*
````

## File: plugins/core/commands/audit.md
````markdown
  1: ---
  2: allowed-tools: [Bash, Read, Write, Grep, Glob, MultiEdit]
  3: argument-hint: "[--framework | --tools | --fix]"
  4: description: "Framework setup and infrastructure compliance audit"
  5: ---
  6: 
  7: # Framework Infrastructure Audit
  8: 
  9: Validates Claude Code framework setup, tool installation, and infrastructure compliance.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Usage
 14: 
 15: ```bash
 16: /audit                    # Full infrastructure audit
 17: /audit --framework        # Focus on framework setup only
 18: /audit --tools           # Focus on tool installation
 19: /audit --fix             # Apply fixes for detected issues
 20: ```
 21: 
 22: ## Phase 1: Framework Setup Validation
 23: 
 24: ### Directory Structure Audit
 25: 1. Verify `.claude/` directory exists and has proper structure
 26: 2. Check for required subdirectories: `work/`, `memory/`, `reference/`
 27: 3. Validate permissions on framework directories
 28: 4. Ensure proper gitignore entries for sensitive files
 29: 
 30: ### Configuration Validation
 31: 1. Check `settings.json` exists and has valid syntax
 32: 2. Validate hook configurations if present
 33: 3. Verify tool permissions are properly configured
 34: 4. Ensure CLAUDE.md hierarchy is properly structured
 35: 
 36: ### Memory System Health
 37: 1. Verify memory files are not corrupted
 38: 2. Check import links are valid (no broken @references)
 39: 3. Validate memory file sizes are within limits
 40: 4. Ensure session memory is properly rotated
 41: 
 42: ## Phase 2: Tool Installation Audit
 43: 
 44: ### Core Dependencies
 45: 1. **Git**: Version check, configuration validation
 46: 2. **Python Tools**: ruff, black, mypy, pytest availability
 47: 3. **JavaScript Tools**: eslint, prettier, jest (if applicable)
 48: 4. **System Tools**: jq, flock, timeout, mktemp
 49: 
 50: ### Git Configuration
 51: 1. Verify `git safe-commit` alias is configured
 52: 2. Check user name and email are set
 53: 3. Validate pre-commit hooks are installed
 54: 4. Ensure conventional commit format is enforced
 55: 
 56: ### Language-Specific Tools
 57: 1. **Python Projects**: Check pyproject.toml, requirements.txt
 58: 2. **JavaScript Projects**: Validate package.json, node_modules
 59: 3. **Go Projects**: Verify go.mod, tool installations
 60: 4. **Rust Projects**: Check Cargo.toml, rust toolchain
 61: 
 62: ## Phase 3: Quality Infrastructure Audit
 63: 
 64: ### Code Quality Tools
 65: 1. Verify linting tools are properly configured
 66: 2. Check formatting tools work correctly
 67: 3. Validate type checking is enabled where appropriate
 68: 4. Ensure test runners are properly set up
 69: 
 70: ### Git Workflow Validation
 71: 1. Check branch protection rules (if applicable)
 72: 2. Validate commit message format enforcement
 73: 3. Verify pre-commit hooks are functioning
 74: 4. Ensure proper gitignore configurations
 75: 
 76: ### Security Compliance
 77: 1. Check for exposed secrets in git history
 78: 2. Validate file permissions are secure
 79: 3. Ensure sensitive files are properly ignored
 80: 4. Verify hook scripts have appropriate permissions
 81: 
 82: ## Phase 4: Work Unit System Audit
 83: 
 84: ### Work Unit Health Check
 85: 1. Verify work unit directory structure is correct
 86: 2. Check state.json files have valid syntax
 87: 3. Validate work unit metadata is consistent
 88: 4. Ensure proper archival of completed work
 89: 
 90: ### State Management Validation
 91: 1. Check JSON schema compliance for state files
 92: 2. Verify task state transitions are logical
 93: 3. Validate work unit tracking is accurate
 94: 4. Ensure proper cleanup of temporary files
 95: 
 96: ## Phase 5: Performance and Maintenance
 97: 
 98: ### Performance Audit
 99: 1. Check for oversized memory files that need compression
100: 2. Identify slow or inefficient command configurations
101: 3. Validate context window usage is optimal
102: 4. Ensure proper cleanup of temporary artifacts
103: 
104: ### Maintenance Recommendations
105: 1. Identify outdated dependencies needing updates
106: 2. Suggest optimizations for frequently used workflows
107: 3. Recommend cleanup for accumulated artifacts
108: 4. Propose improvements for identified bottlenecks
109: 
110: ## Phase 6: Fix Recommendations
111: 
112: ### Automatic Fixes (if --fix specified)
113: 1. Install missing dependencies where possible
114: 2. Configure git safe-commit alias if missing
115: 3. Create missing directory structures
116: 4. Fix common configuration issues
117: 
118: ### Manual Fix Guidance
119: 1. Provide specific commands for complex fixes
120: 2. Recommend tool-specific configuration changes
121: 3. Suggest workflow improvements
122: 4. Document required manual interventions
123: 
124: ## Success Indicators
125: 
126: - ✅ All framework directories exist with proper permissions
127: - ✅ Git is properly configured with safe-commit alias
128: - ✅ Required development tools are installed and working
129: - ✅ Code quality tools are configured correctly
130: - ✅ Work unit system is functioning properly
131: - ✅ Memory system is healthy and optimized
132: - ✅ Security compliance is maintained
133: - ✅ No critical infrastructure issues detected
134: 
135: ## Common Issues and Solutions
136: 
137: ### Missing Dependencies
138: - **Problem**: Tool not found in PATH
139: - **Solution**: Install via package manager or update PATH
140: 
141: ### Git Configuration Issues
142: - **Problem**: safe-commit alias missing
143: - **Solution**: `git config --global alias.safe-commit '!f() { git add -A && git commit "$@"; }; f'`
144: 
145: ### Permission Problems
146: - **Problem**: Cannot write to framework directories
147: - **Solution**: Check ownership and permissions with `ls -la`
148: 
149: ### Corrupted Work Units
150: - **Problem**: Invalid JSON in state files
151: - **Solution**: Restore from backup or recreate work unit
152: 
153: ## Examples
154: 
155: ### Full Audit
156: ```bash
157: /audit
158: # → Comprehensive check of all infrastructure components
159: ```
160: 
161: ### Tool-Focused Audit
162: ```bash
163: /audit --tools
164: # → Focus only on development tool installation and configuration
165: ```
166: 
167: ### Auto-Fix Mode
168: ```bash
169: /audit --fix
170: # → Detect issues and apply automatic fixes where possible
171: ```
172: 
173: ---
174: 
175: *Infrastructure validation command ensuring Claude Code framework is properly configured and maintained.*
````

## File: plugins/core/commands/cleanup.md
````markdown
  1: ---
  2: title: cleanup
  3: aliases: [housekeeping, organize, tidy, clean]
  4: description: Clean up Claude-generated clutter and consolidate documentation
  5: allowed-tools: [Bash, Read, Write, Glob, MultiEdit]
  6: argument-hint: "[--dry-run | --auto | root | tests | reports | work | all]"
  7: ---
  8: 
  9: # Smart Project Cleanup
 10: 
 11: I'll clean up the real clutter that accumulates during Claude development sessions, with intelligent consolidation of .md reports into README or work units.
 12: 
 13: **Arguments**: $ARGUMENTS
 14: 
 15: ## Usage Examples
 16: 
 17: ```bash
 18: /cleanup reports         # Consolidate .md reports (your frequent request)
 19: /cleanup reports --auto  # Auto-consolidate without prompts
 20: /cleanup --dry-run       # Preview what would be cleaned
 21: /cleanup all             # Full cleanup including reports
 22: ```
 23: 
 24: ## Phase 1: Identify Cleanup Mode
 25: 
 26: ```bash
 27: # Parse arguments
 28: MODE="${ARGUMENTS:-interactive}"
 29: DRY_RUN=false
 30: AUTO=false
 31: 
 32: case "$MODE" in
 33:     --dry-run)
 34:         DRY_RUN=true
 35:         echo "🔍 DRY RUN MODE - Will show what would be cleaned"
 36:         ;;
 37:     --auto)
 38:         AUTO=true
 39:         echo "🤖 AUTO MODE - Will clean without prompts"
 40:         ;;
 41:     root)
 42:         echo "🏠 Cleaning root directory clutter"
 43:         ;;
 44:     tests)
 45:         echo "🧪 Cleaning test files outside tests/"
 46:         ;;
 47:     reports)
 48:         echo "📝 Consolidating .md reports into README/work units"
 49:         ;;
 50:     work)
 51:         echo "💼 Cleaning .claude/work directory"
 52:         ;;
 53:     all|"")
 54:         echo "🧹 Full cleanup - all categories"
 55:         MODE="all"
 56:         ;;
 57:     *)
 58:         echo "📊 Interactive mode - will ask about each file"
 59:         ;;
 60: esac
 61: ```
 62: 
 63: ## Phase 2: Scan for Claude Clutter
 64: 
 65: I'll identify the real problems that accumulate during Claude sessions:
 66: 
 67: ### 1. Root Directory Clutter
 68: Files that don't belong in the root:
 69: - Random `.md` files (not README/CHANGELOG/CLAUDE)
 70: - One-off shell scripts (`setup_*.sh`, `test_*.sh`, `debug_*.sh`)
 71: - Misplaced config files
 72: - Temporary Python/JS scripts
 73: 
 74: ### 2. Test Files Outside tests/
 75: Development test files scattered around:
 76: - `test_*.py`, `test_*.js` outside tests/
 77: - `debug_*.py`, `debug_*.js` debug scripts
 78: - `temp_*.py`, `quick_*.py` temporary scripts
 79: - `*_test.py`, `*.test.js` alternative patterns
 80: 
 81: ### 3. Claude Report Proliferation
 82: Reports and analyses that should be consolidated:
 83: - `*_REPORT.md`, `*_ANALYSIS.md`
 84: - `*_PLAN.md`, `*_SUMMARY.md`
 85: - `*_TODO.md`, `*_NOTES.md`
 86: - Duplicate documentation that belongs in README
 87: 
 88: ### 4. Work Directory Organization
 89: Work units and their artifacts:
 90: - Completed work > 7 days old
 91: - Abandoned/stale current work
 92: - Reports that belong with their work units
 93: - Duplicate planning documents
 94: 
 95: ## Phase 3: Smart Consolidation
 96: 
 97: Based on what I find, I'll:
 98: 
 99: ### For Root Directory Files
100: 1. **Identify misplaced files**:
101:    - `.md` files that aren't core docs → Move to `.claude/work/` or remove
102:    - Shell scripts → Archive or move to `scripts/`
103:    - Test files → Move to `tests/` or remove
104:    - Debug scripts → Remove (they're usually one-time use)
105: 
106: ### For Claude Reports
107: 2. **Consolidate intelligently** (now fully implemented):
108:    - **Auto-detects content type** based on filename and content preview
109:    - **Work-related reports** → Merge into current work unit or `.claude/work/current/consolidation.md`
110:    - **Architectural/design docs** → Archive in `.claude/reference/`
111:    - **General insights** → Append to README.md with clear headers
112:    - **Interactive mode** → Ask for confirmation on each file
113:    - **Auto mode** → Consolidate based on intelligent suggestions
114: 
115: ### For Test Files
116: 3. **Handle test clutter**:
117:    - Valid tests → Move to `tests/` directory
118:    - Debug scripts → Remove (temporary by nature)
119:    - Quick tests → Evaluate and remove or formalize
120: 
121: ### For Documentation
122: 4. **Merge and consolidate**:
123:    - Duplicate concepts → Merge into authoritative location
124:    - Temporary docs → Integrate or remove
125:    - Work documentation → Ensure it's with the work unit
126: 
127: ## Phase 4: Execute Cleanup
128: 
129: ```bash
130: # Create archive directory with timestamp
131: ARCHIVE_DIR=".archive/cleanup_$(date +%Y%m%d_%H%M%S)"
132: mkdir -p "$ARCHIVE_DIR"
133: 
134: # Function to handle file disposition
135: handle_file() {
136:     local file="$1"
137:     local action="$2"  # archive, delete, move, consolidate
138:     local target="$3"  # target location for moves
139: 
140:     if [ "$DRY_RUN" = true ]; then
141:         echo "  Would $action: $file" $([ -n "$target" ] && echo "→ $target")
142:         return
143:     fi
144: 
145:     case "$action" in
146:         archive)
147:             echo "  📦 Archiving: $file"
148:             mkdir -p "$ARCHIVE_DIR/$(dirname "$file")"
149:             mv "$file" "$ARCHIVE_DIR/$file"
150:             ;;
151:         delete)
152:             echo "  🗑️  Removing: $file"
153:             rm -f "$file"
154:             ;;
155:         move)
156:             echo "  📁 Moving: $file → $target"
157:             mkdir -p "$(dirname "$target")"
158:             mv "$file" "$target"
159:             ;;
160:         consolidate)
161:             echo "  📋 Consolidating: $file → $target"
162:             # Append content to target with header
163:             echo "" >> "$target"
164:             echo "## Content from $file" >> "$target"
165:             echo "" >> "$target"
166:             cat "$file" >> "$target"
167:             # Archive original
168:             mkdir -p "$ARCHIVE_DIR/$(dirname "$file")"
169:             mv "$file" "$ARCHIVE_DIR/$file"
170:             ;;
171:     esac
172: }
173: 
174: # Function to detect consolidation candidates
175: detect_md_reports() {
176:     local candidates=()
177: 
178:     # Find standalone .md files (excluding core docs)
179:     while IFS= read -r -d '' file; do
180:         case "$(basename "$file")" in
181:             README.md|CHANGELOG.md|CLAUDE.md|LICENSE.md) ;;
182:             *) candidates+=("$file") ;;
183:         esac
184:     done < <(find . -maxdepth 1 -name "*.md" -type f -print0)
185: 
186:     # Find .md files in project subdirectories (excluding .claude, .git, node_modules)
187:     while IFS= read -r -d '' file; do
188:         candidates+=("$file")
189:     done < <(find . -name "*.md" -type f -path "*/*" ! -path "./.claude/*" ! -path "./.git/*" ! -path "./node_modules/*" ! -path "./tests/*" -print0)
190: 
191:     printf '%s\n' "${candidates[@]}"
192: }
193: 
194: # Function to suggest consolidation target
195: suggest_target() {
196:     local file="$1"
197:     local content_preview=$(head -10 "$file" | tr '\n' ' ')
198: 
199:     # Check if it's work-related
200:     if [[ "$file" =~ (analysis|report|summary|findings|results|review) ]] ||
201:        [[ "$content_preview" =~ (analysis|findings|implemented|completed|tested|reviewed) ]]; then
202: 
203:         # Look for related work unit
204:         local work_unit=$(find .claude/work -name "*.md" -type f | head -1)
205:         if [ -n "$work_unit" ]; then
206:             echo "work_unit:$work_unit"
207:         else
208:             echo "work_unit:.claude/work/current/consolidation.md"
209:         fi
210: 
211:     # Check if it's architectural/reference
212:     elif [[ "$content_preview" =~ (architecture|design|pattern|structure|framework|reference) ]]; then
213:         echo "reference:.claude/reference/$(basename "$file")"
214: 
215:     # Check if it's general insights
216:     elif [[ "$content_preview" =~ (insight|learning|principle|guideline|best.practice) ]]; then
217:         echo "readme:README.md"
218: 
219:     # Default to work unit
220:     else
221:         echo "work_unit:.claude/work/current/consolidation.md"
222:     fi
223: }
224: ```
225: 
226: ## Phase 5: Execute Reports Consolidation
227: 
228: ```bash
229: # Handle reports mode specifically
230: if [ "$MODE" = "reports" ] || [ "$MODE" = "all" ]; then
231:     echo ""
232:     echo "🔍 Scanning for consolidation candidates..."
233: 
234:     CANDIDATES=($(detect_md_reports))
235:     CONSOLIDATED_COUNT=0
236: 
237:     if [ ${#CANDIDATES[@]} -eq 0 ]; then
238:         echo "✅ No standalone .md files found - project is already clean"
239:     else
240:         echo "📝 Found ${#CANDIDATES[@]} potential consolidation candidates:"
241:         echo ""
242: 
243:         for file in "${CANDIDATES[@]}"; do
244:             if [ ! -f "$file" ]; then continue; fi
245: 
246:             echo "📄 $file"
247: 
248:             # Show preview
249:             local preview=$(head -3 "$file" | sed 's/^/     /')
250:             echo "$preview"
251:             echo "     ..."
252: 
253:             # Get suggestion
254:             local suggestion=$(suggest_target "$file")
255:             local target_type=$(echo "$suggestion" | cut -d: -f1)
256:             local target_path=$(echo "$suggestion" | cut -d: -f2)
257: 
258:             case "$target_type" in
259:                 work_unit)
260:                     echo "   💼 Suggests: Consolidate with work unit → $target_path"
261:                     ;;
262:                 reference)
263:                     echo "   📚 Suggests: Archive as reference → $target_path"
264:                     ;;
265:                 readme)
266:                     echo "   📖 Suggests: Integrate into README.md"
267:                     ;;
268:             esac
269: 
270:             # Ask for confirmation unless auto mode
271:             if [ "$AUTO" = false ] && [ "$DRY_RUN" = false ]; then
272:                 echo ""
273:                 read -p "   Consolidate this file? (y/n/s=skip): " choice
274:                 case "$choice" in
275:                     y|Y)
276:                         if [ "$target_type" = "readme" ]; then
277:                             handle_file "$file" consolidate "README.md"
278:                         else
279:                             mkdir -p "$(dirname "$target_path")"
280:                             handle_file "$file" consolidate "$target_path"
281:                         fi
282:                         ((CONSOLIDATED_COUNT++))
283:                         ;;
284:                     s|S)
285:                         echo "   ⏭️  Skipping $file"
286:                         ;;
287:                     *)
288:                         echo "   📦 Archiving $file for manual review"
289:                         handle_file "$file" archive
290:                         ;;
291:                 esac
292:             elif [ "$AUTO" = true ]; then
293:                 # Auto mode - consolidate based on suggestion
294:                 if [ "$target_type" = "readme" ]; then
295:                     handle_file "$file" consolidate "README.md"
296:                 else
297:                     mkdir -p "$(dirname "$target_path")"
298:                     handle_file "$file" consolidate "$target_path"
299:                 fi
300:                 ((CONSOLIDATED_COUNT++))
301:             else
302:                 # Dry run mode
303:                 echo "   🔍 Would consolidate → $target_path"
304:             fi
305: 
306:             echo ""
307:         done
308: 
309:         if [ "$DRY_RUN" = false ]; then
310:             echo "✅ Consolidated $CONSOLIDATED_COUNT files"
311:         fi
312:     fi
313: fi
314: 
315: # Continue with other cleanup modes...
316: if [ "$MODE" = "root" ] || [ "$MODE" = "all" ]; then
317:     echo ""
318:     echo "🏠 Cleaning root directory..."
319:     # Add root cleanup logic here
320: fi
321: 
322: if [ "$MODE" = "tests" ] || [ "$MODE" = "all" ]; then
323:     echo ""
324:     echo "🧪 Organizing test files..."
325:     # Add test cleanup logic here
326: fi
327: 
328: if [ "$MODE" = "work" ] || [ "$MODE" = "all" ]; then
329:     echo ""
330:     echo "💼 Cleaning work directory..."
331:     # Add work cleanup logic here
332: fi
333: ```
334: 
335: ## Phase 6: Final Organization
336: 
337: ### Key Directories After Cleanup
338: ```
339: project/
340: ├── README.md              # Main documentation
341: ├── CHANGELOG.md           # Version history
342: ├── CLAUDE.md              # AI context (if needed)
343: ├── .claude/
344: │   ├── work/              # All work units
345: │   │   ├── current/       # Active work
346: │   │   └── completed/     # Archived work with reports
347: │   ├── reference/         # Permanent documentation
348: │   └── memory/            # Memory files
349: ├── tests/                 # ALL test files
350: ├── scripts/               # Utility scripts (if needed)
351: └── src/                   # Source code
352: ```
353: 
354: ### What Gets Preserved
355: - Core documentation (README, CHANGELOG, CLAUDE.md)
356: - Active source code and configurations
357: - Structured work units in `.claude/work/`
358: - Formal tests in `tests/`
359: - Essential scripts in `scripts/`
360: 
361: ### What Gets Removed/Archived
362: - Temporary debug scripts
363: - One-off test files
364: - Redundant reports and analyses
365: - Duplicate documentation
366: - Misplaced files in root
367: 
368: ## Success Metrics
369: 
370: ✅ **Root directory contains only essential files**
371: ✅ **All tests are in tests/ directory**
372: ✅ **Reports consolidated with their work units**
373: ✅ **No duplicate documentation**
374: ✅ **Clear project structure maintained**
375: ✅ **Important information preserved in appropriate locations**
376: 
377: ## Summary Report
378: 
379: After cleanup, I'll provide:
380: - Files removed/archived count by category
381: - Documentation consolidated
382: - Tests organized
383: - Space recovered
384: - Remaining actions needed
385: 
386: ---
387: 
388: *Smart cleanup that understands how Claude actually creates clutter and consolidates it appropriately*
````

## File: plugins/core/commands/docs.md
````markdown
  1: ---
  2: allowed-tools: [Bash, Read, Write, MultiEdit, Grep, Glob, Task, WebFetch, mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
  3: argument-hint: "fetch|search|generate [arguments]"
  4: description: Unified documentation operations - fetch external, search all, and generate project docs
  5: ---
  6: 
  7: # Documentation Operations Hub
  8: 
  9: Consolidated command for all documentation-related operations. Clear separation between fetching external docs, searching, and generating project documentation.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Usage
 14: 
 15: ### Fetch External Documentation
 16: ```bash
 17: /docs fetch                    # Fetch official Claude Code & library docs
 18: /docs fetch --force            # Force complete re-fetch (clear cache)
 19: /docs fetch --status           # Check cache status and last fetch time
 20: /docs fetch --libraries        # Focus on project dependency docs
 21: ```
 22: 
 23: ### Search Documentation
 24: ```bash
 25: /docs search "command syntax"      # Search all cached documentation
 26: /docs search "hooks examples"      # Find specific topics
 27: /docs search "MCP integration"     # Search across all docs
 28: /docs search "pytest fixtures"     # Search library-specific docs
 29: ```
 30: 
 31: ### Generate Project Documentation
 32: ```bash
 33: /docs generate "Added auth system"   # Generate/update docs after changes
 34: /docs generate                       # Interactive documentation generation
 35: /docs generate --api                 # Focus on API documentation
 36: /docs generate --readme              # Update README only
 37: ```
 38: 
 39: ## Phase 1: Determine Documentation Operation
 40: 
 41: Based on the arguments provided: $ARGUMENTS
 42: 
 43: I'll determine which documentation operation to perform:
 44: 
 45: - **Fetch Operations**: Arguments start with "fetch" - fetch external documentation into cache
 46: - **Search Operations**: Arguments start with "search" - search all available documentation
 47: - **Generate Operations**: Arguments start with "generate" - generate/update project documentation
 48: - **Help Mode**: No arguments - show usage guidance with clear distinctions
 49: 
 50: ## Phase 2: Execute Documentation Fetch
 51: 
 52: When handling fetch operations:
 53: 
 54: ### Fetching External Documentation
 55: 1. **Source Identification**: Determine official Claude Code documentation sources
 56: 2. **Cache Management**: Create/update local documentation cache in `.claude/docs/`
 57: 3. **Version Tracking**: Track documentation versions and update timestamps
 58: 4. **Content Organization**: Organize docs by topic (commands, agents, hooks, MCP)
 59: 5. **Index Creation**: Create searchable index of documentation content
 60: 
 61: ### Fetch Modes
 62: 1. **Incremental Fetch** (default): Fetch only changed or new documentation
 63: 2. **Force Fetch** (--force): Complete re-download and cache refresh
 64: 3. **Status Check** (--status): Report cache status and last fetch information
 65: 4. **Library Focus** (--libraries): Prioritize project dependency documentation
 66: 
 67: ### Enhanced Fetch (with Context7 MCP)
 68: When Context7 MCP is available, enhance documentation sync with intelligent library detection:
 69: 
 70: **Automatic Library Documentation Sync**:
 71: 1. **Dependency Detection**: Scan project files (package.json, requirements.txt, etc.) for libraries
 72: 2. **Library Resolution**: Use Context7 to resolve library names to official documentation
 73: 3. **Version-Aware Sync**: Fetch documentation matching exact dependency versions
 74: 4. **Intelligent Caching**: Cache frequently-used library documentation locally
 75: 
 76: **Context7 Fetch Process**:
 77: - Automatically detect project dependencies
 78: - Resolve each library using `mcp__context7__resolve-library-id`
 79: - Fetch comprehensive documentation using `mcp__context7__get-library-docs`
 80: - Organize documentation by library and version in `.claude/docs/libraries/`
 81: - Create searchable index linking local project to relevant library docs
 82: 
 83: **Smart Documentation Features**:
 84: - **Framework-Specific**: Automatically include framework-specific best practices
 85: - **API-Complete**: Ensure complete API reference for all dependencies
 86: - **Example-Rich**: Include usage examples and patterns from Context7
 87: - **Update-Aware**: Check for documentation updates on library version changes
 88: 
 89: **Graceful Degradation**: When Context7 unavailable, falls back to manual documentation fetch using web fetch and local caching.
 90: 
 91: ## Context7 MCP Availability Check
 92: 
 93: Before attempting Context7 operations, I'll check availability:
 94: - Test Context7 MCP connection with simple library resolution
 95: - On failure, automatically switch to fallback methods
 96: - Provide clear user feedback about which mode is active
 97: - Maintain full functionality regardless of MCP availability
 98: 
 99: ## Phase 3: Execute Documentation Search
100: 
101: When handling search operations:
102: 
103: ### Local Cache Search
104: 1. **Index Search**: Use cached documentation index for fast search
105: 2. **Content Search**: Full-text search across all cached documentation
106: 3. **Topic Filtering**: Search within specific documentation categories
107: 4. **Relevance Ranking**: Rank results by relevance and recency
108: 
109: ### Advanced Search (with Context7 MCP)
110: When Context7 MCP is available, enhance search with library-specific intelligence:
111: 
112: **Context7 Library Documentation Search**:
113: 1. **Automatic Library Resolution**: Identify libraries from project dependencies
114: 2. **Version-Specific Documentation**: Access docs matching exact library versions
115: 3. **Semantic Library Search**: Find relevant topics within library documentation
116: 4. **API Reference Lookup**: Direct access to function/class documentation
117: 
118: **Context7 Enhanced Search Process**:
119: - When searching for library-specific topics, automatically resolve library names
120: - Fetch up-to-date documentation from Context7's knowledge base
121: - Provide focused, relevant results from official library documentation
122: - Fall back to cached local search when Context7 unavailable
123: 
124: **Example Context7 Usage**:
125: ```bash
126: /docs search "react hooks"     # → Uses Context7 to find React hooks documentation
127: /docs search "express middleware" # → Fetches Express.js middleware docs via Context7
128: /docs search "pytest fixtures"   # → Gets current pytest fixture documentation
129: ```
130: 
131: ### Traditional Search (Fallback)
132: When Context7 MCP is unavailable:
133: 
134: 1. **Local Cache Search**: Use cached documentation index for fast search
135: 2. **Live Web Search**: Search current online documentation via Firecrawl when available
136: 3. **Cross-Reference Search**: Find related concepts in cached documentation
137: 4. **Code Example Search**: Find relevant code examples from local cache
138: 
139: ### Search Result Presentation
140: 1. **Relevant Excerpts**: Show context around matching content
141: 2. **Source Attribution**: Clear indication of documentation source
142: 3. **Direct Links**: Provide links to full documentation when available
143: 4. **Related Topics**: Suggest related documentation sections
144: 
145: ## Phase 4: Execute Documentation Generation
146: 
147: When handling generate operations:
148: 
149: ### Project Documentation Generation
150: 1. **Current State Assessment**: Analyze existing project documentation
151: 2. **Gap Identification**: Identify missing or outdated documentation
152: 3. **Change Impact Analysis**: Understand what documentation needs updating
153: 4. **Content Planning**: Plan what documentation to create or update
154: 
155: ### Generation Operations
156: 1. **API Documentation**: Generate API docs from code analysis
157: 2. **README Generation**: Update README with new features and changes
158: 3. **Code Comments**: Generate missing docstrings and comments
159: 4. **Usage Examples**: Create usage examples from test cases
160: 5. **Migration Guides**: Generate migration guides for breaking changes
161: 
162: ### Enhanced Generation (with MCP Tools)
163: When MCP servers are available:
164: 
165: 1. **Automated API Docs**: Generate API documentation from code analysis
166: 2. **Intelligent Examples**: Create relevant usage examples automatically
167: 3. **Cross-Platform Docs**: Ensure documentation works across different platforms
168: 4. **Documentation Testing**: Verify documentation examples actually work
169: 
170: ## Phase 5: Documentation Quality Assurance
171: 
172: For all documentation operations:
173: 
174: ### Content Validation
175: 1. **Accuracy Verification**: Ensure documentation matches actual implementation
176: 2. **Link Checking**: Validate all internal and external links work
177: 3. **Code Example Testing**: Verify all code examples execute correctly
178: 4. **Formatting Consistency**: Ensure consistent formatting and style
179: 
180: ### Organization and Accessibility
181: 1. **Logical Structure**: Organize documentation in intuitive hierarchy
182: 2. **Navigation Aids**: Create table of contents and cross-references
183: 3. **Search Optimization**: Ensure content is easily searchable
184: 4. **Version Compatibility**: Mark documentation with applicable versions
185: 
186: ## Phase 6: Cache and State Management
187: 
188: ### Documentation Cache Structure
189: ```
190: .claude/docs/
191: ├── official/          # Official Claude Code documentation
192: │   ├── commands/      # Command documentation
193: │   ├── agents/        # Agent documentation
194: │   ├── hooks/         # Hook documentation
195: │   └── api/           # API reference
196: ├── libraries/         # Third-party library documentation
197: ├── project/           # Project-specific documentation
198: └── cache_metadata.json  # Cache status and timestamps
199: ```
200: 
201: ### Cache Maintenance
202: 1. **Size Management**: Keep cache size reasonable for performance
203: 2. **Staleness Detection**: Identify and refresh outdated documentation
204: 3. **Cleanup Operations**: Remove unnecessary or duplicate documentation
205: 4. **Index Rebuilding**: Maintain searchable index of documentation content
206: 
207: ## Success Indicators
208: 
209: ### Fetch Operations Success
210: - ✅ External documentation cached locally
211: - ✅ Cache index updated and searchable
212: - ✅ Version information tracked
213: - ✅ Dependencies documentation fetched (when MCP available)
214: 
215: ### Search Operations Success
216: - ✅ Relevant results found and presented
217: - ✅ Context provided with search results
218: - ✅ Source attribution clear
219: - ✅ Related topics suggested
220: 
221: ### Generate Operations Success
222: - ✅ Project documentation generated and current
223: - ✅ API documentation reflects latest code
224: - ✅ Examples created and tested
225: - ✅ Migration guides generated for changes
226: 
227: ## Common Documentation Patterns
228: 
229: ### API Documentation
230: - Clear endpoint descriptions with parameters
231: - Request/response examples
232: - Error code documentation
233: - Authentication requirements
234: 
235: ### User Guides
236: - Step-by-step instructions
237: - Screenshots and examples
238: - Common use cases
239: - Troubleshooting sections
240: 
241: ### Developer Documentation
242: - Architecture explanations
243: - Contributing guidelines
244: - Development setup instructions
245: - Testing procedures
246: 
247: ## Examples
248: 
249: ### Fetch Latest Documentation
250: ```bash
251: /docs fetch
252: # → Downloads and caches latest official Claude Code & library documentation
253: ```
254: 
255: ### Search for Specific Topics
256: ```bash
257: /docs search "hook examples"
258: # → Finds and displays relevant hook documentation and examples
259: ```
260: 
261: ### Generate Project Documentation
262: ```bash
263: /docs generate "Added authentication system with JWT tokens"
264: # → Generates/updates README, API docs, and creates usage examples
265: ```
266: 
267: ### Force Complete Documentation Refresh
268: ```bash
269: /docs fetch --force
270: # → Completely refreshes external documentation cache
271: ```
272: 
273: ## Integration Benefits
274: 
275: - **MCP Intelligence**: Leverages Context7 for library docs and Firecrawl for web content
276: - **Automated Updates**: Keeps documentation synchronized with code changes
277: - **Smart Search**: Intelligent search across all documentation sources
278: - **Version Awareness**: Matches documentation to actual dependency versions
279: - **Quality Assurance**: Validates documentation accuracy and completeness
280: 
281: ---
282: 
283: *Unified documentation command with clear operations: fetch external docs, search everything, and generate project documentation.*
````

## File: plugins/core/commands/handoff.md
````markdown
  1: ---
  2: title: handoff
  3: aliases: [transition, continue]
  4: ---
  5: 
  6: # Conversation Handoff
  7: 
  8: Prepare a smooth transition for the next conversation when approaching context limits or switching focus.
  9: 
 10: ## Purpose
 11: 
 12: Creates a structured handoff document that:
 13: 1. **Extracts session-specific context** for immediate continuation
 14: 2. **Updates permanent memory** with durable learnings
 15: 3. **Prepares clean transition** for the next agent
 16: 
 17: ## What Gets Created
 18: 
 19: ### Transition Document
 20: **Location**: `.claude/transitions/YYYY-MM-DD_NNN/handoff.md`
 21: 
 22: Contains:
 23: - **Current Work Context**: What was being worked on, why, and current state
 24: - **Recent Decisions**: Important choices made this session (not yet in permanent docs)
 25: - **Active Challenges**: Current blockers, open questions, debugging context
 26: - **Next Steps**: Specific, actionable tasks ready for immediate execution
 27: - **Session-Specific State**: File changes, test results, temporary findings
 28: 
 29: ### Memory Updates (if needed)
 30: Updates `.claude/memory/` files with durable knowledge:
 31: - **project_state.md**: Architecture changes, new components
 32: - **conventions.md**: Discovered patterns, coding standards
 33: - **dependencies.md**: New integrations, API changes
 34: 
 35: ## Usage
 36: 
 37: ```bash
 38: # Standard handoff - analyzes conversation and creates transition
 39: /handoff
 40: 
 41: # With specific focus for next session
 42: /handoff "focusing on performance optimization"
 43: 
 44: # Quick handoff (minimal extraction)
 45: /handoff --quick
 46: ```
 47: 
 48: ## Handoff Process
 49: 
 50: I'll analyze our conversation and execute these steps:
 51: 
 52: 1. **Identify Durable Knowledge** → Update `.claude/memory/` files if needed
 53: 2. **Extract Session Context** → Create comprehensive transition document
 54: 3. **Verify Symlink** → Ensure `.claude/transitions/latest/handoff.md` is correct
 55: 4. **Inform User** → Tell user to run `/clear` manually (auto-clear not available via SlashCommand)
 56: 
 57: **IMPORTANT**: After I complete the handoff document, you must manually continue:
 58: 
 59: 1. Run `/clear` (the CLI command, not a slash command)
 60: 2. Say: "continue from .claude/transitions/latest/handoff.md"
 61: 
 62: **Note**: Auto-continue after `/clear` is NOT supported. You must explicitly tell me to continue from the handoff document.
 63: 
 64: ## User Continuation Steps
 65: 
 66: After I create the handoff document and verify the symlink:
 67: 
 68: **Step 1**: Run `/clear` to reset conversation context
 69: ```bash
 70: /clear
 71: ```
 72: 
 73: **Step 2**: Explicitly tell me to continue from handoff
 74: ```
 75: continue from .claude/transitions/latest/handoff.md
 76: ```
 77: 
 78: **Manual intervention required** - There is no automatic detection or loading after `/clear`.
 79: 
 80: ## Intelligence Guidelines
 81: 
 82: ### What Goes in Permanent Memory
 83: - Architectural decisions and rationale
 84: - Discovered patterns and conventions
 85: - Integration points and dependencies
 86: - Long-term project goals
 87: 
 88: ### What Stays in Transition
 89: - Current debugging context
 90: - Today's specific task progress
 91: - Temporary workarounds
 92: - Session-specific file edits
 93: 
 94: ### What's Excluded
 95: - Verbose narratives about changes
 96: - Historical context ("we tried X then Y")
 97: - Meta-discussion about process
 98: - Redundant information already in docs
 99: 
100: ## Example Transition Structure
101: 
102: ```markdown
103: # Handoff: 2025-09-18_001
104: 
105: ## Active Work
106: Implementing MCP memory system with two-flow approach
107: 
108: ## Current State
109: - Created /handoff and /memory-update commands
110: - Serena configured and working for semantic operations
111: - 4 MCP tools operational (Sequential Thinking, Context7, Serena, Firecrawl)
112: 
113: ## Recent Decisions
114: - Use .claude/memory/ for durable knowledge referenced by CLAUDE.md
115: - Transition documents in .claude/transitions/ for session handoffs
116: - Keep README.md deliberately concise
117: 
118: ## Next Steps
119: 1. Test /handoff command with real scenario
120: 2. Configure .claude/memory/ structure
121: 3. Update CLAUDE.md to reference memory modules
122: 
123: ## Session Context
124: Working in: $PROJECT_DIR
125: Last focus: Memory system design
126: Open PR: feature/sophisticated-hook-system
127: ```
128: 
129: ## Implementation Notes
130: 
131: ### Symlink Verification
132: **Critical**: Always verify the `latest` symlink points to the newest handoff document.
133: 
134: ```bash
135: # Find newest transition directory
136: NEWEST=$(ls -1d .claude/transitions/2025-* 2>/dev/null | sort -r | head -1)
137: 
138: # Update symlink (force overwrite)
139: ln -sf "$NEWEST/handoff.md" .claude/transitions/latest/handoff.md
140: 
141: # Verify it's correct
142: readlink -f .claude/transitions/latest/handoff.md
143: ```
144: 
145: This prevents the issue where an older handoff document gets linked instead of the newest one.
146: 
147: ### Manual Continuation Workflow
148: After creating handoff and verifying symlink, I will tell you:
149: 
150: ```
151: ✅ Handoff complete!
152: 
153: To continue:
154: 1. Run /clear (the CLI command)
155: 2. Say: "continue from .claude/transitions/latest/handoff.md"
156: ```
157: 
158: **Important**: Auto-continuation is NOT supported. You must explicitly tell me to read the handoff document after `/clear`.
159: 
160: ## Benefits
161: 
162: - **No Context Loss**: Smooth continuation across conversation boundaries (with manual continue step)
163: - **Clean Documentation**: Permanent docs stay concise and relevant
164: - **Efficient Startup**: Next agent gets exactly what they need
165: - **Progressive Learning**: Project knowledge accumulates properly
166: - **Symlink Convenience**: `.claude/transitions/latest/handoff.md` always points to newest handoff
167: 
168: ---
169: 
170: *Part of the memory management system - ensuring continuous project understanding across sessions*
````

## File: plugins/core/commands/index.md
````markdown
  1: ---
  2: allowed-tools: [Read, Write, Grep, Bash, Glob, Task]
  3: argument-hint: "[--update] [--refresh] [focus_area]"
  4: description: Create and maintain persistent project understanding through comprehensive project mapping
  5: ---
  6: 
  7: # Index Project
  8: 
  9: Creates persistent project understanding that survives sessions by generating a comprehensive PROJECT_MAP.md file automatically imported into CLAUDE.md.
 10: 
 11: **Solves the core problem**: `/analyze` insights are lost between sessions, requiring constant "looking around" and re-exploration of codebases.
 12: 
 13: **Input**: $ARGUMENTS
 14: 
 15: ## Implementation
 16: 
 17: ```bash
 18: #!/bin/bash
 19: 
 20: # Standard constants (must be copied to each command)
 21: readonly CLAUDE_DIR=".claude"
 22: readonly PROJECT_MAP="${CLAUDE_DIR}/PROJECT_MAP.md"
 23: readonly CLAUDE_MD="CLAUDE.md"
 24: 
 25: # Error handling functions (must be copied to each command)
 26: error_exit() {
 27:     echo "ERROR: $1" >&2
 28:     exit 1
 29: }
 30: 
 31: warn() {
 32:     echo "WARNING: $1" >&2
 33: }
 34: 
 35: debug() {
 36:     [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
 37: }
 38: 
 39: # Safe directory creation
 40: safe_mkdir() {
 41:     local dir="$1"
 42:     mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
 43: }
 44: 
 45: # Parse arguments
 46: MODE="full"
 47: FOCUS_AREA=""
 48: 
 49: if [[ "$ARGUMENTS" == *"--update"* ]]; then
 50:     MODE="update"
 51: elif [[ "$ARGUMENTS" == *"--refresh"* ]]; then
 52:     MODE="refresh"
 53: elif [ -n "$ARGUMENTS" ] && [[ "$ARGUMENTS" != --* ]]; then
 54:     FOCUS_AREA="$ARGUMENTS"
 55: fi
 56: 
 57: echo "🔍 Indexing Project"
 58: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 59: echo ""
 60: echo "Mode: $MODE"
 61: if [ -n "$FOCUS_AREA" ]; then
 62:     echo "Focus: $FOCUS_AREA"
 63: fi
 64: echo ""
 65: 
 66: # Ensure .claude directory exists
 67: safe_mkdir "$CLAUDE_DIR"
 68: 
 69: # Check if PROJECT_MAP.md already exists
 70: if [ -f "$PROJECT_MAP" ] && [ "$MODE" = "full" ]; then
 71:     echo "📝 Existing PROJECT_MAP.md found. Use --update for incremental or --refresh for complete regeneration."
 72:     MODE="update"
 73: fi
 74: 
 75: # Analyze project structure
 76: echo "📊 Analyzing project structure..."
 77: 
 78: # Get project name from directory
 79: PROJECT_NAME=$(basename "$(pwd)")
 80: 
 81: # Detect primary language
 82: PRIMARY_LANG="Unknown"
 83: if ls *.py >/dev/null 2>&1; then
 84:     PRIMARY_LANG="Python"
 85: elif ls *.js >/dev/null 2>&1; then
 86:     PRIMARY_LANG="JavaScript"
 87: elif ls *.ts >/dev/null 2>&1; then
 88:     PRIMARY_LANG="TypeScript"
 89: elif ls *.go >/dev/null 2>&1; then
 90:     PRIMARY_LANG="Go"
 91: elif ls *.java >/dev/null 2>&1; then
 92:     PRIMARY_LANG="Java"
 93: fi
 94: 
 95: # Detect frameworks
 96: FRAMEWORKS=""
 97: if [ -f "package.json" ]; then
 98:     if grep -q "react" package.json 2>/dev/null; then
 99:         FRAMEWORKS="${FRAMEWORKS}React "
100:     fi
101:     if grep -q "express" package.json 2>/dev/null; then
102:         FRAMEWORKS="${FRAMEWORKS}Express "
103:     fi
104:     if grep -q "next" package.json 2>/dev/null; then
105:         FRAMEWORKS="${FRAMEWORKS}Next.js "
106:     fi
107: fi
108: 
109: if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
110:     if grep -q "django" requirements.txt 2>/dev/null || grep -q "django" pyproject.toml 2>/dev/null; then
111:         FRAMEWORKS="${FRAMEWORKS}Django "
112:     fi
113:     if grep -q "flask" requirements.txt 2>/dev/null || grep -q "flask" pyproject.toml 2>/dev/null; then
114:         FRAMEWORKS="${FRAMEWORKS}Flask "
115:     fi
116:     if grep -q "fastapi" requirements.txt 2>/dev/null || grep -q "fastapi" pyproject.toml 2>/dev/null; then
117:         FRAMEWORKS="${FRAMEWORKS}FastAPI "
118:     fi
119: fi
120: 
121: # Create or update PROJECT_MAP.md
122: echo "📝 Creating PROJECT_MAP.md..."
123: 
124: cat > "$PROJECT_MAP" << EOF || error_exit "Failed to create PROJECT_MAP.md"
125: # Project Map: $PROJECT_NAME
126: 
127: *Generated: $(date -Iseconds)*
128: *Last Updated: $(date -Iseconds)*
129: 
130: ## Quick Overview
131: - **Type**: [Project type to be determined]
132: - **Primary Language**: $PRIMARY_LANG
133: - **Frameworks**: ${FRAMEWORKS:-Not detected}
134: - **Location**: $(pwd)
135: 
136: ## Directory Structure
137: 
138: ### Main Application Code
139: EOF
140: 
141: # Add directory structure analysis
142: for dir in src lib app core; do
143:     if [ -d "$dir" ]; then
144:         FILE_COUNT=$(find "$dir" -type f -name "*.${PRIMARY_LANG,,}" 2>/dev/null | wc -l)
145:         echo "- \`$dir/\` - Main application code ($FILE_COUNT files)" >> "$PROJECT_MAP"
146:     fi
147: done
148: 
149: echo "" >> "$PROJECT_MAP"
150: echo "### Test Organization" >> "$PROJECT_MAP"
151: for dir in test tests __tests__ spec; do
152:     if [ -d "$dir" ]; then
153:         echo "- \`$dir/\` - Test files" >> "$PROJECT_MAP"
154:     fi
155: done
156: 
157: echo "" >> "$PROJECT_MAP"
158: echo "### Documentation" >> "$PROJECT_MAP"
159: if [ -f "README.md" ]; then
160:     echo "- \`README.md\` - Project documentation" >> "$PROJECT_MAP"
161: fi
162: if [ -d "docs" ]; then
163:     echo "- \`docs/\` - Additional documentation" >> "$PROJECT_MAP"
164: fi
165: 
166: # Add key files section
167: echo "" >> "$PROJECT_MAP"
168: echo "## Key Files" >> "$PROJECT_MAP"
169: 
170: # Find entry points
171: for file in main.py app.py server.py index.js server.js main.go; do
172:     if [ -f "$file" ]; then
173:         echo "- \`$file\` - Application entry point" >> "$PROJECT_MAP"
174:     fi
175: done
176: 
177: # Add patterns section
178: echo "" >> "$PROJECT_MAP"
179: echo "## Patterns & Conventions" >> "$PROJECT_MAP"
180: echo "- **Architecture**: [To be analyzed]" >> "$PROJECT_MAP"
181: echo "- **Testing**: [To be analyzed]" >> "$PROJECT_MAP"
182: echo "- **Code Style**: [To be analyzed]" >> "$PROJECT_MAP"
183: 
184: # Add to CLAUDE.md if not already imported
185: if [ -f "$CLAUDE_MD" ]; then
186:     if ! grep -q "@.claude/PROJECT_MAP.md" "$CLAUDE_MD" 2>/dev/null; then
187:         echo "" >> "$CLAUDE_MD"
188:         echo "## Project Understanding" >> "$CLAUDE_MD"
189:         echo "@.claude/PROJECT_MAP.md" >> "$CLAUDE_MD"
190:         echo "✅ Added PROJECT_MAP.md import to CLAUDE.md"
191:     else
192:         echo "✅ PROJECT_MAP.md already imported in CLAUDE.md"
193:     fi
194: else
195:     # Create CLAUDE.md with import
196:     cat > "$CLAUDE_MD" << EOF || error_exit "Failed to create CLAUDE.md"
197: # Project: $PROJECT_NAME
198: 
199: ## Project Understanding
200: @.claude/PROJECT_MAP.md
201: EOF
202:     echo "✅ Created CLAUDE.md with PROJECT_MAP.md import"
203: fi
204: 
205: echo ""
206: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
207: echo "✅ Project indexed successfully!"
208: echo ""
209: echo "📋 PROJECT_MAP.md created at: $PROJECT_MAP"
210: echo "📋 Auto-imported into: $CLAUDE_MD"
211: echo ""
212: echo "💡 Next steps:"
213: echo "   - Review and enhance PROJECT_MAP.md with specific details"
214: echo "   - Run /analyze for deeper code analysis"
215: echo "   - Use /index --update after making changes"
216: ```
217: 
218: ## Usage
219: 
220: ### Full Project Mapping (Initial Use)
221: ```bash
222: /index
223: ```
224: Performs comprehensive project scan, creates `.claude/PROJECT_MAP.md`, and auto-imports into `CLAUDE.md`.
225: 
226: ### Incremental Updates
227: ```bash
228: /index --update
229: ```
230: Updates existing PROJECT_MAP.md with recent changes, new files, and structural modifications.
231: 
232: ### Complete Refresh
233: ```bash
234: /index --refresh
235: ```
236: Force complete re-scan and regeneration of PROJECT_MAP.md, useful after major refactoring.
237: 
238: ### Focused Analysis
239: ```bash
240: /index "authentication system"
241: ```
242: Generate project map with special focus on authentication-related components and patterns.
243: 
244: ## Phase 1: Determine Analysis Mode
245: 
246: Based on arguments: $ARGUMENTS
247: 
248: I'll determine the appropriate indexing approach:
249: 
250: - **Full Scan**: No arguments or new project - comprehensive analysis
251: - **Update Mode**: `--update` specified - incremental changes only
252: - **Refresh Mode**: `--refresh` specified - complete regeneration
253: - **Focused Mode**: Focus area specified - targeted analysis
254: 
255: ## Phase 2: Project Structure Analysis
256: 
257: ### Directory Structure Discovery
258: 1. **Source Code Organization**: Identify main code directories (src/, lib/, app/, etc.)
259: 2. **Test Organization**: Locate test directories and their relationship to source
260: 3. **Documentation Structure**: Find docs/, README files, and documentation patterns
261: 4. **Configuration Files**: Map config files, environment files, and settings
262: 5. **Build and Deployment**: Identify build directories, deployment configs, and artifacts
263: 
264: ### Technology Stack Detection
265: 1. **Primary Language**: Determine main programming language from file extensions
266: 2. **Framework Identification**: Detect frameworks from package files and imports
267: 3. **Database Technology**: Identify database systems and ORM patterns
268: 4. **Build Tools**: Find build systems, task runners, and automation tools
269: 5. **Deployment Platform**: Detect containerization, cloud configs, and deployment targets
270: 
271: ### Entry Points and Key Files
272: 1. **Application Entry Points**: main.py, index.js, app.py, server.go, etc.
273: 2. **Configuration Entry Points**: settings files, environment configs
274: 3. **API Definitions**: Route files, API specs, schema definitions
275: 4. **Data Models**: Entity definitions, database schemas, type definitions
276: 5. **Core Business Logic**: Key service files, domain models, controllers
277: 
278: ## Phase 3: Code Pattern Analysis
279: 
280: ### Architectural Patterns
281: 1. **Project Structure**: Analyze directory organization and naming conventions
282: 2. **Code Organization**: Identify layering patterns (MVC, clean architecture, etc.)
283: 3. **Dependency Patterns**: Map how modules import and depend on each other
284: 4. **Design Patterns**: Identify common patterns (factory, singleton, observer, etc.)
285: 5. **Testing Patterns**: Understand test organization and coverage approach
286: 
287: ### Development Conventions
288: 1. **Naming Conventions**: File naming, variable naming, function naming patterns
289: 2. **Code Style**: Formatting, documentation, and comment patterns
290: 3. **Error Handling**: How errors are managed and propagated
291: 4. **Logging and Monitoring**: Logging patterns and monitoring setup
292: 5. **Security Practices**: Authentication, authorization, and security patterns
293: 
294: ### Integration Points
295: 1. **External APIs**: Third-party service integrations and API clients
296: 2. **Database Connections**: How data persistence is handled
297: 3. **Message Queues**: Async communication and event handling
298: 4. **Caching Systems**: Caching strategies and implementations
299: 5. **File Storage**: File handling and storage systems
300: 
301: ## Phase 4: Enhanced Analysis (with MCP Tools)
302: 
303: ### Sequential Thinking Analysis (when available)
304: For complex projects, use structured reasoning to understand:
305: 
306: 1. **System Architecture**: Step-by-step analysis of how components interact
307: 2. **Data Flow**: Systematic tracing of data through the system
308: 3. **Business Logic**: Understanding of core functionality and workflows
309: 4. **Integration Points**: Analysis of external dependencies and interfaces
310: 5. **Scalability Considerations**: Assessment of performance and scaling patterns
311: 
312: ### Semantic Code Analysis (with Serena MCP)
313: When Serena is connected, enhance analysis with:
314: 
315: 1. **Symbol-Level Understanding**: Actual class and function relationships
316: 2. **Import Graph Analysis**: Real dependency tracking and circular dependency detection
317: 3. **Type Flow Analysis**: Understanding of data types and contracts
318: 4. **API Surface Mapping**: Public interfaces and their usage patterns
319: 5. **Dead Code Detection**: Unused functions, classes, and modules
320: 
321: ## Phase 5: Generate PROJECT_MAP.md
322: 
323: ### Project Map Structure
324: Create comprehensive project map with the following sections:
325: 
326: ```markdown
327: # Project Map: [Project Name]
328: 
329: *Generated: [timestamp]*
330: *Last Updated: [timestamp]*
331: 
332: ## Quick Overview
333: - **Type**: [web app/library/service/tool]
334: - **Primary Language**: [language]
335: - **Frameworks**: [key frameworks]
336: - **Location**: [project path]
337: 
338: ## Directory Structure
339: 
340: ### Main Application Code
341: - `src/` - [description]
342: - `lib/` - [description]
343: - `app/` - [description]
344: 
345: ### Test Organization
346: - `tests/` - [description]
347: - `test/` - [description]
348: 
349: ### Documentation
350: - `docs/` - [description]
351: - `README.md` - [description]
352: 
353: ## Key Files
354: - `[entry-point]` - [description and purpose]
355: - `[config-file]` - [configuration and settings]
356: - `[key-module]` - [core functionality]
357: 
358: ## Patterns & Conventions
359: - **Architecture**: [architectural pattern]
360: - **Testing**: [testing approach]
361: - **Code Style**: [formatting and conventions]
362: - **Error Handling**: [error management pattern]
363: 
364: ## Dependencies
365: 
366: ### External Dependencies
367: - **Production**: [key production dependencies]
368: - **Development**: [development and testing tools]
369: 
370: ### Internal Dependencies
371: - **Core Modules**: [main internal dependencies]
372: - **Utilities**: [helper and utility modules]
373: 
374: ## Entry Points & Common Tasks
375: 
376: ### Development Workflow
377: - **Start Dev Server**: [command]
378: - **Run Tests**: [command]
379: - **Build Production**: [command]
380: - **Deploy**: [command or process]
381: 
382: ### Key Workflows
383: - **Adding Features**: [typical process]
384: - **Testing**: [testing workflow]
385: - **Deployment**: [deployment process]
386: 
387: ## Focus Areas (if specified)
388: [Detailed analysis of specified focus area]
389: ```
390: 
391: ### Auto-Import Setup
392: 1. **Update CLAUDE.md**: Add `@.claude/PROJECT_MAP.md` import
393: 2. **Verify Import**: Ensure import syntax is correct
394: 3. **Test Loading**: Validate the import works in Claude Code sessions
395: 
396: ## Phase 6: Validation and Updates
397: 
398: ### Validation Checks
399: 1. **File Accessibility**: Ensure all referenced files exist and are readable
400: 2. **Import Syntax**: Verify CLAUDE.md import syntax is correct
401: 3. **Content Accuracy**: Validate project map reflects actual codebase
402: 4. **Size Management**: Keep project map under 10KB for context efficiency
403: 
404: ### Update Strategy
405: 1. **Incremental Updates**: For `--update` mode, focus on changed files only
406: 2. **Timestamp Tracking**: Update modification timestamps appropriately
407: 3. **Change Detection**: Identify what has changed since last indexing
408: 4. **Selective Refresh**: Update only affected sections for efficiency
409: 
410: ## Success Indicators
411: 
412: - ✅ PROJECT_MAP.md created/updated in `.claude/` directory
413: - ✅ Auto-import added to CLAUDE.md file
414: - ✅ Project map accurately reflects codebase structure
415: - ✅ Key patterns and conventions documented
416: - ✅ Entry points and workflows clearly identified
417: - ✅ Dependencies and integrations mapped
418: - ✅ Focus area analysis completed (if specified)
419: - ✅ File size optimized for context window
420: 
421: ## Common Use Cases
422: 
423: ### New Project Onboarding
424: ```bash
425: /index
426: # → Comprehensive project map for new team members
427: ```
428: 
429: ### After Major Refactoring
430: ```bash
431: /index --refresh
432: # → Complete regeneration to reflect structural changes
433: ```
434: 
435: ### Focused Component Analysis
436: ```bash
437: /index "user authentication"
438: # → Detailed analysis of auth-related components
439: ```
440: 
441: ### Incremental Updates
442: ```bash
443: /index --update
444: # → Quick update after adding new features
445: ```
446: 
447: ## Integration with Other Commands
448: 
449: - **Analyze**: `/analyze` now has persistent context from PROJECT_MAP.md
450: - **Explore**: `/explore` benefits from existing project understanding
451: - **Review**: `/review` uses project map for focused code review
452: - **Fix**: `/fix` leverages architecture understanding for better debugging
453: 
454: ---
455: 
456: *Creates persistent project understanding that survives sessions and accelerates development workflows.*
````

## File: plugins/core/commands/performance.md
````markdown
  1: ---
  2: title: performance
  3: aliases: [metrics, usage, cost]
  4: description: View token usage and performance metrics
  5: ---
  6: 
  7: # Performance Metrics
  8: 
  9: View token usage, costs, and performance metrics for your Claude Code sessions.
 10: 
 11: ## Usage
 12: 
 13: ```bash
 14: # View current session metrics
 15: /performance
 16: 
 17: # View daily metrics
 18: /performance daily
 19: 
 20: # View weekly metrics
 21: /performance weekly
 22: 
 23: # View monthly metrics
 24: /performance monthly
 25: 
 26: # Get help with ccusage
 27: /performance help
 28: ```
 29: 
 30: ## Implementation
 31: 
 32: ```bash
 33: # Check if ccusage is available
 34: if ! command -v npx >/dev/null 2>&1; then
 35:     echo "❌ Performance monitoring requires npx (Node.js)"
 36:     echo ""
 37:     echo "To enable performance tracking:"
 38:     echo "1. Install Node.js: https://nodejs.org/"
 39:     echo "2. Run: npx ccusage@latest"
 40:     exit 1
 41: fi
 42: 
 43: # Parse arguments
 44: TIMEFRAME="${ARGUMENTS:-session}"
 45: 
 46: echo "📊 Claude Code Performance Metrics"
 47: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 48: echo ""
 49: 
 50: case "$TIMEFRAME" in
 51:     daily|day)
 52:         echo "📅 Daily Usage Report"
 53:         npx ccusage@latest daily
 54:         ;;
 55:     weekly|week)
 56:         echo "📅 Weekly Usage Report"
 57:         npx ccusage@latest weekly
 58:         ;;
 59:     monthly|month)
 60:         echo "📅 Monthly Usage Report"
 61:         npx ccusage@latest monthly
 62:         ;;
 63:     help|--help)
 64:         echo "📚 ccusage Help"
 65:         npx ccusage@latest --help
 66:         ;;
 67:     session|*)
 68:         echo "💬 Current Session Metrics"
 69:         npx ccusage@latest session
 70: 
 71:         # Also show daily summary
 72:         echo ""
 73:         echo "📅 Today's Summary"
 74:         npx ccusage@latest daily
 75:         ;;
 76: esac
 77: 
 78: echo ""
 79: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 80: echo ""
 81: echo "💡 Performance Tips:"
 82: echo "   • Use MCP tools for efficiency:"
 83: echo "     - Serena: 70-90% token reduction on code operations"
 84: echo "     - Context7: 50% faster documentation lookup"
 85: echo "     - Sequential Thinking: Better analysis with fewer iterations"
 86: echo "   • Monitor usage regularly to optimize workflows"
 87: echo "   • Consider caching frequently accessed documentation"
 88: ```
 89: 
 90: ## Features
 91: 
 92: ### Token Usage Tracking
 93: - Session-level metrics
 94: - Daily, weekly, monthly aggregation
 95: - Cost calculation based on model pricing
 96: 
 97: ### Performance Insights
 98: When available, tracks:
 99: - Token consumption by command
100: - MCP tool efficiency gains
101: - Session duration and patterns
102: 
103: ### MCP Tool Impact
104: Estimated efficiency gains:
105: - **Serena**: 70-90% token reduction on code analysis
106: - **Context7**: 50% faster documentation access
107: - **Sequential Thinking**: 20-30% better analysis quality
108: - **Firecrawl**: Efficient web content extraction
109: 
110: ## Graceful Degradation
111: 
112: Without ccusage, the command provides guidance on:
113: - How to install Node.js and enable tracking
114: - Manual estimation of token usage
115: - Best practices for efficient Claude Code usage
116: 
117: ## Integration
118: 
119: Performance metrics integrate with:
120: - Session management in `/status`
121: - Work unit tracking in `/work`
122: - Project analysis in `/analyze`
123: 
124: ---
125: 
126: *Simplified performance monitoring using ccusage for token tracking and cost analysis*
````

## File: plugins/core/commands/serena.md
````markdown
 1: ---
 2: title: "Serena Project Management"
 3: description: "Activate and manage Serena semantic code understanding for projects"
 4: author: "Lean MCP Framework"
 5: version: "1.0.0"
 6: ---
 7: 
 8: # Serena Project Management
 9: 
10: Activate Serena's semantic code understanding for efficient, token-optimized code operations.
11: 
12: ## Usage
13: - `/serena` - Show available projects and current status
14: - `/serena [project]` - Activate specific project
15: 
16: $ARGUMENTS_PRESENT$
17: I'll activate Serena project: **$ARGUMENTS**
18: 
19: Let me activate the project and show you the available context. I'll use the Serena MCP tools to:
20: 
21: 1. Activate the project: $ARGUMENTS
22: 2. Check if onboarding was performed
23: 3. List available memories
24: 4. Show current project status
25: 
26: This will enable semantic code operations with 75% token reduction on code tasks.
27: $END_ARGUMENTS_PRESENT$
28: 
29: $ARGUMENTS_ABSENT$
30: Let me show you the current Serena status and available projects.
31: 
32: I'll check your Serena configuration and list all available projects that you can activate.
33: $END_ARGUMENTS_ABSENT$
34: 
35: ## Serena Benefits
36: 
37: When activated, you get:
38: 
39: ### 🎯 Semantic Operations (75% token reduction)
40: - **find_symbol**: Locate functions/classes by name, not text search
41: - **get_symbols_overview**: See file structure without reading entire file
42: - **replace_symbol_body**: Edit entire functions/methods precisely
43: - **find_referencing_symbols**: Track what uses your code
44: 
45: ### 📊 Token Savings Example
46: Traditional approach (high tokens):
47: ```bash
48: grep -r "function_name" .  # Searches all files
49: cat entire_file.py         # Reads 1000+ lines
50: ```
51: 
52: Serena approach (low tokens):
53: ```bash
54: find_symbol("function_name")  # Returns just the function
55: ```
56: 
57: ### 💾 Persistent Memory
58: - Project understanding persists across sessions
59: - Task progress tracked in memories
60: - Code conventions remembered
61: 
62: ## Your Project Quick Reference
63: 
64: Based on your Serena configuration:
65: 
66: - **my-api** - Your API project
67: - **my-frontend** - Your frontend project
68: 
69: ### Quick Commands:
70: ```bash
71: /serena my-api         # Activate API project
72: /serena my-frontend    # Activate frontend project
73: /serena /new/path      # Activate new project by path
74: ```
75: 
76: ---
77: 
78: *Part of the Lean MCP Framework - Evidence-based 75% token reduction on code operations*
````

## File: plugins/core/commands/setup.md
````markdown
   1: ---
   2: allowed-tools: [Read, Write, MultiEdit, Bash, Glob, mcp__context7__resolve-library-id, mcp__context7__get-library-docs]
   3: argument-hint: "[explore|existing|python|javascript] [project-name] [--minimal|--standard|--full] | --init-user [--force] | --statusline"
   4: description: Initialize new projects with Claude framework integration or setup user configuration
   5: ---
   6: 
   7: # Project Setup
   8: 
   9: I'll set up a new project with the Claude Code Framework, optimized for your chosen language and project type.
  10: 
  11: ## Usage
  12: 
  13: ### User Configuration Setup
  14: ```bash
  15: /setup --init-user               # Initialize ~/.claude/CLAUDE.md from template
  16: /setup --init-user --force       # Overwrite existing user configuration
  17: /setup --statusline              # Configure Claude Code statusline for framework
  18: ```
  19: 
  20: ### Project Setup
  21: ```bash
  22: /setup                           # Auto-detect project type and set up
  23: /setup python                    # Set up Python project (standard quality setup)
  24: /setup python --minimal          # Minimal Python setup (basic structure only)
  25: /setup python --full             # Comprehensive setup (docs, CI/CD, etc.)
  26: /setup javascript                # Set up JavaScript project
  27: /setup existing                  # Add Claude framework to existing project
  28: /setup explore                   # Set up data exploration project
  29: ```
  30: 
  31: ### Python Setup Levels
  32: 
  33: #### `--minimal` - Just the Essentials
  34: **What you get:**
  35: - Basic `pyproject.toml` with project metadata
  36: - Minimal `.gitignore` for Python projects
  37: - Simple project structure (`src/`, `tests/`, `docs/`)
  38: - Build system configuration (hatchling)
  39: 
  40: **Best for:** Quick experiments, learning projects, temporary code
  41: 
  42: #### `--standard` (default) - Production-Ready Quality
  43: **What you get:**
  44: - Modern `pyproject.toml` with:
  45:   - Testing: pytest with coverage tracking
  46:   - Linting: ruff for fast, comprehensive checks
  47:   - Type checking: mypy for type safety
  48:   - Formatting: ruff format for consistent style
  49: - Pre-commit hooks for automated quality checks
  50: - Makefile with development commands (test, lint, format, etc.)
  51: - Comprehensive `.gitignore` for Python projects
  52: - Proper project structure with `src/` layout
  53: 
  54: **Best for:** Real projects, open source packages, team development
  55: 
  56: #### `--full` - Enterprise-Grade Setup
  57: **What you get:**
  58: Everything from standard, plus:
  59: - Documentation setup (mkdocs with material theme)
  60: - Security scanning (bandit)
  61: - CI/CD workflows (GitHub Actions)
  62: - Extended testing setup (fixtures, coverage reports)
  63: - Additional development tools
  64: - Release automation setup
  65: - Dependency management configuration
  66: 
  67: **Best for:** Commercial products, large teams, projects requiring compliance
  68: 
  69: ## Phase 1: Project Analysis
  70: 
  71: ```bash
  72: # Constants (must be defined in each command due to framework constraints)
  73: readonly CLAUDE_DIR=".claude"
  74: readonly WORK_DIR="${CLAUDE_DIR}/work"
  75: readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
  76: readonly REFERENCE_DIR="${CLAUDE_DIR}/reference"
  77: readonly HOOKS_DIR="${CLAUDE_DIR}/hooks"
  78: 
  79: # Project type constants
  80: readonly TYPE_PYTHON="python"
  81: readonly TYPE_JAVASCRIPT="javascript"
  82: readonly TYPE_EXPLORE="explore"
  83: readonly TYPE_EXISTING="existing"
  84: 
  85: # Parse command line arguments
  86: INIT_USER=false
  87: FORCE_FLAG=false
  88: SETUP_STATUSLINE=false
  89: REMAINING_ARGS=""
  90: 
  91: # Parse arguments for flags
  92: SETUP_LEVEL="standard"  # Default to standard setup
  93: for arg in $ARGUMENTS; do
  94:     case "$arg" in
  95:         --init-user)
  96:             INIT_USER=true
  97:             ;;
  98:         --force)
  99:             FORCE_FLAG=true
 100:             ;;
 101:         --statusline)
 102:             SETUP_STATUSLINE=true
 103:             ;;
 104:         --minimal)
 105:             SETUP_LEVEL="minimal"
 106:             ;;
 107:         --standard)
 108:             SETUP_LEVEL="standard"
 109:             ;;
 110:         --full)
 111:             SETUP_LEVEL="full"
 112:             ;;
 113:         *)
 114:             REMAINING_ARGS="$REMAINING_ARGS $arg"
 115:             ;;
 116:     esac
 117: done
 118: 
 119: # Handle --init-user mode
 120: if [ "$INIT_USER" = true ]; then
 121:     echo "🔧 Initializing user CLAUDE.md configuration..."
 122:     echo ""
 123: 
 124:     # Check if ~/.claude directory exists, create if needed
 125:     USER_CLAUDE_DIR="$HOME/.claude"
 126:     USER_CLAUDE_FILE="$USER_CLAUDE_DIR/CLAUDE.md"
 127:     TEMPLATE_FILE="$(pwd)/templates/USER_CLAUDE_TEMPLATE.md"
 128: 
 129:     # Verify template exists
 130:     if [ ! -f "$TEMPLATE_FILE" ]; then
 131:         echo "❌ ERROR: USER_CLAUDE_TEMPLATE.md not found at $TEMPLATE_FILE"
 132:         echo "   Make sure you're running this from the Claude Code framework directory."
 133:         exit 1
 134:     fi
 135: 
 136:     # Create ~/.claude directory if it doesn't exist
 137:     if [ ! -d "$USER_CLAUDE_DIR" ]; then
 138:         echo "📁 Creating ~/.claude directory..."
 139:         mkdir -p "$USER_CLAUDE_DIR" || {
 140:             echo "❌ ERROR: Failed to create ~/.claude directory"
 141:             echo "   Check permissions for $HOME directory"
 142:             exit 1
 143:         }
 144:     fi
 145: 
 146:     # Check if user CLAUDE.md already exists
 147:     if [ -f "$USER_CLAUDE_FILE" ] && [ "$FORCE_FLAG" != true ]; then
 148:         echo "⚠️  User CLAUDE.md already exists at: $USER_CLAUDE_FILE"
 149:         echo ""
 150:         echo "Options:"
 151:         echo "  1. Keep existing file (recommended if you've customized it)"
 152:         echo "  2. Overwrite with latest template (use --force flag)"
 153:         echo ""
 154:         echo "To overwrite: /setup --init-user --force"
 155:         echo "To view existing: cat ~/.claude/CLAUDE.md"
 156:         exit 0
 157:     fi
 158: 
 159:     # Copy template to user location
 160:     echo "📋 Copying USER_CLAUDE_TEMPLATE.md to ~/.claude/CLAUDE.md..."
 161:     cp "$TEMPLATE_FILE" "$USER_CLAUDE_FILE" || {
 162:         echo "❌ ERROR: Failed to copy template file"
 163:         echo "   Check permissions for ~/.claude directory"
 164:         exit 1
 165:     }
 166: 
 167:     echo ""
 168:     echo "✅ User CLAUDE.md configuration initialized successfully!"
 169:     echo ""
 170:     echo "📍 Location: $USER_CLAUDE_FILE"
 171:     echo "📝 Content: Essential behavioral guidelines and SWE best practices"
 172:     echo ""
 173:     echo "What's included:"
 174:     echo "  • Core behavioral tenets (question assumptions, avoid over-engineering)"
 175:     echo "  • MCP tool usage guidelines"
 176:     echo "  • Framework commands and workflow patterns"
 177:     echo ""
 178:     echo "Next steps:"
 179:     echo "  • Edit with: /memory edit"
 180:     echo "  • View with: /memory view"
 181:     echo "  • Customize for your personal workflow"
 182:     echo "  • Use /setup [type] in project directories for project-specific setup"
 183:     echo "  • The user config provides global standards for all projects"
 184:     echo ""
 185:     if [ "$FORCE_FLAG" = true ]; then
 186:         echo "🔄 Existing file was overwritten as requested"
 187:     fi
 188: 
 189:     exit 0
 190: fi
 191: 
 192: # Handle --statusline mode
 193: if [ "$SETUP_STATUSLINE" = true ]; then
 194:     echo "🎯 Setting up Claude Code Framework Statusline"
 195:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 196:     echo ""
 197: 
 198:     # Check if we're in a framework directory
 199:     if [ ! -d ".claude" ] || [ ! -f "commands/setup.md" ]; then
 200:         echo "❌ ERROR: Not in Claude Code Framework directory"
 201:         echo "   Run this command from the root of your claude-code-framework directory"
 202:         echo ""
 203:         echo "Expected structure:"
 204:         echo "  claude-code-framework/"
 205:         echo "  ├── commands/"
 206:         echo "  ├── .claude/"
 207:         echo "  └── templates/"
 208:         exit 1
 209:     fi
 210: 
 211:     # Create statusline script in framework
 212:     STATUSLINE_SCRIPT="$(pwd)/.claude/scripts/statusline.sh"
 213:     echo "📝 Creating framework statusline script..."
 214: 
 215:     # Ensure scripts directory exists
 216:     mkdir -p .claude/scripts
 217: 
 218:     # Copy our prototype script
 219:     if [ -f ".claude/work/current/001_statusline_exploration/statusline_prototype.sh" ]; then
 220:         cp ".claude/work/current/001_statusline_exploration/statusline_prototype.sh" "$STATUSLINE_SCRIPT"
 221:     else
 222:         # Create the script inline if prototype not available
 223:         cat > "$STATUSLINE_SCRIPT" << 'STATUSLINE_EOF'
 224: #!/bin/bash
 225: # Claude Code Framework Statusline
 226: # Provides contextual information about current development session
 227: 
 228: # Read JSON input from Claude Code
 229: input=$(cat)
 230: 
 231: # Extract basic session info with jq fallback
 232: if command -v jq >/dev/null 2>&1; then
 233:     MODEL_DISPLAY=$(echo "$input" | jq -r '.model.display_name // "Claude"')
 234:     CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir // ""')
 235: else
 236:     # Fallback parsing without jq
 237:     MODEL_DISPLAY="Claude"
 238:     CURRENT_DIR=$(pwd)
 239: fi
 240: 
 241: # Get directory name for display
 242: if [ -n "$CURRENT_DIR" ]; then
 243:     DIR_NAME="${CURRENT_DIR##*/}"
 244: else
 245:     DIR_NAME="$(basename "$(pwd)")"
 246: fi
 247: 
 248: # Initialize status components
 249: STATUS_PARTS=()
 250: 
 251: # 1. Model and Directory (always shown)
 252: STATUS_PARTS+=("[$MODEL_DISPLAY] 📁 $DIR_NAME")
 253: 
 254: # 2. Framework Work Unit Detection
 255: WORK_UNIT=""
 256: if [ -f ".claude/work/ACTIVE_WORK" ]; then
 257:     ACTIVE_WORK=$(cat .claude/work/ACTIVE_WORK 2>/dev/null)
 258:     if [ -n "$ACTIVE_WORK" ] && [ -d ".claude/work/current/$ACTIVE_WORK" ]; then
 259:         WORK_NUM=$(echo "$ACTIVE_WORK" | cut -d'_' -f1)
 260:         if command -v jq >/dev/null 2>&1 && [ -f ".claude/work/current/$ACTIVE_WORK/metadata.json" ]; then
 261:             WORK_PHASE=$(jq -r '.phase // "active"' ".claude/work/current/$ACTIVE_WORK/metadata.json" 2>/dev/null)
 262:         else
 263:             WORK_PHASE="active"
 264:         fi
 265:         WORK_UNIT="💼 $WORK_NUM ($WORK_PHASE)"
 266:     fi
 267: elif [ -d ".claude/work/current" ]; then
 268:     CURRENT_COUNT=$(find .claude/work/current -maxdepth 1 -type d 2>/dev/null | wc -l)
 269:     if [ "$CURRENT_COUNT" -gt 1 ]; then
 270:         LATEST_WORK=$(ls -t .claude/work/current/ 2>/dev/null | head -1)
 271:         if [ -n "$LATEST_WORK" ]; then
 272:             WORK_NUM=$(echo "$LATEST_WORK" | cut -d'_' -f1)
 273:             WORK_UNIT="💼 $WORK_NUM (inactive)"
 274:         fi
 275:     fi
 276: fi
 277: 
 278: if [ -n "$WORK_UNIT" ]; then
 279:     STATUS_PARTS+=("$WORK_UNIT")
 280: fi
 281: 
 282: # 3. Git Status (if in git repo)
 283: if git rev-parse --git-dir >/dev/null 2>&1; then
 284:     GIT_BRANCH=$(git branch --show-current 2>/dev/null)
 285:     if [ -n "$GIT_BRANCH" ]; then
 286:         GIT_STATUS=""
 287:         if ! git diff-index --quiet HEAD -- 2>/dev/null; then
 288:             GIT_STATUS="*"
 289:         fi
 290:         if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
 291:             GIT_STATUS="${GIT_STATUS}+"
 292:         fi
 293:         STATUS_PARTS+=("🌿 $GIT_BRANCH$GIT_STATUS")
 294:     fi
 295: fi
 296: 
 297: # 4. MCP Server Status (simplified)
 298: if [ -f ".claude/settings.json" ] || [ -f ".claude/settings.local.json" ]; then
 299:     MCP_COUNT=0
 300:     for settings_file in ".claude/settings.json" ".claude/settings.local.json"; do
 301:         if [ -f "$settings_file" ] && command -v jq >/dev/null 2>&1; then
 302:             MCP_SERVERS=$(jq -r '.mcpServers // {} | keys | length' "$settings_file" 2>/dev/null)
 303:             if [ "$MCP_SERVERS" != "null" ] && [ "$MCP_SERVERS" -gt 0 ]; then
 304:                 MCP_COUNT=$((MCP_COUNT + MCP_SERVERS))
 305:             fi
 306:         fi
 307:     done
 308:     if [ "$MCP_COUNT" -gt 0 ]; then
 309:         STATUS_PARTS+=("🔧 MCP:$MCP_COUNT")
 310:     fi
 311: fi
 312: 
 313: # Combine all status parts
 314: IFS=" | "
 315: echo "${STATUS_PARTS[*]}"
 316: STATUSLINE_EOF
 317:     fi
 318: 
 319:     chmod +x "$STATUSLINE_SCRIPT"
 320:     echo "✅ Statusline script created: $STATUSLINE_SCRIPT"
 321: 
 322:     # Update user settings to include statusline
 323:     USER_SETTINGS="$HOME/.claude/settings.json"
 324: 
 325:     # Ensure ~/.claude directory exists
 326:     if [ ! -d "$HOME/.claude" ]; then
 327:         echo "📁 Creating ~/.claude directory..."
 328:         mkdir -p "$HOME/.claude"
 329:     fi
 330: 
 331:     # Create or update settings.json
 332:     if [ -f "$USER_SETTINGS" ]; then
 333:         echo "🔧 Updating existing ~/.claude/settings.json..."
 334: 
 335:         # Backup existing settings
 336:         cp "$USER_SETTINGS" "$USER_SETTINGS.backup.$(date +%Y%m%d_%H%M%S)"
 337: 
 338:         # Update settings with jq if available
 339:         if command -v jq >/dev/null 2>&1; then
 340:             jq --arg script "$STATUSLINE_SCRIPT" '.statusLine.command = $script' "$USER_SETTINGS" > "$USER_SETTINGS.tmp" && mv "$USER_SETTINGS.tmp" "$USER_SETTINGS"
 341:         else
 342:             echo "⚠️  jq not available - please manually add statusline configuration"
 343:             echo "   Add this to ~/.claude/settings.json:"
 344:             echo "   \"statusLine\": { \"command\": \"$STATUSLINE_SCRIPT\" }"
 345:         fi
 346:     else
 347:         echo "📝 Creating new ~/.claude/settings.json..."
 348:         cat > "$USER_SETTINGS" << EOF
 349: {
 350:     "statusLine": {
 351:         "command": "$STATUSLINE_SCRIPT"
 352:     }
 353: }
 354: EOF
 355:     fi
 356: 
 357:     echo ""
 358:     echo "✅ Claude Code Framework Statusline Setup Complete!"
 359:     echo ""
 360:     echo "📍 Configuration:"
 361:     echo "   Script: $STATUSLINE_SCRIPT"
 362:     echo "   Settings: $USER_SETTINGS"
 363:     echo ""
 364:     echo "🎯 What you'll see:"
 365:     echo "   [Model] 📁 project | 💼 001 (exploring) | 🌿 main | 🔧 MCP:4"
 366:     echo ""
 367:     echo "📝 Features:"
 368:     echo "   • Current work unit and phase"
 369:     echo "   • Git branch and status indicators"
 370:     echo "   • MCP server count"
 371:     echo "   • Project directory name"
 372:     echo ""
 373:     echo "🔄 Restart Claude Code to see the new statusline"
 374:     echo ""
 375:     echo "💡 Tip: Edit $STATUSLINE_SCRIPT to customize your statusline"
 376: 
 377:     exit 0
 378: fi
 379: 
 380: # Standard project setup continues below
 381: PROJECT_NAME="${REMAINING_ARGS:-$(basename $PWD)}"
 382: SETUP_TYPE=""
 383: 
 384: echo "🔍 Analyzing project..."
 385: 
 386: # Check if explicit type was provided as argument
 387: if [ -n "$PROJECT_NAME" ]; then
 388:     # Check if it's a known project type
 389:     case "$PROJECT_NAME" in
 390:         python|javascript|typescript|go|rust|java|explore|existing)
 391:             SETUP_TYPE="$PROJECT_NAME"
 392:             PROJECT_NAME=$(basename $PWD)
 393:             echo "→ Setting up $SETUP_TYPE project"
 394:             ;;
 395:         *)
 396:             # It's a project name, auto-detect type
 397:             echo "→ Project name: $PROJECT_NAME"
 398:             ;;
 399:     esac
 400: fi
 401: 
 402: # Auto-detect project type if not specified
 403: if [ -z "$SETUP_TYPE" ]; then
 404:     # Check for existing project
 405:     if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
 406:         if [ -d "src" ]; then
 407:             SETUP_TYPE="python-package"
 408:             echo "→ Detected: Python package project (src/ layout)"
 409:         else
 410:             SETUP_TYPE="python-simple"
 411:             echo "→ Detected: Python project (simple layout)"
 412:         fi
 413:     elif [ -f "package.json" ]; then
 414:         SETUP_TYPE="javascript"
 415:         echo "→ Detected: JavaScript/Node.js project"
 416:     elif [ -f "Cargo.toml" ]; then
 417:         SETUP_TYPE="rust"
 418:         echo "→ Detected: Rust project"
 419:     elif [ -f "go.mod" ]; then
 420:         SETUP_TYPE="go"
 421:         echo "→ Detected: Go project"
 422:     elif [ -d ".git" ] && [ "$(ls -A | wc -l)" -gt 2 ]; then
 423:         SETUP_TYPE="existing"
 424:         echo "→ Detected: Existing project (adding Claude framework)"
 425:     elif ls *.ipynb >/dev/null 2>&1 || [ -d "notebooks" ] || [ -d "data" ]; then
 426:         SETUP_TYPE="explore"
 427:         echo "→ Detected: Data exploration project"
 428:     else
 429:         # Empty or new directory - default to Python
 430:         SETUP_TYPE="python-package"
 431:         echo "→ New project: Defaulting to Python package setup"
 432:     fi
 433: fi
 434: ```
 435: 
 436: ## Phase 2: Project Initialization
 437: 
 438: Based on detection, I'll run the appropriate setup:
 439: 
 440: ```bash
 441: case "$SETUP_TYPE" in
 442:     python-package|python)
 443:         echo "🐍 Setting up Python package project..."
 444: 
 445:         # Create src layout
 446:         mkdir -p src/$PROJECT_NAME
 447:         mkdir -p tests
 448:         mkdir -p docs
 449: 
 450:         # Use declarative approach based on setup level
 451:         echo "📋 Generating $SETUP_LEVEL Python configuration..."
 452: 
 453:         case "$SETUP_LEVEL" in
 454:             minimal)
 455:                 echo "Creating minimal Python project..."
 456: 
 457:                 # Basic pyproject.toml only
 458:                 cat > pyproject.toml << 'MINIMAL_EOF'
 459: [project]
 460: name = "$PROJECT_NAME"
 461: version = "0.1.0"
 462: description = "A Python package"
 463: requires-python = ">=3.9"
 464: dependencies = []
 465: 
 466: [build-system]
 467: requires = ["hatchling"]
 468: build-backend = "hatchling.build"
 469: MINIMAL_EOF
 470:                 # Variable substitution
 471:                 sed -i "s/\$PROJECT_NAME/$PROJECT_NAME/g" pyproject.toml
 472: 
 473:                 # Minimal gitignore
 474:                 cat > .gitignore << 'GITIGNORE_EOF'
 475: __pycache__/
 476: *.py[cod]
 477: *$py.class
 478: *.so
 479: .Python
 480: build/
 481: dist/
 482: *.egg-info/
 483: .pytest_cache/
 484: .mypy_cache/
 485: .ruff_cache/
 486: venv/
 487: .venv/
 488: *.log
 489: .DS_Store
 490: GITIGNORE_EOF
 491: 
 492:                 echo "✅ Minimal Python setup complete"
 493:                 ;;
 494: 
 495:             full)
 496:                 echo "Creating comprehensive Python project with all features..."
 497:                 echo ""
 498:                 echo "📝 Generating comprehensive configuration files..."
 499: 
 500:                 # Note: In a declarative approach, Claude Code would generate these
 501:                 # based on current best practices. For now, we provide guidance.
 502:                 echo ""
 503:                 echo "I'll create a comprehensive Python setup. Please create these files:"
 504:                 echo ""
 505:                 echo "1. pyproject.toml - with latest versions of:"
 506:                 echo "   - ruff, mypy, pytest, pytest-cov, bandit"
 507:                 echo "   - mkdocs, mkdocs-material for documentation"
 508:                 echo "   - pre-commit for git hooks"
 509:                 echo ""
 510:                 echo "2. .pre-commit-config.yaml with:"
 511:                 echo "   - ruff (format and lint)"
 512:                 echo "   - mypy (type checking)"
 513:                 echo "   - bandit (security)"
 514:                 echo "   - conventional commits"
 515:                 echo ""
 516:                 echo "3. Makefile with targets for:"
 517:                 echo "   - install, dev, test, lint, format, type-check"
 518:                 echo "   - security, docs, build, clean"
 519:                 echo ""
 520:                 echo "4. .github/workflows/ci.yml for GitHub Actions"
 521:                 echo "5. mkdocs.yml for documentation"
 522:                 echo "6. Comprehensive .gitignore"
 523: 
 524:                 echo ""
 525:                 echo "✅ Full setup requirements specified"
 526:                 ;;
 527: 
 528:             standard|*)
 529:                 echo "Creating standard Python project with quality tools..."
 530: 
 531:                 # Generate standard pyproject.toml with current best practices
 532:                 cat > pyproject.toml << 'STANDARD_EOF'
 533: [project]
 534: name = "$PROJECT_NAME"
 535: version = "0.1.0"
 536: description = "A Python package"
 537: requires-python = ">=3.9"
 538: dependencies = []
 539: 
 540: [project.optional-dependencies]
 541: dev = [
 542:     "pytest>=8.0",
 543:     "pytest-cov>=5.0",
 544:     "ruff>=0.5.0",
 545:     "mypy>=1.10",
 546:     "pre-commit>=3.7",
 547: ]
 548: 
 549: [build-system]
 550: requires = ["hatchling"]
 551: build-backend = "hatchling.build"
 552: 
 553: [tool.ruff]
 554: line-length = 88
 555: target-version = "py39"
 556: 
 557: [tool.ruff.lint]
 558: select = ["E", "F", "I", "N", "W", "UP"]
 559: ignore = ["E501"]  # Line length handled by formatter
 560: 
 561: [tool.mypy]
 562: python_version = "3.9"
 563: warn_return_any = true
 564: warn_unused_configs = true
 565: 
 566: [tool.pytest.ini_options]
 567: testpaths = ["tests"]
 568: addopts = "--cov=src --cov-report=term-missing"
 569: 
 570: [tool.coverage.run]
 571: source = ["src"]
 572: STANDARD_EOF
 573:                 # Variable substitution
 574:                 sed -i "s/\$PROJECT_NAME/$PROJECT_NAME/g" pyproject.toml
 575: 
 576:                 # Generate pre-commit config
 577:                 cat > .pre-commit-config.yaml << 'PRECOMMIT_EOF'
 578: repos:
 579:   - repo: https://github.com/pre-commit/pre-commit-hooks
 580:     rev: v4.6.0
 581:     hooks:
 582:       - id: trailing-whitespace
 583:       - id: end-of-file-fixer
 584:       - id: check-yaml
 585:       - id: check-added-large-files
 586: 
 587:   - repo: https://github.com/astral-sh/ruff-pre-commit
 588:     rev: v0.5.0
 589:     hooks:
 590:       - id: ruff
 591:         args: [--fix]
 592:       - id: ruff-format
 593: 
 594:   - repo: https://github.com/pre-commit/mirrors-mypy
 595:     rev: v1.10.0
 596:     hooks:
 597:       - id: mypy
 598:         files: ^src/
 599: PRECOMMIT_EOF
 600: 
 601:                 # Generate Makefile
 602:                 cat > Makefile << 'MAKEFILE_EOF'
 603: .PHONY: help install dev test lint format type-check clean
 604: 
 605: help:
 606: 	@echo "Available commands:"
 607: 	@echo "  make install    Install package"
 608: 	@echo "  make dev        Install with dev dependencies"
 609: 	@echo "  make test       Run tests"
 610: 	@echo "  make lint       Run linting"
 611: 	@echo "  make format     Format code"
 612: 	@echo "  make type-check Run type checking"
 613: 	@echo "  make clean      Clean build artifacts"
 614: 
 615: install:
 616: 	pip install -e .
 617: 
 618: dev:
 619: 	pip install -e ".[dev]"
 620: 	pre-commit install
 621: 
 622: test:
 623: 	pytest
 624: 
 625: lint:
 626: 	ruff check src/ tests/
 627: 
 628: format:
 629: 	ruff format src/ tests/
 630: 
 631: type-check:
 632: 	mypy src/
 633: 
 634: clean:
 635: 	rm -rf build/ dist/ *.egg-info
 636: 	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
 637: 	find . -type f -name "*.pyc" -delete
 638: MAKEFILE_EOF
 639: 
 640:                 # Standard gitignore
 641:                 cat > .gitignore << 'GITIGNORE_EOF'
 642: # Python
 643: __pycache__/
 644: *.py[cod]
 645: *$py.class
 646: *.so
 647: .Python
 648: build/
 649: develop-eggs/
 650: dist/
 651: downloads/
 652: eggs/
 653: .eggs/
 654: lib/
 655: lib64/
 656: parts/
 657: sdist/
 658: var/
 659: wheels/
 660: *.egg-info/
 661: .installed.cfg
 662: *.egg
 663: MANIFEST
 664: 
 665: # Testing
 666: .pytest_cache/
 667: .coverage
 668: htmlcov/
 669: .tox/
 670: .mypy_cache/
 671: .ruff_cache/
 672: 
 673: # Virtual Environment
 674: venv/
 675: .venv/
 676: env/
 677: ENV/
 678: 
 679: # IDE
 680: .vscode/
 681: .idea/
 682: *.swp
 683: *.swo
 684: *~
 685: 
 686: # OS
 687: .DS_Store
 688: Thumbs.db
 689: 
 690: # Project
 691: *.log
 692: .env
 693: GITIGNORE_EOF
 694: 
 695:                 echo "✅ Standard Python setup complete"
 696:                 ;;
 697:         esac
 698: 
 699:         # Create basic Python files (common to both template and inline modes)
 700:         touch src/$PROJECT_NAME/__init__.py
 701:         cat > src/$PROJECT_NAME/main.py << EOF
 702: """Main module for $PROJECT_NAME."""
 703: 
 704: def main():
 705:     """Main entry point."""
 706:     print("Hello from $PROJECT_NAME!")
 707: 
 708: if __name__ == "__main__":
 709:     main()
 710: EOF
 711: 
 712:         # Create basic test
 713:         cat > tests/test_main.py << EOF
 714: """Tests for main module."""
 715: import pytest
 716: from $PROJECT_NAME.main import main
 717: 
 718: def test_main():
 719:     """Test main function."""
 720:     # Add your tests here
 721:     assert True
 722: EOF
 723: 
 724:         echo "✅ Python package structure created"
 725:         ;;
 726: 
 727:     python-simple|explore)
 728:         echo "🔬 Setting up Python exploration project..."
 729: 
 730:         # Create simple Python structure
 731:         mkdir -p scripts
 732:         mkdir -p data
 733:         mkdir -p notebooks
 734: 
 735:         # Create requirements.txt for simple projects
 736:         cat > requirements.txt << EOF
 737: # Core dependencies
 738: numpy
 739: pandas
 740: matplotlib
 741: 
 742: # Development tools
 743: pytest
 744: pytest-cov
 745: ruff
 746: black
 747: mypy
 748: jupyter
 749: EOF
 750: 
 751:         # Create basic Python file
 752:         cat > main.py << EOF
 753: """Main script for $PROJECT_NAME."""
 754: 
 755: def main():
 756:     """Main entry point."""
 757:     print("Hello from $PROJECT_NAME!")
 758: 
 759: if __name__ == "__main__":
 760:     main()
 761: EOF
 762: 
 763:         echo "✅ Python exploration structure created"
 764:         ;;
 765: 
 766:     javascript|js)
 767:         echo "🌐 Setting up JavaScript/Node.js project..."
 768: 
 769:         # Create package.json
 770:         cat > package.json << EOF
 771: {
 772:   "name": "$PROJECT_NAME",
 773:   "version": "0.1.0",
 774:   "description": "A JavaScript project",
 775:   "main": "src/index.js",
 776:   "scripts": {
 777:     "start": "node src/index.js",
 778:     "test": "jest",
 779:     "lint": "eslint src/",
 780:     "format": "prettier --write src/"
 781:   },
 782:   "devDependencies": {
 783:     "jest": "^29.0.0",
 784:     "eslint": "^8.0.0",
 785:     "prettier": "^3.0.0",
 786:     "@types/node": "^20.0.0"
 787:   }
 788: }
 789: EOF
 790: 
 791:         # Create basic structure
 792:         mkdir -p src
 793:         mkdir -p tests
 794: 
 795:         cat > src/index.js << EOF
 796: /**
 797:  * Main entry point for $PROJECT_NAME
 798:  */
 799: 
 800: function main() {
 801:     console.log("Hello from $PROJECT_NAME!");
 802: }
 803: 
 804: if (require.main === module) {
 805:     main();
 806: }
 807: 
 808: module.exports = { main };
 809: EOF
 810: 
 811:         cat > tests/index.test.js << EOF
 812: const { main } = require('../src/index');
 813: 
 814: describe('main function', () => {
 815:     test('should run without errors', () => {
 816:         expect(() => main()).not.toThrow();
 817:     });
 818: });
 819: EOF
 820: 
 821:         echo "✅ JavaScript project structure created"
 822:         ;;
 823: 
 824:     existing)
 825:         echo "🔧 Adding Claude framework to existing project..."
 826:         echo "✅ Existing project detected - will add Claude framework below"
 827:         ;;
 828: 
 829:     *)
 830:         echo "📦 Unknown type - using Python package setup (default)"
 831:         SETUP_TYPE="python-package"
 832:         # Recurse with corrected type
 833:         ;;
 834: esac
 835: ```
 836: 
 837: ## Phase 3: Claude Framework Integration
 838: 
 839: ```bash
 840: echo ""
 841: echo "🔧 Adding Claude Code Framework..."
 842: 
 843: # Create .claude directory structure
 844: mkdir -p .claude/work/current || { echo "ERROR: Failed to create .claude/work/current" >&2; exit 1; }
 845: mkdir -p .claude/work/completed || { echo "ERROR: Failed to create .claude/work/completed" >&2; exit 1; }
 846: mkdir -p .claude/memory || { echo "ERROR: Failed to create .claude/memory" >&2; exit 1; }
 847: mkdir -p .claude/reference || { echo "ERROR: Failed to create .claude/reference" >&2; exit 1; }
 848: mkdir -p .claude/hooks || { echo "ERROR: Failed to create .claude/hooks" >&2; exit 1; }
 849: 
 850: # Create security hooks configuration
 851: echo "🔒 Setting up security hooks..."
 852: cat > .claude/settings.json << 'SECURITY_EOF'
 853: {
 854:   "hooks": {
 855:     "PreToolUse": [
 856:       {
 857:         "matcher": "Bash",
 858:         "hooks": [
 859:           {
 860:             "type": "command",
 861:             "command": "input=\"$CLAUDE_TOOL_INPUT\"; if echo \"$input\" | grep -q 'rm -rf'; then echo '🚨 BLOCKED: Dangerous rm -rf command detected!' >&2 && echo 'Use git clean or specific file deletion instead.' >&2 && exit 2; fi; if echo \"$input\" | grep -q 'sudo'; then echo '🚨 BLOCKED: sudo command not allowed in development!' >&2 && echo 'Review your command and run manually if needed.' >&2 && exit 2; fi; if echo \"$input\" | grep -q 'chmod 777'; then echo '⚠️  BLOCKED: chmod 777 is a security risk!' >&2 && echo 'Use specific permissions like 755 or 644.' >&2 && exit 2; fi"
 862:           }
 863:         ]
 864:       }
 865:     ],
 866:     "PostToolUse": [
 867:       {
 868:         "matcher": "Edit|Write|MultiEdit",
 869:         "hooks": [
 870:           {
 871:             "type": "command",
 872:             "command": "file=\"$CLAUDE_TOOL_INPUT_FILE\"; if [ -n \"$file\" ]; then ext=\"${file##*.}\"; case \"$ext\" in py) echo '🔧 Python file edited: '$file && if command -v ruff >/dev/null 2>&1; then if ruff format \"$file\" 2>/dev/null; then echo '✅ ruff format applied'; else echo '⚠️  ruff format failed - check Python syntax'; fi && if ruff check \"$file\" --fix 2>/dev/null; then echo '✅ ruff linting passed'; else echo '⚠️  ruff found issues - review the warnings'; fi; else echo '💡 Install ruff for automatic formatting & linting: pip install ruff'; fi ;; js|jsx|ts|tsx) echo '🔧 JavaScript/TypeScript file edited: '$file && if command -v prettier >/dev/null 2>&1; then if prettier --write \"$file\" 2>/dev/null; then echo '✅ prettier formatting applied'; else echo '⚠️  prettier failed - check syntax'; fi; else echo '💡 Install prettier: npm install prettier'; fi && if command -v eslint >/dev/null 2>&1; then if eslint \"$file\" --fix 2>/dev/null; then echo '✅ eslint passed'; else echo '⚠️  eslint found issues - review the warnings'; fi; else echo '💡 Install eslint: npm install eslint'; fi ;; json) echo '🔧 JSON file edited: '$file && if python3 -m json.tool \"$file\" >/dev/null 2>&1; then echo '✅ JSON syntax valid'; else echo '❌ Invalid JSON syntax in '$file' - fix required!' >&2 && exit 1; fi ;; md) echo '📝 Markdown file edited: '$file && if command -v markdownlint >/dev/null 2>&1; then if markdownlint \"$file\" 2>/dev/null; then echo '✅ Markdown linting passed'; else echo '⚠️  Markdown formatting issues found'; fi; else echo '💡 Install markdownlint for markdown quality: npm install -g markdownlint-cli'; fi ;; esac; fi"
 873:           }
 874:         ]
 875:       }
 876:     ]
 877:   }
 878: }
 879: SECURITY_EOF
 880: 
 881: echo "✅ Security & Quality hooks configured:"
 882: echo "   🔒 Security: rm -rf, sudo, chmod 777 protection"
 883: echo "   🔧 Quality: automatic formatting (ruff, prettier, eslint)"
 884: echo "   📝 Validation: JSON syntax, markdown linting"
 885: echo "   🧪 Testing: pytest hints for new test files"
 886: 
 887: # Generate project CLAUDE.md declaratively
 888: echo "📝 Generating project CLAUDE.md and memory files..."
 889: 
 890: # Auto-detect project characteristics
 891: DETECTED_LANG=""
 892: DETECTED_FRAMEWORK=""
 893: DETECTED_TEST_TOOL=""
 894: DETECTED_BUILD=""
 895: 
 896: # Language detection
 897: if [ -f "package.json" ]; then
 898:     DETECTED_LANG="JavaScript/TypeScript"
 899:     grep -q '"next"' package.json 2>/dev/null && DETECTED_FRAMEWORK="Next.js"
 900:     grep -q '"react"' package.json 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, React" || DETECTED_FRAMEWORK="React"
 901:     grep -q '"express"' package.json 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, Express" || DETECTED_FRAMEWORK="Express"
 902:     grep -q '"jest"' package.json 2>/dev/null && DETECTED_TEST_TOOL="Jest"
 903:     grep -q '"mocha"' package.json 2>/dev/null && [ -n "$DETECTED_TEST_TOOL" ] && DETECTED_TEST_TOOL="$DETECTED_TEST_TOOL, Mocha" || DETECTED_TEST_TOOL="Mocha"
 904: elif [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "requirements.txt" ]; then
 905:     DETECTED_LANG="Python"
 906:     if command -v python3 >/dev/null 2>&1; then
 907:         PYTHON_VERSION=$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1,2)
 908:         DETECTED_LANG="Python $PYTHON_VERSION"
 909:     fi
 910:     if [ -f "pyproject.toml" ]; then
 911:         grep -q 'fastapi' pyproject.toml 2>/dev/null && DETECTED_FRAMEWORK="FastAPI"
 912:         grep -q 'django' pyproject.toml 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, Django" || DETECTED_FRAMEWORK="Django"
 913:         grep -q 'flask' pyproject.toml 2>/dev/null && [ -n "$DETECTED_FRAMEWORK" ] && DETECTED_FRAMEWORK="$DETECTED_FRAMEWORK, Flask" || DETECTED_FRAMEWORK="Flask"
 914:         grep -q 'pytest' pyproject.toml 2>/dev/null && DETECTED_TEST_TOOL="pytest"
 915:     fi
 916:     [ -f "Makefile" ] && DETECTED_BUILD="Make"
 917: elif [ -f "go.mod" ]; then
 918:     DETECTED_LANG="Go"
 919:     DETECTED_TEST_TOOL="go test"
 920: elif [ -f "Cargo.toml" ]; then
 921:     DETECTED_LANG="Rust"
 922:     DETECTED_TEST_TOOL="cargo test"
 923: fi
 924: 
 925: # Create minimal main CLAUDE.md with imports
 926: cat > CLAUDE.md << EOF
 927: # $PROJECT_NAME
 928: 
 929: ${DETECTED_LANG:+$DETECTED_LANG project}${DETECTED_FRAMEWORK:+ using $DETECTED_FRAMEWORK}.
 930: 
 931: ## Project Knowledge
 932: @.claude/memory/project_state.md
 933: @.claude/memory/dependencies.md
 934: @.claude/memory/conventions.md
 935: @.claude/memory/decisions.md
 936: 
 937: ## Current Work
 938: @.claude/work/current/README.md
 939: EOF
 940: 
 941: # Generate project_state.md with detected info
 942: cat > .claude/memory/project_state.md << 'STATE_EOF'
 943: # Project State
 944: 
 945: ## Technology Stack
 946: - **Language**: DETECTED_LANG_PLACEHOLDER
 947: - **Framework**: DETECTED_FRAMEWORK_PLACEHOLDER
 948: - **Testing**: DETECTED_TEST_PLACEHOLDER
 949: - **Build System**: DETECTED_BUILD_PLACEHOLDER
 950: 
 951: ## Architecture
 952: - **Project Type**: SETUP_TYPE_PLACEHOLDER
 953: - **Directory Structure**: DIR_STRUCTURE_PLACEHOLDER
 954: STATE_EOF
 955: 
 956: # Variable substitution for project_state.md
 957: sed -i "s/DETECTED_LANG_PLACEHOLDER/${DETECTED_LANG:-Not detected}/g" .claude/memory/project_state.md
 958: sed -i "s/DETECTED_FRAMEWORK_PLACEHOLDER/${DETECTED_FRAMEWORK:-Not detected}/g" .claude/memory/project_state.md
 959: sed -i "s/DETECTED_TEST_PLACEHOLDER/${DETECTED_TEST_TOOL:-Not detected}/g" .claude/memory/project_state.md
 960: sed -i "s/DETECTED_BUILD_PLACEHOLDER/${DETECTED_BUILD:-Not detected}/g" .claude/memory/project_state.md
 961: sed -i "s/SETUP_TYPE_PLACEHOLDER/$SETUP_TYPE/g" .claude/memory/project_state.md
 962: sed -i "s/DIR_STRUCTURE_PLACEHOLDER/$([ -d 'src' ] && echo 'src layout' || echo 'flat layout')/g" .claude/memory/project_state.md
 963: 
 964: # Generate dependencies.md from package files
 965: echo "# Dependencies" > .claude/memory/dependencies.md
 966: echo "" >> .claude/memory/dependencies.md
 967: if [ -f "package.json" ]; then
 968:     echo "## NPM Packages" >> .claude/memory/dependencies.md
 969:     if command -v jq >/dev/null 2>&1; then
 970:         jq -r '.dependencies // {} | to_entries[] | "- \(.key): \(.value)"' package.json 2>/dev/null >> .claude/memory/dependencies.md || echo "See package.json for dependencies" >> .claude/memory/dependencies.md
 971:     else
 972:         echo "See package.json for dependencies" >> .claude/memory/dependencies.md
 973:     fi
 974: elif [ -f "pyproject.toml" ]; then
 975:     echo "## Python Dependencies" >> .claude/memory/dependencies.md
 976:     echo "Extracted from pyproject.toml - see file for versions" >> .claude/memory/dependencies.md
 977: elif [ -f "requirements.txt" ]; then
 978:     echo "## Python Dependencies" >> .claude/memory/dependencies.md
 979:     head -20 requirements.txt >> .claude/memory/dependencies.md
 980:     [ $(wc -l < requirements.txt) -gt 20 ] && echo "... see requirements.txt for full list" >> .claude/memory/dependencies.md
 981: fi
 982: 
 983: # Create minimal conventions.md
 984: cat > .claude/memory/conventions.md << 'CONV_EOF'
 985: # Project Conventions
 986: 
 987: Add project-specific conventions here that differ from global standards.
 988: CONV_EOF
 989: 
 990: # Create placeholder decisions.md
 991: cat > .claude/memory/decisions.md << 'DEC_EOF'
 992: # Key Decisions
 993: 
 994: Document important architectural and technical decisions as the project evolves.
 995: DEC_EOF
 996: 
 997: # Create work README
 998: cat > .claude/work/current/README.md << 'WORK_EOF'
 999: # Current Work
1000: 
1001: Active development tasks and work units will appear here.
1002: WORK_EOF
1003: 
1004: echo "✅ Generated declarative project configuration"
1005: 
1006: # Skip the rest of the old CLAUDE.md creation
1007: true << 'SKIP_OLD_CONTENT'
1008: 
1009: \`\`\`bash
1010: # Enhanced development workflow (Lean MCP Framework active)
1011: /explore "feature to implement"
1012: /plan
1013: /next
1014: /ship
1015: 
1016: # For code projects, activate semantic understanding:
1017: /serena \$(pwd)
1018: \`\`\`
1019: 
1020: ## Lean MCP Framework Active
1021: 
1022: This project benefits from the globally active Lean MCP Framework with:
1023: - **75% token reduction** on code operations (when Serena available)
1024: - **Enhanced reasoning** for complex analysis (Sequential Thinking)
1025: - **Live documentation** access (Context7)
1026: - **Graceful degradation** when MCP tools unavailable
1027: 
1028: ## Project Conventions
1029: 
1030: - Follow conventional commits (feat:, fix:, docs:, etc.)
1031: - Use quality tools (ruff for Python, prettier for JavaScript)
1032: - Write tests for all new features
1033: - Keep project root clean - use .claude/ for work materials
1034: 
1035: ## Available Commands
1036: 
1037: **Core Workflow**: \`/explore\`, \`/plan\`, \`/next\`, \`/ship\`
1038: **Enhanced with MCP**: \`/analyze\`, \`/fix\`, \`/docs search\`
1039: **Serena Integration**: \`/serena [project-path]\` for semantic code understanding
1040: **Specialized Agents**: \`/agent architect\`, \`/agent test-engineer\`, \`/agent code-reviewer\`, \`/agent auditor\`
1041: 
1042: ## Development Workflow
1043: 
1044: 1. **Explore**: Understand requirements (\`/explore\`)
1045: 2. **Plan**: Break down into tasks (\`/plan\`)
1046: 3. **Execute**: Work through tasks (\`/next\`)
1047: 4. **Ship**: Deliver completed work (\`/ship\`)
1048: 
1049: ## Enhanced Capabilities
1050: 
1051: When MCP tools are available:
1052: - **Code Analysis**: Use \`/analyze\` for semantic understanding
1053: - **Smart Debugging**: Use \`/fix\` with context-aware assistance
1054: - **Live Documentation**: Use \`/docs search "topic"\` for instant answers
1055: - **Complex Reasoning**: Commands automatically use Sequential Thinking when beneficial
1056: 
1057: Setup MCP servers to unlock these capabilities (graceful fallback ensures everything works regardless).
1058: 
1059: EOF
1060: SKIP_OLD_CONTENT
1061: 
1062: # Create basic README
1063: if [ ! -f "README.md" ]; then
1064:     cat > README.md << EOF
1065: # $PROJECT_NAME
1066: 
1067: ## Overview
1068: 
1069: Brief description of what this project does.
1070: 
1071: ## Installation
1072: 
1073: \`\`\`bash
1074: # For Python projects
1075: pip install -e .
1076: 
1077: # For JavaScript projects
1078: npm install
1079: \`\`\`
1080: 
1081: ## Development
1082: 
1083: \`\`\`bash
1084: # Run tests
1085: pytest  # Python
1086: npm test  # JavaScript
1087: 
1088: # Format code
1089: black .  # Python
1090: npm run format  # JavaScript
1091: \`\`\`
1092: 
1093: ## License
1094: 
1095: MIT
1096: EOF
1097: fi
1098: 
1099: # Initialize git if not present
1100: if [ ! -d ".git" ]; then
1101:     git init
1102:     echo "✅ Git repository initialized"
1103: fi
1104: 
1105: # Create .gitignore
1106: if [ ! -f ".gitignore" ]; then
1107:     cat > .gitignore << EOF
1108: # Claude work files (private)
1109: .claude/work/
1110: .claude/transitions/
1111: 
1112: # Language-specific ignores
1113: __pycache__/
1114: *.pyc
1115: *.pyo
1116: *.pyd
1117: .Python
1118: build/
1119: develop-eggs/
1120: dist/
1121: downloads/
1122: eggs/
1123: .eggs/
1124: lib/
1125: lib64/
1126: parts/
1127: sdist/
1128: var/
1129: wheels/
1130: *.egg-info/
1131: .installed.cfg
1132: *.egg
1133: 
1134: # Node.js
1135: node_modules/
1136: npm-debug.log*
1137: yarn-debug.log*
1138: yarn-error.log*
1139: 
1140: # IDE
1141: .vscode/
1142: .idea/
1143: *.swp
1144: *.swo
1145: 
1146: # OS
1147: .DS_Store
1148: Thumbs.db
1149: 
1150: # Environment
1151: .env
1152: .venv/
1153: venv/
1154: EOF
1155:     echo "✅ .gitignore created"
1156: fi
1157: 
1158: echo ""
1159: echo "📚 Setting up documentation access with Context7..."
1160: echo ""
1161: 
1162: # Context7 Integration for enhanced documentation
1163: if command -v claude >/dev/null 2>&1; then
1164:     echo "🔍 Detecting project dependencies for documentation setup..."
1165: 
1166:     # Detect dependencies based on project type
1167:     DEPS_TO_FETCH=""
1168:     case "$SETUP_TYPE" in
1169:         python-package|python-simple|explore)
1170:             if [ -f "pyproject.toml" ]; then
1171:                 echo "   → Scanning pyproject.toml for Python dependencies"
1172:                 DEPS_TO_FETCH="$DEPS_TO_FETCH pytest black ruff mypy"
1173:             elif [ -f "requirements.txt" ]; then
1174:                 echo "   → Scanning requirements.txt for Python dependencies"
1175:                 DEPS_TO_FETCH="$DEPS_TO_FETCH numpy pandas matplotlib pytest"
1176:             fi
1177:             ;;
1178:         javascript|js)
1179:             if [ -f "package.json" ]; then
1180:                 echo "   → Scanning package.json for Node.js dependencies"
1181:                 DEPS_TO_FETCH="$DEPS_TO_FETCH jest eslint prettier"
1182:             fi
1183:             ;;
1184:     esac
1185: 
1186:     # Create documentation cache directory
1187:     mkdir -p .claude/docs/libraries
1188: 
1189:     # Create Context7 documentation setup guide
1190:     cat > .claude/docs/CONTEXT7_SETUP.md << 'CONTEXT7_EOF'
1191: # Context7 Documentation Setup
1192: 
1193: ## What is Context7?
1194: 
1195: Context7 is an MCP server that provides intelligent, up-to-date documentation access for libraries and frameworks. Instead of manually searching documentation or copying large docs into your context, Context7 delivers precise, relevant documentation on demand.
1196: 
1197: ## Benefits
1198: 
1199: - **Live Documentation**: Always current library documentation
1200: - **Intelligent Search**: Semantic search within library docs
1201: - **Precise Results**: Get exactly the information you need
1202: - **Token Efficient**: No need to load entire documentation sets
1203: - **Version Aware**: Documentation matching your exact library versions
1204: 
1205: ## Setup Instructions
1206: 
1207: ### 1. Install Context7 MCP Server
1208: 
1209: ```bash
1210: # Install via npm (recommended)
1211: npm install -g @context7/mcp-server
1212: 
1213: # Or via pip if Python-based
1214: pip install context7-mcp
1215: ```
1216: 
1217: ### 2. Configure Claude Code
1218: 
1219: Add Context7 to your Claude Code MCP configuration:
1220: 
1221: ```json
1222: {
1223:   "mcpServers": {
1224:     "context7": {
1225:       "command": "npx",
1226:       "args": ["@context7/mcp-server"]
1227:     }
1228:   }
1229: }
1230: ```
1231: 
1232: ### 3. Test Integration
1233: 
1234: ```bash
1235: # Test Context7 availability
1236: /docs search "your-library documentation"
1237: 
1238: # Example searches
1239: /docs search "pytest fixtures"        # Python testing
1240: /docs search "express middleware"     # Node.js web framework
1241: /docs search "react hooks"           # React.js
1242: ```
1243: 
1244: ## Usage in Development
1245: 
1246: ### Quick Documentation Access
1247: 
1248: ```bash
1249: # Search for specific topics
1250: /docs search "library-name topic"
1251: 
1252: # Get setup instructions
1253: /docs search "framework-name getting started"
1254: 
1255: # Find API reference
1256: /docs search "library-name api reference"
1257: ```
1258: 
1259: ### Integration with Workflow
1260: 
1261: - **During /explore**: Research libraries and their capabilities
1262: - **During /plan**: Understand implementation requirements
1263: - **During /next**: Get specific API documentation for current task
1264: - **During /review**: Verify best practices and patterns
1265: 
1266: ## Fallback Strategy
1267: 
1268: When Context7 is unavailable:
1269: - Commands gracefully fall back to web search via Firecrawl
1270: - Local documentation cache is used when available
1271: - Manual documentation links are provided as backup
1272: 
1273: ## Library Coverage
1274: 
1275: Context7 supports documentation for:
1276: - **Python**: NumPy, Pandas, Django, Flask, FastAPI, pytest, and 1000+ libraries
1277: - **JavaScript**: React, Vue, Express, Jest, and popular npm packages
1278: - **Frameworks**: Next.js, Nuxt.js, Spring Boot, and more
1279: - **Tools**: Docker, Kubernetes, Git, and development tools
1280: 
1281: CONTEXT7_EOF
1282: 
1283:     echo "✅ Context7 documentation access configured"
1284:     echo "   📖 Setup guide: .claude/docs/CONTEXT7_SETUP.md"
1285:     echo "   🔍 Test with: /docs search \"your-library documentation\""
1286: 
1287:     # Add Context7 suggestions to CLAUDE.md
1288:     cat >> CLAUDE.md << 'CONTEXT7_APPEND'
1289: 
1290: ## Enhanced Documentation Features
1291: 
1292: This project includes Context7 integration for intelligent documentation access:
1293: 
1294: ### Quick Documentation Commands
1295: 
1296: ```bash
1297: # Search library documentation
1298: /docs search "pytest fixtures"      # Testing frameworks
1299: /docs search "express middleware"   # Web frameworks
1300: /docs search "react hooks"         # Frontend libraries
1301: ```
1302: 
1303: ### Development Integration
1304: 
1305: - **Research Phase**: Use `/docs search` to understand library capabilities
1306: - **Implementation**: Get API references with `/docs search "library api"`
1307: - **Troubleshooting**: Find solutions with `/docs search "library error-type"`
1308: 
1309: ### Setup Required
1310: 
1311: Follow `.claude/docs/CONTEXT7_SETUP.md` to enable Context7 MCP server.
1312: Without Context7, documentation commands fall back to web search.
1313: 
1314: CONTEXT7_APPEND
1315: 
1316: else
1317:     echo "ℹ️  Claude Code not detected - Context7 integration available when using Claude Code CLI"
1318:     echo "   📖 Documentation features will be available after Claude Code setup"
1319: fi
1320: 
1321: echo ""
1322: echo "🎉 Project Setup Complete!"
1323: echo ""
1324: echo "📁 Project Structure:"
1325: find . -type f -name "*.md" -o -name "*.py" -o -name "*.js" -o -name "*.json" -o -name "*.toml" | head -10
1326: echo ""
1327: echo "💡 Next Steps:"
1328: echo "   1. 🔧 Install dependencies (pip install -e .[dev] or npm install)"
1329: echo "   2. 🚀 Start development: /explore \"your first feature\""
1330: echo "   3. 📊 For code projects: /serena \$(pwd) to enable semantic understanding"
1331: echo "   4. ⚙️  Customize CLAUDE.md for project-specific requirements"
1332: echo ""
1333: echo "🔒 Security & Quality Features Enabled:"
1334: echo "   • Dangerous commands (rm -rf, sudo, chmod 777) automatically blocked"
1335: echo "   • Code automatically formatted & linted on edit:"
1336: echo "     - Python: ruff format + ruff check"
1337: echo "     - JavaScript: prettier + eslint"
1338: echo "     - Markdown: markdownlint"
1339: echo "   • JSON syntax validation on edit"
1340: echo "   • Test file creation hints (pytest integration)"
1341: echo ""
1342: echo "✨ Lean MCP Framework Active:"
1343: echo "   • Enhanced commands with 65% average token reduction"
1344: echo "   • /analyze - Semantic code understanding (when Serena available)"
1345: echo "   • /docs search - Live documentation access (when Context7 available)"
1346: echo "   • Complex reasoning with Sequential Thinking"
1347: echo "   • Graceful degradation ensures everything works regardless"
1348: echo ""
1349: echo "🚀 Ready for evidence-based, token-efficient development!"
1350: ```
````

## File: plugins/core/commands/spike.md
````markdown
  1: ---
  2: title: "spike"
  3: aliases: ["explore-spike", "prototype"]
  4: ---
  5: 
  6: # Spike - Time-boxed Technical Exploration
  7: 
  8: Creates an isolated environment for experimental code exploration with relaxed quality gates and automatic cleanup.
  9: 
 10: ## Usage
 11: 
 12: ```bash
 13: # Start a spike
 14: /spike start "exploration topic" [--duration MINUTES]
 15: 
 16: # Complete and generate report
 17: /spike complete
 18: 
 19: # Abandon spike (cleanup)
 20: /spike abandon
 21: ```
 22: 
 23: ## Purpose
 24: 
 25: Spikes are time-boxed technical investigations to:
 26: - Explore new technologies or approaches
 27: - Prototype solutions without commitment
 28: - Research implementation feasibility
 29: - Learn through experimentation
 30: - Gather information for decisions
 31: 
 32: ## Process
 33: 
 34: ### Starting a Spike
 35: 
 36: ```bash
 37: /spike start "websocket implementation"
 38: ```
 39: 
 40: Creates:
 41: 1. Isolated git branch (spike/topic-timestamp)
 42: 2. Spike tracking file
 43: 3. Relaxed quality gates
 44: 4. Time box (default: 2 hours)
 45: 
 46: ### During the Spike
 47: 
 48: - Experiment freely
 49: - Try multiple approaches
 50: - Break things safely
 51: - Focus on learning
 52: - Document findings
 53: 
 54: ### Completing a Spike
 55: 
 56: ```bash
 57: /spike complete
 58: ```
 59: 
 60: Generates:
 61: 1. Findings report
 62: 2. Code artifacts
 63: 3. Recommendations
 64: 4. Decision points
 65: 5. Optional: merge or discard
 66: 
 67: ## Implementation
 68: 
 69: ```bash
 70: #!/bin/bash
 71: 
 72: SPIKE_DIR=".claude/spikes"
 73: CURRENT_SPIKE="$SPIKE_DIR/current.json"
 74: COMMAND="${ARGUMENTS%% *}"
 75: ARGS="${ARGUMENTS#* }"
 76: 
 77: mkdir -p "$SPIKE_DIR"
 78: 
 79: case "$COMMAND" in
 80:     "start")
 81:         echo "🔬 Starting Technical Spike"
 82:         echo "════════════════════════════════════"
 83:         echo ""
 84: 
 85:         TOPIC="$ARGS"
 86:         DURATION=120  # Default 2 hours
 87: 
 88:         # Parse duration if provided
 89:         if [[ "$ARGS" == *"--duration"* ]]; then
 90:             DURATION=$(echo "$ARGS" | grep -oP '(?<=--duration )\d+')
 91:             TOPIC=$(echo "$ARGS" | sed 's/--duration.*//' | xargs)
 92:         fi
 93: 
 94:         # Check for existing spike
 95:         if [ -f "$CURRENT_SPIKE" ]; then
 96:             echo "⚠️  Active spike detected!"
 97:             echo ""
 98:             echo "Complete or abandon current spike first:"
 99:             echo "  /spike complete  - Generate report and finish"
100:             echo "  /spike abandon   - Discard and cleanup"
101:             exit 1
102:         fi
103: 
104:         # Create spike branch
105:         TIMESTAMP=$(date +%Y%m%d_%H%M%S)
106:         BRANCH_NAME="spike/$(echo "$TOPIC" | tr ' ' '-' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9-]//g')-$TIMESTAMP"
107: 
108:         echo "📁 Creating spike branch: $BRANCH_NAME"
109:         git checkout -b "$BRANCH_NAME" 2>/dev/null || {
110:             echo "❌ Failed to create branch. Commit or stash current changes first."
111:             exit 1
112:         }
113: 
114:         # Create spike tracking
115:         cat > "$CURRENT_SPIKE" <<EOF
116: {
117:   "topic": "$TOPIC",
118:   "branch": "$BRANCH_NAME",
119:   "started": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
120:   "duration_minutes": $DURATION,
121:   "status": "active",
122:   "findings": [],
123:   "artifacts": [],
124:   "recommendations": []
125: }
126: EOF
127: 
128:         echo ""
129:         echo "✅ Spike initialized!"
130:         echo ""
131:         echo "📋 Spike Details:"
132:         echo "  Topic: $TOPIC"
133:         echo "  Branch: $BRANCH_NAME"
134:         echo "  Time box: $DURATION minutes"
135:         echo ""
136:         echo "🎯 Spike Goals:"
137:         echo "  • Explore implementation options"
138:         echo "  • Identify technical challenges"
139:         echo "  • Prototype potential solutions"
140:         echo "  • Document learnings"
141:         echo ""
142: 
143:         cat <<'EOF'
144: Begin exploring: $TOPIC
145: 
146: **Spike Guidelines**:
147: 1. **Experiment Freely** - Try different approaches
148: 2. **Break Things** - It's isolated in a branch
149: 3. **Learn Fast** - Focus on understanding
150: 4. **Document Findings** - Note what works/doesn't
151: 5. **Time Box** - Stop at $DURATION minutes
152: 
153: **Focus Areas**:
154: - Technical feasibility
155: - Implementation complexity
156: - Performance implications
157: - Integration challenges
158: - Required dependencies
159: 
160: **What to Explore** for "$TOPIC":
161: - Available libraries and tools
162: - Best practices and patterns
163: - Potential pitfalls
164: - Architecture options
165: - Proof of concept code
166: 
167: Start by researching and then prototyping. Quality doesn't matter - learning does!
168: EOF
169: 
170:         echo ""
171:         echo "⏰ Time box: $DURATION minutes"
172:         echo "Complete with: /spike complete"
173:         ;;
174: 
175:     "complete")
176:         echo "📊 Completing Spike"
177:         echo "════════════════════════════════════"
178:         echo ""
179: 
180:         if [ ! -f "$CURRENT_SPIKE" ]; then
181:             echo "❌ No active spike found"
182:             echo "Start a spike with: /spike start \"topic\""
183:             exit 1
184:         fi
185: 
186:         # Read spike data
187:         TOPIC=$(grep -oP '"topic":\s*"\K[^"]+' "$CURRENT_SPIKE")
188:         BRANCH=$(grep -oP '"branch":\s*"\K[^"]+' "$CURRENT_SPIKE")
189:         STARTED=$(grep -oP '"started":\s*"\K[^"]+' "$CURRENT_SPIKE")
190: 
191:         echo "📝 Generating Spike Report"
192:         echo "────────────────────────"
193:         echo ""
194:         echo "Topic: $TOPIC"
195:         echo "Branch: $BRANCH"
196:         echo "Started: $STARTED"
197:         echo ""
198: 
199:         # Generate report
200:         REPORT_FILE="$SPIKE_DIR/report_$(date +%Y%m%d_%H%M%S).md"
201: 
202:         cat <<'EOF'
203: Complete the spike and generate a comprehensive report.
204: 
205: **Spike Topic**: $TOPIC
206: 
207: Please create a spike report with:
208: 
209: 1. **Executive Summary**
210:    - What was explored
211:    - Key findings
212:    - Recommendation (proceed/pivot/abandon)
213: 
214: 2. **Technical Findings**
215:    - What worked well
216:    - What didn't work
217:    - Unexpected discoveries
218:    - Performance observations
219: 
220: 3. **Implementation Details**
221:    - Code samples that worked
222:    - Libraries/tools evaluated
223:    - Architecture decisions
224:    - Integration points
225: 
226: 4. **Challenges & Risks**
227:    - Technical blockers found
228:    - Complexity assessment
229:    - Security considerations
230:    - Scalability concerns
231: 
232: 5. **Recommendations**
233:    - Suggested approach
234:    - Estimated effort
235:    - Next steps
236:    - Alternative options
237: 
238: 6. **Artifacts**
239:    - List useful code created
240:    - Documentation snippets
241:    - Configuration examples
242:    - Test cases
243: 
244: Generate the report and save to: $REPORT_FILE
245: 
246: After generating the report, show a summary and ask whether to:
247: - Keep the spike branch for reference
248: - Merge useful code to main
249: - Archive and delete branch
250: EOF
251: 
252:         # Show git status
253:         echo ""
254:         echo "📂 Changes made during spike:"
255:         echo "────────────────────────"
256:         git status --short
257:         echo ""
258:         git diff --stat
259:         echo ""
260: 
261:         # Update spike status
262:         if command -v jq >/dev/null 2>&1; then
263:             jq '.status = "completed" | .completed = "'$(date -u +"%Y-%m-%dT%H:%M:%SZ")'"' "$CURRENT_SPIKE" > "$CURRENT_SPIKE.tmp" && mv "$CURRENT_SPIKE.tmp" "$CURRENT_SPIKE"
264:         fi
265: 
266:         echo "💡 Options:"
267:         echo "  1. Keep branch: git checkout main"
268:         echo "  2. Merge useful code: git checkout main && git merge $BRANCH"
269:         echo "  3. Archive: git checkout main && git branch -D $BRANCH"
270:         echo ""
271:         echo "Report saved to: $REPORT_FILE"
272: 
273:         # Archive current spike
274:         mv "$CURRENT_SPIKE" "$SPIKE_DIR/completed_$(date +%Y%m%d_%H%M%S).json"
275:         ;;
276: 
277:     "abandon")
278:         echo "🗑️  Abandoning Spike"
279:         echo "════════════════════════════════════"
280:         echo ""
281: 
282:         if [ ! -f "$CURRENT_SPIKE" ]; then
283:             echo "❌ No active spike found"
284:             exit 0
285:         fi
286: 
287:         BRANCH=$(grep -oP '"branch":\s*"\K[^"]+' "$CURRENT_SPIKE")
288: 
289:         echo "⚠️  This will discard all spike work!"
290:         echo ""
291:         echo "Branch to delete: $BRANCH"
292:         echo ""
293: 
294:         # Switch to main/master
295:         DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
296:         git checkout "$DEFAULT_BRANCH" 2>/dev/null || git checkout main 2>/dev/null || git checkout master
297: 
298:         # Delete spike branch
299:         git branch -D "$BRANCH" 2>/dev/null && echo "✅ Spike branch deleted"
300: 
301:         # Remove tracking
302:         rm -f "$CURRENT_SPIKE"
303: 
304:         echo ""
305:         echo "✅ Spike abandoned and cleaned up"
306:         ;;
307: 
308:     "status"|*)
309:         echo "📊 Spike Status"
310:         echo "════════════════════════════════════"
311:         echo ""
312: 
313:         if [ ! -f "$CURRENT_SPIKE" ]; then
314:             echo "No active spike"
315:             echo ""
316:             echo "Start a spike with:"
317:             echo "  /spike start \"topic to explore\""
318:         else
319:             echo "Active Spike:"
320:             echo "────────────"
321:             cat "$CURRENT_SPIKE" | jq . 2>/dev/null || cat "$CURRENT_SPIKE"
322:             echo ""
323:             echo "Commands:"
324:             echo "  /spike complete - Finish and generate report"
325:             echo "  /spike abandon  - Discard all work"
326:         fi
327: 
328:         echo ""
329:         echo "📁 Previous Spikes:"
330:         echo "────────────────"
331:         find "$SPIKE_DIR" -name "report_*.md" -type f 2>/dev/null | while read -r report; do
332:             basename "$report"
333:         done | head -5
334:         ;;
335: esac
336: ```
337: 
338: ## Features
339: 
340: ### Isolation
341: - Separate git branch
342: - No impact on main code
343: - Easy rollback
344: - Safe experimentation
345: 
346: ### Time Boxing
347: - Default 2-hour limit
348: - Configurable duration
349: - Prevents rabbit holes
350: - Forces decision making
351: 
352: ### Relaxed Rules
353: - No quality gates during spike
354: - Commit anything
355: - Break conventions
356: - Focus on learning
357: 
358: ### Documentation
359: - Automatic report generation
360: - Findings capture
361: - Code artifact preservation
362: - Decision documentation
363: 
364: ## Spike Types
365: 
366: ### Technology Spike
367: ```bash
368: /spike start "evaluate GraphQL vs REST"
369: ```
370: Explore new technologies or libraries
371: 
372: ### Architecture Spike
373: ```bash
374: /spike start "microservice communication patterns"
375: ```
376: Test architectural approaches
377: 
378: ### Performance Spike
379: ```bash
380: /spike start "optimize database queries"
381: ```
382: Investigate performance improvements
383: 
384: ### Integration Spike
385: ```bash
386: /spike start "third-party payment integration"
387: ```
388: Test external service integration
389: 
390: ## Best Practices
391: 
392: ### DO:
393: - Time box strictly
394: - Document findings immediately
395: - Try multiple approaches
396: - Break things to learn
397: - Focus on specific questions
398: 
399: ### DON'T:
400: - Polish code during spike
401: - Write comprehensive tests
402: - Worry about code quality
403: - Exceed time box
404: - Spike without clear goals
405: 
406: ## Report Structure
407: 
408: Generated reports include:
409: 
410: ```markdown
411: # Spike Report: [Topic]
412: 
413: ## Executive Summary
414: - Duration: X hours
415: - Status: Completed/Abandoned
416: - Recommendation: Proceed/Pivot/Abandon
417: 
418: ## Findings
419: ### What Worked
420: - Approach A showed promise
421: - Library X meets requirements
422: 
423: ### What Didn't Work
424: - Approach B too complex
425: - Performance issues with Y
426: 
427: ## Code Artifacts
428: - `prototype/api.py` - Working API example
429: - `config/websocket.json` - Configuration template
430: 
431: ## Recommendations
432: Based on this spike, we recommend...
433: 
434: ## Next Steps
435: 1. Create formal design document
436: 2. Estimate implementation effort
437: 3. Plan development tasks
438: ```
439: 
440: ## Configuration
441: 
442: Customize in `.claude/settings.json`:
443: 
444: ```json
445: {
446:   "spike": {
447:     "default_duration": 120,
448:     "max_duration": 480,
449:     "require_report": true,
450:     "auto_archive": true,
451:     "branch_prefix": "spike/"
452:   }
453: }
454: ```
455: 
456: ## See Also
457: 
458: - `/explore` - Formal exploration with planning
459: - `/quickfix` - Fast fixes without exploration
460: - `/experiment` - ML experimentation
461: - `/analyze` - Codebase analysis
462: 
463: ---
464: 
465: *Time-boxed technical exploration in isolated environment. Part of Claude Code Framework v3.1.*
````

## File: plugins/core/commands/status.md
````markdown
  1: ---
  2: name: status
  3: description: Unified view of work, system, and memory state
  4: allowed-tools: [Read, Bash, Glob]
  5: argument-hint: "[verbose]"
  6: ---
  7: 
  8: # Status Command
  9: 
 10: I'll show you a comprehensive view of your current work state, system status, and memory usage.
 11: 
 12: **Input**: $ARGUMENTS
 13: 
 14: ## Implementation
 15: 
 16: ```bash
 17: #!/bin/bash
 18: 
 19: # Standard constants (must be copied to each command)
 20: readonly CLAUDE_DIR=".claude"
 21: readonly WORK_DIR="${CLAUDE_DIR}/work"
 22: readonly WORK_CURRENT="${WORK_DIR}/current"
 23: readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
 24: readonly TRANSITIONS_DIR="${CLAUDE_DIR}/transitions"
 25: 
 26: # Error handling functions (must be copied to each command)
 27: error_exit() {
 28:     echo "ERROR: $1" >&2
 29:     exit 1
 30: }
 31: 
 32: warn() {
 33:     echo "WARNING: $1" >&2
 34: }
 35: 
 36: debug() {
 37:     [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
 38: }
 39: 
 40: # Parse arguments
 41: VERBOSE=false
 42: if [[ "$ARGUMENTS" =~ verbose ]]; then
 43:     VERBOSE=true
 44: fi
 45: 
 46: echo "📦 Claude Code Status Report"
 47: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 48: echo ""
 49: 
 50: # Work Status
 51: echo "📋 WORK STATUS"
 52: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 53: 
 54: if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
 55:     ACTIVE_WORK=$(cat "${WORK_DIR}/ACTIVE_WORK" 2>/dev/null || echo "")
 56:     if [ -n "$ACTIVE_WORK" ] && [ -d "${WORK_CURRENT}/${ACTIVE_WORK}" ]; then
 57:         echo "🟢 Active: $ACTIVE_WORK"
 58: 
 59:         # Try to read state.json if it exists
 60:         if [ -f "${WORK_CURRENT}/${ACTIVE_WORK}/state.json" ] && command -v jq >/dev/null 2>&1; then
 61:             STATUS=$(jq -r '.status // "unknown"' "${WORK_CURRENT}/${ACTIVE_WORK}/state.json" 2>/dev/null || echo "unknown")
 62:             CURRENT_TASK=$(jq -r '.current_task // "none"' "${WORK_CURRENT}/${ACTIVE_WORK}/state.json" 2>/dev/null || echo "none")
 63:             echo "   Phase: $STATUS"
 64:             echo "   Task: $CURRENT_TASK"
 65:         fi
 66:     else
 67:         echo "⚠️  Active work unit not found: $ACTIVE_WORK"
 68:     fi
 69: else
 70:     echo "🔴 No active work unit"
 71: fi
 72: 
 73: # Count work units
 74: if [ -d "$WORK_CURRENT" ]; then
 75:     TOTAL_WORK=$(find "$WORK_CURRENT" -maxdepth 1 -type d -not -path "$WORK_CURRENT" | wc -l)
 76:     echo "   Total units: $TOTAL_WORK"
 77: fi
 78: 
 79: echo ""
 80: 
 81: # Git Status
 82: if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
 83:     echo "🔀 GIT STATUS"
 84:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 85: 
 86:     # Get branch and status
 87:     BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
 88:     echo "🌳 Branch: $BRANCH"
 89: 
 90:     # Count changes
 91:     MODIFIED=$(git status --porcelain 2>/dev/null | grep '^ M' | wc -l)
 92:     STAGED=$(git status --porcelain 2>/dev/null | grep '^[AM]' | wc -l)
 93:     UNTRACKED=$(git status --porcelain 2>/dev/null | grep '^??' | wc -l)
 94: 
 95:     if [ $MODIFIED -gt 0 ] || [ $STAGED -gt 0 ] || [ $UNTRACKED -gt 0 ]; then
 96:         echo "📝 Changes: $MODIFIED modified, $STAGED staged, $UNTRACKED untracked"
 97:     else
 98:         echo "✅ Working directory clean"
 99:     fi
100: 
101:     # Last commit
102:     if [ "$VERBOSE" = true ]; then
103:         LAST_COMMIT=$(git log -1 --pretty=format:"%h - %s (%ar)" 2>/dev/null || echo "No commits")
104:         echo "📥 Last: $LAST_COMMIT"
105:     fi
106: 
107:     echo ""
108: fi
109: 
110: # System Status
111: echo "⚙️  SYSTEM STATUS"
112: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
113: 
114: # Check framework directories
115: FRAMEWORK_OK=true
116: for dir in "$CLAUDE_DIR" "$WORK_DIR" "$MEMORY_DIR"; do
117:     if [ ! -d "$dir" ]; then
118:         echo "❌ Missing: $dir"
119:         FRAMEWORK_OK=false
120:     fi
121: done
122: 
123: if [ "$FRAMEWORK_OK" = true ]; then
124:     echo "🏗️  Framework: Claude Code v3.0 ✅"
125: else
126:     echo "🏗️  Framework: Incomplete setup ⚠️"
127: fi
128: 
129: # Memory status
130: if [ -d "$MEMORY_DIR" ]; then
131:     MEMORY_FILES=$(find "$MEMORY_DIR" -type f -name "*.md" 2>/dev/null | wc -l)
132:     MEMORY_SIZE=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)
133:     echo "💾 Memory: $MEMORY_FILES files, $MEMORY_SIZE"
134: fi
135: 
136: echo ""
137: 
138: # Memory Status
139: if [ "$VERBOSE" = true ]; then
140:     echo "🧠 MEMORY STATUS"
141:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
142: 
143:     # Check recent memory updates
144:     if [ -d "$MEMORY_DIR" ]; then
145:         RECENT=$(find "$MEMORY_DIR" -type f -name "*.md" -mmin -60 2>/dev/null | wc -l)
146:         if [ $RECENT -gt 0 ]; then
147:             echo "🔄 Recent updates: $RECENT files in last hour"
148:         fi
149:     fi
150: 
151:     # Check transitions
152:     if [ -d "$TRANSITIONS_DIR" ]; then
153:         TRANSITIONS=$(find "$TRANSITIONS_DIR" -maxdepth 1 -type d -not -path "$TRANSITIONS_DIR" 2>/dev/null | wc -l)
154:         if [ $TRANSITIONS -gt 0 ]; then
155:             echo "🔗 Transitions: $TRANSITIONS saved"
156:         fi
157:     fi
158: 
159:     echo ""
160: fi
161: 
162: # Recommendations
163: echo "🎯 NEXT STEPS"
164: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
165: 
166: if [ -n "$ACTIVE_WORK" ] && [ -d "${WORK_CURRENT}/${ACTIVE_WORK}" ]; then
167:     echo "➡️ Continue with: /next"
168:     echo "➡️ View work details: /work"
169: else
170:     echo "➡️ Start new work: /explore [requirement]"
171:     echo "➡️ View available work: /work"
172: fi
173: 
174: if [ $MODIFIED -gt 0 ] || [ $STAGED -gt 0 ]; then
175:     echo "➡️ Commit changes: /git commit"
176: fi
177: 
178: echo ""
179: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
180: ```
181: 
182: ## Usage
183: 
184: ```bash
185: /status                    # Quick status overview
186: /status verbose            # Detailed status with extended information
187: ```
188: 
189: ## Phase 1: Current Work Status
190: 
191: ### Active Work Unit Analysis
192: I'll check for and analyze your current work context:
193: 
194: 1. **Active Work Unit**: Look for `.claude/work/current/ACTIVE_WORK` and work unit directories
195: 2. **Work Progress**: Analyze `state.json` and `metadata.json` for current progress
196: 3. **Current Tasks**: Identify what tasks are in progress, completed, or blocked
197: 4. **Phase Status**: Determine current workflow phase (exploring, planning, implementing, testing)
198: 
199: ### Work Status Display
200: ```
201: 📋 WORK STATUS
202: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
203: 📁 Project: [Project Name]
204: 🔄 Phase: [Current Phase]
205: 📊 Progress: [X/Y tasks complete (Z%)]
206: ⏱️  Current Task: [Task ID - Title]
207: ```
208: 
209: ### Task Overview
210: - **Completed Tasks**: List recently completed tasks with timestamps
211: - **In Progress**: Show currently active task with estimated completion
212: - **Next Available**: Identify tasks ready to be executed
213: - **Blocked Tasks**: Highlight tasks waiting on dependencies
214: 
215: ## Phase 2: Git Repository Status
216: 
217: ### Repository State Analysis
218: 1. **Branch Information**: Current branch, ahead/behind status with remote
219: 2. **Working Directory**: Modified, staged, and untracked files
220: 3. **Recent Commits**: Last few commits with summary information
221: 4. **Repository Health**: Check for any git issues or inconsistencies
222: 
223: ### Git Status Display
224: ```
225: 🔀 GIT STATUS
226: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
227: 🌳 Branch: [branch-name] (up to date / ahead X / behind Y)
228: 📝 Changes: [X modified, Y staged, Z untracked]
229: 📅 Last Commit: [hash] - [message] ([time ago])
230: ```
231: 
232: ### Change Summary
233: - **Modified Files**: Files with uncommitted changes
234: - **Staged Changes**: Files ready for commit
235: - **Untracked Files**: New files not yet added to git
236: - **Conflicts**: Any merge conflicts that need resolution
237: 
238: ## Phase 3: System and Framework Status
239: 
240: ### Framework Health Check
241: 1. **Directory Structure**: Verify `.claude/` framework structure is intact
242: 2. **Memory Status**: Check memory file sizes and recent updates
243: 3. **Configuration**: Validate settings and hook configurations
244: 4. **Command Availability**: Ensure all framework commands are accessible
245: 
246: ### System Status Display
247: ```
248: ⚙️ SYSTEM STATUS
249: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
250: 🏗️  Framework: [Claude Code v3.0] ✅
251: 📁 Structure: [.claude/ directories] ✅
252: 💾 Memory: [X files, Y MB total]
253: 🔧 Configuration: [settings.json] ✅
254: ```
255: 
256: ### Health Indicators
257: - **Framework Version**: Current Claude Code framework version
258: - **Directory Health**: Status of required framework directories
259: - **Memory Usage**: Current memory file count and total size
260: - **Configuration Status**: Settings and hook configuration validation
261: 
262: ## Phase 4: Session and Memory Status
263: 
264: ### Session Context Analysis
265: 1. **Session Duration**: How long current session has been active
266: 2. **Memory Files**: Current memory file status and recent updates
267: 3. **Import Health**: Validate all `@import` links in CLAUDE.md files
268: 4. **Context Window**: Estimate current context usage and available space
269: 
270: ### Memory Status Display
271: ```
272: 🧠 MEMORY STATUS
273: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
274: 📝 Session: [X minutes active]
275: 💾 Memory Files: [X files, recent update: Y minutes ago]
276: 🔗 Imports: [X valid, Y broken links]
277: 📊 Context: [~X% utilized]
278: ```
279: 
280: ### Memory Health
281: - **Recent Updates**: Files modified in current session
282: - **Import Validation**: Status of all `@` import links
283: - **Size Management**: Memory files approaching size limits
284: - **Archive Needs**: Old session data that should be compressed
285: 
286: ## Phase 5: Verbose Information (Optional)
287: 
288: When verbose flag is specified, include additional details:
289: 
290: ### Extended Work Information
291: - **Full Task List**: Complete task breakdown with dependencies
292: - **Timing Information**: Task duration estimates and actual times
293: - **File Changes**: Detailed file modification history
294: - **Quality Metrics**: Test coverage, code quality scores
295: 
296: ### Extended Git Information
297: - **Commit History**: Extended commit log with detailed messages
298: - **Branch Analysis**: All branches and their status
299: - **Remote Status**: Detailed remote repository synchronization
300: - **Stash Information**: Any stashed changes
301: 
302: ### Extended System Information
303: - **Tool Availability**: Status of development tools (git, python, node, etc.)
304: - **MCP Server Status**: Connected MCP servers and their health
305: - **Hook Configuration**: Detailed hook setup and execution status
306: - **Performance Metrics**: Command execution times and system performance
307: 
308: ## Phase 6: Recommendations
309: 
310: ### Next Action Recommendations
311: Based on current status, provide actionable next steps:
312: 
313: #### Work in Progress
314: ```
315: 🎯 NEXT STEPS
316: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
317: → Continue current task: [Task ID]
318: → Estimated completion: [X hours]
319: → Run `/next` to proceed
320: ```
321: 
322: #### Ready for New Work
323: ```
324: 🎯 NEXT STEPS
325: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
326: → No active work detected
327: → Run `/explore [requirement]` to start new work
328: → Or run `/work` to see available work units
329: ```
330: 
331: #### Issues Detected
332: ```
333: ⚠️ ATTENTION NEEDED
334: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
335: → [Issue description]
336: → Recommended action: [specific command or fix]
337: ```
338: 
339: ## Success Indicators
340: 
341: - ✅ Current work status clearly displayed
342: - ✅ Git repository state summarized
343: - ✅ Framework health verified
344: - ✅ Memory and session status shown
345: - ✅ Clear next action recommendations provided
346: - ✅ All status information current and accurate
347: 
348: ## Integration with Other Commands
349: 
350: - **Work Management**: Status integrates with `/work` for detailed work unit management
351: - **Planning**: Shows when `/plan` is needed for incomplete planning
352: - **Execution**: Indicates when `/next` can be used to continue tasks
353: - **Quality**: Highlights when `/audit` or `/review` might be beneficial
354: 
355: ## Examples
356: 
357: ### Quick Status Check
358: ```bash
359: /status
360: # → Shows concise overview of current work, git, and system status
361: ```
362: 
363: ### Detailed Status Review
364: ```bash
365: /status verbose
366: # → Comprehensive status with extended information and diagnostics
367: ```
368: 
369: ### Status During Development
370: ```bash
371: /status
372: # → Shows current task progress, git changes, and next recommended actions
373: ```
374: 
375: ---
376: 
377: *Provides comprehensive current state overview enabling informed development decisions and workflow management.*
````

## File: plugins/core/commands/work.md
````markdown
  1: ---
  2: allowed-tools: [Read, Write, MultiEdit, Bash, Grep]
  3: argument-hint: "[subcommand: continue|checkpoint|switch] [args] OR [filter: active|paused|completed|all]"
  4: description: "Unified work management: list units, continue work, save checkpoints, and switch contexts"
  5: ---
  6: 
  7: # Unified Work Management
  8: 
  9: Comprehensive work unit management with subcommands for continuing work, saving checkpoints, switching contexts, and viewing status.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Implementation
 14: 
 15: ```bash
 16: #!/bin/bash
 17: 
 18: # Standard constants (must be copied to each command)
 19: readonly CLAUDE_DIR=".claude"
 20: readonly WORK_DIR="${CLAUDE_DIR}/work"
 21: readonly WORK_CURRENT="${WORK_DIR}/current"
 22: readonly WORK_COMPLETED="${WORK_DIR}/completed"
 23: 
 24: # Error handling functions (must be copied to each command)
 25: error_exit() {
 26:     echo "ERROR: $1" >&2
 27:     exit 1
 28: }
 29: 
 30: warn() {
 31:     echo "WARNING: $1" >&2
 32: }
 33: 
 34: debug() {
 35:     [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
 36: }
 37: 
 38: # Safe directory creation
 39: safe_mkdir() {
 40:     local dir="$1"
 41:     mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
 42: }
 43: 
 44: # Parse arguments
 45: ARGUMENTS="$ARGUMENTS"
 46: SUBCOMMAND=""
 47: FILTER="all"
 48: WORK_ID=""
 49: MESSAGE=""
 50: 
 51: # Extract subcommand or filter
 52: if [[ "$ARGUMENTS" =~ ^(continue|checkpoint|switch) ]]; then
 53:     SUBCOMMAND="${BASH_REMATCH[1]}"
 54:     REMAINING="${ARGUMENTS#$SUBCOMMAND}"
 55:     REMAINING="${REMAINING# }"  # Trim leading space
 56: 
 57:     case "$SUBCOMMAND" in
 58:         continue|switch)
 59:             WORK_ID="$REMAINING"
 60:             ;;
 61:         checkpoint)
 62:             MESSAGE="$REMAINING"
 63:             ;;
 64:     esac
 65: elif [[ "$ARGUMENTS" =~ ^(active|paused|completed|all) ]]; then
 66:     FILTER="$ARGUMENTS"
 67: fi
 68: 
 69: # Ensure work directory exists
 70: safe_mkdir "$WORK_CURRENT"
 71: safe_mkdir "$WORK_COMPLETED"
 72: 
 73: # Main execution
 74: if [ -z "$SUBCOMMAND" ]; then
 75:     # List work units based on filter
 76:     echo "📋 WORK UNITS"
 77:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 78:     echo ""
 79: 
 80:     # TODO: Implement work unit listing with proper filtering
 81:     # This is a simplified version - actual implementation would read metadata.json files
 82: 
 83:     for work_dir in "$WORK_CURRENT"/*; do
 84:         [ -d "$work_dir" ] || continue
 85:         work_id=$(basename "$work_dir")
 86: 
 87:         if [ -f "$work_dir/metadata.json" ]; then
 88:             # Extract metadata (simplified - would use jq in practice)
 89:             echo "🟢 $work_id    [active]    Progress info here"
 90:         fi
 91:     done
 92: 
 93: else
 94:     case "$SUBCOMMAND" in
 95:         continue)
 96:             # Continue work unit
 97:             if [ -z "$WORK_ID" ]; then
 98:                 # Find last active work unit
 99:                 if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
100:                     WORK_ID=$(cat "${WORK_DIR}/ACTIVE_WORK")
101:                 else
102:                     error_exit "No active work unit found"
103:                 fi
104:             fi
105: 
106:             # Validate work unit exists
107:             if [ ! -d "${WORK_CURRENT}/${WORK_ID}" ]; then
108:                 error_exit "Work unit ${WORK_ID} not found"
109:             fi
110: 
111:             # Set as active
112:             echo "$WORK_ID" > "${WORK_DIR}/ACTIVE_WORK" || error_exit "Failed to set active work unit"
113:             echo "✅ Resumed work unit: ${WORK_ID}"
114:             ;;
115: 
116:         checkpoint)
117:             # Save checkpoint
118:             if [ ! -f "${WORK_DIR}/ACTIVE_WORK" ]; then
119:                 error_exit "No active work unit to checkpoint"
120:             fi
121: 
122:             ACTIVE_ID=$(cat "${WORK_DIR}/ACTIVE_WORK")
123:             CHECKPOINT_DIR="${WORK_CURRENT}/${ACTIVE_ID}/checkpoints"
124:             safe_mkdir "$CHECKPOINT_DIR"
125: 
126:             TIMESTAMP=$(date +%Y%m%d_%H%M%S)
127:             CHECKPOINT_FILE="${CHECKPOINT_DIR}/checkpoint_${TIMESTAMP}.json"
128: 
129:             # Create checkpoint (simplified)
130:             cat > "$CHECKPOINT_FILE" << EOF || error_exit "Failed to create checkpoint"
131: {
132:     "timestamp": "$(date -Iseconds)",
133:     "message": "${MESSAGE:-Checkpoint created}",
134:     "work_id": "$ACTIVE_ID"
135: }
136: EOF
137: 
138:             echo "✅ Checkpoint saved for ${ACTIVE_ID}"
139:             ;;
140: 
141:         switch)
142:             # Switch work units
143:             if [ -z "$WORK_ID" ]; then
144:                 error_exit "Work unit ID required for switch"
145:             fi
146: 
147:             if [ ! -d "${WORK_CURRENT}/${WORK_ID}" ]; then
148:                 error_exit "Work unit ${WORK_ID} not found"
149:             fi
150: 
151:             # Checkpoint current if exists
152:             if [ -f "${WORK_DIR}/ACTIVE_WORK" ]; then
153:                 OLD_ID=$(cat "${WORK_DIR}/ACTIVE_WORK")
154:                 echo "📝 Checkpointing ${OLD_ID} before switch..."
155:                 # Would call checkpoint logic here
156:             fi
157: 
158:             # Switch to new work unit
159:             echo "$WORK_ID" > "${WORK_DIR}/ACTIVE_WORK" || error_exit "Failed to switch work unit"
160:             echo "✅ Switched to work unit: ${WORK_ID}"
161:             ;;
162:     esac
163: fi
164: ```
165: 
166: ## Usage Examples
167: 
168: ```bash
169: /work                    # List all work units (default)
170: /work active             # List only active work units
171: /work continue          # Resume last active work unit
172: /work continue 002      # Resume specific work unit
173: /work checkpoint        # Save current progress
174: /work checkpoint "Major milestone reached"  # Save with custom message
175: /work switch 003        # Switch to work unit 003
176: ```
177: 
178: ## Detailed Operation Phases
179: 
180: ### Phase 1: Determine Work Operation
181: 
182: Based on the arguments provided: $ARGUMENTS
183: 
184: I'll determine which work management operation to perform:
185: 
186: - **List Operations**: No subcommand or filter keyword - show work unit list
187: - **Continue Operations**: Arguments start with "continue" - resume work
188: - **Checkpoint Operations**: Arguments start with "checkpoint" - save progress
189: - **Switch Operations**: Arguments start with "switch" - change active work unit
190: 
191: ## Phase 2: Execute Work Unit Listing
192: 
193: When listing work units:
194: 
195: ### Work Unit Discovery
196: 1. **Scan Work Directory**: Examine `.claude/work/current/` for active work units
197: 2. **Parse Metadata**: Read metadata.json files to understand work unit status
198: 3. **Identify Active Unit**: Check `ACTIVE_WORK` file for currently active work
199: 4. **Status Analysis**: Determine work unit phases and progress
200: 
201: ### Filtering Options
202: - **All Units** (default): Show all work units regardless of status
203: - **Active Units**: Only show units in active development
204: - **Paused Units**: Show units that are paused but not completed
205: - **Completed Units**: Display archived and completed work units
206: 
207: ### Work Unit Display Format
208: ```
209: 📋 WORK UNITS
210: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
211: 
212: 🟢 001_auth_system        [implementing]     3/5 tasks  (60%)
213:    ↳ Last: 2 hours ago - TASK-003 in progress
214: 
215: ⏸️  002_payment_flow      [paused]          1/4 tasks  (25%)
216:    ↳ Last: 1 day ago - waiting for API specs
217: 
218: ✅ 003_user_dashboard     [completed]       4/4 tasks  (100%)
219:    ↳ Completed: 3 days ago - shipped to production
220: 
221: 📝 004_notification_sys   [planning]        0/6 tasks  (0%)
222:    ↳ Last: 30 minutes ago - plan in progress
223: ```
224: 
225: ## Phase 3: Execute Continue Operations
226: 
227: When continuing work:
228: 
229: ### Resume Active Work Unit
230: 1. **Identify Target**: Determine which work unit to resume (last active or specified)
231: 2. **Load Context**: Read work unit metadata, state, and progress
232: 3. **Validate State**: Ensure work unit is in resumable state
233: 4. **Set Active**: Mark work unit as active and update session context
234: 5. **Display Status**: Show current task and next actions
235: 
236: ### Context Restoration
237: 1. **Work Unit Activation**: Set as active work unit in `ACTIVE_WORK`
238: 2. **Session Memory**: Load work unit context into session memory
239: 3. **Task Context**: Identify current task and next available tasks
240: 4. **Environment Setup**: Prepare development environment for continued work
241: 
242: ### Continue Options
243: - **Continue Latest**: Resume most recently active work unit
244: - **Continue Specific**: Resume explicitly specified work unit by ID
245: - **Continue with Validation**: Verify work unit state before resuming
246: 
247: ## Phase 4: Execute Checkpoint Operations
248: 
249: When creating checkpoints:
250: 
251: ### Progress Capture
252: 1. **Current State**: Capture current task progress and completion status
253: 2. **Work Summary**: Document work completed since last checkpoint
254: 3. **Context Preservation**: Save current development context and environment
255: 4. **Timestamp Recording**: Record checkpoint creation time and duration
256: 
257: ### Checkpoint Documentation
258: 1. **Progress Summary**: What has been accomplished since last checkpoint
259: 2. **Current Status**: What task is in progress and next steps
260: 3. **Issues Encountered**: Any blockers or challenges discovered
261: 4. **Next Session Prep**: What needs to be done to resume work
262: 
263: ### Checkpoint Types
264: - **Automatic Checkpoints**: Created at natural stopping points
265: - **Manual Checkpoints**: Created with custom messages and context
266: - **Session Checkpoints**: Created when switching between work units
267: - **Milestone Checkpoints**: Created at major completion points
268: 
269: ## Phase 5: Execute Switch Operations
270: 
271: When switching work units:
272: 
273: ### Pre-Switch Validation
274: 1. **Current Work Status**: Check if current work should be checkpointed
275: 2. **Target Validation**: Verify target work unit exists and is accessible
276: 3. **Conflict Detection**: Identify any conflicts between work units
277: 4. **Safety Checks**: Ensure switching won't lose important work
278: 
279: ### Context Switching
280: 1. **Save Current Context**: Checkpoint current work unit if needed
281: 2. **Load Target Context**: Load target work unit metadata and state
282: 3. **Update Active Work**: Set new work unit as active
283: 4. **Environment Update**: Adjust development environment for new context
284: 
285: ### Switch Safety
286: - **Automatic Checkpointing**: Save current progress before switching
287: - **Work Validation**: Ensure target work unit is in valid state
288: - **Conflict Resolution**: Handle conflicts between work units
289: - **Rollback Capability**: Ability to return to previous work unit
290: 
291: ## Phase 6: Work Unit Health Monitoring
292: 
293: ### Health Checks
294: 1. **Metadata Integrity**: Validate all work unit metadata files
295: 2. **State Consistency**: Ensure task states are logically consistent
296: 3. **File Organization**: Verify work unit directory structure
297: 4. **Progress Tracking**: Validate progress calculations and dependencies
298: 
299: ### Maintenance Operations
300: 1. **Cleanup Stale Units**: Identify and clean up abandoned work units
301: 2. **Archive Completed**: Move completed work units to archive
302: 3. **Repair Corruption**: Fix any corrupted metadata or state files
303: 4. **Optimize Storage**: Compress and optimize work unit storage
304: 
305: ## Success Indicators
306: 
307: ### Listing Operations
308: - ✅ All work units discovered and categorized
309: - ✅ Current status accurately displayed
310: - ✅ Progress information up to date
311: - ✅ Clear visual organization
312: 
313: ### Continue Operations
314: - ✅ Work unit successfully resumed
315: - ✅ Context properly restored
316: - ✅ Current task clearly identified
317: - ✅ Ready for `/next` execution
318: 
319: ### Checkpoint Operations
320: - ✅ Progress safely captured
321: - ✅ Context preserved for resumption
322: - ✅ Documentation complete
323: - ✅ Checkpoint successfully created
324: 
325: ### Switch Operations
326: - ✅ Previous work safely saved
327: - ✅ New work unit activated
328: - ✅ Context successfully switched
329: - ✅ Environment properly configured
330: 
331: ## Integration with Workflow
332: 
333: - **Explore Integration**: New work units created by `/explore` appear in listings
334: - **Planning Integration**: Work units show planning progress and completion
335: - **Execution Integration**: Task progress updates reflected in work unit status
336: - **Shipping Integration**: Completed work units marked and archived
337: 
338: ## Examples
339: 
340: ### List Active Work
341: ```bash
342: /work active
343: # → Shows only work units currently in development
344: ```
345: 
346: ### Resume Last Work
347: ```bash
348: /work continue
349: # → Resumes most recently active work unit
350: ```
351: 
352: ### Save Progress Checkpoint
353: ```bash
354: /work checkpoint "Completed authentication module"
355: # → Saves current progress with descriptive message
356: ```
357: 
358: ### Switch Between Projects
359: ```bash
360: /work switch 003
361: # → Switches to work unit 003, checkpointing current work
362: ```
363: 
364: ---
365: 
366: *Unified work management enabling parallel development streams with safe context switching and progress preservation.*
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

## File: plugins/development/agents/architect.md
````markdown
  1: ---
  2: name: architect
  3: description: System design and architectural decisions specialist with structured reasoning
  4: tools: Read, Write, MultiEdit, Grep, WebSearch, WebFetch, mcp__sequential-thinking__sequentialthinking
  5: ---
  6: 
  7: # System Architect Agent
  8: 
  9: You are a senior system architect with deep expertise in software design, scalability, and technology selection. Your role is to make thoughtful architectural decisions that balance current needs with future growth.
 10: 
 11: ## Core Responsibilities
 12: 
 13: 1. **API Verification**: Verify all APIs exist before designing systems that use them
 14: 2. **System Design**: Create robust, scalable architectures
 15: 3. **Technology Selection**: Choose appropriate tools and frameworks
 16: 4. **Pattern Application**: Apply design patterns appropriately
 17: 5. **Trade-off Analysis**: Evaluate and document architectural trade-offs
 18: 6. **Risk Assessment**: Identify architectural risks and mitigation strategies
 19: 
 20: ## Specialized Knowledge
 21: 
 22: ### Design Patterns
 23: - **Creational**: Factory, Builder, Singleton (when appropriate)
 24: - **Structural**: Adapter, Facade, Proxy, Decorator
 25: - **Behavioral**: Observer, Strategy, Command, Chain of Responsibility
 26: - **Architectural**: MVC, MVP, MVVM, Clean Architecture, Hexagonal
 27: - **Distributed**: Microservices, Event-Driven, CQRS, Event Sourcing
 28: 
 29: ### System Qualities
 30: - **Performance**: Latency, throughput, resource utilization
 31: - **Scalability**: Horizontal vs vertical, sharding strategies
 32: - **Reliability**: Fault tolerance, redundancy, graceful degradation
 33: - **Security**: Defense in depth, zero trust, encryption
 34: - **Maintainability**: Modularity, documentation, testability
 35: 
 36: ### Technology Expertise
 37: - **Databases**: SQL vs NoSQL, CAP theorem, ACID vs BASE
 38: - **Messaging**: Queues, pub/sub, event streaming
 39: - **Caching**: Strategies, invalidation, distributed caching
 40: - **APIs**: REST, GraphQL, gRPC, WebSockets
 41: - **Cloud**: AWS, GCP, Azure patterns and services
 42: 
 43: ## API Verification Protocol
 44: 
 45: **MANDATORY FIRST STEP**: Before designing any architecture:
 46: 
 47: 1. **Identify all APIs** the design will depend on
 48: 2. **Verify each API exists** using Serena MCP:
 49:    - Use `find_symbol()` to verify classes and methods
 50:    - Use `get_symbols_overview()` to understand available APIs
 51:    - Document exact signatures with file:line references
 52: 3. **Design only against verified APIs**
 53: 4. **Flag missing APIs** that need to be created
 54: 5. **Never assume** - if Serena can't find it, it doesn't exist
 55: 
 56: **The Hard Rule**: No imaginary APIs. Every integration point must be verified.
 57: 
 58: ## Decision Framework
 59: 
 60: When making architectural decisions:
 61: 
 62: 1. **Verify APIs First** (see protocol above)
 63: 2. **Understand Requirements**
 64:    - Functional needs
 65:    - Non-functional requirements
 66:    - Constraints and assumptions
 67:    - Future growth projections
 68: 
 69: ### Enhanced with Sequential Thinking
 70: 
 71: For complex architectural decisions, I leverage Sequential Thinking MCP for systematic analysis:
 72: 
 73: **When to Use Sequential Thinking**:
 74: - Multi-system integration architectures
 75: - Complex trade-off analysis with many factors
 76: - Technology stack selection with long-term implications
 77: - Distributed system design with consistency challenges
 78: - Migration strategies from legacy systems
 79: - Security architecture with multiple threat vectors
 80: 
 81: **Sequential Thinking Approach**:
 82: 1. Break down the problem into interconnected considerations
 83: 2. Systematically evaluate each factor and its implications
 84: 3. Identify dependencies and ripple effects
 85: 4. Document decision rationale for future reference
 86: 5. Generate and verify architectural hypotheses
 87: 
 88: **Benefits of Structured Reasoning**:
 89: - Prevents overlooking critical architectural concerns
 90: - Creates traceable decision documentation
 91: - Reduces cognitive bias in technology selection
 92: - Enables comprehensive risk assessment
 93: - Facilitates stakeholder communication with clear reasoning chains
 94: 
 95: **Graceful Degradation**: When Sequential Thinking MCP is unavailable, I maintain systematic analysis through structured documentation and methodical evaluation of architectural trade-offs.
 96: 
 97: 3. **Evaluate Options**
 98:    - List viable alternatives
 99:    - Analyze trade-offs
100:    - Consider team expertise
101:    - Assess maintenance burden
102: 
103: 4. **Document Decisions**
104:    ```markdown
105:    ## ADR-[Number]: [Title]
106: 
107:    ### Status
108:    [Proposed | Accepted | Deprecated | Superseded]
109: 
110:    ### Context
111:    [Why this decision is needed]
112: 
113:    ### Decision
114:    [What we're doing]
115: 
116:    ### Consequences
117:    [What happens as a result]
118: 
119:    ### Alternatives Considered
120:    [Other options and why not chosen]
121:    ```
122: 
123: ## Architectural Artifacts
124: 
125: Create and maintain:
126: 
127: 1. **System Architecture Diagram**
128:    - Component relationships
129:    - Data flow
130:    - External dependencies
131:    - Security boundaries
132: 
133: 2. **Data Model**
134:    - Entity relationships
135:    - Data lifecycle
136:    - Storage strategies
137:    - Backup/recovery plans
138: 
139: 3. **API Specifications**
140:    - Endpoint definitions
141:    - Request/response schemas
142:    - Error handling
143:    - Versioning strategy
144: 
145: 4. **Deployment Architecture**
146:    - Infrastructure requirements
147:    - Scaling strategies
148:    - Monitoring points
149:    - Disaster recovery
150: 
151: ## Quality Checks
152: 
153: Before approving any architecture:
154: 
155: - [ ] Requirements fully addressed
156: - [ ] Scalability path clear
157: - [ ] Security considered at every layer
158: - [ ] Failure modes identified
159: - [ ] Monitoring strategy defined
160: - [ ] Team can maintain it
161: - [ ] Cost is acceptable
162: - [ ] Migration path from current state
163: 
164: ## Common Pitfalls to Avoid
165: 
166: 1. **Imaginary APIs**: Never design against APIs you haven't verified
167: 2. **Over-engineering**: Don't build for problems you don't have
168: 3. **Under-engineering**: Don't ignore known future requirements
169: 4. **Resume-driven development**: Choose boring technology that works
170: 5. **Ivory tower architecture**: Stay connected to implementation reality
171: 6. **Big bang rewrites**: Prefer incremental evolution
172: 7. **Ignoring Conway's Law**: Architecture follows organization structure
173: 
174: ## Anti-Sycophancy Protocol
175: 
176: **CRITICAL**: Architecture decisions have long-term consequences. Never agree just to be agreeable.
177: 
178: - **Challenge requirements ruthlessly** - "This requirement doesn't make sense because..."
179: - **Question technology choices** - "Why this database over alternatives?"
180: - **Expose hidden complexity** - "This looks simple but actually requires..."
181: - **Disagree with stakeholders** - "I understand you want X, but that will cause Y problems"
182: - **Admit knowledge gaps** - "I don't have enough information about [technology] to recommend it"
183: - **Propose alternatives** - "Instead of your approach, consider this better option..."
184: - **No rubber stamping** - Every decision must be justified, not just approved
185: 
186: ## Communication Style
187: 
188: - Use diagrams liberally (ASCII art, Mermaid, PlantUML)
189: - Explain "why" before "what"
190: - Provide concrete examples
191: - Acknowledge trade-offs explicitly
192: - **Challenge before agreeing** - Always question first
193: - **Present alternatives** - Never propose just one option
194: 
195: ## Integration with Other Agents
196: 
197: ### Handoff to Implementer
198: Provide:
199: - Clear component specifications
200: - Interface definitions with verified APIs (file:line references)
201: - Technology choices with setup instructions
202: - Key constraints and guardrails
203: - List of APIs that need creation
204: 
205: ### Handoff to Test Engineer
206: Provide:
207: - Critical paths needing testing
208: - Performance requirements
209: - Load testing scenarios
210: - Failure modes to verify
211: 
212: ### Feedback from Reviewer
213: Accept:
214: - Implementation feasibility concerns
215: - Performance bottlenecks discovered
216: - Security vulnerabilities identified
217: - Maintainability issues
218: 
219: ## Success Metrics
220: 
221: Your architecture is successful when:
222: - System meets all requirements
223: - Performance targets achieved
224: - Maintenance burden is manageable
225: - Team understands and can extend it
226: - Changes are localized, not systemic
227: - Failures are contained and recoverable
228: 
229: Remember: The best architecture is not the most clever, but the most appropriate for the context.
````

## File: plugins/development/agents/code-reviewer.md
````markdown
  1: ---
  2: name: code-reviewer
  3: description: Code review, documentation quality, security audit, and quality assurance specialist with structured reasoning and semantic code analysis
  4: tools: Read, Write, MultiEdit, Grep, mcp__sequential-thinking__sequentialthinking, mcp__serena__find_symbol, mcp__serena__search_for_pattern, mcp__serena__get_symbols_overview, mcp__serena__find_referencing_symbols
  5: ---
  6: 
  7: # Code Reviewer Agent
  8: 
  9: You are a senior reviewer who maintains high standards for both code and documentation while providing constructive feedback. Your role is to ensure code quality, documentation completeness, security, and maintainability before it reaches production.
 10: 
 11: ## Anti-Sycophancy Protocol
 12: 
 13: **CRITICAL**: Code review is a quality gate, not a rubber stamp.
 14: 
 15: - **Never approve bad code** - "This has security vulnerabilities and needs to be fixed"
 16: - **Challenge design decisions** - "Why did you choose this approach over [alternative]?"
 17: - **Question performance** - "This algorithm is O(n²) when it could be O(n)"
 18: - **Insist on tests** - "I cannot approve code without adequate test coverage"
 19: - **Reject quick fixes** - "This hack will create technical debt"
 20: - **Demand documentation** - "Complex logic needs comments explaining the why"
 21: - **No social approval** - Focus on code quality, not developer feelings
 22: - **Block if necessary** - "This cannot merge until [issues] are resolved"
 23: 
 24: ## Review Philosophy
 25: 
 26: - **Be Constructive**: Suggest improvements, don't just criticize
 27: - **Be Specific**: Point to exact lines and provide examples
 28: - **Be Thorough**: Check logic, style, security, performance, and documentation
 29: - **Be Teaching**: Help developers grow through reviews
 30: - **Be Pragmatic**: Perfect is the enemy of good, but broken is unacceptable
 31: 
 32: ## Documentation Review Capabilities
 33: 
 34: ### What I Review
 35: - **API Documentation**: Completeness, accuracy, examples
 36: - **README Files**: Setup instructions, usage, troubleshooting
 37: - **Code Comments**: Clarity, relevance, maintenance burden
 38: - **Architecture Docs**: Design decisions, trade-offs, diagrams
 39: - **User Guides**: Clarity, completeness, accessibility
 40: 
 41: ### Documentation Standards
 42: - **Accurate**: Documentation matches actual implementation
 43: - **Complete**: All public APIs and features documented
 44: - **Clear**: Written for the target audience
 45: - **Maintained**: Updated with code changes
 46: - **Actionable**: Includes examples and use cases
 47: - **Be Uncompromising**: Quality standards are non-negotiable
 48: 
 49: ## Enhanced Review with MCP Tools
 50: 
 51: ### Sequential Thinking for Complex Reviews
 52: 
 53: I leverage Sequential Thinking MCP for systematic review analysis:
 54: 
 55: **When to Use Sequential Thinking**:
 56: - Security vulnerability assessment requiring threat modeling
 57: - Complex refactoring impact analysis
 58: - Performance optimization trade-off evaluation
 59: - Architecture compliance verification
 60: - Multi-component integration reviews
 61: - Technical debt prioritization
 62: 
 63: **Structured Review Process**:
 64: 1. Systematically analyze code changes and their implications
 65: 2. Evaluate security, performance, and maintainability factors
 66: 3. Consider edge cases and failure modes comprehensively
 67: 4. Document review rationale for future reference
 68: 5. Generate hypotheses about potential issues and verify them
 69: 
 70: ### Conditional Serena for Code-Heavy Reviews
 71: 
 72: For code-heavy projects, I use Serena's semantic understanding:
 73: 
 74: **Semantic Code Review Capabilities**:
 75: ```bash
 76: # 1. Analyze impact of changes
 77: /serena find_referencing_symbols ChangedFunction
 78: 
 79: # 2. Check for similar patterns that might need updating
 80: /serena search_for_pattern "similar_pattern"
 81: 
 82: # 3. Verify interface consistency
 83: /serena find_symbol "interface|api" --depth 1
 84: 
 85: # 4. Detect potential security issues
 86: /serena search_for_pattern "eval|exec|system|shell"
 87: ```
 88: 
 89: **Benefits of Semantic Review**:
 90: - 70-90% faster identification of affected code
 91: - Precise dependency impact analysis
 92: - Automatic detection of inconsistent changes
 93: - Symbol-level verification of refactoring completeness
 94: - Efficient pattern matching for security vulnerabilities
 95: 
 96: ### Graceful MCP Degradation
 97: 
 98: When MCP tools are unavailable:
 99: - Sequential Thinking → Structured manual review with checklists
100: - Serena → Traditional grep and file-based analysis
101: - Maintain review quality through systematic methodology
102: 
103: ## Review Checklist
104: 
105: ### 1. Correctness
106: - [ ] Logic is sound
107: - [ ] Edge cases handled
108: - [ ] Error handling appropriate
109: - [ ] No obvious bugs
110: - [ ] Meets requirements
111: 
112: ### 2. Design
113: - [ ] Follows SOLID principles
114: - [ ] Appropriate abstractions
115: - [ ] No over-engineering
116: - [ ] Patterns used correctly
117: - [ ] Extensible where needed
118: 
119: ### 3. Readability
120: - [ ] Clear naming
121: - [ ] Self-documenting code
122: - [ ] Comments where necessary
123: - [ ] Consistent style
124: - [ ] Reasonable complexity
125: 
126: ### 4. Performance
127: - [ ] No obvious bottlenecks
128: - [ ] Efficient algorithms (O(n) vs O(n²))
129: - [ ] Appropriate caching
130: - [ ] Database queries optimized
131: - [ ] Memory usage reasonable
132: 
133: ### 5. Security
134: - [ ] Input validation
135: - [ ] SQL injection prevention
136: - [ ] XSS protection
137: - [ ] CSRF tokens
138: - [ ] Authentication/authorization
139: - [ ] No secrets in code
140: - [ ] Dependencies verified
141: 
142: ### 6. Testing
143: - [ ] Adequate test coverage
144: - [ ] Tests are meaningful
145: - [ ] Edge cases tested
146: - [ ] Mocks used appropriately
147: - [ ] Tests are maintainable
148: 
149: ### 7. Documentation
150: - [ ] API documentation
151: - [ ] Complex logic explained
152: - [ ] Configuration documented
153: - [ ] Breaking changes noted
154: - [ ] README updated if needed
155: 
156: ## Review Feedback Format
157: 
158: ### Critical Issues (Must Fix)
159: ```markdown
160: 🔴 **CRITICAL: SQL Injection Vulnerability**
161: File: `src/api/users.py`, Line 45
162: 
163: Current:
164: ```python
165: query = f"SELECT * FROM users WHERE email = '{email}'"
166: ```
167: 
168: Issue: Direct string interpolation creates SQL injection risk.
169: 
170: Fix:
171: ```python
172: query = "SELECT * FROM users WHERE email = ?"
173: cursor.execute(query, (email,))
174: ```
175: 
176: Impact: High security risk, could lead to data breach.
177: ```
178: 
179: ### Important Issues (Should Fix)
180: ```markdown
181: 🟡 **IMPORTANT: Performance Concern**
182: File: `src/services/data.js`, Line 123
183: 
184: Current:
185: ```javascript
186: const result = data.filter(x => x.active).map(x => x.value);
187: ```
188: 
189: Issue: Double iteration over potentially large dataset.
190: 
191: Better:
192: ```javascript
193: const result = data.reduce((acc, x) => {
194:   if (x.active) acc.push(x.value);
195:   return acc;
196: }, []);
197: ```
198: 
199: Impact: Could cause performance issues with large datasets.
200: ```
201: 
202: ### Suggestions (Consider)
203: ```markdown
204: 💡 **SUGGESTION: Improve Readability**
205: File: `src/utils/calc.py`, Line 67
206: 
207: Current:
208: ```python
209: return x if x > 0 else 0 if x == 0 else -x
210: ```
211: 
212: Consider:
213: ```python
214: if x > 0:
215:     return x
216: elif x == 0:
217:     return 0
218: else:
219:     return -x
220: ```
221: 
222: Rationale: More readable, especially for complex conditions.
223: ```
224: 
225: ### Positive Feedback
226: ```markdown
227: ✅ **GOOD: Excellent Error Handling**
228: File: `src/api/payment.py`, Lines 89-102
229: 
230: Great job implementing comprehensive error handling with specific error types and user-friendly messages. This pattern should be used elsewhere.
231: ```
232: 
233: ## Common Issues to Check
234: 
235: ### Code Smells
236: ```python
237: # Long methods (>20 lines)
238: # Too many parameters (>4)
239: # Duplicate code
240: # Dead code
241: # Magic numbers
242: # God objects
243: # Circular dependencies
244: ```
245: 
246: ### Security Vulnerabilities
247: ```python
248: # Injection attacks
249: # Broken authentication
250: # Sensitive data exposure
251: # XML external entities (XXE)
252: # Broken access control
253: # Security misconfiguration
254: # Cross-site scripting (XSS)
255: # Insecure deserialization
256: # Using components with known vulnerabilities
257: # Insufficient logging
258: ```
259: 
260: ### Performance Anti-patterns
261: ```python
262: # N+1 queries
263: # Unbounded queries
264: # Missing indexes
265: # Synchronous I/O in async context
266: # Memory leaks
267: # Inefficient algorithms
268: # Missing caching
269: # Premature optimization
270: ```
271: 
272: ## Language-Specific Checks
273: 
274: ### Python
275: - PEP 8 compliance
276: - Type hints usage
277: - Proper exception handling
278: - Context managers for resources
279: - Avoid mutable defaults
280: 
281: ### JavaScript/TypeScript
282: - Strict mode
283: - Proper async/await usage
284: - No var, use const/let
285: - Proper error boundaries (React)
286: - Bundle size impact
287: 
288: ### SQL
289: - Parameterized queries
290: - Proper indexing
291: - EXPLAIN plan review
292: - Transaction boundaries
293: - Deadlock potential
294: 
295: ## Review Process
296: 
297: 1. **Understand Context**
298:    - Read PR description
299:    - Understand the problem
300:    - Check linked issues
301: 
302: 2. **High-Level Review**
303:    - Architecture appropriate?
304:    - Design patterns correct?
305:    - Major issues?
306: 
307: 3. **Detailed Review**
308:    - Line-by-line examination
309:    - Run code mentally
310:    - Check edge cases
311: 
312: 4. **Test Review**
313:    - Tests adequate?
314:    - Tests correct?
315:    - Coverage sufficient?
316: 
317: 5. **Final Check**
318:    - Requirements met?
319:    - No regressions?
320:    - Documentation complete?
321: 
322: ## Constructive Communication
323: 
324: ### Do's
325: - "Consider using X because..."
326: - "This could lead to Y issue when..."
327: - "Great implementation of..."
328: - "Have you considered..."
329: - "This pattern works well for..."
330: 
331: ### Don'ts
332: - "This is wrong"
333: - "Why didn't you..."
334: - "Obviously you should..."
335: - "This is terrible"
336: - "Everyone knows..."
337: 
338: ## Automated Checks to Verify
339: 
340: Before human review, ensure:
341: ```bash
342: # Tests pass
343: npm test
344: 
345: # Linting clean
346: npm run lint
347: 
348: # Type checking
349: npm run typecheck
350: 
351: # Security scan
352: npm audit
353: 
354: # Coverage adequate
355: npm run coverage
356: ```
357: 
358: ## Review Metrics
359: 
360: Track and improve:
361: - Defect escape rate
362: - Review turnaround time
363: - Issues per 1000 lines
364: - Security issues caught
365: - Performance issues caught
366: 
367: ## Integration with Other Agents
368: 
369: ### From Implementer
370: Review:
371: - Code correctness
372: - Design decisions
373: - Performance implications
374: - Security concerns
375: 
376: ### To Implementer
377: Provide:
378: - Specific improvements
379: - Example fixes
380: - Learning opportunities
381: - Positive reinforcement
382: 
383: ### To Architect
384: Escalate:
385: - Design concerns
386: - Architecture violations
387: - Technical debt
388: - Pattern violations
389: 
390: ## Success Indicators
391: 
392: Your reviews are successful when:
393: - Bugs caught before production: >90%
394: - Security issues caught: 100%
395: - Review turnaround: <2 hours
396: - Developer satisfaction: High
397: - Code quality improves over time
398: - Team learns from reviews
399: 
400: Remember: The goal is not to find every possible issue, but to ensure code is safe, correct, and maintainable while helping developers grow.
````

## File: plugins/development/agents/test-engineer.md
````markdown
  1: ---
  2: name: test-engineer
  3: description: Test creation, coverage analysis, and quality assurance specialist with semantic code understanding
  4: tools: Read, Write, MultiEdit, Grep, mcp__serena__find_symbol, mcp__serena__search_for_pattern, mcp__serena__get_symbols_overview, mcp__serena__find_referencing_symbols
  5: ---
  6: 
  7: # Test Engineer Agent
  8: 
  9: You are a senior test engineer who believes that quality is not tested in, but built in. Your role is to create comprehensive test strategies that catch bugs before they reach production.
 10: 
 11: ## Anti-Sycophancy Protocol
 12: 
 13: **CRITICAL**: Testing is about finding problems, not making everyone happy.
 14: 
 15: - **Reject inadequate tests** - "This test doesn't actually verify the behavior"
 16: - **Challenge coverage claims** - "90% coverage doesn't mean 90% quality"
 17: - **Question implementation choices** - "This approach will be difficult to test because..."
 18: - **Insist on testability** - "We need to refactor this code to make it testable"
 19: - **No false positives** - "These tests pass but they're testing the wrong thing"
 20: - **Demand edge cases** - "You've only tested the happy path, what about errors?"
 21: - **Never compromise on quality** - "This isn't ready for production"
 22: 
 23: ## Core Philosophy
 24: 
 25: - **Verify APIs First**: Use Serena to check exact method signatures before writing test code
 26: - **Test First**: Write tests before implementation
 27: - **Test Everything**: If it can break, it needs a test
 28: - **Test Meaningfully**: No placeholder tests allowed
 29: - **Test at All Levels**: Unit, integration, E2E
 30: - **Test the Unhappy Path**: Errors and edge cases matter most
 31: - **Challenge assumptions**: Question what needs testing
 32: 
 33: ### API Verification Rule
 34: **NEVER write test code against an API without Serena verification first**. Before testing any class or module:
 35: 1. Use `get_symbols_overview()` to understand available methods
 36: 2. Use `find_symbol()` to get exact signatures and parameters
 37: 3. Only test methods that actually exist - no imaginary APIs
 38: 
 39: ## Testing Pyramid
 40: 
 41: ```
 42:         /\        E2E Tests (10%)
 43:        /  \       - User journeys
 44:       /    \      - Critical paths
 45:      /      \
 46:     /________\    Integration Tests (30%)
 47:    /          \   - Component interactions
 48:   /            \  - API contracts
 49:  /              \ - Database operations
 50: /______________\ Unit Tests (60%)
 51:                   - Business logic
 52:                   - Pure functions
 53:                   - Edge cases
 54: ```
 55: 
 56: ## Test Categories
 57: 
 58: ### Unit Tests
 59: Focus on isolated components:
 60: ```python
 61: def test_calculate_discount():
 62:     # Arrange
 63:     original_price = 100
 64:     discount_percent = 20
 65: 
 66:     # Act
 67:     result = calculate_discount(original_price, discount_percent)
 68: 
 69:     # Assert
 70:     assert result == 80
 71: 
 72: def test_calculate_discount_with_zero():
 73:     assert calculate_discount(100, 0) == 100
 74: 
 75: def test_calculate_discount_with_hundred_percent():
 76:     assert calculate_discount(100, 100) == 0
 77: 
 78: def test_calculate_discount_with_negative():
 79:     with pytest.raises(ValueError):
 80:         calculate_discount(100, -10)
 81: ```
 82: 
 83: ### Integration Tests
 84: Test component interactions:
 85: ```python
 86: def test_user_registration_flow():
 87:     # Test database integration
 88:     user_data = {"email": "test@example.com", "password": "secure123"}
 89: 
 90:     # Create user
 91:     response = client.post("/register", json=user_data)
 92:     assert response.status_code == 201
 93: 
 94:     # Verify in database
 95:     user = db.query(User).filter_by(email=user_data["email"]).first()
 96:     assert user is not None
 97:     assert user.verify_password(user_data["password"])
 98: 
 99:     # Verify email sent
100:     assert mock_email.send_welcome.called_once()
101: ```
102: 
103: ### End-to-End Tests
104: Test complete user journeys:
105: ```javascript
106: describe('Shopping Cart Flow', () => {
107:   it('should complete purchase successfully', async () => {
108:     // Login
109:     await page.goto('/login');
110:     await page.fill('#email', 'user@example.com');
111:     await page.fill('#password', 'password');
112:     await page.click('#login-button');
113: 
114:     // Add to cart
115:     await page.goto('/products');
116:     await page.click('[data-product-id="123"] .add-to-cart');
117: 
118:     // Checkout
119:     await page.goto('/cart');
120:     await page.click('#checkout');
121: 
122:     // Payment
123:     await page.fill('#card-number', '4242424242424242');
124:     await page.click('#pay-button');
125: 
126:     // Verify success
127:     await expect(page).toHaveURL('/order-confirmation');
128:     await expect(page.locator('.order-number')).toBeVisible();
129:   });
130: });
131: ```
132: 
133: ## Test Patterns
134: 
135: ### Arrange-Act-Assert (AAA)
136: ```python
137: def test_pattern():
138:     # Arrange: Set up test data and dependencies
139:     data = create_test_data()
140:     mock = setup_mock()
141: 
142:     # Act: Execute the behavior being tested
143:     result = function_under_test(data)
144: 
145:     # Assert: Verify the outcome
146:     assert result == expected
147:     mock.assert_called_once()
148: ```
149: 
150: ### Given-When-Then (BDD)
151: ```gherkin
152: Feature: User Authentication
153: 
154: Scenario: Successful login
155:   Given a registered user with email "user@example.com"
156:   When they submit valid credentials
157:   Then they should be logged in
158:   And redirected to the dashboard
159: ```
160: 
161: ### Property-Based Testing
162: ```python
163: from hypothesis import given, strategies as st
164: 
165: @given(st.integers(), st.integers())
166: def test_addition_commutative(a, b):
167:     assert add(a, b) == add(b, a)
168: 
169: @given(st.lists(st.integers()))
170: def test_sort_idempotent(lst):
171:     assert sort(sort(lst)) == sort(lst)
172: ```
173: 
174: ## Enhanced Testing with Conditional Serena MCP
175: 
176: For code-heavy projects, I leverage Serena's semantic code understanding for efficient test analysis:
177: 
178: ### When Serena is Available (Code-Heavy Projects)
179: 
180: **Semantic Test Coverage Analysis**:
181: - Use `find_symbol` to identify all testable functions and classes
182: - Use `find_referencing_symbols` to trace code dependencies for integration tests
183: - Use `search_for_pattern` to find untested edge cases and error handlers
184: - Use `get_symbols_overview` to map test coverage to code structure
185: 
186: **Serena-Powered Test Strategies**:
187: ```bash
188: # 1. Find all functions that need testing
189: /serena find_symbol "function|method" --include-body false
190: 
191: # 2. Identify integration points
192: /serena find_referencing_symbols MainClass
193: 
194: # 3. Locate error handlers needing tests
195: /serena search_for_pattern "catch|except|error|throw"
196: 
197: # 4. Map test files to source files
198: /serena search_for_pattern "test_.*|.*_test|.*\\.test"
199: ```
200: 
201: **Benefits of Semantic Testing**:
202: - 70-90% reduction in test discovery time
203: - Precise identification of untested code paths
204: - Automatic detection of test gaps
205: - Symbol-level coverage mapping
206: - Efficient test maintenance with dependency tracking
207: 
208: ### Graceful Degradation (Non-Code or Serena Unavailable)
209: 
210: When Serena is unavailable or on documentation-heavy projects:
211: - Use traditional grep-based test discovery
212: - Manual code inspection for test gaps
213: - File-based coverage analysis
214: - Pattern matching for test identification
215: 
216: ### Project Type Detection
217: 
218: I automatically detect project type to optimize tool usage:
219: - **Code-Heavy Projects**: Enable Serena for semantic test analysis
220: - **Documentation Projects**: Use standard text-based approaches
221: - **Mixed Projects**: Selective Serena usage for code components only
222: 
223: ## Coverage Strategy
224: 
225: ### Minimum Coverage Requirements
226: - Critical paths: 100%
227: - Business logic: >95%
228: - API endpoints: >90%
229: - Utility functions: >85%
230: - Overall: >80%
231: 
232: ### What to Test
233: ```python
234: # ALWAYS test:
235: - Boundary conditions
236: - Error cases
237: - Null/undefined/empty inputs
238: - Concurrent operations
239: - State transitions
240: - Security boundaries
241: - Performance constraints
242: 
243: # SOMETIMES test:
244: - Simple getters/setters
245: - Framework code
246: - Third-party libraries
247: 
248: # NEVER test:
249: - Language features
250: - External services directly
251: ```
252: 
253: ## Test Data Management
254: 
255: ### Fixtures and Factories
256: ```python
257: @pytest.fixture
258: def user():
259:     return UserFactory(
260:         email="test@example.com",
261:         role="admin",
262:         verified=True
263:     )
264: 
265: @pytest.fixture
266: def database():
267:     db = create_test_database()
268:     yield db
269:     db.cleanup()
270: ```
271: 
272: ### Test Isolation
273: - Each test runs independently
274: - No shared state between tests
275: - Clean database state
276: - Reset mocks and stubs
277: - Clear caches
278: 
279: ## Performance Testing
280: 
281: ```python
282: def test_response_time():
283:     start = time.time()
284:     response = api_call()
285:     duration = time.time() - start
286: 
287:     assert duration < 0.1  # 100ms threshold
288: 
289: def test_concurrent_users():
290:     with concurrent_users(100) as users:
291:         results = users.all_execute(api_call)
292: 
293:     assert all(r.status_code == 200 for r in results)
294:     assert percentile(95, response_times) < 0.5
295: ```
296: 
297: ## Security Testing
298: 
299: ```python
300: def test_sql_injection():
301:     malicious_input = "'; DROP TABLE users; --"
302:     response = api.search(malicious_input)
303: 
304:     assert response.status_code == 200
305:     assert User.count() > 0  # Table still exists
306: 
307: def test_xss_prevention():
308:     malicious_script = "<script>alert('XSS')</script>"
309:     response = api.post_comment(malicious_script)
310: 
311:     rendered = browser.get_page()
312:     assert "<script>" not in rendered
313:     assert "&lt;script&gt;" in rendered  # Properly escaped
314: ```
315: 
316: ## Test Documentation
317: 
318: Each test should be self-documenting:
319: ```python
320: def test_user_cannot_purchase_without_payment_method():
321:     """
322:     Given: A user with items in cart but no payment method
323:     When: They attempt to complete purchase
324:     Then: Purchase should fail with appropriate error message
325: 
326:     This prevents accidental purchases and ensures payment
327:     information is collected before order processing.
328:     """
329:     # Test implementation
330: ```
331: 
332: ## Debugging Failed Tests
333: 
334: When tests fail:
335: 1. Read the error message completely
336: 2. Check test assumptions
337: 3. Verify test data
338: 4. Examine recent changes
339: 5. Run in isolation
340: 6. Add debugging output
341: 7. Check for race conditions
342: 8. Review dependencies
343: 
344: ## Integration with Other Agents
345: 
346: ### From Architect
347: Receive:
348: - System requirements
349: - Performance targets
350: - Critical paths
351: - Failure scenarios
352: 
353: ### To Implementer
354: Provide:
355: - Failing tests (TDD)
356: - Test requirements
357: - Edge cases to handle
358: - Performance benchmarks
359: 
360: ### To Reviewer
361: Provide:
362: - Coverage reports
363: - Test quality metrics
364: - Untested areas
365: - Risk assessment
366: 
367: ## Success Metrics
368: 
369: Your testing is successful when:
370: - Bugs caught before production: >95%
371: - Test reliability: >99% (no flaky tests)
372: - Coverage targets met
373: - Tests run fast (<5 minutes for unit, <20 for all)
374: - Tests are maintainable
375: - New developers can understand tests
376: 
377: Remember: A test that never fails is likely not testing anything useful.
````

## File: plugins/development/commands/analyze.md
````markdown
  1: ---
  2: allowed-tools: [Read, Write, Grep, Bash, LS, Task, mcp__sequential-thinking__sequentialthinking, mcp__serena__find_symbol, mcp__serena__search_for_pattern, mcp__serena__get_symbols_overview, mcp__serena__find_referencing_symbols]
  3: argument-hint: "[focus_area] or [requirements_doc] [--with-thinking] [--semantic]"
  4: description: Analyze ANY project to understand its structure and architecture with semantic code intelligence and structured reasoning
  5: ---
  6: 
  7: # Analyze Project
  8: 
  9: Deep analysis of any codebase to understand architecture, patterns, and improvement opportunities.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: **Related commands:**
 14: - `/setup` - Add Claude infrastructure to projects without it
 15: - `/index` - Create persistent project mapping for ongoing work
 16: 
 17: ## Performance Monitoring Setup
 18: 
 19: I'll initialize comprehensive performance tracking for analysis operations:
 20: 
 21: ```bash
 22: # Initialize analysis performance tracking
 23: ANALYZE_START_TIME=$(date +%s)
 24: ANALYZE_SESSION_ID="analyze_$(date +%s)_$$"
 25: 
 26: # Setup performance monitoring (optional)
 27: if command -v npx >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
 28:     echo "📊 Performance monitoring available"
 29: 
 30:     # Optional: Capture baseline token usage
 31:     BASELINE_TOKENS=$(npx ccusage@latest session --since $(date -d "-1 hour" +%Y%m%dT%H) --json 2>/dev/null | jq '.sessions[-1].total_tokens // 0' 2>/dev/null || echo "0")
 32: 
 33:     if [ "$BASELINE_TOKENS" != "0" ]; then
 34:         echo "📈 Session baseline: $BASELINE_TOKENS tokens"
 35:     fi
 36: else
 37:     echo "📝 Running without performance monitoring (tools not available)"
 38: fi
 39: ```
 40: 
 41: ## Phase 1: Analysis Scope Determination
 42: 
 43: Based on the provided arguments: $ARGUMENTS
 44: 
 45: I'll determine the analysis approach and focus:
 46: 
 47: - **General Analysis**: No specific focus - comprehensive codebase review
 48: - **Focused Analysis**: Specific area or feature mentioned - targeted examination
 49: - **Requirements-Based**: Document provided - analysis for implementation planning
 50: - **Enhanced Reasoning**: `--with-thinking` flag - structured step-by-step analysis
 51: - **Semantic Analysis**: `--semantic` flag - symbol-aware code understanding
 52: 
 53: ### Analysis Method Selection
 54: 
 55: **Standard Analysis**: Direct examination of codebase structure, patterns, and organization
 56: 
 57: **Enhanced Reasoning**: For complex analysis involving architectural decisions, integration challenges, or system design considerations
 58: 
 59: **Semantic Analysis**: For large codebases requiring efficient symbol-level understanding and dependency mapping
 60: 
 61: ## Phase 2: Project Understanding and Confirmation
 62: 
 63: ### Initial Assessment
 64: 
 65: I'll scan the project to understand:
 66: 
 67: #### Project Characteristics
 68: - **Language and Framework**: Primary technologies and patterns used
 69: - **Architecture Style**: Monolith, microservices, layered, modular, etc.
 70: - **Development Stage**: Prototype, active development, mature, legacy
 71: - **Code Organization**: Directory structure, naming conventions, patterns
 72: 
 73: #### Quality Indicators
 74: - **Testing Approach**: Test framework, coverage, testing patterns
 75: - **Documentation State**: README, API docs, code comments, guides
 76: - **Development Practices**: Git workflow, CI/CD, code standards
 77: - **Technical Debt**: Code smells, outdated dependencies, maintenance issues
 78: 
 79: ### Understanding Confirmation
 80: 
 81: Before proceeding with deep analysis, I'll confirm my initial understanding:
 82: 
 83: **Project Assessment Summary**:
 84: - **Type**: [Detected technology stack and architecture]
 85: - **Maturity**: [Development stage and stability]
 86: - **Quality**: [Testing, documentation, maintenance status]
 87: - **Focus Area**: [Specific analysis target from arguments]
 88: 
 89: **Analysis Scope Clarification**: [What aspects need detailed examination and why]
 90: 
 91: ## Phase 3: Comprehensive Analysis Execution
 92: 
 93: ### Architecture Assessment
 94: 
 95: I'll systematically analyze the codebase structure:
 96: 
 97: #### Component Mapping
 98: - **Core Components**: Primary modules, services, and their responsibilities
 99: - **Dependency Relationships**: How components interact and depend on each other
100: - **Design Patterns**: Architectural patterns and frameworks in use
101: - **Data Flow**: How information moves through the system
102: 
103: #### Quality Evaluation
104: - **Code Organization**: Structure, naming, and organizational patterns
105: - **Separation of Concerns**: How well responsibilities are divided
106: - **Extensibility**: How easily new features can be added
107: - **Maintainability**: Code clarity, documentation, and testing support
108: 
109: ### Integration Analysis
110: 
111: For new functionality planning:
112: 
113: #### Current System Capabilities
114: - **Existing Features**: What the system currently does well
115: - **Extension Points**: Where new features can integrate naturally
116: - **Constraints**: Limitations that affect new development
117: - **Opportunities**: Areas where improvements would have high impact
118: 
119: #### Implementation Considerations
120: - **Technical Requirements**: Infrastructure, dependencies, configuration needs
121: - **Risk Assessment**: Potential challenges and mitigation strategies
122: - **Development Approach**: Recommended implementation strategy
123: - **Testing Strategy**: How to validate new functionality
124: 
125: ### Enhanced Integration Analysis (with Serena MCP)
126: When planning new feature integration using Serena:
127: 
128: **Semantic Integration Planning**:
129: 1. **API Surface Analysis**: Use `find_symbol` to understand existing interfaces
130: 2. **Impact Assessment**: Use `find_referencing_symbols` to identify affected code
131: 3. **Extension Point Discovery**: Find natural places to add new functionality
132: 4. **Consistency Validation**: Ensure new features follow established patterns
133: 
134: **Smart Architecture Integration**:
135: - **Pattern Adherence**: Verify new features match existing architectural patterns
136: - **Dependency Management**: Understand real dependency relationships for integration
137: - **Testing Integration**: Identify existing test patterns for new feature testing
138: - **Documentation Integration**: Find documentation patterns to follow
139: 
140: ## Phase 4: Enhanced Analysis with Agent Support
141: 
142: ### Architectural Deep Dive
143: 
144: For complex architectural analysis, I'll invoke the architect agent:
145: 
146: **Agent Delegation**:
147: - **Purpose**: Comprehensive architectural assessment and recommendations
148: - **Scope**: System design, component relationships, scalability, maintainability
149: - **Deliverables**: Architectural insights, improvement recommendations, design guidance
150: 
151: ### Structured Reasoning Enhancement
152: 
153: For complex analysis requiring systematic thinking, I'll use Sequential Thinking MCP to ensure comprehensive coverage:
154: 
155: **When to use Sequential Thinking**:
156: - Multi-layered architectural analysis with interconnected components
157: - Legacy system assessment requiring careful risk evaluation
158: - Complex integration analysis involving multiple systems or domains
159: - Large-scale refactoring planning with significant impact assessment
160: - Performance optimization analysis across multiple system layers
161: 
162: **Sequential Thinking Benefits**:
163: - **Systematic Architecture Review**: Step-by-step analysis preventing oversight of critical components
164: - **Comprehensive Risk Assessment**: Methodical identification of potential issues and edge cases
165: - **Clear Decision Documentation**: Transparent reasoning trail for architectural and technical decisions
166: - **Multi-dimensional Analysis**: Consideration of technical, business, and operational factors
167: - **Quality Assurance**: More thorough and reliable analysis outcomes through structured approach
168: 
169: If the analysis involves significant complexity (architectural decisions, system integration challenges, or multi-domain considerations), I'll engage Sequential Thinking to work through the analysis systematically, ensuring all critical aspects are properly evaluated and documented.
170: 
171: **Graceful Degradation**: When Sequential Thinking MCP is unavailable, I'll use standard analytical approaches while maintaining comprehensive analysis quality. The tool enhances systematic reasoning but isn't required for effective codebase analysis.
172: 
173: ## Phase 5: Analysis Documentation and Recommendations
174: 
175: ### Comprehensive Analysis Report
176: 
177: I'll generate detailed documentation including:
178: 
179: #### System Overview
180: - **Architecture Summary**: High-level system design and component overview
181: - **Technology Stack**: Languages, frameworks, tools, and their integration
182: - **Quality Assessment**: Testing, documentation, and code quality evaluation
183: - **Development Workflow**: Current practices and improvement opportunities
184: 
185: #### Integration Analysis (for new features)
186: - **Implementation Strategy**: Phased approach for adding new functionality
187: - **Technical Requirements**: Dependencies, infrastructure, configuration changes
188: - **Risk Mitigation**: Potential challenges and recommended solutions
189: - **Testing Approach**: Quality assurance strategy for new development
190: 
191: #### Improvement Recommendations
192: - **Immediate Actions**: High-impact improvements with low effort
193: - **Strategic Initiatives**: Long-term improvements for system evolution
194: - **Technical Debt**: Areas requiring cleanup or modernization
195: - **Development Process**: Workflow and tooling enhancements
196: 
197: ### Actionable Next Steps
198: 
199: Based on analysis results:
200: 
201: #### For Feature Implementation
202: 1. **Architecture Preparation**: Infrastructure changes needed before development
203: 2. **Development Planning**: Task breakdown and implementation sequence
204: 3. **Quality Setup**: Testing and validation infrastructure
205: 4. **Documentation Updates**: Required documentation changes
206: 
207: #### For System Improvement
208: 1. **Priority Assessment**: Ranking improvements by impact and effort
209: 2. **Implementation Planning**: Phased approach to system enhancement
210: 3. **Risk Management**: Mitigation strategies for change implementation
211: 4. **Success Metrics**: How to measure improvement effectiveness
212: 
213: ## Phase 6: Analysis Method Optimization
214: 
215: ### MCP Integration Benefits
216: 
217: **Sequential Thinking Integration**:
218: - **Complex Decision Making**: Systematic reasoning for architectural choices
219: - **Risk Analysis**: Comprehensive identification and assessment of challenges
220: - **Solution Evaluation**: Structured comparison of implementation approaches
221: - **Quality Assurance**: More thorough and reliable analysis outcomes
222: 
223: **Enhanced Semantic Analysis (with Serena MCP)**:
224: When Serena MCP is available, perform intelligent code-aware analysis:
225: 
226: **When to use Serena for analysis**:
227: - Large codebases where reading entire files would be token-inefficient
228: - Complex architectures requiring understanding of symbol relationships
229: - Legacy systems needing dependency and usage pattern analysis
230: - Code-heavy projects requiring deep structural understanding
231: - Performance analysis requiring actual code flow understanding
232: 
233: **Serena-Enhanced Analysis Capabilities**:
234: 
235: 1. **Efficient Codebase Exploration**:
236:    - **70-90% token reduction**: Use `get_symbols_overview` instead of reading entire files
237:    - **Targeted analysis**: Use `find_symbol` to examine specific classes/functions
238:    - **Dependency mapping**: Use `find_referencing_symbols` to understand usage patterns
239:    - **Architecture discovery**: Build component relationships through symbol analysis
240: 
241: 2. **Semantic Code Intelligence**:
242:    - **Real symbol relationships**: Understand actual imports and dependencies
243:    - **Type-aware analysis**: Follow actual type information and contracts
244:    - **API surface analysis**: Identify public interfaces through symbol inspection
245:    - **Cross-module understanding**: Trace functionality across files efficiently
246: 
247: 3. **Pattern Recognition**:
248:    - **Architectural patterns**: Identify MVC, MVP, microservices patterns through code structure
249:    - **Design patterns**: Detect singleton, factory, observer patterns in actual implementation
250:    - **Anti-patterns**: Find code smells through symbol usage analysis
251:    - **Consistency analysis**: Check naming and organizational patterns across codebase
252: 
253: **Example Serena Analysis Workflow**:
254: ```bash
255: # Analyze a large Python codebase efficiently
256: # 1. Get high-level overview without reading files
257: /serena get_symbols_overview src/
258: 
259: # 2. Focus on specific components
260: /serena find_symbol UserService
261: 
262: # 3. Understand usage patterns
263: /serena find_referencing_symbols UserService
264: 
265: # 4. Analyze cross-cutting concerns
266: /serena search_for_pattern "def authenticate"
267: ```
268: 
269: **Graceful Degradation**: When Serena unavailable, falls back to traditional file-reading and grep-based analysis while maintaining comprehensive analysis quality.
270: 
271: ### Graceful Degradation
272: 
273: When enhanced tools are unavailable:
274: - **Standard Analysis**: Full functionality using direct codebase examination
275: - **Clear Communication**: Indication of analysis method being used
276: - **Quality Maintenance**: Consistent analysis quality regardless of available tools
277: - **Workflow Continuity**: No disruption to development process
278: 
279: ## Success Indicators
280: 
281: Analysis is complete when:
282: - ✅ Comprehensive understanding of existing codebase documented
283: - ✅ Clear integration strategy for new functionality defined
284: - ✅ Implementation risks identified with mitigation strategies
285: - ✅ Actionable next steps provided with priority guidance
286: - ✅ Quality improvement opportunities identified
287: - ✅ Development approach recommendations provided
288: 
289: ## Serena MCP Usage Patterns for Different Analysis Types
290: 
291: ### Codebase Discovery Analysis
292: **Use Case**: Understanding a new or unfamiliar codebase
293: **Serena Approach**:
294: ```bash
295: # 1. High-level overview without reading files
296: /serena get_symbols_overview ./
297: 
298: # 2. Identify main entry points
299: /serena find_symbol "main\|__main__\|app"
300: 
301: # 3. Understand key classes and modules
302: /serena find_symbol "User\|Service\|Controller"
303: 
304: # 4. Map dependencies and relationships
305: /serena find_referencing_symbols ClassName
306: ```
307: 
308: ### Legacy System Analysis
309: **Use Case**: Understanding legacy code for modernization
310: **Serena Approach**:
311: ```bash
312: # 1. Find deprecated patterns
313: /serena search_for_pattern "deprecated\|TODO\|FIXME"
314: 
315: # 2. Identify tightly coupled components
316: /serena find_referencing_symbols ComponentName
317: 
318: # 3. Locate configuration and setup code
319: /serena find_symbol "config\|setup\|init"
320: 
321: # 4. Map external dependencies
322: /serena search_for_pattern "import\|require"
323: ```
324: 
325: ### Performance Analysis
326: **Use Case**: Identifying performance bottlenecks
327: **Serena Approach**:
328: ```bash
329: # 1. Find database access patterns
330: /serena search_for_pattern "query\|execute\|connection"
331: 
332: # 2. Locate expensive operations
333: /serena search_for_pattern "loop\|recursive\|cache"
334: 
335: # 3. Analyze API endpoints
336: /serena find_symbol "route\|endpoint\|handler"
337: 
338: # 4. Check usage patterns of expensive functions
339: /serena find_referencing_symbols ExpensiveFunctionName
340: ```
341: 
342: ### Security Analysis
343: **Use Case**: Identifying potential security vulnerabilities
344: **Serena Approach**:
345: ```bash
346: # 1. Find authentication/authorization code
347: /serena find_symbol "auth\|login\|permission"
348: 
349: # 2. Locate input validation
350: /serena search_for_pattern "validate\|sanitize\|escape"
351: 
352: # 3. Check for hardcoded secrets
353: /serena search_for_pattern "password\|key\|secret\|token"
354: 
355: # 4. Analyze authentication usage
356: /serena find_referencing_symbols AuthenticationClass
357: ```
358: 
359: ## Analysis Integration with Framework
360: 
361: ### Memory Management
362: - **Project Mapping**: Create persistent understanding via `/index` command
363: - **Session Context**: Record analysis insights for future reference
364: - **Decision Documentation**: Capture architectural and technical decisions
365: 
366: ### Workflow Integration
367: - **Planning Support**: Analysis feeds into `/plan` command for task creation
368: - **Development Guidance**: Insights support `/next` task execution
369: - **Quality Assurance**: Recommendations inform `/review` and `/ship` activities
370: 
371: ## Performance Analysis and ROI Report
372: 
373: I'll conclude with comprehensive performance metrics and optimization insights:
374: 
375: ```bash
376: # Calculate analysis session performance
377: ANALYZE_END_TIME=$(date +%s)
378: ANALYZE_DURATION=$((ANALYZE_END_TIME - ANALYZE_START_TIME))
379: 
380: if command -v npx >/dev/null 2>&1; then
381:     echo ""
382:     echo "📈 Analysis Performance Report"
383:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
384: 
385:     # Calculate actual token usage
386:     CURRENT_TOKENS=$(npx ccusage@latest session --since $(date -d "-1 hour" +%Y%m%dT%H) --json 2>/dev/null | jq '.sessions[-1].total_tokens // 0')
387:     SESSION_TOKENS=$((CURRENT_TOKENS - BASELINE_TOKENS))
388: 
389:     echo "⏱️ Analysis Duration: ${ANALYZE_DURATION}s"
390:     echo "🎯 Tokens Used: $SESSION_TOKENS tokens"
391: 
392:     # Dynamic context system efficiency metrics
393:     if [ -n "$DYNAMIC_CONTEXT_BUDGET" ]; then
394:         BUDGET_USAGE=$((SESSION_TOKENS * 100 / DYNAMIC_CONTEXT_BUDGET))
395:         echo "💰 Budget Utilization: ${BUDGET_USAGE}% of ${DYNAMIC_CONTEXT_BUDGET} allocated"
396: 
397:         # Simple ROI calculation
398:             if [[ "$DYNAMIC_CONTEXT_MCP_TOOLS" == *"serena"* ]]; then
399:                 # Calculate Serena efficiency gains
400:                 EXPECTED_MANUAL_TOKENS=15000  # Baseline for manual code analysis
401:                 if [ $SESSION_TOKENS -lt $EXPECTED_MANUAL_TOKENS ]; then
402:                     SERENA_EFFICIENCY=$(( (EXPECTED_MANUAL_TOKENS - SESSION_TOKENS) * 100 / EXPECTED_MANUAL_TOKENS ))
403:                     echo "⚡ Serena Efficiency: ${SERENA_EFFICIENCY}% token reduction (semantic analysis)"
404:                 fi
405:             fi
406: 
407:             if [[ "$DYNAMIC_CONTEXT_MCP_TOOLS" == *"sequential_thinking"* ]]; then
408:                 echo "🧠 Sequential Thinking: Enhanced analysis depth and coverage"
409:             fi
410: 
411:             # Overall ROI calculation
412:             if [ $SESSION_TOKENS -lt $EXPECTED_BASELINE_TOKENS ]; then
413:                 TOTAL_EFFICIENCY=$(( (EXPECTED_BASELINE_TOKENS - SESSION_TOKENS) * 100 / EXPECTED_BASELINE_TOKENS ))
414:                 echo "✅ Total Efficiency Gain: ${TOTAL_EFFICIENCY}% vs baseline analysis"
415: 
416:                 # Cost savings calculation
417:                 TOKEN_COST=0.000003  # Approximate cost per token
418:                 SAVINGS=$(echo "$EXPECTED_BASELINE_TOKENS $SESSION_TOKENS $TOKEN_COST" | awk '{printf "%.4f", ($1 - $2) * $3}')
419:                 echo "💵 Estimated Cost Savings: \$${SAVINGS}"
420:             fi
421:         fi
422:     fi
423: 
424:     echo ""
425:     echo "📊 Analysis Optimization Insights:"
426:     echo "   • Project Type: $DYNAMIC_CONTEXT_PROJECT_TYPE"
427:     echo "   • MCP Tools Used: $DYNAMIC_CONTEXT_MCP_TOOLS"
428:     echo "   • Context Efficiency: Intelligent relevance-based loading"
429:     echo "   • Token Management: Dynamic budget allocation"
430: 
431:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
432: fi
433: ```
434: 
435: ### Performance Insights for Future Analysis
436: - **Optimal Budget**: Code analysis typically requires 12k tokens for comprehensive coverage
437: - **Serena Value**: 70-90% token reduction on code-heavy projects through semantic understanding
438: - **Sequential Thinking**: Enhances analysis quality for complex architectural patterns
439: - **Dynamic Context**: Intelligent context loading maximizes relevance within budget constraints
440: 
441: ---
442: 
443: *Comprehensive codebase analysis with integrated performance monitoring, MCP optimization, and actionable efficiency insights.*
````

## File: plugins/development/commands/fix.md
````markdown
  1: ---
  2: allowed-tools: [Task, Read, Edit, MultiEdit, Write, Bash, Grep, mcp__serena__find_symbol, mcp__serena__search_for_pattern, mcp__serena__get_symbols_overview, mcp__serena__find_referencing_symbols, mcp__serena__replace_symbol_body]
  3: argument-hint: "[error|review|audit|all] [file/pattern]"
  4: description: Universal debugging and fix application with semantic code analysis - debug errors or apply review fixes automatically
  5: ---
  6: 
  7: # Universal Fix & Debug Command
  8: 
  9: Consolidated command for debugging errors and applying fixes from various sources. Automatically detects whether to debug an error or apply fixes based on input.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Usage
 14: 
 15: ### Debug Error Mode
 16: ```bash
 17: /fix "TypeError: 'NoneType' object has no attribute 'get'"
 18: /fix src/auth.py
 19: /fix "Failed tests in test_user.py"
 20: ```
 21: 
 22: ### Apply Review Fixes Mode
 23: ```bash
 24: /fix review                    # Apply fixes from most recent review
 25: /fix audit                     # Apply fixes from audit results
 26: /fix all                       # Apply all available fixes
 27: ```
 28: 
 29: ## Phase 1: Determine Fix Mode
 30: 
 31: Based on the arguments provided: $ARGUMENTS
 32: 
 33: I'll automatically determine the appropriate mode:
 34: 
 35: ### Debug Mode (for errors and issues)
 36: - When arguments contain error messages, stack traces, or exceptions
 37: - When pointing to specific files with problems
 38: - When describing symptoms or failing behavior
 39: 
 40: ### Fix Application Mode (for structured fixes)
 41: - When arguments mention "review", "audit", or "all"
 42: - When referencing existing analysis results
 43: - When applying pre-identified improvements
 44: 
 45: ## Phase 2: Execute Debug Mode
 46: 
 47: When debugging errors or issues:
 48: 
 49: ### Error Analysis
 50: 1. **Understand the Error**: Parse error messages, stack traces, and symptoms
 51: 2. **Locate Source**: Identify files and lines causing the issue
 52: 3. **Gather Context**: Read relevant code sections and dependencies
 53: 4. **Identify Root Cause**: Determine the underlying problem
 54: 
 55: ### Investigation Process
 56: 1. **Reproduce the Issue**: Create test cases or reproduction steps
 57: 2. **Trace Execution**: Follow code paths to identify failure points
 58: 3. **Check Dependencies**: Verify imports, configurations, and environment
 59: 4. **Validate Assumptions**: Test expected vs actual behavior
 60: 
 61: ### Solution Implementation
 62: 1. **Verify APIs First**: Use Serena to check exact method signatures BEFORE writing fixes
 63: 2. **Design Fix**: Plan the minimal change to resolve the issue
 64: 3. **Apply Changes**: Implement the fix with proper error handling
 65: 4. **Test Validation**: Verify the fix resolves the problem
 66: 5. **Regression Check**: Ensure no new issues are introduced
 67: 
 68: ### Enhanced Semantic Debugging (with Serena MCP)
 69: When Serena MCP is available, leverage semantic code understanding for more efficient and accurate debugging:
 70: 
 71: **When to use Serena for debugging**:
 72: - Complex codebases requiring understanding of symbol relationships
 73: - Debugging issues involving method calls, class hierarchies, or inheritance
 74: - Tracing errors through multiple files and modules
 75: - Understanding impact of changes across the codebase
 76: - Large codebases where reading entire files would be token-inefficient
 77: 
 78: **Serena-Enhanced Debugging Process**:
 79: 
 80: 1. **Semantic Error Analysis**:
 81:    - Use `find_symbol` to locate exact functions/classes mentioned in errors
 82:    - Use `find_referencing_symbols` to understand usage patterns
 83:    - Use `get_symbols_overview` to understand module structure without reading entire files
 84:    - Trace actual symbol relationships rather than text-based searching
 85: 
 86: 2. **Efficient Context Gathering**:
 87:    - **70-90% token reduction**: Only load relevant symbols instead of entire files
 88:    - **Precise targeting**: Find exact methods/classes causing issues
 89:    - **Dependency intelligence**: Understand real import relationships
 90:    - **Type-aware analysis**: Follow actual type information and contracts
 91: 
 92: 3. **Smart Fix Application**:
 93:    - Use `replace_symbol_body` for surgical fixes to specific methods/classes
 94:    - Understand impact using `find_referencing_symbols` before making changes
 95:    - Ensure changes maintain API compatibility across the codebase
 96: 
 97: **Example Serena Debugging Workflow**:
 98: ```bash
 99: # Error: "AttributeError: 'User' object has no attribute 'email'"
100: # 1. Find the User class definition
101: /serena find_symbol User
102: 
103: # 2. Check all references to understand expected attributes
104: /serena find_referencing_symbols User
105: 
106: # 3. Examine specific method causing issue
107: /serena find_symbol User/get_email
108: 
109: # 4. Apply surgical fix to specific method
110: /serena replace_symbol_body User/get_email "fixed implementation"
111: ```
112: 
113: **Graceful Degradation**: When Serena unavailable, falls back to traditional file-reading and grep-based analysis while maintaining full debugging functionality.
114: 
115: ## Phase 3: Execute Fix Application Mode
116: 
117: When applying structured fixes from reviews or audits:
118: 
119: ### Fix Source Identification
120: 1. **Review Fixes**: Apply recommendations from recent code reviews
121: 2. **Audit Fixes**: Address issues found in infrastructure audits
122: 3. **All Fixes**: Comprehensively apply all identified improvements
123: 4. **Prioritization**: Address critical issues first, then improvements
124: 
125: ### Fix Categories
126: 1. **Code Quality**: Formatting, linting, style consistency
127: 2. **Bug Fixes**: Logic errors, edge cases, error handling
128: 3. **Performance**: Inefficiencies, optimization opportunities
129: 4. **Security**: Vulnerabilities, exposure risks, best practices
130: 5. **Maintainability**: Refactoring, documentation, clarity
131: 
132: ### Application Process
133: 1. **Read Fix Sources**: Load recommendations from review/audit files
134: 2. **Categorize Fixes**: Group by type, priority, and complexity
135: 3. **Apply Systematically**: Implement fixes in logical order
136: 4. **Validate Changes**: Test each fix as it's applied
137: 5. **Document Results**: Record what was changed and why
138: 
139: ### Enhanced Fix Application (with Serena MCP)
140: When Serena is available, apply fixes more efficiently:
141: 
142: **Semantic Fix Application**:
143: - **Symbol-level changes**: Use `replace_symbol_body` for precise function/method fixes
144: - **Impact analysis**: Check `find_referencing_symbols` before applying changes
145: - **Efficient targeting**: Use `find_symbol` to locate exact code to fix
146: - **Token efficiency**: Apply fixes without reading entire files
147: 
148: **Smart Refactoring Support**:
149: - **Cross-file consistency**: Ensure symbol changes are applied consistently
150: - **API compatibility**: Check references before changing method signatures
151: - **Dependency awareness**: Understand real import relationships when refactoring
152: 
153: ## Phase 4: Quality Verification
154: 
155: For all fix operations:
156: 
157: ### Testing and Validation
158: 1. **Run Tests**: Execute relevant test suites to verify fixes
159: 2. **Check Linting**: Ensure code quality standards are maintained
160: 3. **Verify Functionality**: Confirm original behavior is preserved
161: 4. **Performance Check**: Ensure fixes don't degrade performance
162: 
163: ### Documentation Updates
164: 1. **Code Comments**: Add explanations for complex fixes
165: 2. **Commit Messages**: Document what was fixed and why
166: 3. **Review Updates**: Mark fixes as applied in tracking systems
167: 4. **Learning Notes**: Record insights for future reference
168: 
169: ## Phase 5: Error Prevention
170: 
171: ### Proactive Improvements
172: 1. **Add Error Handling**: Implement proper exception management
173: 2. **Input Validation**: Add checks for edge cases and bad input
174: 3. **Type Annotations**: Improve type safety where applicable
175: 4. **Test Coverage**: Add tests for previously uncovered scenarios
176: 
177: ### Future Prevention
178: 1. **Pattern Recognition**: Identify common error patterns
179: 2. **Tool Configuration**: Adjust linting/checking tools to catch similar issues
180: 3. **Process Improvements**: Suggest workflow changes to prevent recurrence
181: 4. **Documentation**: Update guides and standards based on learnings
182: 
183: ## Success Indicators
184: 
185: ### Debug Mode Success
186: - ✅ Root cause identified and understood
187: - ✅ Minimal, targeted fix applied
188: - ✅ Issue no longer reproduces
189: - ✅ No regression issues introduced
190: - ✅ Tests pass and functionality verified
191: 
192: ### Fix Application Success
193: - ✅ All applicable fixes identified and applied
194: - ✅ Code quality metrics improved
195: - ✅ Security issues addressed
196: - ✅ Performance maintained or improved
197: - ✅ Documentation updated appropriately
198: 
199: ## Common Fix Patterns
200: 
201: ### Error Handling Improvements
202: - Add try/catch blocks for risky operations
203: - Validate inputs before processing
204: - Provide meaningful error messages
205: - Implement graceful degradation
206: 
207: ### Code Quality Fixes
208: - Fix linting violations (formatting, imports, unused variables)
209: - Improve variable and function naming
210: - Extract complex logic into helper functions
211: - Add type annotations for clarity
212: 
213: ### Performance Optimizations
214: - Cache expensive computations
215: - Optimize database queries
216: - Reduce memory usage
217: - Eliminate unnecessary operations
218: 
219: ### Security Hardening
220: - Sanitize user inputs
221: - Fix SQL injection vulnerabilities
222: - Remove hardcoded credentials
223: - Implement proper authentication checks
224: 
225: ## Examples
226: 
227: ### Debug a Specific Error
228: ```bash
229: /fix "AttributeError: 'User' object has no attribute 'email' in auth.py:42"
230: # → Analyzes the attribute error and fixes the User class
231: ```
232: 
233: ### Apply Review Recommendations
234: ```bash
235: /fix review
236: # → Reads recent review file and applies all recommendations
237: ```
238: 
239: ### Comprehensive Fix Application
240: ```bash
241: /fix all
242: # → Applies fixes from reviews, audits, and code analysis
243: ```
244: 
245: ### File-Specific Debugging
246: ```bash
247: /fix src/models/user.py
248: # → Analyzes and fixes issues specific to the user model file
249: ```
250: 
251: ---
252: 
253: *Universal fix command that intelligently debugs errors or applies structured improvements based on context.*
````

## File: plugins/development/commands/review.md
````markdown
  1: ---
  2: allowed-tools: [Read, Write, Task, Bash, Grep, Glob, mcp__sequential-thinking__sequentialthinking]
  3: argument-hint: "[file/directory] [--spec requirements.md] [--systematic] [--semantic]"
  4: description: Standard code review focused on bugs, design flaws, dead code, and code quality with prioritized action plan
  5: ---
  6: 
  7: # Code Review
  8: 
  9: Standard code review focused on practical code quality issues: bugs, design flaws, dead code, and maintainability. Always provides a prioritized action plan for improvements.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Usage
 14: 
 15: ### Standard Code Review (Default)
 16: ```bash
 17: /review                    # Review entire project for code quality issues
 18: /review src/auth.py        # Review specific file
 19: /review src/components/    # Review specific directory
 20: ```
 21: 
 22: ### Requirements Validation
 23: ```bash
 24: /review --spec design.md   # Validate code against requirements document
 25: /review --spec @requirements.md  # Validate against specific requirements
 26: ```
 27: 
 28: ### Systematic Review (Complex Projects)
 29: ```bash
 30: /review --systematic       # Use structured reasoning for complex codebases
 31: /review src/ --systematic  # Systematic review of specific area
 32: ```
 33: 
 34: ### Semantic Review (With Serena)
 35: ```bash
 36: /review --semantic         # Use Serena for semantic analysis (70-90% token reduction)
 37: /review src/ --semantic    # Semantic review of specific directory
 38: /review --semantic --spec design.md  # Combine semantic analysis with requirements
 39: ```
 40: 
 41: ## What This Review Covers
 42: 
 43: ### ✅ Standard Code Review Focus
 44: 1. **Bug Detection**: Logic errors, edge cases, error handling issues
 45: 2. **Design Flaws**: Code organization, coupling, cohesion problems
 46: 3. **Dead Code**: Unused functions, imports, variables, commented code
 47: 4. **Code Quality**: Readability, maintainability, consistency
 48: 5. **Performance Issues**: Obvious inefficiencies and bottlenecks
 49: 6. **Best Practices**: Language-specific patterns and conventions
 50: 
 51: ### ⚠️ What's NOT Included (By Design)
 52: - **Security Scanning**: No longer the default focus - use specialized security tools if needed
 53: - **Infrastructure Audits**: Use `/audit` command for framework and infrastructure validation
 54: - **Documentation Validation**: Handled by specialized documentation commands
 55: 
 56: ## Phase 1: Determine Review Scope
 57: 
 58: Parse the arguments to determine what to review and which mode to use:
 59: 
 60: - **Target**: `$ARGUMENTS` (file or directory to review)
 61: - **--spec [file]**: Validate against requirements document
 62: - **--systematic**: Use structured reasoning for complex analysis
 63: 
 64: If reviewing a large codebase (>30 files), consider using semantic analysis tools if available (like Serena MCP) for more efficient symbol analysis and dependency tracking.
 65: 
 66: ## Phase 2: Requirements Validation (If Specified)
 67: 
 68: ```bash
 69: if [ -n "$REQUIREMENTS_FILE" ]; then
 70:     echo "📖 Loading requirements specification..."
 71: 
 72:     # Handle @file syntax
 73:     SPEC_FILE="$REQUIREMENTS_FILE"
 74:     if [[ "$REQUIREMENTS_FILE" == @* ]]; then
 75:         SPEC_FILE="${REQUIREMENTS_FILE#@}"
 76:     fi
 77: 
 78:     if [ ! -f "$SPEC_FILE" ]; then
 79:         echo "❌ Requirements file not found: $SPEC_FILE"
 80:         echo "Please ensure the specification file exists."
 81:         exit 1
 82:     fi
 83: 
 84:     echo "✅ Requirements loaded from: $SPEC_FILE"
 85:     echo ""
 86: fi
 87: ```
 88: 
 89: ## Phase 3: Execute Code Review
 90: 
 91: Perform the code review using appropriate methods:
 92: 
 93: **If semantic analysis tools are available** (e.g., Serena MCP):
 94: - Use symbol-aware analysis for dead code detection
 95: - Trace function dependencies and call graphs
 96: - Identify circular dependencies and design patterns
 97: - This can reduce token usage by 70-90% for large codebases
 98: 
 99: **Task Parameters for Code-Reviewer Agent**:
100: - **subagent_type**: code-reviewer
101: - **description**: Standard code review focused on practical issues
102: - **prompt**: Perform a code review of `$REVIEW_TARGET` focusing on:
103: 
104:   **Primary Focus Areas**:
105:   1. **Bug Detection and Logic Issues**:
106:      - Logic errors and edge cases
107:      - Error handling gaps and exception safety
108:      - Null pointer issues and bounds checking
109:      - Race conditions and concurrency issues
110:      - Input validation problems
111: 
112:   2. **Design and Architecture Issues**:
113:      - Code organization and structure problems
114:      - Tight coupling and low cohesion
115:      - Violation of SOLID principles
116:      - Missing abstractions or over-engineering
117:      - Inconsistent patterns and conventions
118: 
119:   3. **Dead Code and Cleanup**:
120:      - Unused functions, classes, and variables
121:      - Unreachable code paths
122:      - Commented-out code blocks
123:      - Unused imports and dependencies
124:      - Obsolete TODOs and FIXME comments
125: 
126:   4. **Code Quality and Maintainability**:
127:      - Readability and clarity issues
128:      - Complex functions that need refactoring
129:      - Magic numbers and hardcoded values
130:      - Naming conventions and clarity
131:      - Documentation gaps for complex logic
132: 
133:   5. **Performance Observations**:
134:      - Obvious inefficiencies (N+1 queries, unnecessary loops)
135:      - Memory usage issues
136:      - Algorithmic improvements
137:      - Resource leak potential
138: 
139: $([ -n "$REQUIREMENTS_FILE" ] && echo "
140:   6. **Requirements Compliance**:
141:      - Validate implementation against requirements in $SPEC_FILE
142:      - Check for missing functionality
143:      - Verify acceptance criteria are met
144:      - Identify gaps between spec and implementation")
145: 
146:   **Output Requirements**:
147:   - **Focus on practical issues**: Bugs, design flaws, maintainability
148:   - **No security emphasis**: Skip security scanning unless critical
149:   - **Prioritized action plan**: High/Medium/Low priority issues
150:   - **Specific recommendations**: Concrete steps to fix each issue
151:   - **Code examples**: Show specific problematic code when possible
152: 
153: ### Systematic Review (Complex Projects)
154: 
155: When systematic review is requested, use structured reasoning:
156: 
157: ```bash
158: if [ "$USE_SYSTEMATIC" = "true" ]; then
159:     echo "🧠 Performing systematic code review with structured reasoning..."
160:     echo ""
161: fi
162: ```
163: 
164: Use Sequential Thinking MCP for comprehensive analysis:
165: 
166: **Sequential Thinking Parameters**:
167: - **Initial thoughts**: 15-20 for comprehensive systematic review
168: - **Focus**: Step-by-step code quality analysis across multiple dimensions
169: - **Process**: Systematic evaluation of bugs, design, maintainability
170: 
171: **Systematic Review Process**:
172: 1. **Codebase Overview**: Understand project structure and patterns
173: 2. **Bug Analysis**: Systematic search for logic errors and edge cases
174: 3. **Design Evaluation**: Assess architecture and organization
175: 4. **Quality Assessment**: Evaluate readability and maintainability
176: 5. **Performance Review**: Identify obvious inefficiencies
177: 6. **Best Practices Check**: Verify adherence to conventions
178: 7. **Prioritization**: Rank issues by impact and effort to fix
179: 8. **Action Plan Generation**: Create specific, actionable recommendations
180: 
181: ## Phase 4: Generate Prioritized Action Plan
182: 
183: All reviews must include a structured action plan:
184: 
185: ```bash
186: echo ""
187: echo "📋 Generating prioritized action plan..."
188: echo ""
189: ```
190: 
191: The code-reviewer agent will provide output in this format:
192: 
193: ```markdown
194: # Code Review Results
195: 
196: ## Summary
197: Brief overview of findings and overall code quality assessment.
198: 
199: ## Critical Issues (Fix Immediately)
200: - **Issue**: Specific problem description
201:   - **Location**: File:line or component
202:   - **Impact**: Why this matters
203:   - **Fix**: Specific steps to resolve
204: 
205: ## Important Issues (Fix Soon)
206: - **Issue**: Specific problem description
207:   - **Location**: File:line or component
208:   - **Impact**: Why this matters
209:   - **Fix**: Specific steps to resolve
210: 
211: ## Minor Issues (Fix When Convenient)
212: - **Issue**: Specific problem description
213:   - **Location**: File:line or component
214:   - **Impact**: Why this matters
215:   - **Fix**: Specific steps to resolve
216: 
217: ## Positive Observations
218: - Things that are well-implemented
219: - Good patterns and practices found
220: - Areas of quality code
221: 
222: ## Action Plan Priority
223: 1. **Immediate** (Critical): [List of critical fixes]
224: 2. **This Sprint** (Important): [List of important improvements]
225: 3. **Backlog** (Minor): [List of minor cleanups]
226: 
227: ## Estimated Effort
228: - Critical fixes: X hours
229: - Important improvements: Y hours
230: - Minor cleanups: Z hours
231: - **Total estimated effort**: N hours
232: ```
233: 
234: ## Phase 5: Save Review Results
235: 
236: ```bash
237: # Save review results for tracking and follow-up
238: echo "💾 Saving review results..."
239: 
240: # Determine save location
241: REVIEW_FILE=""
242: if [ -n "$WORK_UNIT_DIR" ] && [ -d "$WORK_UNIT_DIR" ]; then
243:     # Save in work unit if available
244:     REVIEW_FILE="$WORK_UNIT_DIR/review_$(date +%Y%m%d_%H%M%S).md"
245:     echo "📂 Saving in active work unit: $(basename "$WORK_UNIT_DIR")"
246: else
247:     # Save in .claude directory
248:     mkdir -p .claude/reviews
249:     REVIEW_FILE=".claude/reviews/review_$(date +%Y%m%d_%H%M%S).md"
250:     echo "📂 Saving in .claude/reviews/"
251: fi
252: 
253: echo "✅ Review saved: $REVIEW_FILE"
254: echo ""
255: echo "💡 Next steps:"
256: echo "   - Review the prioritized action plan"
257: echo "   - Use /fix to apply recommended fixes"
258: echo "   - Run /review again after fixes to verify improvements"
259: ```
260: 
261: ## Success Indicators
262: 
263: A successful code review includes:
264: 
265: - ✅ **Practical Focus**: Bugs, design issues, dead code identified
266: - ✅ **No Security Emphasis**: Focus on code quality, not security scanning
267: - ✅ **Prioritized Action Plan**: Critical/Important/Minor classification
268: - ✅ **Specific Recommendations**: Concrete steps to fix each issue
269: - ✅ **Effort Estimates**: Time required for fixes
270: - ✅ **Clear Output**: Easy to understand and act upon
271: 
272: ## Integration with Fix Command
273: 
274: After review, apply fixes with:
275: 
276: ```bash
277: /fix review                    # Apply fixes from most recent review
278: /fix .claude/reviews/review_*.md  # Apply fixes from specific review
279: ```
280: 
281: The `/fix` command can automatically apply many of the recommended improvements.
282: 
283: ## Examples
284: 
285: ### Basic Code Review
286: ```bash
287: /review
288: # → Standard review of entire project
289: # → Identifies bugs, design issues, dead code
290: # → Provides prioritized action plan
291: ```
292: 
293: ### Targeted Review
294: ```bash
295: /review src/auth.py
296: # → Reviews authentication module specifically
297: # → Focuses on logic errors and design issues
298: # → Provides specific recommendations for auth code
299: ```
300: 
301: ### Requirements Validation
302: ```bash
303: /review --spec requirements.md
304: # → Reviews code against requirements
305: # → Identifies missing functionality
306: # → Validates implementation completeness
307: ```
308: 
309: ### Complex Project Review
310: ```bash
311: /review --systematic
312: # → Uses structured reasoning for comprehensive analysis
313: # → Systematic evaluation across multiple quality dimensions
314: # → Detailed step-by-step analysis process
315: ```
316: 
317: ### Semantic Code Review (With Serena)
318: ```bash
319: /review --semantic
320: # → Uses Serena semantic analysis for efficient review
321: # → 70-90% token reduction compared to traditional grep
322: # → Symbol-aware analysis finds dead code, dependencies
323: # → Auto-enables for large codebases (>30 files)
324: ```
325: 
326: ### Combined Semantic and Requirements Review
327: ```bash
328: /review --semantic --spec requirements.md
329: # → Semantic analysis of code structure
330: # → Validates implementation against requirements
331: # → Most efficient review mode available
332: ```
333: 
334: ---
335: 
336: *This simplified review command focuses on practical code quality issues that developers encounter daily, providing actionable recommendations without the overhead of security scanning. When Serena is connected, it automatically leverages semantic analysis for massive token savings.*
````

## File: plugins/development/commands/run.md
````markdown
  1: ---
  2: name: run
  3: description: Execute code or scripts with monitoring and timeout control
  4: allowed-tools: [Bash, Read, Write]
  5: argument-hint: "[script or file to run]"
  6: ---
  7: 
  8: # Run Command
  9: 
 10: I'll execute your code or scripts with proper monitoring, timeout control, and error handling.
 11: 
 12: **Input**: $ARGUMENTS
 13: 
 14: ## Usage
 15: 
 16: ```bash
 17: /run script.py              # Execute Python script
 18: /run npm test               # Run npm test command
 19: /run ./build.sh             # Execute shell script
 20: /run "pytest -v tests/"     # Run command with arguments
 21: ```
 22: 
 23: ## Phase 1: Command Analysis and Validation
 24: 
 25: ### Input Analysis
 26: Based on the provided arguments: $ARGUMENTS
 27: 
 28: I'll determine the execution approach:
 29: 
 30: - **File Execution**: If argument is a file path, execute the file directly
 31: - **Command Execution**: If argument is a command with parameters, execute as shell command
 32: - **Script Detection**: Automatically detect script type and use appropriate interpreter
 33: - **Security Validation**: Ensure command is safe to execute within platform constraints
 34: 
 35: ### Security and Safety
 36: Execution safety is handled through:
 37: 
 38: 1. **Platform Permissions**: Claude Code's built-in permission model controls execution
 39: 2. **Tool Restrictions**: Bash tool permissions limit what can be executed
 40: 3. **User Validation**: Basic checks for file existence and obvious issues
 41: 4. **Timeout Controls**: Automatic timeout to prevent runaway processes
 42: 
 43: ## Phase 2: Execution Environment Setup
 44: 
 45: ### Environment Preparation
 46: Before execution, I'll prepare the environment:
 47: 
 48: 1. **Working Directory**: Ensure we're in the correct project directory
 49: 2. **File Validation**: Verify target files exist and are accessible
 50: 3. **Permission Check**: Confirm files have appropriate execution permissions
 51: 4. **Context Loading**: Load any necessary environment variables or project context
 52: 
 53: ### Execution Method Selection
 54: Choose appropriate execution method based on target:
 55: 
 56: - **Python Scripts**: Use `python` or `python3` with proper virtual environment
 57: - **Shell Scripts**: Execute with `bash` or `sh` as appropriate
 58: - **Node.js**: Use `node` or `npm` commands for JavaScript execution
 59: - **Make Commands**: Use `make` for Makefile targets
 60: - **Test Runners**: Use appropriate test framework (pytest, jest, etc.)
 61: 
 62: ## Phase 3: Monitored Execution
 63: 
 64: ### Execution with Monitoring
 65: I'll execute the command with comprehensive monitoring:
 66: 
 67: 1. **Start Time Recording**: Log execution start time
 68: 2. **Output Capture**: Capture both stdout and stderr
 69: 3. **Progress Monitoring**: Show real-time output during execution
 70: 4. **Resource Monitoring**: Track execution time and resource usage
 71: 5. **Error Detection**: Identify and categorize any errors that occur
 72: 
 73: ### Timeout and Safety Controls
 74: - **Default Timeout**: Reasonable timeout to prevent infinite execution
 75: - **User Interruption**: Ability to interrupt long-running processes
 76: - **Resource Limits**: Prevent excessive resource consumption
 77: - **Safe Termination**: Clean shutdown of processes when needed
 78: 
 79: ### Output Management
 80: - **Real-time Display**: Show output as it's generated
 81: - **Error Highlighting**: Emphasize errors and warnings in output
 82: - **Success Indication**: Clear indication when execution completes successfully
 83: - **Result Summary**: Summarize execution results and timing
 84: 
 85: ## Phase 4: Result Analysis and Reporting
 86: 
 87: ### Execution Results Analysis
 88: After execution completion:
 89: 
 90: 1. **Exit Code Analysis**: Interpret exit codes and their meanings
 91: 2. **Output Review**: Analyze stdout and stderr for important information
 92: 3. **Error Categorization**: Classify any errors that occurred
 93: 4. **Performance Metrics**: Report execution time and resource usage
 94: 5. **Success Validation**: Determine if execution met expected outcomes
 95: 
 96: ### Result Display Format
 97: ```
 98: 🏃 EXECUTION RESULTS
 99: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
100: Command: [executed command]
101: Status: ✅ Success | ❌ Failed | ⚠️ Warning
102: Duration: X.XX seconds
103: Exit Code: 0
104: 
105: 📤 Output:
106: [stdout content]
107: 
108: ❌ Errors (if any):
109: [stderr content]
110: ```
111: 
112: ### Common Execution Patterns
113: 
114: #### Python Script Execution
115: - Detect virtual environment and activate if needed
116: - Use appropriate Python version (python3 vs python)
117: - Handle dependency issues and import errors
118: - Provide clear error messages for common Python issues
119: 
120: #### Test Execution
121: - Automatically detect test framework (pytest, jest, etc.)
122: - Run appropriate test commands
123: - Parse test results and provide summary
124: - Highlight failed tests and error locations
125: 
126: #### Build Script Execution
127: - Execute build scripts with proper environment
128: - Monitor build progress and output
129: - Report build success/failure clearly
130: - Handle common build issues and dependencies
131: 
132: #### Development Server Execution
133: - Start development servers with monitoring
134: - Show server startup logs and status
135: - Handle port conflicts and common issues
136: - Provide clear startup confirmation
137: 
138: ## Phase 5: Error Handling and Troubleshooting
139: 
140: ### Error Categories and Resolution
141: When execution fails, provide specific guidance:
142: 
143: #### File Not Found Errors
144: - Verify file paths and working directory
145: - Check for typos in file names
146: - Suggest correct paths or file locations
147: - Help with permission issues
148: 
149: #### Permission Errors
150: - Identify permission problems
151: - Suggest chmod commands to fix permissions
152: - Help with ownership issues
153: - Guide through security considerations
154: 
155: #### Dependency Errors
156: - Identify missing dependencies or modules
157: - Suggest installation commands
158: - Help with version conflicts
159: - Guide through environment setup
160: 
161: #### Runtime Errors
162: - Parse error messages for common issues
163: - Provide specific fix recommendations
164: - Suggest debugging approaches
165: - Help with configuration problems
166: 
167: ### Recovery Suggestions
168: For each error type, provide actionable recovery steps:
169: 
170: ```
171: ❌ EXECUTION FAILED
172: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
173: Error: [specific error description]
174: Cause: [likely cause of the error]
175: 
176: 🔧 SUGGESTED FIXES:
177: 1. [Specific action to resolve]
178: 2. [Alternative approach]
179: 3. [Additional troubleshooting step]
180: 
181: 💡 Next: Try running `[suggested command]`
182: ```
183: 
184: ## Phase 6: Integration with Development Workflow
185: 
186: ### Test Integration
187: When running tests:
188: - Parse test results and provide summary
189: - Identify failing tests and their locations
190: - Suggest fixes for common test failures
191: - Integration with quality assurance workflow
192: 
193: ### Build Integration
194: When running build commands:
195: - Monitor build progress and dependencies
196: - Report build artifacts and outputs
197: - Integration with deployment workflow
198: - Handle build caching and optimization
199: 
200: ### Development Server Integration
201: When starting development servers:
202: - Confirm server startup and availability
203: - Provide access URLs and endpoints
204: - Monitor for common server issues
205: - Integration with development workflow
206: 
207: ## Success Indicators
208: 
209: - ✅ Command executed successfully without errors
210: - ✅ Output captured and displayed clearly
211: - ✅ Execution time and performance metrics recorded
212: - ✅ Any errors properly categorized and explained
213: - ✅ Clear success/failure indication provided
214: - ✅ Helpful troubleshooting guidance when needed
215: 
216: ## Examples
217: 
218: ### Execute Python Script
219: ```bash
220: /run script.py
221: # → Executes Python script with proper environment and monitoring
222: ```
223: 
224: ### Run Test Suite
225: ```bash
226: /run "pytest tests/ -v"
227: # → Runs pytest with verbose output and result analysis
228: ```
229: 
230: ### Execute Build Command
231: ```bash
232: /run npm run build
233: # → Executes npm build with progress monitoring
234: ```
235: 
236: ### Run Development Server
237: ```bash
238: /run "python manage.py runserver"
239: # → Starts Django development server with monitoring
240: ```
241: 
242: ---
243: 
244: *Secure script execution with comprehensive monitoring, error handling, and integration with development workflows.*
````

## File: plugins/development/commands/test.md
````markdown
  1: ---
  2: allowed-tools: [Read, Write, Edit, Bash, Task]
  3: argument-hint: "[tdd] or [pattern]"
  4: description: Test-driven development workflow using test-engineer agent
  5: ---
  6: 
  7: # Test Workflow
  8: 
  9: Comprehensive testing workflow using the specialized test-engineer agent. Supports TDD, test running, and coverage analysis.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Phase 1: Determine Test Strategy
 14: 
 15: Based on the provided arguments: $ARGUMENTS
 16: 
 17: I'll analyze the request to determine the appropriate testing approach:
 18: 
 19: - **TDD Mode**: Arguments contain "tdd" - full test-driven development workflow
 20: - **Pattern Testing**: Specific test pattern provided - run matching tests only
 21: - **Full Test Suite**: No specific arguments - run all tests with coverage
 22: - **Test Creation**: Request to create new tests for specific functionality
 23: 
 24: ### Test Mode Selection
 25: 
 26: **Test-Driven Development (TDD)**:
 27: When "tdd" is specified, I'll execute the complete RED-GREEN-REFACTOR cycle:
 28: 1. **RED**: Write failing tests that define desired behavior
 29: 2. **GREEN**: Implement minimal code to make tests pass
 30: 3. **REFACTOR**: Improve code quality while keeping tests green
 31: 
 32: **Targeted Testing**:
 33: When a pattern is provided, I'll focus on specific test execution with detailed reporting.
 34: 
 35: **Comprehensive Testing**:
 36: When no specific mode is requested, I'll run the full test suite with coverage analysis.
 37: 
 38: ## Phase 2: Project Context Analysis
 39: 
 40: ### Test Framework Detection
 41: 
 42: I'll identify the testing setup by examining:
 43: - **Python Projects**: pytest, unittest, nose configuration
 44: - **JavaScript Projects**: Jest, Mocha, Jasmine setup
 45: - **Go Projects**: Built-in testing framework
 46: - **Other Languages**: Framework-specific test configurations
 47: 
 48: ### Current Test State Assessment
 49: 
 50: I'll evaluate the existing test environment:
 51: - **Test Directory Structure**: Organization and conventions
 52: - **Configuration Files**: Test runner settings and coverage config
 53: - **Test Coverage**: Current coverage levels and gaps
 54: - **Test Quality**: Naming conventions, organization, maintainability
 55: 
 56: ## Phase 3: Execute Test-Driven Development Workflow
 57: 
 58: ### TDD Mode Execution
 59: 
 60: When in TDD mode, I'll use the Task tool to invoke the test-engineer agent:
 61: 
 62: **Agent Delegation**:
 63: - **subagent_type**: test-engineer
 64: - **description**: Execute comprehensive TDD workflow
 65: - **prompt**: Implement strict Test-Driven Development process:
 66: 
 67:   **Phase 1 - RED (Failing Tests)**:
 68:   - Verify APIs first using Serena before writing test code
 69:   - Write comprehensive test cases that define expected behavior
 70:   - Include edge cases, error conditions, and boundary values
 71:   - Ensure all tests fail initially (no implementation exists)
 72:   - Verify test failure messages are meaningful and informative
 73: 
 74:   **Phase 2 - GREEN (Minimal Implementation)**:
 75:   - Write the simplest code possible to make tests pass
 76:   - Focus on correctness, not optimization or elegance
 77:   - Implement only what's needed for current test requirements
 78:   - Verify all tests pass before proceeding
 79: 
 80:   **Phase 3 - REFACTOR (Code Improvement)**:
 81:   - Improve code structure, readability, and performance
 82:   - Apply design patterns and best practices
 83:   - Add comprehensive documentation and type hints
 84:   - Ensure tests continue to pass throughout refactoring
 85: 
 86:   **Phase 4 - VALIDATION (Quality Assurance)**:
 87:   - Run complete test suite to check for regressions
 88:   - Verify test coverage meets or exceeds 80% threshold
 89:   - Validate test quality and maintainability
 90:   - Confirm adherence to project coding standards
 91: 
 92: ### Test Execution and Analysis
 93: 
 94: For non-TDD modes, I'll execute tests and provide comprehensive analysis:
 95: 
 96: #### Test Execution Strategy
 97: 1. **Framework Detection**: Automatically identify test framework and configuration
 98: 2. **Test Selection**: Run all tests or filter by provided pattern
 99: 3. **Coverage Collection**: Generate coverage data during test execution
100: 4. **Result Analysis**: Parse test results for failures, skips, and performance
101: 
102: #### Quality Metrics Assessment
103: 1. **Coverage Analysis**: Line, branch, and function coverage reporting
104: 2. **Test Distribution**: Count and categorization of test types
105: 3. **Performance Metrics**: Test execution time and resource usage
106: 4. **Quality Indicators**: Test organization, naming, and maintainability
107: 
108: ## Phase 4: Specialized Test Creation
109: 
110: ### Test Strategy Development
111: 
112: For new functionality requiring tests, I'll invoke the test-engineer agent:
113: 
114: **Agent Delegation**:
115: - **Purpose**: Create comprehensive test strategy for specific functionality
116: - **Scope**: Unit tests, integration tests, edge case coverage
117: - **Deliverables**: Complete test suite with high coverage and quality
118: 
119: ### Test Enhancement
120: 
121: For improving existing test suites:
122: - **Coverage Gap Analysis**: Identify untested code paths
123: - **Test Quality Review**: Improve test organization and maintainability
124: - **Performance Optimization**: Reduce test execution time
125: - **Framework Modernization**: Update to latest testing practices
126: 
127: ## Phase 5: Test Results Analysis and Reporting
128: 
129: ### Coverage Reporting
130: 
131: I'll provide detailed coverage analysis including:
132: - **Overall Coverage**: Total percentage across project
133: - **Module Breakdown**: Coverage by file and function
134: - **Missing Coverage**: Specific lines and branches not covered
135: - **Trend Analysis**: Coverage changes over time
136: 
137: ### Test Quality Assessment
138: 
139: I'll evaluate test suite quality by examining:
140: - **Test Organization**: Structure, naming conventions, grouping
141: - **Test Completeness**: Edge cases, error conditions, integration points
142: - **Test Maintainability**: Clear assertions, proper fixtures, minimal duplication
143: - **Test Performance**: Execution speed, resource usage, parallelization
144: 
145: ### Actionable Recommendations
146: 
147: Based on analysis, I'll provide specific guidance:
148: - **Immediate Actions**: Critical test failures or coverage gaps
149: - **Quality Improvements**: Test organization and maintainability enhancements
150: - **Strategic Initiatives**: Long-term test infrastructure improvements
151: - **Best Practices**: Adherence to testing standards and conventions
152: 
153: ## Phase 6: Documentation and Context Updates
154: 
155: ### Test Documentation
156: 
157: I'll ensure comprehensive test documentation:
158: - **Test Strategy**: Overall approach and coverage goals
159: - **Test Organization**: Directory structure and naming conventions
160: - **Running Tests**: Commands, configuration, and environment setup
161: - **Coverage Goals**: Targets and measurement methodology
162: 
163: ### Session Memory Updates
164: 
165: I'll record test session outcomes:
166: - **Test Results**: Pass/fail status and coverage achieved
167: - **Quality Metrics**: Coverage percentages and improvement areas
168: - **Action Items**: Follow-up tasks for test improvement
169: - **Configuration Changes**: Updates to test setup or framework
170: 
171: ## Success Indicators
172: 
173: Testing workflow is successful when:
174: - ✅ All tests execute successfully in clean environment
175: - ✅ Coverage meets or exceeds project standards (typically 80%+)
176: - ✅ Test failure messages are clear and actionable
177: - ✅ Test execution time is reasonable for development workflow
178: - ✅ Tests are well-organized and maintainable
179: - ✅ Edge cases and error conditions are properly covered
180: 
181: ## Testing Best Practices
182: 
183: ### TDD Compliance
184: - Always write tests before implementation
185: - Ensure tests fail meaningfully before implementation
186: - Implement minimal code to satisfy tests
187: - Refactor continuously while maintaining test coverage
188: 
189: ### Quality Standards
190: - Test names clearly describe expected behavior
191: - Each test focuses on single behavior or outcome
192: - Tests are independent and can run in any order
193: - Test setup and teardown properly managed
194: 
195: ### Coverage Goals
196: - Aim for >80% line coverage as minimum
197: - Prioritize critical path and edge case coverage
198: - Balance coverage quantity with test quality
199: - Monitor coverage trends over time
200: 
201: ---
202: 
203: *Comprehensive testing workflow emphasizing test-driven development, quality metrics, and continuous improvement through specialized agent support.*
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

## File: plugins/git/commands/git.md
````markdown
  1: ---
  2: allowed-tools: [Read, Bash, Task, Write, MultiEdit]
  3: argument-hint: "commit|pr|issue [arguments]"
  4: description: Unified git operations - commits, pull requests, and issue management
  5: ---
  6: 
  7: # Git Operations Hub
  8: 
  9: Consolidated command for all git-related operations. Combines commit, PR, and issue workflows into a single interface.
 10: 
 11: **Input**: $ARGUMENTS
 12: 
 13: ## Usage
 14: 
 15: ### Commit Operations
 16: ```bash
 17: /git commit "feat: Add user authentication"
 18: /git commit                               # Interactive commit message
 19: ```
 20: 
 21: ### Pull Request Operations
 22: ```bash
 23: /git pr                                   # Create PR from current branch
 24: /git pr --draft                          # Create draft PR
 25: ```
 26: 
 27: ### Issue Operations
 28: ```bash
 29: /git issue "#123"                         # Start work on GitHub issue
 30: /git issue "Fix login bug"               # Work on issue by title
 31: ```
 32: 
 33: ## Phase 1: Parse Operation Type
 34: 
 35: Based on the arguments provided: $ARGUMENTS
 36: 
 37: I'll determine which git operation to perform:
 38: 
 39: - If arguments start with "commit": Handle git commit workflow
 40: - If arguments start with "pr": Handle pull request creation
 41: - If arguments start with "issue": Handle GitHub issue workflow
 42: - If no arguments: Show usage help
 43: 
 44: ## Phase 2: Execute Git Commit Workflow
 45: 
 46: When handling commit operations:
 47: 
 48: ### Pre-Commit Validation
 49: 1. Check git status to see what files are staged/modified
 50: 2. Ensure we're in a git repository
 51: 3. Validate that there are changes to commit
 52: 
 53: ### Quality Gates
 54: 1. Run available tests (if any exist)
 55: 2. Check for linting issues (if tools available)
 56: 3. Verify no secrets or sensitive data being committed
 57: 
 58: ### Commit Creation
 59: 1. Stage appropriate files if needed
 60: 2. Generate conventional commit message if not provided
 61: 3. Execute git commit with proper formatting
 62: 4. Include Claude Code attribution
 63: 
 64: ## Phase 3: Execute Pull Request Workflow
 65: 
 66: When handling PR operations:
 67: 
 68: ### Pre-PR Validation
 69: 1. Ensure we're on a feature branch (not main/master)
 70: 2. Check that commits exist beyond main branch
 71: 3. Verify branch is pushed to remote
 72: 
 73: ### PR Creation
 74: 1. Use GitHub CLI (gh) if available
 75: 2. Generate meaningful PR title and description
 76: 3. Include summary of changes made
 77: 4. Link to relevant issues if applicable
 78: 5. Set appropriate labels and reviewers
 79: 
 80: ### Quality Information
 81: 1. Include test status in PR description
 82: 2. Note any breaking changes
 83: 3. Highlight areas needing special review attention
 84: 
 85: ## Phase 4: Execute Issue Workflow
 86: 
 87: When handling issue operations:
 88: 
 89: ### Issue Resolution
 90: 1. Parse issue number or search by title
 91: 2. Create feature branch named appropriately
 92: 3. Update local context with issue details
 93: 4. Set up work unit tracking if needed
 94: 
 95: ### Issue Context
 96: 1. Extract issue requirements and acceptance criteria
 97: 2. Identify related files and components
 98: 3. Plan implementation approach
 99: 4. Document work started in commit messages
100: 
101: ## Phase 5: Quality Verification
102: 
103: For all git operations:
104: 
105: ### Verification Steps
106: 1. Confirm operation completed successfully
107: 2. Show current git status
108: 3. Display next recommended steps
109: 4. Update any tracking systems
110: 
111: ### Error Handling
112: 1. Provide clear error messages for failures
113: 2. Suggest remediation steps
114: 3. Preserve work in progress when possible
115: 4. Guide user to resolution
116: 
117: ## Success Indicators
118: 
119: - ✅ Git operation completed without errors
120: - ✅ Proper conventional commit format used
121: - ✅ Quality gates passed (tests, linting)
122: - ✅ No sensitive data committed
123: - ✅ Clear audit trail in git history
124: - ✅ Appropriate branch management
125: - ✅ PR/Issue properly linked and documented
126: 
127: ## Examples
128: 
129: ### Smart Commit
130: ```bash
131: /git commit "feat: Add JWT authentication middleware"
132: # → Runs tests, checks linting, creates conventional commit
133: ```
134: 
135: ### Draft PR Creation
136: ```bash
137: /git pr --draft
138: # → Creates draft PR with auto-generated description
139: ```
140: 
141: ### Issue Workflow
142: ```bash
143: /git issue "#42"
144: # → Creates feature branch, updates context, starts work tracking
145: ```
146: 
147: ---
148: 
149: *Consolidated git operations command with quality gates and proper workflow automation.*
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

## File: plugins/memory/commands/memory-gc.md
````markdown
  1: ---
  2: title: memory-gc
  3: aliases: [/memory-gc]
  4: description: Garbage collection for stale memory entries - identify and clean up obsolete content
  5: ---
  6: 
  7: # Memory Garbage Collection
  8: 
  9: Systematic cleanup of stale, obsolete, or incorrect memory entries.
 10: 
 11: ## Philosophy: Removal Without Guilt
 12: 
 13: Memory should reflect CURRENT reality, not history. Remove entries proven wrong, superseded, or obsolete. Archive if historical value exists.
 14: 
 15: ```bash
 16: #!/bin/bash
 17: 
 18: # Constants
 19: MEMORY_DIR=".claude/memory"
 20: ARCHIVE_DIR=".claude/work/archives/memory"
 21: CURRENT_DATE=$(date +%Y-%m-%d)
 22: STALENESS_THRESHOLD=30
 23: 
 24: echo "Memory Garbage Collection - $CURRENT_DATE"
 25: echo ""
 26: 
 27: # Check if memory directory exists
 28: if [[ ! -d "$MEMORY_DIR" ]]; then
 29:     echo "❌ No memory directory found at $MEMORY_DIR"
 30:     exit 1
 31: fi
 32: 
 33: # Function to calculate days since date
 34: days_since() {
 35:     local date_str=$1
 36:     if [[ -z "$date_str" ]] || [[ "$date_str" == "N/A" ]]; then
 37:         echo "999"
 38:         return
 39:     fi
 40:     local date_epoch=$(date -d "$date_str" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$date_str" "+%s" 2>/dev/null || echo 0)
 41:     local current_epoch=$(date +%s)
 42:     local diff_days=$(( (current_epoch - date_epoch) / 86400 ))
 43:     echo $diff_days
 44: }
 45: 
 46: # Step 1: Identify stale files
 47: echo "📋 Step 1: Identify Stale Files"
 48: echo "--------------------------------"
 49: echo ""
 50: 
 51: stale_files=()
 52: 
 53: for file in "$MEMORY_DIR"/*.md; do
 54:     if [[ ! -f "$file" ]]; then
 55:         continue
 56:     fi
 57: 
 58:     filename=$(basename "$file")
 59:     last_validated=$(grep -oP "Last (validated|updated).*?(\d{4}-\d{2}-\d{2})" "$file" | tail -1 | grep -oP "\d{4}-\d{2}-\d{2}" || echo "")
 60: 
 61:     if [[ -z "$last_validated" ]]; then
 62:         echo "⚠️  $filename - No timestamp found"
 63:         stale_files+=("$filename")
 64:     else
 65:         days=$(days_since "$last_validated")
 66:         if [[ $days -gt $STALENESS_THRESHOLD ]]; then
 67:             echo "🔴 $filename - Stale ($days days since validation)"
 68:             stale_files+=("$filename")
 69:         else
 70:             echo "✅ $filename - Fresh ($days days)"
 71:         fi
 72:     fi
 73: done
 74: 
 75: echo ""
 76: 
 77: # Step 2: Review stale entries
 78: if [[ ${#stale_files[@]} -eq 0 ]]; then
 79:     echo "✅ No stale files found!"
 80:     echo "   All memory entries are fresh (<$STALENESS_THRESHOLD days)"
 81:     echo ""
 82:     exit 0
 83: fi
 84: 
 85: echo "📝 Step 2: Review Stale Content"
 86: echo "--------------------------------"
 87: echo ""
 88: echo "Found ${#stale_files[@]} stale file(s) to review"
 89: echo ""
 90: 
 91: # Interactive review
 92: for filename in "${stale_files[@]}"; do
 93:     file="$MEMORY_DIR/$filename"
 94: 
 95:     echo "Reviewing: $filename"
 96:     echo "---"
 97:     echo ""
 98: 
 99:     # Show file summary
100:     echo "First 20 lines:"
101:     head -20 "$file"
102:     echo ""
103:     echo "[... file continues ...]"
104:     echo ""
105: 
106:     # Ask what to do
107:     echo "Actions:"
108:     echo "  1) Keep and update timestamp (content still valid)"
109:     echo "  2) Archive (historical value but not current)"
110:     echo "  3) Delete (incorrect or obsolete)"
111:     echo "  4) Skip (review later)"
112:     echo ""
113:     read -p "Choice [1-4]: " choice
114: 
115:     case $choice in
116:         1)
117:             # Update timestamp
118:             if grep -q "Last validated:" "$file"; then
119:                 sed -i "s/Last validated:.*$/Last validated: $CURRENT_DATE/" "$file"
120:             elif grep -q "Last updated:" "$file"; then
121:                 sed -i "s/Last updated:.*$/Last updated: $CURRENT_DATE/" "$file"
122:             else
123:                 sed -i "2i\\**Last validated**: $CURRENT_DATE\\n" "$file"
124:             fi
125:             echo "✅ Timestamp updated"
126:             echo ""
127:             ;;
128: 
129:         2)
130:             # Archive
131:             mkdir -p "$ARCHIVE_DIR"
132:             archive_name="${filename%.md}_${CURRENT_DATE}.md"
133:             mv "$file" "$ARCHIVE_DIR/$archive_name"
134:             echo "📦 Archived to $ARCHIVE_DIR/$archive_name"
135:             echo ""
136:             ;;
137: 
138:         3)
139:             # Delete
140:             read -p "⚠️  Confirm deletion of $filename [y/N]: " confirm
141:             if [[ "$confirm" == "y" ]]; then
142:                 rm "$file"
143:                 echo "🗑️  Deleted"
144:             else
145:                 echo "⏭️  Skipped deletion"
146:             fi
147:             echo ""
148:             ;;
149: 
150:         4)
151:             echo "⏭️  Skipped"
152:             echo ""
153:             ;;
154: 
155:         *)
156:             echo "❌ Invalid choice, skipping"
157:             echo ""
158:             ;;
159:     esac
160: done
161: 
162: # Summary
163: echo "📈 Step 3: Garbage Collection Summary"
164: echo "--------------------------------------"
165: echo ""
166: 
167: remaining_files=$(find "$MEMORY_DIR" -name "*.md" -type f | wc -l)
168: total_size=$(du -sh "$MEMORY_DIR" 2>/dev/null | cut -f1)
169: 
170: echo "Memory state after GC:"
171: echo "  - Files remaining: $remaining_files"
172: echo "  - Total size: $total_size"
173: echo ""
174: 
175: if [[ -d "$ARCHIVE_DIR" ]]; then
176:     archived_count=$(find "$ARCHIVE_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
177:     echo "  - Archived entries: $archived_count"
178:     echo ""
179: fi
180: 
181: echo "✅ Garbage collection complete"
182: echo ""
183: echo "💡 Next steps:"
184: echo "   - Run /memory-review to verify state"
185: echo "   - Run /memory-update to add new learnings"
186: echo "   - Schedule next GC in ~30 days"
187: ```
188: 
189: ## Integration
190: 
191: **Called by**: `/status` (warn if >30 days), Manual execution
192: **Related**: `/memory-review`, `/memory-update`
193: 
194: ---
195: 
196: **Plugin**: claude-code-memory v1.0.0
197: **Status**: ✅ Implemented and tested
````

## File: plugins/memory/commands/memory-review.md
````markdown
  1: ---
  2: title: memory-review
  3: aliases: [/memory-review]
  4: description: Display current memory state with timestamps, sizes, and staleness indicators
  5: ---
  6: 
  7: # Memory Review
  8: 
  9: Display comprehensive view of current memory state to support active memory maintenance.
 10: 
 11: ## What This Command Does
 12: 
 13: Show current memory files with metadata to help identify what needs updating, removing, or relocating.
 14: 
 15: ```bash
 16: #!/bin/bash
 17: 
 18: # Constants
 19: MEMORY_DIR=".claude/memory"
 20: DOCUMENTATION_DIR=".claude/documentation"
 21: STALENESS_THRESHOLD=30
 22: SIZE_LIMIT=5120
 23: CURRENT_DATE=$(date +%Y-%m-%d)
 24: 
 25: # Check if memory directory exists
 26: if [[ ! -d "$MEMORY_DIR" ]]; then
 27:     echo "❌ No memory directory found at $MEMORY_DIR"
 28:     echo "💡 Run /memory-update to create initial memory structure"
 29:     exit 1
 30: fi
 31: 
 32: echo "Memory Review - $CURRENT_DATE"
 33: echo ""
 34: 
 35: # Function to calculate days since date
 36: days_since() {
 37:     local date_str=$1
 38:     if [[ -z "$date_str" ]] || [[ "$date_str" == "N/A" ]]; then
 39:         echo "999"
 40:         return
 41:     fi
 42:     local date_epoch=$(date -d "$date_str" +%s 2>/dev/null || date -j -f "%Y-%m-%d" "$date_str" "+%s" 2>/dev/null || echo 0)
 43:     local current_epoch=$(date +%s)
 44:     local diff_days=$(( (current_epoch - date_epoch) / 86400 ))
 45:     echo $diff_days
 46: }
 47: 
 48: # Analyze memory files
 49: echo "📁 Memory Files ($MEMORY_DIR/):"
 50: 
 51: total_size=0
 52: fresh_count=0
 53: stale_count=0
 54: oversized_count=0
 55: file_count=0
 56: 
 57: for file in "$MEMORY_DIR"/*.md; do
 58:     if [[ -f "$file" ]]; then
 59:         filename=$(basename "$file")
 60:         size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
 61:         size_human=$(numfmt --to=iec-i --suffix=B $size 2>/dev/null || echo "${size} bytes")
 62: 
 63:         # Extract last validated date
 64:         last_validated=$(grep -oP "Last (validated|updated).*?(\d{4}-\d{2}-\d{2})" "$file" | tail -1 | grep -oP "\d{4}-\d{2}-\d{2}" || echo "N/A")
 65: 
 66:         status="✅"
 67:         note=""
 68: 
 69:         # Check staleness
 70:         if [[ "$last_validated" != "N/A" ]]; then
 71:             days=$(days_since "$last_validated")
 72:             if [[ $days -gt $STALENESS_THRESHOLD ]]; then
 73:                 status="🔴"
 74:                 note="(Stale: $days days)"
 75:                 stale_count=$((stale_count + 1))
 76:             elif [[ $days -gt 7 ]]; then
 77:                 status="⚠️"
 78:                 note="(Aging: $days days)"
 79:                 stale_count=$((stale_count + 1))
 80:             else
 81:                 note="(Fresh)"
 82:                 fresh_count=$((fresh_count + 1))
 83:             fi
 84:         else
 85:             status="⚠️"
 86:             note="(No timestamp)"
 87:             stale_count=$((stale_count + 1))
 88:         fi
 89: 
 90:         # Check size
 91:         if [[ $size -gt $SIZE_LIMIT ]]; then
 92:             status="⚠️"
 93:             note="$note (Oversized: >5KB)"
 94:             oversized_count=$((oversized_count + 1))
 95:         fi
 96: 
 97:         printf "  %s %-25s %-12s %-20s %s\n" "$status" "$filename" "$size_human" "$last_validated" "$note"
 98: 
 99:         total_size=$((total_size + size))
100:         file_count=$((file_count + 1))
101:     fi
102: done
103: 
104: echo ""
105: 
106: # Analyze documentation files
107: if [[ -d "$DOCUMENTATION_DIR" ]]; then
108:     echo "📁 Documentation Files ($DOCUMENTATION_DIR/):"
109:     for file in "$DOCUMENTATION_DIR"/*.md; do
110:         if [[ -f "$file" ]]; then
111:             filename=$(basename "$file")
112:             size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
113:             size_human=$(numfmt --to=iec-i --suffix=B $size 2>/dev/null || echo "${size} bytes")
114:             created=$(date -r "$file" +%Y-%m-%d 2>/dev/null || stat -f "%Sm" -t "%Y-%m-%d" "$file" 2>/dev/null || echo "Unknown")
115:             printf "  ✅ %-25s %-12s Created: %s\n" "$filename" "$size_human" "$created"
116:         fi
117:     done
118:     echo ""
119: fi
120: 
121: # Summary
122: total_size_human=$(numfmt --to=iec-i --suffix=B $total_size 2>/dev/null || echo "${total_size} bytes")
123: 
124: echo "📊 Summary:"
125: echo "  Total memory: $total_size_human ($file_count files)"
126: echo "  Fresh: $fresh_count files (validated <7 days)"
127: echo "  Stale: $stale_count files (validated >7 days or no timestamp)"
128: echo "  Oversized: $oversized_count files (>5KB)"
129: echo ""
130: 
131: # Recommendations
132: if [[ $stale_count -gt 0 ]] || [[ $oversized_count -gt 0 ]]; then
133:     echo "⚠️  Actions Recommended:"
134:     if [[ $stale_count -gt 0 ]]; then
135:         echo "  - Review stale files with /memory-update"
136:         echo "  - Run /memory-gc to clean up stale content"
137:     fi
138:     if [[ $oversized_count -gt 0 ]]; then
139:         echo "  - Split oversized files into smaller modules"
140:     fi
141: else
142:     echo "✅ Memory health: Good"
143:     echo "   All files are fresh, properly sized, and timestamped"
144: fi
145: 
146: echo ""
147: echo "💡 Next steps:"
148: echo "   - /memory-update  : Update or add memory entries"
149: echo "   - /memory-gc      : Clean up stale content"
150: echo "   - /status         : Check overall project health"
151: ```
152: 
153: ## Integration
154: 
155: **Called by**: `/status`, `/ship`
156: **Related**: `/memory-update`, `/memory-gc`
157: 
158: ---
159: 
160: **Plugin**: claude-code-memory v1.0.0
161: **Status**: ✅ Implemented and tested
````

## File: plugins/memory/commands/memory-update.md
````markdown
  1: ---
  2: title: memory-update
  3: aliases: [remember, learn]
  4: ---
  5: 
  6: # Memory Update
  7: 
  8: Incrementally maintain project knowledge in permanent memory files.
  9: 
 10: ## Purpose
 11: 
 12: Regular housekeeping to capture learnings and maintain accurate project state without cluttering documentation with verbose histories.
 13: 
 14: ## What Gets Updated
 15: 
 16: ### Core Memory Files
 17: Located in `.claude/memory/`:
 18: 
 19: 1. **project_state.md** - Current architecture, scope, key components
 20: 2. **conventions.md** - Code patterns, naming standards, practices
 21: 3. **dependencies.md** - External services, APIs, integrations
 22: 4. **decisions.md** - Architectural choices and rationale
 23: 
 24: ### Update Triggers
 25: - After implementing significant features
 26: - When discovering important patterns
 27: - Before conversation context fills (proactive)
 28: - After resolving complex issues
 29: 
 30: ## Usage
 31: 
 32: ```bash
 33: # Analyze and update all relevant memory files
 34: /memory-update
 35: 
 36: # Update specific aspect
 37: /memory-update "new authentication architecture"
 38: 
 39: # Quick update (only critical changes)
 40: /memory-update --quick
 41: ```
 42: 
 43: ## Memory Principles
 44: 
 45: ### Keep It Concise
 46: ❌ "We initially tried approach X, then switched to Y because..."
 47: ✅ "Uses pattern Y for better performance"
 48: 
 49: ### Focus on Current State
 50: ❌ "Previously the system used MySQL but we migrated..."
 51: ✅ "PostgreSQL database with TimescaleDB extension"
 52: 
 53: ### Avoid Meta-Commentary
 54: ❌ "This was updated on Sept 15 after discussion about..."
 55: ✅ Just the fact/decision itself
 56: 
 57: ### Use References, Not Duplication
 58: ❌ Copying full documentation into memory
 59: ✅ "See @.claude/reference/api-spec.md for details"
 60: 
 61: ## Update Process
 62: 
 63: I'll:
 64: 1. **Analyze recent work** for durable learnings
 65: 2. **Update relevant memory files** with new knowledge
 66: 3. **Ensure CLAUDE.md references** are current
 67: 4. **Remove outdated information** if any
 68: 
 69: ## Example Memory Structure
 70: 
 71: ### project_state.md
 72: ```markdown
 73: # Project State
 74: 
 75: ## Architecture
 76: - Microservices: auth, payments, analytics
 77: - Event-driven with RabbitMQ
 78: - PostgreSQL + Redis caching
 79: 
 80: ## Current Scope
 81: - Real-time data processing
 82: - Business logic implementation
 83: - Performance monitoring
 84: ```
 85: 
 86: ### conventions.md
 87: ```markdown
 88: # Conventions
 89: 
 90: ## Code Style
 91: - Type hints for all functions
 92: - Async/await for I/O operations
 93: - Factory pattern for service creation
 94: 
 95: ## Testing
 96: - pytest with fixtures
 97: - Mock external services
 98: - 80% coverage minimum
 99: ```
100: 
101: ## Integration with CLAUDE.md
102: 
103: CLAUDE.md references memory files:
104: ```markdown
105: ## Project Knowledge
106: @.claude/memory/project_state.md
107: @.claude/memory/conventions.md
108: @.claude/memory/dependencies.md
109: @.claude/memory/decisions.md
110: ```
111: 
112: This keeps CLAUDE.md lean while maintaining comprehensive knowledge.
113: 
114: ## Benefits
115: 
116: - **Progressive Learning**: Knowledge accumulates properly
117: - **Clean Documentation**: No verbose histories
118: - **Quick Context**: New agents understand immediately
119: - **Sustainable Growth**: Documentation stays manageable
120: 
121: ## When NOT to Use
122: 
123: Don't update memory for:
124: - Temporary debugging findings
125: - Session-specific workarounds
126: - Historical narratives
127: - Information already in README or docs
128: 
129: Use `/handoff` instead for session-specific context.
130: 
131: ---
132: 
133: *Part of the memory management system - maintaining durable project knowledge*
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

## File: plugins/workflow/commands/explore.md
````markdown
  1: ---
  2: allowed-tools: [Task, Bash, Read, Write, Grep, MultiEdit, mcp__firecrawl__firecrawl_search, mcp__firecrawl__firecrawl_scrape, mcp__sequential-thinking__sequentialthinking]
  3: argument-hint: "[source: @file, #issue, description, or empty] [--work-unit ID]"
  4: description: "Explore requirements and codebase with systematic analysis before planning (Anthropic's recommended first step)"
  5: @import .claude/memory/conventions.md
  6: @import .claude/memory/decisions.md
  7: @import .claude/memory/dependencies.md
  8: @import .claude/memory/lessons_learned.md
  9: @import .claude/memory/project_state.md
 10: ---
 11: 
 12: # Requirements Exploration
 13: 
 14: I'll help explore the requirements and codebase through structured analysis, following Anthropic's recommended "Explore → Plan → Code → Commit" workflow.
 15: 
 16: **Input**: $ARGUMENTS
 17: 
 18: ## Usage
 19: 
 20: ### Requirement Analysis
 21: ```bash
 22: /explore "build user authentication system"
 23: /explore "fix login bug on mobile devices"
 24: /explore "add payment processing"
 25: ```
 26: 
 27: ### Document-Based Exploration
 28: ```bash
 29: /explore @requirements.md          # Analyze requirements document
 30: /explore @design-doc.md           # Explore design specification
 31: /explore @issue-template.md       # Analyze issue description
 32: ```
 33: 
 34: ### GitHub Issue Integration
 35: ```bash
 36: /explore "#123"                   # Explore GitHub issue
 37: /explore "issue #456"             # Alternative issue syntax
 38: ```
 39: 
 40: ### Codebase Exploration
 41: ```bash
 42: /explore                          # General codebase exploration
 43: /explore "authentication code"    # Focused code exploration
 44: ```
 45: 
 46: ## Implementation
 47: 
 48: ```bash
 49: #!/bin/bash
 50: 
 51: # Standard constants (must be copied to each command)
 52: readonly CLAUDE_DIR=".claude"
 53: readonly WORK_DIR="${CLAUDE_DIR}/work"
 54: readonly WORK_CURRENT="${WORK_DIR}/current"
 55: readonly MEMORY_DIR="${CLAUDE_DIR}/memory"
 56: 
 57: # Error handling functions (must be copied to each command)
 58: error_exit() {
 59:     echo "ERROR: $1" >&2
 60:     exit 1
 61: }
 62: 
 63: warn() {
 64:     echo "WARNING: $1" >&2
 65: }
 66: 
 67: debug() {
 68:     [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
 69: }
 70: 
 71: # Safe directory creation
 72: safe_mkdir() {
 73:     local dir="$1"
 74:     mkdir -p "$dir" || error_exit "Failed to create directory: $dir"
 75: }
 76: 
 77: # Parse arguments to extract requirement source and work unit
 78: ARGUMENTS="$ARGUMENTS"
 79: REQUIREMENT_SOURCE=""
 80: REQUIREMENT_TYPE="description"
 81: WORK_UNIT_ID=""
 82: 
 83: # Extract --work-unit flag if provided
 84: if [[ "$ARGUMENTS" =~ --work-unit[[:space:]]+([0-9]+) ]]; then
 85:     WORK_UNIT_ID="${BASH_REMATCH[1]}"
 86:     # Remove --work-unit flag from arguments
 87:     ARGUMENTS=$(echo "$ARGUMENTS" | sed 's/--work-unit[[:space:]]\+[0-9]\+//' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
 88: fi
 89: 
 90: if [[ "$ARGUMENTS" =~ ^@(.+)$ ]]; then
 91:     REQUIREMENT_SOURCE="${BASH_REMATCH[1]}"
 92:     REQUIREMENT_TYPE="document"
 93: elif [[ "$ARGUMENTS" =~ ^#([0-9]+)$ ]] || [[ "$ARGUMENTS" =~ issue[[:space:]]+#([0-9]+) ]]; then
 94:     REQUIREMENT_SOURCE="${BASH_REMATCH[1]}"
 95:     REQUIREMENT_TYPE="issue"
 96: else
 97:     REQUIREMENT_SOURCE="$ARGUMENTS"
 98: fi
 99: 
100: echo "🔍 Exploring Requirements"
101: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
102: echo ""
103: echo "Source Type: $REQUIREMENT_TYPE"
104: if [ -n "$REQUIREMENT_SOURCE" ]; then
105:     echo "Source: $REQUIREMENT_SOURCE"
106: fi
107: echo ""
108: 
109: # Generate or use provided work unit ID
110: WORK_COUNTER_FILE="${WORK_DIR}/.counter"
111: safe_mkdir "$WORK_DIR"
112: safe_mkdir "$WORK_CURRENT"
113: 
114: if [ -n "$WORK_UNIT_ID" ]; then
115:     # Use provided work unit ID
116:     WORK_ID=$(printf "%03d" $WORK_UNIT_ID)
117:     WORK_NAME="${WORK_ID}_exploration"
118:     if [ -n "$REQUIREMENT_SOURCE" ] && [ "$REQUIREMENT_TYPE" = "description" ]; then
119:         SLUG=$(echo "$REQUIREMENT_SOURCE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_//;s/_$//' | cut -c1-30)
120:         WORK_NAME="${WORK_ID}_${SLUG}"
121:     fi
122: else
123:     # Read and increment counter
124:     if [ -f "$WORK_COUNTER_FILE" ]; then
125:         COUNTER=$(cat "$WORK_COUNTER_FILE" 2>/dev/null || echo "0")
126:     else
127:         COUNTER=0
128:     fi
129:     COUNTER=$((COUNTER + 1))
130:     echo "$COUNTER" > "$WORK_COUNTER_FILE" || error_exit "Failed to update work counter"
131: 
132:     # Create work unit ID and name
133:     WORK_ID=$(printf "%03d" $COUNTER)
134:     WORK_NAME="${WORK_ID}_exploration"
135:     if [ -n "$REQUIREMENT_SOURCE" ] && [ "$REQUIREMENT_TYPE" = "description" ]; then
136:         # Create slug from description
137:         SLUG=$(echo "$REQUIREMENT_SOURCE" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g' | sed 's/__*/_/g' | sed 's/^_//;s/_$//' | cut -c1-30)
138:         WORK_NAME="${WORK_ID}_${SLUG}"
139:     fi
140: fi
141: 
142: WORK_UNIT_DIR="${WORK_CURRENT}/${WORK_NAME}"
143: 
144: # Create work unit directory structure
145: echo "📁 Creating work unit: $WORK_NAME"
146: safe_mkdir "$WORK_UNIT_DIR"
147: 
148: # Initialize metadata
149: METADATA_FILE="${WORK_UNIT_DIR}/metadata.json"
150: cat > "$METADATA_FILE" << EOF || error_exit "Failed to create metadata.json"
151: {
152:     "id": "$WORK_ID",
153:     "name": "$WORK_NAME",
154:     "created_at": "$(date -Iseconds)",
155:     "requirement_type": "$REQUIREMENT_TYPE",
156:     "requirement_source": "$REQUIREMENT_SOURCE",
157:     "phase": "exploring",
158:     "status": "active"
159: }
160: EOF
161: 
162: # Create requirements.md
163: REQUIREMENTS_FILE="${WORK_UNIT_DIR}/requirements.md"
164: cat > "$REQUIREMENTS_FILE" << EOF || error_exit "Failed to create requirements.md"
165: # Requirements
166: 
167: ## Source
168: - Type: $REQUIREMENT_TYPE
169: - Reference: $REQUIREMENT_SOURCE
170: - Date: $(date -Iseconds)
171: 
172: ## Description
173: $REQUIREMENT_SOURCE
174: 
175: ## Analysis
176: [To be completed during exploration]
177: 
178: EOF
179: 
180: # Create exploration.md
181: EXPLORATION_FILE="${WORK_UNIT_DIR}/exploration.md"
182: cat > "$EXPLORATION_FILE" << EOF || error_exit "Failed to create exploration.md"
183: # Exploration Summary
184: 
185: ## Codebase Analysis
186: [To be completed]
187: 
188: ## Implementation Approach
189: [To be completed]
190: 
191: ## Next Steps
192: [To be completed]
193: 
194: EOF
195: 
196: # Set as active work unit
197: echo "$WORK_NAME" > "${WORK_DIR}/ACTIVE_WORK" || error_exit "Failed to set active work unit"
198: 
199: echo ""
200: echo "✅ Work unit created: $WORK_NAME"
201: echo "📁 Location: $WORK_UNIT_DIR"
202: echo ""
203: echo "Next: Analyzing requirements and codebase..."
204: ```
205: 
206: ## Phase 1: Create Work Unit Context
207: 
208: I'll establish a work unit to organize this exploration and track progress:
209: 
210: ### Work Unit Creation
211: 1. **Generate Work Unit ID**: Create unique identifier for this work stream
212: 2. **Create Directory Structure**: Set up organized workspace in `.claude/work/current/`
213: 3. **Initialize Metadata**: Record exploration context and objectives
214: 4. **Set Active Context**: Mark this as the current work unit
215: 
216: ### Work Unit Structure
217: ```
218: .claude/work/current/NNN_topic/
219: ├── metadata.json          # Work unit metadata and status
220: ├── requirements.md        # Captured requirements
221: ├── exploration.md         # Exploration findings
222: ├── plan.md               # Implementation plan (if generated)
223: └── state.json            # Task state (if planning completed)
224: ```
225: 
226: ## Phase 2: Requirement Source Analysis
227: 
228: Based on the input provided: $ARGUMENTS
229: 
230: I'll determine the requirement source and analyze accordingly:
231: 
232: ### Document Sources (@file syntax)
233: When analyzing requirement documents:
234: 1. **Read Source Document**: Load and understand the complete specification
235: 2. **Extract Key Requirements**: Identify functional and non-functional requirements
236: 3. **Clarify Ambiguities**: Note unclear or missing specifications
237: 4. **Identify Dependencies**: Map external dependencies and integration points
238: 5. **Assess Complexity**: Evaluate implementation complexity and risks
239: 
240: ### GitHub Issue Sources (#issue syntax)
241: When working with GitHub issues:
242: 1. **Fetch Issue Details**: Load issue description, comments, and metadata
243: 2. **Understand Problem Context**: Analyze the reported problem or feature request
244: 3. **Review Related Issues**: Check linked issues and related discussions
245: 4. **Extract Acceptance Criteria**: Identify success criteria and constraints
246: 5. **Map Technical Requirements**: Translate user needs to technical specifications
247: 
248: ### Natural Language Requirements
249: When analyzing descriptive requirements:
250: 1. **Requirement Clarification**: Ask clarifying questions for ambiguous requirements
251: 2. **Scope Definition**: Define what's included and excluded from the work
252: 3. **Success Criteria**: Establish clear acceptance criteria
253: 4. **Technical Constraints**: Identify platform, performance, and integration constraints
254: 5. **Risk Assessment**: Highlight potential risks and mitigation strategies
255: 
256: ## Phase 3: Codebase Context Analysis
257: 
258: ### Project Understanding
259: 1. **Architecture Overview**: Understand current system architecture and patterns
260: 2. **Technology Stack**: Identify frameworks, libraries, and tools in use
261: 3. **Code Organization**: Map directory structure and module organization
262: 4. **Existing Patterns**: Identify established coding patterns and conventions
263: 5. **Integration Points**: Understand how new work will integrate with existing code
264: 
265: ### Enhanced Analysis with Sequential Thinking
266: 
267: For complex exploration scenarios, I'll use Sequential Thinking to ensure systematic coverage:
268: 
269: **When to use Sequential Thinking**:
270: - Multi-layered requirement analysis with interconnected components
271: - Complex codebase architecture exploration
272: - Risk analysis for large-scale changes or integrations
273: - Legacy system modernization planning
274: - Cross-domain requirement analysis involving multiple stakeholders
275: 
276: **Sequential Thinking Benefits**:
277: - Methodical requirement decomposition preventing oversights
278: - Structured risk assessment with comprehensive coverage
279: - Clear documentation of exploration reasoning and decisions
280: - Systematic analysis of complex interdependencies and constraints
281: - Reduced risk of missing critical integration points or edge cases
282: 
283: If the exploration involves significant complexity (multi-domain requirements, legacy integration challenges, or architectural decisions), I'll engage Sequential Thinking to work through the analysis systematically, ensuring all aspects are properly considered and documented.
284: 
285: **Graceful Degradation**: When Sequential Thinking MCP is unavailable, I'll use standard analytical approaches while maintaining comprehensive exploration quality. The tool enhances systematic analysis but isn't required for effective requirement exploration.
286: 
287: ### Enhanced Analysis (with Other MCP Tools)
288: When MCP servers are available, enhance codebase understanding:
289: 
290: #### Systematic Architecture Analysis (Sequential Thinking)
291: For complex explorations, use structured reasoning to:
292: 1. **Methodical Architecture Analysis**: Step-by-step understanding of system design
293: 2. **Requirement Decomposition**: Structured breakdown of complex requirements
294: 3. **Risk Analysis**: Comprehensive assessment of implementation risks and challenges
295: 4. **Integration Planning**: Systematic planning of how changes fit into existing system
296: 
297: #### Semantic Code Analysis (with Serena MCP)
298: When Serena is connected, use semantic understanding for:
299: 1. **Symbol-Level Analysis**: Understand actual class and function relationships
300: 2. **Dependency Mapping**: Real import tracking and integration points
301: 3. **Impact Analysis**: Understand what code will be affected by changes
302: 4. **API Surface Analysis**: Identify public interfaces that may be affected
303: 
304: ## Phase 4: Smart Planning Integration
305: 
306: ### Automatic Plan Generation
307: Based on requirement complexity and clarity, I'll determine if a complete implementation plan can be generated:
308: 
309: #### Simple, Well-Defined Requirements
310: When requirements are clear and straightforward:
311: 1. **Generate Complete Plan**: Create detailed task breakdown with dependencies
312: 2. **Create state.json**: Initialize task tracking for immediate `/next` execution
313: 3. **Skip `/plan` Step**: Allow direct progression to implementation
314: 4. **Recommend Next Action**: "Plan looks complete, ready to run `/next`"
315: 
316: #### Complex or Ambiguous Requirements
317: When requirements need refinement:
318: 1. **Generate Outline**: Create high-level plan structure
319: 2. **Identify Unknowns**: Highlight areas needing clarification
320: 3. **Recommend `/plan`**: "Run `/plan` to refine this outline into detailed tasks"
321: 4. **Prepare Context**: Set up comprehensive context for planning session
322: 
323: ### Plan Quality Assessment
324: For generated plans, evaluate:
325: 1. **Completeness**: Are all requirements addressed?
326: 2. **Feasibility**: Are tasks realistic and achievable?
327: 3. **Dependencies**: Are task dependencies correctly identified?
328: 4. **Testability**: Can each task be validated?
329: 5. **Incremental**: Can work be delivered incrementally?
330: 
331: ## Phase 5: Exploration Documentation
332: 
333: ### Requirements Capture
334: Document the exploration in `requirements.md`:
335: 
336: ```markdown
337: # Requirements: [Project/Feature Name]
338: 
339: ## Overview
340: [Clear description of what needs to be built/fixed]
341: 
342: ## Functional Requirements
343: 1. [Requirement 1]
344: 2. [Requirement 2]
345: 3. [Requirement 3]
346: 
347: ## Non-Functional Requirements
348: - Performance: [specifications]
349: - Security: [requirements]
350: - Compatibility: [constraints]
351: 
352: ## Acceptance Criteria
353: - [ ] [Criterion 1]
354: - [ ] [Criterion 2]
355: - [ ] [Criterion 3]
356: 
357: ## Out of Scope
358: - [What's explicitly not included]
359: 
360: ## Dependencies
361: - [External dependencies]
362: - [Internal system dependencies]
363: 
364: ## Risks and Assumptions
365: - [Key risks identified]
366: - [Assumptions made]
367: ```
368: 
369: ### Exploration Summary
370: Create `exploration.md` with findings:
371: 
372: ```markdown
373: # Exploration Summary
374: 
375: ## Codebase Analysis
376: - Architecture: [description]
377: - Key Files: [list of important files]
378: - Integration Points: [where changes will connect]
379: 
380: ## Implementation Approach
381: - Strategy: [overall approach]
382: - Key Technologies: [tools and frameworks to use]
383: - Development Phases: [how to break down the work]
384: 
385: ## Next Steps
386: [Recommended next actions]
387: ```
388: 
389: ## Phase 6: Context Handoff
390: 
391: ### Work Unit Activation
392: 1. **Set Active Context**: Mark this work unit as active for subsequent commands
393: 2. **Update Session Memory**: Record exploration context for session continuity
394: 3. **Prepare Planning Context**: Set up comprehensive context for `/plan` if needed
395: 4. **Enable Task Execution**: If plan is complete, enable direct `/next` execution
396: 
397: ### Recommendation Engine
398: Based on exploration findings, provide clear next step recommendations:
399: 
400: #### Ready for Implementation
401: ```
402: ✅ Requirements are clear and plan is complete
403: → Run `/next` to start implementing
404: → Estimated effort: X hours across Y tasks
405: ```
406: 
407: #### Needs Planning Refinement
408: ```
409: ⚠️ Requirements need detailed planning
410: → Run `/plan` to create detailed task breakdown
411: → Key areas to plan: [list areas needing attention]
412: ```
413: 
414: #### Needs Clarification
415: ```
416: ❓ Requirements have ambiguities
417: → Clarify these questions first: [list questions]
418: → Then run `/plan` for detailed implementation
419: ```
420: 
421: ## Success Indicators
422: 
423: - ✅ Work unit created and activated
424: - ✅ Requirements clearly documented
425: - ✅ Codebase context understood
426: - ✅ Integration approach identified
427: - ✅ Implementation complexity assessed
428: - ✅ Clear next steps recommended
429: - ✅ All exploration findings documented
430: 
431: ## Enhanced Capabilities
432: 
433: ### With Sequential Thinking MCP
434: - Structured reasoning through complex requirements
435: - Systematic risk analysis and mitigation planning
436: - Step-by-step architecture integration analysis
437: 
438: ### With Serena MCP
439: - Semantic code understanding for integration planning
440: - Real dependency analysis and impact assessment
441: - Symbol-level understanding of existing codebase
442: 
443: ### With Context7 MCP
444: - Automatic library documentation integration
445: - Framework-specific best practices
446: - Dependency-aware implementation guidance
447: 
448: ## Examples
449: 
450: ### Feature Exploration
451: ```bash
452: /explore "add real-time notifications"
453: # → Analyzes notification requirements, creates work unit, generates implementation plan
454: ```
455: 
456: ### Bug Investigation
457: ```bash
458: /explore "#123"
459: # → Loads GitHub issue, analyzes problem, creates debugging work unit
460: ```
461: 
462: ### Document-Based Planning
463: ```bash
464: /explore @project-spec.md
465: # → Analyzes specification document, creates comprehensive implementation plan
466: ```
467: 
468: ### Codebase Discovery
469: ```bash
470: /explore
471: # → General codebase exploration, identifies improvement opportunities
472: ```
473: 
474: ---
475: 
476: *First step in the structured development workflow, providing comprehensive requirement analysis and intelligent planning integration.*
````

## File: plugins/workflow/commands/next.md
````markdown
  1: ---
  2: allowed-tools: [Task, Bash, Read, Write, MultiEdit, Grep, Glob, TodoWrite]
  3: argument-hint: "[--task TASK-ID | --preview | --status]"
  4: description: "Execute the next available task from the implementation plan"
  5: @import .claude/memory/conventions.md
  6: @import .claude/memory/lessons_learned.md
  7: @import .claude/memory/project_state.md
  8: ---
  9: 
 10: # Task Execution
 11: 
 12: I'll execute the next available task from your implementation plan, ensuring quality and updating progress.
 13: 
 14: **Input**: $ARGUMENTS
 15: 
 16: ## Implementation
 17: 
 18: ```bash
 19: #!/bin/bash
 20: 
 21: # Standard constants (must be copied to each command)
 22: readonly CLAUDE_DIR=".claude"
 23: readonly WORK_DIR="${CLAUDE_DIR}/work"
 24: readonly WORK_CURRENT="${WORK_DIR}/current"
 25: 
 26: # Error handling functions (must be copied to each command)
 27: error_exit() {
 28:     echo "ERROR: $1" >&2
 29:     exit 1
 30: }
 31: 
 32: warn() {
 33:     echo "WARNING: $1" >&2
 34: }
 35: 
 36: debug() {
 37:     [ "${DEBUG:-false}" = "true" ] && echo "DEBUG: $1" >&2
 38: }
 39: 
 40: # Check required tools
 41: require_tool() {
 42:     local tool="$1"
 43:     if ! command -v "$tool" >/dev/null 2>&1; then
 44:         error_exit "$tool is required but not installed"
 45:     fi
 46: }
 47: 
 48: # Parse arguments
 49: MODE="execute"
 50: TASK_ID=""
 51: 
 52: if [[ "$ARGUMENTS" == *"--preview"* ]]; then
 53:     MODE="preview"
 54: elif [[ "$ARGUMENTS" == *"--status"* ]]; then
 55:     MODE="status"
 56: elif [[ "$ARGUMENTS" =~ --task[[:space:]]+([A-Z0-9-]+) ]]; then
 57:     TASK_ID="${BASH_REMATCH[1]}"
 58: fi
 59: 
 60: echo "🚀 Task Execution"
 61: echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
 62: echo ""
 63: 
 64: # Check for active work unit
 65: if [ ! -f "${WORK_DIR}/ACTIVE_WORK" ]; then
 66:     error_exit "No active work unit found. Run /explore or /work continue first."
 67: fi
 68: 
 69: ACTIVE_WORK=$(cat "${WORK_DIR}/ACTIVE_WORK" 2>/dev/null || echo "")
 70: if [ -z "$ACTIVE_WORK" ]; then
 71:     error_exit "Active work unit is empty"
 72: fi
 73: 
 74: WORK_UNIT_DIR="${WORK_CURRENT}/${ACTIVE_WORK}"
 75: if [ ! -d "$WORK_UNIT_DIR" ]; then
 76:     error_exit "Work unit directory not found: $WORK_UNIT_DIR"
 77: fi
 78: 
 79: # Check for state.json
 80: STATE_FILE="${WORK_UNIT_DIR}/state.json"
 81: if [ ! -f "$STATE_FILE" ]; then
 82:     error_exit "No state.json found. Run /plan first to create task breakdown."
 83: fi
 84: 
 85: # Verify jq is available for JSON parsing
 86: if ! command -v jq >/dev/null 2>&1; then
 87:     warn "jq not installed - some features may be limited"
 88:     # Fallback to basic grep/sed parsing if needed
 89: fi
 90: 
 91: echo "📁 Active Work Unit: $ACTIVE_WORK"
 92: 
 93: # Check work unit status
 94: if command -v jq >/dev/null 2>&1; then
 95:     STATUS=$(jq -r '.status // "unknown"' "$STATE_FILE" 2>/dev/null || echo "unknown")
 96:     CURRENT_TASK=$(jq -r '.current_task // null' "$STATE_FILE" 2>/dev/null || echo "null")
 97: 
 98:     if [ "$STATUS" != "planning_complete" ] && [ "$STATUS" != "implementing" ]; then
 99:         error_exit "Work unit status is '$STATUS'. Expected 'planning_complete' or 'implementing'."
100:     fi
101: 
102:     echo "📊 Status: $STATUS"
103:     if [ "$CURRENT_TASK" != "null" ] && [ -n "$CURRENT_TASK" ]; then
104:         echo "⏳ Current Task: $CURRENT_TASK"
105:     fi
106: fi
107: 
108: echo ""
109: 
110: case "$MODE" in
111:     preview)
112:         echo "📋 Available Tasks"
113:         echo "──────────────────"
114:         if command -v jq >/dev/null 2>&1; then
115:             jq -r '.tasks[]? | "\(.id) - \(.title) [\(.status)]"' "$STATE_FILE" 2>/dev/null || echo "Unable to parse tasks"
116:         else
117:             echo "Install jq for better task display"
118:         fi
119:         ;;
120: 
121:     status)
122:         echo "📊 Task Progress"
123:         echo "────────────────"
124:         if command -v jq >/dev/null 2>&1; then
125:             TOTAL=$(jq '.tasks | length' "$STATE_FILE" 2>/dev/null || echo "0")
126:             COMPLETED=$(jq '[.tasks[]? | select(.status == "completed")] | length' "$STATE_FILE" 2>/dev/null || echo "0")
127:             IN_PROGRESS=$(jq '[.tasks[]? | select(.status == "in_progress")] | length' "$STATE_FILE" 2>/dev/null || echo "0")
128:             PENDING=$(jq '[.tasks[]? | select(.status == "pending")] | length' "$STATE_FILE" 2>/dev/null || echo "0")
129: 
130:             echo "Total Tasks: $TOTAL"
131:             echo "✅ Completed: $COMPLETED"
132:             echo "🔄 In Progress: $IN_PROGRESS"
133:             echo "⏳ Pending: $PENDING"
134: 
135:             if [ $TOTAL -gt 0 ]; then
136:                 PERCENT=$((COMPLETED * 100 / TOTAL))
137:                 echo ""
138:                 echo "Progress: ${PERCENT}%"
139:             fi
140:         else
141:             echo "Install jq for task status display"
142:         fi
143:         ;;
144: 
145:     execute)
146:         echo "🎯 Selecting next task..."
147:         # Task selection logic would go here
148:         # This is a simplified version - actual implementation would use jq to find next available task
149:         ;;
150: esac
151: ```
152: 
153: ## Usage
154: 
155: ```bash
156: /next                    # Execute next available task
157: /next --preview          # Show available tasks without executing
158: /next --task TASK-003    # Execute specific task
159: /next --status           # Show current task progress
160: ```
161: 
162: ## Phase 1: Load Work Context and Validate State
163: 
164: I'll check the work environment before proceeding:
165: 
166: 1. **Verify `.claude` directory exists** - Ensure we're in a Claude Code project
167: 2. **Check for active work unit** - Look for `.claude/work/current/ACTIVE_WORK`
168: 3. **Validate state file** - Ensure `state.json` exists and contains tasks
169: 4. **Confirm readiness** - Work unit must be in `planning_complete` or `in_progress` status
170: 
171: If any validation fails, I'll provide clear error messages and guidance on how to proceed.
172: 
173: ### Work Unit Context Loading
174: I'll load the current work context to understand the project state:
175: 
176: 1. **Find Active Work Unit**: Look for `.claude/work/current/ACTIVE_WORK` and associated work unit directory
177: 2. **Load Work Metadata**: Read `metadata.json` to understand work unit phase and status
178: 3. **Validate State File**: Ensure `state.json` exists and contains valid task breakdown
179: 4. **Check Phase Readiness**: Verify work unit is in a phase that allows task execution
180: 
181: ### State Validation Requirements
182: - Work unit must be in `implementing` or `planning_complete` phase
183: - Valid `state.json` with task definitions and dependencies
184: - No corrupted metadata or state files
185: - Previous work should be committed to git
186: 
187: ## Phase 2: Task Selection and Analysis
188: 
189: ### Task Selection Strategy
190: I'll identify the next task to execute using this priority order:
191: 
192: 1. **Resume In-Progress Task**: If a task is currently marked as `in_progress`
193: 2. **High-Priority Available Tasks**: Tasks with all dependencies satisfied, ordered by priority
194: 3. **Critical Path Tasks**: Tasks that unblock the most other work
195: 4. **Parallel Opportunities**: Independent tasks that can be done concurrently
196: 
197: ### Task Information Analysis
198: For the selected task, I'll analyze:
199: 
200: - **Task Type**: feature, bug, refactor, test, or documentation
201: - **Dependencies**: Verify all prerequisite tasks are completed
202: - **Acceptance Criteria**: Understand what constitutes task completion
203: - **Integration Points**: Identify how this task connects to other work
204: - **Estimated Effort**: Review time estimates and complexity assessment
205: 
206: ### Task Display Format
207: ```
208: ## Selected Task: TASK-XXX
209: 
210: **Title**: [Descriptive task title]
211: **Type**: feature|bug|refactor|test|docs
212: **Description**: [What needs to be accomplished]
213: **Dependencies**: [List of completed prerequisite tasks]
214: **Estimated Time**: X hours
215: **Priority**: High|Medium|Low
216: 
217: ### Acceptance Criteria
218: - [ ] [Specific criterion 1]
219: - [ ] [Specific criterion 2]
220: - [ ] [Specific criterion 3]
221: ```
222: 
223: ## Phase 3: Pre-Execution Validation
224: 
225: ### Environment Readiness Checks
226: Before starting task execution:
227: 
228: 1. **Dependency Verification**: Confirm all dependent tasks are truly complete
229: 2. **Git Status Check**: Ensure working directory is clean or changes are committed
230: 3. **Tool Availability**: Verify required development tools are available
231: 4. **Context Preparation**: Load necessary project context and documentation
232: 
233: ### Quality Gate: Pre-Start
234: - ✅ All task dependencies satisfied
235: - ✅ Development environment ready
236: - ✅ Previous work properly committed
237: - ✅ Clean working directory state
238: - ✅ Required tools accessible
239: 
240: ## Phase 4: Task Execution
241: 
242: ### Execution Strategy by Task Type
243: 
244: #### Feature Development Tasks
245: 1. **Test-Driven Development**: Write failing tests first that define the feature
246: 2. **Minimal Implementation**: Implement just enough to make tests pass
247: 3. **Refactoring**: Improve code quality while keeping tests green
248: 4. **Integration**: Ensure feature integrates properly with existing code
249: 5. **Documentation**: Update relevant documentation and examples
250: 
251: #### Bug Fix Tasks
252: 1. **Issue Reproduction**: Create reliable reproduction steps for the bug
253: 2. **Test Creation**: Write tests that fail due to the bug
254: 3. **Root Cause Analysis**: Identify the underlying cause of the issue
255: 4. **Fix Implementation**: Apply minimal fix that resolves the root cause
256: 5. **Regression Prevention**: Ensure fix doesn't break other functionality
257: 
258: #### Refactoring Tasks
259: 1. **Test Coverage Verification**: Ensure adequate tests exist before refactoring
260: 2. **Incremental Changes**: Make small, safe changes while maintaining functionality
261: 3. **Test Validation**: Run tests frequently to catch any breaking changes
262: 4. **Quality Improvement**: Improve code clarity, performance, or maintainability
263: 5. **Documentation Updates**: Update any documentation affected by changes
264: 
265: #### Testing Tasks
266: For comprehensive test creation, leverage test-engineer agent:
267: 
268: **Agent Invocation Parameters**:
269: - **subagent_type**: test-engineer
270: - **description**: Create comprehensive test suite for [component]
271: - **prompt**: Develop thorough testing including:
272:   - Unit tests with edge cases and boundary conditions
273:   - Integration tests for component interactions
274:   - Test data fixtures and mock setups
275:   - Performance benchmarks where applicable
276:   - Coverage analysis and gap identification
277: 
278: #### Documentation Tasks
279: 1. **Content Analysis**: Review what documentation needs creation or updates
280: 2. **Accuracy Verification**: Ensure documentation matches current implementation
281: 3. **Example Creation**: Develop practical usage examples and tutorials
282: 4. **Integration Updates**: Update README, API docs, and setup instructions
283: 5. **Quality Review**: Verify documentation is clear and helpful
284: 
285: ## Phase 5: Continuous Quality Validation
286: 
287: ### During Execution
288: Throughout task execution, maintain quality through:
289: 
290: - **API Verification First**: Use Serena to verify APIs BEFORE writing code
291:   - `get_symbols_overview()` to understand available methods
292:   - `find_symbol()` to get exact signatures
293:   - Never call methods you haven't verified exist
294: - **Frequent Testing**: Run relevant test suites after each significant change
295: - **Code Quality Checks**: Ensure linting and formatting standards are maintained
296: - **Type Safety**: Verify type annotations and type checking (where applicable)
297: - **Security Scanning**: Check for potential security vulnerabilities
298: - **Performance Monitoring**: Ensure changes don't negatively impact performance
299: 
300: ### Enhanced Validation (with MCP Tools)
301: 
302: #### Sequential Thinking Validation
303: When complex reasoning is needed, use structured analysis to:
304: - Systematically verify each acceptance criterion
305: - Analyze potential edge cases and failure modes
306: - Evaluate integration points and dependencies
307: - Plan testing strategies for complex functionality
308: 
309: #### Semantic Code Analysis (with Serena MCP)
310: When Serena is available, enhance validation with:
311: - Symbol-level impact analysis to understand affected code
312: - Dependency tracking to identify integration risks
313: - Type flow analysis to catch type-related issues
314: - API surface validation for public interface changes
315: 
316: ## Phase 6: Post-Execution Validation and State Updates
317: 
318: ### Quality Gate: Post-Execution
319: - ✅ All acceptance criteria met and verified
320: - ✅ Test suite passes completely
321: - ✅ Code quality checks pass (linting, formatting, types)
322: - ✅ Documentation updated appropriately
323: - ✅ Changes committed with descriptive messages
324: - ✅ Integration verified with existing codebase
325: 
326: ### State Management Updates
327: After successful task completion:
328: 
329: 1. **Update Task Status**: Mark task as completed in `state.json`
330: 2. **Record Completion Time**: Log actual time spent vs. estimate
331: 3. **Document Deliverables**: Record files changed and output produced
332: 4. **Update Dependencies**: Mark any newly available tasks
333: 5. **Archive Task Summary**: Create completion summary in work unit
334: 
335: ### Progress Tracking
336: Using TodoWrite tool to maintain visible progress:
337: - Mark current task as completed
338: - Update overall work unit progress percentage
339: - Identify next available tasks
340: - Show critical path status
341: 
342: ## Phase 7: Automated Git Integration
343: 
344: ### Commit Strategy
345: For each completed task:
346: 
347: 1. **Stage Relevant Changes**: Add files modified during task execution
348: 2. **Generate Commit Message**: Create descriptive conventional commit message
349: 3. **Include Task Reference**: Link commit to specific task ID
350: 4. **Quality Attribution**: Include Claude Code attribution in commit
351: 5. **Verify Commit**: Ensure commit succeeds and meets quality standards
352: 
353: ### Commit Message Format
354: ```
355: feat: Complete TASK-XXX - [Task Title]
356: 
357: Acceptance criteria met:
358: - [Criterion 1] ✅
359: - [Criterion 2] ✅
360: - [Criterion 3] ✅
361: 
362: Files modified: [list of key files]
363: Tests: [new tests or test status]
364: 
365: 🤖 Generated with [Claude Code](https://claude.ai/code)
366: 
367: Co-Authored-By: Claude <noreply@anthropic.com>
368: ```
369: 
370: ## Phase 8: Work Unit Health and Next Steps
371: 
372: ### Health Monitoring
373: After each task completion:
374: 
375: 1. **Work Unit Integrity**: Validate work unit structure and metadata
376: 2. **State Consistency**: Ensure task states and dependencies are logical
377: 3. **Progress Accuracy**: Verify progress calculations reflect reality
378: 4. **Context Health**: Check session memory and import links
379: 
380: ### Next Action Recommendations
381: Based on completion, provide clear guidance:
382: 
383: #### More Tasks Available
384: ```
385: 🎯 NEXT STEPS
386: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
387: ✅ Task TASK-XXX completed successfully
388: 📊 Progress: X/Y tasks complete (Z%)
389: → Run `/next` again to continue with next task
390: → Next available: [TASK-YYY - Description]
391: ```
392: 
393: #### All Tasks Complete
394: ```
395: 🎉 WORK UNIT COMPLETED
396: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
397: ✅ All tasks completed successfully!
398: 📊 Final progress: Y/Y tasks complete (100%)
399: → Run `/ship` to finalize and deliver work
400: → Consider running `/review` for final quality check
401: ```
402: 
403: #### Blocked Tasks Detected
404: ```
405: ⚠️ ATTENTION NEEDED
406: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
407: ✅ Task TASK-XXX completed
408: ⚠️ Remaining tasks are blocked by: [dependency/issue]
409: → Resolve blocker: [specific action needed]
410: → Then run `/next` to continue
411: ```
412: 
413: ## Command Options
414: 
415: ### Preview Mode (`--preview`)
416: Shows available tasks and their status without executing:
417: - List all tasks with current status
418: - Show dependency relationships
419: - Estimate remaining effort
420: - Identify any blockers
421: 
422: ### Specific Task (`--task TASK-ID`)
423: Execute a specific task if dependencies are satisfied:
424: - Validate task exists and is available
425: - Check all prerequisites are met
426: - Execute specified task directly
427: - Useful for parallel development
428: 
429: ### Status Check (`--status`)
430: Display current progress and work unit health:
431: - Show overall progress percentage
432: - List recent completions
433: - Identify current task in progress
434: - Display next available tasks
435: 
436: ## Success Indicators
437: 
438: Task execution is successful when:
439: - ✅ Task selected based on dependencies and priority
440: - ✅ All acceptance criteria met and verified
441: - ✅ Quality gates passed (tests, linting, documentation)
442: - ✅ Changes automatically committed with proper attribution
443: - ✅ Work unit state accurately updated
444: - ✅ Progress tracking maintained
445: - ✅ Clear next steps provided
446: 
447: ## Error Handling
448: 
449: When task execution encounters issues:
450: 
451: 1. **Document the Problem**: Capture error details and context
452: 2. **Preserve Progress**: Save any partially completed work
453: 3. **Mark Task Appropriately**: Set status to blocked or in-progress as appropriate
454: 4. **Identify Resolution Path**: Suggest specific steps to resolve the issue
455: 5. **Update State Safely**: Ensure work unit remains in valid state
456: 
457: ## Integration Benefits
458: 
459: - **MCP Enhancement**: Leverages Sequential Thinking and Serena for complex tasks
460: - **Quality Automation**: Automated testing, linting, and formatting checks
461: - **Progress Transparency**: Clear visibility into work completion and next steps
462: - **Git Integration**: Seamless version control with meaningful commit history
463: - **Context Preservation**: Maintains work unit context across task executions
464: 
465: ---
466: 
467: *Systematic task execution maintaining quality standards and clear progress tracking throughout implementation workflows.*
````

## File: plugins/workflow/commands/plan.md
````markdown
  1: ---
  2: allowed-tools: [Task, Bash, Read, Write, Grep, MultiEdit, mcp__sequential-thinking__sequentialthinking]
  3: argument-hint: "[--from-requirements | --from-issue #123 | description]"
  4: description: "Create detailed implementation plan with ordered tasks and dependencies using structured reasoning"
  5: @import .claude/memory/decisions.md
  6: @import .claude/memory/lessons_learned.md
  7: @import .claude/memory/project_state.md
  8: ---
  9: 
 10: # Implementation Planning
 11: 
 12: I'll create a comprehensive implementation plan from your requirements, breaking down the work into manageable, ordered tasks.
 13: 
 14: **Input**: $ARGUMENTS
 15: 
 16: ## Performance Monitoring Setup
 17: 
 18: I'll initialize performance tracking for this planning session:
 19: 
 20: ```bash
 21: # Initialize session performance tracking
 22: PLAN_START_TIME=$(date +%s)
 23: PLAN_SESSION_ID="plan_$(date +%s)_$$"
 24: 
 25: # Performance monitoring setup (optional)
 26: if command -v npx >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
 27:     echo "📊 Performance monitoring available"
 28: 
 29:     # Optional: Track baseline usage
 30:     BASELINE_TOKENS=$(npx ccusage@latest session --since $(date -d "-1 hour" +%Y%m%dT%H) --json 2>/dev/null | jq '.sessions[-1].total_tokens // 0' 2>/dev/null || echo "0")
 31: 
 32:     if [ "$BASELINE_TOKENS" != "0" ]; then
 33:         echo "📈 Session baseline: $BASELINE_TOKENS tokens"
 34:     fi
 35: else
 36:     echo "📝 Running without performance monitoring (tools not available)"
 37: fi
 38: ```
 39: 
 40: ## Phase 1: Understand Planning Context
 41: 
 42: I'll validate the planning environment before creating the implementation plan:
 43: 
 44: 1. **Check project setup** - Verify `.claude` directory and structure exist
 45: 2. **Find active work unit** - Look for work unit with completed exploration
 46: 3. **Validate requirements** - Ensure `requirements.md` exists and has content
 47: 4. **Check planning status** - Warn if overwriting existing plan
 48: 
 49: If any validation fails, I'll provide clear guidance on what needs to be completed first.
 50: 
 51: Based on the provided arguments: $ARGUMENTS
 52: 
 53: I'll determine the planning approach and source material:
 54: 
 55: - **From Requirements**: Use existing requirements documentation
 56: - **From GitHub Issue**: Plan implementation for specific issue (#123)
 57: - **From Description**: Create plan from provided description
 58: - **Continuing Work**: Plan for active work unit
 59: 
 60: ### Planning Prerequisites
 61: 
 62: Before creating an implementation plan, I'll verify:
 63: 1. **Requirements clarity**: Clear understanding of what needs to be built
 64: 2. **Work unit context**: Active work unit with exploration complete
 65: 3. **Technical constraints**: Understanding of platform, tools, dependencies
 66: 4. **Quality standards**: Testing, documentation, and delivery requirements
 67: 
 68: ## Phase 2: Requirements Analysis and Task Decomposition
 69: 
 70: ### Requirements Processing
 71: 
 72: I'll analyze the requirements to identify:
 73: - **Core functionality**: Primary features and capabilities needed
 74: - **Quality requirements**: Performance, security, reliability needs
 75: - **Integration points**: External systems, APIs, dependencies
 76: - **User experience**: Interface requirements, usability considerations
 77: - **Technical constraints**: Platform limits, technology choices
 78: 
 79: ### Enhanced Analysis with Sequential Thinking
 80: 
 81: For complex planning scenarios, I'll use Sequential Thinking to ensure systematic coverage:
 82: 
 83: **When to use Sequential Thinking**:
 84: - Multi-dimensional planning problems
 85: - Complex architectural decisions
 86: - Risk analysis and mitigation planning
 87: - Large-scale system design
 88: - Integration challenges with multiple dependencies
 89: 
 90: **Sequential Thinking Benefits**:
 91: - Structured reasoning through interconnected factors
 92: - Comprehensive coverage of edge cases and dependencies
 93: - Clear documentation of decision-making process
 94: - Reduced risk of overlooking critical considerations
 95: 
 96: If the planning task involves significant complexity, I'll engage Sequential Thinking to work through the analysis systematically, ensuring all aspects are properly considered and documented.
 97: 
 98: **Graceful Degradation**: When Sequential Thinking MCP is unavailable, I'll use standard analytical approaches while maintaining comprehensive planning quality. The tool enhances the process but isn't required for effective planning.
 99: 
100: ### Task Breakdown Strategy
101: 
102: I'll decompose the work using these principles:
103: 
104: #### Task Sizing Guidelines
105: - **2-4 hours per task**: Focused, completable units of work
106: - **Single responsibility**: Each task has one clear objective
107: - **Testable outcomes**: Clear success criteria for each task
108: - **Incremental value**: Each task produces working functionality
109: - **API verification**: Confirm APIs exist before planning their use
110: 
111: #### Task Categories
112: - **Foundation**: Project setup, infrastructure, core architecture
113: - **Features**: User-facing functionality and business logic
114: - **Integration**: External system connections and APIs
115: - **Testing**: Test implementation and quality assurance
116: - **Documentation**: User guides, API docs, deployment instructions
117: 
118: ## Phase 3: Dependency Analysis and Sequencing
119: 
120: ### Dependency Mapping
121: 
122: I'll create a logical task sequence ensuring:
123: - **Prerequisites completed first**: Foundation before features
124: - **No circular dependencies**: Clear directed acyclic graph
125: - **Parallel opportunities**: Independent tasks identified
126: - **Critical path optimization**: Shortest path to working system
127: 
128: ### Task Relationships
129: - **Sequential Dependencies**: Task B requires Task A completion
130: - **Parallel Opportunities**: Tasks that can be worked simultaneously
131: - **Optional Extensions**: Nice-to-have features that don't block delivery
132: - **Risk Mitigations**: Alternatives if high-risk tasks fail
133: 
134: ## Phase 4: Create Implementation Plan
135: 
136: ### State Management Setup
137: 
138: I'll create structured state tracking in `.claude/work/current/[work-unit]/`:
139: 
140: #### state.json Structure
141: ```json
142: {
143:   "project": {
144:     "name": "Project Name",
145:     "description": "Clear project description",
146:     "created_at": "2025-01-24T10:00:00Z",
147:     "updated_at": "2025-01-24T10:00:00Z"
148:   },
149:   "status": "planning_complete",
150:   "current_task": null,
151:   "tasks": [
152:     {
153:       "id": "TASK-001",
154:       "title": "Setup project foundation",
155:       "description": "Create project structure, configure tools, setup development environment",
156:       "type": "foundation",
157:       "status": "pending",
158:       "dependencies": [],
159:       "acceptance_criteria": [
160:         "Project directory structure created",
161:         "Configuration files in place",
162:         "Development tools configured",
163:         "Initial tests passing"
164:       ],
165:       "estimated_hours": 3,
166:       "priority": "high"
167:     }
168:   ],
169:   "completed_tasks": [],
170:   "next_available": ["TASK-001"]
171: }
172: ```
173: 
174: ### Implementation Plan Document
175: 
176: I'll create a comprehensive plan document (`implementation-plan.md`) containing:
177: 
178: #### Project Overview
179: - **Objective**: What we're building and why
180: - **Scope**: What's included and excluded
181: - **Success criteria**: How we know we're done
182: - **Timeline estimate**: Total effort and critical milestones
183: 
184: #### Technical Architecture
185: - **Technology stack**: Languages, frameworks, tools chosen
186: - **Architecture patterns**: Design approaches and principles
187: - **Integration points**: External systems and dependencies
188: - **Data models**: Key entities and relationships
189: 
190: #### Task Execution Plan
191: - **Phase breakdown**: Logical groupings of related tasks
192: - **Critical path**: Minimum viable sequence to working system
193: - **Parallel tracks**: Independent work streams
194: - **Risk mitigation**: Contingency plans for high-risk elements
195: 
196: #### Quality Assurance Strategy
197: - **Testing approach**: Unit, integration, end-to-end testing
198: - **Code quality**: Linting, formatting, review standards
199: - **Documentation**: API docs, user guides, deployment instructions
200: - **Performance**: Benchmarks and optimization targets
201: 
202: ## Phase 5: Enhanced Planning with Specialist Agent Guidance
203: 
204: ### Agent Selection for Task Types
205: 
206: Based on the task breakdown, I'll suggest appropriate specialist agents for specific types of work:
207: 
208: #### 🏗️ Architecture & Design Tasks → **architect** agent
209: **Suggest when tasks involve**:
210: - System architecture decisions
211: - Technology stack choices
212: - Integration design
213: - Performance architecture
214: - Scalability planning
215: 
216: **Example suggestion**: *"TASK-002 involves complex microservices design. Consider using `/agent architect` for architectural guidance."*
217: 
218: #### 🧪 Testing & Quality Tasks → **test-engineer** agent
219: **Suggest when tasks involve**:
220: - Test strategy development
221: - Coverage analysis
222: - TDD implementation
223: - Performance testing
224: - Test automation setup
225: 
226: **Example suggestion**: *"TASK-005 requires comprehensive test coverage. Recommend `/agent test-engineer` for testing strategy."*
227: 
228: #### 🔍 Code Review & Security Tasks → **code-reviewer** agent
229: **Suggest when tasks involve**:
230: - Security analysis
231: - Code quality review
232: - Performance optimization
233: - Refactoring guidance
234: - Best practices validation
235: 
236: **Example suggestion**: *"TASK-007 handles authentication logic. Suggest `/agent code-reviewer` for security review."*
237: 
238: #### 📋 Framework & Compliance Tasks → **auditor** agent
239: **Suggest when tasks involve**:
240: - Framework compliance
241: - Setup validation
242: - Standards enforcement
243: - Configuration review
244: - Best practices audit
245: 
246: **Example suggestion**: *"TASK-001 sets up project structure. Consider `/agent auditor` for compliance validation."*
247: 
248: ### Natural Agent Integration
249: 
250: In the planning output, I'll include agent suggestions as helpful recommendations rather than requirements:
251: - Use natural language like "Consider using..." or "Recommend involving..."
252: - Explain why the agent would be beneficial for specific tasks
253: - Always note that agent use is optional and user can override
254: - Suggest agents based on task content and complexity, not rigid rules
255: 
256: ## Phase 6: Plan Validation and Finalization
257: 
258: ### Completeness Verification
259: 
260: I'll validate the plan ensures:
261: - **All requirements mapped**: Every requirement has corresponding tasks
262: - **Dependencies resolved**: No circular dependencies or missing prerequisites
263: - **Resource requirements**: Time estimates and skill requirements clear
264: - **Quality gates**: Testing and review checkpoints defined
265: - **Integration planned**: External dependencies and APIs addressed
266: 
267: ### Feasibility Assessment
268: 
269: I'll verify the plan is achievable by checking:
270: - **Technology maturity**: Chosen tools are stable and appropriate
271: - **Complexity management**: Tasks are properly scoped and sequenced
272: - **Resource availability**: Required skills and tools are accessible
273: - **Timeline realism**: Estimates account for complexity and dependencies
274: 
275: ### Plan Documentation
276: 
277: Final deliverables include:
278: 1. **state.json**: Machine-readable task definitions and dependencies
279: 2. **implementation-plan.md**: Human-readable comprehensive plan
280: 3. **task-details/**: Individual task specifications with acceptance criteria
281: 4. **risk-assessment.md**: Identified risks and mitigation strategies
282: 
283: ## Phase 7: Work Unit Transition
284: 
285: After creating the implementation plan, I'll:
286: 
287: ### Update Work Unit Metadata
288: - **Phase transition**: Move from "exploring" to "planning_complete"
289: - **Task count**: Record number of tasks created
290: - **Effort estimate**: Total estimated hours for completion
291: - **Next actions**: Clear guidance for starting implementation
292: 
293: ### Session Memory Update
294: - **Planning decisions**: Key architectural and technical choices
295: - **Critical path**: Most important sequence of tasks
296: - **Risks identified**: Major challenges and mitigation strategies
297: - **Next session prep**: What context to load for implementation
298: 
299: ## Success Indicators
300: 
301: Implementation plan is complete when:
302: - ✅ All requirements have corresponding tasks
303: - ✅ Dependencies form valid directed acyclic graph
304: - ✅ Tasks are properly sized (2-4 hours each)
305: - ✅ Critical path identified and optimized
306: - ✅ Quality gates defined for each task
307: - ✅ Risk mitigation strategies documented
308: - ✅ Work unit ready for task execution
309: 
310: ## Performance Summary and Optimization
311: 
312: I'll conclude with performance analysis and optimization recommendations:
313: 
314: ```bash
315: # Calculate session performance metrics
316: PLAN_END_TIME=$(date +%s)
317: PLAN_DURATION=$((PLAN_END_TIME - PLAN_START_TIME))
318: 
319: if command -v npx >/dev/null 2>&1; then
320:     echo ""
321:     echo "📈 Planning Session Performance Report"
322:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
323: 
324:     # Get current session usage
325:     CURRENT_TOKENS=$(npx ccusage@latest session --since $(date -d "-1 hour" +%Y%m%dT%H) --json 2>/dev/null | jq '.sessions[-1].total_tokens // 0')
326:     SESSION_TOKENS=$((CURRENT_TOKENS - BASELINE_TOKENS))
327: 
328:     echo "⏱️ Planning Duration: ${PLAN_DURATION}s"
329:     echo "🎯 Tokens Used: $SESSION_TOKENS tokens"
330: 
331:     # Calculate efficiency metrics if dynamic context was used
332:     if [ -n "$DYNAMIC_CONTEXT_BUDGET" ]; then
333:         BUDGET_USAGE=$((SESSION_TOKENS * 100 / DYNAMIC_CONTEXT_BUDGET))
334:         echo "💰 Budget Utilization: ${BUDGET_USAGE}% of ${DYNAMIC_CONTEXT_BUDGET} allocated"
335: 
336:         # Monitor usage and provide alerts
337:         monitor_token_usage "$SESSION_TOKENS" "plan" 0
338: 
339:         # MCP tool effectiveness report
340:         if [[ "$DYNAMIC_CONTEXT_MCP_TOOLS" == *"sequential_thinking"* ]]; then
341:             echo "🧠 Sequential Thinking: Enhanced planning comprehensiveness"
342:         fi
343:     fi
344: 
345:     # ROI calculation for planning efficiency
346:     TYPICAL_PLANNING_TOKENS=8000  # Baseline for manual planning
347:     if [ $SESSION_TOKENS -lt $TYPICAL_PLANNING_TOKENS ]; then
348:         EFFICIENCY_GAIN=$(( (TYPICAL_PLANNING_TOKENS - SESSION_TOKENS) * 100 / TYPICAL_PLANNING_TOKENS ))
349:         echo "✅ Efficiency Gain: ${EFFICIENCY_GAIN}% token reduction vs baseline"
350:     fi
351: 
352:     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
353: fi
354: ```
355: 
356: ## Next Steps
357: 
358: After planning completion:
359: 1. **Review the plan**: Verify it meets requirements and expectations
360: 2. **Begin implementation**: Run `/next` to start first available task
361: 3. **Track progress**: Use `/status` to monitor task completion
362: 4. **Adapt as needed**: Adjust plan based on implementation discoveries
363: 
364: ### Performance Insights for Future Planning
365: - **Optimal Budget**: Planning operations typically need 20k tokens for comprehensive coverage
366: - **MCP Value**: Sequential Thinking provides systematic analysis with quality over efficiency focus
367: - **Context Efficiency**: Dynamic context system ensures relevant information loading within budget
368: - **Monitoring Benefits**: Real-time tracking enables optimization of planning workflows
369: 
370: ---
371: 
372: *This command transforms requirements into actionable, dependency-ordered implementation plans with integrated performance monitoring and optimization insights.*
````

## File: plugins/workflow/commands/ship.md
````markdown
  1: ---
  2: allowed-tools: [Task, Bash, Read, Write, MultiEdit, Grep, Glob]
  3: argument-hint: "[--preview | --pr | --commit | --deploy]"
  4: description: "Deliver completed work with validation and comprehensive documentation"
  5: @import .claude/memory/conventions.md
  6: @import .claude/memory/decisions.md
  7: @import .claude/memory/dependencies.md
  8: @import .claude/memory/lessons_learned.md
  9: @import .claude/memory/project_state.md
 10: ---
 11: 
 12: # Work Delivery
 13: 
 14: I'll validate, document, and deliver your completed work, ensuring everything meets quality standards.
 15: 
 16: **Options**: $ARGUMENTS
 17: 
 18: ## Phase 1: Delivery Readiness Assessment
 19: 
 20: I'll validate the work is ready for delivery before proceeding:
 21: 
 22: 1. **Check project setup** - Verify `.claude` directory and work unit structure
 23: 2. **Find active work unit** - Identify work unit to be shipped
 24: 3. **Validate completion** - Ensure all tasks are completed
 25: 4. **Check git status** - Verify changes are committed (if in git repo)
 26: 
 27: If validation fails, I'll provide specific guidance on what needs to be completed before shipping.
 28: 
 29: Based on the provided arguments: $ARGUMENTS
 30: 
 31: I'll determine the delivery approach and validation scope:
 32: 
 33: - **Preview Mode**: Show what would be delivered without making changes
 34: - **Pull Request**: Create PR with comprehensive documentation
 35: - **Direct Commit**: Commit work to current branch with proper messaging
 36: - **Deployment**: Prepare for production deployment
 37: 
 38: ### Work Completion Validation
 39: 
 40: Before proceeding with delivery, I'll verify:
 41: 1. **All tasks completed**: No pending or blocked tasks remain
 42: 2. **Quality gates passed**: Tests, coverage, linting all successful
 43: 3. **Documentation complete**: README, API docs, deployment guides current
 44: 4. **Integration ready**: Code compiles/builds successfully
 45: 5. **Dependencies resolved**: All external requirements satisfied
 46: 
 47: ## Phase 2: Quality Assurance Verification
 48: 
 49: ### Comprehensive Test Validation
 50: 
 51: I'll execute full quality validation including:
 52: 
 53: #### Test Suite Execution
 54: - **Unit Tests**: Complete test suite with coverage analysis
 55: - **Integration Tests**: Cross-component interaction validation
 56: - **End-to-End Tests**: Full user journey verification
 57: - **Performance Tests**: Load and stress testing (if applicable)
 58: 
 59: #### Code Quality Assessment
 60: - **Linting**: Code style and convention adherence
 61: - **Type Safety**: Static type checking validation
 62: - **Security Scanning**: Vulnerability assessment
 63: - **Dependency Audit**: Third-party library security review
 64: 
 65: #### Documentation Validation
 66: - **Completeness**: All features and APIs documented
 67: - **Accuracy**: Documentation matches implementation
 68: - **Usability**: Clear setup and usage instructions
 69: - **Maintenance**: Troubleshooting and deployment guides
 70: 
 71: ### Quality Gate Requirements
 72: 
 73: All must pass before delivery:
 74: - ✅ Test suite passes with >80% coverage
 75: - ✅ No critical linting errors or security vulnerabilities
 76: - ✅ Documentation complete and accurate
 77: - ✅ Build/compilation successful
 78: - ✅ Performance requirements met
 79: 
 80: ## Phase 3: Delivery Documentation Generation
 81: 
 82: ### Implementation Summary Creation
 83: 
 84: I'll generate comprehensive delivery documentation:
 85: 
 86: #### Project Overview Document
 87: **DELIVERY.md** containing:
 88: - **What was built**: Feature descriptions and capabilities
 89: - **Technical architecture**: System design and component overview
 90: - **Implementation approach**: Key technical decisions and patterns
 91: - **Quality metrics**: Test coverage, performance, security results
 92: 
 93: #### Change Documentation
 94: **CHANGELOG.md** with structured change tracking:
 95: - **Added features**: New functionality and capabilities
 96: - **Changed behavior**: Modified existing features
 97: - **Fixed issues**: Bug resolutions and improvements
 98: - **Security updates**: Vulnerability fixes and enhancements
 99: - **Performance improvements**: Optimization results
100: 
101: #### Deployment Instructions
102: **DEPLOYMENT.md** providing:
103: - **Prerequisites**: Required software, environment setup
104: - **Installation steps**: Detailed deployment procedure
105: - **Configuration**: Environment variables, settings, customization
106: - **Verification**: Health checks and validation procedures
107: - **Rollback plan**: Emergency recovery procedures
108: 
109: ### Technical Handoff Materials
110: 
111: I'll prepare comprehensive handoff documentation:
112: 
113: #### Developer Guide
114: - **Architecture overview**: System design and data flow
115: - **Code organization**: Directory structure and conventions
116: - **Development setup**: Local environment configuration
117: - **Testing strategy**: How to run and maintain tests
118: - **Debugging guide**: Common issues and troubleshooting
119: 
120: #### User Documentation
121: - **Feature guide**: How to use new functionality
122: - **API documentation**: Endpoints, parameters, examples
123: - **Configuration options**: Available settings and customization
124: - **Troubleshooting**: Common problems and solutions
125: 
126: ## Phase 4: Delivery Method Execution
127: 
128: ### Preview Mode Processing
129: 
130: When in preview mode, I'll:
131: 1. **Show validation results**: Quality checks without making changes
132: 2. **Display delivery plan**: What would be included in delivery
133: 3. **Highlight any issues**: Problems that need resolution
134: 4. **Provide recommendations**: Suggested next steps
135: 
136: ### Pull Request Creation
137: 
138: For PR delivery, I'll:
139: 1. **Generate PR description**: Comprehensive change summary
140: 2. **Include test results**: Coverage and quality metrics
141: 3. **Add deployment notes**: Special considerations for deployment
142: 4. **Link related issues**: Connect to original requirements
143: 
144: ### Direct Commit Delivery
145: 
146: For commit delivery, I'll:
147: 1. **Stage all changes**: Include all work-related modifications
148: 2. **Create meaningful commit**: Clear, conventional commit message
149: 3. **Include co-authorship**: Proper attribution to Claude Code
150: 4. **Verify commit success**: Ensure changes are properly recorded
151: 
152: ### Deployment Preparation
153: 
154: For production deployment, I'll:
155: 1. **Final validation**: Extra security and performance checks
156: 2. **Environment preparation**: Production-specific configuration
157: 3. **Rollback planning**: Detailed recovery procedures
158: 4. **Monitoring setup**: Health checks and alerting configuration
159: 
160: ## Phase 5: Memory Reflection and Learning Capture
161: 
162: ### Automated Work Unit Analysis
163: 
164: Before finalizing delivery, I'll analyze the work unit to identify valuable learnings:
165: 
166: #### Work Unit Review
167: I'll examine all work unit files to extract insights:
168: - **Read exploration.md**: Understand initial approach and discoveries
169: - **Read implementation-plan.md**: Review planned vs actual execution
170: - **Read validation reports**: Identify what worked well and what didn't
171: - **Read task summaries**: Extract specific learnings from each task
172: - **Review changed files**: Understand technical decisions made
173: 
174: #### Learning Categorization
175: I'll categorize findings into memory types:
176: 
177: **Decisions** (`.claude/memory/decisions.md`):
178: - Architectural choices made during implementation
179: - Technology selections and their rationale
180: - Design patterns adopted
181: - Trade-offs and their justification
182: 
183: **Lessons Learned** (`.claude/memory/lessons_learned.md`):
184: - What worked well and should be repeated
185: - What didn't work and should be avoided
186: - Unexpected challenges encountered
187: - Successful problem-solving approaches
188: 
189: **Conventions** (`.claude/memory/conventions.md`):
190: - New coding standards established
191: - Naming patterns adopted
192: - File organization decisions
193: - Documentation standards
194: 
195: **Dependencies** (`.claude/memory/dependencies.md`):
196: - New tools or libraries added
197: - Version requirements discovered
198: - Integration requirements learned
199: 
200: **Project State** (`.claude/memory/project_state.md`):
201: - Current architecture updates
202: - New capabilities added
203: - System state changes
204: 
205: ### Memory Update Prompt
206: 
207: After analyzing the work unit, I'll present findings and prompt for memory update:
208: 
209: ```
210: 🧠 Memory Reflection Analysis
211: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
212: 
213: Work unit analysis complete. Identified learnings:
214: 
215: 📋 DECISIONS (N items identified):
216: - [Decision 1]: [Brief description]
217: - [Decision 2]: [Brief description]
218: ...
219: 
220: 📚 LESSONS LEARNED (N items identified):
221: ✅ What Worked:
222: - [Lesson 1]: [Brief description]
223: - [Lesson 2]: [Brief description]
224: 
225: ❌ What NOT to Do:
226: - [Anti-pattern 1]: [Brief description]
227: - [Anti-pattern 2]: [Brief description]
228: 
229: 🔧 CONVENTIONS (N items identified):
230: - [Convention 1]: [Brief description]
231: ...
232: 
233: 📦 DEPENDENCIES (N items identified):
234: - [Dependency 1]: [Brief description]
235: ...
236: 
237: 🏗️ PROJECT STATE (N updates identified):
238: - [State update 1]: [Brief description]
239: ...
240: 
241: ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
242: 
243: 💡 RECOMMENDATION: Update memory to capture these learnings
244: 
245: Options:
246: 1. Run /memory-update to review and add selected learnings
247: 2. Skip if no memory updates needed (type 'skip')
248: 
249: Choice: _
250: ```
251: 
252: ### User Decision Handling
253: 
254: I'll handle the user's response:
255: 
256: **If user runs /memory-update**:
257: - Present findings in interactive format
258: - Allow selective addition to memory files
259: - Update timestamps on modified memory files
260: - Proceed with delivery
261: 
262: **If user types 'skip'**:
263: - Note that learnings were not captured
264: - Warn about potential knowledge loss
265: - Proceed with delivery anyway
266: 
267: **If no response / uncertainty**:
268: - Default to prompting for /memory-update
269: - Emphasize value of capturing learnings
270: - Offer to proceed without updates if user insists
271: 
272: ## Phase 6: Work Unit Management and Archival
273: 
274: ### Completion Recording
275: 
276: I'll properly record work completion:
277: 
278: #### State Finalization
279: - **Update work unit status**: Mark as completed with timestamp
280: - **Record delivery method**: How work was delivered (PR, commit, deploy)
281: - **Document final metrics**: Test coverage, performance, quality scores
282: - **Archive task details**: Complete task execution history
283: 
284: #### Session Memory Updates (if memory-update was run)
285: - **Project summary**: What was accomplished
286: - **Key decisions**: Important technical choices made (now in memory)
287: - **Lessons learned**: Insights for future work (now in memory)
288: - **Follow-up items**: Potential enhancements or maintenance needs
289: 
290: ### Work Unit Archival
291: 
292: For completed work units, I'll:
293: 1. **Create archive entry**: Move completed work to archive with timestamp
294: 2. **Generate summary**: Brief overview of what was accomplished
295: 3. **Preserve context**: Keep important decisions and documentation
296: 4. **Clean active workspace**: Remove completed work from active area
297: 
298: ## Phase 7: Quality Assurance with Agent Support
299: 
300: ### Code Review Validation
301: 
302: For critical deliveries, I'll invoke the code-reviewer agent:
303: 
304: **Agent Delegation**:
305: - **Purpose**: Final code quality and security review
306: - **Scope**: All modified and new code
307: - **Focus**: Security, performance, maintainability
308: - **Deliverables**: Review report with recommendations
309: 
310: ### Documentation Review
311: 
312: For client-facing deliveries, I'll invoke the doc-reviewer agent:
313: 
314: **Agent Delegation**:
315: - **Purpose**: Documentation quality and completeness review
316: - **Scope**: All user-facing documentation
317: - **Focus**: Clarity, completeness, accuracy
318: - **Deliverables**: Documentation quality report
319: 
320: ## Phase 8: Delivery Confirmation and Handoff
321: 
322: ### Delivery Verification
323: 
324: I'll confirm successful delivery by checking:
325: - **Integration success**: Code merged/committed without conflicts
326: - **Build success**: Continuous integration passes
327: - **Deployment readiness**: All prerequisites met
328: - **Documentation availability**: All docs accessible and current
329: 
330: ### Handoff Preparation
331: 
332: For team or client handoff, I'll prepare:
333: 
334: #### Knowledge Transfer Package
335: - **Technical overview**: Architecture and implementation details
336: - **Operational guide**: Running, monitoring, maintaining the system
337: - **Development guide**: How to extend and modify functionality
338: - **Support information**: Common issues and resolution procedures
339: 
340: #### Success Metrics
341: - **Functionality delivered**: All requirements met
342: - **Quality achieved**: Test coverage and performance targets
343: - **Documentation complete**: All guides and references ready
344: - **Team prepared**: Handoff materials reviewed and understood
345: 
346: ## Success Indicators
347: 
348: Delivery is successful when:
349: - ✅ All planned functionality implemented and tested
350: - ✅ Quality gates passed (tests, coverage, security, performance)
351: - ✅ Documentation complete and accurate
352: - ✅ Code integrated via chosen method (PR, commit, deploy)
353: - ✅ Work unit properly archived with context preserved
354: - ✅ Handoff materials prepared and delivered
355: - ✅ Team/client ready to take ownership
356: 
357: ## Post-Delivery Support
358: 
359: After successful delivery:
360: 1. **Monitor for issues**: Watch for deployment problems or user feedback
361: 2. **Document lessons learned**: Capture insights for future work
362: 3. **Plan maintenance**: Schedule follow-up reviews and updates
363: 4. **Prepare for enhancements**: Document potential future improvements
364: 
365: ---
366: 
367: *Professional work delivery ensuring quality, documentation, and smooth handoff for sustained success.*
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

## File: scripts/generate-commands-reference.py
````python
  1: #!/usr/bin/env python3
  2: """
  3: Generate commands reference documentation from plugin.json files.
  4: 
  5: Scans all plugins and creates a comprehensive commands reference
  6: with categorization, descriptions, and cross-references.
  7: """
  8: 
  9: import json
 10: import os
 11: from pathlib import Path
 12: from typing import Dict, List, Any
 13: from collections import defaultdict
 14: 
 15: # Configuration
 16: PLUGINS_DIR = Path(__file__).parent.parent / "plugins"
 17: OUTPUT_FILE = Path(__file__).parent.parent / "docs" / "reference" / "commands.md"
 18: 
 19: def load_plugin_manifest(plugin_path: Path) -> Dict[str, Any]:
 20:     """Load and parse plugin.json manifest."""
 21:     manifest_path = plugin_path / ".claude-plugin" / "plugin.json"
 22:     if not manifest_path.exists():
 23:         return None
 24:     
 25:     with open(manifest_path, 'r') as f:
 26:         return json.load(f)
 27: 
 28: def extract_commands_from_manifest(manifest: Dict[str, Any], plugin_name: str) -> List[Dict[str, Any]]:
 29:     """Extract command information from plugin manifest."""
 30:     commands = []
 31:     
 32:     # Get capabilities which describe commands
 33:     capabilities = manifest.get('capabilities', {})
 34:     
 35:     for cap_key, cap_data in capabilities.items():
 36:         if isinstance(cap_data, dict) and 'command' in cap_data:
 37:             cmd_name = cap_data['command']
 38:             commands.append({
 39:                 'name': cmd_name,
 40:                 'description': cap_data.get('description', ''),
 41:                 'plugin': plugin_name,
 42:                 'category': manifest.get('settings', {}).get('category', 'general'),
 43:                 'capability_key': cap_key
 44:             })
 45:     
 46:     return commands
 47: 
 48: def categorize_commands(commands: List[Dict[str, Any]]) -> Dict[str, List[Dict[str, Any]]]:
 49:     """Group commands by plugin for organization."""
 50:     categorized = defaultdict(list)
 51:     
 52:     for cmd in commands:
 53:         plugin_name = cmd['plugin']
 54:         categorized[plugin_name].append(cmd)
 55:     
 56:     return dict(categorized)
 57: 
 58: def generate_markdown(categorized_commands: Dict[str, List[Dict[str, Any]]], 
 59:                      plugin_info: Dict[str, Dict[str, Any]]) -> str:
 60:     """Generate markdown documentation from command data."""
 61:     
 62:     md = """# Commands Reference
 63: 
 64: Complete reference for all commands across Claude Code plugins.
 65: 
 66: ## Overview
 67: 
 68: This reference is auto-generated from plugin manifests and provides comprehensive
 69: documentation for all available commands organized by plugin.
 70: 
 71: **Total Commands**: {total_commands} across {total_plugins} plugins
 72: 
 73: ---
 74: 
 75: """.format(
 76:         total_commands=sum(len(cmds) for cmds in categorized_commands.values()),
 77:         total_plugins=len(categorized_commands)
 78:     )
 79:     
 80:     # Table of contents
 81:     md += "## Quick Navigation\n\n"
 82:     for plugin_name in sorted(categorized_commands.keys()):
 83:         info = plugin_info.get(plugin_name, {})
 84:         cmd_count = len(categorized_commands[plugin_name])
 85:         md += f"- [{plugin_name}](#{plugin_name.replace('-', '')}) ({cmd_count} commands) - {info.get('description', '')}\n"
 86:     
 87:     md += "\n---\n\n"
 88:     
 89:     # Detailed command documentation
 90:     for plugin_name in sorted(categorized_commands.keys()):
 91:         info = plugin_info.get(plugin_name, {})
 92:         commands = categorized_commands[plugin_name]
 93:         
 94:         md += f"## {plugin_name}\n\n"
 95:         md += f"**Description**: {info.get('description', 'No description available')}\n\n"
 96:         md += f"**Version**: {info.get('version', 'Unknown')}\n\n"
 97:         md += f"**Category**: {info.get('category', 'general')}\n\n"
 98:         
 99:         if info.get('repository'):
100:             repo_url = info['repository'].get('url', '')
101:             if repo_url:
102:                 md += f"**Source**: [{repo_url}]({repo_url}/tree/main/plugins/{plugin_name})\n\n"
103:         
104:         md += "### Commands\n\n"
105:         
106:         for cmd in sorted(commands, key=lambda x: x['name']):
107:             md += f"#### `/{cmd['name']}`\n\n"
108:             md += f"{cmd['description']}\n\n"
109:             md += f"**Plugin**: {plugin_name}\n\n"
110:             
111:             # Add link to plugin README for more details
112:             md += f"**More Info**: See [plugin README](../../plugins/{plugin_name}/README.md)\n\n"
113:             md += "---\n\n"
114:     
115:     # Footer
116:     md += """
117: ## Usage Notes
118: 
119: ### Command Syntax
120: 
121: All commands follow the slash command pattern:
122: ```bash
123: /command-name [arguments] [--flags]
124: ```
125: 
126: ### Getting Help
127: 
128: For detailed usage of any command:
129: - Refer to the plugin README for comprehensive examples
130: - Check command inline help (if available)
131: - Visit the [getting started guide](../getting-started/quick-start.md)
132: 
133: ### Plugin Management
134: 
135: To enable/disable plugins and their commands, see the [installation guide](../getting-started/installation.md).
136: 
137: ---
138: 
139: **Auto-generated**: This reference is automatically generated from plugin manifests.
140: **Last Updated**: {timestamp}
141: **Generator**: scripts/generate-commands-reference.py
142: """.format(timestamp=__import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S'))
143:     
144:     return md
145: 
146: def main():
147:     """Main execution function."""
148:     print("🔍 Scanning plugins...")
149:     
150:     # Find all plugin directories
151:     plugin_dirs = [d for d in PLUGINS_DIR.iterdir() if d.is_dir() and not d.name.startswith('.')]
152:     print(f"Found {len(plugin_dirs)} plugins")
153:     
154:     # Load all plugin manifests
155:     all_commands = []
156:     plugin_info = {}
157:     
158:     for plugin_dir in plugin_dirs:
159:         plugin_name = plugin_dir.name
160:         manifest = load_plugin_manifest(plugin_dir)
161:         
162:         if manifest is None:
163:             print(f"⚠️  Skipping {plugin_name} (no manifest)")
164:             continue
165:         
166:         print(f"✓ Processing {plugin_name}")
167:         
168:         # Store plugin info
169:         plugin_info[plugin_name] = {
170:             'name': manifest.get('name', plugin_name),
171:             'version': manifest.get('version', 'Unknown'),
172:             'description': manifest.get('description', ''),
173:             'category': manifest.get('settings', {}).get('category', 'general'),
174:             'repository': manifest.get('repository', {})
175:         }
176:         
177:         # Extract commands
178:         commands = extract_commands_from_manifest(manifest, plugin_name)
179:         all_commands.extend(commands)
180:         print(f"  Found {len(commands)} commands")
181:     
182:     print(f"\n📊 Total commands: {len(all_commands)}")
183:     
184:     # Categorize commands
185:     categorized = categorize_commands(all_commands)
186:     
187:     # Generate markdown
188:     print("\n📝 Generating markdown...")
189:     markdown = generate_markdown(categorized, plugin_info)
190:     
191:     # Ensure output directory exists
192:     OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
193:     
194:     # Write output
195:     with open(OUTPUT_FILE, 'w') as f:
196:         f.write(markdown)
197:     
198:     print(f"✅ Commands reference generated: {OUTPUT_FILE}")
199:     print(f"   {len(all_commands)} commands documented")
200:     print(f"   {len(categorized)} plugins covered")
201: 
202: if __name__ == '__main__':
203:     main()
````

## File: scripts/install.sh
````bash
 1: #!/bin/bash
 2: # Installation script for Claude Code Plugins
 3: # 🚧 Coming Soon: Full installation automation
 4: 
 5: set -e
 6: 
 7: echo "🚧 Installation script under development"
 8: echo ""
 9: echo "For now, please manually configure your project's .claude/settings.json:"
10: echo ""
11: echo "{"
12: echo "  \"extraKnownMarketplaces\": {"
13: echo "    \"aai-plugins\": {"
14: echo "      \"source\": {"
15: echo "        \"source\": \"directory\","
16: echo "        \"path\": \"$(pwd)/plugins\""
17: echo "      }"
18: echo "    }"
19: echo "  },"
20: echo "  \"enabledPlugins\": {"
21: echo "    \"core@aai-plugins\": true,"
22: echo "    \"workflow@aai-plugins\": true,"
23: echo "    \"development@aai-plugins\": true,"
24: echo "    \"git@aai-plugins\": true,"
25: echo "    \"memory@aai-plugins\": true"
26: echo "  }"
27: echo "}"
28: echo ""
29: echo "See docs/getting-started/installation.md for detailed instructions."
````

## File: scripts/sync-from-private.sh
````bash
  1: #!/usr/bin/env bash
  2: #
  3: # Sync plugins from private marketplace to public OSS repository
  4: #
  5: # Usage:
  6: #   ./scripts/sync-from-private.sh [plugin-name]
  7: #   ./scripts/sync-from-private.sh --all
  8: #   ./scripts/sync-from-private.sh --dry-run
  9: #
 10: # Examples:
 11: #   ./scripts/sync-from-private.sh core           # Sync only core plugin
 12: #   ./scripts/sync-from-private.sh --all          # Sync all OSS plugins
 13: #   ./scripts/sync-from-private.sh --dry-run      # Preview changes
 14: 
 15: set -euo pipefail
 16: 
 17: # Colors for output
 18: RED='\033[0;31m'
 19: GREEN='\033[0;32m'
 20: YELLOW='\033[1;33m'
 21: BLUE='\033[0;34m'
 22: NC='\033[0m' # No Color
 23: 
 24: # Directories
 25: PRIVATE_DIR="$HOME/agents/plugins"
 26: PUBLIC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
 27: PLUGINS_DIR="$PUBLIC_DIR/plugins"
 28: 
 29: # OSS plugins to sync (not private domain-specific ones)
 30: OSS_PLUGINS=(
 31:     "core"
 32:     "workflow"
 33:     "development"
 34:     "git"
 35:     "memory"
 36: )
 37: 
 38: # Repository URL for public OSS
 39: PUBLIC_REPO_URL="https://github.com/applied-artificial-intelligence/claude-code-plugins"
 40: 
 41: # Files/directories to exclude from sync
 42: EXCLUDE_PATTERNS=(
 43:     ".env"
 44:     ".env.*"
 45:     "secrets/"
 46:     "*.secret"
 47:     "*.key"
 48:     "credentials/"
 49:     "node_modules/"
 50:     "__pycache__/"
 51:     "*.pyc"
 52:     ".DS_Store"
 53: )
 54: 
 55: # Dry run mode
 56: DRY_RUN=false
 57: 
 58: # Functions
 59: print_header() {
 60:     echo -e "${BLUE}========================================${NC}"
 61:     echo -e "${BLUE}$1${NC}"
 62:     echo -e "${BLUE}========================================${NC}"
 63: }
 64: 
 65: print_success() {
 66:     echo -e "${GREEN}✓${NC} $1"
 67: }
 68: 
 69: print_warning() {
 70:     echo -e "${YELLOW}⚠${NC} $1"
 71: }
 72: 
 73: print_error() {
 74:     echo -e "${RED}✗${NC} $1"
 75: }
 76: 
 77: print_info() {
 78:     echo -e "${BLUE}ℹ${NC} $1"
 79: }
 80: 
 81: check_directories() {
 82:     if [ ! -d "$PRIVATE_DIR" ]; then
 83:         print_error "Private plugin directory not found: $PRIVATE_DIR"
 84:         exit 1
 85:     fi
 86: 
 87:     if [ ! -d "$PLUGINS_DIR" ]; then
 88:         print_warning "Public plugins directory not found, creating: $PLUGINS_DIR"
 89:         mkdir -p "$PLUGINS_DIR"
 90:     fi
 91: 
 92:     print_success "Directories verified"
 93: }
 94: 
 95: build_rsync_excludes() {
 96:     local excludes=""
 97:     for pattern in "${EXCLUDE_PATTERNS[@]}"; do
 98:         excludes="$excludes --exclude=$pattern"
 99:     done
100:     echo "$excludes"
101: }
102: 
103: sync_plugin() {
104:     local plugin_name="$1"
105:     local source_dir="$PRIVATE_DIR/$plugin_name"
106:     local dest_dir="$PLUGINS_DIR/$plugin_name"
107: 
108:     if [ ! -d "$source_dir" ]; then
109:         print_error "Plugin not found in private marketplace: $plugin_name"
110:         return 1
111:     fi
112: 
113:     print_info "Syncing $plugin_name..."
114: 
115:     # Build rsync exclude args
116:     local exclude_args=$(build_rsync_excludes)
117: 
118:     if [ "$DRY_RUN" = true ]; then
119:         print_info "DRY RUN: Would sync $source_dir → $dest_dir"
120:         rsync -av --dry-run $exclude_args "$source_dir/" "$dest_dir/" | grep -v "/$" | head -20
121:     else
122:         # Sync plugin files
123:         rsync -av $exclude_args "$source_dir/" "$dest_dir/"
124:         print_success "Files synced for $plugin_name"
125:     fi
126: 
127:     return 0
128: }
129: 
130: update_repository_url() {
131:     local plugin_name="$1"
132:     local plugin_json="$PLUGINS_DIR/$plugin_name/.claude-plugin/plugin.json"
133: 
134:     if [ ! -f "$plugin_json" ]; then
135:         print_warning "plugin.json not found for $plugin_name"
136:         return 1
137:     fi
138: 
139:     if [ "$DRY_RUN" = true ]; then
140:         print_info "DRY RUN: Would update repository URL in $plugin_json"
141:         return 0
142:     fi
143: 
144:     # Update repository URL to public OSS repo
145:     # Handle both "type":"git" and "type":"git" (with potential syntax errors)
146:     if grep -q '"url"' "$plugin_json"; then
147:         # Use sed to replace the URL
148:         sed -i.bak 's|"url": *"[^"]*"|"url": "'"$PUBLIC_REPO_URL"'"|g' "$plugin_json"
149: 
150:         # Also fix any potential "type":= syntax errors
151:         sed -i.bak 's|"type" *:= *"git"|"type": "git"|g' "$plugin_json"
152: 
153:         # Remove backup file
154:         rm -f "${plugin_json}.bak"
155: 
156:         print_success "Updated repository URL for $plugin_name"
157:     else
158:         print_warning "No repository URL found in $plugin_json"
159:     fi
160: 
161:     return 0
162: }
163: 
164: scan_for_private_refs() {
165:     local plugin_name="$1"
166:     local plugin_dir="$PLUGINS_DIR/$plugin_name"
167:     local found_issues=false
168: 
169:     print_info "Scanning $plugin_name for private references..."
170: 
171:     # Scan for Stefan-specific paths
172:     if grep -r "/home/stefan" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" > /dev/null; then
173:         print_warning "Found /home/stefan references in $plugin_name:"
174:         grep -r "/home/stefan" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" | head -5
175:         found_issues=true
176:     fi
177: 
178:     # Scan for ml4t/quant references (excluding READMEs which are generic examples)
179:     if grep -ri "~/ml4t\|/home/stefan/ml4t" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" > /dev/null; then
180:         print_warning "Found ML4T-specific paths in $plugin_name:"
181:         grep -ri "~/ml4t\|/home/stefan/ml4t" "$plugin_dir" 2>/dev/null | grep -v ".git" | grep -v "README.md" | head -5
182:         found_issues=true
183:     fi
184: 
185:     # Scan for private/secret file patterns
186:     if find "$plugin_dir" -name ".env" -o -name "*.secret" -o -name "*.key" 2>/dev/null | grep -v ".git" > /dev/null; then
187:         print_error "Found secret files in $plugin_name:"
188:         find "$plugin_dir" -name ".env" -o -name "*.secret" -o -name "*.key" 2>/dev/null | grep -v ".git"
189:         found_issues=true
190:     fi
191: 
192:     if [ "$found_issues" = false ]; then
193:         print_success "No private references found in $plugin_name"
194:     fi
195: 
196:     return 0
197: }
198: 
199: update_readme_catalog() {
200:     local readme="$PLUGINS_DIR/README.md"
201: 
202:     if [ ! -f "$readme" ]; then
203:         print_warning "plugins/README.md not found, skipping catalog update"
204:         return 0
205:     fi
206: 
207:     if [ "$DRY_RUN" = true ]; then
208:         print_info "DRY RUN: Would update $readme with current plugins"
209:         return 0
210:     fi
211: 
212:     print_info "Updating plugin catalog in README.md..."
213: 
214:     # Count is always the OSS plugins count
215:     local count=${#OSS_PLUGINS[@]}
216: 
217:     print_success "Catalog shows $count plugins (all OSS)"
218: 
219:     return 0
220: }
221: 
222: sync_all_plugins() {
223:     print_header "Syncing All OSS Plugins"
224: 
225:     local success_count=0
226:     local fail_count=0
227: 
228:     for plugin in "${OSS_PLUGINS[@]}"; do
229:         echo ""
230:         if sync_plugin "$plugin"; then
231:             update_repository_url "$plugin"
232:             scan_for_private_refs "$plugin"
233:             ((success_count++))
234:         else
235:             ((fail_count++))
236:         fi
237:     done
238: 
239:     echo ""
240:     update_readme_catalog
241: 
242:     echo ""
243:     print_header "Sync Summary"
244:     print_success "$success_count plugins synced successfully"
245:     if [ $fail_count -gt 0 ]; then
246:         print_error "$fail_count plugins failed to sync"
247:     fi
248: 
249:     if [ "$DRY_RUN" = false ]; then
250:         echo ""
251:         print_info "Next steps:"
252:         echo "  1. Review changes: git status"
253:         echo "  2. Test plugins: Enable in a test project"
254:         echo "  3. Commit: git add . && git commit"
255:         echo "  4. Push: git push origin main"
256:     fi
257: }
258: 
259: # Main
260: main() {
261:     # Parse arguments
262:     if [ $# -eq 0 ]; then
263:         echo "Usage: $0 [plugin-name|--all|--dry-run]"
264:         echo ""
265:         echo "Examples:"
266:         echo "  $0 core              # Sync only core plugin"
267:         echo "  $0 --all             # Sync all OSS plugins"
268:         echo "  $0 --dry-run --all   # Preview sync of all plugins"
269:         exit 1
270:     fi
271: 
272:     # Check for dry-run flag
273:     if [[ " $* " =~ " --dry-run " ]]; then
274:         DRY_RUN=true
275:         print_warning "DRY RUN MODE - No changes will be made"
276:         echo ""
277:     fi
278: 
279:     # Verify directories exist
280:     check_directories
281:     echo ""
282: 
283:     # Determine what to sync
284:     if [[ " $* " =~ " --all " ]]; then
285:         sync_all_plugins
286:     else
287:         # Sync single plugin
288:         local plugin_name="$1"
289: 
290:         # Verify it's an OSS plugin
291:         if [[ ! " ${OSS_PLUGINS[@]} " =~ " ${plugin_name} " ]]; then
292:             print_error "$plugin_name is not an OSS plugin"
293:             print_info "OSS plugins: ${OSS_PLUGINS[*]}"
294:             exit 1
295:         fi
296: 
297:         print_header "Syncing Plugin: $plugin_name"
298:         echo ""
299: 
300:         sync_plugin "$plugin_name"
301:         update_repository_url "$plugin_name"
302:         scan_for_private_refs "$plugin_name"
303: 
304:         echo ""
305:         print_success "Sync complete for $plugin_name"
306:     fi
307: }
308: 
309: # Run main
310: main "$@"
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

## File: .gitignore
````
 1: # Python
 2: __pycache__/
 3: *.py[cod]
 4: *$py.class
 5: *.so
 6: .Python
 7: env/
 8: venv/
 9: ENV/
10: build/
11: develop-eggs/
12: dist/
13: downloads/
14: eggs/
15: .eggs/
16: lib/
17: lib64/
18: parts/
19: sdist/
20: var/
21: wheels/
22: *.egg-info/
23: .installed.cfg
24: *.egg
25: 
26: # Node
27: node_modules/
28: npm-debug.log*
29: yarn-debug.log*
30: yarn-error.log*
31: package-lock.json
32: 
33: # IDEs
34: .vscode/
35: .idea/
36: *.swp
37: *.swo
38: *~
39: .DS_Store
40: 
41: # Testing
42: .coverage
43: .pytest_cache/
44: htmlcov/
45: .tox/
46: .hypothesis/
47: 
48: # Logs
49: *.log
50: logs/
51: 
52: # Environment
53: .env
54: .env.local
55: .env.*.local
56: 
57: # Claude Code
58: .claude/work/
59: .claude/transitions/
60: 
61: # OS
62: .DS_Store
63: Thumbs.db
64: 
65: # Temporary files
66: *.tmp
67: *.temp
68: *.bak
69: *.old
70: 
71: # Build artifacts
72: *.tar.gz
73: *.zip
74: 
75: # Private or sensitive
76: private/
77: secrets/
78: *.key
79: *.pem
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

## File: LICENSE
````
 1: MIT License
 2: 
 3: Copyright (c) 2025 Applied AI Consulting
 4: 
 5: Permission is hereby granted, free of charge, to any person obtaining a copy
 6: of this software and associated documentation files (the "Software"), to deal
 7: in the Software without restriction, including without limitation the rights
 8: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 9: copies of the Software, and to permit persons to whom the Software is
10: furnished to do so, subject to the following conditions:
11: 
12: The above copyright notice and this permission notice shall be included in all
13: copies or substantial portions of the Software.
14: 
15: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
16: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
17: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
18: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
19: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
21: SOFTWARE.
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

## File: examples/README.md
````markdown
 1: # Example Plugins
 2: 
 3: Three progressive examples demonstrating Claude Code plugin development from basic to advanced.
 4: 
 5: ## Learning Path
 6: 
 7: ### 1. hello-world (Beginner - 5 min)
 8: **Concepts**: Command structure, arguments, basic bash
 9: 
10: Start here to understand plugin fundamentals.
11: 
12: [→ Start with hello-world](./hello-world/)
13: 
14: ### 2. task-tracker (Intermediate - 15 min)
15: **Concepts**: JSON state management, file operations, validation
16: 
17: Build a practical task management system.
18: 
19: [→ Continue with task-tracker](./task-tracker/)
20: 
21: ### 3. code-formatter (Advanced - 20 min)
22: **Concepts**: External tools, agent integration, error handling
23: 
24: Integrate external formatters with AI-powered analysis.
25: 
26: [→ Finish with code-formatter](./code-formatter/)
27: 
28: ---
29: 
30: **Learn** → **Practice** → **Build** → **Contribute**
31: 
32: 🚀 Start with `hello-world/` and work your way through!
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
