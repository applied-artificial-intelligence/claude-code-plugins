---
description: Format code files using external tools with AI validation
tags: [format, integration, tools]
---

# Format Command

Demonstrates integration with external formatting tools and agent validation.

## Implementation

```bash
#!/bin/bash

# Get file path from arguments
FILE_PATH="$ARGUMENTS"

if [ -z "$FILE_PATH" ]; then
    echo "ERROR: File path required" >&2
    echo "Usage: /format <file-path>" >&2
    exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "ERROR: File not found: $FILE_PATH" >&2
    exit 1
fi

# Detect file type
FILE_EXT="${FILE_PATH##*.}"

echo "🎨 Formatting: $FILE_PATH"
echo "File type: $FILE_EXT"
echo ""

# Format based on file type
case "$FILE_EXT" in
    js|jsx|ts|tsx|json)
        if command -v prettier >/dev/null 2>&1; then
            echo "Using: Prettier"
            prettier --write "$FILE_PATH"
            echo "✅ Formatted with Prettier"
        else
            echo "⚠️ Prettier not installed"
            echo "Install: npm install -g prettier"
        fi
        ;;

    py)
        if command -v black >/dev/null 2>&1; then
            echo "Using: Black"
            black "$FILE_PATH"
            echo "✅ Formatted with Black"
        else
            echo "⚠️ Black not installed"
            echo "Install: pip install black"
        fi
        ;;

    *)
        echo "⚠️ No formatter configured for .$FILE_EXT files"
        echo "Supported: .js, .jsx, .ts, .tsx, .json (Prettier), .py (Black)"
        exit 1
        ;;
esac

echo ""
echo "💡 For style recommendations, use: /agent style-checker \"$FILE_PATH\""
```

## Key Concepts

### 1. External Tool Integration
- Check tool availability with `command -v`
- Provide installation instructions
- Handle missing tools gracefully

### 2. File Type Detection
```bash
FILE_EXT="${FILE_PATH##*.}"  # Extract extension
```

### 3. Tool Selection
- Match formatters to file types
- Use industry-standard tools
- Suggest alternatives when missing

### 4. Agent Integration
- Command handles mechanical formatting
- Agent provides strategic recommendations
- Separation of concerns

## Usage

```bash
# Format JavaScript
/format src/app.js

# Format Python
/format scripts/deploy.py

# Format TypeScript
/format components/Header.tsx
```

## With Agent Validation

```bash
# 1. Format file
/format src/utils.js

# 2. Get style recommendations
/agent style-checker "src/utils.js"
```
