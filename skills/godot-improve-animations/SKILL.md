---
name: godot-improve-animations
description: Use when auditing motion across a Godot project, prioritizing animation improvements, writing implementation plans, executing an approved motion plan or reconciling its status.
---
# Improving Godot Motion

Preserve the advisor workflow: recon → audit → vet → prioritize → self-contained
plans → execution → review. Select the requested mode before touching files.
Read [AUDIT.md](AUDIT.md) for categories and
[PLAN-TEMPLATE.md](PLAN-TEMPLATE.md) when writing a plan.

## Modes and scope

| Request | Behavior |
| --- | --- |
| Audit / bare / quick / deep | Inspect and report; do not modify game source |
| Plan a described improvement | Inspect enough context, then write its plan |
| Audit and plan | Produce plans for the requested scope; otherwise propose the highest-value few |
| Execute a selected plan | Implementation is authorized; apply, test and review that scope |
| Reconcile | Compare plans to actual code/evidence; update statuses and stale references |

Plan artifacts go in an existing designated folder or `animation-plans/`.
Read-only modes do not install tools, run import/build mutations, commit changes
or change project configuration. Existing artifacts can provide evidence.
Execution mode follows the project's normal permissions and test workflow.

## Workflow

1. **Recon:** version, renderer, target devices, native scene/control structure,
   motion owners, Theme/timing resources, focus/InputMap and settings. Record
   actual interaction frequency and expected style.
2. **Audit:** examine the eight categories below. `quick` covers critical
   player paths; normal covers interactive UI; `deep` includes authored overlays,
   mobile and rare sequences. No fixed finding quota. When delegation is
   available and authorized, bounded read-only audits can cover disjoint areas;
   otherwise perform the same audit serially. Include scope, context and exact
   reference path in any delegated task.
3. **Vet:** re-read every cited location and validate the consequence. Respect
   documented tradeoffs. Separate confirmed failures, performance hypotheses and
   optional polish. Collapse duplicates and identify dependencies.
4. **Prioritize:** show **Severity | Category | Location | Evidence | Fix**.
   HIGH means input/correctness or major visible failure; MEDIUM means noticeable
   usability or continuity loss; LOW means polish. Frequency/input device alone
   is never a severity. Include genuine missed opportunities separately.
5. **Plan:** when requested, write selected plans with current revision and
   self-contained instructions. If the user has not requested planning, deliver
   the audit first. Do not make extra approval rounds for already selected work.
6. **Execute:** only in an implementation request. Check drift, apply the plan,
   run appropriate engine tests and inspect actual motion. Review with the
   included audit bar or `godot-review-animations` if installed. Record results;
   do not call unobserved visual checks complete.

Plans must carry exact files, native API choices, target values/units, scene
hierarchy, cancellation/input/clock contracts, test commands and visual checks.
Maintain a small plan index with order, dependencies and status. Never mark a
plan DONE merely because its target code appears in a search result.
