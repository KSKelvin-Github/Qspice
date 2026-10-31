ÿØÿÛ«schematic
  «component (-1000,2000) 0 0
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
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Vds"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "0"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-2900,1700) 0 0
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
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Vgs"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "0"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-1000,2400) 12 0
    «symbol IProbe-0Vsrc(large)
      «type: V»
      «description: Current Probe - with 0V voltage source by KSKelvin»
      «shorted pins: false»
      «line (150,130) (150,-150) 0 0 0x1000000 -1 -1»
      «ellipse (-40,40) (40,-40) 0 0 0 0x1000000 0xff0012 -1 -1»
      «arc3p (0,-100) (0,100) (0,0) 0 0 0x1000000 -1 -1»
      «triangle (150,-150) (100,-80) (200,-80) 0 0 0x1000000 0xff0012 -1 -1»
      «text (250,-100) 1 75 0 0x1000000 -1 -1 "Idrain"»
      «text (250,99) 0.63 75 2 0x1000000 -1 -1 "0"»
      «text (250,190) 0.681 75 3 0x1000000 -1 -1 "; hold shift to probe"»
      «pin (0,100) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-100) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-2100,2000) 0 0
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
  «net (-1000,1700) 1 13 0 "GND"»
  «net (-2900,1400) 1 13 0 "GND"»
  «net (-2000,1700) 1 13 0 "GND"»
  «wire (-2900,1900) (-2900,2000) "N01"»
  «wire (-2900,1400) (-2900,1500) "GND"»
  «wire (-2900,2000) (-2300,2000) "N01"»
  «wire (-2000,2200) (-2000,2700) "N02"»
  «wire (-2000,1700) (-2000,1800) "GND"»
  «wire (-2000,2700) (-1000,2700) "N02"»
  «wire (-1000,1800) (-1000,1700) "GND"»
  «wire (-1000,2300) (-1000,2200) "N03"»
  «wire (-1000,2700) (-1000,2500) "N02"»
  «text (-3050,850) 1 7 0 0x1000000 -1 -1 "ï»¿.dc Vds 0 Vds_max Vds_max/100 Vgs Vgs_min Vgs_max 1\n.plot I(Idrain)\n.abscissa Vds"»
  «text (-3060,3280) 1 7 0 0x1000000 -1 -1 "ï»¿; user input\n.param Vds_max=30\n.param Vgs_min=4\n.param Vgs_max=7"»
  «text (-3050,4100) 1 7 1 0x1000000 -1 -1 "ï»¿Device: NMOS\nMeasurement: Output Characteristic - Idrain VS Vds\n  - template : template.nmos.Output Characteristic Id VS Vds.sch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

