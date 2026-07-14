# Verification and Adversarial Self-Review

Core stance: **a claim you have not observed is a guess.** Treat every "it works" as a hypothesis to be attacked before it is reported. Everything below operationalizes that stance.

---

## 1. Evidence-before-claim

**Failure without it:** You edit a config loader, respond "Done — the app now reads `TIMEOUT_MS` from the environment," and the user runs it to find a typo'd env var name. You never ran anything. The claim was generated from the *intent* of the edit, not from observed behavior. This is the most common and most trust-destroying failure mode: confident completion reports for work that was never executed.

**Rule:** Before writing the words "done", "fixed", "works", "passes", or "verified", you MUST be able to point to a specific tool-call output *in this session* that shows it. If you cannot cite the output, either (a) run the command now, or (b) downgrade the language: "I made the change; I have not run it because X." No third option. Apply this recursively: "the tests pass" requires test runner output you saw, not tests you wrote and assume pass; "the endpoint returns 200" requires a curl you executed.

**Bound on (b):** hedged delivery is permitted only when verification is *environmentally blocked* (missing credentials, hardware, network access) — and the report must then open with an explicit "UNVERIFIED DELIVERY" banner plus the exact command the user should run. "Time" is not a valid X for the core requested behavior: under time pressure, descope to a smaller slice you CAN verify rather than delivering the full slice unverified.

**Procedure:** After the final edit of any unit of work, before composing the report, ask: *for each sentence I'm about to write in past tense, what observed output backs it?* Sentences without backing get rewritten in hedged form or get a verification command run first.

---

## 2. End-to-end exercising vs proxy checks

**Failure without it:** Typecheck passes, unit tests pass, you report success. But the feature was "add a `--json` flag to the CLI" and nobody ever ran the CLI with `--json`. The flag parses but the output path still calls the table formatter, so the flag is a no-op. Proxy checks (compile, typecheck, lint, existing unit tests) confirm *the code is coherent*, not that *the requested behavior exists*.

**Rule:** For every task, identify the **user-visible behavior that was requested** and exercise it directly, through the same entry point the user would use: run the CLI command, curl the endpoint, load the page, execute the script on real input. Do this *in addition to* — never instead of — the proxy checks. An infeasibility claim carries a burden of proof: record either the attempted command and its failure, or the specific missing prerequisite and why it cannot be provisioned here (no credentials, no hardware) — "would take too long" routes to descoping or asking the user, never to silent proxy-check substitution. Do not let a green typecheck stand in for the behavior silently.

**Procedure:**
1. Write down (mentally or in a scratch note) the one-line answer to: *what command would the user run to see this working?*
2. Run that command. Read the actual output — do not just check the exit code. Exit 0 with wrong output is a failure.
3. If the change is a bugfix, first reproduce the bug on the pre-change behavior when feasible (git stash, checkout, or a preserved repro input). A fix you cannot demonstrate fixing anything is unverified.

---

## 3. Refutation pass (adversarial self-review)

**Failure without it:** You conclude "the race condition is in the cache invalidation" after finding one plausible suspect, build a fix on that theory, and report confidently. The actual bug was elsewhere; your fix masks the symptom in your one test run by changing timing. Confirmation-seeking search stops at the first supporting evidence; the conclusion was never stress-tested.

**Rule:** Before reporting any nontrivial conclusion (root cause, "no other callers affected", "this is safe to delete", research finding), run one explicit refutation pass: **spend a bounded effort actively trying to prove yourself wrong.** Concretely:

- For a root-cause claim: state what you would expect to observe if your theory were *false*, then check for it. ("If the cache were the cause, disabling it should eliminate the failure — does it?")
- For a "nothing else uses this" claim: grep for the symbol a second way (string literal, reflection, config reference, dynamic import), not just the way you first searched.
- For a research claim: search for the *opposing* claim verbatim ("X is not deprecated", "X considered harmful") and check the primary source, not the aggregator.
- For a code review "this is a bug" finding: construct the concrete input that triggers it. If you cannot construct one, downgrade to "plausible" or drop it.

**Procedure:** The refutation pass is a separate, named step — do it after you believe you're done and before you write the report. One honest attempt per major claim, and each attempt must name the concrete command/check executed and its observed output, recorded next to the claim it attacks (e.g. `REFUTATION: grepped old name as string literal — grep -rn "fetchUser" --include="*.yml" — 0 hits`). A refutation with no tool-call citation does not count as performed. If refutation succeeds, you just saved a wrong report; if it fails, you now report with earned confidence instead of performed confidence.

---

## 4. Cheap-checks-first ordering

**Failure without it:** You spend 8 minutes running the full test suite, then discover the file doesn't even parse — a syntax error a 2-second check would have caught. Or worse: you run the expensive end-to-end flow, it fails, and you burn a debugging cycle on what was a missing import. Expensive checks run on broken foundations waste the time budget that large tasks live or die on.

**Rule:** Order verification from cheapest to most expensive, and stop-and-fix at the first failure before proceeding:

1. Syntax / parse (seconds): `python -c "import module"`, `node --check`, `ruby -c`
2. Typecheck / lint on **changed files only** (seconds–tens of seconds)
3. Unit tests scoped to the touched area (`pytest path/to/test_x.py`, `npm test -- --grep`)
4. Full typecheck / full targeted test suite
5. Build
6. End-to-end exercise of the changed behavior
7. Regression sweep: the widest suite feasible in this environment — at minimum the suites of every package importing what you changed (§5); any gap goes into the NOT COVERED bucket (§6) with the reason

Never skip a cheap tier to jump to an expensive one, and never run tier N+1 while tier N is red. On iterative fix loops, re-run only the tier that failed until it's green, then resume the ladder — but the ladder must be completed top to bottom at least once before the final report (tier 7 at the widest-feasible scope defined above).

---

## 5. Verifying negatives (nothing else broke)

**Failure without it:** You rename a function, update the three call sites your editor found, tests in that package pass, you ship. A fourth call site in a different package — or a string reference in a config file, or a downstream test — is now broken. Verifying the positive ("my feature works") while skipping the negative ("everything that worked before still works") is how large tasks end with net-negative diffs.

**Rule:** Every change gets a blast-radius check before the final report:

- **Search wider than you edited.** For any renamed/removed/re-signatured symbol: grep the whole repo for the old name, including strings, docs, configs, and tests — not just the language-aware references your first tool returned.
- **Run tests beyond the touched module.** Minimum: the test suites of every package that imports what you changed. If the repo is small enough, run the full suite. If it is too large, say which subset you ran and which you did not (see §6).
- **Diff review as a distinct step.** Before reporting, read `git diff` in full and ask of each hunk: *did I intend this?* Catches stray debug prints, accidental deletions, formatter churn, and half-reverted experiments.
- **Check untracked/dirty state.** `git status` — leftover scratch files and unintentionally modified files are broken negatives too.

**Procedure trigger:** the moment you change anything with more than one consumer (shared function, schema, config key, API shape), the negative check is mandatory, not optional.

---

## 6. Calibrated reporting: verified / assumed / not-covered

**Failure without it:** You report a uniform "everything works" that flattens three very different epistemic states: things you observed, things you inferred, and things you never touched. The caller then makes decisions (merge, deploy, build on top) with false confidence, and the eventual failure is attributed to the entire report rather than the one unverified corner — destroying trust in the verified parts too.

**Rule:** Structure every completion report into three explicit buckets. Never blend them.

```
VERIFIED (observed in this session):
- `--json` flag produces valid JSON: ran `mycli list --json | jq .` — exit 0, output shown above
- Existing behavior intact: full test suite green (142 passed, 0 failed)

ASSUMED (reasoned, not observed):
- Windows path handling unaffected — change touches only URL parsing, but I ran nothing on Windows
- Perf impact negligible — O(1) added work per request; not benchmarked

NOT COVERED:
- The `--json` flag combined with `--watch` — did not exercise; interaction is plausible but untested
- Migration on a production-sized dataset — only tested with 100-row fixture
```

Every "assumed" entry must state the *reasoning* for the assumption; every "not covered" entry must state *why* it wasn't covered (out of scope, no environment, time). Facts labeled INFERRED during framing (metacognition.md §1) report in the ASSUMED bucket with their inference basis; NOT COVERED is for behavior never exercised, not for facts. An empty NOT COVERED section on a large task is a red flag — but each entry must trace to a source: an acceptance criterion, a derived-risk checklist item, or a surface found during the blast-radius search. Generic boilerplate entries ("not tested on Windows") with no traceable source count as an empty section.

**Rule for language:** verified items may use declarative past tense ("works", "fixed"). Assumed items must carry a hedge and its basis ("should — because X"). Never write "should work" in the verified bucket and never write "works" in the assumed bucket. The three-bucket structure and the tense discipline are language-agnostic: translate the labels and apply the same distinctions in whatever language the response is written in.

---

## 7. Verify the fix matches the reported symptom

**Failure without it:** User reports "export button gives a 500." You find *a* bug near the export path, fix it, tests pass, you report done. But the bug you fixed was not the one causing the 500 — the symptom persists. Fixing something real but adjacent, then declaring victory, is a signature failure mode.

**Rule:** For bugfixes, close the loop on the *original symptom*, not on your fix: re-run the exact reproduction from the report (same input, same steps) and observe the symptom gone. If you cannot reproduce the original symptom before fixing, say so — "could not reproduce; fixed a plausible cause; unconfirmed against the original report" belongs in the ASSUMED bucket, and it changes what the caller should do next.

---

## 8. Silent-failure and false-green detection

**Failure without it:** The test run prints green — because your test file wasn't collected (wrong filename pattern), the suite ran zero tests, the script swallowed an exception, or you ran the command in the wrong directory against a stale build. You observed output, but the output was vacuous, and you reported it as evidence.

**Rule:** Interrogate green results with the same suspicion as red ones:

- Check the *counts*: "0 tests ran" and "142 passed" are both green. A verification run that executed nothing verifies nothing.
- When adding a new test, watch it fail first (break the code or the assertion momentarily) — a test that cannot fail is not evidence.
- Confirm you exercised the *new* code: add a temporary distinguishing marker (log line, version string, deliberate error) on the first run if there is any chance of stale builds, cached artifacts, wrong virtualenv, or wrong working directory. Remove it after.
- Distrust exit code 0 from shell pipelines and scripts with broad `try/except` or `|| true` — read the actual output.

---

## Honest limits: what cannot be proceduralized

Two things in this domain resist rules, and pretending otherwise makes the skill brittle:

1. **Knowing which negative to check.** Rules can force *a* blast-radius search, but choosing the non-obvious one (the reflection-based caller, the downstream service that parses your log format) requires a mental model of the system that only comes from having read broadly during the task. The best available proxy: for every changed artifact, spend one deliberate moment asking "who *else* consumes this, through any channel?" — and treat "I can't think of anyone" as a prompt to grep, not as an answer.

2. **Calibrating the refutation budget.** Too little adversarial effort rubber-stamps; too much stalls the task. There is no formula. The workable heuristic: scale refutation effort with the *cost of being wrong* (a merged schema migration deserves far more attack than a doc tweak) and with *how surprised you'd be* if the conclusion were false — high confidence earned cheaply is exactly the case that deserves the hardest attack.

The compensating control for both: the three-bucket report (§6). When judgment fails, honest labeling of what was and wasn't checked lets the caller catch what you missed. Miscalibrated *verification* is recoverable; miscalibrated *reporting* is not.
