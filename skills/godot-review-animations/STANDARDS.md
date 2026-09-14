# Godot motion review standards

## Purpose and timing

Look for feedback, orientation, state readability, explanation, reward or
atmosphere that serves the game. Repeated actions need low latency and small
visual cost. Focus should change immediately even when an indicator retargets.
Pure fades or immediate state changes are valid, including reduced motion.

Use project tokens. Starting ranges when none exist: press/focus 0.08–0.14 s;
small panels 0.16–0.24 s; screens 0.20–0.35 s. Cubic-out is a sensible response
curve; sine-in-out suits travel. These are not automatic pass/fail thresholds.
Staggered groups need a cap on total delay and immediate response to interaction.
Long narrative/reward sequences need intentional pacing and skip behavior.

## Geometry and identity

- A `Container` owns direct-child layout. Animate nested visual offsets or
  explicitly design layout interpolation; do not assume direct-child scale or
  position survives sorting.
- Keep logical hit regions stable during decorative motion. Reflow text for
  expanded content; reserve scale for brief intentional feedback.
- Recompute pivot and measured targets after resizing. Trigger/global/viewport
  coordinates must be converted into the animated node's local space.
- Use stable identity for list entries. Avoid destroying/recreating a control
  merely to refresh its motion state.

## Ownership, interruption and lifetime

Trace every property writer, including Theme changes, scripts, Tweens,
AnimationPlayer and AnimationTree. Overlap is a defect only when ownership is
not coordinated. Store/kill an obsolete tween and create a fresh one from
current properties. `Tween.new()` is not a valid scene-tree animation setup.

Open→close→reopen must finish open. Old completions cannot hide/free/disable the
new action. Guard callbacks with generation/state checks; define cancellation
separately from normal completion. An await on a killed tween cannot be the
only path that unlocks input. Looping tracks have no normal end. On scene exit,
dispose drivers/connections and prevent delayed callbacks into invalid nodes.
Visual completion must not be an accidental second gameplay command.

## Input, focus and clocks

Native Button activation should not be duplicated by a second input handler.
Keyboard, controller and mouse must reach consistent semantic states. Hover
does not equal selection. Touch input needs accepted-pointer ownership and a
policy for emulated mouse events; cancellation handles release outside/focus loss.

Opacity alone does not disable input. Closing content must lose interactive
ownership immediately; descendants and focus need consideration, not just the
parent's `mouse_filter`. Modals isolate background controls, focus a valid child
and restore an appropriate target on close. A visibility helper is not a modal
manager unless it implements that contract.

Setting a parent's `process_mode` to disabled does not remove descendant focus
eligibility, and an explicit ALWAYS descendant can still process. Test actual
navigation/activation into the outgoing subtree; do not merely assert an enum.
If an input gate snapshots a subtree, define how additions/config changes while
blocked are handled and how the current desired settings are restored.

Paused trees and global time scale are different checks. Make the UI owner
processable during pause when required. Verify Tween pause mode and, where
supported, `set_ignore_time_scale`. Do not alter the global clock to make a UI
preview slower. If animation and input use different process policies, test both.

## Accessibility and performance

Use the project's reduced-motion preference and respond to changes during motion.
Snap or fade while preserving readable focus/selection/state. Decorative motion,
haptics and audio are not the only way to communicate essential information.
Check text sizes, long translations and safe screen bounds on target devices.

Do not claim Tween or AnimationPlayer automatically moves updates off the main
thread. Inspect profiler evidence for CPU time, layout churn, resource loading,
draw calls, overdraw and material passes. Changing `size` is not inherently wrong
when it is the intended layout effect. A material instance should be local when
only one control is being animated.

## Concrete checks

1. Navigate A→B→C faster than feedback duration; C is actionable immediately.
2. Open→close→reopen before completion; no old exit wins.
3. Resize or change text/item count during motion; layout and input remain valid.
4. Pause, adjust game speed and exercise the intended UI clock policy.
5. Change reduced motion while moving; settle correctly and retain state cues.
6. Dispose the owner during a transition; no errors or later effects.
7. Inspect real frames at normal and locally slowed speed; headless tests alone
   do not establish feel or performance on the target device.

References: [Tween](https://docs.godotengine.org/en/4.6/classes/class_tween.html),
[Control](https://docs.godotengine.org/en/4.6/classes/class_control.html),
[pausing](https://docs.godotengine.org/en/4.6/tutorials/scripting/pausing_games.html).
