ÿØÿÛ«schematic
  «component (-600,-200) 0 0
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
  «component (-1900,-200) 8 0
    «symbol C
      «type: C»
      «description: Capacitor»
      «shorted pins: false»
      «line (0,200) (0,40) 0 0 0x1000000 -1 -1»
      «line (0,-40) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-130,-40) (130,-30) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-130,30) (130,40) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «text (180,150) 1 7 0 0x1000000 -1 -1 "C1"»
      «text (180,-150) 1 7 0 0x1000000 -1 -1 "Q=11.858e-9*(sqrt(1+x/5.892)-1)"»
      «text (200,-350) 1 7 1 0x1000000 -1 -1 "Q=100p*x"»
      «text (200,-550) 1 7 1 0x1000000 -1 -1 "Q=1/2*(-1p)*x**2+1000p*x"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (-1900,-500) 1 13 0 "GND"»
  «net (-600,-500) 1 13 0 "GND"»
  «net (-600,100) 1 14 0 "Vmeas"»
  «wire (-600,0) (-600,100) "Vmeas"»
  «wire (-600,-500) (-600,-400) "GND"»
  «wire (-1900,-400) (-1900,-500) "GND"»
  «wire (-1900,100) (-1900,0) "Vmeas"»
  «wire (-600,100) (-1900,100) "Vmeas"»
  «rect (-950,3850) (3200,-800) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (-800,1350) 1 7 0 0x1000000 -1 -1 "ï»¿.ac list frq\n.option saveparams\n.step param Vbias Vmin Vmax (Vmax-Vmin)/total_steps\n.func Z() (V(Vmeas)/-I(Vmeas))\n.func Resistance() re(Z())\n.func Capacitance() -1/2/pi/frq/im(Z())\n.plot Resistance() LIN\n.plot Capacitance() LIN\n.abscissa Vbias"»
  «text (-800,3000) 1 7 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param frq=1Meg\n.param Vmin=0\n.param Vmax=100\n.param total_steps=100"»
  «text (-800,3650) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Capacitance and Resistance"»
»

