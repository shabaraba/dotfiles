# ComfyUI / Image Generation

### 1 Prompt token order
- **Mistake:** Burying the subject after a wall of style words; assuming order doesn't matter.
- **Consequence:** CLIP encodes in 75-token chunks and earlier tokens dominate composition; late tokens degrade to weak hints, and chunk boundaries can split concepts.
- **Rule:** Order: **subject → action/pose → setting → medium/style → lighting → incidental details**. Keep the critical content in the first ~40 tokens. Tag-style comma prompts for SD1.5/anime checkpoints; natural-language sentences for SDXL and especially FLUX (T5 encoder reads prose, and attention weighting syntax has little effect on it).

### 2 Weighting syntax
- **Mistake:** Pasting A1111 prompts with heavy weights `((masterpiece)), (thing:1.8)` into ComfyUI.
- **Consequence:** ComfyUI normalizes emphasis differently from A1111, so identical prompts render differently; weights above ~1.5 cause burn-in and anatomy artifacts.
- **Rule:** Use `(word:1.2)` explicit form only; stay in **0.8–1.3**. Don't expect A1111 seed/prompt parity — re-tune when porting.

### 3 Negative prompt strategy
- **Mistake:** Cargo-cult quality spam ("worst quality, lowres, bad anatomy, ...") on every model; putting "no hat" in the positive prompt.
- **Consequence:** Quality-tag negatives only help SD1.5/anime checkpoints trained on those tags; on SDXL/FLUX they waste tokens or shift style. "no hat" in a positive prompt *adds* hats.
- **Rule:** Negations go in the negative prompt as plain nouns (`hat`, `text, watermark`). Keep negatives short and targeted at observed failures. Know when negatives are dead: at CFG ≤ 2 (Turbo/Lightning/LCM) the negative is effectively ignored, and FLUX-dev's distilled guidance doesn't use one at all.

### 4 Consistency stack: choosing the wrong tool
- **Mistake:** Reaching for one mechanism for everything, or stacking all of them at full strength.
- **Consequence:** Wrong tool = wrong axis of control; over-stacking = rigid, muddy, artifact-prone outputs.
- **Rule:** Match tool to axis:

| Tool | Controls | Wins when | Cost/limit |
|---|---|---|---|
| **Character LoRA** (str 0.7–1.0) | Identity + outfit + style, robust across poses | Recurring character, production series; you have 15–50 clean images and can train | Training time; locked to one model family |
| **IPAdapter / FaceID / InstantID** (weight 0.5–0.8) | Face/identity from 1 reference, zero training | One-offs, fast iteration, no dataset | Weaker on outfit/full body; fights with style prompts at high weight |
| **ControlNet (pose/depth/canny)** (str 0.6–1.0, end ~0.8) | Pose and composition only | Exact framing/pose needed | Zero identity control — always pair with one of the above |

Standard combo: **one identity tool + one ControlNet**. Lower each tool's strength when combining; end ControlNet influence early (`end_percent ≈ 0.8`) to let details settle.

### 5 Sampler/scheduler mismatches
- **Mistake:** Treating samplers as interchangeable; using ancestral or SDE samplers when reproducibility matters; wrong sampler for distilled models.
- **Consequence:** Ancestral samplers (`euler_ancestral`, `dpmpp_2s_ancestral`) inject noise each step — never converge, and changing step count changes the whole image. `*_sde` samplers are non-deterministic on GPU. LCM/Lightning with a normal sampler+scheduler produces mush.
- **Rule:** Defaults that work: `dpmpp_2m` + `karras`, 24–30 steps (or `euler` + `normal` as the safe fallback). Distilled models: LCM → `lcm` sampler + `sgm_uniform`, 4–8 steps; Lightning/Turbo → `euler` + `sgm_uniform`, 4–8 steps, CFG 1–2. For exact reproducibility avoid `_ancestral` and `_sde`.

### 6 CFG and steps interactions
- **Mistake:** Cranking CFG for "prompt adherence"; cranking steps for "quality."
- **Consequence:** High CFG burns: oversaturated colors, crunchy contrast, deep-fried skin. Steps past convergence (~30 for 2M-Karras) only cost time; too few (<15 non-distilled) leaves mush.
- **Rule:** CFG ranges: **SD1.5: 6–8; SDXL: 4–7; FLUX-dev: CFG 1 + FluxGuidance ≈ 3.5**. If output looks burned, lower CFG before touching the prompt. When you change sampler family or model family, re-tune steps and CFG together — they are not independent knobs. If unsure, render one 4-value CFG sweep grid; that is cheaper than guessing.

### 7 Rendering off-native resolution
- **Mistake:** Generating 1920×1080 directly because the user asked for 1080p.
- **Consequence:** Duplicate heads, twin subjects, stretched anatomy — the model was trained near a fixed pixel budget.
- **Rule:** Generate at native: **SD1.5 ≈ 512–768 px side; SDXL ≈ 1 MP** (1024×1024, 832×1216, 1216×832); FLUX tolerates 0.5–2 MP. Then upscale: model upscaler (or latent upscale) + second KSampler pass at **denoise 0.3–0.55**. Higher denoise on the second pass reintroduces duplication.

### 8 Seed control and reproducibility
- **Mistake:** Believing "same seed = same image."
- **Consequence:** Irreproducible results and false bug reports.
- **Rule:** Reproduction requires the **full tuple**: seed + sampler + scheduler + steps + CFG + resolution + exact model/LoRA files + node graph — and bit-exactness additionally requires same GPU class and PyTorch version. In ComfyUI set the seed widget's `control_after_generate` to `fixed` (default `randomize` silently changes it every queue). Batches: each batch index gets different noise; regenerate with batch size 1 to isolate one image. ComfyUI embeds the entire workflow in output PNG metadata — treat saved PNGs as the reproducibility record and reload by dragging them onto the canvas.

### 9 VRAM budgeting
- **Mistake:** Adding LoRAs, two ControlNets, IPAdapter, and a 2 MP decode to an 8 GB card, then blaming ComfyUI for the crash.
- **Consequence:** OOM at the worst moment — usually **VAE decode**, which spikes far above sampling usage at high resolution.
- **Rule:** Budget before building: SDXL fp16 baseline ≈ 8–10 GB; each ControlNet ≈ +1–2 GB; IPAdapter ≈ +1 GB; FLUX-dev fp16 ≈ 24 GB (use **fp8 or GGUF quants** to fit 12–16 GB). On the edge: swap final decode to **VAE Decode (Tiled)**, reduce batch to 1, generate at native res and upscale in a second pass rather than sampling large. ComfyUI manages offloading automatically; `--lowvram` is a last resort, not a first move.

### 10 Model-family mismatches
- **Mistake:** Loading an SDXL LoRA/ControlNet with an SD1.5 checkpoint (or vice versa); ignoring VAE and clip-skip requirements.
- **Consequence:** Hard errors if lucky; silent garbage if not. Wrong/missing VAE gives washed-out desaturated output; anime SD1.5 checkpoints without clip skip give off-style results.
- **Rule:** Every add-on model (LoRA, ControlNet, IPAdapter) must match the checkpoint's family — check before wiring. Use the checkpoint author's recommended VAE. For anime SD1.5 models add `CLIP Set Last Layer = -2`.

### 11 What cannot be proceduralized here
Judging whether an image is *good* — composition, appeal, "burnt vs punchy" — is not fully rule-based. Proceduralize the search instead: generate grids (seed × CFG, or sampler × steps) with everything else pinned, compare, then narrow. A mid-tier model following the ranges above plus grid-based comparison will land within one iteration of frontier output; claiming the first render is optimal is the failure mode to avoid.

---

## Enforcement mechanisms — a prompt is not a mechanism

- **Pin everything:** ComfyUI version AND every custom node pack (IPAdapter_plus had breaking node renames; FaceID variants require their own loader node plus insightface). A workflow without pinned versions errors on first run somewhere.
- **No invented assets:** every checkpoint/LoRA/embedding is either a real, findable asset (name + source) or an explicit `PLACEHOLDER:` with acquisition/training instructions. An invented filename presented as real is a calibration failure.
- **Control-input provenance:** pose skeletons, lineart, and reference images are upstream deliverables — state how each is authored (3D mannequin render, DWPose extraction from what image, hand-drawn) and check they don't fight the prompt (lineart from a neutral face vs an open-mouth expression).
- **Soft targets get hard enforcement:** a muted palette needs hex/HSV target values, a deterministic post pass (LUT / grade / palette quantization shared across all outputs), and a measurable check (eyedropper per region, saturation histogram, DeltaE tolerance). Identity consistency needs an overlay or embedding-similarity check across finals. If the only enforcement is prompt tokens, expect drift.
- **The back view is structural:** models are weakest on back views and there is no canon to compare against. Invent the back once — single-canvas multi-view sheet, regional prompting, or reference-only ControlNet — rather than prompting it fresh per shot.
- **Turnaround discipline:** lock head-height ratio and framing across front/side/back with shared guide lines or identical camera/canvas geometry; resolve left/right ambiguity of the side view explicitly (which profile, where the asymmetric details sit).
- **Sweep, don't nudge:** tune with XY grid tests (IPAdapter weight x ControlNet strength x CFG), seed-locked, not one-knob 0.05 adjustments in a loop.
- **LoRA training is won in the data:** captioning strategy (prune the tags you want bound to the trigger word), regularization images, and per-epoch checkpoint comparison for overfit — rank and steps alone secure nothing.
- **Budget block (required):** VRAM for the full stack (base + refiner/hires + adapters + detailer), training and inference wall-clock, and the retake allowance.

- **Authoring vs execution mode:** with a running ComfyUI instance, grid sweeps are mandatory as written. When authoring a workflow without a server, deliver the workflow plus an embedded XY-grid test plan (exact axes, values, seeds) as NEEDS-RUN — and node-name verification against the node-pack source remains mandatory, since it needs no server.
