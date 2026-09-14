---
name: godot-animate
description: Use when implementing Godot UI motion, control feedback, panel transitions, inventory selection, or animated interface state changes.
---
# Building Godot UI Motion

Turn a motion request into native scenes and GDScript. Preserve the order:
purpose before ingredients, interruption before polish, running evidence before
claims about feel. Read [RECIPES.md](RECIPES.md) for the matching component and
[ENGINE.md](ENGINE.md) for ownership, timing and validation details.

## Build sequence

1. **Recon.** Inspect `project.godot`, engine version, target renderer/devices,
   scene hierarchy, input actions and existing motion/settings conventions.
   Respect the project's instructions and chosen implementation language; the
   bundled examples use GDScript. Do not require an engine upgrade or new add-on.
2. **Gate.** Name the purpose: feedback, orientation, state readability,
   continuity, explanation, reward or atmosphere. Repeated navigation needs
   immediate input response and brief, retargetable feedback. Keyboard and
   controller input are eligible. Remove decorative loops that impair reading.
   Longer rewards and narrative beats need their own pacing and skip contract.
3. **Choose the smallest native tool.** Use `Theme` states for static feedback,
   an owned `Tween` for changing targets, `AnimationPlayer` for authored tracks,
   a tested spring for velocity continuity, or `CanvasItem` drawing/materials for
   masks and effects. `AnimationTree` is for actual blending/state graphs, not a
   prerequisite for a button. Read [ENGINE.md](ENGINE.md) before combining owners.
4. **Choose properties and origins.** Keep interactive layout stable. Animate a
   visual child inside a layout slot; let `Container` own its direct children.
   Prefer local `position`, `scale`, `rotation`, `modulate:a` or bounded material
   parameters where appropriate. Expanding content may need measured layout
   changes; do not stretch paragraphs to simulate reflow. Recalculate
   `pivot_offset` after layout and convert trigger coordinates into local space.
5. **Choose timing.** Extend existing tokens. Otherwise start with press/focus
   0.08–0.14 s, small panels 0.16–0.24 s, screens 0.20–0.35 s. Try
   `TRANS_CUBIC` + `EASE_OUT` for immediate response and `TRANS_SINE` +
   `EASE_IN_OUT` for travel. These are prototype values, not universal limits.
   An authored anticipation can accelerate; a readable fade is a valid entrance.
6. **Handle interruption and exit.** Update requested state immediately. Kill
   the previous tween for those properties, build a new one from current values,
   and invalidate old completions with a generation ID. Define hide/free,
   cancellation and focus behavior. A killed tween does not finish successfully.
   UI completions must not accidentally commit the same game action twice.
7. **Handle input and preferences.** Use native button signals/focus and mapped
   actions; do not double-bind acceptance. Decorative children ignore pointer
   input. Apply the game's reduced-motion setting at runtime; snap or fade while
   preserving state cues. Explicitly choose pause and time-scale behavior.
8. **Verify.** Parse/import with the actual engine, run focused behavioral
   checks, and inspect the rendered interaction. Test rapid reversal, resizing,
   focus/activation, disposal, pause and changed preferences. Slow presentation
   locally for inspection rather than slowing the entire game's simulation.

Deliver the implementation, a short ingredient summary and what was actually
tested. Distinguish a headless pass from visual inspection. If no runtime is
available, deliver reviewable code and state the untested boundary.

## Runnable reference

[motion-lab](assets/motion-lab/project.godot) is a standalone Godot 4.6 project.
It demonstrates stable button hit regions, retargetable panel visibility,
reduced motion and an explicitly pause-independent presentation clock. Copy
only the needed pattern into a real project; it is not a required framework.
