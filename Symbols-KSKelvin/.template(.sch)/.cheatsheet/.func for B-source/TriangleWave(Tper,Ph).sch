ÿØÿÛ«schematic
  «text (-550,250) 1 7 0 0x1000000 -1 -1 "ï»¿.func TriangleWave(Tper,Ph)=2.0*fabs((time+(1-wrap1(Ph))*Tper)/Tper-round((time+(1-wrap1(Ph))*Tper)/Tper)) ;Period:Tper(s), Phase:Ph(degree)\n.func wrap1(Ph)=mod(Ph,360)/360\n.func mod(x,y)=x-y*trunc(x/y)"»
»

