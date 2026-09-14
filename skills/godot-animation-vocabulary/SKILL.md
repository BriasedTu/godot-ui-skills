---
name: godot-animation-vocabulary
description: Use when a user describes a Godot UI motion effect and wants its name or precise language for requesting it, rather than an implementation.
---
# Godot Animation Vocabulary

Name the visible effect, then explain it in one sentence. Match intent rather
than keywords. Give at most two close alternatives when ambiguous; distinguish
appearance from implementation. If no term fits, describe the combination and
mark any approximation. Respond in the user's language and keep the technical
term available for future prompts. Do not turn a naming request into a build.

Example: “卡牌依次亮起来” → **Stagger / 错峰动效**: several cards begin the same
feedback a short interval apart. This is timing, not necessarily a particle effect.

## Appearance and transitions

| Term | Meaning / native distinction |
| --- | --- |
| Fade | Changing opacity; `modulate` includes descendants, `self_modulate` does not |
| Slide | Position changes into or out of a region |
| Scale in | A smaller visual grows to its resting size |
| Pop in | A scale entrance with a small overshoot |
| Reveal | Content is uncovered by clipping or a material mask |
| Crossfade | Two visuals overlap while one fades out and the other in |
| Morph | A shape changes into another; not just overlapping images |
| Shared element transition | One recognizable object travels between contexts |
| Layout animation | Visual continuity between old and new layout positions |
| Direction-aware transition | Navigation direction determines motion direction |
| Scene transition | Presentation connecting game screens/scenes |
| Origin-aware motion | Scaling/rotation tied to an appropriate pivot or trigger |
| Pivot | The local point used for scale/rotation; `Control.pivot_offset` |
| 3D flip | Rotation through depth, requiring a 3D representation or perspective effect |
| Parallax | Layers move at different rates to suggest depth |

## Timing and physical behavior

| Term | Meaning |
| --- | --- |
| Keyframe | An authored property value at a time in an Animation track |
| Tween | Interpolation between values; also Godot's runtime interpolation object |
| Stagger | Small start-time offsets among related elements |
| Orchestration | Coordinating multiple tracks as one readable event |
| Anticipation | A preparation beat before the main movement |
| Follow-through | Secondary parts settle after the main movement |
| Squash and stretch | Deliberate deformation conveying energy or softness |
| Ease-out | Fast initial response that decelerates toward the target |
| Ease-in | Initial acceleration; useful for intentional wind-up, potentially slow for immediate feedback |
| Ease-in-out | Acceleration and deceleration during travel |
| Linear | Constant interpolation rate, useful for truthful progress |
| Overshoot | Passing a target briefly before settling |
| Spring | Stateful motion driven by displacement and velocity; not just a bouncy Tween curve |
| Damping | Dissipation that controls how a spring settles |
| Momentum | Continued movement due to velocity after release |
| Retargeting | Redirecting unfinished motion toward the latest state |
| Rubber-banding | Increasing resistance outside an allowed drag range |
| Hit stop | A brief impact pause; a gameplay/presentation decision, not a default for UI |

## Feedback and ambient effects

| Term | Meaning |
| --- | --- |
| Hover feedback | Response to a pointing cursor entering a target |
| Focus feedback | Visible indication of the control receiving keyboard/controller input |
| Press feedback | Immediate acknowledgement of a held or accepted activation |
| Hold to confirm | A deliberate hold interval before one accepted action |
| Shake / wiggle | Brief oscillation, often marking rejected input |
| Ripple | An expanding mark from a press location |
| Pulse | Repeated scale/opacity/intensity emphasis |
| Float | Gentle positional drift at rest |
| Loop / ping-pong | Repetition / alternating forward and backward motion |
| Shimmer | A moving sheen, often on a temporary loading surface |
| Typewriter | Progressive text reveal with language/shaping considerations |
| Number ticker | A displayed number moving toward a new value |
| Mask | Per-pixel visibility, including soft or shaped boundaries |
| Line draw | Progressive exposure of a path, for example with Line2D or a material |

## Implementation and quality language

- **Frame budget:** time available per frame on the target device; not just an FPS average.
- **Overdraw:** pixels shaded repeatedly by overlapping surfaces.
- **Layout churn:** repeatedly invalidating/recomputing Control layout.
- **Property ownership:** which tween, track or script is allowed to write a value.
- **Unscaled time:** presentation time independent of global game speed.
- **Cancellation:** ending an obsolete action without reporting it as successful.
- **Reduced motion:** fewer/gentler effects or immediate state changes, with feedback preserved.
- **Perceived responsiveness:** how quickly input appears acknowledged, separate from total duration.
