# Matlab2Qspice
This project uses Matlab to automate Qspice

## Files
* qsch2qraw.m - convert Qspice schematic (.qsch) to output data (.qraw)
* qraw_parser.m - parser of Qspice output data file (.qraw) in binary format

## Example Files
* Qspice_example_loadtestcircuit.m - example to simulate and plot results from circuit in test circuit folder
* [folder] test circuit - demo .qsch to run examples

## Hints
* if you have a schematic (.qsch), use qsch2qraw.m to convert schematic to output data (.qraw).  This command level operations is same as to Run simulation from Qspice to get .qraw.
* if you have an output data (.qraw) in binary format, qraw_parser.m can help to convert it into a matlab cell array.  You can work on simulation data in Matlab without the need of exporting with Qspice Waveform Viewer (QUX.exe)