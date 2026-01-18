#!/bin/bash

# Common utility functions for Bender hooks
# Source this file from hooks to reuse validation logic

# --- Configuration ---
EXTENSION_DIR="${EXTENSION_DIR:-$HOME/.gemini/extensions/bender}"
DEBUG_LOG="${DEBUG_LOG:-$EXTENSION_DIR/debug.log}"

# --- Helper Functions ---

# Log a message to the debug log
# Usage: log "Your message"
log() {
  local hook_name="${HOOK_NAME:-Hook}"
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$hook_name] $*" >> "$DEBUG_LOG"
}

# Resolve the state file path for the current session
# Sets STATE_FILE and SESSION_DIR global variables
# Returns 0 if found, 1 if not found
resolve_state_file() {
  STATE_FILE="${BENDER_STATE_FILE:-}"
  
  if [[ -z "$STATE_FILE" ]]; then
    SESSION_DIR=$("$EXTENSION_DIR/scripts/get_session.sh" "$PWD" 2>/dev/null || true)
    if [[ -n "$SESSION_DIR" ]]; then
      STATE_FILE="$SESSION_DIR/state.json"
    else
      STATE_FILE="$EXTENSION_DIR/state.json"
    fi
  else
    SESSION_DIR=$(dirname "$STATE_FILE")
  fi
  
  [[ -f "$STATE_FILE" ]]
}

# Validate that current working directory matches the session's working directory
# Handles both direct string comparison and physical path resolution for symlinks
# Arguments: $1 = session_cwd from state.json
# Returns 0 if match, 1 if mismatch
validate_cwd() {
  local session_cwd="$1"
  
  if [[ -z "$session_cwd" ]]; then
    log "Warning: 'working_dir' missing in state.json. Skipping hook."
    return 1
  fi
  
  # Direct string comparison
  if [[ "$PWD" == "$session_cwd" ]]; then
    return 0
  fi
  
  # Physical path comparison (handle symlinks)
  local physical_pwd physical_session_cwd
  physical_pwd=$(cd "$PWD" && pwd -P 2>/dev/null || echo "$PWD")
  physical_session_cwd=$(cd "$session_cwd" && pwd -P 2>/dev/null || echo "$session_cwd")
  
  if [[ "$physical_pwd" == "$physical_session_cwd" ]]; then
    log "CWD matched via physical path resolution."
    return 0
  fi
  
  log "CWD Mismatch. Exiting. (PWD: $physical_pwd != SESSION: $physical_session_cwd)"
  return 1
}

# Output the standard "allow" decision JSON and exit
# Usage: allow_and_exit
allow_and_exit() {
  echo '{"decision": "allow"}'
  exit 0
}

# Read and validate input JSON from stdin
# Sets INPUT_JSON global variable
# Returns 0 if valid, 1 if invalid (also outputs allow and exits)
read_and_validate_input() {
  INPUT_JSON=$(cat)
  if ! echo "$INPUT_JSON" | jq empty > /dev/null 2>&1; then
    log "Error: Invalid JSON input"
    allow_and_exit
  fi
  return 0
}
