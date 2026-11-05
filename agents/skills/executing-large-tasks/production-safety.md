# Production Safety and Failure Design

Plans naturally cover building the thing and verifying it works; they rarely cover what happens when it doesn't. A plan without a failure design is a happy-path plan. Run this checklist against any plan that ships changes to a running system, before calling the plan complete.

---

## 1. Reversibility before change

**Failure without it:** A migrated package starts throwing unhandled rejections in production. The only rollback is git revert + redeploy — 40 minutes of user impact while CI runs.

**Rules:**
- For every production-bound change, name the mechanism that turns it OFF **without a deploy**: feature flag, config toggle, env var, routing rule. If none exists and the blast radius is meaningful, adding one is part of the task. If you deliberately ship without one, write the reason in the plan.
- Rollback is a data problem, not just a code problem. If the change writes data in a new format, backfills columns, or tightens constraints, git revert does not undo it. Use expand/contract: ship schema expansion first, code second, contraction last — each step independently revertible.
- Write the rollback runbook BEFORE the rollout: exact steps, who can execute it, and the data story (what happens to rows written while the new code was live?).
- A backfill that rewrites existing records (especially financial/historical data) gets: a pre-check query validating its core assumption against real data, a dry-run diff, and a documented down-path. Never state the assumption ("all existing rows are base currency") as fact — sample first.

## 2. Staged exposure

**Failure without it:** Eleven packages' worth of behavioral change lands in production at once after a single end-of-migration staging bake. Something regresses; nothing attributes.

**Rules:**
- Ship in waves (per package, per service, per tenant cohort). Define, per wave: the metric being watched, the abort threshold, and the soak time — pre-registered, not decided in the moment.
- The fix for a production bug must itself follow this rule. A fix for a deploy-window bug that ships without a canary is the same gamble that caused the incident.
- Separate mechanical change from behavioral change into different deploys (e.g., swap the client library with old defaults pinned; change the defaults in a later, separately monitored deploy). When something regresses, exactly one axis is suspect.
- Install the ratchet first: when driving something to zero (a deprecated import, an old API, a banned pattern), land the guard that blocks NEW instances (lint ban, CI grep gate) with the FIRST wave, not the last — otherwise the count climbs behind you while you drain it.

## 3. Containment before diagnosis (active incidents)

**Failure without it:** While you elegantly root-cause the double-charge, it double-charges forty more customers.

**Rules:**
- When the system is actively causing harm (money, data loss, security), the first actions are containment, not investigation: freeze or restrict the triggering activity (deploys, the affected endpoint, the feature flag), and reduce exposure (maxUnavailable=0, pause windows).
- Identify already-affected users/records and start remediation (refunds, notifications, finance/support handoff) in parallel with — not after — root-causing.
- Root-cause analysis begins once the bleeding is stopped. State this ordering explicitly in any incident plan.

## 4. Stop conditions and escalation, written in advance

**Failure without it:** The codemod mismatches 30% of call sites and the model keeps hand-patching them one by one for three hours instead of stopping to reconsider.

**Rules:**
- Every plan states, up front, the conditions that PAUSE the work and trigger consulting a human: a mismatch/failure-rate threshold, an unexplained metric regression, a failed reproduction, a discovery that contradicts the task's premise.
- Silence on stop conditions means the plan is incomplete. "I'll use judgment in the moment" is not a stop condition.
- Three failed attempts at the same failure → apply the strategy-change rule in metacognition.md §6.

## 5. The no-winner branch

**Failure without it:** The benchmark plan assumes one of the candidates will meet p99 < 120ms. None does. The team has spent four weeks and has no next move.

**Rules:**
- Any plan with gates or acceptance thresholds (technology selection, performance targets, migration feasibility) must contain an explicit branch for "nothing passes": renegotiate the requirement with its owner, change the architecture (tiering, caching, sharding), or descope. Write it before running the evaluation.
- Same for investigations: state what happens if the reproduction fails or the evidence is inconclusive (widen telemetry and wait for the next occurrence, escalate, timebox and report honestly).

## 6. Fix-risk analysis

**Failure without it:** The fix — a deterministic idempotency key — silently suppresses legitimate retry-after-decline payments. The fix caused a new incident.

**Rules:**
- Before shipping any fix, write one sentence per NEW failure mode the fix can introduce (suppressed legitimate operations, added latency on a hot path, a unique constraint that fails on existing dirty rows, lock impact of DDL on a hot table). If you can't think of any, that is a prompt to look harder, not evidence of safety.
- Ship the minimal safe slice first (e.g., detection + reconciliation before the behavioral change), so protection exists even if the full fix takes longer.
- Verify external-API semantics you depend on (idempotency-key TTL and scope, retry behavior) against documentation or a test call — not from the name of the feature.

## 7. Ground truth selection

**Failure without it:** The duplicate-detection SQL queries the local ledger — but the leading hypothesis is a crash between the external charge and the local commit, which by definition never produces a local duplicate row. The detector cannot see the thing it hunts.

**Rules:**
- When investigating data integrity, reconcile against the system that cannot lie about the outcome (the external provider's records, the upstream source of truth), not your own possibly-corrupted store.
- Validate the detector against each hypothesis: for every candidate cause, ask "if this were the cause, would my query/metric/log search actually show it?" A hypothesis your detector is blind to is untested, not disproven.
- Also apply forward: any new fix ships WITH a detector (metric + alert) that would catch the failure recurring, and the "it's fixed" claim is backed by that detector staying quiet across real triggering conditions (e.g., several deploy windows), not by absence of complaints.

## 8. Budget the meta-work

**Failure without it:** The bake-off plan quietly requires embedding 50M documents and building four full-scale indexes — weeks of a 2-person team's time — and nobody priced it.

**Rules:**
- Expensive evaluations (benchmarks, bake-offs, large test matrices) get their own explicit cost/time estimate in the plan.
- Always run a small-scale smoke first (1/10th–1/50th scale) to validate the harness, configs, and instrumentation before the expensive run.
- Use a downselect ladder: all candidates at cheap scale → 2–3 finalists at full scale. Full-scale everything is a big-bang plan wearing a lab coat.
- Keep every run's config and result in the campaign ledger (versioned), so the evaluation is auditable, repeatable, and survives interruption or handoff.
- Operational claims ("a 2-person team can run it") are tested with drills — kill a node, run an upgrade, restore a backup, rebuild an index under load — not by reading the architecture docs.

---

## Final gate: before calling any plan complete

- [ ] Off-switch without a deploy named (or its absence justified in writing)
- [ ] Rollback runbook exists and covers data written under the new code
- [ ] Exposure is staged, with pre-registered abort thresholds per wave
- [ ] If this is an incident: containment and remediation ordered before diagnosis
- [ ] Stop conditions and escalation criteria written down
- [ ] The no-winner / can't-reproduce branch exists
- [ ] The fix's own new failure modes listed; minimal safe slice identified
- [ ] Detector validated against every hypothesis; recurrence detector ships with the fix
- [ ] Meta-work (benchmarks, backfills, drills) has a budget and a smoke run
