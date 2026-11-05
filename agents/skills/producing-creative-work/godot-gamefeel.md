# Godot 4 Game Feel

**This file is the canonical source of game-feel numbers.** If another file in this skill states a different band for the same parameter, the values here win.

### 1 `_process` vs `_physics_process`
- **Mistake:** Moving a `CharacterBody2D` in `_process`, or splitting movement logic across both callbacks.
- **Consequence:** Frame-rate-dependent movement, tunneling, and jitter against physics objects.
- **Rule:** All velocity changes and `move_and_slide()` go in `_physics_process`. `_process` is for visuals only (sprite scale, camera cosmetics, UI). Never let the same state be written from both.

### 2 Delta misuse with `move_and_slide()`
- **Mistake:** `move_and_slide(velocity * delta)` (Godot 3 muscle memory) or multiplying velocity by delta before assigning.
- **Consequence:** In Godot 4, `move_and_slide()` takes **no arguments**, uses the `velocity` property, and applies delta internally — pre-multiplying makes the character move at 1/60th speed or become tick-rate dependent.
- **Rule:** Apply delta exactly once, to *accelerations*: `velocity.y += gravity * delta`, `velocity.x = move_toward(velocity.x, target, accel * delta)`, then bare `move_and_slide()`.

### 3 Frame-rate-dependent lerp smoothing
- **Mistake:** `position = position.lerp(target, 0.1)` every frame.
- **Consequence:** Smoothing speed changes with FPS; feels different on 60 vs 144 Hz monitors.
- **Rule:** Use exponential decay: `a = a.lerp(b, 1.0 - exp(-k * delta))` with k ≈ 5–15 (higher = snappier). Same for camera follow and squash recovery done in `_process`.

### 4 Copy-pasted gravity/jump constants
- **Mistake:** Using the project default gravity (980) and guessing a jump velocity.
- **Consequence:** Floaty, untunable jumps; designers can't reason about "how high."
- **Rule:** Derive from design intent: choose jump height `h` (e.g. 3 tiles) and time-to-apex `t` (0.3–0.45 s), then `jump_velocity = -2h/t`, `gravity = 2h/t²`. Multiply gravity by **1.6–2.2 when falling** and cut upward velocity to **40–50%** on jump-button release (variable jump). Expose all of these as `@export` vars.

### 5 Missing coyote time and jump buffering
- **Mistake:** `if is_on_floor() and jump_pressed` as the entire jump condition.
- **Consequence:** Players "drop" jumps at ledge edges and eat inputs pressed a few frames early — the game reads as unresponsive even when technically correct.
- **Rule:** Implement both. Starting values: **coyote time 80–120 ms**, **jump buffer 100–150 ms**. Count them down in `_physics_process`; jump if `coyote_timer > 0 and buffer_timer > 0`, then zero both.

### 6 Input handling
- **Mistake:** Hardcoding keycodes; reading `is_action_just_pressed` in multiple callbacks; leaving the default joystick deadzone.
- **Consequence:** Unbindable controls; double-consumed or inconsistent presses; the default 0.5 deadzone makes analog movement feel dead.
- **Rule:** Use Input Map actions only. Read each `just_pressed` in exactly one callback (it is physics-frame-aware in `_physics_process`, so that's fine — just don't read the same action in both). Set action deadzones to ~0.2 and use `Input.get_vector()` (circular deadzone, normalized) for movement.

### 7 Camera jitter and smoothing
- **Mistake:** Camera2D smoothing a physics-driven target updated in `_process`, or stacking `position_smoothing` on top of manual lerp.
- **Consequence:** Visible stutter, worst when monitor Hz ≠ physics tick rate; double-smoothing feels like rubber.
- **Rule:** One smoothing source only. Either enable physics interpolation (project setting, Godot 4.3+ for 2D) and Camera2D's built-in `position_smoothing` (values 3–8), or move the camera yourself in `_physics_process`. For platformers: add horizontal look-ahead in the facing direction and a larger vertical deadzone so the camera doesn't pump on every jump.

### 8 Squash & stretch on the wrong node
- **Mistake:** Tweening `scale` on the CharacterBody itself.
- **Consequence:** Scales the collision shape — physics glitches, ground clipping.
- **Rule:** Scale only the Sprite/visual child. Values: land = `(1.2, 0.8)`, jump launch = `(0.8, 1.2)`, recover to `(1,1)` with a 0.1–0.2 s tween (`TRANS_QUAD`/`TRANS_BACK`, ease out). Keep x·y ≈ 1 to preserve volume.

### 9 Screen shake and hitstop done naively
- **Mistake:** Random camera offset every frame with linear falloff; hitstop via `Engine.time_scale = 0` restored by a normal timer.
- **Consequence:** Shake reads as noise, not impact; a time-scaled timer never fires, freezing the game permanently.
- **Rule:** Use the trauma model: accumulate `trauma` (0–1), offset = `max_offset * trauma² * noise(t)` (max offset 8–24 px, decay ~1–2 trauma/s). Hitstop: 40–100 ms at `Engine.time_scale ≈ 0.05`, restored via `get_tree().create_timer(dur, true, false, true)` — the last `true` is `ignore_time_scale`.

### 10 Particle cost and lifecycle
- **Mistake:** Instancing a new GPUParticles2D per hit and `queue_free()` immediately; huge `amount`; GPUParticles on the web/Compatibility renderer.
- **Consequence:** Effects vanish before playing (freed early), draw-call and material-compile spikes, broken/expensive particles on Compatibility.
- **Rule:** Pool particle nodes; trigger with `restart()` + `one_shot`; free only on the `finished` signal. Keep counts small (dust: 4–16, explosion: 16–48). Use CPUParticles2D when targeting web/Compatibility. Share ParticleProcessMaterials.

### 11 What cannot be proceduralized here
Feel tuning is iterative by nature. The numbers above are **starting points that land in the acceptable band**, not final answers — final values require playing the build. Proceduralize the *loop* instead: expose every constant as `@export`, tune while running, and change one variable at a time. A model that ships the starting values plus live-tunable exports approximates frontier behavior; a model that claims the first values are "polished" does not.

---

## Measured pitfalls — the invisible-by-reading bugs

- **Squash-and-stretch pivot:** scaling a center-pivoted sprite sinks the feet into the floor on squash and lifts them on stretch. Anchor the sprite origin at the feet (offset) or compensate position inside the same tween. This is the single most common juice bug that reads fine in code.
- **Camera as child of the player:** it inherits the player's motion, so smoothing/lag never manifests. Set `top_level = true` on the Camera2D or make it a sibling; add deadzone/drag margins and level limits.
- **Lead camera from facing/input, not `sign(velocity.x)`:** velocity-driven lead snaps sides on turnarounds and collapses during deceleration. Slew-limit the lead flip or add a turn-hold delay.
- **Derived constants vs live tuning:** jump velocity/gravity computed once in `_ready()` from @export values makes remote-inspector tuning a no-op. Recompute in setters, or derive every physics frame in debug builds. (Also: edits to a local `.tres` do NOT propagate to a running game — live tweaking happens in the Remote scene tree.)
- **State-machine leaks:** apex-hang gated on a velocity band triggers on walk-off falls (floaty drops) and can stay latched when landing inside the band (speed bonus applied while grounded). Gate on jumped-state; emit exit events on every landing.
- **Buffered jump vs variable height:** consuming the buffer without re-checking the button is still held turns a quick tap into a full-height jump. Re-check `Input.is_action_pressed` at consume time, or apply the cut retroactively.
- **Pixel discipline at low res:** declare stretch mode (viewport vs canvas_items), 2D transform/vertex snapping, and physics interpolation. A per-render-frame smoothed camera over a 60Hz physics body judders at 144Hz — enable physics interpolation or smooth the visual, and say which.
- **Budget block (required):** GPUParticles2D vs CPUParticles2D tradeoff (web export, low-end, first-emission shader-compile hitch), particle counts, and any per-frame allocation in `_process`.
