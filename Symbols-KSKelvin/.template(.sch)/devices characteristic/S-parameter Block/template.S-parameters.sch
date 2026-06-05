ÿØÿÛ«schematic
  «component (-400,-100) 8 0
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
      «text (180,-50) 1 7 0 0x1000000 -1 -1 "AC 1"»
      «text (180,-200) 1 7 0 0x1000000 -1 -1 "Rser=Zo"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (1600,-100) 0 0
    «symbol R
      «type: R»
      «description: Resistor(USA Style Symbol)»
      «shorted pins: false»
      «line (0,200) (0,180) 0 0 0x1000000 -1 -1»
      «line (0,-180) (0,-200) 0 0 0x1000000 -1 -1»
      «zigzag (-80,180) (80,-180) 0 0 0 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "R1"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "Zo"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (-400,-400) 1 13 0 "GND"»
  «net (600,-400) 1 13 0 "GND"»
  «net (1600,-400) 1 13 0 "GND"»
  «net (-400,300) 1 14 0 "Port1"»
  «net (1600,300) 1 14 0 "Port2"»
  «wire (1600,100) (1600,300) "Port2"»
  «wire (1600,-400) (1600,-300) "GND"»
  «wire (1600,300) (1100,300) "Port2"»
  «wire (-400,-300) (-400,-400) "GND"»
  «wire (-400,300) (-400,100) "Port1"»
  «wire (600,-100) (600,-400) "GND"»
  «wire (100,300) (-400,300) "Port1"»
  «rect (-50,850) (1250,-250) 0 0 2 0x4000000 0x1000000 -1 0 -1»
  «text (-500,-850) 1 7 0 0x1000000 -1 -1 "ï»¿.net R1 V1\n.ac dec Points fstart fstop"»
  «text (-500,-1350) 1 7 0 0x1000000 -1 -1 "ï»¿.plot S11(V1)\n.plot S21(V1)"»
  «text (-480,1650) 1 7 0 0x1000000 -1 -1 "ï»¿.param fstart=1Meg\n.param fstop=500Meg\n.param Points=100\n.param Zo=50"»
  «text (-1000,2200) 1 7 1 0x1000000 -1 -1 "ï»¿S-parameter block test template (Zo=50)"»
»

