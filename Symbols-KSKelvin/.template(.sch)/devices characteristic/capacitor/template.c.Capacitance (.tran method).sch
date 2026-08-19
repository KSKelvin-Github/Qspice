ÿØÿÛ«schematic
  «component (700,0) 0 0
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
      «text (150,-200) 1 7 0 0x1000000 -1 -1 "PWL 0 0 Tstop Vbias_max"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (700,1000) 0 0
    «symbol B1
      «type: B»
      «description: Behavioral Voltage Source»
      «shorted pins: false»
      «line (0,-130) (0,-200) 0 0 0x1000000 -1 -1»
      «line (0,200) (0,130) 0 0 0x1000000 -1 -1»
      «rect (-25,77) (25,73) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,50) (2,100) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,-73) (25,-77) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «ellipse (-130,130) (130,-130) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "B1"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "V=idt(-I(Vmeas))"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (2900,1000) 0 0
    «symbol B1
      «type: B»
      «description: Behavioral Voltage Source»
      «shorted pins: false»
      «line (0,-130) (0,-200) 0 0 0x1000000 -1 -1»
      «line (0,200) (0,130) 0 0 0x1000000 -1 -1»
      «rect (-25,77) (25,73) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,50) (2,100) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,-73) (25,-77) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «ellipse (-130,130) (130,-130) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "B2"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "V=-I(Vmeas)/ddt(V(Vmeas))"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-500,0) 8 0
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
      «text (180,-300) 1 7 1 0x1000000 -1 -1 "Q=100p*x"»
      «text (180,-450) 1 7 1 0x1000000 -1 -1 "Q=1/2*(-1p)*x**2+1000p*x"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (-500,-300) 1 13 0 "GND"»
  «net (700,-300) 1 13 0 "GND"»
  «net (700,300) 1 14 0 "Vmeas"»
  «net (700,800) 1 13 0 "GND"»
  «net (700,1200) 1 14 0 "Charge"»
  «net (2900,800) 1 13 0 "GND"»
  «net (2900,1200) 1 14 0 "Capacitance"»
  «wire (700,200) (700,300) "Vmeas"»
  «wire (700,-300) (700,-200) "GND"»
  «wire (-500,-200) (-500,-300) "GND"»
  «wire (-500,300) (-500,200) "Vmeas"»
  «wire (700,300) (-500,300) "Vmeas"»
  «rect (300,-600) (6200,4450) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (450,2350) 1 7 0 0x1000000 -1 -1 "ï»¿.param Tstop=1\n.tran Tstop\n.func Capacitance()=V(Capacitance)/1V\n.func Charge()=V(Charge)/1V\n.func Vbias()=V(Vmeas)\n.plot Charge()\n.plot Capacitance()\n.abscissa Vbias()"»
  «text (450,3400) 1 7 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param Vbias_max=100"»
  «text (450,4000) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Capacitance and Charge from time domain\n - error free method in calculating Q for capacitance as a function of its voltage\n - Vmeas has to begin with 0V for correct initial condition of Q"»
  «text (1100,1100) 1 7 1 0x1000000 -1 -1 "ï»¿Q=I*t (integral form)"»
  «text (3400,1200) 1 7 1 0x1000000 -1 -1 "ï»¿By I=C dv/dt\n-> C = I / (dv/dt)"»
»

