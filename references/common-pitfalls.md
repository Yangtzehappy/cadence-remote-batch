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
- If a source kit is still in legacy CDB form, convert it into a dedicated OA copy in an isolated work tree before using it in a new flow

## 1b. Different launch directories see different libraries

Symptom:
- Virtuoso launched from one directory shows one process set
- The same executable launched from another directory shows a different process set

Typical cause:
- local `cds.lib` files or wrapper scripts are being picked up from the current working directory

What to do:
- use a dedicated launcher directory for each process kit
- keep `cds.lib`, scratch data, and results under the same isolated root
- verify the active library set at startup before editing anything

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

## 7. The schematic looks right, but the netlist is wrong

Symptom:
- The GUI shows the intended size or topology
- The generated `input.scs` uses unexpected values or defaults

Typical causes:
- hidden CDF parameters were not mapped the way the PDK expects
- finger count, total width, or wrapper parameters were not propagated
- the testbench was edited by hand instead of being netlisted from the schematic source of truth

What to do:
- inspect the generated netlist every time the flow changes
- compare visible schematic parameters to netlisted device parameters
- do not trust the GUI alone when hidden fields may control the actual instance

## 8. The schematic is electrically correct but hard for humans to review

Symptom:
- connectivity checks pass
- the picture still suggests shorts or ambiguous crossings
- long wires cross through symbols or pin neighborhoods

Typical causes:
- the drawing was optimized for connectivity only
- labels were omitted or not attached to wires
- too many wires were routed as one long bus

What to do:
- use short stubs plus explicit wire names
- keep power and ground visually local
- avoid crossings that look like shorts even if they are not
- treat human readability as a design requirement, not a cosmetic extra

## 9. Multiple process environments interfere with each other

Symptom:
- one launch sees a different process set than another
- the same tool behaves differently depending on startup location

Typical causes:
- shared `cds.lib` or startup scripts
- mixing unrelated libraries in one shell/session
- reusing scratch directories across process kits

What to do:
- keep each process kit in its own launcher or wrapper
- isolate `cds.lib`, results, and scratch paths
- avoid cross-contaminating one environment with another unless you are intentionally comparing them
