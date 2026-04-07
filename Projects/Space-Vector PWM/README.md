# Space-Vector Pulse Width Modulation (SVPWM)
This project showcases the utilization of C++ blocks to implement Space-Vector Pulse Width Modulation (SVPWM) in QSpice. It is designed as a tutorial to assist others in comprehending the mathematical concepts and implementation of SVPWM in Qspice. The folder comprises both the C++ block version and the B-sources version, accompanied by a pdf presentation that systematically explains the algorithm, operational principles and implementation.

## Files
* Space-Vector Pulse Width Modulation (SVPWM) by KSKelvin.pdf : Explains operation principal and mathematics of SVPWM

## Folders
* /01 Basic Operation (DLL 3-segment)/ - fundamental concept (C++ version)
* /02 Basic Operation (DLL 7-segment)/ - 7-segment switching pattern (C++ version)
* /03a B-source SVPWM Implementation (7-segment)/ - B-source implementation
* /03b B-source SVPWM Implementation (3-5-7-segment)/ - B-source with selectable 3-,5-,7-segment
* /04 Local Geometry (DLL)/ - SVPWM with local geometry C++ version

## How to use
* download all files from a folder, run simulation in Qspice.  For C++ version, first time simulation execution will pop up window and ask to compile .dll.

## Screen Capture
* /04 Local Geometry (DLL)/example.Space-VectorPWM(LocalGeometry).qsch
![alt text](https://github.com/KSKelvin-Github/Qspice/blob/main/Projects/Space-Vector%20PWM/screen%20capture/SVPWM-Local-Geometry.png)