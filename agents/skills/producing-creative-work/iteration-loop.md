# Blind Iteration: The Visual Feedback Loop Without Reliable Eyes

**What a "look" is, and when to use your eyes:** a look = reading the image file with a multimodal tool if the harness renders images (in Claude Code, the Read tool displays PNGs), else handing the image plus your written expectation to the user. Decide which channel applies once, at task start, and state it. If you can view images cheaply, LOOK at every proxy render directly — the numeric checks below (histograms, RMSE, silhouette masks) are for thresholds, regression gates, and unattended loops, not a substitute for available eyes; the blind protocol is the fallback for genuinely vision-less contexts. Numeric checks assume numpy/ImageMagick — verify these exist during toolchain verification, or fall back to PIL one-liners or bpy pixel prints.


Core premise: you are a blind sculptor with calipers. Every property you can measure, you measure; every property you cannot measure, you budget scarce "looks" (screenshots/renders sent to vision) against a written expectation. Never iterate on hope.

---

## 1. Render early, render often — with cheap proxies

### 1.1 First render inside the first 10% of the work

**Behavior:** Produce *some* image (or run *some* playable build) immediately after scene/level scaffolding exists, before any detailing.

**Failure without it:** 45 minutes of scripted modeling produces a scene where the camera points at nothing, units are 100x off, or all objects spawned at the origin inside each other. Every subsequent "improvement" was applied to garbage.

**Rule:** After creating camera + subjects, render once at proxy quality before writing any material, lighting, or detail code. If the proxy render is empty or unrecognizable, stop and fix framing first.

### 1.2 Proxy quality ladder

**Behavior:** Maintain an explicit ladder and stay on the lowest rung that answers the current question:

1. **Viewport/OpenGL capture** (Workbench, matcap or flat studio lighting) — answers: composition, framing, silhouette, scale. Seconds.
2. **Clay render** (Cycles/Eevee, single gray override material, 16–32 samples, 25–50% res) — answers: lighting direction, shadow shapes, value structure. Under a minute.
3. **Low-sample full render** (64 samples, denoiser on, 50% res) — answers: materials, color. A few minutes.
4. **Final quality** — answers: nothing new. Only for delivery.

```python
# Blender: fast proxy settings
s = bpy.context.scene
s.render.resolution_percentage = 25
s.cycles.samples = 32
s.cycles.use_denoising = True
s.view_layer.material_override = clay_mat  # clay pass; None to restore
```

**Failure without it:** Agent renders 1024-sample 4K frames to check whether the cube moved left, burning the entire time budget on 3 iterations instead of 30.

**Rule:** Never render above the rung that answers the question you're currently asking. Composition questions get Workbench captures. Lighting questions get clay. Only the final deliverable gets final settings. Write the question down before rendering; if you can't state it, don't render.

---

## 2. Automated self-checks that need no eyes

These run every iteration, cost nothing, and catch the majority of blind-agent failures. Treat them as unit tests for images.

### 2.1 Histogram / value-distribution check

**Behavior:** Load every proxy render and compute: mean luminance, % pixels near pure black (< 5/255), % pixels near clipped white (> 250/255), and standard deviation.

```python
import numpy as np
img = np.asarray(load_render()).astype(float) / 255.0
luma = 0.2126*img[...,0] + 0.7152*img[...,1] + 0.0722*img[...,2]
mean, std = luma.mean(), luma.std()
black = (luma < 0.02).mean(); white = (luma > 0.98).mean()
```

Heuristic gates (tune per brief, but these catch disasters): mean in 0.15–0.65; std > 0.08 (else the image is flat mush); black < 40%; white < 10%.

**Failure without it:** The classic blind-agent render: pitch black (light pointing wrong way, light intensity in wrong units, camera inside a wall) or nuclear white (emission strength 1000), confidently described as "a warm sunset scene."

**Rule:** Gate every render through the histogram check before doing anything else with it. A failed gate means fix exposure/lighting *now* — do not evaluate composition, materials, or anything else on a broken-value image, and never send one to vision.

### 2.2 Silhouette render

**Behavior:** Render subject-only, flat white on black (Workbench, single flat material, world black). Measure: coverage (subject pixels / frame pixels), number of connected components, and whether the silhouette touches frame edges.

**Failure without it:** Subject occupies 2% of frame (scale/distance error), or is cropped by all four edges (camera too close), or the "creature" silhouette is 14 disconnected blobs because limbs never got parented/positioned — all invisible to numeric bbox checks alone, all obvious in a 1-bit mask.

**Rule:** For any hero object, render the silhouette mask and assert: coverage between roughly 15% and 60%, one dominant connected component, and no unintended edge cropping. Read the silhouette as data (numpy), not with vision.

### 2.3 Bounding-box and scale sanity

**Behavior:** Script-audit the scene: every object's world-space dimensions vs. plausible real-world size (a mug is ~0.1 m, not 10 m); no object at exactly (0,0,0) unless intended; no two objects with near-identical bbox centers (spawn stacking); all subject bbox corners project inside the camera frustum.

```python
for ob in scene_objects:
    print(ob.name, [round(d,3) for d in ob.dimensions], ob.matrix_world.translation)
```

**Failure without it:** Everything downstream of a 100x scale error is wrong — light falloff, DoF, physics mass, texture density — and no render will tell a blind agent *why* it looks off.

**Rule:** After every batch of object creation, print the dimension/position table and compare against a written list of expected real-world sizes. Verify camera coverage by projecting bbox corners (`world_to_camera_view`) — all subjects' corners in [0,1] NDC with margin — before ever rendering.

### 2.4 Polygon and asset budget counts

**Behavior:** Count tris per object and total; flag any single object holding > 50% of the budget and any total exceeding target (set a target: e.g., 100k tris for a stylized scene, 1–5M for detailed offline).

**Failure without it:** A subdivision modifier stacked twice puts 8M tris on a background prop; renders slow to a crawl mid-loop and the iteration cadence — the whole methodology — collapses.

**Rule:** Print the tri-count table after modifier changes. Investigate any object over budget immediately; slow renders kill more iterations than bad renders.

### 2.5 Seed-fixed A/B diffs

**Behavior:** Fix every random seed (sampler seed, procedural texture seeds, particle seeds). Keep the previous iteration's render. After each change, diff:

```bash
magick compare -metric RMSE prev.png curr.png diff.png
```

Also compute region-localized diff (which quadrants/tiles changed).

**Failure without it:** You "adjusted the rim light" but the RMSE is 0.0 (the change silently didn't apply — wrong object name, wrong node socket) or the entire frame changed (you nudged the camera by accident). Blind agents ship no-op changes constantly.

**Rule:** After every change, assert two things numerically: (a) the image changed at all (RMSE > noise floor), and (b) the change is localized where intended. Global diff from a local edit means an unintended side effect — find it before continuing. A zero diff means your edit did not land — never conclude "that parameter doesn't matter" from one zero diff.

---

## 3. XY/grid tests for image generation (ComfyUI / diffusion)

**Behavior:** Never evaluate parameters one image at a time. Build contact sheets: fix the seed, sweep one variable per axis (X = CFG {4, 7, 10}, Y = steps {20, 30, 45}; or X = prompt variant, Y = 3–4 fixed seeds). Stitch into a single labeled grid image. When comparing prompt wording, always run the same 3–4 seeds for both wordings.

**Failure without it:** Two failure modes. (1) Single-sample judgment: the agent concludes "CFG 9 is better" from one image where the seed, not the CFG, made the difference — diffusion variance across seeds usually exceeds variance across nearby parameter values. (2) Look-budget waste: 12 separate screenshots to vision instead of one grid, so vision never sees the *comparison*, only isolated images it can't rank.

**Rule:** One variable per axis, seeds fixed or explicitly the axis. Minimum 3 values per swept variable, minimum 3 seeds before any conclusion about a prompt change. Send vision the *whole grid as one image* with the axis labels burned in, and ask a ranking question ("which column has the fewest anatomy errors?"), not an open-ended "how does this look?". Record the winning cell's full parameter set in your notes before moving to the next sweep.

---

## 4. Playtest instrumentation for game feel

Game feel is the most measurable "visual" domain — you can replace eyes almost entirely with telemetry. Numbers first, vision last.

### 4.1 Frame-level telemetry

**Behavior:** Instrument the player controller to log per-frame: `t, x, y, vx, vy, grounded, input_state`. Dump to CSV. Drive it with *scripted deterministic input* (press jump at frame 60, hold right for 120 frames), not manual play.

**Failure without it:** "The jump feels floaty" is undebuggable blind. With a CSV it becomes "time-to-apex is 0.72 s and fall gravity equals rise gravity" — a concrete, fixable number.

**Rule:** Before tuning any movement parameter, build the scripted-input harness and CSV logger. Every tuning change is then: edit parameter → run scripted sequence → compare extracted metrics against targets. No screenshot needed.

### 4.2 Metrics and reference targets

**Behavior:** Extract from the CSV and check against genre baselines (starting points, not laws):

| Metric | How measured | Typical target (action platformer) |
|---|---|---|
| Time-to-apex | frames from jump-press to vy sign flip | 0.30–0.45 s |
| Jump height | max Δy, in tile units | 2–4 tiles, and ≥ 0.5 tile clearance over required jumps |
| Rise:fall gravity ratio | fit g on rise vs fall segments | fall 1.5–2.5× rise |
| Input-to-response latency | frames between input log and first Δv | ≤ 2–3 frames @ 60 fps |
| Time to max run speed | frames from input to 95% max speed | 0.1–0.3 s (snappy) |
| Stop distance | distance after input release | < 0.5 tile (tight) |
| Coyote time | latest post-ledge frame where jump still fires | 4–8 frames |
| Jump buffer | earliest pre-landing frame where queued jump fires | 4–10 frames |

**Failure without it:** Blind tuning oscillates: gravity up, "too heavy," gravity down, "too floaty," forever — because "feels wrong" has no direction without a number.

**Rule:** Write target numbers *before* tuning. Tune until the measured metric is inside the target band, then stop touching that parameter. Test coyote time and jump buffering with scripted edge-case inputs (jump 3 frames after walking off a ledge; jump 5 frames before landing) and assert they fire.

### 4.3 Jump arc plots

**Behavior:** Plot (x, y) of the logged jump as an image (matplotlib) or ASCII plot in the terminal. The *shape* is readable without vision tools: symmetric parabola = no fall-gravity boost; flat top = apex hang (intentional?); kinks = physics-step or state-machine bugs.

**Failure without it:** A state-machine bug that zeroes velocity for 2 frames at apex is invisible in aggregate metrics and imperceptible-but-wrong in play; it's a visible kink on the plot — and you can detect the kink numerically (second-difference spike in y).

**Rule:** Plot the arc after every gravity/velocity change. Check for kinks numerically (max |Δ²y| between consecutive frames) in addition to inspecting the plot. Overlay previous iteration's arc on the same axes so A/B is one artifact.

---

## 5. Structured critique checklist for when vision IS available

Looks are expensive. Extract maximum information per look.

**Behavior:** Before requesting/inspecting any screenshot or render, write down the expectation: "I expect: subject centered-left, key light from upper right creating shadow to lower left, warm/cool contrast, background darker than subject." Then evaluate the image against the checklist *in this order*, coarse to fine:

1. **Read (global):** Can you tell what the image is in half a second? Does the eye land on the intended subject?
2. **Silhouette & composition:** Subject readable in outline? Framing intentional (rule of thirds / centered deliberately)? Anything tangent to frame edges or awkwardly cropped?
3. **Values:** Clear light/mid/dark grouping? Is the subject the area of highest contrast? Squint-test: does structure survive?
4. **Scale & grounding:** Do relative sizes read correctly? Contact shadows present — or do objects float?
5. **Light & color:** One readable key direction? Shadows have color (not pure black)? Palette limited and deliberate?
6. **Materials & detail (last):** Roughness variation? Texel density consistent? Any obvious artifacts (z-fighting, seams, stretched UVs, fireflies)?
7. **Expectation diff:** List every mismatch between what you predicted and what you see. Each mismatch is either a defect (punch-list it) or a wrong mental model (update your model of the scene — this is the most valuable output of a look).

**Failure without it:** Unstructured looking yields "looks pretty good, maybe improve the lighting" — zero actionable output from your scarcest resource — and the agent fixates on a detail (item 6) while the composition (item 2) is broken.

**Rule:** No look without a written expectation first. Work the checklist top-down and *stop at the first broken level* — do not critique materials on an image with broken composition. Convert every finding into a punch list, batch-fix the whole list using the numeric checks of §2 for verification, and only then spend the next look. Never spend a look to verify something a histogram, diff, or bbox check could verify.

---

## 6. Stop conditions

**Behavior:** Define acceptance criteria at task start (checkable ones: histogram gates pass, silhouette coverage in band, all metrics in target bands, punch list empty, one final-quality render matches expectation). Track per-iteration deltas. Stop when *any* of:

- All acceptance criteria pass. Ship.
- **Diminishing returns:** two consecutive iterations each change the seed-fixed RMSE by < ~1–2% and produce no new punch-list items.
- **Oscillation:** you are about to revert or re-revert a previous change (parameter ping-pong). This means the objective is underspecified — stop tuning, re-derive a target number or ask the user.
- **Hard cap:** a preset iteration budget (e.g., 8–12 loops for a scene, 5 per game-feel parameter) is exhausted. Ship best-so-far with a written list of known gaps.

**Failure without it:** Two terminal states, both bad: infinite polish loops that thrash between equally mediocre variants while burning the budget, or premature "done" on the first render that isn't black.

**Rule:** Write acceptance criteria before the first iteration; your own new ideas go to a later list — user requests are not scope creep; they reset the acceptance criteria and renegotiate the iteration budget.

---

## Honest limits — what cannot be proceduralized

- **Taste.** The checks above bound *failure* (black renders, broken scale, floaty jumps, clipped values); they do not produce *beauty*. Whether a composition is compelling, a palette is evocative, or a jump is *fun* rather than merely in-spec remains a judgment call. When vision is available, use it for these judgments specifically — that is what it's for. When it isn't, say so in the deliverable: "metrics pass; aesthetic quality unverified."
- **Heuristic thresholds are priors, not laws.** A film-noir scene legitimately fails the 40%-black gate; a bullet-hell game wants different latency targets than a platformer. Override gates deliberately and in writing ("intentionally low-key lighting, black gate waived"), never by silently ignoring a failure.
- **Cross-modal descriptions don't substitute for measurement.** Do not let a text description of an image (from a caption model or your own generation-time intent) stand in for the checks in §2 — describing what *should* be there is exactly the failure mode this loop exists to prevent.
