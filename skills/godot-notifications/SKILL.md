---
name: godot-notifications
description: Use when building or fixing Godot notification toasts, message stacks, loading-to-result messages or temporary UI alerts.
---
# Native Godot Notifications

Use the project's existing notification host first. Godot does not provide a
universal toast service; [CONTRACT.md](CONTRACT.md) is a proposed local component
contract, not an engine API. Adapt names to the project rather than inventing
calls to nonexistent built-ins.

## Workflow

1. Inspect UI root, navigation/modal layering, Theme, supported inputs, pause
   policy and existing message events.
2. Choose a stable host lifetime. A CanvasLayer can own screen-space messages;
   scene-specific messages can belong to their screen. Define disposal explicitly.
3. Give each logical message an ID. Create, update, dismiss and expire by ID;
   loading→success updates the same logical entry. Guard every timeout and exit
   completion against updates or replacement.
4. Build a native Control row with icon/text and optional real Buttons. Keep
   layout slots stable and animate a visual child. Reuse Theme/resources.
5. Handle burst limits, wrapping, input/focus, action deduplication, reduced
   motion and chosen clocks. Persistent/actionable messages need deliberate
   dismissal; a brief status should not steal focus.
6. Verify repeated updates, expiry races, scene disposal, modal layering,
   paused gameplay, localization, reduced motion and each supported input path.

Prototype entry at 0.18 s cubic-out and exit at 0.12 s; retarget from current
properties. Avoid queuing motion while many messages arrive. Visibility duration
is a reading/accessibility decision, separate from animation duration. Moving a
notification's slot within a Container must respect layout ownership.

## Troubleshooting

| Symptom | Trace before changing code |
| --- | --- |
| Missing message | Host lifetime, layer ordering, clipping, hidden ancestor and current ID |
| Duplicate message | Duplicate publishers/subscriptions or absent stable identity |
| Updated message disappears early | A timeout/exit from a previous revision still acts on the same ID |
| Clicks blocked | Full-screen/decorative Controls intercepting input; parent filter alone is insufficient |
| Action inaccessible | Missing focus path, timed dismissal while focused, modal conflict |
| Stops during pause | Owner process mode and animation/timer policy differ |
| Every row changes appearance | Shared mutable Theme/material resource was changed globally |
| Stack jumps on resize | Cached heights, direct-child transform ownership or long text not remeasured |

Deliver concrete code when asked to build/fix. For API questions, distinguish
existing project methods from a proposed interface. Report runtime evidence and
remaining device/visual checks.
