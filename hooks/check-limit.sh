#!/bin/bash

# Check Limit Hook for Bender
# Blocks the model if time or iteration limits are reached.
# "Blackjack... and time limits!"

set -euo pipefail

# --- Configuration ---
HOOK_NAME="CheckLimit"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# --- Main Execution ---

# 1. Read and Validate Input
read_and_validate_input

# 2. Determine State File Path
if ! resolve_state_file; then
  allow_and_exit
fi

# 3. Read State
STATE_CONTENT=$(cat "$STATE_FILE" 2>/dev/null || echo "{}")
ACTIVE=$(echo "$STATE_CONTENT" | jq -r '.active // false')

# 4. Check Working Directory Context
SESSION_CWD=$(echo "$STATE_CONTENT" | jq -r '.working_dir // empty')
log "Context Check: PWD='$PWD' SESSION_CWD='$SESSION_CWD'"

if ! validate_cwd "$SESSION_CWD"; then
  allow_and_exit
fi

if [[ "$ACTIVE" != "true" ]]; then
  allow_and_exit
fi

ITERATION=$(echo "$STATE_CONTENT" | jq -r '.iteration // 0')
MAX_ITERATIONS=$(echo "$STATE_CONTENT" | jq -r '.max_iterations // 0')
MAX_TIME_MINS=$(echo "$STATE_CONTENT" | jq -r '.max_time_minutes // 0')
START_TIME=$(echo "$STATE_CONTENT" | jq -r '.start_time_epoch // 0')

# Sanity Check: Ensure START_TIME is valid
if [[ "$START_TIME" -le 0 ]]; then
  log "Warning: Invalid start time ($START_TIME). Allowing."
  allow_and_exit
fi

# 5. Check Termination Conditions

# 5a. Time Limit
CURRENT_TIME=$(date +%s)
ELAPSED_SECONDS=$((CURRENT_TIME - START_TIME))
MAX_TIME_SECONDS=$((MAX_TIME_MINS * 60))

if [[ "$MAX_TIME_MINS" -gt 0 ]] && [[ "$ELAPSED_SECONDS" -ge "$MAX_TIME_SECONDS" ]]; then
  log "Time limit reached. Blocking model."
  echo '{"decision":"deny","continue": false,"reason": "Time limit exceeded", "stopReason": "Time limit exceeded"}'
  exit 0
fi

# 5b. Max Iterations
if [[ "$MAX_ITERATIONS" -gt 0 ]] && [[ "$ITERATION" -gt "$MAX_ITERATIONS" ]]; then
  log "Max iterations reached ($ITERATION > $MAX_ITERATIONS). Blocking model."
  echo '{"decision":"deny","continue": false,"reason": "Iteration limit exceeded", "stopReason": "Iteration limit exceeded"}'
  exit 0
fi

# 6. Allow continuation
allow_and_exit
