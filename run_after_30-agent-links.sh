#!/usr/bin/env bash
# Link skills, global instructions and MCP servers for Codex and Antigravity (Gemini).
# Runs on every apply, after the pstack skills install, so `npx skills` copies get relinked.
exec "$HOME/.agents/link-skills.sh"
