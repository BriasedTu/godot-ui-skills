# Native touch recipes

These are implementation contracts, not undocumented engine methods. Use the
project's existing gesture layer where available. Consult
[InputEventScreenTouch](https://docs.godotengine.org/en/4.6/classes/class_inputeventscreentouch.html),
[InputEventScreenDrag](https://docs.godotengine.org/en/4.6/classes/class_inputeventscreendrag.html)
and [Control](https://docs.godotengine.org/en/4.6/classes/class_control.html)
for the destination version.

## Press feedback

Use native Button signals; a visual child can scale 1→0.97→1 with an owned
Tween (0.08 s down, 0.12 s up, cubic-out as a starting point). Keep the logical
button stable. Touch emulation must not create a second acceptance path.
Disabled state and canceled touch return visuals without activating.

## Draggable sheet or swipe-dismiss row

State sequence: idle → pending pointer → dragging → settling → idle/closed.
Store accepted touch index, start position, last local position/time, current
visual position and recent velocity. Ignore additional fingers. A small movement
threshold can defer ownership until intent is clear; use project-scaled units.
Resolve the axis against an enclosing ScrollContainer rather than hijacking every
drag. When the sheet owns the gesture, consume its input through the chosen
Control/input route. Do not activate an underlying button on release.

Track the visual directly while dragging. On release, choose a destination from
distance or recent directionally valid velocity. Express thresholds relative to
panel extent and units/second; e.g. prototype a 35% distance threshold with a
separately tuned fling threshold. Stale velocity from an old drag is invalid.
At a boundary, compress extra visual displacement with increasing resistance.
This does not expand the valid action region.

Kill any settle Tween when the same sheet is grabbed again. Start at its current
position. If continuity of velocity matters, use a tested stateful integrator;
Godot's time-based Tween easings do not expose mass/damping/initial velocity.
Close/reopen needs a generation guard so old completion cannot free the sheet.
Cancel on focus loss, scene disposal, or invalidated gesture ownership. Provide
an explicit button/controller route for the same action.

## Collapsing header and lists

Observe ScrollContainer scroll position and map a clamped range to visual offset
and backing opacity. Keep title text readable and maintain a stable content
layout. Avoid connecting another handler per frame. Recycled entries retain
identity and should not replay entrance every time they reappear. Large groups
need a capped aggregate stagger, not a delay that grows with the whole list.

## Safe area and virtual keyboard

Read available display/window dimensions and safe-area information after
orientation changes. Convert screen-pixel rectangles to the actual viewport/UI
space. Re-layout the content or scroll the focused field into view when the
keyboard covers it. Query platform capability before relying on keyboard height.
Do not promise frame-synchronous keyboard choreography without a supported native
integration. Test with actual input methods and long content on the device.

## Tab indicator and screen transitions

Select content immediately, then move a separate indicator to the chosen tab's
measured rectangle (about 0.16 s cubic-out initially). Keep semantic focus current.
Screen transitions belong to the game's navigation host: cover native controls,
focus, cancellation and scene lifetime together. A swipe preview must not commit
navigation until the interaction state machine accepts it.

## Haptic threshold

Keep a last-committed detent/outcome ID. Vibrate once when the accepted ID changes,
if enabled and supported, paired with a visual or sound. Do not vibrate from an
unbounded per-frame condition. Reset that identity at the correct gesture/session
boundary; a canceled gesture must not report success.
