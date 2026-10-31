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
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "Vgrid"»
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
      «text (100,-150) 1 7 0 0x1000000 -1 -1 "PWL 0 Vp 1 Vp+1"»
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
  «net (-2800,-7100) 1 13 0 "GND"»
  «net (-2000,-6800) 1 13 0 "GND"»
  «net (-3500,-7300) 1 13 0 "GND"»
  «net (-2100,-6300) 1 14 0 "plate"»
  «wire (-2000,-6400) (-2000,-6300) "plate"»
  «wire (-2100,-6300) (-2700,-6300) "plate"»
  «wire (-2900,-6800) (-3500,-6800) "N01"»
  «wire (-3500,-6900) (-3500,-6800) "N01"»
  «wire (-2000,-6300) (-2100,-6300) "plate"»
  «wire (-2700,-6300) (-2700,-6600) "plate"»
  «wire (-2800,-7100) (-2800,-7000) "GND"»
  «text (-3750,-8400) 1 7 0 0x1000000 -1 -1 "ï»¿.tran 1\n.step param Vgrid Vgrid_min Vgrid_max 0.1\n+     param Vp Vplate_min Vplate_max Vplate_step\n.meas Iplate_avg avg -I(Vp)  ; calculate DC plate current\n.meas Iplate_pp pp -I(Vp)     ; calculate delta Iplate\n.meas Vplate_pp pp V(plate)  ; calculate delta Vplate\n.meas rp param Vplate_pp/Iplate_pp  ; calculate rp = dV/dI\n.meas plot min(rp,40K)  ; plot .meas result\n.meas plot abscissa min(Iplate_avg,14m)"»
  «text (-2100,-7100) 1 7 1 0x1000000 -1 -1 "ï»¿PWL provide dVp in time domain at Vp\ndV=1V, dt=1s"»
  «text (-3650,-4500) 1 7 1 0x1000000 -1 -1 "ï»¿Device: Triode / Vacuum Tube\nMeasurement: Plate Resistance (rp) VS Plate Current (Iplate)\n  - template : template.triode.rp-VS-Iplate.qsch\n  - download : https://github.com/KSKelvin-Github/Qspice/"»
  «text (-3600,-5500) 1 7 0 0x1000000 -1 -1 "ï»¿.param Vgrid_min=-15\n.param Vgrid_max=0\n.param Vplate_min=50\n.param Vplate_max=300\n.param Vplate_step=50"»
»

