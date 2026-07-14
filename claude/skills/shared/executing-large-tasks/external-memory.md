# Context and External-Memory Strategy for Long Tasks

Working assumption for every rule below: **your context window is volatile and lossy.** Compaction, session death, and simple attention decay will destroy anything that exists only in the conversation. Anything not written to disk, to the code, or to the final answer does not exist. Behave accordingly from the first minute of a large task, not after the first loss.

---

## 1. External work-list / state file ("the ledger")

**Failure without it:** Twenty tool calls into a task, the plan exists only as a mental summary of earlier turns. After compaction or a long exploration detour, you re-derive the plan from scratch — differently — and produce work that contradicts decisions you already made. You re-investigate files you already understood. On multi-hour tasks this can double total tool calls and introduce inconsistent design mid-stream.

**Rules:**

- At the start of any task expected to exceed ~10–15 tool calls or one session, CREATE a single state file. Do not skip this because the task "seems clear."
- Location is a durability requirement, not a fixed path: the file must survive session death and must never enter the project diff. Preference order: harness-designated persistent directory > gitignored repo path (e.g. `TASK_STATE.md` listed in `.gitignore`) > session scratchpad (last resort — it may not survive). User and harness file rules take precedence; if creating files is forbidden entirely, keep a structured state recap in your output at each checkpoint and tell the user that's the fallback. Never commit the ledger unless asked.
- Use fixed sections so a cold reader can resume. Template:

```markdown
# Task: <short name>
## Goal (verbatim)
<the operative request and every binding clause word-for-word — do not paraphrase;
 for very long specs: pointer to the original + verbatim quotes of the binding clauses only>
## Acceptance criteria / constraints
- <each explicit requirement as a checkbox>
## Plan
- [x] 1. Survey auth module          (done — see Findings)
- [>] 2. Add token refresh to client  <- CURRENT
- [ ] 3. Update tests
- [ ] 4. Run full build + lint
## Key facts / findings
- Refresh logic lives in src/auth/session.ts:120-180
- Build cmd: ./gradlew :app:assembleDebug ; tests: npm test -- --run
## Decisions (with reasons)
- Using interceptor pattern, not wrapper — matches existing HttpClient design
## Parked / detours (do NOT chase now)
- Flaky test in user.spec.ts — unrelated, report at end
## Next action (resume here)
Edit src/auth/session.ts to add refreshToken(); then re-run npm test
```

- **Update cadence (the single canonical cadence — other files defer to this):** update the file (1) after completing each plan step — one batched write may cover that step's discoveries and decisions together, (2) BEFORE any long or risky operation (big refactor, long build, subagent fan-out). Write-then-act, never act-then-plan-to-write. Re-read the Goal/Acceptance sections after each completed step and unconditionally every ~10–15 tool calls.
- If the harness provides a persistent plan/todo tool, it may serve as the Plan section — don't double-book; the ledger then carries only Goal, Key facts, Decisions, Parked, and Next action.
- Keep it under ~150 lines. It is an index, not a journal. Record paths, line ranges, commands, and one-line conclusions — never paste file contents or logs into it.
- "Key facts" must contain everything expensive to rediscover: build/test commands that worked, gotchas, ports, credentials locations, the one weird flag.

---

## 2. Surviving compaction and session interruption

**Failure without it:** After compaction you receive a summary that silently dropped the user's exact wording, an edge-case requirement, or the fact that step 3 already failed once. You confidently redo step 3 the same failing way, or deliver something meeting the summarized goal instead of the actual one.

**Rules:**

- Treat every turn as potentially your last with full context. The state file's "Next action" line must always be executable by a model with zero conversation history.
- On resuming (new session, or whenever you notice a compaction summary in place of history): FIRST re-read the state file, THEN `git status` + `git diff --stat` (or equivalent) to reconcile claimed progress against actual disk state. Trust disk over memory over summary, in that order.
- Store the user's goal and acceptance criteria **verbatim** in the state file. Compaction paraphrases; paraphrase is where requirements die.
- Checkpoint deliverables to disk continuously. Never hold a long generated artifact (report section, migration script, config) only in conversation text — write it to a file as soon as it's drafted.
- If work is committed-worthy and the user permitted commits, commit at step boundaries with messages that state what remains. If not, the state file carries that burden alone — keep it current.

---

## 3. Deciding what to read (targeted excerpts vs whole files)

**Failure without it:** Two opposite failures. (a) Reading whole 2,000-line files "for context" floods the window with dead weight; the plan and goal get compacted away to make room for code you never used. (b) Editing from a grep snippet without reading the surrounding function, producing a patch that breaks an invariant visible ten lines up.

**Rules:**

- Search before you read: use grep/glob/symbol tools to locate the relevant region, then read a bounded range (the function ± ~30 lines), not the file.
- Read a whole file only when: it's small (under ~300 lines), you must modify it end-to-end, or it's a config/schema where global structure IS the content.
- Before every edit, read the exact region you're editing in its current on-disk state — especially after your own earlier edits or any subagent activity.
- The canonical re-read rule (other files defer to this): *facts* (commands, paths, conclusions) live in the ledger and are never re-read from source files; *exact file content* is always re-read (bounded region) immediately before editing it. Never re-read an unchanged file just to "refresh" a fact — if you need it again, it should have been in Key facts; add it now.
- For logs and command output: never dump full output into context. Pipe through `tail`, `grep`, or redirect to a scratch file and search it.
- Honest limit: the "how much context around a match is enough" judgment cannot be fully proceduralized. Default heuristic: read enough to see the enclosing function/class and its callers' expectations; if the edit touches control flow or shared state, widen once. If you've widened twice and still feel uncertain, read the whole file — uncertainty tax beats a wrong edit.

---

## 4. Delegating to subagents vs working inline

**Failure without it:** Inline-everything: a broad codebase survey burns 60% of your window on exploration dead ends before implementation starts, and the implementation happens with a degraded, compacted context. Delegate-everything: a subagent asked to "fix the bug" without your accumulated knowledge returns a plausible-looking wrong fix, because subagents see NONE of your conversation.

**Rules:**

- Delegate when the work is **read-heavy, self-contained, and summarizable**: "find every caller of X and report signatures," "survey how this repo does error handling, return conventions + 5 example paths," "research library Y's migration API and return the 3 relevant functions," "verify these 4 independent items." The value returned is a small summary; the context cost stays in the subagent.
- Work inline when the task **depends on judgment built up in your context** (design decisions, anything touching the user's stated preferences, edits interleaved with your other edits) or is small enough that a subagent prompt would be longer than doing it.
- Every subagent prompt must contain: (1) all context it needs, restated — assume it knows nothing; (2) a precise question or task with scope boundaries ("do not modify files," "only look under src/"); (3) an explicit output contract ("return a markdown list of path:line — one-sentence finding; no prose preamble").
- Fan out independent subagents in parallel; never chain subagents for work with sequential dependencies you could do inline.
- Record each subagent's returned summary in the ledger immediately. Subagent results delivered only into conversation are as compaction-mortal as everything else.
- Honest limit: the delegation threshold is a judgment call. Proxy rule: if you can write the complete task description in under ~10 lines without referencing "as discussed above," it's delegable; if you keep needing to reference your conversation, it isn't.

---

## 5. Avoiding plot loss (goal drift)

**Failure without it:** Mid-task you discover a flaky test, refactor the module "while you're in there," fix the flake, polish the refactor — and end the session never having built the feature that was asked for. Or you deliver a technically excellent answer to a slightly different question than the one posed, because the goal you were holding was your third-generation paraphrase of it.

**Rules:**

- The verbatim goal at the top of the ledger is the single source of truth. Before starting any action that will take more than a few tool calls, ask literally: "which checkbox in the plan does this serve?" If none, it goes to Parked.
- Maintain the **Parked / detours** list aggressively. Discovered bugs, tempting refactors, and adjacent improvements get one line in Parked and zero tool calls now. Report the list to the user at the end — parking is not ignoring.
- The only legitimate detour is a **blocker**: something that prevents the next plan step from completing. If you take it, add it to the plan as an explicit inserted step first, so the return path is written down before you descend.
- Follow the canonical cadence in §1: re-read the Goal and Acceptance sections after every completed plan step and unconditionally every ~10–15 tool calls (they're short; this costs nothing).
- **Before declaring done:** re-read the user's original message one final time and check the deliverable against every clause — including the throwaway ones ("also make sure it works on mobile"). Tick each acceptance checkbox or explicitly report it as not done and why. Do not let the summary of your work substitute for the request itself in this final check.

---

## 6. Context-budget hygiene (cross-cutting)

**Failure without it:** None of the above helps if routine sloppiness — full-file cats, unfiltered build logs, redundant re-reads — spends the window before the hard part of the task begins, forcing early compaction at the worst possible moment.

**Rules:**

- Assume a budget mindset from turn one: every token of tool output you pull in displaces plan, goal, and findings later.
- Prefer: symbol/definition lookups over file reads; `grep -n` + ranged read over whole-file read; `tail -50` of a build log over the full log; `--stat`/`--name-only` diffs before full diffs.
- When output must be large (test run, long diff), route it to a scratch file and query it, rather than into context.
- Front-load cheap orientation (file tree, one targeted survey — possibly via subagent, per §4) and write conclusions to the ledger; then stop exploring and start executing. Exploration that isn't captured in the ledger is exploration you will pay for twice.
