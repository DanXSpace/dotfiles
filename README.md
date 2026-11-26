# dotfiles

Everything my coding-agent workflow needs on a machine, managed with [chezmoi](https://chezmoi.io): Claude Code, Matt Pocock's skills, the pstack skills, the Codex reviewer, git and gh, plus links so Codex and Gemini (Antigravity) share the same instructions and skills.

## What it sets up

| Target | Source | Notes |
|---|---|---|
| `~/.claude/rules/pstack-models.md` | `dot_claude/rules/` | Reviewer models for `/interrogate` and `/arena`, including the `codex-cli` seat |
| `~/.claude/settings.json` | `dot_claude/modify_settings.json` | Merges shared keys only; Claude Code and any machine-specific hooks keep the rest |
| `~/.claude/CLAUDE.md` | `dot_claude/CLAUDE.md` | The workflow, next-step rule and model policy for every project |
| `~/.claude/skills/next/` | `dot_claude/skills/next/` | `/next`: names the next workflow step |
| `~/.config/mise/config.toml` | `dot_config/mise/` | Installs claude, codex, gh, node and chezmoi |
| `~/.gitconfig` | `dot_gitconfig` | Uses `gh` for GitHub credentials |
| Claude Code plugins | `run_onchange_after_10-claude-plugins.sh.tmpl` | `mattpocock-skills`, `clangd-lsp` |
| pstack skills | `run_onchange_after_20-skills.sh.tmpl` | The 10 cherry-picked skills |
| Codex and Gemini links | `dot_agents/executable_link-skills.sh`, run by `run_after_30-agent-links.sh` | Links `~/.agents/skills`, `~/.codex/AGENTS.md`, `~/.gemini/config/` and T3's Antigravity folder to the Claude originals, and adds MobileBuildMCP for Antigravity on macOS. Rerun `~/.agents/link-skills.sh` after adding a skill |

Sign-ins are never stored here. After each apply, a check lists any that are missing.

## New machine

1. Install mise and chezmoi. On macOS: `brew install mise chezmoi`, then add `eval "$(mise activate zsh)"` to `~/.zshrc`. Omarchy ships mise.
2. `chezmoi init --apply DanXSpace/dotfiles`
3. Run whatever the check lists: `gh auth login`, `codex login`.
4. Start a new Claude Code session.

## Changing things

- Edit a managed file: `chezmoi edit ~/.claude/rules/pstack-models.md`, or edit it in place and run `chezmoi re-add`.
- Add a plugin or skill: edit its `run_onchange_` script; the next apply installs it.
- Sync: `chezmoi cd && git commit -am "…" && git push` here, then `chezmoi update` on the other machine.

Project-specific setup (agents, project skills, `.mcp.json`) lives in each project's `.claude/`, not here.
