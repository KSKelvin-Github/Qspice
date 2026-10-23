ÿØÿÛ«schematic
  «component (1400,1200) 0 0
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
  «component (2900,900) 0 0
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
  «component (2900,400) 0 0
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
  «component (3700,900) 0 0
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
  «component (3700,400) 0 0
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
  «net (1400,1000) 1 13 0 "GND"»
  «net (1700,1500) 1 14 0 "Vmeas"»
  «net (3300,-200) 1 13 0 "GND"»
  «junction (3300,1300)»
  «junction (3300,0)»
  «wire (1400,1400) (1400,1500) "Vmeas"»
  «wire (2900,600) (2900,700) "N01"»
  «wire (3700,600) (3700,700) "N02"»
  «wire (1400,1500) (1700,1500) "Vmeas"»
  «wire (2900,1100) (2900,1300) "Vmeas"»
  «wire (2900,0) (2900,200) "GND"»
  «wire (3300,1300) (3700,1300) "Vmeas"»
  «wire (3700,200) (3700,0) "GND"»
  «wire (3700,1300) (3700,1100) "Vmeas"»
  «wire (3300,0) (2900,0) "GND"»
  «wire (1700,1500) (3300,1500) "Vmeas"»
  «wire (3300,1500) (3300,1300) "Vmeas"»
  «wire (2900,1300) (3300,1300) "Vmeas"»
  «wire (3300,0) (3300,-200) "GND"»
  «wire (3700,0) (3300,0) "GND"»
  «rect (-1900,4200) (2500,600) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (-1750,2223) 1 5 0 0x1000000 -1 -1 "ï»¿; calculate Cs-Rs model parameters\n.ac dec PtsPerDecade minFreq maxFreq \n.func Z() V(Vmeas)/-I(Vmeas) \n.func Rs() re(Z())\n.func Cs() -1/im(Z())/2/PI/freq\n.plot LIN Rs ; series resistance\n.plot LIN Cs ; series capacitance\n.abscissa Freq"»
  «text (-1750,3140) 1 5 0 0x1000000 -1 -1 "ï»¿;user input parameters\n.param minFreq=100\n.param maxFreq=100Meg\n.param PtsPerDecade=100"»
  «text (-1700,3700) 1 7 1 0x1000000 -1 -1 "ï»¿Calculate Cs-Rs model parameters\nin freqeuncy sweep test\n  - template : template.C.FreqSweep.Cs-Rs (.ac).sch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

