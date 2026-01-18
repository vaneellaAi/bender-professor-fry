#!/bin/bash

# -----------------------------------------------------------------------------
# Bender: Worker Session Bootstrapper (Professor Farnsworth)
# -----------------------------------------------------------------------------
# Initializes a worker session starting at the RESEARCH phase.
# "Good news, everyone!" - Professor Farnsworth
# -----------------------------------------------------------------------------

set -euo pipefail

# -- Configuration --
STATE_PATH="${BENDER_STATE_FILE:-}"

if [[ -z "$STATE_PATH" ]]; then
  echo "❌ Error: BENDER_STATE_FILE environment variable not set." >&2
  exit 1
fi

# -- State Variables --
# We treat all arguments as the task description.
# Note: Gemini CLI passes arguments as a single string if quoted, or multiple.
TASK_STR="$*"

# -- Session Setup --
FULL_SESSION_PATH=$(dirname "$STATE_PATH")
mkdir -p "$FULL_SESSION_PATH"

# -- JSON Generation --
# Clean up prompt for JSON safety
JSON_SAFE_PROMPT=$(echo "$TASK_STR" | sed 's/"/\\"/g')
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
START_EPOCH=$(date +%s)

# Initializing at 'research' phase.
# 'active' is true so BeforeAgent hooks (Persona) trigger.
# 'worker' is true so AfterAgent hooks (Stop-Hook) allow exit (Native loop takes over).
cat > "$STATE_PATH" <<JSON
{
  "active": true,
  "working_dir": "$PWD",
  "worker": true,
  "step": "research",
  "iteration": 1,
  "max_iterations": 20,
  "max_time_minutes": 30,
  "start_time_epoch": $START_EPOCH,
  "completion_promise": "I AM DONE",
  "original_prompt": "$JSON_SAFE_PROMPT",
  "current_ticket": null,
  "history": [],
  "started_at": "$TIMESTAMP",
  "session_dir": "$FULL_SESSION_PATH"
}
JSON

# -- User Output --

cat <<EOF
👨‍💻 Professor Farnsworth Worker Activated!

>> Mode:      Execution (Research -> Plan -> Implement -> Refactor)
>> State:     $STATE_PATH
>> Task:      $TASK_STR

⚠️  WARNING: Professor will work until the task is complete (outputs 'I AM DONE') or expires.
   "Good news, everyone! I've completed another task!"
EOF