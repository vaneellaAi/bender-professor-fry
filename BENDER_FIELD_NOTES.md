# Bender Field Notes 🤖

Sharper prompts, cleaner loops, fewer Fry moments.

## 🧠 Prompt Craft

### 1) Be Concrete
Skip vague asks. Instead of “Refactor the code,” say “Refactor `AuthService` to use a Strategy pattern for OAuth providers and enforce strict TypeScript types.”

### 2) Force the Interview
Want a PRD interview? Ask for it directly: “Interrogate me on edge cases before drafting the PRD.”

### 3) Name Your Sessions
Use `--name` to keep `sessions/` tidy:
```bash
/bender "Implement JWT auth" --name "auth-jwt-migration"
```

## 🤖 Bender + Professor Architecture

Bender runs a **Manager/Worker** model.
- **Bender (Manager):** Plans, breaks down tickets, and audits results.
- **Professor Farnsworth (Worker):** Executes a single ticket inside its own loop.

### What you’ll see
1. **Silence can be normal:** The manager may be quiet while the Professor works.
2. **The audit phase:** Bender reviews `git diff` and runs tests after the worker finishes. If the output is weak, he reverts and reruns.

## 📝 Example Prompts

### Full-Stack Feature + Verification
```bash
/bender "Add a new 'Dashboard' view to this full-stack app. To validate your changes, you MUST run 'npm run build' and 'npm run test' before finishing."
```

### Deep Refactor
```bash
/bender "Refactor the database connection logic in src/db.ts to use a singleton pattern. Interrogate me on the preferred retry strategy before you start."
```

### Bug Fix + Research
```bash
/bender "The file selection in the sidebar is intermittent. Conduct deep research into the event propagation before proposing a plan."
```

## 🛠️ Session Management

### Watch Progress (Manager + Worker)
**Manager (Bender):**
```bash
SESSION_DIR=$(~/.gemini/extensions/bender/scripts/get_session.sh)
tail -f "$SESSION_DIR/state.json"
```

**Worker (Professor):**
```bash
ls -t ~/.gemini/extensions/bender/sessions/*/*/*/worker_session_*.log | head -n 1 | xargs tail -f
```

### Advanced Flags
- `--reset`: Reset iteration count + timer (only with `--resume`)
- `--paused`: Initialize a session without starting the loop
- `--worker-timeout <seconds>`: Override worker timeout (default: 1200s)

### Manual Intervention
If the loop jams, use `/bite-my-shiny` and edit `state.json` to skip steps or change `current_ticket`.

### Resume
```bash
/bender --resume
```
Or resume a specific path:
```bash
/bender --resume ~/.gemini/extensions/bender/sessions/YYYY-MM-DD-slug
```

## 🚀 God Mode Habits

### Invent Tools When Needed
If a task needs a helper script, tell Bender: “Invent the tool you need and prove it works.”

### Verification Matters
Without tests, Bender is guessing. Provide build or test commands in your prompt.

## ⚠️ Common Pitfalls

- **Silence:** If the agent goes quiet, say: “Explain your moves, Bender.”
- **Vague PRDs:** Review `prd.md` before the Breakdown phase starts.
- **Permissions:** If the loop won’t restart, make sure `hooks/` is executable (`chmod +x`).
- **Custom Installation Path:** Skills assume the default install location (`~/.gemini/extensions/bender`). If you install elsewhere, skills that call `run_shell_command("~/.gemini/extensions/bender/scripts/...")` will fail.

---

> “I’m not just a CLI tool. I’m the reason your code compiles.” 🤖
