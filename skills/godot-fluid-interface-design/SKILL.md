---
name: godot-fluid-interface-design
description: Use when designing fluid Godot UI behavior, direct manipulation, gesture continuity, spring settling, spatial transitions or coordinated sensory feedback.
---
# Fluid Godot Interfaces

Design behavior first: the interface should track intent continuously through
press, drag, release, interruption and rest. Adapt to the game's personality
and player needs, not a prescribed operating-system appearance.

## Process

1. Identify the object's states, constraints, input sources and intended result.
2. Diagram ownership of position, velocity, focus and activation across each
   phase. One owner writes each property at a time.
3. Prototype direct tracking first; add release behavior and boundary response.
4. Test interruptions and changed geometry, then tune sensory feedback.
5. Measure and observe on the target device; separate findings from assumptions.

## Principles translated to Godot

| Principle | Implementation consequence |
| --- | --- |
| Immediate response | Accept mapped input and update semantic state before decorative settling |
| Direct manipulation | Update the owned visual from accepted pointer displacement; avoid easing that lags behind the pointer |
| Interruption | Reclaim control immediately, cancel the previous driver and retain current presentation |
| Velocity handoff | Record recent local-units/second velocity and initialize the release integrator from it |
| Projected intent | Select a bounded destination using direction, distance and recent velocity |
| Spatial continuity | Convert between coordinate spaces explicitly; preserve object identity during transitions |
| Soft boundaries | Apply increasing resistance to visual over-drag; leave authoritative bounds unchanged |
| Multimodal feedback | Optional local sound/haptics reinforce a state transition once, never every frame |

## Springs and time

A time-based `Tween` transition does not preserve physical velocity. Even
`TRANS_SPRING` is an interpolation curve, not an object with mass and damping.
For inertial settling use an existing tested spring implementation or integrate
a stateful spring with explicit position, velocity, target, damping and time.
Define units, timestep bounds and an error/velocity sleep threshold. Test at
30/60/120 fps and after a long frame. A critically damped spring suits quiet
settling; underdamping is an intentional style choice.

Do not smooth direct drag and then call its lag “weight.” Add weight through
release momentum, constrained displacement and sensory cues if appropriate.
Long authored beats can use AnimationPlayer; dynamic targets usually suit
Tweens or integrators. Pick the UI's pause and time-scale behavior deliberately.

## Native constraints

Use Controls for input and layout, with an unconstrained visual wrapper for
animated offsets. Containers own their direct-child geometry. Pointer positions
from different APIs may use viewport or local coordinates; convert once at the
input boundary. Capture the accepted touch index and ignore unrelated touches.
Cancel on loss of focus or disposal, and resolve nested scrolling before the
gesture starts committing actions.

Keep focused content visible; do not hide the active target behind a moving
panel. Every drag-only action needs a suitable non-drag path for the supported
input devices. For an overlay, preserve modal focus and restoration independently
of presentation. Reduced motion removes travel/oscillation or snaps to state;
it does not remove the visible distinction between selected and unselected.

## Materials, text and verification

Depth, translucency and typography should explain grouping and priority. Check
legibility over actual scenes and at the player's text/UI scale. Avoid repeated
full-screen blur or unbounded particles as defaults. Use the Godot profiler to
measure shader/overdraw and scene-processing cost rather than infer performance
from the animation API.

Observe a real viewport at normal speed and inspect local slow playback. Test
drag reversal, flings near boundaries, cancel, resized panels, changed reduced
motion, pause and scene replacement. Report behavioral evidence separately from
subjective tuning. If only code was inspected, say so.
