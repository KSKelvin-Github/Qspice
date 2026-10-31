ÿØÿÛ«schematic
  «component (-3500,-7100) 0 0
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
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Vgrid"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "0"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-2000,-6600) 0 0
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
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Vp"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "0"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «component (-2700,-6800) 0 0
    «symbol Triode-subckt1
      «type: X»
      «description: Triode / Vacuum Tube (.subckt A|P G K)»
      «library file: |.subckt 6J6 P G K\nBp P K I= (0.02975503554m)*uramp(V(P,K)*ln(1.0+(-0.03870606743)+exp((2.609078816)+ (2.609078816)*((44.4681031)+(-320.4695508m)*V(G,K))*V(G,K)/sqrt((45.24212568)**2+ (V(P,K)-(7.633778567))**2)))/(2.609078816))**(1.325356539)\nCgp G P 1.8p\nCgk G K 2.4p\nCpk P K 0.9p\nRpk P K 1G\nd3 G K dx1\n.model dx1 d(is=1n rs=2K cjo=1pf N=1.5 tt=1n)\n.ends 6J6»
      «shorted pins: false»
      «line (-100,100) (100,100) 0 0 0x1000000 -1 -1»
      «line (100,0) (-200,0) 0 1 0x1000000 -1 -1»
      «line (100,-100) (100,-150) 0 0 0x1000000 -1 -1»
      «line (-100,-100) (-100,-200) 0 0 0x1000000 -1 -1»
      «line (0,100) (0,200) 0 0 0x1000000 -1 -1»
      «rect (-100,-95) (100,-105) 0 0 0 0x1000000 0x1000000 -1 0 -1»
      «ellipse (-200,200) (200,-200) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (200,200) 1 7 0 0x0 -1 -1 "X1"»
      «text (200,-150) 1 7 0 0x0 -1 -1 "6J6"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "A|P"»
      «pin (-200,0) (0,0) 1 0 0 0x0 -1 "G"»
      «pin (-100,-200) (0,0) 1 0 0 0x0 -1 "K"»
    »
  »
  «component (-2500,-6300) 10 0
    «symbol IProbe-0Vsrc(large)
      «type: V»
      «description: Current Probe - with 0V voltage source by KSKelvin»
      «shorted pins: false»
      «line (150,130) (150,-150) 0 0 0x1000000 -1 -1»
      «ellipse (-40,40) (40,-40) 0 0 0 0x1000000 0xff0012 -1 -1»
      «arc3p (0,-100) (0,100) (0,0) 0 0 0x1000000 -1 -1»
      «triangle (150,-150) (100,-80) (200,-80) 0 0 0x1000000 0xff0012 -1 -1»
      «text (200,-10) 1 110 0 0x1000000 -1 -1 "Iplate"»
      «text (-40,-10) 0.63 109 2 0x1000000 -1 -1 "0"»
      «text (-135,-10) 0.681 109 3 0x1000000 -1 -1 "; hold shift to probe"»
      «pin (0,100) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-100) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (-2800,-7100) 1 13 0 "GND"»
  «net (-2000,-6800) 1 13 0 "GND"»
  «net (-3500,-7300) 1 13 0 "GND"»
  «net (-2100,-6300) 1 14 0 "plate"»
  «net (-3100,-6800) 1 14 0 "grid"»
  «wire (-2000,-6400) (-2000,-6300) "plate"»
  «wire (-2600,-6300) (-2700,-6300) "N01"»
  «wire (-3100,-6800) (-3500,-6800) "grid"»
  «wire (-3500,-6900) (-3500,-6800) "grid"»
  «wire (-2000,-6300) (-2100,-6300) "plate"»
  «wire (-2700,-6300) (-2700,-6600) "N01"»
  «wire (-2800,-7100) (-2800,-7000) "GND"»
  «wire (-2100,-6300) (-2400,-6300) "plate"»
  «wire (-2900,-6800) (-3100,-6800) "grid"»
  «text (-3600,-7900) 1 7 0 0x1000000 -1 -1 "ï»¿.dc Vgrid Vgrid_min Vgrid_max 1m\n+Vp Vplate_min Vplate_max Vplate_step\n.plot I(Iplate)\n.abscissa V(grid)"»
  «text (-3600,-5300) 1 7 0 0x1000000 -1 -1 "ï»¿.param Vgrid_min=-14\n.param Vgrid_max=0\n.param Vplate_min=50\n.param Vplate_max=300\n.param Vplate_step=50"»
  «text (-3650,-4250) 1 7 1 0x1000000 -1 -1 "ï»¿Device: Triode / Vacuum Tube\nMeasurement: Plate Current (Iplate) VS Grid Voltage (Vgrid)\n  - template : template.triode.Iplate-VS-Vgrid.qsch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

