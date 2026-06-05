ÿØÿÛ«schematic
  «component (-600,500) 0 0
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
      «text (180,150) 1 7 0 0x1000000 -1 -1 "V1"»
      «text (180,-150) 1 7 0 0x1000000 -1 -1 "DC VR"»
      «text (200,-350) 1 7 0 0x1000000 -1 -1 "AC 1"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (300,500) 0 0
    «symbol D
      «type: D»
      «description: Silicon Diode»
      «library file: Diode.txt»
      «shorted pins: false»
      «line (100,80) (-100,80) 0 0 0x1000000 -1 -1»
      «line (0,200) (0,80) 0 0 0x1000000 -1 -1»
      «line (0,-200) (0,-70) 0 0 0x1000000 -1 -1»
      «triangle (0,80) (100,-70) (-100,-70) 0 0 0x1000000 0x2000000 -1 -1»
      «text (150,150) 1 7 0 0x1000000 -1 -1 "D1"»
      «text (150,-150) 1 7 0 0x1000000 -1 -1 "RF1001NS2D"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "A"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "K"»
    »
  »
  «net (300,-100) 1 13 0 "GND"»
  «net (0,900) 1 14 0 "R"»
  «junction (300,0)»
  «wire (300,700) (300,900) "R"»
  «wire (300,0) (300,300) "GND"»
  «wire (-600,300) (-600,0) "GND"»
  «wire (-600,900) (-600,700) "R"»
  «wire (0,900) (-600,900) "R"»
  «wire (300,0) (-600,0) "GND"»
  «wire (300,-100) (300,0) "GND"»
  «wire (300,900) (0,900) "R"»
  «text (-750,1200) 1 7 1 0x1000000 -1 -1 "ï»¿Capacitance Ct vs Reverse Voltage VR"»
  «text (-750,-500) 1 7 0 0x1000000 -1 -1 "ï»¿.param f=1Meg\n.ac list f\n.step param VR 0 30 0.2"»
  «text (-750,-1200) 1 7 0 0x1000000 -1 -1 "ï»¿.func imZ() imag(V(R)/-I(V1))\n.func Ct_pF() -1/2/pi/f/imZ()/1p\n.plot Ct_pF()"»
»

