---
name: godot-prototype
description: Use when explicitly asked to compare multiple Godot UI or motion variants in a native interactive prototype picker.
---
# Prototyping Godot Variants

Preserve divergence → live comparison → user selection → promotion. This is an
explicit exploration tool. Read [PICKER.md](PICKER.md) before building the host.

## Workflow

1. **Scope:** identify the component, context and behavior being compared. For a
   broad request, work through coherent groups rather than silently discard scope.
2. **Recon:** inspect engine version, existing scene/control patterns, Theme,
   input actions, motion settings and target viewport. No project means a small
   standalone Godot project with native Controls.
3. **Directions:** default to three genuinely distinct approaches, up to five
   when useful/requested. Name the axis (density, hierarchy, motion character,
   interaction). Three recolors are not meaningful alternatives. Respect the
   player's settled gameplay/input contracts.
4. **Build:** one PackedScene per variant or equivalent isolated native scene
   factory, shown at full size in realistic context. Use actual working inputs
   and plausible sample content. Keep prototype state separate from player data.
   Work in an isolated prototype scene/project; production integration follows
   selection. A runnable host is bundled in
   [prototype-lab](assets/prototype-lab/project.godot).
5. **Verify:** run every variant, its repeated/interruptible interactions and
   replay. Check output logs, resizing, focus, reduced motion and relevant input
   devices. Inspect real rendered frames; do not claim that screenshots or a
   headless pass establish animation feel.
6. **Present:** table of variant, named axis, benefit and cost, plus the scene
   path and picker controls. The user chooses unless they already delegated
   selection. An exploration request is complete at this choice point.
7. **Promote:** integrate the selected variant using project conventions and
   retest the real context. Remove only the task-owned prototype when it is no
   longer wanted; preserve a requested comparison lab.

All variants meet the same correctness bar: immediate semantic input, native
focus, one property owner, cancellation, Container-safe visuals and reduced
motion. Timing/curve changes are legitimate comparison axes, not automatic
violations. A variant's quality cannot excuse broken actions.

`riff <name>` explores new directions around that choice. `keep <name>` integrates
it. `keep <name>, leave the picker` preserves the comparison. If a sibling motion
skill is unavailable, use the constraints here and the project's native workflow.
