# Cadence Remote Batch

`cadence-remote-batch` is a Codex skill for working more smoothly with remote Cadence and Virtuoso environments.

The goal of this project is simple: help an agent inspect libraries, diagnose schematic-view problems, run batch simulations, and export results in a more reliable way when direct GUI interaction is awkward or fragile.

This skill is focused on workflow, not on any specific PDK or proprietary design kit. It captures practical lessons for:

- inspecting OA libraries and cellviews
- comparing working and broken schematics
- repairing visually empty or black schematic views
- using `dbAccess` for deterministic batch edits
- running `spectre` and `ocean -nograph` remotely
- exporting results for local plotting and review

## Why this exists

In many real setups, an agent can reach a remote Linux VM over SSH long before it can comfortably drive a full Virtuoso GUI session. In that situation, progress often depends on batch-oriented tools and good debugging habits rather than on interactive clicking.

This repository packages those habits into a reusable skill so future agent runs can be faster, more stable, and easier to reproduce.

## Repository contents

- `SKILL.md`  
  The main skill instructions.

- `references/common-pitfalls.md`  
  A short guide to common failure modes such as empty schematics, DM issues, lock files, and headless OCEAN quirks.

- `scripts/inspect_schematic_graphics.il`  
  A small inspection script for comparing visible schematic objects.

- `scripts/inspect_symbol_pins.il`  
  A helper for inspecting symbol terminals and pin figure locations.

- `scripts/export_results_template.ocn`  
  A generic OCEAN template for exporting batch simulation results to CSV.

## Intended use

This repository is meant as a reusable agent skill and workflow reference. It is most useful when:

- the Cadence environment is remote
- the design database can be inspected from batch tools
- simulation can be run from `spectre`
- results need to be exported and post-processed outside ADE

## Scope

This repository intentionally avoids including:

- proprietary PDK files
- model files
- confidential design data
- internal library names
- project specific content

You should adapt the placeholders in the scripts to your own environment before using them.

## Notice

This project is shared for workflow reuse only.

If you believe any content in this repository infringes your rights or should not be published, please open an issue or contact the repository owner. The content will be reviewed and, if necessary, removed promptly.
