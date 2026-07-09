# cleanmyagent

Audit what your coding agents' skills, plugins, and MCP servers actually **cost**
(context tokens loaded every session) versus how much you actually **use** them —
then tell you what to delete.

Every installed skill's description sits in your context window every single turn,
whether it ever triggers or not. That's context tax. This tool makes it visible —
across **Claude Code, Codex, opencode, Gemini CLI, OpenClaw, and Hermes Agent** at once.

```
cleanmyagent · context-tax audit · 2026-07-09
agents scanned: claude-code · codex · opencode · gemini · openclaw · hermes

CONTEXT TAX
  every session      ████████████████████  ~10,315 tok of skill descriptions
  never-used share   ██████████████░░░░░░  ~6,986 tok (68%) buys you nothing

STANDALONE SKILLS (32)
  SKILL                          COST   USES      LAST  VERDICT
  utm-macos-vm                    199      ·         —  ✗ unused
  humanizer                       140      9    1d ago  ✓ keep
  figma-diff                      133      2   87d ago  ◌ stale 87d
  ...

GSTACK (56 skills, managed as a suite)             ███░░░░░░░░░ 12/56 used
PLUGIN:VERCEL @claude-plugins-official (27 skills) ░░░░░░░░░░░░  1/27 used
PLUGIN:SUPERPOWERS @claude-plugins-official (14)   ██████░░░░░░  7/14 used
PLUGIN:ATLASSIAN @claude-plugins-official (6)      ░░░░░░░░░░░░  0/6 used

UTILIZATION
  standalone skills   15/32   ████████░░░░░░░░  47%
  gstack              12/56   ███░░░░░░░░░░░░░  21%
  mcp servers          7/8    ██████████████░░  88%

MCP SERVERS
  ✓ pencil        343 calls   8d ago
  ✗ paper         configured, never called
```

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
`· bundle` judged at bundle level.

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
