# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# A value `<model> <effort>` means Agent `model: "<model>"`, `effort: "<effort>"`. `inherit-parent` means omit `model`.
# defaults: 3
# budget: large (xhigh)
#
# `codex-cli` is a seat run by OpenAI's Codex CLI, not a Claude model. Never map it to the session model.
# To fill a codex-cli seat: create its git worktree as usual (copy in the scope's uncommitted changes), then spawn a
# general-purpose Agent with `model: "sonnet"`, `effort: "low"` whose only job is to relay. It runs, from that worktree:
#   codex exec -C <worktree> -s workspace-write --skip-git-repo-check -o <worktree>/.codex-report.md "<the full brief the other seats got>"
# (use `-s read-only` when the seat must not edit, such as a cross-judge), with a Bash timeout of 600000,
# and returns the contents of .codex-report.md verbatim, without adding, dropping or rewording findings.
# If codex exits non-zero or is not logged in (`codex login status`), report the seat as a dropout and continue.
# Codex's findings get the same verification as every other seat: rerun each command, keep only what reproduces.
interrogate reviewers: fable high, opus high, codex-cli
arena runners: fable high, opus high
arena cross-judge pool: codex-cli
