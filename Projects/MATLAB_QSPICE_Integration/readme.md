# MATLAB & QSPICE Integration

This directory ([`Projects/MATLAB_QSPICE_Integration`](https://github.com/KSKelvin-Github/Qspice/tree/main/Projects/MATLAB_QSPICE_Integration)) demonstrates approaches for implementing and co-simulating a **discrete-time Proportional-Integral (PI) controller** in **Qorvo QSPICE** alongside **MATLAB** and **Simulink**.

---

## Benchmark Closed-Loop System

All workflows share the same closed-loop benchmark circuit (`my_circuit.qsch`, `.tran 10m`) so results can be compared directly across methods:

| Block | Component / Description | Parameters |
| :--- | :--- | :--- |
| **Reference Input (`V1`)** | Step voltage source | `0 V` to `1 V` (`PWL 0 0 20u 1`) |
| **Error Subtractor (`X3`)** | Feedback error calculation | $e(t) = V(\text{ref}) - V(\text{out})$ |
| **Continuous-Time Plant (`X2`)** | 2nd-order Laplace transfer function | $\omega_n = 3162\text{ rad/s}$ ($\approx 503\text{ Hz}$), $\zeta = 0.632$, $\text{IC} = 0$ |
| **Discrete PI Controller (`X1`)** | Forward-Euler discrete PI controller | $k_p = 0.8$, $k_i = 1200$, $T_s = 50\ \mu\text{s}$ ($20\text{ kHz}$) |

---

## Workflows at a Glance

| Subfolder | Approach | Key Files | Requirements |
| :--- | :--- | :--- | :--- |
| [`00_Qspice_Standalone`](https://github.com/KSKelvin-Github/Qspice/tree/main/Projects/MATLAB_QSPICE_Integration/00_Qspice_Standalone) | **Native C++ Reference Baseline** — Discrete PI controller written directly in C++ as a QSPICE C-Block. | `my_circuit.qsch`, `pi_block.cpp`, `readme.md`, `screen_capture/` | QSPICE only (no MATLAB/Simulink required) |
| [`01_MATLAB_Basic_Workflow`](https://github.com/KSKelvin-Github/Qspice/tree/main/Projects/MATLAB_QSPICE_Integration/01_MATLAB_Basic_Workflow) | **MATLAB Coder C-Code Generation** — Generates ANSI C89/C90 code from a stateful MATLAB function and compiles it into a QSPICE DLL. | `pi_controller.m`, `matlab_codegen.m`, `pi_block.cpp`, `my_circuit.qsch`, `readme.md`, `screen_capture/` | MATLAB + MATLAB Coder + QSPICE |
| [`02_Simulink_Basic_Workflow`](https://github.com/KSKelvin-Github/Qspice/tree/main/Projects/MATLAB_QSPICE_Integration/02_Simulink_Basic_Workflow) | **Simulink / Embedded Coder C-Code Generation** — Programmatically builds a Simulink model, exports ANSI C89/C90 code, and wraps it in a QSPICE C-Block DLL. | `pi_simulink_generation.m`, `pi_block.cpp`, `my_circuit.qsch`, `readme.md`, `screen_capture/` | MATLAB + Simulink + Simulink Coder (`ert.tlc` or `grt.tlc`) + QSPICE |
| [`03_TCP_CoSimulation`](https://github.com/KSKelvin-Github/Qspice/tree/main/Projects/MATLAB_QSPICE_Integration/03_TCP_CoSimulation) | **Live TCP/IP Co-Simulation** — Runs `pi_controller.m` natively in MATLAB while QSPICE communicates over localhost TCP (`127.0.0.1:55000`). | `matlab_tcp_server_java.m`, `matlab_tcp_server_tcpserver.m`, `pi_controller.m`, `pi_block.cpp`, `my_circuit.qsch`, `readme.md`, `screen_capture/` | Base MATLAB (R2021a+) + QSPICE (no Coder license required) |

---

## Important Usage Note

* **No Spaces in File Paths:** Because QSPICE compiles C-Blocks with `dmc.exe`, ensure the entire working directory path contains **no whitespace** (for example, use `C:\Qspice_Demo\`, not `C:\My Projects\Qspice Demo\`).
