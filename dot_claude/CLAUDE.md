# How I work

## Workflow (any project)

1. **Plan:** `/grilling`, then `/to-spec`. Record decisions with `/domain-modeling` (glossary, ADRs). Use `/prototype` when a UI or state model is unclear, and `/arena` for a big design choice.
2. **Tickets:** `/to-tickets`, then `/triage` to mark them ready.
3. **Build:** one ticket at a time with `/tdd`, or the project's own ticket skill if it has one (LiftDay: `/liftday-tickets`).
4. **Review:** `/code-review`. Add `/interrogate` for a risky change, or `/blast-radius` for a small diff you don't trust.
5. **Ship:** `/pr`, then `/ship` or `/steward`. I approve before anything merges.
6. **Learn:** when I make the same correction twice, suggest `/correct`.

For a bug, use `/diagnosing-bugs`, then a regression test with `/tdd`. For a small fix (one file, obvious change), skip steps 1–2. When I've lost track, I run `/next`.

## Name the next step

Most of these skills only run when I type them. At the end of each step, name the next command in one line, such as "Spec is written. Next: `/to-tickets`." Don't start a step I haven't asked for.

A change is **risky** if it touches data models or migrations, stored user data (health, payments, auth), concurrency, an AI/model layer, or many files. Say so when it is, and suggest `/interrogate`.

## Models and effort

- **Default:** the session's own model. In Claude Code that's Opus at medium effort, set in settings, so subagents on Opus get it unless told otherwise.
- **Subagents and delegated tasks use the same provider and model as the session that starts them.** A Gemini session's workers are Gemini, not Claude. Use another model only when I name one, or when a skill's model settings assign seats (such as `pstack-models.md` for `/interrogate` and `/arena`).
- **High effort:** for risky changes, and for a second attempt after a failed review or fix. Raise effort on the same model (Gemini: `thought_level` high); don't switch providers to get it.
- **Fable, xhigh, and multi-model runs** (`/interrogate`, `/arena`): only for risky changes or big design choices.
- **Subagents:** don't spawn one for work that takes a few tool calls. Use Explore for broad searches.
