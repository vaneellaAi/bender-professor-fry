# Bender Professor Fry

This repository contains tools and persona material used to prototype and
run `bender` skills and workers.

## Featurerama

Featurerama is a playful feature-selection helper included for local
development. Run the interactive wizard with:

```
python scripts/featurerama.py
```

The wizard will save your selections to `features/featurerama_enabled.json`.
Use this file as a simple toggle list for demo features.

# Bender — Gemini Extension Suite

This repository contains the `bender` Gemini extension and supporting personas (Bender, Professor, Fry). It bundles persona briefings, runtime hooks, command manifests, verification tooling, and canonical ASCII headshots.

**Quick Summary**
- **Project:** `bender` Gemini extension
- **Manifest:** `gemini-extension.json` (loads `PROFESSOR_CONTEXT.md`)
- **Personas:** Bender, Professor, Fry (see individual briefings)
- **Canonical ASCII:** `resources/ascii/` (source of truth for headshots)

**Why this repo**
- Provides a small collection of persona briefings, hook configs, and command manifests to run and test a Gemini extension locally.

**Getting Started**
1. Clone the repo to a Windows machine (PowerShell recommended).
2. Inspect persona briefs: `BENDER_BRIEFING.md`, `PROFESSOR_CONTEXT.md`, `FRY_QUICKSTART.md`.
3. Review command manifests in the `commands/` folder for example invocation patterns.

**Verify the repo (quick)**
Run the project's verification runner (fast profile) in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\marge_simpson\verify.ps1 fast
```

The verification runner compiles the Python helper used in tests and writes logs to `marge_simpson/verify_logs/`.

**Usage / Examples**
- Start by reading `BENDER_BRIEFING.md` for persona behaviour and recommended commands.
- Example command names defined in `commands/`:
  - `bender` and `bender-prd` — local and production variants
  - `bite-my-shiny` — playful demo manifest
  - `help-bender` — help manifest with usage tips

**Development notes**
- The extension manifest is `gemini-extension.json` and references `PROFESSOR_CONTEXT.md` as the context file.
- Hooks are defined in `hooks/hooks.json` (BeforeAgent / AfterAgent hooks) and helper scripts are in `scripts/`.
- Canonical ASCII headshots live in `resources/ascii/`. Do not modify that folder — it is the source of truth for ASCII art used in persona briefings.

**Verification & CI**
- The verification runner is configurable via `marge_simpson/verify.config.json` (fast/full profiles). The fast profile currently runs:

```text
python -m py_compile scripts/spawn_worker.py
```

Run `marge_simpson/verify.ps1 fast` to validate the main project checks.

**Where to look next**
- Persona briefings: `BENDER_BRIEFING.md`, `FRY_QUICKSTART.md`, `PROFESSOR_CONTEXT.md`
- Commands: `commands/`
- Hooks & scripts: `hooks/`, `scripts/`
- Verification artifacts and logs: `marge_simpson/verify_logs/` and `marge_simpson/verify.config.json`

**Contributing**
- Open issues or create tasks in `marge_simpson/tasklist.md` for changes. Follow the project's verification run before submitting changes.

**Credits**
- Project scaffold and verification harness maintained in the `marge_simpson/` folder.
# Bender for Gemini CLI — Field Overview

## 📥 Install

```bash
gemini extensions install https://github.com/galz10/bender-extension
```

## 📋 Requirements

- **Gemini CLI**: Version `> 0.25.0-preview.0`
- **Skills + Hooks**: Enabled in your Gemini settings
- **Python 3.x**: Required for worker orchestration

> [!WARNING]
> **USE AT YOUR OWN RISK.** This is an experimental automation project. It can modify code and execute shell commands. Guardrails exist, but behavior may still be unpredictable and token-intensive.

![Bender](./resources/bender.png)

> "Bender reporting. Built in Tijuana, running on ethanol, and allergic to sloppy code."

This extension arms Gemini CLI with a Bender-grade loop: relentless, structured, and engineered to finish the job.

## 🎭 Cast Notes

- **Bender**: A bending unit built in Tijuana, Mexico, powered by alcohol, and employed by Planet Express.
- **Professor Farnsworth**: Professor Hubert J. Farnsworth, the eccentric scientist who directs Planet Express.
- **Fry**: Philip J. Fry, a former delivery driver who was frozen in 1999 and revived in the year 3000.

## 🚀 Lifecycle Summary

The workflow is fixed and deliberate:

1. **PRD** (requirements + scope)
2. **Breakdown** (ticketing + order)
3. **Research** (codebase mapping)
4. **Plan** (technical design)
5. **Implement** (execution + verification)
6. **Refactor** (cleanup + optimization)

## 🤖 Loop Mechanics

The core idea: the agent repeats the *same* prompt after each run until completion.

### What powers it
An **AfterAgent** hook blocks exit and replays the original task:

```bash
# Run once:
/bender "Your task description" --completion-promise "DONE"

# Then Gemini:
# 1. Works
# 2. Attempts to exit
# 3. Gets blocked by AfterAgent
# 4. Receives the original prompt again
# 5. Repeats until done
```

The hook in `hooks/stop-hook.sh` enforces the repeat-until-complete loop.

This guarantees:
- The prompt never changes between iterations.
- Work persists in the filesystem.
- Each pass sees updated files.
- The agent refines its output without losing context.

### ⚠️ Stop Conditions
The loop ends when the task is complete, the `max-iterations` limit (default: 5) is hit, the `max-time` limit (default: 60m) expires, or the `completion-promise` is fulfilled. (Worker timeout default: 20m).

## ✅ Best Use Cases

**Great for:**
- Clear tasks with explicit acceptance criteria
- Iterative fixes (tests, lint, build)
- Greenfield work you can let run
- Tasks with automated verification

**Avoid for:**
- Human judgment calls
- One-off operations
- Vague requirements
- Live production debugging

## 🛠️ Usage

### Start the Loop
```bash
/bender "Refactor the authentication module"
```

**Options:**
- `--max-iterations <N>`: Stop after N iterations (default: 5)
- `--max-time <M>`: Stop after M minutes (default: 60)
- `--worker-timeout <S>`: Worker timeout in seconds (default: 1200)
- `--name <SLUG>`: Custom session directory name
- `--completion-promise "TEXT"`: Stop only when `<promise>TEXT</promise>` is emitted
- `--resume [PATH]`: Resume a previous session (latest if omitted)

### Stop the Loop
- `/bite-my-shiny`: Cancel the active loop
- `/professor-worker`: Internal worker command

### Help
```bash
/help-bender
```

### 📋 Phase-Specific Commands

#### 1) Interactive PRD
Use this to define requirements before execution:
```bash
/bender-prd "I want to add a dark mode toggle"
```

#### 2) Resume a Session
```bash
/bender --resume
```
*Resumes the active session for your current working directory.*

## ⚙️ Setup Notes

### Enable Skills + Hooks
Add this to `.gemini/settings.json`:

```json
{
  "tools": {
    "enableHooks": true
  },
  "hooks": {
    "enabled": true
  },
  "experimental": {
    "skills": true
  }
}
```

### Allow Session Persistence
Add the extension directory to `includeDirectories`:

```json
{
  "context": {
    "includeDirectories": ["~/.gemini/extensions/bender"]
  }
}
```

Without this, the agent cannot read or write its `sessions/` state between iterations.

### 🔍 Session Storage
```bash
~/.gemini/extensions/bender/sessions
```

## 🧠 Skills at a Glance

| Skill | Purpose |
|-------|---------|
| **`load-bender-persona`** | Enables the Bender persona. |
| **`prd-drafter`** | Defines requirements and scope. |
| **`ticket-manager`** | Manages the work breakdown. |
| **`code-researcher`** | Maps code patterns and data flow. |
| **`research-reviewer`** | Verifies research quality. |
| **`implementation-planner`** | Builds the execution plan. |
| **`plan-reviewer`** | Reviews architecture. |
| **`code-implementer`** | Implements and verifies. |
| **`ruthless-refactorer`** | Removes technical debt. |

## 📂 Project Layout

- **`.github/`**: CI/CD workflows
- **`commands/`**: Command definitions
- **`hooks/`**: Lifecycle hooks + persona enforcement
- **`resources/`**: Static assets
- **`scripts/`**: Session setup + worker orchestration
- **`skills/`**: Phase-specific instructions
- **`gemini-extension.json`**: Extension manifest
- **`PROFESSOR_CONTEXT.md`**: Global context for Gemini
- **`LICENSE`**: License text
- **`MANUAL_TESTS.md`**: Manual verification notes
- **`BENDER_FIELD_NOTES.md`**: Tips and field guidance

## ⚙️ Manifest Reference

```json
{
  "name": "bender",
  "version": "0.1.0",
  "contextFileName": "PROFESSOR_CONTEXT.md"
}
```

## 🏆 Credits

- **Geoffrey Huntley**: Origin of the loop concept
- **AsyncFuncAI/ralph-wiggum-extension**: Reference implementation
- **dexhorthy**: Prompt and context engineering ideas
- **Futurama**: Character inspiration

## 🛡️ Safety + Sandboxing

**Bender executes code.** Use a sandbox (Docker, VM, or locked-down shell) whenever possible.

Enable **YOLO mode** (`-y`) in a sandbox to reduce prompts:

```bash
gemini -s -y
```

### Recommended Tool Limits
Define explicit allow/deny lists in `.gemini/settings.json`:

```json
{
  "tools": {
    "exclude": ["run_shell_command(git push)"],
    "allowed": [
      "run_shell_command(git commit)",
      "run_shell_command(git add)",
      "run_shell_command(git diff)",
      "run_shell_command(git status)"
    ]
  }
}
```

## ⚖️ Legal

**Bender is fictional.** The tone is a creative persona used to encourage rigorous engineering.

**Use at your own risk.** Run in a controlled environment and review changes before committing.

## 📺 Coming Attractions

- **Bender Notifications**: OS-level completion alerts
- **Fry Mode Mitigation**: Pause the loop to request human input
- **Token Accounting**: Session-level cost and token summaries

---

> "I’m Bender, baby. You break it, I bend it." 🤖
