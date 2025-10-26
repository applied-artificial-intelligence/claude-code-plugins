#!/bin/bash
# AI Cost Guard Hook
# Triggers: tool-call-Edit, tool-call-Write
# Purpose: Estimate API costs for AI operations and alert on expensive patterns

set -euo pipefail

FILE_PATH="${1:-}"
TEMP_CONTENT="${2:-}"

# Only check Python files
if [[ ! "$FILE_PATH" =~ \.py$ ]]; then
    exit 0
fi

# Read file content
CONTENT=""
if [[ -n "$TEMP_CONTENT" && -f "$TEMP_CONTENT" ]]; then
    CONTENT=$(cat "$TEMP_CONTENT")
elif [[ -f "$FILE_PATH" ]]; then
    CONTENT=$(cat "$FILE_PATH")
else
    exit 0
fi

# Detection patterns
ALERTS=()

# Check for expensive embedding operations
if echo "$CONTENT" | grep -q "text-embedding-ada-002"; then
    ALERTS+=('⚠️  Using text-embedding-ada-002 ($0.10/1M tokens)')
    ALERTS+=('   💡 Recommendation: Switch to text-embedding-3-small ($0.02/1M) - 5x cheaper, better quality')
fi

# Check for batch processing without explicit limits
if echo "$CONTENT" | grep -qE "(embeddings\.create|chat\.completions\.create)" && \
   echo "$CONTENT" | grep -qE "for .* in .*:" && \
   ! echo "$CONTENT" | grep -qE "(batch_size|chunk|limit)"; then
    ALERTS+=('⚠️  Detected unbounded loop with API calls')
    ALERTS+=('   💡 Add batch_size limit to prevent cost spirals')
    ALERTS+=('   Example: for batch in chunks(items, batch_size=100):')
fi

# Check for GPT-4 in production code (expensive)
if echo "$CONTENT" | grep -qE 'model=["\x27]gpt-4["\x27]' && \
   [[ "$FILE_PATH" =~ (main|app|server|api) ]]; then
    ALERTS+=("💰 Using GPT-4 (\$30/1M tokens) in production code: $FILE_PATH")
    ALERTS+=('   💡 Consider: gpt-4-turbo ($10/1M, 3x cheaper) or gpt-3.5-turbo ($0.50/1M, 60x cheaper)')
fi

# Estimate costs for large-scale operations
if echo "$CONTENT" | grep -qE "range\([0-9]{4,}"; then
    RANGE=$(echo "$CONTENT" | grep -oE "range\([0-9]+" | head -1 | grep -oE "[0-9]+")
    if [[ -n "$RANGE" && "$RANGE" -gt 1000 ]]; then
        # Check if this loop calls expensive APIs
        if echo "$CONTENT" | grep -qE "(gpt-4|claude-3-opus)"; then
            EST_K=$(awk "BEGIN {printf \"%.1f\", $RANGE / 1000}")
            EST_COST=$(awk "BEGIN {printf \"%.0f\", $RANGE / 1000 * 0.03}")
            ALERTS+=("🚨 HIGH COST DETECTED: ~${EST_K}k API calls with GPT-4")
            ALERTS+=("   Estimated cost: \$$EST_COST (assuming 1k tokens/call)")
            ALERTS+=('   💡 Consider: Switch to gpt-3.5-turbo or add confirm() prompt')
        fi
    fi
fi

# Check for missing retry/error handling on expensive calls
if echo "$CONTENT" | grep -qE "(gpt-4|claude-3-opus)" && \
   ! echo "$CONTENT" | grep -qE "(try:|except|retry|tenacity)"; then
    ALERTS+=('⚠️  Expensive API calls without error handling')
    ALERTS+=('   💡 Add retry logic to prevent wasted money on transient failures')
fi

# Check for embeddings on large datasets without caching
if echo "$CONTENT" | grep -qE "embeddings\.create" && \
   echo "$CONTENT" | grep -qE "(read_csv|load_dataset|open\()" && \
   ! echo "$CONTENT" | grep -qE "(cache|@lru_cache|joblib\.Memory|shelve)"; then
    ALERTS+=('💾 Generating embeddings without caching detected')
    ALERTS+=('   💡 Add caching to avoid regenerating embeddings (saves $$ on re-runs)')
    ALERTS+=('   Example: from functools import lru_cache')
fi

# Output alerts if any
if [[ ${#ALERTS[@]} -gt 0 ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🤖 AI Cost Guard - Potential Cost Issues"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    printf '%s\n' "${ALERTS[@]}"
    echo ""
    echo "File: $FILE_PATH"
    echo ""
    echo "💡 Tip: These are warnings, not errors. Review and optimize as needed."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

# Always allow (non-blocking hook)
exit 0
