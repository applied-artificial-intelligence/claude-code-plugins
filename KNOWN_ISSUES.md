# Known Issues

This document tracks known test failures, limitations, platform-specific issues, and workarounds for the claude-code-plugins test suite. We believe in transparent communication about what works, what doesn't, and what we're working on.

**Last Updated**: 2025-10-23

## Quick Reference

| Issue Category | Impact | Workaround Available | Status |
|----------------|--------|---------------------|--------|
| API Authentication | High | Yes (simulation mode) | Documented |
| MCP Tools Optional | Low | Yes (graceful degradation) | By design |
| Git Context Required | Medium | Yes (use git repos) | Documented |
| Docker Permissions | Medium | Yes (see below) | Platform-specific |
| Command Timeouts | Medium | Yes (timeout tuning) | Configuration |
| Node Version Mismatch | High | Yes (use v20 or v22) | Documented |

---

## Test Failures and Limitations

### 1. API Authentication Required for Full Testing

**Issue**: Full functional testing requires `ANTHROPIC_API_KEY` environment variable.

**Impact**:
- Without API key: Tests run in **simulation mode** (validates command catalog only)
- With API key: Full command execution with Claude

**Workaround**:
```bash
# Option 1: Run in simulation mode (no API calls)
python3 test_suite_oss.py --simulation

# Option 2: Provide API key for full testing
export ANTHROPIC_API_KEY="your_api_key_here"
python3 test_suite_oss.py
```

**Status**: ✅ By design - simulation mode provides fast validation without API costs

**Tracking**: N/A (intentional behavior)

---

### 2. MCP Tools Optional (Graceful Degradation)

**Issue**: Some plugins use MCP (Model Context Protocol) tools that may not be available in all environments.

**Affected Plugins**:
- **agents** - Uses Sequential Thinking MCP for structured reasoning
- **workflow** - Can use Sequential Thinking for complex planning
- **development** - Can use Serena MCP for semantic code analysis

**Impact**:
- Commands work without MCP (graceful degradation)
- Enhanced functionality available when MCP tools present
- No test failures if MCP unavailable

**Workaround**: Install MCP tools for enhanced functionality (optional):
```bash
# Claude Code includes Sequential Thinking MCP by default
# For Serena (semantic code understanding):
# See: https://github.com/context7-labs/serena-mcp

# For Context7 (documentation access):
# See: https://github.com/context7-labs/context7-mcp
```

**Status**: ✅ By design - MCP enhances but never required

**Tracking**: N/A (intentional graceful degradation)

---

### 3. Commands Requiring Git Repository Context

**Issue**: Some commands expect to run in a git repository and may fail or produce limited output in non-git directories.

**Affected Commands**:
- `/development:git` - All git operations require git repo
- `/workflow:ship` - Creates git commits for deliverables
- `/system:status` - Shows git status when available

**Impact**:
- Commands fail with clear error messages in non-git directories
- Tests may show lower pass rates if run outside git repos

**Workaround**:
```bash
# Run tests in git repository
cd /path/to/git/repo
python3 /path/to/tests/test_suite_oss.py

# Or initialize git in test directory
git init
python3 test_suite_oss.py
```

**Status**: ⚠️ Expected behavior - git commands need git context

**Tracking**: Documented in QUICKSTART_TESTING.md

---

### 4. Docker Permission Issues (Platform-Specific)

**Issue**: Docker may have permission issues on some systems, particularly Linux.

**Symptoms**:
- `Cannot connect to the Docker daemon` errors
- Permission denied when running Docker commands
- Tests fail with Docker-related errors

**Platform**: Linux (Ubuntu, Debian, etc.)

**Workaround**:
```bash
# Option 1: Add user to docker group (recommended)
sudo usermod -aG docker $USER
newgrp docker  # Or log out and log back in

# Option 2: Run with sudo (not recommended)
sudo docker compose up

# Option 3: Use local testing instead of Docker
# Follow macOS/Ubuntu instructions in QUICKSTART_TESTING.md
```

**Status**: ⚠️ Platform-specific - affects Linux systems

**Tracking**: See QUICKSTART_TESTING.md troubleshooting section

---

### 5. Command Timeouts in Non-Interactive Mode

**Issue**: Some commands may timeout when run non-interactively via `claude -p`.

**Affected Commands** (potentially):
- Commands that normally require user permission/confirmation
- Commands with long-running operations (>30s default)
- Commands waiting for external resources (network, API)

**Impact**:
- Tests may report timeout failures
- Pass rate may be lower than actual functionality

**Workaround**:
```bash
# Increase timeout for specific tests
python3 test_suite_oss.py --timeout 60  # 60 seconds

# Skip known-timeout commands
python3 test_suite_oss.py --skip-timeouts

# Test interactively (not automated)
claude  # Then run commands manually
```

**Current Timeout Settings**:
- Default: 30 seconds
- CI: 120 seconds (GitHub Actions)
- Configurable via `--timeout` flag

**Status**: ⚠️ Ongoing - some commands inherently slow

**Tracking**: [Issue #TBD] - Optimize slow commands

---

### 6. Node Version Compatibility

**Issue**: Plugins require Node.js v20 or v22. Other versions not supported.

**Supported Versions**:
- ✅ Node.js v20.x LTS
- ✅ Node.js v22.x LTS
- ❌ Node.js v18.x (deprecated)
- ❌ Node.js v16.x (deprecated)

**Impact**: Tests fail with version mismatch errors on unsupported Node versions

**Workaround**:
```bash
# Check current version
node --version

# Install supported version with nvm
nvm install 22
nvm use 22

# Verify
node --version  # Should show v22.x.x
```

**Status**: ✅ By design - follow Node.js LTS schedule

**Tracking**: N/A (documented requirement)

---

## Platform-Specific Gotchas

### macOS

**Issue**: macOS may have different terminal behavior affecting tmux/FFmpeg recording.

**Known Issues**:
- Terminal font rendering differences
- Screen recording permissions required (System Preferences → Security & Privacy → Screen Recording)
- FFmpeg may need Homebrew installation: `brew install ffmpeg`

**Workaround**: Grant screen recording permissions and use Homebrew for dependencies.

---

### Ubuntu / Debian

**Issue**: Missing system dependencies for Python packages or FFmpeg.

**Known Issues**:
- Python `dev` packages may be needed: `sudo apt install python3-dev`
- FFmpeg may need manual installation: `sudo apt install ffmpeg`
- Docker permission issues (see #4 above)

**Workaround**: Install system dependencies before running tests.

---

### Docker

**Issue**: Docker environment differs from local environment in subtle ways.

**Known Issues**:
- Permission model different (non-root user `claude-tester`)
- Volume mounts may have sync delays
- Network isolation may affect external API calls
- Python package installation needs special handling (use `uv` not `pip`)

**Workaround**: Use Docker-specific instructions in QUICKSTART_TESTING.md.

---

## MCP Configuration Requirements

### Sequential Thinking MCP

**Status**: ✅ Built-in to Claude Code
**Configuration**: None required (automatically available)
**Usage**: Enhanced reasoning for `/workflow:explore`, `/workflow:plan`, complex analysis

---

### Serena MCP (Semantic Code Understanding)

**Status**: ⚠️ Optional, requires per-project setup
**Configuration**:
```bash
# Install Serena MCP
# See: https://github.com/context7-labs/serena-mcp

# Activate for project
cd /path/to/project
/agents:serena  # Run activation command
```

**Benefits**: 70-90% token reduction for code operations, semantic search, symbol-level analysis
**Impact if Missing**: Commands fall back to text-based file reading and grep search

---

### Context7 MCP (Documentation Access)

**Status**: ⚠️ Optional, requires API key
**Configuration**:
```bash
# Get API key from https://context7.com
export CONTEXT7_API_KEY="your_api_key_here"

# Or add to ~/.claude/settings.json
```

**Benefits**: Real-time library documentation access, faster than manual web search
**Impact if Missing**: Commands fall back to web search and cached documentation

---

## Authentication Requirements

### Anthropic API Key

**Required For**: Full functional testing with real Claude API calls
**Not Required For**: Simulation mode testing (command catalog validation)

**How to Obtain**:
1. Sign up at https://console.anthropic.com
2. Generate API key
3. Set environment variable: `export ANTHROPIC_API_KEY="sk-ant-..."`

**Security Notes**:
- Never commit API keys to git
- Use `.env` files (ignored by git)
- Rotate keys regularly
- Use separate keys for testing vs production

---

### MCP API Keys (Optional)

**Context7**: Get from https://context7.com (optional)
**Serena**: No API key required (uses local analysis)

---

## Timeout Tuning Guidance

### Default Timeouts

- **Smoke tests**: 5 seconds per command
- **Functional tests**: 30 seconds per command
- **CI tests**: 120 seconds per command
- **Overall test suite**: 30 minutes (CI), unlimited (local)

### Adjusting Timeouts

```bash
# Increase timeout for all tests
python3 test_suite_oss.py --timeout 60

# Increase timeout for specific command
python3 test_suite_oss.py --command "/workflow:explore" --timeout 90

# Disable timeout (local development only)
python3 test_suite_oss.py --no-timeout
```

### Commands with Known Long Execution Times

| Command | Typical Time | Reason |
|---------|--------------|--------|
| `/workflow:explore` | 30-60s | Deep codebase analysis |
| `/development:analyze` | 20-45s | Semantic code understanding |
| `/memory:index` | 45-90s | Project knowledge indexing |
| `/development:review --systematic` | 60-120s | Thorough code review |

**Recommendation**: Use higher timeouts in CI (120s), lower in local development (30s).

---

## Performance Expectations

### Test Execution Times

**Smoke Tests** (fast validation):
- Docker: ~30 seconds
- Local (macOS/Ubuntu): ~15 seconds

**Functional Tests** (command execution):
- Simulation mode: 2-5 minutes (45 commands)
- Full mode (with API key): 10-20 minutes (45 commands)
- CI mode (subset, 20 commands): 5-10 minutes

**Multi-Environment Tests**:
- Docker + macOS: ~15 minutes total
- Full matrix (3 environments × 2 Node versions): ~30 minutes total

### Test Pass Rate Expectations

**Target**: ≥90% pass rate
**Typical**: 95-98% pass rate in clean environments

**Lower pass rates may indicate**:
- API key issues (use simulation mode)
- Git context missing (run in git repo)
- Timeout too aggressive (increase timeout)
- Network issues (check connectivity)
- Platform-specific issues (check known issues above)

---

## Planned Improvements

### Short-Term (Next 2-4 Weeks)

- [ ] **Optimize slow commands** - Reduce execution time for long-running commands
- [ ] **Better timeout detection** - Distinguish between true timeouts vs normal long operations
- [ ] **Enhanced simulation mode** - More realistic validation without API calls
- [ ] **Improved error messages** - Clearer guidance when tests fail

### Medium-Term (1-3 Months)

- [ ] **Parallel test execution** - Run tests concurrently for faster execution
- [ ] **Incremental testing** - Only test changed plugins/commands
- [ ] **Test result caching** - Skip tests for unchanged code
- [ ] **Visual test reports** - HTML/dashboard for test results

### Long-Term (3-6 Months)

- [ ] **Integration test suite** - Test plugin interactions and workflows
- [ ] **Performance benchmarking** - Track command execution time trends
- [ ] **Automated video testing** - Validate demo videos automatically
- [ ] **Cross-platform CI** - Test on Windows, macOS, Linux in CI

---

## Reporting New Issues

Found a bug or issue not listed here?

### Before Reporting

1. ✅ Check this document for known issues
2. ✅ Read QUICKSTART_TESTING.md troubleshooting section
3. ✅ Try workarounds listed above
4. ✅ Verify prerequisites are installed correctly
5. ✅ Test in Docker (cleanest environment)

### What to Include

When opening a GitHub issue, please include:

**Environment**:
- Platform: Docker / macOS / Ubuntu (specify version)
- Node version: `node --version`
- Claude Code version: `claude --version`
- Python version: `python3 --version`

**Reproduction**:
- Full command that failed
- Complete error message
- Steps to reproduce consistently

**Workaround** (if you found one):
- What did you try?
- What worked?
- Any side effects?

**Expected vs Actual**:
- What did you expect to happen?
- What actually happened?
- Why is this a problem?

### Where to Report

- **Bugs**: https://github.com/applied-artificial-intelligence/claude-code-plugins/issues
- **Questions**: https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions
- **Security**: Email security@applied-ai.com (do not open public issue)

---

## Issue Status Legend

- ✅ **Documented** - Expected behavior, documented workaround
- ⚠️ **Known Limitation** - Will not fix, use workaround
- 🔧 **In Progress** - Actively working on fix
- 📋 **Planned** - Will fix in future release
- ❌ **Blocked** - Waiting on external dependency

---

## Contributing Fixes

Want to help fix these issues?

1. Fork the repository
2. Create feature branch: `git checkout -b fix/issue-name`
3. Make changes and add tests
4. Verify tests pass: `python3 test_suite_oss.py`
5. Submit pull request with:
   - Description of issue being fixed
   - How the fix works
   - Test coverage for the fix
   - Updated documentation if needed

See `CONTRIBUTING.md` for complete guidelines.

---

## Changelog

**2025-10-23**: Initial known issues documentation
- Documented 6 major issue categories
- Added platform-specific gotchas
- Included workarounds for all known issues
- Planned improvements roadmap

---

**Feedback**: If you encounter an issue not listed here, please help us improve this document by opening an issue or pull request.

**Philosophy**: We believe in transparent communication about what works and what doesn't. This document reflects our commitment to honest documentation and continuous improvement.
