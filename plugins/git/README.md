# Git Plugin

Unified git operations for commits, pull requests, and issue management with AI-assisted workflows.

## Overview

The Git plugin provides a unified `/git` command that handles all git operations with intelligent automation. It creates well-formatted commits, generates comprehensive pull requests, and manages GitHub issues - all with proper attribution and best practices built-in.

## Features

- **Smart Commits**: AI-generated commit messages following conventional commit format
- **Pull Request Automation**: Comprehensive PR creation with summaries and test plans
- **Issue Management**: Create and manage GitHub issues via gh CLI
- **Safe Operations**: Never destructive, always reviewable before execution
- **Proper Attribution**: Auto-adds Claude Code attribution to commits and PRs

## Command

### `/git [commit|pr|issue] [arguments]`
Unified git operations - commits, pull requests, and issue management.

## Git Commit

Create commits with AI-generated messages that follow best practices.

**Usage**:
```bash
/git commit                                 # Commit staged changes with generated message
/git commit -m "Custom message"            # Commit with custom message
/git commit --amend                        # Amend last commit (with safety checks)
/git commit --all                          # Stage all changes and commit
```

**What it does**:
1. Analyzes staged changes (or all changes with --all)
2. Reviews recent commits to match style
3. Generates descriptive commit message
4. Shows you the message for approval
5. Creates commit with Claude Code attribution
6. Runs pre-commit hooks if configured

**Commit Message Format**:
```
feat: Add user authentication with JWT

Implements JWT-based authentication for API endpoints.
- Add password hashing to User model
- Create login endpoint with token generation
- Protect existing endpoints with auth middleware
- Add comprehensive integration tests

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Commit Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Test additions or modifications
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `style`: Code style changes (formatting)

**Safety Features**:
- Never uses `--force` flags
- Never uses `--no-verify` (skipping hooks)
- Checks authorship before amending
- Warns on force push to main/master
- Validates staged changes before committing

**When to use**:
- ✅ After completing a feature or fix
- ✅ Regular progress checkpoints
- ✅ Before switching branches
- ✅ Integrated with `/ship --commit`

**When NOT to use**:
- ❌ No changes to commit (git will warn)
- ❌ Unreviewed changes you don't understand
- ❌ Temporary/experimental code

## Git Pull Request

Create pull requests with comprehensive documentation.

**Usage**:
```bash
/git pr                                     # Create PR from current branch
/git pr "PR title"                         # Create PR with custom title
/git pr --draft                            # Create draft PR
/git pr --base develop                     # Target different base branch
```

**What it does**:
1. Analyzes all commits since branch diverged from base
2. Examines changed files and code
3. Generates comprehensive PR summary
4. Creates test plan checklist
5. Pushes branch if needed
6. Creates PR via gh CLI
7. Returns PR URL

**PR Format**:
```markdown
## Summary
- Add JWT-based authentication to API
- Implement password hashing and token generation
- Protect endpoints with auth middleware
- Add comprehensive integration tests

## Changes
- **Added**: JWT token generation utilities
- **Modified**: User model with password hashing
- **Added**: Login endpoint at /api/auth/login
- **Added**: Auth middleware for protected routes
- **Added**: Integration tests for auth flow

## Test Plan
- [ ] Test user registration creates hashed password
- [ ] Test login generates valid JWT token
- [ ] Test protected endpoints reject without token
- [ ] Test protected endpoints accept with valid token
- [ ] Test token expiration handling
- [ ] Run full integration test suite

## Breaking Changes
None

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

**Requirements**:
- **gh CLI**: GitHub CLI must be installed and authenticated
- **Remote branch**: Branch should be pushed or will auto-push
- **Git configured**: User name and email must be set

**Configuration**:
```bash
# Install gh CLI (if not installed)
# macOS
brew install gh

# Linux
# See: https://github.com/cli/cli#installation

# Authenticate
gh auth login
```

**When to use**:
- ✅ Feature development complete
- ✅ Ready for team review
- ✅ After `/ship` validation passes
- ✅ Integrated with `/ship --pr`

## Git Issue

Create and manage GitHub issues.

**Usage**:
```bash
/git issue "Bug: Login fails on Safari"    # Create new issue
/git issue "Feature: Add OAuth support" --label enhancement
/git issue --list                          # List open issues
/git issue --close 123                     # Close issue #123
```

**What it does**:
- Creates well-formatted GitHub issues
- Assigns labels and milestones
- Adds issue templates if available
- Links to related PRs/commits
- Manages issue lifecycle

**Issue Format**:
```markdown
## Description
[Clear description of the issue]

## Steps to Reproduce
1. [First step]
2. [Second step]
3. [etc.]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- OS: [e.g., macOS 13.0]
- Browser: [e.g., Safari 16.1]
- Version: [e.g., v1.2.3]

## Additional Context
[Any additional information]
```

**Requirements**:
- **gh CLI**: GitHub CLI must be installed and authenticated

**When to use**:
- ✅ Bug reports
- ✅ Feature requests
- ✅ Task tracking
- ✅ Documentation todos

## Safety Protocol

The Git plugin follows these safety rules:

### NEVER Do
- ❌ Run `git push --force` to main/master (warns user if requested)
- ❌ Skip hooks with `--no-verify` or `--no-gpg-sign`
- ❌ Update git config without user permission
- ❌ Amend commits by other developers
- ❌ Amend commits already pushed to shared branches
- ❌ Commit files that likely contain secrets (.env, credentials, etc.)

### ALWAYS Do
- ✅ Validate staged changes before committing
- ✅ Check authorship before amending
- ✅ Run pre-commit hooks if configured
- ✅ Add Claude Code attribution
- ✅ Generate descriptive commit messages
- ✅ Review changes with user before committing
- ✅ Warn about sensitive files
- ✅ Verify tests pass before recommending PR

## Integration with Other Plugins

### Workflow Plugin
**Integrated with /ship**:
```bash
/ship --commit              # Uses /git commit
/ship --pr                  # Uses /git pr
```

The workflow plugin calls git plugin automatically during delivery.

### Development Plugin
**Quality Gates**:
- `/review` runs before `/git commit` (recommended)
- `/test` runs before `/git pr` (recommended)
- `/fix` resolves issues blocking commit

**Recommended Flow**:
```bash
# 1. Review code
/review

# 2. Fix issues
/fix review

# 3. Run tests
/run npm test

# 4. Commit when ready
/git commit

# 5. Create PR
/git pr
```

### Core Plugin
- Uses `/agent` for specialized git operations
- Uses `/status` to show git state

## Configuration

### Commit Defaults (`.claude/config.json`)
```json
{
  "git": {
    "commit": {
      "conventionalCommits": true,
      "addAttribution": true,
      "analyzeRecentCommits": true,
      "commitCountToAnalyze": 5,
      "allowAmend": "with-checks"
    }
  }
}
```

### Pull Request Defaults
```json
{
  "git": {
    "pr": {
      "defaultBase": "main",
      "includeSummary": true,
      "includeTestPlan": true,
      "autoLabels": true,
      "draftByDefault": false
    }
  }
}
```

### Safety Rules
```json
{
  "git": {
    "safety": {
      "warnOnForceToMain": true,
      "preventSecretCommit": true,
      "secretPatterns": [".env", "credentials", "secrets", "*.key"],
      "requireTestsBeforePR": false
    }
  }
}
```

## System Requirements

### Required
- **git** (v2.0.0+): Version control system
  ```bash
  git --version
  # Should be 2.0.0 or higher
  ```

### Optional
- **gh** (GitHub CLI): For PR and issue management
  ```bash
  # Install
  brew install gh           # macOS
  # See https://github.com/cli/cli#installation for other platforms

  # Authenticate
  gh auth login

  # Verify
  gh --version
  ```

## Best Practices

### Commit Workflow
```bash
# 1. Make changes

# 2. Stage changes
git add src/auth/login.js

# 3. Review what's staged
git diff --staged

# 4. Create commit
/git commit

# 5. Review generated message

# 6. Push when ready
git push
```

### Pull Request Workflow
```bash
# 1. Ensure branch is up to date
git fetch origin
git rebase origin/main

# 2. Run tests
/run npm test

# 3. Review code
/review

# 4. Fix issues
/fix review

# 5. Commit changes
/git commit

# 6. Create PR
/git pr

# 7. Address review feedback
# (make changes, commit, push)
```

### Issue Workflow
```bash
# Report bug
/git issue "Bug: User login fails on Firefox" --label bug

# Track feature
/git issue "Feature: Add OAuth support" --label enhancement

# Link PR to issue
/git pr "Fixes #123: Add Firefox compatibility"

# Close when done
/git issue --close 123
```

## Examples

### Example 1: Feature Development
```bash
# Create feature branch
git checkout -b feature/oauth-login

# Develop feature
# (write code)

# Review code
/review src/auth

# Fix issues
/fix review

# Run tests
/run npm test

# Commit
/git commit
# Generates: "feat: Add OAuth login support"

# Create PR
/git pr
# Creates comprehensive PR with summary and test plan
```

### Example 2: Bug Fix
```bash
# Create issue
/git issue "Bug: Memory leak in data processing" --label bug

# Create branch
git checkout -b fix/memory-leak

# Fix bug
# (write code)

# Test fix
/run npm test

# Commit
/git commit
# Generates: "fix: Resolve memory leak in data processing"

# Create PR linking to issue
/git pr "Fixes #456: Memory leak in data processing"
```

### Example 3: Integrated Workflow
```bash
# Use workflow plugin
/explore "Add user authentication"
/plan
/next  # Implement tasks
/next
/next

# Ship with git integration
/ship --pr
# Automatically:
# - Reviews code
# - Runs tests
# - Creates commit with /git commit
# - Creates PR with /git pr
# - Returns PR URL
```

## Troubleshooting

### /git commit fails
**Issue**: "Nothing to commit"
- **Solution**: Stage changes with `git add` first

**Issue**: "Pre-commit hook failed"
- **Solution**: Fix issues identified by hook, or use `git commit --no-verify` (not recommended)

**Issue**: "Author mismatch on amend"
- **Solution**: Don't amend others' commits; create new commit instead

### /git pr fails
**Issue**: "gh: command not found"
- **Solution**: Install GitHub CLI: `brew install gh`

**Issue**: "gh: not authenticated"
- **Solution**: Run `gh auth login` and follow prompts

**Issue**: "No commits on branch"
- **Solution**: Ensure you've committed changes on current branch

**Issue**: "Branch not pushed"
- **Solution**: Plugin will auto-push, or run `git push -u origin branch-name`

### Commit message not generated
**Issue**: Git status not showing changes
- **Solution**: Verify changes exist with `git status` and stage with `git add`

**Issue**: Recent commit history unavailable
- **Solution**: Initialize git history, or provide custom message with `-m`

## Advanced Usage

### Amending Commits Safely
```bash
# Only amend if:
# 1. You authored the commit
# 2. Commit not pushed to shared branch

/git commit --amend

# Plugin checks:
# - Author matches current user
# - Commit not on origin (or ahead of origin)
# - Confirms safe to amend
```

### Custom Commit Messages
```bash
# Override AI generation
/git commit -m "fix: Resolve Safari compatibility issue

Fixes rendering bug on Safari 16+ by updating CSS Grid usage.

Fixes #123"
```

### Draft Pull Requests
```bash
# Create draft PR for early feedback
/git pr --draft

# Benefits:
# - Signals "work in progress"
# - Prevents accidental merge
# - Allows early review/discussion
```

### Target Different Base Branch
```bash
# PR to develop instead of main
/git pr --base develop

# PR to release branch
/git pr --base release/v2.0
```

## Metrics and Quality

The git plugin tracks:
- **Commit frequency**: Commits per day/week
- **Commit size**: Lines changed per commit
- **PR quality**: Summary completeness, test plan coverage
- **Attribution**: Claude Code usage in commits

View with:
```bash
/status verbose
/performance
```

## Support

- **Documentation**: [Git Workflow Guide](../../docs/guides/git-workflow.md)
- **Issues**: [GitHub Issues](https://github.com/applied-artificial-intelligence/claude-code-plugins/issues)
- **Discussions**: [GitHub Discussions](https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions)

## Related Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Git Best Practices](https://git-scm.com/book/en/v2)

## License

MIT License - see [LICENSE](../../LICENSE) for details.

---

**Version**: 1.0.0
**Category**: Tools
**System Requirements**: git (2.0.0+), gh CLI (optional)
**Dependencies**: core (^1.0.0)
**MCP Tools**: None
