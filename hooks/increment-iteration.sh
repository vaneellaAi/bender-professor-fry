#!/bin/bash

# Increment Iteration Hook for Bender
# Runs at BeforeAgent to ensure the iteration counter is updated
# before the agent starts its loop.
# "One more iteration closer to being the greatest!"

set -euo pipefail

# --- Configuration ---
HOOK_NAME="IncrementIteration"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# --- Main Execution ---

# 1. Read and Validate Input
read_and_validate_input

# 2. Determine State File Path
if ! resolve_state_file; then
  # No state file means not in a pickle loop, just allow
  allow_and_exit
fi

# 3. Read State and Increment
STATE_CONTENT=$(cat "$STATE_FILE" 2>/dev/null || echo "{}")
ACTIVE=$(echo "$STATE_CONTENT" | jq -r '.active // false')

# 4. Check Working Directory Context
SESSION_CWD=$(echo "$STATE_CONTENT" | jq -r '.working_dir // empty')
log "Context Check: PWD='$PWD' SESSION_CWD='$SESSION_CWD'"

if ! validate_cwd "$SESSION_CWD"; then
  allow_and_exit
fi

if [[ "$ACTIVE" == "true" ]]; then
  ITERATION=$(echo "$STATE_CONTENT" | jq -r '.iteration // 0')

  # Validate Iteration is a Number
  if ! [[ "$ITERATION" =~ ^[0-9]+$ ]]; then
    log "Error: Invalid iteration value '$ITERATION'. Resetting to 1."
    ITERATION=0
  fi

  NEXT_ITERATION=$((ITERATION + 1))

  log "Incrementing iteration from $ITERATION to $NEXT_ITERATION"

  TMP_STATE=$(mktemp)
  if jq --argjson iter "$NEXT_ITERATION" '.iteration = $iter' "$STATE_FILE" > "$TMP_STATE"; then
    mv "$TMP_STATE" "$STATE_FILE"
  else
    log "Error: Failed to update state file"
    rm -f "$TMP_STATE"
  fi
fi

# 5. Allow continuation
allow_and_exit
