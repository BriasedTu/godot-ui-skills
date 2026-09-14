# Notification component contract

This is an adaptable design for a local service, not a Godot class definition.
Do not call these methods until they exist in the destination project.

## Suggested operations

| Operation | Meaning |
| --- | --- |
| show_message(id, data) | Create or replace the logical message; return identity/revision if needed |
| update_message(id, data) | Change the current entry without duplicating its row |
| dismiss_message(id) | Begin one guarded exit for the current entry |
| clear_owner(owner_id) | Dispose messages scoped to an outgoing view/session |
| action_requested(id, action_id) signal | Emit one accepted action to the owning command layer |

Data can contain title, description, semantic kind, icon, reading duration,
persistent flag and optional action label/ID. Prefer data/IDs to closures that
capture scene nodes with shorter lifetimes. Do not place transient scene objects
in persistent game data. Use an existing project representation if available.

## State and races

Each entry has a monotonically increasing revision. An update invalidates the
old timeout and exit completion. A callback checks ID, revision and lifecycle
state before changing anything. Dismissal during entry is allowed and begins
from the current visual pose. Update during exit either explicitly revives the
entry or creates a new revision according to the chosen contract; test that path.
The same ID must never have two authoritative active rows.

A long-running task updates loading→success/error only if its owner and message
revision still match. Cancellation is not success. Interactive actions lock or
deduplicate once accepted, with the command layer performing the actual action.
The notification's fade completion must not perform it again.

## Presentation and lifetime

Define a visible cap and bounded queue policy; merge repetitive messages where
meaning is preserved. Keep the host's screen-space layer explicit relative to
menus/modals. Root decoration ignores pointer input; real action Buttons remain
reachable. A toast normally does not steal focus. For an actionable stack,
provide a discoverable focus route and avoid auto-expiring the focused entry.

Use a stable Container slot and visual child for entry/exit. On exit, remove
interactive ownership immediately, but free the visual only after a still-valid
completion. Recalculate layout after text/viewport changes. Reduced motion can
snap/fade while retaining the message and reading time.

Choose whether reading timers and motion run during pause and global slow motion.
Do not silently use different clocks for update timeout and UI presentation.
Dispose owner-scoped messages and invalidate their callbacks on navigation.

## Acceptance cases

Create→update→expire-old; create→dismiss→update; ten messages in a burst; long
translated text; action accepted twice quickly; focus held across the default
timeout; pause while showing; owner removed mid-task; reduced motion toggled
mid-entry; modal opens above/below the notification layer. Verify each expected
outcome with the destination project's runner and a real viewport.
