# Common Pitfalls

## 1. The library opens with DM errors

Symptom:
- Cadence complains about a missing `libgdm*.so`
- The library appears in Library Manager but behaves strangely

Typical cause:
- The design library was created with the wrong `DMTYPE`
- A process or technology name was accidentally used as the DM system

What to do:
- Compare `cdsinfo.tag` against a known-good local design library
- For ordinary design libraries, expect a normal filesystem-backed library, not a custom DM plugin

## 2. The schematic is black or looks empty

Symptom:
- The editor opens but the canvas appears black or blank
- Exported images are also blank

Typical causes:
- `instances/nets/terminals` exist but `shapes=0`
- Coordinates are far outside a normal viewing range
- Only logical objects were created, not visible wire or label figures

What to do:
- Inspect object counts first
- Compare against a working schematic in the same environment
- Rebuild using compact coordinates and explicit drawable shapes
- Reopen the cellview and use `Zoom Fit`

## 3. The circuit exists logically but cannot be reviewed visually

Symptom:
- Navigator or properties show devices and nets
- The schematic still is not human-readable

Typical cause:
- OA connectivity was created without the visible drawing layer content needed for schematic review

What to do:
- Treat reviewability as a separate requirement from connectivity
- Add wires, labels, and readable placement

## 4. The cellview cannot be opened for write

Symptom:
- `dbOpenCellViewByType(... "a")` fails or reports a lock problem

Typical causes:
- a GUI editor still has the view open
- `.cdslck` files remain from an active or stale session

What to do:
- Check whether the view is open in Virtuoso before deleting anything
- Prefer waiting or closing the GUI cleanly before editing from batch mode

## 5. OCEAN behaves oddly on a headless machine

Symptom:
- display warnings
- `CDS.log` lock warnings
- exports silently fail

Typical causes:
- GUI expectations leaking into a headless session
- multiple Cadence processes sharing the same log files

What to do:
- use `ocean -nograph`
- confirm the actual PSF path with `openResults(...)`
- verify the expected output CSV files exist before copying them back

## 6. Symbol automation blocks simulation progress

Symptom:
- The schematic is done, but no symbol exists
- Testbench generation stalls on symbol-view tooling

What to do:
- decouple electrical verification from symbol automation
- run a standalone Spectre deck first
- come back to hierarchical symbol generation after the electrical behavior is verified
