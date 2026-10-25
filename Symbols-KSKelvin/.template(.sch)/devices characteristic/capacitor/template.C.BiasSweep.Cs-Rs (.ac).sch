ÿØÿÛ«schematic
  «component (2600,900) 0 0
    «symbol V
      «type: V»
      «description: Independent Voltage Source»
      «shorted pins: false»
      «line (0,-130) (0,-200) 0 0 0x1000000 -1 -1»
      «line (0,200) (0,130) 0 0 0x1000000 -1 -1»
      «rect (-25,77) (25,73) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,50) (2,100) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,-73) (25,-77) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «ellipse (-130,130) (130,-130) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Vmeas"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "Vbias"»
      «text (100,-300) 1 7 0 0x1000000 -1 -1 "AC 1"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (4300,900) 0 0
    «symbol C-Capacitor Voltage Dependent
      «type: C»
      «description: Capacitor - Voltage Dependent»
      «shorted pins: false»
      «line (0,200) (0,40) 0 0 0x1000000 -1 -1»
      «line (0,-40) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-130,-40) (130,-30) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-130,30) (130,40) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "C2"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "1µ"»
      «text (100,-300) 1 7 0 0x1000000 -1 -1 "Vsat=<10>Voltage that drops C to Satfrac*C (V)"»
      «text (100,-450) 1 7 0 0x1000000 -1 -1 "Csat=<0.2µ>C approaching saturation (F) [10% of C if Csat=0]"»
      «text (100,-600) 1 7 0 0x1000000 -1 -1 "SATFRAC=<0.7>Factional drop in C at Vsat"»
      «text (100,-750) 1 7 0 0x1000000 -1 -1 "Rser=1m"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
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
  «text (-800,1350) 1 7 0 0x1000000 -1 -1 "ï»¿.ac list frq\n.option saveparams\n.step param Vbias Vmin Vmax (Vmax-Vmin)/total_steps\n.func Z() (V(Vmeas)/-I(Vmeas))\n.func Rs() re(Z())\n.func Cs() -1/2/pi/frq/im(Z())\n.plot Rs LIN\n.plot Cs LIN\n.abscissa Vbias"»
  «text (-800,2950) 1 7 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param frq=1Meg\n.param Vmin=0\n.param Vmax=100\n.param total_steps=100"»
  «text (-800,3950) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Cs-Rs model parameters\nin dc bias sweep test\n  - template : template.C.FreqSweep.Cs-Rs (.ac).sch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

