ÿØÿÛ«schematic
  «text (-750,550) 1 7 0 0x1000000 -1 -1 "ï»¿struct sDLL\n{\n  // declare the structure here\n  bool init;\n  double nextSampleTime;\n};\n\n\n   // Initialization\n   if(!inst->init){\n      inst->nextSampleTime = 1/fsw;\n      inst->init = true;\n   }\n\n   // Sample control signals at switching frequency\n   if(t >= inst->nextSampleTime){\n      // Latch control signals at sampling instant (zero-order hold)\n      inst->nextSampleTime = inst->nextSampleTime+1/fsw;\n   }"»
»

