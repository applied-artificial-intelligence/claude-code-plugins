# AI/ML Development Hooks for Claude Code

**Purpose**: Proactive prevention of costly mistakes in AI/ML development workflows

These hooks catch expensive issues *before* they happen - saving time, money, and GPU resources.

---

## Overview

**Traditional tools** (linters, formatters): Catch syntax errors after you write code
**These hooks**: Prevent domain-specific AI/ML disasters before they occur

| Hook | Prevents | Saves |
|------|----------|-------|
| **AI Cost Guard** | API cost spirals, inefficient model choices | $100s in unnecessary API costs |
| **GPU Memory Guard** | Out-of-memory errors, wrong model sizes | Hours of debugging, failed training runs |

---

## Hook 1: AI Cost Guard

**File**: `ai-cost-guard.sh`
**Triggers**: `tool-call-Edit`, `tool-call-Write` (on `.py` files)
**Purpose**: Estimate and alert on expensive AI API patterns

### What It Catches

1. **Outdated expensive models**
   - Detects: `text-embedding-ada-002` ($0.10/1M tokens)
   - Recommends: `text-embedding-3-small` ($0.02/1M - 5x cheaper)

2. **Unbounded API loops**
   - Detects: `for item in items:` + `client.create()`
   - Alerts: Add `batch_size` limit to prevent cost spirals

3. **Expensive models in production**
   - Detects: `gpt-4` in `main.py`, `app.py`, `server.py`
   - Recommends: `gpt-4-turbo` (3x cheaper) or `gpt-3.5-turbo` (60x cheaper)

4. **High-volume operations**
   - Detects: `range(10000)` with GPT-4 calls
   - Estimates: "~$300 cost for this operation"

5. **Missing error handling**
   - Detects: Expensive API calls without try/except
   - Alerts: Add retry logic to prevent wasted money

6. **Missing caching**
   - Detects: Embeddings generation on datasets without caching
   - Recommends: Add `@lru_cache` or `joblib.Memory`

### Example Output

```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🤖 AI Cost Guard - Potential Cost Issues
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  Using text-embedding-ada-002 ($0.10/1M tokens)
   💡 Recommendation: Switch to text-embedding-3-small ($0.02/1M) - 5x cheaper, better quality

💰 Using GPT-4 ($30/1M tokens) in production code: app/main.py
   💡 Consider: gpt-4-turbo ($10/1M, 3x cheaper) or gpt-3.5-turbo ($0.50/1M, 60x cheaper)

⚠️  Detected unbounded loop with API calls
   💡 Add batch_size limit to prevent cost spirals
   Example: for batch in chunks(items, batch_size=100):

💾 Generating embeddings without caching detected
   💡 Add caching to avoid regenerating embeddings (saves $$ on re-runs)
   Example: from functools import lru_cache

File: app/rag_pipeline.py

💡 Tip: These are warnings, not errors. Review and optimize as needed.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Real-World Impact

**Scenario**: Building RAG system for 100k documents

**Without hook**:
```python
# Uses outdated model
for doc in documents:  # 100k documents
    emb = openai.embeddings.create(
        model="text-embedding-ada-002",  # $0.10/1M
        input=doc.content
    )
# Cost: ~$150 (assuming 1.5M tokens total)
```

**With hook** (alerts you immediately):
```python
# Hook suggests: Switch to text-embedding-3-small
for doc in documents:
    emb = openai.embeddings.create(
        model="text-embedding-3-small",  # $0.02/1M
        input=doc.content
    )
# Cost: ~$30 (5x cheaper)
```

**Saved**: $120 on first run, $120 on every subsequent run

---

## Hook 2: GPU Memory Guard

**File**: `gpu-memory-guard.sh`
**Triggers**: `tool-call-Edit`, `tool-call-Write` (on `.py` files)
**Purpose**: Validate model sizes fit in GPU memory before OOM errors

### What It Catches

1. **Model too large for GPU**
   - Detects: `llama-2-70b` loading (140GB required)
   - Checks: Available GPU memory (e.g., 24GB)
   - Alerts: "WARNING: 24GB < 140GB required"
   - Suggests: 4-bit quantization (75% memory reduction)

2. **Missing quantization for large models**
   - Detects: Loading >20GB model without `load_in_4bit` or `load_in_8bit`
   - Recommends: Quantization config to reduce memory

3. **Large batch sizes**
   - Detects: `batch_size=64` with large models
   - Recommends: Start small (batch_size=8), increase gradually

4. **Missing device_map**
   - Detects: Large model loading without `device_map='auto'`
   - Recommends: Automatic multi-GPU distribution

5. **Gradient accumulation opportunities**
   - Detects: Small batch size (memory constrained)
   - Suggests: Use `gradient_accumulation_steps` for effective larger batches

### Example Output

```bash
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎮 GPU Memory Guard - Model Size Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Available GPU Memory: 24GB

🔍 Detected model: meta-llama/Llama-2-70b-hf
   Size: ~140GB (fp16), Recommended GPU: 160GB+
   🚨 WARNING: Available GPU memory (24GB) < Required (160GB)
   💡 Solutions:
      1. Use 4-bit quantization: load_in_4bit=True (75% memory reduction)
      2. Use 8-bit quantization: load_in_8bit=True (50% memory reduction)
      3. Use smaller model variant

💡 Tip: Consider 4-bit quantization for 140GB model:
      quantization_config = BitsAndBytesConfig(load_in_4bit=True)
      Reduces to ~35GB with minimal quality loss

⚠️  Large model loading without device_map
   💡 Add: device_map='auto' for automatic multi-GPU distribution
   Example: model = AutoModel.from_pretrained(..., device_map='auto')

File: train_llm.py

💡 These are warnings to help prevent OOM errors. Not blocking.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Real-World Impact

**Scenario**: Fine-tuning LLaMA-2-70B on single GPU

**Without hook**:
```python
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-70b-hf"
)
# Result: torch.cuda.OutOfMemoryError
# Time wasted: 20 minutes downloading model + debugging
```

**With hook** (catches immediately):
```python
# Hook alerts: "24GB < 160GB required, use 4-bit quantization"
from transformers import BitsAndBytesConfig

quantization_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype=torch.float16
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-70b-hf",
    quantization_config=quantization_config,
    device_map="auto"
)
# Result: Fits in 24GB, trains successfully
```

**Saved**: Hours of debugging, failed training runs, GPU resource waste

---

## Installation

### Step 1: Copy hooks to your project

```bash
# Copy both hooks
cp ~/applied-ai/claude-code-plugins/hooks/ai-cost-guard.sh ~/.claude/hooks/
cp ~/applied-ai/claude-code-plugins/hooks/gpu-memory-guard.sh ~/.claude/hooks/

# Make executable
chmod +x ~/.claude/hooks/*.sh
```

### Step 2: Configure in Claude Code settings

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "tool-call-Edit": [
      "~/.claude/hooks/ai-cost-guard.sh \"$FILE_PATH\" \"$TEMP_PATH\"",
      "~/.claude/hooks/gpu-memory-guard.sh \"$FILE_PATH\" \"$TEMP_PATH\""
    ],
    "tool-call-Write": [
      "~/.claude/hooks/ai-cost-guard.sh \"$FILE_PATH\" \"$TEMP_PATH\"",
      "~/.claude/hooks/gpu-memory-guard.sh \"$FILE_PATH\" \"$TEMP_PATH\""
    ]
  }
}
```

### Step 3: Test the hooks

**Test AI Cost Guard**:
```bash
# Create test file with expensive pattern
cat > test_cost.py << 'EOF'
import openai

# This will trigger cost alerts
for i in range(10000):
    response = openai.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": "test"}]
    )
EOF

# Edit file in Claude Code
# Hook will alert on expensive pattern
```

**Test GPU Memory Guard**:
```bash
# Create test file with large model
cat > test_gpu.py << 'EOF'
from transformers import AutoModelForCausalLM

# This will trigger GPU memory alert
model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-2-70b-hf"
)
EOF

# Edit file in Claude Code
# Hook will alert on memory requirements
```

---

## Hook Design Philosophy

### Why Non-Blocking?

Both hooks return `exit 0` (allow operation) rather than blocking. Here's why:

1. **Advisory, not prescriptive** - Alerts help you make informed decisions
2. **Context matters** - Sometimes you *do* need GPT-4 or large models
3. **Learning tool** - Teaches best practices without forcing them
4. **No workflow interruption** - Keep coding, review alerts when ready

### When to Make Blocking

You can make hooks blocking (`exit 1`) for specific conditions:

**Example: Block production code with unbounded loops**
```bash
# In ai-cost-guard.sh
if [[ "$FILE_PATH" =~ (main|app|server) ]] && \
   # Detected unbounded loop with expensive API
then
    echo "🚨 BLOCKED: Unbounded API loop in production code"
    exit 1  # Block the operation
fi
```

### Extensibility

Add your own checks:

**Cost thresholds**:
```bash
if [[ "$ESTIMATED_COST" -gt 100 ]]; then
    echo "🚨 Operation exceeds $100 cost threshold"
    exit 1  # Require manual review
fi
```

**Team-specific rules**:
```bash
# Enforce: Always use gpt-3.5-turbo in dev, gpt-4 only in prod
if [[ "$FILE_PATH" =~ dev/ ]] && grep -q "gpt-4"; then
    echo "🚨 Dev code must use gpt-3.5-turbo"
    exit 1
fi
```

---

## Advanced Patterns

### Pattern 1: Cost Budget Enforcement

Track cumulative costs across project:

```bash
# In ai-cost-guard.sh
COST_LOG="$HOME/.claude/cost_tracking.json"

# Log estimated costs
echo "{\"file\": \"$FILE_PATH\", \"estimated_cost\": $ESTIMATED_COST, \"timestamp\": $(date +%s)}" >> "$COST_LOG"

# Check monthly budget
MONTHLY_COST=$(jq -s 'map(select(.timestamp > (now - 2592000)) | .estimated_cost) | add' "$COST_LOG")
if (( $(echo "$MONTHLY_COST > 500" | bc -l) )); then
    echo "🚨 Monthly cost budget ($500) exceeded: $$MONTHLY_COST"
    exit 1
fi
```

### Pattern 2: Model Registry Integration

Fetch model sizes from external registry:

```bash
# In gpu-memory-guard.sh
MODEL_REGISTRY="https://huggingface.co/api/models/$MODEL_NAME"

# Fetch actual model size
MODEL_INFO=$(curl -s "$MODEL_REGISTRY")
MODEL_SIZE=$(echo "$MODEL_INFO" | jq '.modelSize' | awk '{print int($1/1e9)}')  # Convert to GB
```

### Pattern 3: Team Notifications

Alert team when expensive operations detected:

```bash
# In ai-cost-guard.sh
if [[ "$ESTIMATED_COST" -gt 50 ]]; then
    # Send Slack notification
    curl -X POST "$SLACK_WEBHOOK_URL" \
        -H 'Content-Type: application/json' \
        -d "{\"text\": \"💰 High-cost operation detected: \$$ESTIMATED_COST in $FILE_PATH\"}"
fi
```

---

## Comparison with Other Tools

| Tool | Focus | When It Runs | What It Catches |
|------|-------|--------------|-----------------|
| **ruff/mypy** | Syntax, types | After code written | `undefined_var`, `type_mismatch` |
| **pytest** | Logic correctness | Manual test run | Business logic bugs |
| **AI Cost Guard** | API costs | During coding (live) | Expensive patterns, inefficiencies |
| **GPU Memory Guard** | Hardware limits | During coding (live) | OOM errors, model size mismatches |

**Key difference**: Traditional tools catch *coding mistakes*. These hooks catch *domain-specific disasters*.

---

## Metrics & Impact

### Quantified Savings (Estimated)

**For a typical AI/ML team (5 engineers)**:

**AI Cost Guard**:
- Prevents: 2-3 cost optimization opportunities per week
- Average savings: $50-150 per catch
- Annual impact: **$5,000-$15,000 saved**

**GPU Memory Guard**:
- Prevents: 1-2 OOM errors per engineer per week
- Time saved: 30-60 min debugging each
- Annual impact: **250-500 hours saved** (equivalent to $25k-$50k at $100/hr)

**Total**: $30k-$65k value per year for a 5-person team

---

## Future Hooks (Ideas)

**Dataset Staleness Guard**:
```bash
# Alert if dataset >90 days old
if [[ $(find data/train.csv -mtime +90) ]]; then
    echo "⚠️  Training data is 90+ days old"
fi
```

**Citation Validator** (for academic/research work):
```bash
# Check for citation markers without references
if grep -q '\[1\]' && ! grep -q 'References'; then
    echo "⚠️  Found citations but no reference list"
fi
```

**Experiment Tracker**:
```bash
# Auto-log experiments to MLflow
if [[ "$COMMAND" =~ python.*train\.py ]]; then
    mlflow run . --params "$DETECTED_PARAMS"
fi
```

---

## Contributing

To add new hooks or improve existing ones:

1. Fork the repository
2. Add hook script to `hooks/`
3. Update this README with documentation
4. Test with real AI/ML workflows
5. Submit PR with examples of catches

**Guidelines**:
- Make hooks fast (<100ms runtime)
- Keep alerts actionable (include fix suggestions)
- Default to non-blocking (advisory mode)
- Include real-world impact metrics

---

## License

MIT License - Free to use, modify, and distribute.

---

## Credits

Created by Applied Artificial Intelligence
- **AI Cost Guard**: Prevents API cost spirals
- **GPU Memory Guard**: Prevents OOM errors

**Philosophy**: Proactive prevention beats reactive debugging.

---

**Last Updated**: 2024-10-26
**Version**: 1.0.0
