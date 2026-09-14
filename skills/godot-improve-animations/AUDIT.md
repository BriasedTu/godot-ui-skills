# Godot motion audit playbook

Use this catalog to ask questions, not to invent findings. Search native scene,
script and animation resource files. Record the actual version and constraints.

| Category | Inspect | Evidence that justifies a finding |
| --- | --- | --- |
| Purpose and frequency | Input response, readable values, decorative loops, reward pacing | An action waits for decoration, targets move during selection, or motion hides useful information |
| Timing and easing | Tween enums, Animation tracks, constants, stagger sums, initial delays | Observed lag/discontinuity or mismatch with a documented contract; not merely an uncommon enum |
| Geometry and origin | Container ownership, pivots, anchors, transforms, text reflow, screen bounds | Resizing resets an effect, hit area shifts, text distorts, or origin is visibly wrong |
| Interruption and lifecycle | One property owner, kill/replace, generation guards, disposal, loop/finished semantics | An obsolete close wins, callbacks reach freed objects, input stays locked, or a command fires twice |
| Performance | Per-frame allocation/loading, layout churn, node count, overdraw and shaders | Profiler/trace measurements, or a precise hypothesis flagged as unmeasured |
| Accessibility and input | Focus, native activation, touch indices, modal isolation, reduced motion, text size | A supported input path fails, information relies only on motion/color/sound, or a preference change is ignored |
| Cohesion and resources | Existing Theme/motion tokens, visual identity, material sharing | Duplicated divergent values or an instance effect unintentionally mutates other controls |
| Missing continuity | Adds/removes, navigation, inventory reorders, bounded group entrances | An actual relationship becomes hard to follow and a small native treatment helps |

## Native checkpoints

- `Container` direct-child geometry is managed; visual wrappers can animate
  independently. Legitimate layout animation must account for minimum size and
  changed content. `Control.rotation` is planar; depth requires another approach.
- A new Tween per action with current start values is normal. Killing an old
  Tween is cancellation, not successful completion. `AnimationPlayer` is valid
  for authored tracks; explicit reset/stop/blend policy matters more than the tool.
- `TRANS_SPRING` is time interpolation. Velocity-preserving releases need a
  tested spring/inertia state, consistent coordinate units and bounded timesteps.
- Separate pause from time scale. UI input must process when its visuals do.
  A full-screen faded control can still intercept input; descendants and keyboard
  focus need explicit handling when a view closes.
- Built-in easing and fade-only transitions are allowed. Prototype defaults:
  press/focus 0.08–0.14 s, panel 0.16–0.24 s, screen 0.20–0.35 s; cubic-out for
  response, sine-in-out for travel. Preserve project values when intentional.
- Repeated focus changes should acknowledge input immediately. Cap total
  decorative stagger; animate fewer entries or skip when the group is large.
- Use a real viewport for feel and the target device for performance. Headless
  tests establish behavior but cannot establish visual quality.

## Verification scenarios for plans

Use only scenarios relevant to the finding: A→B→C selection faster than the
feedback; open→close→reopen; resize/localization while moving; input during exit;
pause and time-scale changes; reduced-motion change during interpolation;
scene replacement mid-animation; mobile scroll/drag conflict; repeated
notification update and expiry. Define expected semantics, not just “looks good.”
