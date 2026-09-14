---
name: godot-write-gdscript
description: Use when writing or refactoring GDScript for Godot UI components, animation helpers, resources, input handlers or scene lifecycle code.
---
# GDScript for Interface Engineering

Write native code that fits the destination project's version, language and
architecture. This skill's examples use Godot 4 GDScript; do not rewrite an
existing C# project wholesale just to follow them.

## Workflow

1. Inspect the engine version, relevant scene, scripts, instructions and tests.
   Read the actual declarations of project helpers before using them.
2. Identify ownership and observable behavior: scene nodes, data resources,
   commands, signal connections, animated properties and cancellation.
3. Implement the smallest coherent change with explicit data and lifecycle
   boundaries. Reuse existing test/framework conventions.
4. Parse/import with that engine and run focused behavior checks. Inspect errors
   in logs even if exit status is zero. For UI, inspect an actual render too.

## Language and resource choices

| Need | Use / consequence |
| --- | --- |
| Inspector-authored data | `Resource` with typed `@export` fields |
| Scene behavior | `Node`/`Control` script attached to the relevant owner |
| Short-lived non-scene state | `RefCounted` or a small existing data structure |
| Node references | Typed `@export` or `@onready` bindings consistent with the scene |
| Events | Typed signals and direct Callable connections; disconnect long-lived publishers when ownership ends |
| Variant-returning API | Explicit type/check where inference would lose safety |
| Optional/freed object | Null and `is_instance_valid` checks at lifecycle boundaries |
| Shared material or Resource | Deliberate sharing; duplicate/localize when changing one instance |

GDScript uses `func`, typed `var`, `:=` inference, `await` and indentation.
Keep code in the project's style. `Resource`, `RefCounted` and `Node` are
reference objects; do not assume assignment clones them. Typed arrays and
version-sensitive collection syntax need the project's actual parser.

## State, signals and asynchronous work

Update requested state in the command/input path. Presentation can interpolate
toward it but must not accidentally become a duplicate state mutation. A single
Button signal should not coexist with another handler accepting the same event.

For replaceable work, increment a generation token and check it after any await
or deferred completion. A destroyed view cannot own a future action. Do not await
`Tween.finished` as the only unlock path if that Tween can be killed. Define a
cancel result or use guarded callbacks with an independently maintained state.
Timers and external signal subscriptions need the same ownership analysis.

Stay on the main thread for scene tree/UI mutation. `await` yields; it does not
move work to a worker thread. Use background work only when profiling and an
appropriate thread-safe API justify it, then hand results back safely. Do not
introduce global singletons simply to avoid passing a local dependency.

## Animation-specific rules

Create a Tween through `Node.create_tween()` or a bound SceneTree tween, never
`Tween.new()` for playback. Kill and replace it when its target changes. Reuse
nodes, not finished Tween objects. Coordinate AnimationPlayer/AnimationTree and
scripts so there is one intentional owner per property.

Containers own direct-child geometry. Native controls own hit/focus behavior;
decorative descendants should ignore input. Choose processing policy separately
for gameplay pause and time scale. Verify version-specific APIs such as
`Tween.set_ignore_time_scale` rather than assuming an older engine supports them.

## Verification and reporting

Use focused behavioral tests for lifecycle/input contracts, not assertions that
mirror private implementation. Good cases include cancellation, repeated
activation, pause, resize, removed nodes and changed preferences. Fixtures use
isolated test data paths and must not overwrite player saves. Do not install a
new testing framework when the repository has a working runner.

Report changed behavior, relevant test evidence and limits. Consult official
[GDScript basics](https://docs.godotengine.org/en/4.6/tutorials/scripting/gdscript/gdscript_basics.html)
and [thread-safe APIs](https://docs.godotengine.org/en/4.6/tutorials/performance/thread_safe_apis.html)
for unfamiliar/version-sensitive details.
