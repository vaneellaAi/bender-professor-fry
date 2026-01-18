#!/usr/bin/env python3
"""Featurerama — a playful feature-selection wizard for this project.

Run this script to interactively choose small demo features to enable
for local development. Selections are saved to `features/featurerama_enabled.json`.
"""
from pathlib import Path
import json

ROOT = Path(__file__).resolve().parent.parent
ASCII_PATH = ROOT / "resources" / "ascii" / "featurerama_ascii.txt"

def load_ascii():
    try:
        return ASCII_PATH.read_text(encoding="utf-8")
    except Exception:
        return "Featurerama\n"

def prompt_yes_no(prompt: str) -> bool:
    try:
        return input(prompt).strip().lower() in ("y", "yes")
    except EOFError:
        return False

def main():
    print(load_ascii())
    print("Welcome to Featurerama — the feature selection wizard.\n")

    features = [
        ("tiny-logging", "Add tiny logging hooks to scripts"),
        ("demo-endpoint", "Create a simple demo endpoint placeholder"),
        ("auto-doc", "Generate a small feature README snippet"),
    ]

    enabled = []
    for i, (key, desc) in enumerate(features, start=1):
        if prompt_yes_no(f"{i}) Enable {key} — {desc}? (y/N): "):
            enabled.append(key)

    out = {"enabled": enabled}

    out_dir = ROOT / "features"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / "featurerama_enabled.json"
    out_path.write_text(json.dumps(out, indent=2), encoding="utf-8")

    print(f"\nSaved selection to {out_path}")
    if enabled:
        print("Enabled:", ", ".join(enabled))
    else:
        print("No features enabled.")


if __name__ == "__main__":
    main()
