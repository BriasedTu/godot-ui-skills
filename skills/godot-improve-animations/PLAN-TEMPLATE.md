# Self-contained motion plan format

Populate these fields from the actual project. This is a format for an output
artifact, not a fictional ready-to-run plan. Do not leave placeholders in a
delivered plan.

1. **Title and status:** short imperative title, PLANNED/IN_PROGRESS/VERIFIED,
   source revision, relevant engine version, severity and affected files.
2. **Problem:** concrete player action, current behavior and expected behavior.
   Cite real `.gd`/`.tscn`/`.tres` locations and include a short current excerpt.
3. **Native target:** node hierarchy and property owner; exact durations in
   seconds, transition/ease enums or spring parameters with units; requested
   state, interruption, cancellation, hide/free and reduced-motion outcomes.
4. **Project conventions:** local resources/helpers/input actions to reuse,
   with one actual exemplar. State Container and focus ownership, material
   sharing, pause/time-scale behavior and any version-dependent API.
5. **Edits:** ordered, bounded changes with exact target paths, resulting code
   or scene edits, and integration points. Include setup dependencies; do not
   refer to “the approach discussed earlier.”
6. **Boundaries:** unrelated scenes/gameplay/save logic to leave alone, allowed
   dependencies, and what to do if the source has changed. Re-read and adapt
   routine line drift; report a semantic conflict instead of overwriting it.
7. **Verification:** actual engine/test commands and expected outputs; relevant
   rapid-input, disposal, layout and clock checks; a rendered interaction at
   normal and locally slowed speed. Identify target device checks separately.
8. **Completion evidence:** checks run, result paths and untested limits. A
   mechanical pass cannot substitute for an unperformed visual check.

If plans share a prerequisite, order them explicitly in the plan index. Group
findings only when they have the same owner and correction. During reconcile,
compare behavior and evidence as well as code before changing status.
