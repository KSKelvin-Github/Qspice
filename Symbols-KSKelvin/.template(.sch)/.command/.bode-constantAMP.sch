ÿØÿÛ«schematic
  «component (-900,1800) 0 0
    «symbol V-Source Bode-Perturbing
      «type: V»
      «description: Independent Voltage Source»
      «shorted pins: false»
      «line (0,200) (0,130) 0 0 0x1000000 -1 -1»
      «line (-75,-40) (-75,-20) 0 0 0x1000000 -1 -1»
      «line (-25,-40) (-25,35) 0 0 0x1000000 -1 -1»
      «line (-130,130) (130,130) 0 0 0x1000000 -1 -1»
      «line (-130,130) (-130,-100) 0 0 0x1000000 -1 -1»
      «line (130,130) (130,-100) 0 0 0x1000000 -1 -1»
      «line (25,-40) (25,35) 0 0 0x1000000 -1 -1»
      «line (75,-40) (75,-20) 0 0 0x1000000 -1 -1»
      «rect (-25,-103) (25,-107) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-2,-130) (2,-80) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «rect (-25,97) (25,93) 0 0 0 0x1000000 0x3000000 -1 0 -1»
      «arc3p (-75,-20) (-115,-20) (-95,-20) 0 0 0x1000000 -1 -1»
      «arc3p (-75,-40) (-25,-40) (-50,-40) 0 0 0x1000000 -1 -1»
      «arc3p (25,35) (-25,35) (0,35) 0 0 0x1000000 -1 -1»
      «arc3p (130,-100) (0,-200) (130,-200) 0 0 0x1000000 -1 -1»
      «arc3p (0,-200) (-130,-100) (-130,-200) 0 0 0x1000000 -1 -1»
      «arc3p (25,-40) (75,-40) (50,-40) 0 0 0x1000000 -1 -1»
      «arc3p (115,-20) (75,-20) (95,-20) 0 0 0x1000000 -1 -1»
      «text (150,100) 1 7 0 0x1000000 -1 -1 "Vpert"»
      «text (150,-100) 1 7 0 0x1000000 -1 -1 "0"»
      «pin (0,-200) (0,0) 1 0 0 0x0 -1 "+"»
      «pin (0,200) (0,0) 1 0 0 0x0 -1 "-"»
    »
  »
  «text (-1100,250) 1 7 0 0x1000000 -1 -1 "ï»¿//Frequency Response Analysis (.bode)\n.param Tsettle=<seconds> ;Time required for the circuit to settle to steady state\n.param Fstart=<Hz> ;Lowest frequency to analyze\n.param Fstop=<Hz> ;Highest frequency to analyze\n.param Amp=<V> ;Minimum amplitude of perturbing source\n\n.bode Vpert Tsettle Fstart Fstop Amp debug=0\n.option BodeAmpFreq=0\n.option BodeInput=<netname>\n.option BodeOutput=<netname>"»
»

