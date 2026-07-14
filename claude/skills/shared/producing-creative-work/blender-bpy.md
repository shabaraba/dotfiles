# Blender / bpy

### 1 Relying on `bpy.ops` where the data API works
- **Mistake:** Driving everything through `bpy.ops.*` (operator calls) as if scripting the UI.
- **Consequence:** Operators depend on context (active object, selection, mode, window/area) and raise `RuntimeError: Operator bpy.ops.X.poll() failed, context is incorrect` — especially headless. Ops also force a scene update per call, so loops are 10–100x slower.
- **Rule:** Prefer `bpy.data` / `bmesh` / `mesh.from_pydata()` for creation and editing. Use `bpy.ops` only for things with no data-API equivalent (e.g. `transform_apply`, render). Before any op, explicitly set state: `obj.select_set(True); bpy.context.view_layer.objects.active = obj`.

### 2 Legacy context override (removed)
- **Mistake:** Passing a context dict as the first argument: `bpy.ops.object.delete(override_dict)` — common in pre-3.2 training data.
- **Consequence:** `TypeError` in Blender 4.x; the calling convention was removed.
- **Rule:** Use `with bpy.context.temp_override(**overrides): bpy.ops...` (Blender 3.2+). If you can avoid needing an override at all (see 1.1), do that instead.

### 3 Mode confusion
- **Mistake:** Calling edit-mode ops in object mode, or reading/writing `mesh.vertices` while the mesh is open in Edit Mode.
- **Consequence:** Poll failures; or silent stale data — edit-mode geometry lives in a BMesh, so `bpy.data` reads/writes don't round-trip until mode toggle.
- **Rule:** Do all data-API edits in OBJECT mode. If you must work in Edit Mode, use `bmesh.from_edit_mesh(me)` + `bmesh.update_edit_mesh(me)`. Guard mode switches: `mode_set` fails if there is no active object.

### 4 New objects not linked to a collection
- **Mistake:** `obj = bpy.data.objects.new("X", mesh)` and stopping there.
- **Consequence:** Object exists but is invisible and never renders — a classic "script ran fine, render is empty" bug.
- **Rule:** Always link: `bpy.context.scene.collection.objects.link(obj)` (or a specific collection). When deleting, use `bpy.data.objects.remove(obj, do_unlink=True)`.

### 5 Headless (`blender -b`) quirks
- **Mistake:** Assuming a `-b` run behaves like the GUI: same prefs, same addons, exceptions abort, viewport available.
- **Consequence:** View-dependent ops fail (anything needing a 3D viewport, OpenGL/viewport render); user addons/prefs may alter results between machines; a Python exception in your script still exits 0, so CI reports success on a broken run.
- **Rule:** Invoke as `blender -b --factory-startup file.blend -P script.py -- <your args>` (parse args after `--` via `sys.argv[sys.argv.index("--")+1:]`). Enable any needed addon explicitly in the script. Add `--python-exit-code 1` so exceptions fail the job. Set `scene.render.filepath` to an absolute path and render with `bpy.ops.render.render(write_still=True)` — nothing is written otherwise.

### 6 GPU rendering headless
- **Mistake:** Setting `scene.cycles.device = 'GPU'` and assuming GPU is used.
- **Consequence:** Silently renders on CPU (or errors) because Cycles devices are a *preferences* setting not stored in the .blend.
- **Rule:** In the script: get `prefs = bpy.context.preferences.addons['cycles'].preferences`, set `prefs.compute_device_type = 'OPTIX'` (or `'CUDA'`/`'METAL'`/`'HIP'`), call `prefs.get_devices()`, set `d.use = True` on each device, then `scene.cycles.device = 'GPU'`. Log the device list so failures are visible.

### 7 Blender 4.x Principled BSDF socket renames
- **Mistake:** Using pre-4.0 socket names or numeric indices from old training data: `inputs["Specular"]`, `inputs["Subsurface"]`, `inputs["Transmission"]`, `inputs["Clearcoat"]`, `inputs["Emission"]`, `inputs[5]`.
- **Consequence:** `KeyError`, or with indices, silently writing the wrong socket (indices shifted in 4.0).
- **Rule:** Access sockets **by 4.x name only**: `Base Color`, `Metallic`, `Roughness`, `IOR`, `Alpha`, `Specular IOR Level`, `Subsurface Weight`, `Transmission Weight`, `Coat Weight`, `Sheen Weight`, `Emission Color`, `Emission Strength`. Never index numerically. If code must span versions, branch on `bpy.app.version`.

### 8 Other 4.x API drift
- **Mistake:** `mesh.use_auto_smooth = True` (removed 4.1), `mesh.calc_normals()` (removed 4.0), engine id `'BLENDER_EEVEE'` (4.2 renamed EEVEE Next to `'BLENDER_EEVEE_NEXT'`), old Filmic-look assumptions.
- **Consequence:** AttributeError/enum errors; or renders that look different from every pre-4.0 tutorial because 4.0 changed default view transform from Filmic to **AgX** (less saturated, different contrast).
- **Rule:** For smooth shading use `bpy.ops.object.shade_smooth()` plus `bpy.ops.object.shade_auto_smooth(angle=...)` / the "Smooth by Angle" modifier in 4.1+. Set the render engine string per version. If you need the legacy look, set `scene.view_settings.view_transform` explicitly — don't assume.

### 9 Units and scale
- **Mistake:** Modeling at arbitrary scale ("it's all relative").
- **Consequence:** 1 Blender unit = 1 meter. Wrong scale breaks physics (a 100 m cube falls "in slow motion"), light falloff (lamps are in Watts), SSS/volumetrics, camera clipping (z-fighting or clipped geometry on tiny/huge scenes), and exports (FBX to game engines lands at 100x/0.01x).
- **Rule:** Build at real-world size. For very small/large scenes adjust `camera.data.clip_start/clip_end`. On import scale problems, fix scale then apply it (1.10).

### 10 Unapplied transforms
- **Mistake:** Leaving non-uniform object scale/rotation baked into the object transform.
- **Consequence:** Modifiers misbehave (Bevel widths skew, Solidify thickness varies, Array spacing wrong), normal maps and physics break, exports come in sheared or wrong-sized.
- **Rule:** After blocking out size, run `bpy.ops.object.transform_apply(rotation=True, scale=True)` **before** adding modifiers or exporting. Keep location unapplied unless you specifically want origin at world zero.

### 11 Normals and shading artifacts
- **Mistake:** Ignoring face orientation after scripted/boolean geometry.
- **Consequence:** Flipped normals render black in EEVEE with backface culling, break bevel/solidify direction, and produce inside-out lighting.
- **Rule:** After generating geometry, recalculate: enter Edit Mode, select all, `bpy.ops.mesh.normals_make_consistent(inside=False)` (or `bmesh.ops.recalc_face_normals`). For hard-surface, shade smooth + Smooth by Angle (~30°). Watch for imported meshes carrying custom split normals that override your edits — clear them if shading looks locked.

### 12 Cycles vs EEVEE assumptions
- **Mistake:** Building a material/lighting setup on one engine and rendering on the other, or leaving defaults.
- **Consequence:** EEVEE needs features enabled per-material/per-scene (refraction, raytracing in EEVEE Next, volumetric quality, blend modes for alpha); results diverge wildly from Cycles. Cycles at default samples is noisy or slow.
- **Rule:** Decide the engine first and set it in the script. For Cycles set `scene.cycles.samples` explicitly (128–512 stills; use adaptive sampling) and enable a denoiser. For EEVEE, explicitly enable every non-default feature the material relies on. Never claim visual parity between engines.

### 13 Non-deterministic renders
- **Mistake:** Expecting pixel-identical renders across runs/machines with defaults.
- **Consequence:** CI image diffs flap.
- **Rule:** Fix `scene.cycles.seed`, disable `use_animated_seed`, pin sample counts, and use `--factory-startup`. GPU denoising (OptiX, GPU OIDN) is not bit-stable — for pixel-exact comparisons denoise on CPU or compare with a perceptual threshold instead of exact equality. Same Blender version + same device class, always.

---

## Computable checks — never assert what you can calculate

- **Framing:** never claim the hero subject fits the frame by intuition. Compute the subject's world-space bounding box and verify it against the camera frustum (`camera_fit_coords`, or FOV math from lens + sensor + distance), with headroom margin. Print the numbers in the script.
- **Containment/overlap:** before shipping, check that meshes meant to be adjacent do not interpenetrate — compare bounding extents numerically (a foam ring's radius vs the displaced rock's max radius). Propose a clay/solid-override draft render as the visual audit.
- **Parenting after placement:** `obj.parent = other` without `obj.matrix_parent_inverse = other.matrix_world.inverted()` re-bases world transforms and displaces the child. Parent first then position, build in local space, or set the inverse matrix.
- **DOF:** place the focus plane ON the hero subject (focus_object or measured distance), not at a fraction of the aim distance.
- **Version-guard risky nodes:** the Sky texture API changed across 4.x (`sky_type` values and Nishita removal in newer versions); `ShaderNodeMix` with `data_type='RGBA'` must select sockets by `socket.identifier` only (`A_Color`/`B_Color`) — never numeric indices, which silently break when the node adds sockets — `inputs["A"]` returns the disabled Float socket. If you cannot verify a property exists in the pinned version, guard with `hasattr`/try and mark NEEDS-CHECK.
- **Fireflies by construction:** a small bright emitter enclosed in glass/transmission is a firefly generator — enlarge the mesh light, use light-path tricks, or set `cycles.sample_clamp_indirect`.
- **Depth is built in, not deferred:** layered terrain needs aerial perspective (mist pass, distance-driven desaturation, or fog volume) in the shipped script, or the layers read as same-plane clutter.
- **Output robustness:** set `scene.cycles.device` explicitly (headless defaults to CPU); don't rely on `bpy.path.abspath("//...")` with an unsaved .blend — derive paths from the script location or argv after `--`; use 16-bit PNG/EXR for smooth sky gradients (8-bit bands).
- **Frame every named element, not just the hero:** a frustum fit that only checks the hero bounding box passes even when a background layer sits BEHIND the camera. Verify each element the brief names (depth layers, sea, props) lands inside the view frustum with its intended screen share, and print the check. Verify gradient/mapping axes numerically too — evaluate the world shader toward zenith vs horizon and print both values, rather than trusting a rotation to have moved the axis you think it did.
- **Budget block (required):** expected render wall-clock at final samples/resolution, VRAM estimate, and total poly count — stated next to the render settings.
