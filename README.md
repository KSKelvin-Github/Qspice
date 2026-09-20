# Qspice Resources & Guidelines

[![QSpice](https://img.shields.io/badge/Simulator-QSpice-blue.svg)](https://www.qorvo.com/design-hub/calculators-simulation/qspice)
[![Examples Library](https://img.shields.io/badge/Circuit%20Examples-Qspice--Circuits-orange.svg)](https://github.com/QSpice-Circuits/Qspice-examples)

Welcome to the comprehensive repository for **Qspice** tutorials, reference manuals, custom symbol libraries, and simulation examples curated by KSKelvin.

---

## 🔗 Official Qspice Links
* 📥 [Download Qspice (Official Qorvo Website)](https://www.qorvo.com/design-hub/design-tools/interactive/qspice)
* ⚡ [Direct Installer Download (.exe)](https://getqspice.com/InstallQSPICE.exe)
* 💬 [Official Qspice Forum](https://forum.qorvo.com/c/qspice/)

---

## 📂 Repository Contents

| Folder | Description |
| :--- | :--- |
| `Guideline/` | Comprehensive PDF guides covering Qspice basics to advanced topics. |
| `Symbols-KSKelvin/` | Custom `.qsym` symbol files for Qspice. |
| `SPICE-library/` | SPICE model collections (`.model`) for BJTs, Diodes, JFETs, and MOSFETs. |
| `Projects/` | Example circuit designs and simulation projects. |
| `Matlab2Qspice/` | Scripts for generating netlists, automating simulations, and plotting results via MATLAB. |
| `Supplementary/` | Additional reference materials and notes on SPICE simulation. |

---

## 📚 User Guidelines & Reference Manuals

Download these detailed PDF guides to learn Qspice usage and device modeling:

| Guide Name | Description | Direct Download |
| :--- | :--- | :---: |
| **Entry User Guide** | Beginner tutorial for getting started with Qspice. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Qspice%20-%20Entry%20User%20Guide%20by%20KSKelvin.pdf) |
| **General Reference Guide** | Covers hierarchical blocks, subcircuits, Symbol Editor, and viewers. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Qspice%20-%20General%20Reference%20Guide%20by%20KSKelvin.pdf) |
| **Command Reference Guide** | Guide to dot (`.`) commands and batch simulation scripting. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Qspice%20-%20Command%20Reference%20Guide%20by%20KSKelvin.pdf) |
| **Device Reference Guide** | Complete reference for Qspice built-in device models. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Qspice%20-%20Device%20Reference%20Guide%20by%20KSKelvin.pdf) |
| **Bode Analysis Guide** | Frequency response analysis using the `.bode` command. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Qspice%20-%20Bode%20Frequency%20Response%20Analysis%20(.bode).pdf) |
| **Model Generators Guide** | How to use built-in Diode and MOSFET model generators. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Qspice%20-%20Model%20Generators%20Guide%20by%20KSKelvin.pdf) |
| **How Time Step Works** | Deep-dive into timesteps, `maxstep`, and `TTOL`. | [Download PDF](https://github.com/KSKelvin-Github/Qspice/raw/main/Guideline/Advanced%20Topics/Qspice%20-%20How%20Time%20Step%20Works.pdf) |

---

## ⚡ How to Download & Setup

<details>
<summary><b>Option 1: Quick Download (ZIP)</b></summary>

1. Click the green **`<> Code`** button at the top of the repository page.
2. Select **`Download ZIP`**.
3. Extract the ZIP file to access all guidelines, symbol libraries, and project files.
</details>

<details>
<summary><b>Option 2: Clone via GitHub Desktop</b></summary>

1. Download and install [GitHub Desktop](https://desktop.github.com/download/).
2. In GitHub Desktop, clone using the URL: `https://github.com/KSKelvin-Github/Qspice.git`
3. Go to **Repository > Show in Explorer** to view your local files.
4. Click **Pull origin** anytime to fetch the latest updates.
</details>

---

## 💡 Recommended Community Resources

* **Forum Topics:**
  * [Qspice Beginner Tutorial](https://forum.qorvo.com/t/beginner-tutorial-for-qspice-community-sharing/25421)
  * [Delayed Pulse Train (Digital Delay .DLL)](https://forum.qorvo.com/t/delayed-pulse-train-for-conceptual-logic-in-qspice/25996)
  * [.net S-Parameters Simulation (Touchstone .s2p)](https://forum.qorvo.com/t/net-network-parameters-simulation-with-touchstone-s2p-file/24862)
  * [Guide to Importing Infineon SPICE Models](https://forum.qorvo.com/t/general-guide-to-import-an-infineon-spice-mosfet-model/25212)
  * [Guide to Importing TI SPICE Models](https://forum.qorvo.com/t/general-guide-to-import-a-ti-spice-model/23993)

* **Community Repositories:**
  * [RDunn's QSpice Repo](https://github.com/robdunn4/QSpice) – C++ / DLL blocks and custom utilities (e.g., QColorPrefs).
  * [physicboy's QSPICE Repo](https://github.com/physicboy/QSPICE) – Power electronics & digital control examples using C++.
  * [PyQSPICE (by masashi.nogawa)](https://github.com/Qorvo/PyQSPICE) – Official Python interface for Qspice.
  * [Mgyger's Symbol Collection](https://gitlab.com/mgyger/qspice-symbols/) – Community symbol collection.
  * [Marcos Alonso's GitHub Repo](https://github.com/marcosalonsoelectronics/website) & [YouTube Channel](https://www.youtube.com/@MarcosAlonsoElectronics) – Educational resources and tutorials.