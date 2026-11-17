ÿØÿÛ«schematic
  «text (-800,100) 1 7 0 0x1000000 -1 -1 "ï»¿// user input parameters (PID-controller)\n.param KP=8m\n.param KI=2.51327\n.param KD=6.3662Âµ\n.param fp1=5K\n.param fp2=5K\n\n// calculated Type-III parameters\n.param fp0=2*PI*KD*fp1*fp2\n.param fz1=(KP-sqrt(KP^2-4*KI*KD))/4/PI/KD\n.param fz2=(KP+sqrt(KP^2-4*KI*KD))/4/PI/KD"»
  «text (-800,-1250) 1 7 0 0x1000000 -1 -1 "ï»¿.option listparam"»
»

