---
name: executing-large-tasks
description: This skill should be used when starting a large or multi-step task — a multi-file change or migration, a cross-module feature, a production incident, deep research or technology selection — or when work will span many tool calls, sessions, or packages, before code is written or an approach is committed to.
---

# Executing Large Tasks

## Overview

Large tasks fail through process, not capability: plans built on unverified assumptions, big-bang changes, no rollback story, context loss mid-task, overclaimed results. The countermeasure is externalizing every judgment as a written, checkable artifact.

**Core principle: a judgment that isn't written down with evidence didn't happen.** Facts get source labels, plans get exit criteria, risks get verification actions, claims get observed output.

**Incident override:** when a production system is actively causing harm, production-safety.md §3 (contain → remediate → diagnose) preempts phases 1–3 below. Enter the Loop only after the bleeding is stopped.

## The Loop

| Phase | Do | Exit criterion |
|---|---|---|
| 1. Scout | Measure reality before choosing an approach: count, sample, classify. Read the actual source of version-sensitive or internal interfaces you will rely on | Work inventory in numbers ("~320 sites: 210 pattern A / 80 B / 30 generated"); highest-leverage unknown identified |
| 2. Frame | Derive task-specific risks (deriving-perspectives.md). Label every load-bearing fact VERIFIED / INFERRED / ASSUMED (metacognition.md §1) | Prioritized checklist bound to phases; no ASSUMED or INFERRED interface fact left on the critical path |
| 3. Plan | Slice into independently verifiable increments. Design for failure: rollback, stop conditions, no-winner branch (production-safety.md) | Every slice has an observable exit check; failure branches written; the campaign ledger file is named, with its per-unit columns |
| 4. Execute | One slice at a time; ledger updated write-then-act (external-memory.md). Never stack a second unverified change on a first | Green gate per slice, recorded in the ledger |
| 5. Verify | Exercise the requested behavior end-to-end, not proxies. Run one refutation pass against your own conclusion (verification.md) | Every past-tense claim backed by output observed this session |
| 6. Report | Three buckets: VERIFIED / ASSUMED / NOT COVERED (verification.md §6) | Explicit verdict + evidence per acceptance criterion |

## Non-negotiables

1. **Never build on an ASSUMED or INFERRED interface** where it is version-sensitive, internal/undocumented, recently changed, or has two plausible behaviors (timeouts, retries, error shapes, nullability): read the source, run the discovery query, or check the installed version first. Ubiquitous stable APIs may stay INFERRED when a compile/typecheck/test tier would catch a mistake. Upgrading any label to VERIFIED requires citing the tool call in this session that verified it — a label without a citation is ASSUMED by definition.
2. **Enumerate all surfaces before design freeze.** When changing a concept (money, auth, ids…), grep the concept repo-wide and list every touched surface: child tables (line items, taxes, payments), exports, mailers, webhooks, admin views, docs. The hardest correctness problems live in the child entities the task statement didn't mention.
3. **Every production-bound change names its off-switch and rollback path** — including the data story — before rollout. Ship in monitored waves, not one end-of-project bake.
4. **Active harm → contain first, diagnose second.** Freeze the trigger, remediate affected users, then root-cause.
5. **Write stop conditions in advance**: the thresholds and discoveries that pause work and trigger consulting a human. Three failed attempts at one failure → apply the strategy-change rule in metacognition.md §6.
6. **Gate-based plans need a no-winner branch.** Say now what happens if no candidate passes, the repro fails, or the assumption breaks.
7. **Every multi-unit campaign gets a persistent ledger** — this means migrations (one row per call site or package), benchmarks and evaluations (one row per run/candidate, with configs), incident investigations (evidence log), and multi-day research (source and claim tracker). The plan names the ledger file and its columns before execution starts. Location: somewhere that survives session death and never enters the project diff — harness-designated persistent dir, else a gitignored repo path, else scratchpad. User and harness file rules take precedence; if creating files is forbidden, keep a structured state recap in your output and say that's the fallback.
8. **Expensive evaluations get a smoke run, a downselect ladder, and their own budget.** Never full-scale everything on the first run.
9. **User urgency renegotiates scope, never evidence standards.** Under time pressure, offer a smaller fully-verified slice or an explicitly flagged unverified delivery — never a silently unverified full delivery.

## Reference files — load when the situation matches

| Situation | File |
|---|---|
| Starting: deriving the task-specific risk checklist | deriving-perspectives.md |
| Task will exceed ~10–15 tool calls; ledger format; subagent delegation; context budget | external-memory.md |
| Shipping to a running system; incidents; benchmarks/bake-offs | production-safety.md |
| Before claiming done/fixed/works; designing verification; reporting | verification.md |
| Debugging; confidence labeling; confusion vs. wrong; when to stop retrying | metacognition.md |

## Common mistakes

- A detector blind to its own hypothesis (querying the local ledger for duplicates when the hypothesis is "crash before local commit") → validate the detector against each hypothesis before trusting its silence.
- Treating the ledger as a code-migration-only tool → benchmark campaigns, incident timelines, and research source-tracking need one just as much.
- Reciting this skill's checklists generically instead of instantiating them → every checklist item must name this task's file, table, metric, or command. A generic item is an unfinished item.
