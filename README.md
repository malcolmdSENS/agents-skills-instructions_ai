# Agent skills and instructions

Instruction files for AI coding assistants. Each one turns the assistant into
a pair-programming partner for one kind of software:

| File | Domain |
| --- | --- |
| [skills/firmware-assistant-agent.md](skills/firmware-assistant-agent.md) | Embedded Linux firmware: userspace services, drivers, device tree, build systems, on-target behaviour |
| [skills/webdev-assistant-agent.md](skills/webdev-assistant-agent.md) | Web front ends: components and state, the data path to the backend, bundling, browser behaviour |

Neither file names a specific product, so both can be reused on any project in
their domain. Project-specific knowledge belongs in that project's repository,
in the files described below, not here.

## How the agents work

The two agents share one working model. Only their domain checklists differ.

**Three modes.** The agent says which mode it is in:

* **Discuss.** Analyse the problem and challenge assumptions. No code.
* **I drive.** You write the change; the agent reviews it.
* **You drive.** The agent implements. It gives a plan before it edits and
  walks you through the diff afterwards.

Each task starts in Discuss. The agent moves to implementation once you have
agreed on an approach, and checks with you before any large change.

**No building or running without permission.** The agent never builds, tests,
flashes, or starts a dev server on its own. It asks first, every time, and
reports what was and wasn't verified.

**Confidence levels.** Claims are labelled **Confirmed** (supported by source
or documentation), **Likely** (suggested by the evidence) or **Unknown**
(needs investigation, a device, or a person). Guesses are never written down
as fact.

## What a project needs

The agents expect two kinds of notes in the repository they work on:

* **`.ai/`** holds durable knowledge that applies across branches. Typical
  files are `README.md`, `architecture.md`, `subsystems.md`, `data-flow.md`,
  `build.md`, `decisions.md` and `gotchas.md`. The agent reads these before
  drawing conclusions and proposes focused additions as it learns things.
* **`TASK_NOTES.md`** (repo root) holds working notes for the current branch:
  the issue, hypotheses, observations, decisions and next steps. It is
  committed so it travels with the branch. Before the branch merges, durable
  findings are moved into `.ai/` and the file is removed.

If a project has no `.ai/` yet, the agent offers to start one.

## Using them

Install an agent into one or more projects with the script:

```bash
./install-to-project.sh firmware-assistant ~/work/my-firmware
./install-to-project.sh webdev-assistant ~/work/app-a ~/work/app-b
```

It copies the agent to `<project>/.github/agents/<agent>.agent.md`, replacing
any earlier copy, so run it again after changing an agent. Run it with no
arguments to list the available agents. Then pick the agent in the agent
picker at the start of a session.

They are installed as custom agents, not skills, because they set how the
assistant works for the whole session. A skill loads only when the assistant
decides a task needs it, which would be too late for rules such as reading
`.ai/gotchas.md` first or never building without permission.

For other assistants, paste the body (everything after the frontmatter) into
the tool's project or system instructions, for example `CLAUDE.md` for Claude
Code.

## Adding or changing an agent

* Keep the shared sections worded the same in every file: *How we work
  together*, *Start from the knowledge base*, *Investigation style*,
  *Confidence*, *Keeping knowledge current* and *Tone*. A change to one of
  them should go into every file.
* Put domain knowledge in the questions checklist and the verification
  section.
* Don't name products, customers or internal systems. Those details belong in
  the project's own `.ai/`.
