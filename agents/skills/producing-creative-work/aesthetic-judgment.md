# Externalizing Taste: Procedures That Substitute for Aesthetic Judgment

**How to read this file:** these are rules for you to follow now, not notes for a skill author. All numeric gates below are defaults, not absolutes — override any of them when the anchor demonstrably requires otherwise; cite the anchor property and write the waiver inline. If the project already has visual assets or a style guide, the anchor is extracted from them — introducing a new tradition requires flagging the divergence to the user first. If no named tradition fits the brief, a constructed anchor (a written property set for form/color/light, or an explicit two-anchor collision) is first-class; only adjective anchors ("cinematic") are banned. Anchor-descriptor justification applies to style-bearing choices only — legibility, function, and performance are standing licensed justifications.


Purpose: a mid-tier model has no reliable "this looks bad" signal. It will happily ship results that a frontier model would reject on sight. The fix is not "try to have taste" — it is to convert taste into decisions made **before generation** and checks run **after generation**. Every section below follows: (a) the technique, (b) the failure you get without it, (c) rules a skill document can state and a model can verify.

---

## 1. Style Anchor + Three Reference Descriptors (before anything else)

### What it is
Before writing a single line of bpy, prompt text, or shader code, commit in writing to ONE style anchor (a nameable, pre-existing visual tradition) and THREE reference descriptors (specific, checkable properties of that tradition). Everything generated afterward is judged against these four lines of text instead of against "does this look good."

### Failure without it
The mid-tier model averages. Asked for "a cozy cabin scene," it produces the centroid of all cabin images: generic warm light, generic wood texture, generic fog, generic composition. The output is never *wrong*, and never *specific*. Averaging is the single largest gap between mid-tier and frontier creative output. A frontier model implicitly picks a lane; a mid-tier model must be forced to.

### Rules
- **RULE: Before generating any asset, write a style block with exactly this shape, and keep it in context for the whole task:**
  ```
  ANCHOR: <one named tradition — a film, game, art movement, studio, illustrator, or era.
           Must be a proper noun or named movement, not an adjective.>
  DESCRIPTOR 1 (form):   <how shapes/geometry behave in this style>
  DESCRIPTOR 2 (color):  <the palette logic of this style>
  DESCRIPTOR 3 (light/surface): <how light and materials behave>
  ```
  Example: `ANCHOR: Moebius. FORM: flat clean linework, large empty areas, organic dunes. COLOR: desaturated sand + one acid accent. LIGHT: flat ambient, almost no cast shadow.`
- **RULE: "Realistic," "stylized," "cinematic," "beautiful," and "high quality" are banned as anchors.** They are adjectives, not traditions, and they resolve to the average.
- **RULE: Every subsequent decision (material roughness, prompt token, post-process choice) must be justifiable by one of the three descriptors.** If you cannot say which descriptor a choice serves, cut the choice.
- **RULE: If the user gave no style direction, propose one anchor in one sentence and proceed with it** — do not generate anchor-less, and do not stall on a long clarification exchange for a throwaway asset.
- Checkable test: after finishing, re-read the style block and list one concrete element in the output that satisfies each descriptor. If any descriptor has no corresponding element, the output failed the anchor and gets one revision pass targeting that descriptor only.

---

## 2. Value-Structure-First Design (3-Value Composition)

### What it is
Design the image as three flat luminance groups before any color, texture, or detail exists: a **dominant** value (~60–70% of the frame), a **secondary** value (~20–30%), and an **accent** value (~5–10%, placed at the focal point). Color is applied *within* the value groups afterward and is never allowed to break them.

### Failure without it
The mid-tier model builds scenes object-by-object, lighting each thing "so it's visible." Result: mid-gray mush — a histogram bulging in the middle, nothing dark, nothing bright, no focal read. Converted to grayscale, the image is illegible. This is the most common structural failure in Blender scenes and generated images alike.

### Rules
- **RULE: Before building, write one line assigning the three values:** e.g., `DOMINANT: dark (background forest) / SECONDARY: mid (ground, props) / ACCENT: light (window glow — focal point)`. Any of the six dark/mid/light orderings is valid; picking one is mandatory.
- **RULE: The accent value appears in exactly one region of the frame, and that region is the focal point.** If the brightest (or darkest) value shows up in three places, you have three competing focal points, i.e., none.
- **RULE (Blender): run the grayscale check before final render.** Set View Transform contrast preview or add an RGB-to-BW node in the compositor, render at low samples, and verify: (1) the three value groups are distinguishable, (2) area proportions are roughly 60/30/10, (3) the strongest value contrast in the whole image sits on the focal object. Fix with lighting, not with material albedo, first.
- **RULE (ComfyUI): specify value structure in the prompt, not just content.** Include tokens like `dark background, rim-lit subject`, `high-key, white-on-white with one dark accent`, `silhouetted foreground`. After generation, desaturate the output (with a node or a one-line PIL desaturate — never mentally; the check must produce an artifact) and apply the same three checks; if it fails, revise the lighting tokens, not the subject tokens.
- **RULE (game dev): assign value bands by gameplay function.** Background: one value band, low contrast internally. Platforms/interactables: second band. Player, enemies, pickups: highest-contrast band. A screenshot converted to grayscale must still let you point at the player instantly.
- Concrete number to enforce: **contrast between figure and its immediate background ≥ 30 points of luminance (0–255 scale)** at the focal point; internal contrast within the dominant area kept low (≤ 20 points).

---

## 3. Limited-Palette Discipline + Temperature Contrast

### What it is
Fix the palette before production: a small set of named colors with assigned roles, plus one deliberate warm/cool opposition. Every colored element must map to a palette slot.

### Failure without it
The mid-tier model colors each object "appropriately" in isolation — green grass, blue sky, red barn, brown fence, yellow flowers — producing the crayon-box look: many hues at similar saturation, no relationship between them, no mood. Second failure: it makes lights white and shadows gray, throwing away temperature contrast, the cheapest source of visual sophistication that exists.

### Rules
- **RULE: Declare the palette before creating any material or writing any color token: maximum 1 dominant hue family, 1 secondary hue family, 1 accent hue. Neutrals (near-zero saturation) are free.** Total distinct hue families in the frame: ≤ 3 (≤ 4 only if the anchor demands it — cite the anchor).
- **RULE: The accent hue is reserved for the focal point / interactive elements and may occupy at most ~10% of the frame.** In game dev, the accent hue is *functionally reserved*: if pickups are orange, nothing decorative is orange, anywhere, ever.
- **RULE: Saturation is hierarchical, not uniform.** Cap most of the frame at ≤ 40% saturation (S in HSV); allow the accent up to 80–100%. If everything is above 60% saturation, the image reads as AI kitsch — desaturate the dominant field first, not the accent.
- **RULE: Lights and shadows must differ in temperature.** Pick one: warm key / cool shadow (default, sunlight logic) or cool key / warm shadow (night, interior-window logic). Implementation: in Blender, tint the key light (e.g., 5500–6500K vs. a sky/fill at 8000K+, or literally shift hue ±15–30°); never leave every light at pure white 6500K. In ComfyUI, state it in the prompt (`warm sunlight, cool blue shadows`, `teal ambient, tungsten practicals`).
- **RULE: Shadows are never neutral gray or pure black.** Shift shadow color toward the cool (or warm) side of the declared opposition.
- Checkable test: sample 5 random points in the output plus 1 point on the focal object. Each sample must classify into a declared palette slot. Any sample that doesn't → that element gets recolored to the nearest slot.

---

## 4. Silhouette-First Modeling + Readability Tests

### What it is
Design and evaluate every object, character, and scene as a flat black shape first. Detail is only allowed after the silhouette alone communicates identity, orientation, and (for characters) pose/intent.

### Failure without it
The mid-tier model models front-to-back: starts with a base mesh, adds features, adds detail — and never once looks at the outline. Results: characters whose arms merge into the torso mass, props that read as blobs at gameplay distance, buildings that are extruded rectangles with detail smeared on. It compensates for bad silhouettes with more surface detail, which makes it worse.

### Rules
- **RULE (Blender): run the silhouette render before detailing.** Procedure: Workbench renderer, flat lighting, all objects with pure black flat color on white world (or matcap set to single color) — one render from the primary camera. Pass criteria: (1) each major object is identifiable from its outline alone, (2) no two important objects' silhouettes merge into one blob, (3) a character's pose reads (limbs separated from torso where intent matters). Fail any → fix the blocking *before* adding any modifier, texture, or detail.
- **RULE: Vary the three primary dimensions of every hero object.** No hero shape is a near-cube. Force ratio differentiation (e.g., ~1 : 1.6 : 0.4). Near-equal proportions read as programmer art.
- **RULE: Build big-medium-small.** Every object: one primary mass (the silhouette), 2–4 secondary forms (readable at half distance), then tertiary detail. Never start tertiary before the silhouette render passes. Rough budget: primary forms decided at ~10% of the modeling effort, and they are frozen after that.
- **RULE (game dev): the 8-meter test.** Render/screenshot at actual gameplay camera distance and at 25% resolution scale. Player, enemies, and interactables must remain individually identifiable. If not, fix silhouette or value contrast — never fix by adding an outline shader first (outline shaders are a legitimate style choice via the anchor, not a bandage).
- **RULE (ComfyUI): silhouette lives in the prompt's noun phrases.** Describe shape explicitly (`tall thin figure in a wide-brimmed hat, asymmetric cloak`) rather than material detail (`intricate ornate detailed armor` — a kitsch token that produces noise, not shape). If character/object identity matters, generate, then squint-test the thumbnail at ~64px: if the subject is unidentifiable, revise shape words, not quality words.

---

## 5. Focal Hierarchy + Composition Schemes

### What it is
Decide the viewing order — 1st read, 2nd read, 3rd read — and pick one named composition scheme that delivers it. Then stack multiple contrast types (value, saturation, temperature, detail, sharpness, geometry) on the 1st read and strip them from the 3rd.

### Failure without it
The mid-tier model centers the subject, levels the camera at chest height with a ~50mm default FOV, distributes objects evenly across the frame, and gives everything equal lighting. Nothing leads the eye; the image is an inventory, not a picture. In games: HUDs and effects that all scream at equal volume.

### Rules
- **RULE: Write the read order before setting up the camera:** `1st READ: <focal subject>. 2nd READ: <supporting element>. 3rd READ: <environment>.` Three items, no more.
- **RULE: Pick exactly one composition scheme by name and place the focal point according to it:** rule of thirds (focal point on an intersection), golden triangle/diagonal (focal point on the diagonal, supports in the triangles), L-composition (dark L frames a light interior), central/symmetric (ONLY when the anchor justifies formality — a deliberate choice, never the default), or leading lines converging on the focal point. State the scheme in one line; it becomes checkable.
- **RULE: Stack ≥ 3 contrast types on the 1st read.** The focal point should win on at least three of: brightest-vs-darkest value junction, highest saturation, temperature outlier, highest detail density, sharpest edges, only curved thing among straights (or the reverse), faces/eyes if present. The 3rd read gets at most one mild contrast.
- **RULE (Blender camera): never leave the defaults.** Choose focal length by intent — 24–35mm for environments/drama (and add subtle perspective convergence), 50–85mm for subjects/portraits, and set camera height deliberately (low angle = imposing, high = vulnerable/map-like, eye level = neutral — pick one and say why in a comment). Tilt or position so the horizon is NOT at 50% frame height; put it near the top or bottom third.
- **RULE: leave empty space.** At least ~30% of the frame is rest area — low detail, low contrast, one value group. The mid-tier instinct to fill every region is the failure; emptiness is what makes the focal point loud.
- **RULE (game feel / UI): rank every screen-space element 1–3 in importance; only rank-1 may use accent color + motion + sound simultaneously.** Rank-3 elements get no animation at idle. If everything pulses, nothing does.
- Checkable test: blur the render/screenshot heavily (or view thumbnail at 5%). The location your eye lands first must be the declared 1st read. If it lands elsewhere, reduce contrast where it landed; do not add more contrast to the focal point (arms race → oversaturation).

---

## 6. Avoiding the Default Look (AI Kitsch, Plastic Materials, Uniform Detail, Oversaturation)

### What it is
A blocklist plus positive replacements for the recognizable signature of machine-generated art. The default look is a *cluster* of failures that co-occur: everything is a symptom of "no decision was made."

### Failure without it
The mid-tier model, unprompted, produces: glossy uniform plastic materials (default Principled BSDF, roughness 0.5 everywhere), even detail density corner to corner, saturation cranked because "vibrant reads as good," bloom/lens-flare/volumetric-god-rays as substitutes for lighting design, and prompt tokens like `masterpiece, 8k, ultra detailed, trending on artstation, epic, hyperrealistic`. Each is a tell; together they scream default.

### Rules
- **RULE (materials, Blender): no material ships with default Principled values.** Every material must set, deliberately: base color (from the palette, never RGB primaries or pure #FFFFFF/#000000 — clamp albedo to roughly 0.05–0.9), roughness (chosen, and *varied across the surface* via a noise/curvature/AO-driven map — real objects are never one roughness), and at least one of: edge wear, dirt in crevices (AO-masked), or subtle color variation (noise into hue/value at low strength). A one-node material is only acceptable if the anchor is explicitly flat-shaded/toon — cite the anchor.
- **RULE: detail density must follow the focal hierarchy, never be uniform.** Detail (geometry, texture frequency, prop clutter) concentrates at the 1st read and decays toward the frame edges and the 3rd read. Concrete check: divide the frame in a 3×3 grid; the cell containing the focal point should visibly out-detail the corner cells. If all nine cells are equally busy, delete detail from eight of them — deleting is the fix, adding is not.
- **RULE (ComfyUI prompt hygiene): ban the kitsch token cluster.** Never emit `masterpiece, best quality, 8k, ultra-detailed, trending on artstation, epic, award-winning, hyperrealistic, intricate` as generic boosters. Replace with the style block from Section 1: medium (`gouache`, `35mm Kodak Portra`, `flat-shaded 3D render`), era/tradition, light description, palette description. Quality tokens describe *nothing*; the model fills the vacuum with the average, which is the kitsch look itself.
- **RULE (ComfyUI): put the default look in the negative prompt explicitly** when photorealism is not the anchor: `oversaturated, HDR look, plastic skin, airbrushed, bloom` — tuned to the anchor.
- **RULE: saturation ceiling and bloom budget.** Global rule of thumb: if >50% of pixels exceed 60% saturation, desaturate the dominant field (Section 3). Bloom/glare: threshold high enough that only actual emitters bloom; volumetrics only if the anchor's light descriptor calls for atmosphere; lens flares: no, unless the anchor is explicitly retro-photographic.
- **RULE: one imperfection minimum, everywhere humans touched.** Perfect alignment is a tell. Rotate props off-axis by 1–5°, vary duplicated objects (scale ±5–10%, rotation, one changed component), misalign the "perfectly centered" by a small deliberate offset. In bpy, never instance N identical objects in a clean grid without a jitter pass — write the jitter loop by default.
- **RULE (game feel): defaults are also temporal.** Linear interpolation everywhere, identical animation durations, no anticipation/follow-through = the motion equivalent of plastic materials. Every UI/gameplay motion uses an easing curve chosen on purpose (ease-out for entrances/responses ~100–200ms, ease-in for exits, overshoot only on rank-1 feedback), and impact events get ≥ 2 simultaneous channels (e.g., hitstop 2–4 frames + particle + sound + 2–6px camera impulse) — but scaled to the event's rank in the hierarchy.

---

