ÿØÿÛ«schematic
  «component (-100,0) 0 0
    «symbol GND-Float
      «type: R»
      «description: Floating Ground (1Gohms Resistor to GND) - User requires to assign same node name»
      «shorted pins: false»
      «rect (71,-50) (69,-140) 0 0 0 0x1000000 0x1000000 -1 0 -1»
      «rect (70,-96) (116,-94) 0 0 0 0x1000000 0x1000000 -1 0 -1»
      «rect (70,-51) (116,-49) 0 0 0 0x1000000 0x1000000 -1 0 -1»
      «triangle (-80,0) (80,0) (0,-80) 0 0 0x1000000 0x1000000 -1 -1»
      «text (100,200) 1 7 2 0x1000000 -1 -1 "FGND1"»
      «text (100,50) 1 7 2 0x1000000 -1 -1 "1G"»
      «pin (0,0) (0,0) 1 0 0 0x0 -1 "1"»
      «pin (0,-100) (0,0) 1 0 0 0x0 -1 "2" "0"»
    »
  »
  «net (-100,100) 1 7 0 "Gnd-Float"»
  «wire (-100,100) (-100,200) "Gnd-Float"»
  «wire (-100,0) (-100,100) "Gnd-Float"»
»

