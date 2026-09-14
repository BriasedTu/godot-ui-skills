---
name: godot-animate-mobile
description: Use when implementing Godot UI for touch devices, including draggable panels, swipe feedback, mobile safe areas, virtual keyboards and optional haptics.
---
# Godot Motion on Touch Devices

Keep the construction sequence: purpose → native tool → properties → timing →
interruption → input/preferences → device verification. Read
[RECIPES.md](RECIPES.md) for native gesture patterns. Inspect engine version,
target platform, renderer, stretch settings and existing input code first.

## Decisions

- High-frequency navigation is eligible for immediate, subtle feedback. Touch
  must not depend on hover, and a connected controller still needs native focus.
- Prefer `Button`, `ScrollContainer`, native Control drag/drop and existing
  project widgets. Use an owned Tween for settling and AnimationPlayer for
  authored sequences. Add a gesture state machine only for custom interaction.
- Keep Container layout and hit regions stable; animate a visual child or overlay.
  Use local coordinates and elapsed seconds. Scaling the root UI changes the
  mapping from physical pixels to gameplay interface units.
- Track exactly one accepted touch index. Resolve scroll-vs-drag ownership before
  commitment; once canceled, restore visuals without performing the action.
- Inspect `input_devices/pointing/emulate_mouse_from_touch` and related settings.
  Do not process an emulated mouse event and its source touch as two activations.
  Avoid globally changing input configuration just to fix one widget.
- Direct manipulation follows the accepted pointer without easing behind it.
  Release can use distance/velocity thresholds and a tested spring or Tween.
  A bouncy interpolation curve does not carry velocity through interruption.
- Choose pause and unscaled-time policies for UI; pause processing alone does
  not neutralize `Engine.time_scale`. Reuse the game's preference source and
  settle safely when reduced motion changes while dragging or animating.

## Feedback and device boundaries

Use `Input.vibrate_handheld` only where supported, enabled by the player and
appropriate. Check the target version, platform/export requirements and hardware
support; no-op gracefully when unavailable. Controller vibration is a separate
API/capability. Trigger once at a semantic threshold or accepted outcome, never
each frame. Pair it with a visible cue; do not rely on haptics alone.

Recompute layout for display cutouts, safe areas, orientation and virtual
keyboard changes. `DisplayServer` values can use screen pixels; convert them
into the UI's coordinate space. Capability-check platform methods instead of
assuming every mobile device provides continuous keyboard position updates.

## Verification

Run parser/behavior checks, then inspect an actual target-device build: scroll
conflict, second finger, release outside bounds, focus loss/backgrounding,
orientation, keyboard cover, reduced motion, low frame rate and repeated gestures.
Desktop touch simulation is useful but does not prove mobile performance or
haptic feel. State any device/export checks not performed.

Deliver the native implementation and short evidence summary. Optional
`godot-animate` supplies general recipes; this skill is usable by itself.
