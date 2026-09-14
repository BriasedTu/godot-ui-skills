# Verification record

The native examples target Godot 4.6 and were exercised on **Godot 4.6.1 stable
official** on Windows. Python checks use only the standard library.

## Reproduce

```text
python tools/validate_skills.py
python tools/verify.py --godot <executable>
python tools/verify.py --godot <executable> --capture
```

The combined runner imports both standalone projects, runs their behavioral
suites, loads both real entry scenes, and inspects process status and engine
error output. `--capture` additionally uses a real display/renderer to capture
moving and settled viewport frames. Logs/images are local ignored artifacts.

## Coverage

| Check | Scope |
| --- | --- |
| Skill package validation | Twelve expected entries; matching names/descriptions; native-only instructional content; all linked resources bundled inside each skill |
| Motion Lab | 69 assertions covering visibility, cancellation, reopen, disposal, reduced motion, paused/zero-time-scale playback, native focus and activation, outgoing subtree input, Container resize and stable hit geometry |
| Prototype Lab | 24 assertions covering selection, one live variant, replay disposal, sample action, reduced motion, clamped indices and local playback clock |
| Entry scenes | Actual main scenes load without script/parse errors |
| Render capture | Windows Compatibility renderer; opening and settled motion frames, smaller viewport capture, three prototype treatments |

The initial tests were run before their example implementations: each failed
because the required native scene/scripts were absent. After implementation,
the two suites passed. Original-skill baseline evaluation also demonstrated that
the old gate rejected the requested keyboard navigation and prescribed non-native
tools; that behavior was deliberately replaced.

Independent skill forward-testing checked inventory/pause construction, scoped
audit-and-plan, prototype selection/promotion and mobile notification requests.
It found the original sample's parent-only process gate could still admit focus
and an explicitly always-processing child. A native-input regression reproduced
the defect before the subtree gate was corrected; the updated suite passes.

## Limits

- Headless assertions prove the enumerated behaviors, not subjective animation
  quality. Captured temporal samples support visual inspection; they do not
  establish physical controller, touch, haptic, screen-reader or device performance.
- Mobile instructions are version-aware guidance; no Android/iOS export or
  hardware test is claimed. No shipping game was modified or used as a fixture.
- The Motion Lab panel is a visibility primitive. Its host must implement modal
  input isolation and focus restoration when a real modal is required.
  Its gate snapshots the existing subtree; dynamic membership or input-policy
  changes while blocked need an extended host-owned gate.
- Notification and advanced gesture recipes are design contracts, not a complete
  notification add-on or a shipped velocity-preserving spring library.
- The prototype sample uses GDScript scene construction for isolation; a real
  project may use editor-authored PackedScenes and its own Theme/components.
- Single-folder skills contain their references and assets; optional named
  handoffs do not require all twelve skills to be installed.
