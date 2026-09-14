---
name: godot-design-engineering
description: Use when polishing Godot interfaces, reviewing control design, or deciding how typography, layout, input feedback and motion should work together.
---
# Godot Design Engineering

Build interfaces whose small decisions reinforce each other. Study the actual
game's visual language and interaction needs; do not substitute a universal
skin. This skill covers overall craft. For a focused task, optional companions
are `godot-animate`, `godot-review-animations`, `godot-prototype`, and
`godot-pick-ui-component`. Their absence is not a blocker.

## Workflow

1. Read the project's instructions, current scene and existing Theme/resources.
   Identify player goal, information priority, supported inputs and engine
   version. Inspect a real viewport before drawing conclusions about layout.
2. State what must be understood first and which interaction currently feels
   unclear, slow or inconsistent. Preserve approved visual choices.
3. Choose the smallest change that makes state or intent legible. A static
   focus mark can solve more than another flourish.
4. Implement with native Controls, containers, Theme overrides/resources and
   owned presentation code. Reuse the project's component system.
5. Check the rendered result across states, input methods and representative
   window sizes. Report exact changes and remaining visual uncertainty.

## Motion decisions

Name a purpose before choosing a curve: feedback, spatial continuity, state
readability, instruction, reward or atmosphere. Frequent actions deserve fast
response, not a blanket ban on motion. Keyboard/controller focus changes now;
its visual can follow briefly without delaying activation. Decorative movement
must not obscure values or make a target difficult to acquire.

Use existing timing tokens. Otherwise prototype press/focus at 0.08–0.14 s,
small surfaces at 0.16–0.24 s, scene transitions at 0.20–0.35 s. Cubic-out gives
prompt response; sine-in-out suits travel. Authored anticipation or reward
staging may need different timing. Judge the result, not adherence to one curve.
Small scale/fade entrances, or fades alone, are valid. Visible bounce belongs
only where it supports the intended personality.

## Native component craft

- **Buttons:** preserve native activation and focus; provide normal, focused,
  pressed and disabled states. Animate a visual child rather than its hit region.
  Decorative descendants should not intercept the parent's input.
- **Menus and tooltips:** connect origin to trigger, clamp to usable bounds,
  support focused controls, avoid focus stealing and stale hover-delay callbacks.
- **Panels:** preserve identity during open/close, reflow long text, and use one
  owner per animated property. Container-managed direct children need stable
  layout slots, with visual animation below them.
- **Typography:** readable size/contrast, complete glyph coverage, language-aware
  wrapping and shaping, predictable numeric alignment. Inspect long translations
  and text-size settings; do not flatten editable text into textures.
- **Materials:** choose Theme/StyleBoxTexture/NinePatchRect or dedicated art to
  suit the project. Use stretch-safe regions; keep texture borders and icons from
  deforming. Transparency does not automatically create hierarchy or readability.
- **Input:** distinguish hover, focus, selection and activation. Honor InputMap,
  focus order and controller navigation. Touch gets explicit discovery paths.
- **State:** visual confirmation cannot be an additional gameplay command. Keep
  loading, failed and unavailable states readable, with a reason when useful.

## Continuity and cost

Retarget rapid transitions from current values, invalidate stale callbacks, and
disable closed-view actions. Choose UI pause/time-scale policy explicitly.
`AnimationPlayer` tracks and Tweens must not fight over the same property.
Reduced motion can snap or fade while retaining static state differences; apply
preference changes while a transition is running.

Use the Godot profiler rather than assuming a property is cheap: repeated
Container layout, transparent overdraw, material passes and resource loading
have different costs. Do not add a global framework for one local interaction.

## Review format

Use a concise table: **Location | Before | After | Why**. Link actual files and
distinguish observed problems from hypotheses needing a rendered check. Verify
normal, rapid/reversed, disabled, reduced-motion and resized states. State
whether the engine ran and whether the motion was visually inspected.
