ÿØÿÛ«schematic
  «component (-2000,2000) 0 0
    «symbol NMOS
      «type: MN»
      «description: N-Channel MOSFET Transistor»
      «library file: |.model Si7336ADP VDMOS(Rg=3.5 Rd=1.2m Rs=800µ mtriode=1.9 lambda=0.01 Vto=2.9 Ksubthres=100m Kp=280 Cgdmax=1.6n Cgdmin=200p A=1.5 Cgs=5.2n Cjo=3n M=.5 Is=5p Rb=3m mfg=Siliconix Vds=30 Ron=2.4m Qg=36n)»
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
      «text (200,-200) 1 7 0 0x1000000 -1 -1 "Si7336ADP"»
      «pin (100,200) (0,0) 1 0 0 0x0 -1 "D"»
      «pin (-200,0) (0,0) 1 0 0 0x0 -1 "G"»
      «pin (100,-200) (0,0) 1 0 0 0x0 -1 "S"»
    »
  »
  «component (-2500,1700) 0 0
    «symbol I
      «type: I»
      «description: Current Source»
      «shorted pins: false»
      «line (0,200) (0,150) 0 0 0x1000000 -1 -1»
      «line (0,-150) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-25,102) (25,98) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,75) (2,125) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,-98) (25,-102) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «ellipse (-100,-150) (100,50) 0 0 0 0x1000000 0x1000000 -1 -1»
      «ellipse (-100,-50) (100,150) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,150) 1 7 0 0x1000000 -1 -1 "Ig"»
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "Qg_max/tscale"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
    »
  »
  «component (-1100,2600) 2 0
    «symbol I
      «type: I»
      «description: Current Source»
      «shorted pins: false»
      «line (0,200) (0,150) 0 0 0x1000000 -1 -1»
      «line (0,-150) (0,-200) 0 0 0x1000000 -1 -1»
      «rect (-25,102) (25,98) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,75) (2,125) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,-98) (25,-102) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «ellipse (-100,-150) (100,50) 0 0 0 0x1000000 0x1000000 -1 -1»
      «ellipse (-100,-50) (100,150) 0 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,0) 1 110 0 0x1000000 -1 -1 "I2"»
      «text (-100,0) 1 109 0 0x1000000 -1 -1 "Id"»
      «text (-250,0) 1 109 0 0x1000000 -1 -1 "Vsat=1m"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
    »
  »
  «component (-400,2000) 0 0
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
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "Vds"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «net (-2500,1500) 1 13 0 "GND"»
  «net (-1900,1700) 1 13 0 "GND"»
  «net (-400,1700) 1 13 0 "GND"»
  «net (-2400,2000) 1 14 0 "Vg"»
  «wire (-1900,2200) (-1900,2600) "N01"»
  «wire (-1900,1700) (-1900,1800) "GND"»
  «wire (-400,2200) (-400,2600) "N02"»
  «wire (-400,1700) (-400,1800) "GND"»
  «wire (-400,2600) (-900,2600) "N02"»
  «wire (-2400,2000) (-2500,2000) "Vg"»
  «wire (-2500,2000) (-2500,1900) "Vg"»
  «wire (-2200,2000) (-2400,2000) "Vg"»
  «wire (-1900,2600) (-1300,2600) "N01"»
  «text (-2600,800) 1 7 0 0x1000000 -1 -1 "ï»¿.tran 1*tscale\n.ic V(Vg)=0\n.func Qg() I(Ig)*time  ; by Q=I*t\n.plot V(Vg)\n.abscissa Qg"»
  «text (-2640,3440) 1 7 0 0x1000000 -1 -1 "ï»¿.param Vds=15  ;gate charge Vds test voltage\n.param Id=1  ;gate charge Id test current\n.param Qg_max=45n  ;maximum total gate charge in x-axis\n.param tscale=1  ;default set to 1s"»
  «text (-2650,4250) 1 7 1 0x1000000 -1 -1 "ï»¿Test Circuit for Gate Charge Vg VS Qg\n  - template : template.nmos.GateCharge Vg VS Qg.sch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
»

