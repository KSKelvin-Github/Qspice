# MATLAB-to-QSPICE Batch Regression Test Suite

A collection of MATLAB scripts and helper functions designed to automate batch regression testing of [QSPICE](https://www.qorvo.com/design-hub/design-tools/interactive/qspice) schematics (`.qsch`).

This toolkit automates netlist generation (`QUX.exe`) and simulation execution (`QSPICE64.exe` / `QSPICE80.exe`) directly from MATLAB, handles write-protected directories automatically, cleans up temporary simulation artifacts, and generates a concise pass/fail summary report.

---

## Features

- **Two Batch Testing Modes**:
  - **Recursive Folder Scan**: Automatically discovers and simulates every `.qsch` file across a selected root directory and all nested subfolders.
  - **Multi-File Selection**: Lets you hand-pick one or more `.qsch` schematics from a specific directory.
- **Write-Protection Handling**: Automatically detects if a schematic resides under `C:\Program Files\` (e.g., QSPICE's built-in `Examples` folder) and routes temporary output files to MATLAB's current working directory instead.
- **Automatic Solver Selection**: Inspects the generated `.cir` netlist for `fastmath=0` (automatically switches to `QSPICE80`) or `fastmath=1` (switches to `QSPICE64`).
- **Auto-Cleanup**: Deletes temporary `.cir` netlists and `.qraw` waveform files after each simulation to keep your workspace clean.
- **Regression Summary Reporting**: Tracks and lists schematics that fail to execute or do not finish with a `Total elapsed time:` message (such as fatal simulation errors or non-standalone hierarchical subcircuit blocks).
- **`.step` Sweep Parsing**: The core helper functions parse QSPICE console logs to extract `.step` parameter names, values, and step counts into a structured MATLAB variable.

---

## File Overview

| File | Type | Description |
| :--- | :--- | :--- |
| `Matlab2Qspice_Regression_FolderAllFiles.m` | Script | Prompts for a root folder, recursively locates all `.qsch` files, runs batch simulations, cleans up artifacts, and prints a summary report. |
| `Matlab2Qspice_Regression_UserSelectFiles.m` | Script | Prompts for one or more `.qsch` files via a multi-select dialog, runs simulations, cleans up artifacts, and prints a summary report. |
| `qsch2qraw.m` | Function | Converts a `.qsch` schematic to a `.cir` netlist and runs QSPICE, saving output files alongside the original `.qsch` file. |
| `qsch2qraw_pwd.m` | Function | Same as `qsch2qraw.m`, but writes the `.cir` and `.qraw` files to MATLAB's current working directory (`pwd`) for use with write-protected directories. |

---

## Prerequisites

- **Operating System**: Windows
- **MATLAB**: Any recent version supporting `uigetdir`, `uigetfile`, `isfile`, and `startsWith`
- **QSPICE**: Installed in one of the standard locations:
  - `C:\Program Files\QSPICE\`
  - `%USERPROFILE%\QSPICE\`

> **Note:** If QSPICE is installed in a custom directory, update the `QspicePath` variable in both `qsch2qraw.m` and `qsch2qraw_pwd.m`.

---

## Usage

### 1. Run a Recursive Folder Regression Test

1. Place all four `.m` files in the same folder (or ensure `qsch2qraw.m` and `qsch2qraw_pwd.m` are on your MATLAB path).
2. Run the folder regression script in MATLAB:
   ```matlab
   Matlab2Qspice_Regression_FolderAllFiles
   ```
3. Select the root directory containing your `.qsch` files (defaults to `C:\Program Files\QSPICE\Examples`).
4. Monitor progress and view the final report in the MATLAB Command Window.

### 2. Run a Regression Test on Selected Files

1. Run the file-selection regression script in MATLAB:
   ```matlab
   Matlab2Qspice_Regression_UserSelectFiles
   ```
2. Select one or more `.qsch` files in the file dialog and click **Open**.
3. Review the simulation logs and summary report in the Command Window.

### 3. Using the Core Helper Functions Directly

You can also call `qsch2qraw` or `qsch2qraw_pwd` directly in your own MATLAB scripts:

```matlab
% Default: binary .qraw format using QSPICE64
[Qpath, step, Console] = qsch2qraw('C:\path\to\circuit.qsch');

% Custom format ('binary' or 'ascii') and simulator ('QSPICE64' or 'QSPICE80')
[Qpath, step, Console] = qsch2qraw('circuit.qsch', 'ascii', 'QSPICE80');

% For schematics inside write-protected directories (outputs saved to current folder)
[Qpath, step, Console] = qsch2qraw_pwd('C:\Program Files\QSPICE\Examples\DelayedPulseTrain.qsch');
```

#### Output Arguments
- **`Qpath`**: Struct containing `.qsch`, `.cir`, and `.qraw` file paths.
- **`step`**: Struct containing `.step` sweep metadata (`status`, `TotalStep`, `name`, `data`, `textstr`).
- **`Console`**: Cell array of strings capturing the QSPICE simulator console output.

---

## Example Summary Output

After completing a batch run, the script prints a summary to the Command Window:

```text
*** Regression Test Summary Report ****
Total .qsch files tested: 42
No execution errors occurred.
Filename(s) without Total elapsed time returned:
  [These files may be hierarchical/subcircuit blocks or encountered a fatal error.]
  C:\Program Files\QSPICE\Examples\SubcircuitBlock.qsch
```

---

## Notes & Known Limitations

- **Write-Protected Folder Dependencies**: When running schematics located in `C:\Program Files\` via `qsch2qraw_pwd()`, the netlist is generated in MATLAB's current working directory. As a result, relative local dependencies (such as `.lib` or `.sub` files residing in the original schematic folder) will not be resolved automatically.
- **Hierarchical Schematics**: Subcircuit `.qsch` files that are not standalone runnable simulations will be flagged under `Filename(s) without Total elapsed time returned`—this is expected behavior.

---

## Repository

Part of the [KSKelvin-Github/Qspice](https://github.com/KSKelvin-Github/Qspice) collection.