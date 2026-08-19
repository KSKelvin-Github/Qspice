ÿØÿÛ«schematic
  «text (-1100,-2800) 1 7 0 0x1000000 -1 -1 "ï»¿.func response()=V(<netname>) ; <netname> to measure\n.meas Vmax max mag(response())\n.meas fo FIND frequency WHEN mag(response())=Vmax \n.meas fL FIND frequency WHEN mag(response())=Vmax/sqrt(2) rise=1\n.meas fH FIND frequency WHEN mag(response())=Vmax/sqrt(2) fall=last\n.meas BW fH-fL \n.meas Q fo/BW"»
»

