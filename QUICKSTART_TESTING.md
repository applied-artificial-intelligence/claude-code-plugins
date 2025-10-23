# Quickstart Testing Guide

Complete guide to running the claude-code-plugins test suite. This guide assumes zero prior knowledge and provides copy-paste commands for all platforms.

## Prerequisites

### Required Software

1. **Node.js** (v20 or v22)
   - Install via [nvm](https://github.com/nvm-sh/nvm) (recommended)
   - Or download from [nodejs.org](https://nodejs.org/)

2. **Claude Code**
   - Install globally: `npm install -g @anthropic-ai/claude-code`
   - Requires Max plan or API key

3. **Docker** (for Docker testing)
   - Install from [docker.com](https://www.docker.com/get-started)
   - Ensure Docker daemon is running

4. **Python 3.11+** (for functional tests)
   - macOS: Pre-installed or via Homebrew
   - Ubuntu: `sudo apt install python3 python3-pip`

### Optional

- **ANTHROPIC_API_KEY** (for full functional testing)
  - Without API key: Tests run in simulation mode
  - With API key: Full command execution and validation

## Quick Start (3 Commands)

**For impatient users** - Get test results immediately:

```bash
# 1. Clone repository
git clone https://github.com/applied-artificial-intelligence/claude-code-plugins.git
cd claude-code-plugins

# 2. Run smoke tests
./tests/smoke.sh

# 3. Run functional tests (simulation mode)
cd tests && python3 test_suite_oss.py --simulation
```

**Expected output**: Smoke tests should show "✓ All plugin manifests found and valid", functional tests should report pass/fail for 45 commands.

## Platform-Specific Instructions

### Docker Testing (Recommended)

**Why Docker?** Cleanest environment, reproducible across machines, CI-compatible.

#### Build Docker Image

```bash
# Build image (takes 5-10 minutes first time)
cd tests
docker compose build

# Or build specific Node version
docker compose build claude-tester-node22
docker compose build claude-tester-node20
```

#### Run Tests in Docker

```bash
# Start container
docker compose up -d claude-tester-node22

# Run smoke tests
docker exec claude-tester-node22 bash -c '. ~/.nvm/nvm.sh && claude --version && claude doctor'

# Run functional tests (simulation mode)
docker exec claude-tester-node22 bash -c '. ~/.nvm/nvm.sh && cd /workspace/tests && python3 test_suite_oss.py --simulation'

# Stop container
docker compose down
```

#### Run Tests with API Key

```bash
# Set API key in environment
export ANTHROPIC_API_KEY="your_api_key_here"

# Pass API key to container
docker exec -e ANTHROPIC_API_KEY claude-tester-node22 bash -c '. ~/.nvm/nvm.sh && cd /workspace/tests && python3 test_suite_oss.py'
```

#### Stop and Clean Up

```bash
# Stop containers
docker compose down

# Remove volumes (clean slate)
docker compose down -v

# Remove images
docker rmi claude-code-plugins-test:latest
```

### macOS Testing

#### Setup

```bash
# 1. Install nvm (if not already installed)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 2. Reload shell
source ~/.zshrc  # or ~/.bash_profile

# 3. Install Node.js LTS
nvm install 22
nvm use 22

# 4. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 5. Verify installation
claude --version
claude doctor
```

#### Run Tests

```bash
# Navigate to repository
cd ~/path/to/claude-code-plugins

# Run smoke tests
./tests/smoke.sh

# Run functional tests (simulation mode)
cd tests
python3 test_suite_oss.py --simulation

# Run with API key (full execution)
export ANTHROPIC_API_KEY="your_api_key_here"
python3 test_suite_oss.py
```

### Ubuntu Testing

#### Setup

```bash
# 1. Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 2. Reload shell
source ~/.bashrc

# 3. Install Node.js LTS
nvm install 22
nvm use 22

# 4. Install Claude Code
npm install -g @anthropic-ai/claude-code

# 5. Install Python dependencies (if needed)
sudo apt update
sudo apt install -y python3 python3-pip

# 6. Verify installation
claude --version
claude doctor
```

#### Run Tests

```bash
# Navigate to repository
cd ~/claude-code-plugins

# Run smoke tests
./tests/smoke.sh

# Run functional tests (simulation mode)
cd tests
python3 test_suite_oss.py --simulation

# Run with API key (full execution)
export ANTHROPIC_API_KEY="your_api_key_here"
python3 test_suite_oss.py
```

## Understanding Results

### Smoke Tests

**Purpose**: Fast sanity checks (< 1 minute)

**What it checks**:
- Claude Code installation
- Plugin manifests exist and are valid JSON
- Basic CLI functionality

**Expected output**:
```
Checking plugin manifests...
✓ Found: plugins/system/.claude-plugin/plugin.json
  → Valid JSON
✓ Found: plugins/workflow/.claude-plugin/plugin.json
  → Valid JSON
...
✓ All plugin manifests found and valid
```

**Failure examples**:
- `✗ Missing: plugins/xyz/.claude-plugin/plugin.json` → Plugin manifest missing
- `→ Invalid JSON` → Manifest has syntax errors

### Functional Tests

**Purpose**: Validate command execution (2-10 minutes depending on mode)

**Test modes**:
- **Simulation mode** (`--simulation` flag): Fast validation without API calls
- **Full mode** (requires API key): Real command execution with Claude

**Expected output (simulation)**:
```
Testing 45 commands across 5 plugins...
✓ /workflow:explore - Command exists, manifest valid
✓ /workflow:plan - Command exists, manifest valid
✓ /workflow:next - Command exists, manifest valid
...
✓ Test framework loaded
⚠ Simulation mode: Validating command catalog only
→ 45/45 commands validated (100% coverage)
```

**Expected output (full mode with API key)**:
```
Testing /workflow:status...
  ✓ Command executed successfully
  ✓ Output contains expected keywords: ['status', 'project', 'tasks']
  ✓ Execution time: 2.3s

Testing /development:analyze...
  ✓ Command executed successfully
  ✓ Output contains expected keywords: ['codebase', 'structure']
  ✗ FAILED: Timeout after 30s

Test Results:
  Passed: 43/45 (95.6%)
  Failed: 2/45 (4.4%)
  Coverage: 100% (45 commands tested)
```

### Test Matrix

**Purpose**: Track results across environments and Node versions

**View test matrix**:
```bash
# After running tests
cat tests/test_matrix.md
```

**Example matrix**:

| Environment | Node | Install | Commands | Happy Path | MCP |
|-------------|------|---------|----------|------------|-----|
| Docker      | v22  | ✅ 5/5  | ✅ 45/45 | ✅ 97%    | ✅  |
| Docker      | v20  | ✅ 5/5  | ✅ 45/45 | ✅ 96%    | ✅  |
| macOS       | v22  | ✅ 5/5  | ✅ 45/45 | ✅ 98%    | ✅  |

## Troubleshooting

### Common Issues

#### 1. Docker Not Running

**Error**: `Cannot connect to the Docker daemon`

**Fix**:
```bash
# macOS: Open Docker Desktop app
open -a Docker

# Linux: Start Docker daemon
sudo systemctl start docker
```

#### 2. API Key Missing

**Error**: `⚠ Real command execution requires ANTHROPIC_API_KEY`

**Fix**: Run in simulation mode (no API calls) or set API key:
```bash
export ANTHROPIC_API_KEY="your_api_key_here"
```

#### 3. Node Version Mismatch

**Error**: `Node version v18.x.x not supported, please use v20 or v22`

**Fix**:
```bash
# Install correct version
nvm install 22
nvm use 22

# Verify
node --version  # Should show v22.x.x
```

#### 4. Permission Errors

**Error**: `EACCES: permission denied, mkdir '/usr/local/lib/node_modules'`

**Fix**: Use nvm (recommended) instead of system Node:
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Then follow nvm setup steps above
```

#### 5. Plugin Manifests Not Found

**Error**: `✗ Missing: plugins/xyz/.claude-plugin/plugin.json`

**Fix**: Ensure you're in the repository root:
```bash
pwd  # Should show .../claude-code-plugins
ls plugins/  # Should show: development memory system workflow agents
```

#### 6. Claude Code Not Found

**Error**: `claude: command not found`

**Fix**: Ensure Claude Code is installed globally:
```bash
# Install Claude Code
npm install -g @anthropic-ai/claude-code

# Verify
which claude  # Should show path to claude binary
claude --version  # Should show version number
```

#### 7. Tests Timeout

**Error**: `⏱ Timeout after 30s`

**Causes**:
- Command requires user permission (can't run non-interactively)
- Claude Code waiting for input
- Network/API issues

**Fix**: Check `KNOWN_ISSUES.md` for documented command timeouts

#### 8. Python Not Found (Docker)

**Error**: `python3: command not found` in Docker container

**Fix**: Python should be pre-installed in Docker image. Rebuild image:
```bash
docker compose down
docker compose build --no-cache
```

### Getting Help

**Before asking for help**, please:
1. ✅ Read this guide completely
2. ✅ Check `KNOWN_ISSUES.md` for documented issues
3. ✅ Try in Docker (cleanest environment)
4. ✅ Verify prerequisites are installed

**Where to get help**:
- **GitHub Issues**: https://github.com/applied-artificial-intelligence/claude-code-plugins/issues
- **Discussions**: https://github.com/applied-artificial-intelligence/claude-code-plugins/discussions

**What to include in bug reports**:
- Platform (Docker/macOS/Ubuntu)
- Node version (`node --version`)
- Claude Code version (`claude --version`)
- Full error message
- Steps to reproduce

## Advanced Usage

### Running Specific Test Suites

```bash
# Run only smoke tests
./tests/smoke.sh

# Run only functional tests
python3 tests/test_suite_oss.py --simulation

# Run tests for specific plugin
python3 tests/test_suite_oss.py --plugin workflow

# Run specific commands
python3 tests/test_suite_oss.py --commands "/workflow:explore,/workflow:plan"
```

### Multi-Environment Testing

```bash
# Test in all Docker environments
docker compose up -d
docker exec claude-tester-node22 bash -c '. ~/.nvm/nvm.sh && cd /workspace/tests && python3 test_suite_oss.py --simulation'
docker exec claude-tester-node20 bash -c '. ~/.nvm/nvm.sh && cd /workspace/tests && python3 test_suite_oss.py --simulation'
```

### Generating Test Reports

```bash
# Run tests with JSON output
python3 tests/test_suite_oss.py --simulation --output-json results.json

# View test matrix
cat tests/test_matrix.md

# View detailed logs
cat tests/logs/test_run_*.log
```

### CI/CD Integration

Tests run automatically on GitHub Actions:
- **Trigger**: Pull requests and pushes to main
- **Environments**: Docker (Ubuntu 24.04 + Node v22)
- **Tests**: Smoke + functional (subset of 20 high-priority commands)
- **Timeout**: 30 minutes
- **Reports**: Artifacts published to GitHub

**View CI results**: Check the "Actions" tab on GitHub

## Test Coverage

**Current coverage**: 100% (45 commands across 5 plugins)

**Plugins tested**:
1. **system** (4 commands): audit, cleanup, setup, status
2. **workflow** (4 commands): explore, plan, next, ship
3. **development** (6 commands): analyze, review, test, fix, run, git
4. **memory** (3 commands): index, memory-gc, memory-review
5. **agents** (2 commands): agent, serena

**Test types**:
- ✅ **Installation tests**: Plugin loads, commands register
- ✅ **Smoke tests**: Basic CLI functionality
- ✅ **Functional tests**: Command execution, output validation
- ✅ **Edge case tests**: Missing preconditions, invalid args, permissions
- ✅ **Performance tests**: Execution time, resource usage
- ✅ **Security tests**: No secrets in logs, safe operations
- ✅ **MCP integration tests**: Optional MCP tools work correctly

## Contributing Test Improvements

Found a bug? Want to improve tests?

1. Fork the repository
2. Add test cases in `tests/`
3. Update documentation if needed
4. Submit pull request with:
   - Description of what you're testing
   - Why it's important
   - Expected vs actual behavior

**Test philosophy**: Tests should be reliable, fast, and easy to understand. Prefer semantic validation (keywords, patterns) over exact output matching.

---

## Next Steps

- ✅ Tests passing? → Try the plugins in a real project
- ❌ Tests failing? → Check `KNOWN_ISSUES.md` for workarounds
- 💡 Found a bug? → Open an issue on GitHub
- 🚀 Ready to contribute? → See `CONTRIBUTING.md`

**Happy testing!** 🎉
