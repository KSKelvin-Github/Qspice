ÿØÿÛ«schematic
  «text (-800,100) 1 7 0 0x1000000 -1 -1 "ï»¿// user input parameters (Type III)\n.param fp0=1K\n.param fz1=100\n.param fz2=100 \n.param fp1=5K\n.param fp2=5K\n\n// calculated PID parameters\n//    - no high frequency pole attenuation\n.param KP=(fz1+fz2)*fp0/fp1/fp2\n.param KI=2*PI*fz1*fz2*fp0/fp1/fp2\n.param KD=1/2/PI*fp0/fp1/fp2"»
  «text (-800,-1250) 1 7 0 0x1000000 -1 -1 "ï»¿.option listparam"»
»

