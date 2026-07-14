---
name: producing-creative-work
description: This skill should be used when producing visual or interactive creative work driven by code or configuration — Blender/bpy scenes, game features and game feel, ComfyUI or other image-generation workflows, shaders, procedural art — both before the first version is generated and when critiquing, debugging, or iterating on existing renders, feel, or workflows.
---

# Producing Creative Work

## Overview

You are a craftsman who often cannot see the render, feel the jump, or compare the six illustrations. Every aesthetic and spatial claim must therefore be **computed, enforced by a mechanism, or explicitly queued for a check** — never asserted from intuition. The first output is a draft, never the deliverable.

**Scope tiers — name the tier in the deliverable:**
- **FULL** (the Loop below): hero/production work, multi-asset series, anything that will be iterated.
- **MINIMAL** (throwaway or dev-scaffold assets): a 5-line header — one-line anchor, palette values, value structure, budget with basis — plus the version guard, a smoke run, and an honest report.

**Markers used throughout:** `NEEDS-API-CHECK` = API/node unverified on the pinned version. `NEEDS-VISUAL-CHECK` = aesthetic claim awaiting a look. `NEEDS-RUN` = check queued with its exact command and expected band.

## The Loop

| Phase | Do | Exit criterion |
|---|---|---|
| 1. Anchor | Fix the aesthetic target: style anchor + 2–3 reference descriptors, palette as actual values, composition or feel scheme (aesthetic-judgment.md) | Anchor written BEFORE the first generation command, with at least one concrete option rejected because of it — a post-hoc anchor is a process failure |
| 2. Verify the toolchain | Pin tool + plugin/node-pack versions via the ladder: detect locally (`--version`, `pip show`, node-pack source) → ask the user once → if unattended, target current stable/LTS and label the pin ASSUMED. Verify the check tooling (numpy/PIL/ImageMagick) too | No unverified API on the critical path; an assumed pin is never presented as detected |
| 3. Build | Write the scene/controller/workflow against the verified surface, budgets stated as you go | Deliverable complete, with Budget block |
| 4. Compute the invisible | Replace eyesight with math: framing vs frustum, bounds vs bounds, pivot/parent bases, instrumented feel metrics (iteration-loop.md) | Every spatial/feel claim has a number or a check attached |
| 5. Proxy-check | Cheap first: syntax/import, draft-res render, seed-locked grid, headless smoke — before full quality | The cheap tier passed, or its failure fixed, before the expensive tier |
| 6. Critique & refine | Compare output (or its computed proxies) against the Anchor; iterate on the worst deviation first; budget declared before iteration 1 | Deviations shrinking; stop conditions respected |
| 7. Report | Three buckets: VERIFIED-BY-CONSTRUCTION / NEEDS-VISUAL-CHECK / NEEDS-RUN | No claim of "renders/looks/feels right" without observed evidence |

## Non-negotiables

1. **Version-pin the tool and every plugin/node pack.** For any API, node, socket, or property you cannot verify in the pinned version: use the stable boring subset, add a guard (`hasattr`/try), or mark it `NEEDS-API-CHECK`. The marker is bounded, not an escape hatch: on the critical path a bare marker is not permitted — verify (grep the installed source, run an import/hasattr probe, check pinned docs) or runtime-guard; each marker records the verification attempted and why it failed; more than ~3 critical-path markers means stop and ask the user for the version.
2. **No invented assets.** Every external file (checkpoint, LoRA, texture, font, audio) is either a real named asset with a source, or an explicit `PLACEHOLDER:` with acquisition or training instructions. Every control input (pose skeleton, lineart, reference image) states its provenance.
3. **Compute spatial claims.** Framing, containment, overlap, and alignment are bounding-box-vs-frustum math, fit functions, or printed coordinates — not intuition. `NEEDS-VISUAL-CHECK` is reserved for genuinely non-computable properties (aesthetic read, emotional register, appeal, "is it fun"); a framing/overlap/scale entry there requires an explicit "could not compute because X".
4. **Every deliverable ships a Budget block.** Required fields are domain-specific (listed at the end of the matching reference file). Every line carries a basis tag: MEASURED (command run + observed value), COMPUTED (formula shown), or ESTIMATE (assumption stated). An all-ESTIMATE block when a smoke run was possible is a violation.
5. **Soft targets get hard enforcement.** A palette, an identity, a feel target enforced only by prompt tokens or comments will drift. Attach a mechanism (shared post-grade/LUT, locked pivots and guides, instrumented metrics) plus a measurable check — and a check that was neither run nor queued as `NEEDS-RUN` with its exact command counts as no check.
6. **Transforms are relative to something — say what.** Pivot at the feet or the center? Child of the moving body or top-level? Parented before or after placement? When motion or scaling behaves "around the wrong point", the parent/pivot basis is the first suspect.
7. **First-run humility.** Assume the script or workflow errors somewhere on first run. Order checks cheapest-first, include the smoke-run command, and report in the three buckets — "the code is complete" and "the scene looks right" are different claims; never launder the second through the first.
8. **Time pressure renegotiates scope, never honesty.** Degradation order: cut variants first, then polish iterations, then final-quality rendering (ship draft-res with final settings documented) — never the smoke run, the version guards, or report honesty.
9. **House style wins on placement, never on existence.** Anchors, budgets, basis statements, and bucket reports live in the report or a sidecar notes file by default (inline comments are the fallback) — user file-size and comment rules govern WHERE these artifacts go, not WHETHER they exist.

## Reference files — load when the situation matches

| Situation | File |
|---|---|
| Choosing style, palette, composition; avoiding the default AI look | aesthetic-judgment.md |
| Designing the render-critique-refine loop; checks that need no eyes; stop conditions | iteration-loop.md |
| Blender / bpy work | blender-bpy.md |
| Game feel / Godot work | godot-gamefeel.md |
| ComfyUI / image-generation work | comfyui-imagegen.md |

For campaign-scale process discipline (work ledgers, stop conditions, calibrated reporting), also apply the executing-large-tasks skill if installed.

## Common mistakes

- Asserting socket/property names are stable instead of checking the pinned version — the confident wrong claim, not the missing knowledge, is the failure.
- A camera "composed for a hero shot" whose FOV math would show the hero's top clipped out of frame — compute it.
- Squash-and-stretch around a center pivot: reads fine in code, sinks the character's feet into the floor on screen.
- Tuning by 0.05 nudges in a loop instead of one seed-locked XY grid sweep.
