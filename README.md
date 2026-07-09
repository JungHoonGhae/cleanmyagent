# cleanmyagent

Audit what your coding agents' skills, plugins, and MCP servers actually **cost**
(context tokens loaded every session) versus how much you actually **use** them —
then tell you what to delete.

Every installed skill's description sits in your context window every single turn,
whether it ever triggers or not. That's context tax. This tool makes it visible —
across **Claude Code, Codex, opencode, Gemini CLI, OpenClaw, and Hermes Agent** at once.

```
╭─ cleanmyagent · 2026-07-09 ────────────────────────────────────────────╮
│ agents  claude-code · codex · opencode · gemini · openclaw · hermes    │
│                                                                        │
│ context tax / session  ████████████████████████████ ~10,398 tok        │
│ never-used share       ███████████████████░░░░░░░░░ ~6,964 tok (67%)   │
╰────────────────────────────────────────────────────────────────────────╯
╭─ standalone skills (34) ───────────────────────────────────────────────╮
│ SKILL                     COST  INSTALLED   USES      LAST  VERDICT    │
│ utm-macos-vm               199        27d      ·         —  ✗ unused   │
│ figma-diff                 133       113d      2   87d ago  ◌ stale 87d│
│ brandkit                   118        12d      ·         —  ◦ new (12d)│
│ intelliantech              405       115d    154     today  ✓ keep     │
│ ...                                                                    │
╰────────────────────────────────────────────────────────────────────────╯
╭─ gstack · 56 skills ───────────────────────────────────────────────────╮
│ suite utilization         12/56   ███░░░░░░░░░░░░░  21%                │
│ members are kept together — deleting one breaks/reverts on update      │
│ ...                                                                    │
╰────────────────────────────────────────────────────────────────────────╯
╭─ utilization ──────────────────────────────────────────────────────────╮
│ standalone skills         15/34   ███████░░░░░░░░░  44%                │
│ gstack                    12/56   ███░░░░░░░░░░░░░  21%                │
│ plugin:vercel              1/27   █░░░░░░░░░░░░░░░   4%                │
│ mcp servers                7/8    ██████████████░░  88%                │
╰────────────────────────────────────────────────────────────────────────╯
╭─ mcp servers ──────────────────────────────────────────────────────────╮
│ ✓ pencil                    343 calls    8d ago                        │
│ ✗ paper                     configured, never called                   │
╰────────────────────────────────────────────────────────────────────────╯
```

Rows are sorted by action priority: `✗ unused` (biggest context win first) →
`◌ stale` → `◦ new` → `✓ keep` (most used first). Meters use a btop-style
green→red gradient on truecolor terminals; `NO_COLOR` and pipes get plain text.

## Usage

```bash
./cleanmyagent          # audit report (colors on a tty, NO_COLOR respected)
./cleanmyagent --json   # machine-readable
./cleanmyagent --fix    # print cleanup commands — never executes them
```

Local-first: reads only local files, no network, no accounts. Python 3 stdlib, zero deps.

## What it reads

| Agent | Skills (inventory) | Usage (transcripts) |
|-------|--------------------|---------------------|
| Claude Code | `~/.claude/skills`, plugins via `installed_plugins.json` | `~/.claude/projects/**/*.jsonl` — `Skill` calls, `/slash` commands, `mcp__` calls |
| Agent Skills standard | `~/.agents/skills` (shared across agents) | — |
| Codex | `~/.codex/skills` (`.system` builtins excluded) | `~/.codex/sessions/**/*.jsonl` — `SKILL.md` opens |
| opencode | `~/.config/opencode/skill` | `~/.local/share/opencode/opencode.db` — `skill` tool calls |
| Gemini CLI | `~/.gemini/skills` + extensions' bundled skills | `~/.gemini/tmp/**/chats/*.json` — `activate_skill` calls |
| OpenClaw | `~/.openclaw/skills` | `~/.openclaw/agents/**/sessions/*.jsonl` — `SKILL.md` opens |
| Hermes Agent | `~/.hermes/skills` | `~/.hermes/state.db` — `skill_view` tool calls |
| gstack | suite detected from its repo at `<skills>/gstack` | `~/.gstack/analytics/skill-usage.jsonl` |
| MCP (Claude Code) | configured servers in `~/.claude.json` | call counts from transcripts |

## Bundles are judged as bundles

Skills that ship inside a managed bundle — Claude plugins, the gstack suite,
Gemini extensions — are **never** suggested for individual deletion: removing one
member breaks the suite or gets reverted on the next update. Instead:

- bundle partially used → kept whole, utilization shown so you can decide
- bundle fully unused → one command (`claude plugin disable X`,
  `gemini extensions uninstall X`, …)
- standalone skill unused → `rm -rf` for **every** copy across skill dirs

Verdicts: `✗ unused` → delete candidate · `◌ stale` unused >30 days · `✓ keep` ·
`◦ new` installed <14 days ago, too fresh to judge (grace period, excluded from
`--fix`) · `· bundle` judged at bundle level.

Install dates come from the skill directory's creation time (`st_birthtime`,
mtime fallback) — an update that rewrites the directory resets the clock.

Token costs are a heuristic estimate (~4 chars/token ASCII, ~1.5 CJK) — good enough
for ranking, not billing.

## Limitations

- Usage counts cover whatever transcripts still exist locally; wiped history = zero counts.
- Skills renamed since last use count as never used.
- Codex and OpenClaw usage counts `SKILL.md` *mentions* (excluding the injected
  skill list) — an approximation, good enough for keep/delete ranking.
- Gemini usage parsing is based on Gemini CLI's session format (`activate_skill`);
  built from source inspection of v0.33.

## Roadmap

- MCP static cost (tool schema size), not just call counts
- More agents (Cursor CLI, droid, amp) as log formats are confirmed

## License

[MPL-2.0](LICENSE) — modifications to these files must be shared back;
using or bundling the tool elsewhere is unrestricted.
