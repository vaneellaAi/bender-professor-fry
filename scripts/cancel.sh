#!/bin/bash

# Cancel Bender Script
# Sets the loop state to inactive
# "We're boned!" - Bender

set -euo pipefail

EXTENSION_DIR="$HOME/.gemini/extensions/bender"
SESSION_DIR=$("$EXTENSION_DIR/scripts/get_session.sh" "$PWD" 2>/dev/null || true)

if [[ -z "$SESSION_DIR" ]]; then
  echo "❌ No active session found for current directory ($PWD)" >&2
  exit 1
fi

STATE_FILE="$SESSION_DIR/state.json"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "❌ No active Bender loop found" >&2
  echo "   State file not found: $STATE_FILE" >&2
  exit 1
fi

# Check CWD
SESSION_CWD=$(jq -r '.working_dir // empty' "$STATE_FILE")
if [[ -n "$SESSION_CWD" ]]; then
  if [[ "$PWD" != "$SESSION_CWD" ]]; then
    # Physical Path Comparison
    PHYSICAL_PWD=$(cd "$PWD" && pwd -P 2>/dev/null || echo "$PWD")
    PHYSICAL_SESSION_CWD=$(cd "$SESSION_CWD" && pwd -P 2>/dev/null || echo "$SESSION_CWD")

    if [[ "$PHYSICAL_PWD" != "$PHYSICAL_SESSION_CWD" ]]; then
      echo "❌ Cancelling Bender failed: You are in a different directory ($PWD) than the active session ($SESSION_CWD)." >&2
      exit 1
    fi
  fi
fi

# Update state file to set active: false using jq for safe JSON modification
TMP_STATE=$(mktemp)
if jq '.active = false' "$STATE_FILE" > "$TMP_STATE"; then
  mv "$TMP_STATE" "$STATE_FILE"
else
  rm -f "$TMP_STATE"
  echo "❌ Failed to update state file" >&2
  exit 1
fi

echo "✅ Bender cancelled. Kill all humans later!"
echo "State file: $STATE_FILE"