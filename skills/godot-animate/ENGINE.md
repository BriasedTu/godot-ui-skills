# Native implementation decisions

## Engine and property ownership

Inspect the destination version. Examples here are tested on Godot 4.6.1;
version-sensitive APIs require verification before use on an older project.

| Need | Native implementation | Constraint |
| --- | --- | --- |
| Hover, focus, disabled, pressed | `BaseButton` signals and `Theme` states | Focus moves immediately; feedback is presentation |
| Dynamic panel or selection | `Node.create_tween()` | One writer per animated property; replace rather than reuse |
| Fixed choreography, audio cues | `AnimationPlayer` / `AnimationLibrary` | Track paths, initial state, RESET and cancellation must be explicit |
| State-dependent track blending | `AnimationTree` | Do not simultaneously drive its player manually |
| Direct drag | Native input with one active pointer | Track locally without easing behind the pointer |
| Momentum after release | Tested spring or inertial integrator | Preserve velocity and use elapsed seconds |
| Soft reveal | Local `ShaderMaterial` parameter | Duplicate shared material if only one instance should change |
| Rectangular reveal | Clipping wrapper (`clip_contents`) | Check minimum sizes; do not move the logical hit target |
| 3D card flip | `Node3D` scene or a deliberate perspective shader | `Control.rotation` is a 2D rotation, not a 3D axis |

`Tween.TRANS_SPRING`, `TRANS_BACK` and `TRANS_ELASTIC` describe time-based
interpolation, not a velocity-carrying physics spring. Changing a tween's target
requires a replacement tween. Do not invent stiffness/damping arguments on it.

For a `Container` child, separate roles:

```text
GridContainer
  SlotButton (native focus and stable hit region; minimum size defines layout)
    Visual (Control, mouse_filter = IGNORE)
      Background / Icon / Label (also non-intercepting decoration)
```

Container sorting sets direct-child position/size and can reset scale. Do not
fight it every frame. If neighbors must move, first compute the final layout,
then animate visual offsets toward zero in wrappers. Resizing invalidates
measurements. Avoid changing text scale for a sustained expanded state.

`modulate` affects descendants; `self_modulate` affects only the item's own
drawing. A transparent `Control` can still receive input. Hiding, focus removal,
interaction disabling and visual fading are separate responsibilities. Setting
only a parent's `mouse_filter` does not disable every descendant.

## Lifecycle

Keep authoritative requested state separate from visible interpolation. Bind a
tween to an owning node, keep its handle, and kill it on replacement/disposal.
Start at current properties instead of resetting to an entrance pose. Initialize
the hidden pose only on genuine first appearance. Guard deferred completions
with a generation ID and requested state. Do not await an interruptible tween
as the sole way to release a lock: cancellation needs an explicit outcome.

For an exit, disable outgoing actions immediately. Keep the visual alive through
the fade, then hide or free it only if that exit is still current. When an
overlay owns modal input, isolate underlying controls, select an initial focus,
handle cancel and restore a valid previous focus. The standalone panel example
animates visibility and snapshots/restores the existing content subtree's input
eligibility. Its host owns modal behavior. Build that subtree before parenting
the helper. While it is blocked, do not replace descendants or overwrite its
processing/focus/filter configuration; a dynamic host must extend the gate to
new controls and retain current desired configuration separately. Data-driven
Button availability remains a host concern, not an animation result.

Animation tracks need the same contract: specify whether interruption blends,
seeks, stops or retargets. Avoid queued open/close sequences for rapidly reversed
UI. `animation_finished` is not a general cancellation notification and looping
animations have no normal finished event. Reset only owned properties, never
unrelated game state. A clip's method track must not become an unguarded second
path for a transaction or reward.

## Clocks

Pause and time scale are distinct. A pause menu's owner can use
`PROCESS_MODE_ALWAYS`; bound tweens follow the owner's processing policy.
`TWEEN_PAUSE_PROCESS` lets a tween process through a paused tree, but does not
make disabled input handlers process. On compatible engine versions,
`set_ignore_time_scale(true)` gives a tween an unscaled clock. Do not set global
`Engine.time_scale` merely to preview an interface. For authored UI clips,
choose an appropriate process mode and explicit local playback policy; verify
how the project's version handles time scale instead of assuming parity.

## Performance and verification

Tween/AnimationPlayer property updates do not guarantee a separate execution
thread. Avoid allocations, synchronous resource loads and rebuilding scenes in
per-frame motion. Check CPU frame time, rendering cost, transparent overdraw,
shader complexity and number of active nodes in the Godot profiler. Fading
several full-screen layers can be expensive even without layout changes.

Run commands against an explicit project path, using its known Godot executable:

```text
godot --headless --path <project> --editor --import
godot --headless --path <project> --script res://verify.gd
godot --path <project>
```

The second command assumes that project contains a compatible test script;
otherwise use its existing test runner. Check logs for parse/script errors even
when the process exits zero. A dummy renderer cannot establish visual quality.
Inspect an actual viewport at native size, resized aspect ratios and the target
renderer. Use local duration multipliers or AnimationPlayer scrubbing to inspect
motion; then test at production speed. Record which checks were performed.

Official reference: [Tween](https://docs.godotengine.org/en/4.6/classes/class_tween.html),
[Control](https://docs.godotengine.org/en/4.6/classes/class_control.html),
[AnimationPlayer](https://docs.godotengine.org/en/4.6/classes/class_animationplayer.html),
[input propagation](https://docs.godotengine.org/en/4.6/tutorials/inputs/inputevent.html).
