# Assigning Port and Data Type for Ø-Devices (`.qsch` or `.qsym`)

This guide explains how to manually configure the port direction and data type of an Ø-Device by editing `.qsch` (schematic) or `.qsym` (symbol) files directly in a text editor (e.g., [Notepad++](https://notepad-plus-plus.org/)).

---

## Step-by-Step Procedure

### 1. Open File
Open your `.qsch` or `.qsym` file containing the Ø-Device in a text editor.

### 2. Locate the Pin Definition Line
Find the pin definition line, which follows this structure:

```text
pin (-2300,1000) (0,0) 0.926 7 17 0x0 -1 "InputBoolean"
```

#### Syntax Breakdown

| Parameter | Value | Description |
| :--- | :--- | :--- |
| **Position** | `(-2300,1000)` | Pin coordinates $(x, y)$ |
| **Label Offset** | `(0,0)` | Offset for the pin label position $(x, y)$ |
| **Font Size** | `0.926` | Text font size |
| **Justification** | `7` | Pin label text alignment |
| **Port & Data Type Code** | `17` | **Combined code for Direction + Data Type** |
| **Reserved 1** | `0x0` | Internal flag/attribute |
| **Reserved 2** | `-1` | Internal flag/attribute |
| **Pin Label** | `"InputBoolean"` | Display name of the pin |

### 3. Update the Port & Data Type Code
Replace the **Port & Data Type Code** (e.g., `17`) with the corresponding value from the reference table below.

> **Example:** To set a pin as an **Output Port** with a **Float** data type, replace `17` with `146`.

---

## Port & Data Type Code Lookup Table

| Data Type | Input | Output | DLL's GND |
| :--- | :---: | :---: | :---: |
| *Direction Code Offset* | *1* | *2* | *3* |
| **Boolean** | **17** | **18** | — |
| **Char** | 33 | 34 | — |
| **Unsigned Char** | 49 | 50 | — |
| **Short** | 65 | 66 | — |
| **Unsigned Short** | 81 | 82 | — |
| **Integer** | **97** | **98** | — |
| **Unsigned Integer** | 113 | 114 | — |
| **Short Float (32-bit)** | 129 | 130 | — |
| **Float** | **145** | **146** | — |
| **Integer64** | 161 | 162 | — |
| **Unsigned Integer 64** | 177 | 178 | — |