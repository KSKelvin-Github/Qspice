ÿØÿÛ«schematic
  «component (5100,1800) 8 0
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
      «text (180,150) 1 7 0 0x1000000 -1 -1 "Vmeas"»
      «text (180,-150) 1 7 0 0x1000000 -1 -1 "PWL 0 0 Tstart Vbias_max Tstop Vbias_min"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (3900,3700) 0 0
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
  «component (3900,2800) 0 0
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
  «component (7100,1800) 0 0
    «symbol C-Capacitor Voltage Dependent
      «type: C»
      «description: Capacitor - Voltage Dependent»
      «shorted pins: false»
      «line (0,200) (0,40) 0 0 0x1000000 -1 -1»
      «line (0,-40) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-130,-40) (130,-30) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-130,30) (130,40) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "C1"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "1µ"»
      «text (100,-300) 1 7 0 0x1000000 -1 -1 "Vsat=<10>Voltage that drops C to Satfrac*C (V)"»
      «text (100,-450) 1 7 0 0x1000000 -1 -1 "Csat=<0.2µ>C approaching saturation (F) [10% of C if Csat=0]"»
      «text (100,-600) 1 7 0 0x1000000 -1 -1 "SATFRAC=<0.7>Factional drop in C at Vsat"»
      «text (100,-750) 1 7 0 0x1000000 -1 -1 "Rser=1m"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (5100,1500) 1 13 0 "GND"»
  «net (5100,2100) 1 14 0 "Vmeas"»
  «net (3900,3500) 1 13 0 "GND"»
  «net (3900,3900) 1 14 0 "Charge"»
  «net (3900,2600) 1 13 0 "GND"»
  «net (3900,3000) 1 14 0 "Capacitance"»
  «net (7100,1500) 1 13 0 "GND"»
  «wire (5100,2000) (5100,2100) "Vmeas"»
  «wire (5100,1500) (5100,1600) "GND"»
  «wire (7100,2000) (7100,2100) "Vmeas"»
  «wire (7100,1500) (7100,1600) "GND"»
  «wire (5100,2100) (7100,2100) "Vmeas"»
  «rect (300,1200) (6300,4900) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (500,2400) 1 7 0 0x1000000 -1 -1 "ï»¿.param Tstart=0.1\n.param Tstop=1.1\n.tran 0 Tstop Tstart (Tstop-Tstart)/1e5\n.func Capacitance()=V(Capacitance)/1V\n.func Charge()=V(Charge)/1V\n.func Vbias()=V(Vmeas)\n.plot Charge\n.plot Capacitance\n.abscissa Vbias"»
  «text (500,3700) 1 7 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param Vbias_min=-20\n.param Vbias_max=100"»
  «text (500,4450) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Capacitance and Charge from time domain\n - error free method in calculating Q for capacitance as a function of its voltage\n - Vmeas has to begin with 0V for correct initial condition of Q"»
  «text (4300,3800) 1 7 1 0x1000000 -1 -1 "ï»¿Q=I*t (integral form)"»
  «text (4450,2950) 1 7 1 0x1000000 -1 -1 "ï»¿By I=C dv/dt\n-> C = I / (dv/dt)"»
»

