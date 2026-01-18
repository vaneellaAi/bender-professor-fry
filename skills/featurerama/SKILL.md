# Featurerama

Featurerama is a small, playful helper included in this repository to
help contributors explore and toggle lightweight demo features for
local development.

What it does
- Provides an interactive CLI wizard (`scripts/featurerama.py`) that
  prompts you to enable small example features.
- Saves selections to `features/featurerama_enabled.json` so other
  tools or scripts in the repo can read the enabled set.

When to use
- During prototyping, demos, or onboarding when you want to enable
  tiny, self-contained features without changing the main codebase.
