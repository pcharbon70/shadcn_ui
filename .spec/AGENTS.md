# `.spec` agent guide

<!-- covers: spec.workspace.agents_present spec.workspace.agent_prime_context -->

Use this folder for ShadcnUI architecture, current-truth specifications,
accepted decisions, milestone definitions, implementation plans, and generated
SpecLed state.

## First read

1. Read `.spec/README.md`.
2. Read `.spec/decisions/README.md` and every applicable accepted decision.
3. Read every current `.spec/specs/*.spec.md` subject before editing it.
4. Read the applicable `.spec/milestones/*.md` roadmap before creating a phased
   implementation plan.

## Working rules

- Keep one current-truth subject per specification file.
- Keep durable cross-cutting choices in `.spec/decisions`.
- Keep milestone definitions in `.spec/milestones`; they describe ordered
  outcomes and boundaries, not implementation completion.
- Keep phase, section, task, and subtask checklists in `.spec/planning`.
- Do not mark a milestone complete merely because its planning document exists.
- Run `mix spec.prime --base HEAD` when starting SpecLed work.
- Run `mix spec.next` after changes and `mix spec.check --base HEAD` before
  finishing implementation or specification work.
