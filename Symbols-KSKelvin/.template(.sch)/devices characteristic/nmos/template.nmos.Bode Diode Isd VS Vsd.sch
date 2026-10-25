ÿØÿÛ«schematic
  «component (-1500,1700) 0 0
    «symbol NMOS
      «type: MN»
      «description: N-Channel FET Transistor»
      «library file: NMOS.txt»
      «shorted pins: false»
      «line (100,200) (100,150) 0 0 0x1000000 -1 -1»
      «line (100,-150) (100,-200) 0 0 0x1000000 -1 -1»
      «line (-100,150) (-100,-150) 0 0 0x1000000 -1 -1»
      «line (-100,0) (-200,0) 0 0 0x1000000 -1 -1»
      «line (100,-150) (-50,-150) 0 0 0x1000000 -1 -1»
      «line (100,150) (-50,150) 0 0 0x1000000 -1 -1»
      «line (-50,150) (-50,-150) 0 0 0x1000000 -1 -1»
      «triangle (70,-150) (-25,-125) (-25,-175) 0 0 0x1000000 0x3000000 -1 -1»
      «text (200,200) 1 7 0 0x1000000 -1 -1 "M1"»
      «text (200,-200) 1 7 0 0x1000000 -1 -1 "IRFR210"»
      «pin (100,200) (0,0) 1 0 0 0x0 -1 "D"»
      «pin (-200,0) (0,0) 1 0 0 0x0 -1 "G"»
      «pin (100,-200) (0,0) 1 0 0 0x0 -1 "S"»
    »
  »
  «component (-400,1600) 12 0
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
      «text (130,-100) 1 75 0 0x1000000 -1 -1 "Vsd"»
      «text (130,100) 1 75 0 0x1000000 -1 -1 "0"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-400,2000) 0 0
    «symbol IProbe-0Vsrc(large)
      «type: V»
      «description: Current Probe - with 0V voltage source by KSKelvin»
      «shorted pins: false»
      «line (150,130) (150,-150) 0 0 0x1000000 -1 -1»
      «ellipse (-40,40) (40,-40) 0 0 0 0x1000000 0xff0012 -1 -1»
      «arc3p (0,-100) (0,100) (0,0) 0 0 0x1000000 -1 -1»
      «triangle (150,-150) (100,-80) (200,-80) 0 0 0x1000000 0xff0012 -1 -1»
      «text (200,30) 1 7 0 0x1000000 -1 -1 "Isd"»
      «text (250,-119) 0.63 7 2 0x1000000 -1 -1 "0"»
      «text (250,-210) 0.681 7 3 0x1000000 -1 -1 "; hold shift to probe"»
      «pin (0,100) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-100) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (-400,1300) 1 13 0 "GND"»
  «net (-1400,1300) 1 13 0 "GND"»
  «net (-1800,1700) 1 11 0 "GND"»
  «wire (-1400,1900) (-1400,2200) "N01"»
  «wire (-1400,1300) (-1400,1500) "GND"»
  «wire (-1400,2200) (-400,2200) "N01"»
  «wire (-400,1400) (-400,1300) "GND"»
  «wire (-400,1900) (-400,1800) "N02"»
  «wire (-400,2200) (-400,2100) "N01"»
  «wire (-1800,1700) (-1700,1700) "GND"»
  «text (-1950,750) 1 7 0 0x1000000 -1 -1 "ï»¿.dc Vsd 0 Vsd_max Vsd_max/100\n.plot I(Isd)\n.abscissa Vsd"»
  «text (-1890,2650) 1 7 0 0x1000000 -1 -1 "ï»¿; user input parameters\n.param Vsd_max=1"»
  «text (-1900,3250) 1 7 1 0x1000000 -1 -1 "ï»¿Test Circuit for Body Diode\n  - template : template.nmos.Bode Diode Isd VS Vsd.sch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

