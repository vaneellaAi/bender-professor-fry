#!/bin/bash

# Stop Hook for Bender
# Intercepts exit attempts to maintain the iterative loop
# "I'm gonna build my own loop, with blackjack and hookers!"

set -euo pipefail

# --- Configuration ---
HOOK_NAME="StopHook"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"

# --- Main Execution ---

# 1. Read and Validate Input
read_and_validate_input

# 2. Determine State File Path
if ! resolve_state_file; then
  # No state file -> Allow exit
  allow_and_exit
fi

# 3. Read State using jq
if ! STATE_CONTENT=$(cat "$STATE_FILE" 2>/dev/null); then
    log "Error: Could not read state file"
    allow_and_exit
fi

ACTIVE=$(echo "$STATE_CONTENT" | jq -r '.active // false')
SESSION_CWD=$(echo "$STATE_CONTENT" | jq -r '.working_dir // empty')

# Debug Log for Context verification
log "Context Check: PWD='$PWD' SESSION_CWD='$SESSION_CWD'"

if ! validate_cwd "$SESSION_CWD"; then
  allow_and_exit
fi

IS_WORKER=$(echo "$STATE_CONTENT" | jq -r '.worker // false')

# Worker Bypass: Workers (Professors) should not have an infinite loop enforced by the hook.
# They are managed by the parent process or have their own completion logic.
if [[ "$IS_WORKER" == "true" ]]; then
  log "Professor worker session detected. Allowing exit."
  allow_and_exit
fi

if [[ "$ACTIVE" != "true" ]]; then
  # Not active -> Allow exit
  allow_and_exit
fi

# 4. Parse Loop State
ITERATION=$(echo "$STATE_CONTENT" | jq -r '.iteration // 1')
MAX_ITERATIONS=$(echo "$STATE_CONTENT" | jq -r '.max_iterations // 0')
MAX_TIME_MINS=$(echo "$STATE_CONTENT" | jq -r '.max_time_minutes // 0')
START_TIME=$(echo "$STATE_CONTENT" | jq -r '.start_time_epoch // 0')
COMPLETION_PROMISE=$(echo "$STATE_CONTENT" | jq -r '.completion_promise // "null"')
ORIGINAL_PROMPT=$(echo "$STATE_CONTENT" | jq -r '.original_prompt // ""')

# 5. Check Termination Conditions

# 5a. Time Limit
CURRENT_TIME=$(date +%s)
ELAPSED_SECONDS=$((CURRENT_TIME - START_TIME))
MAX_TIME_SECONDS=$((MAX_TIME_MINS * 60))

log "Time Check | Elapsed: $ELAPSED_SECONDS / $MAX_TIME_SECONDS (Max Mins: $MAX_TIME_MINS)"

if [[ "$MAX_TIME_MINS" -gt 0 ]] && [[ "$ELAPSED_SECONDS" -ge "$MAX_TIME_SECONDS" ]]; then
  # Time limit reached -> Allow exit
  TMP_STATE=$(mktemp)
  if jq '.active = false' "$STATE_FILE" > "$TMP_STATE"; then
      mv "$TMP_STATE" "$STATE_FILE"
      log "Time limit reached. Stopping loop."
  fi
  allow_and_exit
fi

# 5b. Max Iterations
if [[ "$MAX_ITERATIONS" -gt 0 ]] && [[ "$ITERATION" -ge "$MAX_ITERATIONS" ]]; then
  # Limit reached -> Allow exit
  TMP_STATE=$(mktemp)
  if jq '.active = false' "$STATE_FILE" > "$TMP_STATE"; then
      mv "$TMP_STATE" "$STATE_FILE"
      log "Max iterations reached ($ITERATION). Stopping loop."
  fi
  allow_and_exit
fi

# 5c. Completion Promise
# Extract the assistant response from the input. 
# Note: hooks_refrence.md for AfterAgent says 'prompt_response' is the field for the model's response text.
LAST_MESSAGE=$(echo "$INPUT_JSON" | jq -r '.prompt_response // ""')

if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ "$COMPLETION_PROMISE" != "" ]]; then
  if echo "$LAST_MESSAGE" | grep -q "<promise>$COMPLETION_PROMISE</promise>"; then
    # Promise fulfilled -> Allow exit
    TMP_STATE=$(mktemp)
    if jq '.active = false' "$STATE_FILE" > "$TMP_STATE"; then
        mv "$TMP_STATE" "$STATE_FILE"
        log "Completion promise fulfilled. Stopping loop."
    fi
    allow_and_exit
  fi
fi

# 6. Continue Loop (Prevent Exit)

# Construct Feedback Message
FEEDBACK="� **Bender Loop Active** (Iteration $ITERATION)"
if [[ "$MAX_ITERATIONS" -gt 0 ]]; then
  FEEDBACK="$FEEDBACK of $MAX_ITERATIONS"
fi

if [[ "$COMPLETION_PROMISE" != "null" ]] && [[ "$COMPLETION_PROMISE" != "" ]]; then
  FEEDBACK="$FEEDBACK\n🎯 Target: <promise>$COMPLETION_PROMISE</promise>"
fi

log "Loop continuing. Blocking exit."

# Output JSON to prevent exit and send new prompt
# We use 'decision: block' to stop the session from ending normally.
# We inject additionalContext to feed back into the agent if supported, or just to log.
jq -n \
  --arg prompt "$ORIGINAL_PROMPT" \
  --arg feedback "$FEEDBACK" \
  '{ 
    "decision": "block",
    "systemMessage": $feedback,
    "hookSpecificOutput": {
      "hookEventName": "AfterAgent",
      "additionalContext": $prompt
    }
  }'
