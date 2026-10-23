ÿØÿÛ«schematic
  «component (500,-100) 0 0
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
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "AC 1"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (3000,-400) 0 0
    «symbol C
      «type: C»
      «description: Capacitor»
      «shorted pins: false»
      «line (0,200) (0,40) 0 0 0x1000000 -1 -1»
      «line (0,-40) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-130,-40) (130,-30) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-130,30) (130,40) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "C1"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "220µ"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (3000,-900) 0 0
    «symbol R
      «type: R»
      «description: Resistor(USA Style Symbol)»
      «shorted pins: false»
      «line (0,200) (0,180) 0 0 0x1000000 -1 -1»
      «line (0,-180) (0,-200) 0 0 0x1000000 -1 -1»
      «zigzag (-80,180) (80,-180) 0 0 0 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "R1"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "25m"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (3800,-400) 0 0
    «symbol C
      «type: C»
      «description: Capacitor»
      «shorted pins: false»
      «line (0,200) (0,40) 0 0 0x1000000 -1 -1»
      «line (0,-40) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-130,-40) (130,-30) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-130,30) (130,40) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "C2"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "40µ"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (3800,-900) 0 0
    «symbol R
      «type: R»
      «description: Resistor(USA Style Symbol)»
      «shorted pins: false»
      «line (0,200) (0,180) 0 0 0x1000000 -1 -1»
      «line (0,-180) (0,-200) 0 0 0x1000000 -1 -1»
      «zigzag (-80,180) (80,-180) 0 0 0 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "R2"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "10m"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (500,-300) 1 13 0 "GND"»
  «net (800,200) 1 14 0 "Vmeas"»
  «net (3400,-1500) 1 13 0 "GND"»
  «junction (3400,0)»
  «junction (3400,-1300)»
  «wire (500,100) (500,200) "Vmeas"»
  «wire (3000,-700) (3000,-600) "N01"»
  «wire (3800,-700) (3800,-600) "N02"»
  «wire (500,200) (800,200) "Vmeas"»
  «wire (3000,-200) (3000,0) "Vmeas"»
  «wire (3000,-1300) (3000,-1100) "GND"»
  «wire (3400,0) (3800,0) "Vmeas"»
  «wire (3800,-1100) (3800,-1300) "GND"»
  «wire (3800,0) (3800,-200) "Vmeas"»
  «wire (3400,-1300) (3000,-1300) "GND"»
  «wire (800,200) (3400,200) "Vmeas"»
  «wire (3400,200) (3400,0) "Vmeas"»
  «wire (3000,0) (3400,0) "Vmeas"»
  «wire (3400,-1300) (3400,-1500) "GND"»
  «wire (3800,-1300) (3400,-1300) "GND"»
  «rect (-600,3750) (2650,-600) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (-400,2173) 1 5 0 0x1000000 -1 -1 "ï»¿; calculate Cs-Rs model parameters\n.ac dec PtsPerDecade minFreq maxFreq \n.func Z() V(Vmeas)/-I(Vmeas) \n.func Rs() re(Z())\n.func Cs() -1/im(Z())/2/PI/freq\n.plot LIN Rs ; series resistance\n.plot LIN Cs ; series capacitance\n.abscissa Freq"»
  «text (-400,3140) 1 5 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param minFreq=100\n.param maxFreq=100Meg\n.param PtsPerDecade=100"»
  «text (-400,3450) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Cs-Rs model parameters\nin freqeuncy sweep test"»
»

