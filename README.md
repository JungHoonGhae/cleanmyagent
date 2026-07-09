# cleanmyagent

Audit what your coding agent's skills, plugins, and MCP servers actually **cost**
(context tokens loaded every session) versus how much you actually **use** them —
then tell you what to delete.

Every installed skill's description sits in your context window every single turn,
whether it ever triggers or not. That's context tax. This tool makes it visible.

```
SKILL                          COST(tok)   USES      LAST  VERDICT
figma:figma-generate-design          220      0     never  ❌ never used
utm-macos-vm                         199      0     never  ❌ never used
humanizer                            140      9    1d ago  ✅ keep
figma-diff                           133      2   87d ago  ⚠️  stale (87d)
...

153 skills, ~10297 tokens of descriptions loaded every session.
118 never used → ~7074 tokens/session (68%) are pure context tax.
```

## Usage

```bash
./cleanmyagent          # human-readable audit table
./cleanmyagent --json   # machine-readable
./cleanmyagent --fix    # print cleanup commands (rm / plugin disable / mcp remove) — never executes them
```

Local-first: reads only local files, no network, no accounts. Python 3 stdlib, zero deps.

## What it reads

| Data | Source |
|------|--------|
| Skills + descriptions | `~/.claude/skills`, `~/.agents/skills` (open standard), `~/.codex/skills` — `*/SKILL.md` |
| Plugin skills | `~/.claude/plugins/installed_plugins.json` → each plugin's `skills/` |
| Claude Code usage | `~/.claude/projects/**/*.jsonl` (`Skill` tool calls + `/slash` commands + `mcp__server__tool` calls) |
| Codex usage | `~/.codex/sessions/**/*.jsonl` (`SKILL.md` opens, minus the per-session skill-list injection) |
| Configured MCP servers | `~/.claude.json` (global + per-project) — joined with call counts to flag never-called servers |

Verdicts: never used → ❌ uninstall candidate · unused >30 days → ⚠️ stale · otherwise ✅ keep.

Token costs are a heuristic estimate (~4 chars/token ASCII, ~1.5 CJK) — good enough
for ranking, not billing.

## Roadmap

- Adapters for more agents (Gemini CLI, opencode) — the Agent Skills standard
  (`SKILL.md`) is shared, only log formats differ
- MCP static cost (tool schema size), not just call counts

## Limitations

- Usage counts cover whatever transcripts still exist locally; wiped history = zero counts.
- Skills renamed since last use count as never used.
- Codex usage counts SKILL.md *mentions* in transcripts (excluding the injected skill list) —
  an approximation of real invocations, good enough for keep/delete ranking.

## License

[MPL-2.0](LICENSE) — modifications to these files must be shared back;
using or bundling the tool elsewhere is unrestricted.
