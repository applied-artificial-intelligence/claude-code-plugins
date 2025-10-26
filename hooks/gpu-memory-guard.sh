#!/bin/bash
# GPU Memory Guard Hook
# Triggers: tool-call-Edit, tool-call-Write
# Purpose: Validate model sizes fit in available GPU memory

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

# Check if nvidia-smi available
AVAILABLE_GPU_MEMORY=0
if command -v nvidia-smi &> /dev/null; then
    AVAILABLE_GPU_MEMORY=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits -i 0 2>/dev/null | awk '{print int($1/1024)}' || echo "0")
fi

ALERTS=()

# Detect large models (70B+) without quantization
if echo "$CONTENT" | grep -qE "(llama.*70b|mixtral.*8x22b)" && \
   ! echo "$CONTENT" | grep -qE "(load_in_4bit|load_in_8bit|quantization_config)"; then
    ALERTS+=('🔍 Detected large model (70B+ parameters)')
    if [[ "$AVAILABLE_GPU_MEMORY" -gt 0 && "$AVAILABLE_GPU_MEMORY" -lt 160 ]]; then
        ALERTS+=("   🚨 WARNING: Your GPU has ${AVAILABLE_GPU_MEMORY}GB memory")
        ALERTS+=('   70B models require ~140GB (fp16) or ~35GB (4-bit quantized)')
    fi
    ALERTS+=('   💡 Solution: Use 4-bit quantization')
    ALERTS+=('   quantization_config = BitsAndBytesConfig(load_in_4bit=True)')
    ALERTS+=('')
fi

# Detect medium models (13B-70B) - check for quantization recommendation
if echo "$CONTENT" | grep -qE "(llama.*13b|mistral.*7b.*8x|mixtral.*8x7b)" && \
   ! echo "$CONTENT" | grep -qE "(load_in_4bit|load_in_8bit)"; then
    if [[ "$AVAILABLE_GPU_MEMORY" -gt 0 && "$AVAILABLE_GPU_MEMORY" -lt 80 ]]; then
        ALERTS+=('🔍 Detected medium model (13B-56B parameters)')
        ALERTS+=("   Your GPU: ${AVAILABLE_GPU_MEMORY}GB")
        ALERTS+=('   💡 Tip: Consider 4-bit or 8-bit quantization for better memory efficiency')
        ALERTS+=('')
    fi
fi

# Check for large batch sizes
if echo "$CONTENT" | grep -qE "batch_size\s*=\s*[0-9]+" && \
   echo "$CONTENT" | grep -qE "(AutoModel|from_pretrained)"; then
    BATCH_SIZE=$(echo "$CONTENT" | grep -oE "batch_size\s*=\s*[0-9]+" | head -1 | grep -oE "[0-9]+")
    if [[ -n "$BATCH_SIZE" && "$BATCH_SIZE" -gt 32 ]]; then
        ALERTS+=("⚠️  Large batch size detected: $BATCH_SIZE")
        ALERTS+=('   💡 Tip: Start with batch_size=8 and increase until GPU memory full')
        ALERTS+=('   Use torch.cuda.OutOfMemoryError exception handling')
        ALERTS+=('')
    fi
fi

# Check for missing device_map when loading large models
if echo "$CONTENT" | grep -qE "(llama|mixtral|gpt)" && \
   echo "$CONTENT" | grep -qE "from_pretrained" && \
   ! echo "$CONTENT" | grep -qE "device_map"; then
    ALERTS+=('⚠️  Large model loading without device_map')
    ALERTS+=("   💡 Add: device_map='auto' for automatic GPU distribution")
    ALERTS+=("   Example: model = AutoModel.from_pretrained(..., device_map='auto')")
    ALERTS+=('')
fi

# Check for gradient accumulation opportunities
if echo "$CONTENT" | grep -qE "batch_size\s*=\s*[1-4]" && \
   echo "$CONTENT" | grep -qE "(Trainer|training_args|optimizer)" && \
   ! echo "$CONTENT" | grep -qE "gradient_accumulation"; then
    ALERTS+=('💡 Small batch size detected (memory constrained?)')
    ALERTS+=('   Tip: Use gradient accumulation for effective larger batches:')
    ALERTS+=('   gradient_accumulation_steps=4 → effective_batch = batch_size * 4')
    ALERTS+=('')
fi

# Output alerts if any
if [[ ${#ALERTS[@]} -gt 0 ]]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎮 GPU Memory Guard - Model Size Analysis"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    if [[ "$AVAILABLE_GPU_MEMORY" -gt 0 ]]; then
        echo "Available GPU Memory: ${AVAILABLE_GPU_MEMORY}GB"
    else
        echo "GPU Memory: Not detected (nvidia-smi unavailable)"
    fi
    echo ""
    printf '%s\n' "${ALERTS[@]}"
    echo "File: $FILE_PATH"
    echo ""
    echo "💡 These are warnings to help prevent OOM errors. Not blocking."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
fi

# Always allow (non-blocking hook)
exit 0
