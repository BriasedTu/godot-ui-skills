---
name: godot-pick-ui-component
description: Use when explicitly asked to choose a native Godot control, animation tool or UI add-on for an interface task.
---
# Choosing Godot UI Building Blocks

Explicit selection workflow. Identify the task and inspect existing scenes,
engine version, renderer, enabled plugins and dependencies. Respect a tool the
user explicitly chose; do not silently replace it with a favorite.

Prefer an existing project component, then a suitable built-in, then a small
local scene, then a maintained compatible add-on when it adds concrete value.
Recommend one default with its constraint. Install or wire it only when that is
part of the request. Do not require an external dependency for a simple fade.

| Task | Native default | Boundary to check |
| --- | --- | --- |
| Activate/toggle | Button / CheckButton / CheckBox | Native focus, input mapping, disabled state |
| Dropdown / contextual menu | OptionButton / MenuButton / PopupMenu | Window embedding, dismissal, theme, focus and target platform |
| Dialog | AcceptDialog / ConfirmationDialog or existing modal scene | Native window vs embedded presentation; modal focus/restore |
| Rich text / progressive reveal | RichTextLabel | Shaping, supported glyphs and reveal behavior |
| Progress / radial fill | ProgressBar / TextureProgressBar | Authoritative value versus interpolated visual |
| Structured lists | ItemList / Tree | Built-in behavior may limit per-row art/motion |
| Custom cards/grid | Container + reusable Control scenes | Direct-child layout ownership, high item count |
| Scrolling | ScrollContainer | Gesture conflicts, focused item visibility; not automatic virtualization |
| Native drag/drop | Control drag/drop virtual methods | Keyboard/controller alternative and coordinate space |
| Hover help | tooltip_text or custom tooltip | Focus/touch disclosure when hover is unavailable |
| Tab selection | TabContainer / TabBar | Immediate selected state and native focus |
| Reusable skin | Theme, StyleBox, NinePatchRect | Texture stretch margins, contrast and text sizing |
| Simple dynamic motion | Owned Tween | One writer, kill/replace, pause/time-scale policy |
| Authored animation | AnimationPlayer / AnimationLibrary | Track paths, reset and cancellation |
| Blended graph | AnimationTree | Driver ownership; no parallel manual player control |
| Soft masks / sheen | CanvasItem ShaderMaterial | Local material ownership and renderer cost |
| Particles | GPUParticles2D / CPUParticles2D | Target renderer/device and reduced-motion policy |
| Notifications | Existing service or small reusable Control host | Godot has no universal built-in toast service |
| 3D UI element | Node3D / SubViewport composition | Input forwarding, render cost and texture resolution |

For very large custom lists, measure before adding recycling. Native containers
do not automatically virtualize thousands of custom scene instances. For a true
velocity-preserving spring, use a tested stateful implementation; a Tween easing
enum is not that system.

If an add-on is justified, verify its official repository, current engine
compatibility, license, maintenance, export/platform support and actual needed
capability. Report what is verified versus inferred. Reuse an already adopted
library unless there is a task-specific reason to change it. A dependency choice
does not authorize a project-wide migration.

Output: choice, reason, integration location and one relevant limitation. For an
implementation request, continue with concrete integration and verification.
