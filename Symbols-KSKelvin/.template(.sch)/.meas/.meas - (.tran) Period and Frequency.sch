ÿØÿÛ«schematic
  «text (-800,800) 1 7 0 0x1000000 -1 -1 "ï»¿.param thre=0              ;rising edge trigger level for Tperiod measurement\n.param startcount=50    ;skip first N rising edges (allow oscillator to settle)\n.meas Tperiod trig V(x)=thre rise=startcount targ V(x)=thre rise=startcount+1\n.meas FRQ param 1/Tperiod  ;Frequency (Hz)"»
»

