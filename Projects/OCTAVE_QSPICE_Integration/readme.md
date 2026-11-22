# GNU Octave – QSPICE TCP Co-Simulation

Octave : https://octave.org/
Free software, Drop-in compatible with many Matlab scripts

Closed-loop co-simulation between **QSPICE** and **GNU Octave** over a local TCP connection (`127.0.0.1:55000`) using QSPICE's built-in **Berkeley Socket API** and Octave's **`instrument-control`** package. This setup runs a discrete-time PI controller natively in Octave (`pi_controller.m`) without requiring MATLAB or Simulink Coder.

---

## Requirements & Setup

1. **Space-Free Path:** Place all project files in a folder path with **no spaces** (e.g., `C:\Qspice_Octave_Demo\`).
2. **GNU Octave + Package:** Install Octave and the `instrument-control` package:
   ```matlab
   pkg install -forge instrument-control