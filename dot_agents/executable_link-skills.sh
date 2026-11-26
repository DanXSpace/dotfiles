#!/usr/bin/env bash
# Point Codex, Antigravity (Gemini) and other non-Claude agents at the one real copy
# of each skill, the global instructions and the MCP servers. Claude Code reads the
# originals in ~/.claude. Safe to rerun; chezmoi runs it after every apply.
set -euo pipefail
eval "$(mise env -s bash 2>/dev/null)" 2>/dev/null || true

backup="$HOME/.agents/skills.bak-$(date +%Y-%m-%d)"

# link SRC DEST: replace DEST with a symlink to SRC, backing up a real file in the way.
link() {
  local src=$1 dest=$2
  if [ -e "$dest" ] && [ ! -L "$dest" ] && [ -s "$dest" ]; then
    mv "$dest" "$dest.bak-$(date +%Y-%m-%d)"
    echo "  backed up $dest"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
}

# 1. Skills: ~/.agents/skills holds a link per skill.
dest="$HOME/.agents/skills"
mkdir -p "$dest"
find "$dest" -mindepth 1 -maxdepth 1 -type l -delete
add_skill() {  # add_skill DIR: link it unless a skill of that name is already linked
  local dir=${1%/} name; name=$(basename "$dir")
  [ -f "$dir/SKILL.md" ] || return 0
  if [ -d "$dest/$name" ] && [ ! -L "$dest/$name" ]; then
    # A real copy (from an importer or `npx skills`) would drift from the original.
    mkdir -p "$backup"; rm -rf "${backup:?}/$name"; mv "$dest/$name" "$backup/$name"
  fi
  [ -e "$dest/$name" ] || ln -s "$dir" "$dest/$name"
}
for d in "$HOME"/.claude/skills/*/; do
  [ -d "$d" ] || continue
  [ "$(basename "$d")" = synced ] && continue   # Claude-managed, licensed for Claude only
  add_skill "$d"
done
mp=$(python3 - <<'PY' 2>/dev/null || true
import json, os
d = json.load(open(os.path.expanduser("~/.claude/plugins/installed_plugins.json")))
print(d["plugins"]["mattpocock-skills@claude-plugins-official"][0]["installPath"])
PY
)
if [ -n "$mp" ] && [ -d "$mp" ]; then
  for d in "$mp"/skills/engineering/*/ "$mp"/skills/productivity/*/; do
    [ -d "$d" ] && add_skill "$d"
  done
fi

# 2. Global instructions: one file, ~/.claude/CLAUDE.md.
link "$HOME/.claude/CLAUDE.md" "$HOME/.codex/AGENTS.md"
link "$HOME/.claude/CLAUDE.md" "$HOME/.gemini/config/AGENTS.md"
link "$dest" "$HOME/.gemini/config/skills"

# 3. Antigravity MCP servers: add MobileBuildMCP on macOS, keeping any others.
if [ "$(uname)" = Darwin ] && command -v npx >/dev/null; then
  NPX=$(command -v npx) python3 - <<'PY'
import json, os
p = os.path.expanduser("~/.gemini/config/mcp_config.json")
os.makedirs(os.path.dirname(p), exist_ok=True)
try:
    cfg = json.load(open(p)) if os.path.getsize(p) else {}
except FileNotFoundError:
    cfg = {}
npx = os.environ["NPX"]
servers = cfg.setdefault("mcpServers", {})
servers.setdefault("MobileBuildMCP", {}).update({
    "command": npx,
    "args": ["-y", "mobilebuildmcp@latest", "mcp"],
    "env": {"MOBILEBUILDMCP_DISABLE_XCODE_AUTO_SYNC": "true",
            "PATH": os.path.dirname(npx) + ":/usr/bin:/bin:/usr/sbin:/sbin"},
})
json.dump(cfg, open(p, "w"), indent=2)
PY
fi

# 4. T3 runs Antigravity from its own config folder, named by a hash that can change.
for cfg in "$HOME"/.t3/userdata/providers/antigravity/*/config; do
  [ -d "$cfg" ] || continue
  link "$HOME/.claude/CLAUDE.md" "$cfg/AGENTS.md"
  [ -f "$HOME/.gemini/config/mcp_config.json" ] && link "$HOME/.gemini/config/mcp_config.json" "$cfg/mcp_config.json"
  [ -e "$cfg/skills" ] || ln -s "$dest" "$cfg/skills"
done

echo "  + agent links ($(find "$dest" -mindepth 1 -maxdepth 1 -type l | wc -l | tr -d ' ') skills)"
