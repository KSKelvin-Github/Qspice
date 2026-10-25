ÿØÿÛ«schematic
  «component (4300,900) 0 0
    «symbol L-Inductor Saturation
      «type: L»
      «description: Inductor - Saturation»
      «shorted pins: false»
      «line (0,200) (0,180) 0 0 0x1000000 -1 -1»
      «line (0,-200) (0,-180) 0 0 0x1000000 -1 -1»
      «line (100,200) (100,100) 0 0 0x1000000 -1 -1»
      «line (100,100) (-100,-100) 0 0 0x1000000 -1 -1»
      «line (-100,-100) (-100,-200) 0 0 0x1000000 -1 -1»
      «coil (-60,180) (60,-180) 0 0 0 0x1000000 -1 -1»
      «text (150,150) 1 7 0 0x1000000 -1 -1 "L1"»
      «text (150,-100) 1 7 0 0x1000000 -1 -1 "1µ"»
      «text (150,-250) 1 7 0 0x1000000 -1 -1 "Isat=<10>Current that drops L to Satfrac*L (A)"»
      «text (150,-400) 1 7 0 0x1000000 -1 -1 "Lsat=<0.2µ>L approaching saturation (H) [10% of L if Lset=0]"»
      «text (150,-550) 1 7 0 0x1000000 -1 -1 "SATFRAC=<0.7> Factional drop in L at Isat"»
      «text (150,-700) 1 7 0 0x1000000 -1 -1 "Rser=1m"»
      «text (150,-850) 1 7 0 0x1000000 -1 -1 "Rpar=0"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "1"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "2"»
    »
  »
  «component (2600,900) 0 0
    «symbol I
      «type: I»
      «description: Current Source»
      «shorted pins: false»
      «line (0,200) (0,150) 0 0 0x1000000 -1 -1»
      «line (0,-150) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-25,102) (25,98) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,75) (2,125) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,-98) (25,-102) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «ellipse (-100,-150) (100,50) 0 0 0 0x1000000 0x1000000 -1 -1»
      «ellipse (-100,-50) (100,150) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Imeas"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "Ibias"»
      «text (100,-300) 1 7 0 0x1000000 -1 -1 "AC 1"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
    »
  »
  «net (4300,600) 1 13 0 "GND"»
  «net (2600,600) 1 13 0 "GND"»
  «net (2600,1200) 1 14 0 "Vmeas"»
  «wire (2600,1100) (2600,1200) "Vmeas"»
  «wire (2600,600) (2600,700) "GND"»
  «wire (4300,700) (4300,600) "GND"»
  «wire (4300,1200) (4300,1100) "Vmeas"»
  «wire (2600,1200) (4300,1200) "Vmeas"»
  «rect (-950,4400) (3350,300) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (-800,1350) 1 7 0 0x1000000 -1 -1 "ï»¿.ac list frq\n.option saveparams\n.step param Ibias Imin Imax (Imax-Imin)/total_steps\n.func Z() (V(Vmeas)/I(Imeas))\n.func Rs() re(Z())\n.func Ls() im(Z())/2/pi/frq\n.plot Rs LIN\n.plot Ls LIN\n.abscissa Vbias"»
  «text (-800,2950) 1 7 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param frq=1Meg\n.param Imin=0\n.param Imax=100\n.param total_steps=100"»
  «text (-800,3950) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Ls-Rs model parameters\nin dc bias sweep test\n  - template : template.L.FreqSweep.Ls-Rs (.ac).sch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

