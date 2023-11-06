# Matlab2Qspice
This project uses Matlab to automate Qspice
Created with Matlab R2023a

## Files
* qsch2qraw.m - convert Qspice schematic (.qsch) to output data (.qraw)
* qraw_parser.m - parser of Qspice output data file (.qraw) in binary format

## Example Files
* Qspice_example_demo.m - example to simulate and plot results from circuit in test circuit folder
* Qspice_example_impedance.m - example to simulate and plot impedance, gamma (SmithChart) for "impedance(.ac).qsch" in test circuit folder
* [folder] test circuit - circuit demo (.qsch) for example .m to run

## Hints
* if you have a schematic (.qsch), use qsch2qraw.m to convert schematic to output data (.qraw).  This command level operations is same as to Run simulation from Qspice to get .qraw.
* if you have an output data (.qraw) in binary format, qraw_parser.m can help to convert it into a matlab cell array.  You can work on simulation data in Matlab without the need of exporting with Qspice Waveform Viewer (QUX.exe)