---
name: godot-review-animations
description: Use when reviewing an existing Godot UI animation, scene or change for responsiveness, lifecycle correctness, input behavior, accessibility and visual quality.
---
# Reviewing Godot Motion

Review existing work; do not silently redesign the whole interface or implement
fixes in a review-only request. Read [STANDARDS.md](STANDARDS.md). Match the
project's version and established choices before judging.

## Workflow

1. Identify scope and intended behavior. Read the affected scenes, scripts,
   animation resources, settings and input bindings.
2. Trace input → requested state → visual driver → completion/disposal. Check
   Container and property ownership, focus, pause and cancellation explicitly.
3. Assess motion purpose and perceptual response. Frequent keyboard/controller
   navigation is allowed; waiting for decoration before accepting it is a defect.
4. Reproduce suspected failures using available tests/runtime. A source pattern
   alone does not prove jank or a focus failure. Do not run mutations outside the
   authorized review scope just to collect evidence.
5. Re-read cited locations, remove duplicates and label unverified hypotheses.
   Recommend the smallest correction with exact native properties/timing where
   useful. Values are proposals unless the project already defines them.

## Findings and verdict

Use one table: **Severity | Location | Before | After | Why / evidence**.
Prioritize correctness/input regressions, visible discontinuity, demonstrated
performance problems, accessibility, then polish. Do not pad a clean review.

- **Block:** confirmed stale completion, duplicate action, lost/blocked input,
  invalid object access, broken pause behavior or a material visual regression.
- **Needs runtime check:** an important visual or timing claim is not established.
- **Approve:** no material issue found within the inspected scope. State what
  ran and what did not; approval is not a claim that every device was tested.

Do not block solely for a fade-only entrance, a built-in easing function,
AnimationPlayer use, layout animation or a duration outside a suggested range.
Judge their actual purpose and implementation. A fixed-duration elastic curve
is not evidence of a velocity-preserving spring.

For an authorized fix, implement the scoped correction using the project's
workflow; optionally use `godot-animate` if installed. For a broad roadmap,
`godot-improve-animations` provides audit and plan modes. Neither handoff is a
requirement to stop already authorized work.
