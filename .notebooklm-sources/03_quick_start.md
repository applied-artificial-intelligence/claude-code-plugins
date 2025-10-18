# Quick Start Tutorial

Get productive with Claude Code Plugins in 15 minutes. Learn the core workflow with a real-world example.

## What You'll Build

In this tutorial, you'll add user authentication to a Node.js API using the Claude Code Plugins workflow:

**Result**: Working JWT-based authentication in ~15 minutes

## Prerequisites

Before starting, ensure you have:

- ✅ Claude Code v3.0+ installed
- ✅ Claude Code Plugins installed ([Installation Guide](installation.md))
- ✅ A Node.js project (or follow along with the example)

**Time Required**: 15 minutes

## The Workflow

Claude Code Plugins provide a systematic 4-phase workflow:

```
/explore → /plan → /next → /ship
   ↓         ↓       ↓        ↓
Analyze   Design  Build   Deliver
```

Let's see it in action!

---

## Step 1: Explore the Requirements (3 minutes)

**Goal**: Understand what needs to be built and explore the codebase.

### Run the Command

In your project directory, start a Claude Code session and run:

```bash
/explore "Add JWT-based authentication to the API"
```

### What Happens

Claude will:
1. **Analyze your request** - Understand what "JWT-based authentication" means
2. **Explore your codebase** - Find relevant files (routes, models, middleware)
3. **Identify constraints** - Discover existing auth patterns, dependencies
4. **Document findings** - Create `exploration.md` with analysis

### Expected Output

```
🔍 Exploration: Add JWT-based authentication to the API
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Requirements Analysis
✓ JWT-based authentication requested
✓ Stateless token-based approach
✓ Industry standard for APIs

## Codebase Exploration
Found relevant files:
- src/routes/auth.js (empty, needs implementation)
- src/models/User.js (has password field, needs hashing)
- src/middleware/ (needs auth middleware)

## Existing Dependencies
✓ express: 4.18.2 (web framework)
✓ bcrypt: 5.1.0 (already installed - good for password hashing!)
⚠ jsonwebtoken: NOT installed (need to add)

## Recommendations
1. Install jsonwebtoken package
2. Add password hashing to User model
3. Create login endpoint
4. Implement auth middleware
5. Protect existing routes

Exploration complete → Ready for planning
📁 Created: .claude/work/current/auth_implementation/exploration.md
```

### Common Issues

**Issue**: "No relevant files found"
- **Solution**: Make sure you're in the project root directory
- **Tip**: You can still continue - Claude will guide you to create the structure

**Issue**: "Unclear what you want to explore"
- **Solution**: Be more specific: "Add JWT authentication with login/register endpoints"

---

## Step 2: Create an Implementation Plan (2 minutes)

**Goal**: Break the work into ordered, manageable tasks.

### Run the Command

```bash
/plan
```

**Note**: `/plan` automatically uses the exploration findings from Step 1.

### What Happens

Claude will:
1. **Review exploration** - Load findings from Step 1
2. **Break down work** - Create ordered tasks with dependencies
3. **Define success criteria** - Specify how to verify each task
4. **Create task file** - Generate `implementation-plan.md` and `state.json`

### Expected Output

```
📋 Implementation Plan: JWT Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Task Breakdown (6 tasks, ~3 hours estimated)

TASK-001: Install jsonwebtoken dependency
├─ Priority: High
├─ Time: 15 minutes
└─ Acceptance: Package.json updated, dependency installed

TASK-002: Add password hashing to User model
├─ Dependencies: None
├─ Priority: High
├─ Time: 30 minutes
└─ Acceptance: Passwords hashed on save, comparison method works

TASK-003: Create JWT utilities (generate/verify tokens)
├─ Dependencies: TASK-001
├─ Priority: High
├─ Time: 30 minutes
└─ Acceptance: Can generate and verify valid JWTs

TASK-004: Implement login endpoint
├─ Dependencies: TASK-002, TASK-003
├─ Priority: High
├─ Time: 45 minutes
└─ Acceptance: POST /auth/login returns valid JWT

TASK-005: Create auth middleware
├─ Dependencies: TASK-003
├─ Priority: High
├─ Time: 30 minutes
└─ Acceptance: Middleware validates JWT and attaches user

TASK-006: Protect existing endpoints
├─ Dependencies: TASK-005
├─ Priority: Medium
├─ Time: 30 minutes
└─ Acceptance: Protected routes require valid token

Planning complete → Ready for implementation
📁 Created: .claude/work/current/auth_implementation/implementation-plan.md
📁 Created: .claude/work/current/auth_implementation/state.json
```

### What You Get

- **implementation-plan.md**: Human-readable plan with full details
- **state.json**: Machine-readable task tracking for `/next`

### Common Issues

**Issue**: "No exploration found"
- **Solution**: Run `/explore` first (Step 1)

**Issue**: "Plan looks wrong"
- **Solution**: You can run `/plan` again with more specifics:
  ```bash
  /plan "Focus on minimal viable auth - just login and protect routes"
  ```

---

## Step 3: Execute Tasks One by One (8 minutes)

**Goal**: Implement each task systematically with `/next`.

### Run the Command

```bash
/next
```

**This will execute the first available task (TASK-001).**

### What Happens

Claude will:
1. **Select next task** - Chooses first task with satisfied dependencies
2. **Display task details** - Shows what will be done
3. **Execute task** - Implements the changes
4. **Verify completion** - Checks acceptance criteria
5. **Update state** - Marks task complete, identifies next task
6. **Commit changes** - Auto-commits with descriptive message

### Expected Output (First Task)

```
🚀 Executing TASK-001: Install jsonwebtoken dependency
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Task Details
Priority: High
Estimated: 15 minutes
Dependencies: None (ready to execute)

## Executing...
Running: npm install jsonwebtoken

added 5 packages, and audited 150 packages in 3s
✓ jsonwebtoken@9.0.2 installed successfully

## Verification
✓ Package.json updated with jsonwebtoken@9.0.2
✓ Dependency installed in node_modules
✓ All acceptance criteria met

## Git Commit
[main a7f3d91] feat: Install jsonwebtoken for JWT authentication
 2 files changed, 6 insertions(+)

✅ TASK-001 completed successfully

📊 Progress: 1/6 tasks complete (17%)
→ Next available: TASK-002, TASK-003

Run /next again to continue!
```

### Continue with /next

Keep running `/next` to execute all tasks:

```bash
/next  # Executes TASK-002 (password hashing)
/next  # Executes TASK-003 (JWT utilities)
/next  # Executes TASK-004 (login endpoint)
/next  # Executes TASK-005 (auth middleware)
/next  # Executes TASK-006 (protect routes)
```

**Or run them all at once**: Just keep running `/next` until all tasks are complete!

### Real Example: TASK-004 Output

```
🚀 Executing TASK-004: Implement login endpoint
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Implementation
Created: src/routes/auth.js

```javascript
const express = require('express');
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');

const router = express.Router();

router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Verify password
    const isValid = await user.comparePassword(password);
    if (!isValid) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    // Generate JWT
    const token = generateToken({ userId: user._id });

    res.json({ token, user: { id: user._id, email: user.email } });
  } catch (error) {
    res.status(500).json({ error: 'Login failed' });
  }
});

module.exports = router;
```

## Verification
✓ POST /auth/login endpoint created
✓ Password verification integrated
✓ JWT generation on successful login
✓ Error handling for invalid credentials
✓ Returns token and user data

✅ TASK-004 completed successfully
📊 Progress: 4/6 tasks complete (67%)
```

### Common Issues

**Issue**: Task fails with "dependency not satisfied"
- **Solution**: Complete the dependent tasks first
- **Tip**: Run `/next --status` to see task dependencies

**Issue**: "Tests failing after implementation"
- **Solution**: Claude will show the error and suggest fixes
- **Tip**: Run `/fix` to debug and resolve test failures

---

## Step 4: Review and Test (1 minute)

**Goal**: Verify everything works before delivery.

### Run the Command

```bash
/review
```

### What Happens

Claude will:
1. **Review all changes** - Check code added during `/next` executions
2. **Run quality checks** - Linting, formatting, security
3. **Identify issues** - Bugs, design flaws, improvements
4. **Provide feedback** - Prioritized list of findings

### Expected Output

```
🔍 Code Review: JWT Authentication Implementation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Files Reviewed
- src/models/User.js
- src/utils/jwt.js
- src/routes/auth.js
- src/middleware/auth.js
- src/routes/users.js (protected)

## Findings

### HIGH Priority
✓ No critical issues found!

### MEDIUM Priority
ℹ️ Consider adding rate limiting to login endpoint
  Location: src/routes/auth.js:12
  Reason: Prevent brute-force attacks
  Suggestion: Use express-rate-limit middleware

### LOW Priority
✓ Code quality good
✓ Error handling present
✓ Security best practices followed

## Summary
✅ Implementation is production-ready
ℹ️  1 optional improvement suggested (rate limiting)

Overall Quality: Excellent
Security: Good
Maintainability: High
```

### Optional: Fix Issues

If the review found issues:

```bash
/fix review
```

This will automatically apply suggested fixes.

### Test Manually

Try the authentication:

```bash
# Register a user (if you have registration)
curl -X POST http://localhost:3000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"secure123"}'

# Login
curl -X POST http://localhost:3000/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"secure123"}'

# Returns: {"token":"eyJhbGc...","user":{"id":"...","email":"test@example.com"}}

# Access protected route
curl http://localhost:3000/api/users \
  -H "Authorization: Bearer eyJhbGc..."
```

---

## Step 5: Ship the Feature (1 minute)

**Goal**: Finalize and deliver the completed work.

### Run the Command

```bash
/ship
```

Or create a pull request:

```bash
/ship --pr
```

### What Happens

Claude will:
1. **Verify completion** - Check all tasks are done
2. **Run final tests** - Execute test suite
3. **Generate documentation** - Create completion summary
4. **Create commit/PR** - Package changes for review
5. **Provide summary** - What was delivered and how to use it

### Expected Output

```
🚀 Shipping: JWT Authentication
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## Pre-Delivery Checks
✅ All 6 tasks completed
✅ Tests passing (12/12)
✅ Code review passed
✅ No outstanding issues

## What Was Delivered

### Features
✅ JWT-based authentication system
✅ Password hashing with bcrypt
✅ Login endpoint: POST /auth/login
✅ Auth middleware for protected routes
✅ Token generation and verification utilities

### Files Modified
- package.json (added jsonwebtoken)
- src/models/User.js (password hashing)
- src/utils/jwt.js (NEW - JWT utilities)
- src/routes/auth.js (NEW - login endpoint)
- src/middleware/auth.js (NEW - auth middleware)
- src/routes/users.js (protected with auth)

### Tests Added
- User model password hashing tests (4 tests)
- JWT utilities tests (6 tests)
- Auth endpoint integration tests (8 tests)

## How to Use

### Login
```bash
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "token": "eyJhbGc...",
  "user": { "id": "...", "email": "user@example.com" }
}
```

### Protected Routes
```bash
GET /api/users
Authorization: Bearer eyJhbGc...
```

## Pull Request Created
🔗 https://github.com/your-org/your-repo/pull/42

Title: feat: Add JWT-based authentication
Status: Ready for review
Reviewers: Automatically suggested based on CODEOWNERS

## Next Steps
1. Team review of PR #42
2. Address any review feedback
3. Merge to main when approved
4. Deploy to staging for integration testing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Feature delivery complete!
📊 Total time: ~15 minutes
📈 Quality: Production-ready
```

### If You Used --pr

Claude will:
- Push your branch to GitHub
- Create a pull request with comprehensive description
- Add test plan checklist
- Suggest reviewers
- Return the PR URL

---

## What You Just Learned

In 15 minutes, you:

✅ **Explored** requirements and codebase with `/explore`
✅ **Planned** implementation with ordered tasks using `/plan`
✅ **Built** the feature systematically with `/next`
✅ **Reviewed** code quality with `/review`
✅ **Shipped** production-ready code with `/ship`

**Result**: Working JWT authentication with tests, documentation, and a pull request!

## The Power of the Workflow

### Why This Workflow Works

1. **Systematic**: No guessing - clear steps from start to finish
2. **Quality-First**: Built-in review and testing at each step
3. **Trackable**: Always know what's done and what's next
4. **Collaborative**: PRs with comprehensive context for reviewers
5. **Fast**: 15 minutes vs. hours of manual coding

### When to Use This Workflow

✅ **Perfect for**:
- Features that span multiple files
- Bug fixes requiring investigation
- Refactoring with many changes
- Work you'll spread across sessions
- Team collaboration (plan serves as spec)

❌ **Skip for**:
- Single-line fixes
- Typo corrections
- Quick documentation updates

## Common Issues & Solutions

### "I made a mistake in exploration"

No problem! Just run `/explore` again:

```bash
/explore "Add JWT authentication with login AND register endpoints"
```

Then `/plan` will use the new exploration.

### "The plan created too many tasks"

You can simplify:

```bash
/plan "Create minimal auth - just login endpoint and one protected route"
```

Or merge tasks by running multiple `/next` commands and manually combining the work.

### "A task failed halfway through"

Claude will mark it as "in_progress" and you can:

1. **Fix the issue** manually
2. **Run `/next` again** - it will resume the same task
3. **Or use `/fix`** to debug the error

### "I want to change the approach mid-implementation"

You can:

1. Finish current task with `/next`
2. Run `/plan` again with new direction
3. Claude will create a new plan building on completed work

## Next Steps

Now that you know the workflow:

1. **Try it on your own project** - Pick a small feature and use the 4-phase workflow
2. **Learn individual plugins** - Explore the [Core](../../plugins/core/README.md), [Workflow](../../plugins/workflow/README.md), and [Development](../../plugins/development/README.md) plugin READMEs
3. **Create a custom plugin** - Follow the [First Plugin Tutorial](first-plugin.md)
4. **Read architecture docs** - Understand the [design principles](../architecture/design-principles.md)

## Quick Reference

### The 4-Phase Workflow

```bash
/explore "<what to build>"     # Step 1: Analyze requirements
/plan                          # Step 2: Create task breakdown
/next                          # Step 3: Execute tasks (repeat)
/ship                          # Step 4: Deliver completed work
```

### Bonus Commands

```bash
/status                        # Check current progress
/next --status                 # See task breakdown and progress
/next --preview                # Show next task without executing
/review                        # Code quality check
/fix                           # Debug and fix issues
/git commit                    # Create well-formatted commit
/git pr                        # Create pull request
```

### Getting Help

- **Full Documentation**: [Documentation Index](../README.md)
- **Plugin READMEs**: Detailed command references in each plugin
- **GitHub Issues**: [Report bugs](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [Ask questions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

---

**Congratulations!** 🎉

You've completed the Quick Start tutorial. You now know how to use Claude Code Plugins to build features systematically and ship quality code fast.

**Ready for more?** Try the workflow on your next feature!
