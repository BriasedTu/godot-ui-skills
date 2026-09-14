# Native prototype picker

The picker is neutral test equipment. Use native Controls in a separate overlay
or reserved panel, legible and visually distinct from the variant. It should
not compete with the design or depend on a theme package. Move it away from the
area under test, including safe-area bounds.

## Contract

- Display one full-size variant at a time, with its name, axis and needed context.
- Native Buttons or TabBar select variants. Switching is immediate; do not add
  a transition that contaminates the comparison.
- Replay resets only the selected prototype instance and its test data. Remove
  the outgoing instance from the tree immediately, then free it so old input and
  callbacks cannot act on the replacement. Never reset a live player session.
- Provide visible replay, reduced-motion and slow-playback controls when useful.
  A duration multiplier or local driver speed controls presentation; do not use
  `Engine.time_scale` to slow the whole game.
- Keyboard shortcuts 1–N select and R replays when not typing; ignore repeats,
  modifiers and events already consumed by the tested component. Native focus
  navigation remains available. Controller operation uses mapped UI actions and
  buttons rather than requiring keyboard shortcuts.
- Persist only the selected variant if useful, using an isolated ConfigFile.
  Do not store prototype settings in the player's save. Clamp invalid indices.
- On replay/switch, preserve sensible focus in the picker or move it to an
  explicit variant target. Do not keep a reference to a freed focused node.
- Every variant exposes the same test controls/behavior so comparisons are fair.

## Bundled lab

[main.gd](assets/prototype-lab/main.gd) is a standalone host with three native
panel entrance treatments, replay, reduced motion and local slow playback.
It uses an isolated `user://prototype_picker.cfg` within its own application
data directory. The same script builds the small demonstration scene; production
variants should use the destination project's scene-authoring conventions.

Launch [project.godot](assets/prototype-lab/project.godot) in Godot 4.6 or run:

```text
godot --path <prototype-lab>
godot --headless --path <prototype-lab> --script res://verify.gd
```

The lab is infrastructure/example content, not a promised art direction. Use its
ownership and comparison behavior; replace sample content with the actual brief.
