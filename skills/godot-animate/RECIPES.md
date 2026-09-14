# Godot motion recipes

Use existing project values first. Numbers below are measured-in-seconds starting
points; validate them in the actual scene. Each recipe includes semantics beyond
the animation itself. Read [ENGINE.md](ENGINE.md) for shared ownership rules.

## Button press, hover and focus

Use `Button`/`BaseButton` for activation, focus and disabled states. A visual
child can shrink to 0.97 on press (0.08 s) and return to 1.0 (0.12 s,
`TRANS_CUBIC`/`EASE_OUT`). Do not shrink the button's hit region. Use a static
focus outline or icon in addition to motion, also for controllers. Track hover,
focus and pressed state together so a mouse exit cannot erase keyboard focus.
Reduced motion keeps the outline/color and uses scale 1.0.

Runnable pattern: [motion_button.gd](assets/motion-lab/motion_button.gd).

## Panel, menu and tooltip

Try opacity 0→1 with scale 0.97→1 over 0.20 s, cubic-out. Center a modal's pivot;
place a contextual menu's pivot near its trigger in the menu's local coordinates.
Clamp the panel inside the usable viewport. A fade without scale is also valid.

Reopening during exit kills the old tween and continues from current values;
an old callback must not hide the new opening. Closing disables actions before
the fade. Focus handling, modal isolation and viewport resizing belong to the
host. Test these separately from the visibility helper.

Tooltips should not steal focus. After an initial intentional hover delay,
neighboring items can reveal promptly; invalidate the previous delay whenever
the target changes. Support focus-triggered information on controller/keyboard,
and explicit touch disclosure when the platform has no hover.

Runnable visibility primitive: [motion_panel.gd](assets/motion-lab/motion_panel.gd).

## Drawer and screen transition

Use an unconstrained visual wrapper or overlay layer. Derive closed position
from measured panel/viewport size in local units; use a 0.20–0.30 s cubic-out
settle. Choose a direction consistent with navigation history. Back/forward and
reopen actions replace current presentation instead of queuing stale routes.
Keep input and focus ownership explicit during overlap. A reduced-motion variant
can switch instantly or briefly fade. Do not reload a scene merely to replay
decoration. Longer chapter/reward transitions use their own skip contract.

## Notification stack

Give messages stable IDs and update existing entries rather than duplicating
them. Create a stable layout slot with a visual child; fade/slide the visual
0.18 s on entry and 0.12 s on exit. Cap visible entries and merge bursts when
appropriate. A closing entry must stay alive only for its exit, and its timeout
must not dismiss a newer update. Noninteractive decoration ignores pointer
input; action buttons remain focusable. Use the optional `godot-notifications`
skill for the full lifecycle design, or implement that contract locally.

## Accordion and expanding detail

Let text reflow at the target width. Animate a measured clipping wrapper or a
controlled minimum-height contribution over about 0.20 s, and observe the parent
Container's response. It is legitimate to animate layout when layout is the
effect; profile the result. Never let the parent's minimum size prevent collapse
without noticing. Recompute target height on localization or width changes.
Collapsed descendants must not remain focusable. Reduced motion sets final
layout immediately.

## Group entrance and list movement

For occasional entrances, 0.03–0.06 s stagger can show grouping. Cap aggregate
delay (for example 0.18 s), not just per-item delay. Reveal controls immediately
when focused/activated; no input waits for a flourish. Recycled rows should not
replay entry on every reuse. Stable IDs bind visual continuity across reorders.
Use final layout plus animated visual offsets; cancel/rebase on resize.

## Hold to confirm

Do not introduce a hold requirement without an interaction brief. If requested,
use a `ProgressBar` or local shader parameter driven by a single accepted hold.
For example, fill over 0.8 s linearly, cancel on release/focus loss/disabled state,
and reset over 0.10 s. Map mouse, keyboard and controller to the same state
machine. Consume each accepted commit once; animation completion is not a second
command. Show textual progress/confirmation and an accessible alternative when
the interaction requires one. Reduced motion does not remove required feedback.

## Tab indicator and shared element

Select the new tab immediately. Animate a separate indicator toward the chosen
tab's measured local rectangle (0.16 s cubic-out), retargeting on each new input.
Only animate the rectangle's size if the visual requires it; do not move native
focus to match a delayed indicator. For a thumbnail-to-detail transition, create
one presentation proxy in a stable overlay, convert coordinates explicitly,
and hand visibility to the real destination once. Cancel safely on navigation.

## Scroll reveal and drag dismissal

Use `ScrollContainer` for ordinary scrolling. Avoid replaying entrances while a
user scans a list. For drag gestures, track a single accepted pointer without
lag, resolve gesture-vs-scroll ownership, and cancel on focus loss. Measure
recent velocity in local units/second. Dismiss on a deliberate distance or a
directionally valid fling, not an unlabelled magic number. Snap back with an
owned tween when velocity continuity is unnecessary; otherwise use a tested
spring with explicit state. The optional `godot-animate-mobile` skill covers
touch ownership and device checks.

## Mask, crossfade, counter and typewriter

- Clip rectangular reveals with a wrapper or use a local material for soft masks.
  Material sharing must not animate every instance unintentionally.
- A crossfade can double-expose text. Prefer switching text once while fading
  its backing, or moving between readable states. Blur is not a required cure.
- Count toward the latest authoritative number and retarget mid-count. Keep
  comparisons, accessibility text and actions tied to the real value, not the
  interpolated label; use stable digit widths where needed.
- Use `RichTextLabel.visible_characters`/`visible_ratio` for typewriter reveals
  after checking shaping behavior for the languages supported. First accept can
  finish text and the next advance, if that is the game's chosen contract.
  Skipping must not fire every intermediate sound/event at once.
