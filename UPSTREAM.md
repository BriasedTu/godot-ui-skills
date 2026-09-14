# Upstream provenance and adaptation map

- Source: https://github.com/emilkowalski/skills
- Baseline: `d23d7f88a2e21c9e4b1418c7abe420f5c1052ba7`
- Adaptation date: 2026-09-14
- License: MIT, original copyright notice retained unchanged.
- Upstream history remains available; the current skill tree contains only the
  Godot adaptation. No compatibility aliases load the old platform instructions.

| Original role | Godot role | Workflow preserved |
| --- | --- | --- |
| emil-design-eng | godot-design-engineering | Purposeful polish and coherent component decisions |
| animate | godot-animate | Gate → tool → properties → timing → interruption → accessibility → validation |
| animate-expo | godot-animate-mobile | Touch-first construction, gesture ownership, device checks |
| review-animations | godot-review-animations | Evidence-based findings table and explicit verdict |
| improve-animations | godot-improve-animations | Recon → audit → vet → plans → execute → reconcile |
| find-animation-opportunities | godot-find-animation-opportunities | Search seams, gate opportunities, show real rejections |
| animation-vocabulary | godot-animation-vocabulary | Reverse lookup and disambiguation of visible motion |
| apple-design | godot-fluid-interface-design | Direct manipulation, interruption, momentum and spatial continuity |
| write-swift | godot-write-gdscript | Language, data ownership, asynchronous lifetime, performance and testing |
| pick-ui-library | godot-pick-ui-component | Task-first selection, reuse existing tools, avoid dependency churn |
| prototype | godot-prototype | Distinct directions → interactive picker → choice → promotion |
| ask-sonner | godot-notifications | Notification setup, message updates, lifecycle and troubleshooting |

This is a native rewrite of the technical layer. CSS/HTML, React/Motion, Expo,
Swift and Sonner instructions and assets are absent from the installed skills.
Their tasks are fulfilled through native Godot controls, GDScript, animation
resources, input APIs and the editor/runtime. Notification method names are
explicitly proposed project contracts, not nonexistent engine APIs.

The judgment layer is adapted too: frequent keyboard/controller feedback is
allowed; exact timing tables become starting points; review does not prohibit
fade-only entrances or every layout animation. Engine-specific ownership,
pausing/time scale, cancellation, input and native verification replace the old
platform assumptions. The user's project conventions and authorization scope
remain authoritative. No individual game's contracts are bundled.

Each skill includes a license copy so a single-folder installation preserves
the upstream notice. The root README documents installation and current testing;
it is not required at invocation time.
