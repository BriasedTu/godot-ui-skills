# Godot adaptation plan

The requested deliverable is a general Godot skill collection in a new private
repository owned by BriasedTu. Preserve the upstream workflow; replace all
platform-specific implementation, examples, dependency choices and inspection
steps. Do not embed any individual game's architecture or art direction.

- [x] Clone upstream and record its revision and license.
- [x] Exercise the original workflow against native focus, layout and pause cases.
- [x] Port the twelve skill roles, including construction, review, auditing,
  vocabulary, variants, mobile input, component choice and notifications.
- [x] Bundle standalone native examples and run lifecycle regressions in Godot.
- [x] Independently exercise the new skills; correct observed gaps.
- [x] Validate isolated skill packaging, native-only guidance and source attribution.
- [ ] Publish the verified commit to BriasedTu/godot-ui-skills as a private repository.

The baseline rejected keyboard feedback before considering latency, prescribed
non-native animation tools, and could not specify container ownership, pause
processing or stale completion behavior. Acceptance checks must cover those
behaviors, not just renamed vocabulary. A rendered inspection is separate from
headless correctness; report the limits of each.

Implementation uses Godot 4 GDScript, scenes and native controls. The bundled
examples target Godot 4.6 and are verified with 4.6.1. Skills must inspect the
destination project's actual version rather than impose an engine upgrade.

Each skill is independently installable: supporting assets and references stay
inside its folder. Named handoffs to other skills are optional; missing siblings
do not prevent completing an authorized task with the included guidance.
