# Matlab2Qspice
Matlab interface for Qspice, created with Matlab R2023a

## Files
* qsch2qraw.m - convert Qspice schematic (.qsch) to output data (.qraw)
* cir2out.m - QPOST post processing .cir and .qraw to .out (for .meas and .func)
* qraw_parser.m - parser of Qspice output data file (.qraw) in binary format
* out_parser.m - parser of Qpsice Qpost console output file (.out) in text format

## Example Files
* Matlab2Qspice_example_demo.m - example to simulate and plot results from circuit in test circuit folder
* Matlab2Qspice_example_impedance.m - example to simulate and plot impedance, gamma (SmithChart) for "impedance(.ac).qsch" in test circuit folder
* Matlab2Qspice_example_FFT_Qraw.m - example to load .fft.qraw and plot FFT : magnitude vs frequency (linear and dB plot)
* [folder] test circuit - circuit demo (.qsch) for example .m to run

## Hints
* if you have a schematic (.qsch), use qsch2qraw.m to convert schematic to output data (.qraw).  This command level operations is same as to Run simulation from Qspice to get .qraw.
* if you have an output data (.qraw) in binary format, qraw_parser.m can help to convert it into a matlab cell array.  You can work on simulation data in Matlab without the need of exporting with Qspice Waveform Viewer (QUX.exe)