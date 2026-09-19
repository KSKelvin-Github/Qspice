ÿØÿÛ«schematic
  «text (-600,450) 1 7 0 0x1000000 -1 -1 "ï»¿#include <math.h>"»
  «text (-600,0) 1 7 0 0x1000000 -1 -1 "ï»¿// CLK is clock frequency, y outputs Sawtooth (0-1V)\ndouble const y = fmod(t,1/CLK)*CLK;"»
  «text (-600,-600) 1 7 0 0x1000000 -1 -1 "ï»¿// CLK is clock frequency, y outputs Trianglar wave (0-1V)\ndouble const wave = fabs(remainder(t,1/CLK))*2*CLK;"»
  «text (-600,-1200) 1 7 0 0x1000000 -1 -1 "ï»¿// CLK is clock frequency, y outputs Trianglar wave (-1 to +1V)\ndouble const wave = (fabs(remainder(t,1/CLK))*4*CLK-1;"»
»

