---
name: cadence-remote-batch
description: Use when working with a remote Cadence/Virtuoso environment over SSH, especially to inspect OA libraries, create or repair visible schematics with dbAccess, run Spectre or OCEAN in batch mode, export results, and avoid GUI-only failure modes such as lock files, display issues, and empty black schematics.
---

# Cadence Remote Batch

Use this skill when Cadence is running on a remote Linux VM or server and you need reliable, scriptable progress without depending on interactive GUI control.

## Quick Start

Prefer this order of operations:
1. Verify remote access and tool paths.
2. Inspect the existing library and cellview structure before editing anything.
3. Use `dbAccess` for OA inspection and deterministic schematic edits.
4. Use `spectre` and `ocean -nograph` for batch simulation and result export.
5. Pull exported CSV data local and plot locally if the remote GUI is fragile.
6. Inspect the generated netlist before trusting results.
7. Keep each process kit in its own launcher, cds.lib, and scratch tree.

## Workflow

### 1. Establish the remote baseline

On the remote machine, confirm:
- the login user and working directory
- Cadence executables such as `virtuoso`, `dbAccess`, `spectre`, and `ocean`
- the active `cds.lib`
- whether a known-good design library exists for comparison

Treat existing in-environment libraries as truth for:
- library definitions
- view naming
- symbol scale
- wire and label conventions

If a working reference library exists, inspect it before creating anything new.

### 2. Inspect before editing

Before creating or fixing a schematic, inspect:
- `instances`
- `nets`
- `terminals`
- `pins`
- `shapes`

Use `scripts/inspect_schematic_graphics.il` to compare a known-good schematic against the target schematic.

Interpretation:
- If `instances/nets/terminals` exist but `shapes=0`, the schematic is logically connected but visually empty.
- If `shapes` exist but the canvas still looks empty, coordinates may be far too large or too spread out.
- If the cellview cannot be opened for write, look for `.cdslck` files or an open GUI session.

### 3. Creating or repairing schematics

When GUI APIs are unavailable or unreliable, create the schematic in OA with `dbAccess`.

Key lesson:
- Logical connectivity is not enough.
- A visible schematic needs explicit drawable objects such as wires and labels.

For programmatic schematic creation:
- create nets and terms
- create device instances
- connect instance terminals to nets
- add visible wire shapes
- add visible labels
- keep coordinates compact and comparable to normal symbol sizes
- keep the schematic readable for humans, not just electrically connected
- prefer short stubs plus explicit net names over long crossing wires
- verify the extracted netlist matches the intended device sizing and pin order

Do not assume a created instance will automatically produce a readable canvas layout.

### 4. Verify the netlist, not only the schematic

After `createNetlist()` or any export step:
- inspect the generated `input.scs`
- confirm subcircuit pin order
- confirm device widths, finger counts, and other hidden CDF-mapped parameters
- confirm the intended testbench is the source of truth, not a hand-written copy

If a parameter looks correct in the GUI but wrong in the netlist, trust the netlist and inspect the CDF mapping.

### 5. Handle symbols separately from schematics

Schematic success does not imply symbol success.

If hierarchical testbenches are needed:
- first confirm whether symbol creation APIs are available in the current batch environment
- if not, keep simulation moving with standalone Spectre decks while investigating symbol generation
- avoid blocking electrical verification on symbol-view automation

Use `scripts/inspect_symbol_pins.il` to inspect master symbol pin locations and term names.

### 6. Prefer batch simulation

For remote work, prefer:
- `spectre` for simulation
- `ocean -nograph` for PSF export

This is usually more reliable than trying to drive ADE remotely.

Recommended pattern:
1. Run `spectre` on a standalone deck.
2. Export selected results to CSV with OCEAN.
3. Pull CSV files locally.
4. Plot and post-process locally with Python.

Use `scripts/export_results_template.ocn` as a starting point for PSF export.

### 7. Keep installations isolated

When multiple process kits or library sets are available, isolate them:
- use separate launcher shortcuts or shell wrappers
- keep separate `cds.lib` and scratch/result directories
- do not mix unrelated process environments in one session unless that is the explicit goal
- if a legacy CDB library must be reused, convert it into a dedicated OA copy instead of sharing the source tree
- prefer launching from a dedicated work directory so startup picks up the intended local `cds.lib`

### 8. Keep reusable assets generic

For anything intended for GitHub or reuse:
- never hard-code confidential library names
- never hard-code proprietary model paths
- never embed process-specific device names unless they are public

Instead:
- use placeholders such as `YOUR_LIB`, `YOUR_CELL`, `YOUR_RESULTS_DIR`
- document where environment-specific values must be filled in

## Common Failure Modes

Read [references/common-pitfalls.md](references/common-pitfalls.md) when:
- the schematic opens as a black or empty canvas
- Cadence reports a missing DM shared library
- OCEAN fails because of display or log locking
- batch scripts work logically but the GUI view is still unreadable

## Included Scripts

- `scripts/inspect_schematic_graphics.il`
  Use to compare object counts and visible shapes between a known-good cell and a broken cell.
- `scripts/inspect_symbol_pins.il`
  Use to inspect symbol terminals and pin figure locations before wiring programmatically.
- `scripts/export_results_template.ocn`
  Use to export DC or transient waveforms from PSF to CSV without relying on ADE.

## Operating Rules

- Favor known-good local conventions over generic assumptions.
- Back up a design directory before replacing or rebuilding a cellview.
- Do not delete lock files blindly while a GUI editor may still be open.
- Separate "Cadence/OA problem" from "circuit-design problem" early.
- If the goal is verification, do not let symbol automation block batch simulation.
- Prefer schematic-driven netlisting when the schematic is meant to be reviewed by humans.
- Treat library conversion, schematic graphics, and simulation as separate checkpoints.
