---
name: next
description: Work out where the current work stands and name the one next workflow step. Use for /next, "what's next", or "where was I".
disable-model-invocation: true
---

# Next

Find where the work in this repo stands and name the one next step from the workflow in `~/.claude/CLAUDE.md`. Read only. Don't change files, tickets or branches.

## Look

1. **Git:** the current branch, uncommitted changes, and commits ahead of the default branch (`git status`, `git log --oneline <default>..HEAD`).
2. **Pull requests:** an open PR for this branch and its state: CI, review comments, approval (`gh pr view`, `gh pr checks`).
3. **Tracker:** where the project keeps specs and tickets (its `CLAUDE.md` says; for example `.scratch/` or GitHub Issues). Look for:
   - a spec with no tickets;
   - tickets waiting on triage;
   - tickets that are ready, with their blockers resolved;
   - tickets in progress or with a candidate waiting for review.
4. **Review state:** commits on this branch that no review has covered yet, and whether the change is risky as `~/.claude/CLAUDE.md` defines it.

## Reply

- **Where things stand:** one or two lines.
- **Next:** the one command to run, and why.
- **Or:** at most two alternatives, each with a one-line reason.

If nothing is in progress, say so and suggest picking a ready ticket or starting a plan with `/grilling`.
