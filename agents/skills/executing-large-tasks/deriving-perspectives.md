# Deriving a Task-Specific Risk Checklist

This document turns implicit risk enumeration into an explicit procedure. Run it **after reading the task statement, before writing a plan**. Budget (hard caps): ≤10 min for a half-day task, ≤45 min for a multi-day task, ≤90 min for a multi-week campaign. The output is a prioritized, phase-tagged checklist that you consult at defined points, not a one-time brainstorm.

**Tiering:** for tasks under ~half a day, run a quick pass over three axes only (data lifecycle, interfaces & contracts, failure modes) — no scoring matrix, ≤7 items, same validity rule as Step 4. The full 7-step procedure below is for larger work.

---

## Part 1: The Nine Derivation Axes

Each axis is a lens. For each, ask the trigger questions against the *specific* task, not in the abstract. An axis that yields nothing must be explicitly dismissed in writing — and the reason must reference a Step 2 inventory fact ("N/A because the inventory contains no data store"). An N/A citing nothing ("unlikely", "out of scope") is invalid; re-sweep the axis.

| # | Axis | Coding-task trigger questions | Research-task trigger questions |
|---|------|------------------------------|--------------------------------|
| 1 | **Data lifecycle** | Where does data enter, transform, persist, get cached, get deleted? Does old data meet new code (or new data meet old code)? Is a backfill/migration needed? Are there derived copies (caches, indexes, materialized views) that go stale? | What data will the chosen system hold? Retention, replay, schema-evolution needs? How fresh are my evidence sources — am I citing 2021 benchmarks? |
| 2 | **Interfaces & contracts** | Who calls this; what does it call? What are the *implicit* contracts: timeouts, retries, idempotency, ordering, nullability, error types, header propagation? Which callers do I not control? | What must the chosen option integrate with? Client-library maturity in our language? Protocol/format lock-in? |
| 3 | **Failure modes** | What happens on a halfway failure? On duplicate or out-of-order events? On the worst plausible input? On resource exhaustion or concurrent access? | What would make this recommendation *wrong*? Which claims come from vendor marketing vs. independent measurement? Which single requirement, if I have it wrong, invalidates the comparison? |
| 4 | **Time** (rollout, rollback, windows) | Can old and new versions coexist? Is rollback still safe *after* data has been written in the new format? Deploy-ordering constraints? Deadlines, freeze windows, feature flags? | Is the decision reversible — what is the exit path? Vendor roadmap/EOL risk? How long is the migration window and what runs in parallel during it? |
| 5 | **People** (users, operators, reviewers) | Who notices if this breaks? Who must review/approve (OWNERS, security, other teams)? Who operates it at 3am — do runbooks/alerts exist? Whose workflow changes? | Who lives with the decision — do their skills match the operational burden? Who are the stakeholders with veto power? Who consumes the output downstream? |
| 6 | **Scale & performance** | What multiplies (fan-out, N+1, payload size)? Largest realistic N? Is this on a hot path with a latency budget? Quotas and rate limits? | Actual current load and realistic growth (measured, not guessed)? Peak vs. average? Where are the pricing/architecture cliffs as scale grows? |
| 7 | **Security** | New untrusted inputs? Permission boundaries crossed? Secrets, PII, or auth tokens touched? Dependency/supply-chain changes? | Compliance requirements (residency, certifications)? Encryption and network-isolation options per candidate? |
| 8 | **Observability** | How will I *know* it works in production? How would the on-call person diagnose its failure? Do metric names, dashboards, or alerts change or silently go blank? | How debuggable is each candidate in practice (metrics, dead-letter handling, tooling)? How would we detect the choice failing post-adoption? |
| 9 | **Cost** | Recurring compute/storage/egress created? Retry or fan-out amplification of downstream load? Maintenance burden added? | Pricing model and its cliffs (per-unit vs. provisioned)? Licensing changes (e.g., BSL relicensing risk)? Total cost including operator time, not just the invoice? |

---

## Part 2: The Procedure (7 steps)

### Step 1 — Restate the task as a delta plus invariants
Write 2–4 sentences: **what changes**, and **what must remain true afterwards**. Every invariant is a checklist seed. If you cannot state the invariants, that itself is checklist item #1: ask the requester.

> Format: "Change: X → Y. Invariants: A must still hold; B must be unobservable to C."

### Step 2 — Build the touchpoint inventory (time-box: 10–15 min)
Make concrete lists, using actual investigation (grep/glob the repo, read the schema, list the stakeholders) — not memory:
- Systems/modules/files touched (for code: count call sites, list packages)
- Data stores, schemas, message formats involved
- External parties: callers you don't own, vendors, downstream consumers
- Environments and deploy surfaces; deadlines and freeze windows
- For research: current system, measured requirements, candidate options, stakeholders

Cap the inventory at ~20 entries; group beyond that ("40 packages owned by 12 teams" is one entry).

### Step 3 — Sweep all nine axes against the inventory
For each axis, ask its trigger questions about the inventory items. Write every hit as a candidate in this exact form:

> **Risk:** \<what specifically goes wrong\> — **if unchecked:** \<concrete consequence\>

Rules: one pass per axis, in order; no filtering or scoring yet; dismiss an axis only by writing "N/A because \<reason\>". Vague entries ("performance might be an issue") are not allowed — name the mechanism ("connection-pool defaults differ; hot-path service may exhaust sockets").

### Step 4 — Make each candidate checkable
Rewrite each candidate as an action with a built-in verification: "Verify X by doing Y" or "Decide X with \<person\> before Z." If you cannot name a verification action, either (a) convert it into an explicit question for the user, or (b) discard it — an unverifiable worry is noise.

**Validity rule (anti-recitation):** a surviving item must cite an artifact actually observed in Step 2 — a file:line, a command output, a schema, a stakeholder message. An item citing nothing was generated from priors, not investigation; it is auto-dropped as recitation.

### Step 5 — Score impact × uncertainty
Score each item:

**Impact** — 1: annoyance, self-contained fix. 2: rework, degraded users, missed deadline. 3: data loss, outage, security exposure, or a wrong irreversible decision.

**Uncertainty** — 1: I already know the answer. 2: checkable in minutes (read docs/source, run a query). 3: genuinely unknown; needs a spike, measurement, or a human.

**Priority = impact × uncertainty.**
- **6–9**: resolve *before* design/implementation starts.
- **3–4**: handle at the tagged phase (Step 7).
- **1–2**: drop, or keep as a one-line note.
- **Override:** impact-3 items never drop out entirely, even at uncertainty 1 — they become a cheap "verify once" item, because the cost of being miscalibrated is catastrophic.
- **Enabler override:** an item that unblocks several other checklist items (tooling, comms, access) may be kept regardless of score — mark it "enabler".
- **Calibration rule:** in an unfamiliar domain, when unsure whether something matters, raise *uncertainty*, never lower *impact*.

### Step 6 — Apply the stopping rule and cut
Stop enumerating when the **first** of these fires:
1. All nine axes swept once (mandatory floor), **and** the last two axes produced no item scoring ≥ 3 (diminishing returns).
2. 25 candidates exist pre-scoring (merge or stop generating).
3. The time-box (the hard cap in the header) expires.

The nine-axis floor overrides the time-box: if the cap expires mid-sweep, the remaining axes each get a one-line rapid pass (a hit or a valid written N/A) rather than being skipped.

Cut the scored list to **7–15 final items** for a large task (≤ 7 for a half-day task). If over, merge related items first, then cut lowest scores. A 40-item checklist will not be consulted; that failure mode is worse than a missing item.

### Step 7 — Bind items to workflow phases
Tag every surviving item with the phase where it gets checked:
- Code: `[before-design]` `[during-impl]` `[before-merge]` `[after-deploy]`
- Research: `[before-search]` `[during-evaluation]` `[before-recommendation]`

Put the checklist at the top of your plan or working notes. At each phase boundary, re-read the items with that tag and check them off **with evidence** (a file/line, a doc link, a measured number, a stakeholder answer) — not with "should be fine."

---

## Part 3: Worked Examples

### Example A — API-client migration in a large monorepo

**Task:** Migrate ~300 call sites in ~40 packages from deprecated internal HTTP client `legacyhttp` to `corenet`, deadline in 6 weeks.

**Step 1 (delta/invariants):** Change: all call sites use `corenet`. Invariants: request semantics (timeouts, retries, headers, error handling) unchanged as observed by called services and by calling code; no user-visible behavior change.

**Step 2 (touchpoints, abridged):** 300 call sites / 40 packages / 12 owning teams; client config defaults; auth + tracing header injection; test mocks of `legacyhttp`; codemod tooling; per-directory OWNERS review; client metric names.

**Step 3–4 (axis sweep, hits only):**

| Axis | Candidate (made checkable) | I | U | Score |
|------|---------------------------|---|---|-------|
| Interfaces | Verify default timeout/retry: `legacyhttp` = 30s/no-retry, `corenet` = 10s/3-retries. Diff the two configs in source. | 3 | 2 | 6 |
| Failure modes | Identify non-idempotent (POST/PUT) call sites where new auto-retry causes duplicate writes; grep call sites by method. | 3 | 3 | **9** |
| Interfaces | Find callers switching on `legacyhttp` error types/status wrapping; verify `corenet` error mapping. | 3 | 3 | **9** |
| Observability | Verify metric names emitted by `corenet` vs `legacyhttp`; list dashboards/alerts keyed on old names (they go silently blank). | 3 | 3 | **9** |
| Security | Verify auth-token and trace-header propagation is automatic in `corenet` or must be configured per-site. | 3 | 2 | 6 |
| Time | 300 sites cannot merge atomically → weeks of mixed state; confirm both clients can coexist in one binary; define per-package rollback unit. | 2 | 2 | 4 |
| People | 12 teams must review; write migration one-pager + codemod so reviews are rubber-stampable; sequence non-critical packages first. | 2 | 1 | 2→keep (enables everything) |
| Scale | Compare connection-pool/keep-alive defaults for the 3 hot-path services; load-test one before fleet rollout. | 3 | 2 | 6 |
| Data lifecycle | Verify JSON serialization defaults (nil/empty handling) identical; diff one request byte-for-byte in a test. | 2 | 2 | 4 |
| Cost | N/A — no new infra; retry amplification covered under failure modes. | — | — | — |

**Steps 5–7 (final checklist, 8 items):**
1. `[before-design]` (9) Grep-classify all 300 sites by HTTP method; disable auto-retry for non-idempotent sites or set per-site retry policy.
2. `[before-design]` (9) Catalogue error-type/status handling patterns at call sites; write an error-mapping shim or fix sites individually — decide which before codemod.
3. `[before-design]` (9) List dashboards/alerts using `legacyhttp` metric names; plan dual-emit or dashboard update per rollout wave.
4. `[before-design]` (6) Diff timeout defaults; pin explicit timeouts in the codemod rather than inheriting new defaults.
5. `[before-design]` (6) Prove auth/trace header parity with one integration test before migrating any site.
6. `[during-impl]` (6) Load-test one hot-path service on `corenet` (pool/keep-alive behavior) before its wave.
7. `[during-impl]` (4) Byte-diff one serialized request old vs. new in CI.
8. `[before-merge]` (4) Rollout in per-package waves with per-package revert; confirm both clients coexist in one binary first. Migration one-pager sent to 12 teams before first PR.

Dropped: license/cost, deep inheritance concerns, test-mock rewrites (impact 1 — handled mechanically by codemod).

### Example B — Technology-selection research task

**Task:** Recommend a message-queue technology (Kafka / GCP Pub/Sub / SQS / Redis Streams) for an event pipeline: ~5k msg/s claimed, small platform team, currently Redis + cron.

**Step 1 (delta/invariants):** Change: recommendation + migration path. Invariants: per-user event ordering preserved; existing producers keep working during migration; team of 3 can operate it.

**Step 2 (touchpoints):** current Redis pipeline; claimed 5k msg/s (unmeasured); team skills (no JVM ops); cloud = GCP; consumers = data team + 2 product services; budget ceiling; no formal compliance requirement (confirm).

**Steps 3–7 compressed (final checklist, 7 items):**
1. `[before-search]` (9) Measure real peak throughput from Redis metrics; get written confirmation of the ordering requirement. *Do this before comparing any vendors.*
2. `[before-search]` (6) Decide managed-only vs. self-managed with the team lead; document as a hard constraint.
3. `[before-search]` (6) Get replay/retention and delivery-semantics requirements from the data team.
4. `[during-evaluation]` (6) Build a cost model at 1× and 10× load per finalist; identify pricing crossover.
5. `[during-evaluation]` (4) Check library maturity + license/EOL history per finalist.
6. `[before-recommendation]` (4) Audit the draft: flag every load-bearing claim sourced only from vendor material; replace or spike-test.
7. `[before-recommendation]` (3) Written stakeholder confirmation that no compliance/residency constraint exists.

Note the characteristic research pattern the sweep surfaces: **the top risks are about your own requirements, not the technologies.** A mid-tier model's default is to start comparing products; the axis sweep reorders that.

---

## Part 4: What This Procedure Cannot Give You (honest limits)

- **Knowing which invariant is load-bearing.** The axes surface candidates; ranking their true importance needs domain judgment. Mitigation: ask the requester "which of these outcomes would be worst?"; read past incident reports and existing tests — they encode what already burned this team.
- **Domain-specific failure knowledge.** The interfaces axis tells you to *check* retry defaults; it cannot tell you that two clients differ. The procedure only converts unknown-unknowns into "go look" items if you answer trigger questions by actually reading source/docs, never from assumption. If you catch yourself writing "probably the same," that is an uncertainty-3 item by definition.
- **Impact calibration in unfamiliar domains.** Scores will be wrong sometimes. The overrides (impact-3 never fully drops; unsure → raise uncertainty) bound the damage but don't eliminate it.
- **Detecting that the task statement itself is wrong.** No axis reliably catches "you shouldn't do this at all." Partial proxy: if Step 1 invariants contradict the requested change, or Step 3 produces multiple 9s that all trace to the same design decision, escalate before proceeding.
