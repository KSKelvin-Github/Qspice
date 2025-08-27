// Automatically generated C++ file on Sun May 25 00:52:34 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD franalyzerksk.cpp kernel32.lib

#include <malloc.h>
#include <math.h>
#include <stdio.h>
#include <cstring>
#include <string>

extern "C" __declspec(dllexport) int (*Display)(const char *format, ...) = 0; // works like printf()
extern "C" __declspec(dllexport) const double *DegreesC                  = 0; // pointer to current circuit temperature
extern "C" __declspec(dllexport) const int *StepNumber                   = 0; // pointer to current step number
extern "C" __declspec(dllexport) const int *NumberSteps                  = 0; // pointer to estimated number of steps
extern "C" __declspec(dllexport) const char* const *InstanceName         = 0; // pointer to address of instance name
extern "C" __declspec(dllexport) const char *QUX                         = 0; // path to QUX.exe
extern "C" __declspec(dllexport) const bool *ForKeeps                    = 0; // pointer to whether being evaluated non-hypothetically
extern "C" __declspec(dllexport) const bool *HoldICs                     = 0; // pointer to whether instance initial conditions are being held
extern "C" __declspec(dllexport) int (*DFFT)(struct sComplex *u, bool inv, unsigned int N, double scale) = 0; // discrete Fast Fourier function

union uData
{
   bool b;
   char c;
   unsigned char uc;
   short s;
   unsigned short us;
   int i;
   unsigned int ui;
   float f;
   double d;
   long long int i64;
   unsigned long long int ui64;
   char *str;
   unsigned char *bytes;
};

// int DllMain() must exist and return 1 for a process to load the .DLL
// See https://docs.microsoft.com/en-us/windows/win32/dlls/dllmain for more information.
int __stdcall DllMain(void *module, unsigned int reason, void *reserved) { return 1; }

void bzero(void *ptr, unsigned int count)
{
   unsigned char *first = (unsigned char *) ptr;
   unsigned char *last  = first + count;
   while(first < last)
      *first++ = '\0';
}

// #undef pin names lest they collide with names in any header file(s) you might include.
#undef PertSrc
#undef CH1
#undef CH2
#undef SrcFrq
#undef SrcLvl
#undef Gain
#undef Ph
#undef CH1mag
#undef CH2mag
#undef Real
#undef Imag
#undef debug1
#undef debug2

struct sFRANALYZERKSK
{
  // declare the structure here

  // Frequency and timing related variables
  double mixerfreq;  // Current frequency of the reference signal (Hz)
  double lastT;      // Previous time value (seconds) for delta time calculation
  double lastRsin;   // Previous value of reference sine wave for zero-crossing detection
  double lastI1;     // Previous value of I1
  double lastQ1;     // Previous value of Q1
  double lastI2;     // Previous value of I2
  double lastQ2;     // Previous value of Q2

  // Phase tracking
  double lastPh;     // Previous phase measurement for phase unwrapping

  // Signal processing accumulators
  double cumsumf;    // Cumulative phase sum for frequency generation (radians)
  double cumsumI1;   // Accumulated in-phase component for Channel 1
  double cumsumQ1;   // Accumulated quadrature component for Channel 1
  double cumsumI2;   // Accumulated in-phase component for Channel 2
  double cumsumQ2;   // Accumulated quadrature component for Channel 2

  // Measurement counters
  double NumMeasCount;  // Counter for number of frequency points measured
  double NumRefCycles;  // Counter for number of reference signal cycles completed at one frequency test point

  // Bode Plot
  const char *fname;    // filename with .csv extension

  // Completion flag
  bool init;         // Flag indicating whether initialization is complete
  bool complete;     // Flag indicating whether FRA process is complete
  bool plotbode;     // Flag indicating whether plot bode from .csv

};

extern "C" __declspec(dllexport) void franalyzerksk(struct sFRANALYZERKSK **opaque, double t, union uData *data)
{
   double       CH1          = data[ 0].d  ; // input
   double       CH2          = data[ 1].d  ; // input
   double       Tstart       = data[ 2].d  ; // input parameter
   double       fstart       = data[ 3].d  ; // input parameter
   double       fstop        = data[ 4].d  ; // input parameter
   double       fstep        = data[ 5].d  ; // input parameter
   bool         logsweep     = data[ 6].b  ; // input parameter
   double       lvlstart     = data[ 7].d  ; // input parameter
   double       lvlmid       = data[ 8].d  ; // input parameter
   double       lvlmidfreq   = data[ 9].d  ; // input parameter
   double       lvlstop      = data[10].d  ; // input parameter
   double       lvlDCoffset  = data[11].d  ; // input parameter
   double       precycles    = data[12].d  ; // input parameter
   double       meascycles   = data[13].d  ; // input parameter
   bool         autocycles   = data[14].b  ; // input parameter
   bool         quickLowFreq = data[15].b  ; // input parameter
   double       LowFreq      = data[16].d  ; // input parameter
   double       LFstep       = data[17].d  ; // input parameter
   bool         plotbode     = data[18].b  ; // input parameter
   const char * fname        = data[19].str; // input parameter
   double      &PertSrc      = data[20].d  ; // output
   double      &SrcFrq       = data[21].d  ; // output
   double      &SrcLvl       = data[22].d  ; // output
   double      &Gain         = data[23].d  ; // output
   double      &Ph           = data[24].d  ; // output
   double      &CH1mag       = data[25].d  ; // output
   double      &CH2mag       = data[26].d  ; // output
   double      &Real         = data[27].d  ; // output
   double      &Imag         = data[28].d  ; // output
   double      &debug1       = data[29].d  ; // output
   double      &debug2       = data[30].d  ; // output

   if(!*opaque)
   {
      *opaque = (struct sFRANALYZERKSK *) malloc(sizeof(struct sFRANALYZERKSK));
      bzero(*opaque, sizeof(struct sFRANALYZERKSK));
   }
   struct sFRANALYZERKSK *inst = *opaque;

// Implement module evaluation code here:

   // Initilization (execute before each .step)
   if(!inst->init){
      inst->fname = fname;       // inst for fname
      inst->plotbode = plotbode; // inst for plotbode
      inst->init = true;         // initilization already done! (this reset in each .step)

      // print FRA setup information (only execute at first .step)
      if (*StepNumber==1){
         Display("Frequency Response Analyer by KSKelvin - Setup Information\n");
         if (logsweep) Display("  Frequency: %.0fHz to %.0fHz (log sweep, %.0f steps per decade)\n",fstart,fstop,fstep);
         else Display("  Frequency: %.0fHz to %.0fHz (linear sweep, total %.0f steps)\n",fstart,fstop,fstep);
         Display("  Amplitude: %.2fV@fstart to %.2fV@%.0fHz to %.2fV@fstop\n",lvlstart,lvlmid,lvlmidfreq,lvlstop);
         Display("  Measurement: %.0f pre-cycles (stabilization) + %.0f averaged cycles per frequency\n",precycles,meascycles);
         if (autocycles) Display("  Option [Auto ]: Adjust averaging cycles according to gain\n");
         if (quickLowFreq) Display("  Option [Limit]: Limit test steps when frequency < %.0fHz\n",LowFreq);
         if (plotbode) Display("  Option [Plot ]: Auto-generate Bode plot post-simulation\n");
         Display("\n");
      }
   }

   // Constants
   double PI = 3.14159265359;    // Mathematical constant pi
   double dT = t - inst->lastT;  // Time step since last calculation

   // Initialize mixer frequency and amplitude (0 before Tstart)
   double mixerfreq = 0;   // Frequency of reference signal (0Hz during Tstart)
   double lvl=0;           // Amplitude of perturbation signal (0V during Tstart)

   // Frequency sweep begins after settling time (Tstart) [RFA processing]
   if (t >= Tstart){
      if (logsweep){
         // Logarithmic frequency sweep generation
         double decade_start = log10(fstart);   // Convert start freq to logarithmic scale
         double decade_stop = log10(fstop);     // Convert stop freq to logarithmic scale
         double step_size = 1/fstep;            // Step size in decades
         double N = (decade_stop - decade_start) / step_size + 1; // Total steps needed
         // Generate next frequency in logarithmic sequence if within range
         if (inst->NumMeasCount < N) mixerfreq = pow(10,decade_start+inst->NumMeasCount*step_size);
      }else{
         // Alternative linear frequency sweep
         if (inst->NumMeasCount <= fstep) mixerfreq = fstart + inst->NumMeasCount * (fstop - fstart)/fstep;
      }
      // ** mixerfreq keeps at 0Hz when NumMeasCount > total step number

      // Amplitude adjustment based on frequency (piecewise linear interpolation)
      if(mixerfreq<=lvlmidfreq){
         // Ramp amplitude from lvlstart to lvlmid for lower frequencies
         lvl = (lvlmid-lvlstart)/(lvlmidfreq-fstart)*(mixerfreq-fstart)+lvlstart;
      }else{
         // Ramp amplitude from lvlmid to lvlstop for higher frequencies
         lvl = (lvlmid-lvlstop)/(lvlmidfreq-fstop)*(mixerfreq-fstop)+lvlstop;
      }
   }

   // Check if frequency sweep is complete (NumMeasCount > 0 but mixerfreq = 0)
   // Return -1e308 in MaxExtStepSize() to terminate simulation
   if (inst->NumMeasCount != 0 & mixerfreq == 0){
      inst->complete = true;  // Flag to terminate simulation
   }

   // Generate reference signals using Time-Varying Frequency Sine Wave method
   inst->cumsumf = mixerfreq*dT + inst->cumsumf;   // Accumulate phase for smooth transitions (rectangle integration)
   if (inst->lastT < Tstart & t >= Tstart) inst->cumsumf=0; // reset cumsumf to force rsin at 0 degree at Tstart
   double rsin = sin(2*PI*inst->cumsumf);          // Reference sine wave
   double rcos = cos(2*PI*inst->cumsumf);          // Reference cosine wave (90° phase shifted)
   PertSrc = lvl*rsin+lvlDCoffset;  // Perturbation signal = reference sine (rsin) with amplitude equals lvl and with DC offset

   // Signal processing after settling time [RFA processing]
   if (t >= Tstart){
      // Mix input signals (CH1, CH2) with reference signals (I/Q demodulation)
      double I1 = CH1*rsin;   // In-phase component of CH1
      double Q1 = CH1*rcos;   // Quadrature component of CH1
      double I2 = CH2*rsin;   // In-phase component of CH2
      double Q2 = CH2*rcos;   // Quadrature component of CH2

      // cumulative sum of I1 and Q1 over time (trap vs rect integration)
      if (true){
         // Integrate I/Q components over time (cumulative sum) (trapezoidal integration)
         inst->cumsumI1 += (I1+inst->lastI1)/2.0*dT;
         inst->cumsumQ1 += (Q1+inst->lastQ1)/2.0*dT;
         inst->cumsumI2 += (I2+inst->lastI2)/2.0*dT;
         inst->cumsumQ2 += (Q2+inst->lastQ2)/2.0*dT;
         inst->lastI1 = I1;
         inst->lastQ1 = Q1;
         inst->lastI2 = I2;
         inst->lastQ2 = Q2;
      }
      else{
         // Integrate I/Q components over time (cumulative sum) (rectangle integration)
         inst->cumsumI1 += I1*dT;
         inst->cumsumQ1 += Q1*dT;
         inst->cumsumI2 += I2*dT;
         inst->cumsumQ2 += Q2*dT;
      }

   }

   // Auto-adjust measurement cycles based on signal gain to balance speed and accuracy
   // only execute if autocycles option is true
   if (autocycles){
      // auto adjust meascycles based on previous gain
      double automeascycles = meascycles;          // Default to baseline measurement cycles
      if (Gain > 3.2) automeascycles = 1;          // Gain : 3.2 (10dB) : fast measurement (less averaging needed)
      else if (Gain > 1.0) automeascycles = 2;     // Gain : 1.0 (0dB)
      else if (Gain > 0.32) automeascycles = 4;    // Gain : 0.32 (-10dB)
      else if (Gain > 0.1) automeascycles = 8;     // Gain : 0.1 (-20dB)
      else if (Gain > 0.0) automeascycles = 16;    // Extremely low gain : maximum averaging
      // auto adjust meascycles based on mixerfreq
      if (mixerfreq > 1e5) automeascycles = 32;       // freq > 100000Hz
      else if (mixerfreq > 1e4) automeascycles = 16;  // freq > 10000Hz
      else if (mixerfreq > 5e3) automeascycles = 8;   // freq > 5000Hz
      else if (mixerfreq > 1e3) automeascycles = 4;   // freq > 1000Hz
      else if (mixerfreq > 5e2) automeascycles = 2;   // freq > 500Hz

      // Ensure meascycles is never lower than user required
      if (automeascycles > meascycles){
         //precycles = ceil(automeascycles);
         meascycles = automeascycles;
      }
   }

   // Process measurements at zero-crossing points of reference sine wave (every reference signal cycle)
   if (rsin>=0 & inst->lastRsin<0){  // Detect negative-to-positive zero crossing at rsin

      inst->NumRefCycles++;   // Increment reference cycle count (this counter begin from 1)

      // precycles : not to accumlators results, only start storing measure data after precycles complete
      if (inst->NumRefCycles <= precycles){
         // Reset accumulators for discardcycles
         inst->cumsumI1=0;
         inst->cumsumQ1=0;
         inst->cumsumI2=0;
         inst->cumsumQ2=0;
      }

      // Perform measurement after accumulating enough cycles (meascycles)
      if (inst->NumRefCycles >= meascycles + precycles){

         // Calculate DC components (averaged over measurement cycles)
         double I1dc = mixerfreq / meascycles * inst->cumsumI1;    // 1/Tperiod/meascycles * int(I1)
         double Q1dc = mixerfreq / meascycles * inst->cumsumQ1;    // 1/Tperiod/meascycles * int(Q1)
         double I2dc = mixerfreq / meascycles * inst->cumsumI2;    // 1/Tperiod/meascycles * int(I2)
         double Q2dc = mixerfreq / meascycles * inst->cumsumQ2;    // 1/Tperiod/meascycles * int(Q2)

         // Calculate amplitude and phase from I/Q components
         double A1 = 2*hypot(I1dc,Q1dc);  // CH1 amplitude (factor of 2 for RMS-to-peak)
         double Ph1 = atan2(Q1dc,I1dc);   // CH1 phase (radians)
         double A2 = 2*hypot(I2dc,Q2dc);  // CH2 amplitude
         double Ph2 = atan2(Q2dc,I2dc);   // CH2 phase

         // Calculate output values
         SrcFrq = mixerfreq;  // Pert Src frequency point
         SrcLvl = lvl;        // Pert Src level
         Gain = A2/A1;        // Transfer function magnitude : |CH2/CH1|
         Ph = Ph2 - Ph1;      // Phase difference (radians) : <CH2-<CH1
         CH1mag = A1;         // CH1 amplitude (factor of 2 for RMS-to-peak)
         CH2mag = A2;         // CH2 amplitude (factor of 2 for RMS-to-peak)
         Real = Gain*cos(Ph); // Real part of CH2/CH1
         Imag = Gain*sin(Ph); // Imag part of CH2/CH1

         // Phase unwrapping (handle -pi to +pi transitions)
         if (inst->lastPh < 0 && Ph > 0){
            Ph = Ph - 2*PI;   // Add 2pi to maintain continuity
         }

         // Initialize output window and output files on first measurement
         if (inst->NumMeasCount ==0){
            // Display results : headerlines
            Display("No., Freq(Hz), Gain(dB), Phase(°),    |CH1|,    |CH2|,|CH2/CH1|,meascycles\n");
            // Save results into .csv - open a csv file into write format
            if (*StepNumber==1){    // with .step, only open a write file one time
               FILE *fptr = fopen(inst->fname,"w");
               if(*ForKeeps) fprintf(fptr,"\"Frequency\",\"TransferFunction\"\n");
               fclose(fptr);
            }
         }
         // Display results : Frequency, Gain(dB), Phase(°)
         Display("%3.0f, %8.0f, %8.2f, %8.2f, %8.3f, %8.3f, %8.3f, %9.0f\n",inst->NumMeasCount,mixerfreq,20*log10(Gain),Ph*180/PI,A1,A2,A2/A1,meascycles);
         // Save results into .csv - Qspice polar format : Frequency  Real,Imag
         FILE *fptr = fopen(inst->fname,"a");
         if(*ForKeeps) fprintf(fptr,"%.12f\t%.12f,%.12f\n",mixerfreq,Gain*cos(Ph),Gain*sin(Ph));
         fclose(fptr);

         // Reset accumulators for next frequency test point
         inst->cumsumI1=0;
         inst->cumsumQ1=0;
         inst->cumsumI2=0;
         inst->cumsumQ2=0;

         // Update meausrement counters for next measurement : include a skip meas module (only for log sweep)
         //   -- update NumMeasCount
         if(mixerfreq <= LowFreq & quickLowFreq & logsweep){
            // speed up Low Frequency by skipping measured frequency points
            double skipCount = ceil(fstep/LFstep)+1;
            inst->NumMeasCount = inst->NumMeasCount + skipCount;
         }else{
            inst->NumMeasCount++; // Move to next frequency point
         }
         //   -- update NumRefCycles
         inst->NumRefCycles = 0; // Reset cycle counter for next frequency point
      }
   }

   // Store current state for next iteration
   inst->mixerfreq = mixerfreq;
   inst->lastT = t;
   inst->lastRsin = rsin;
   inst->lastPh = Ph;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sFRANALYZERKSK *inst, double t)
{
   if (!inst->complete)
      return 1/inst->mixerfreq/1e3; // auto limit max step size = pert period / 1000
   else
      return -1e308; // terminate simulation
}

extern "C" __declspec(dllexport) void PostProcess(struct sFRANALYZERKSK *inst)
{
   if(inst->plotbode){
      // command preparation
      char cmdBuf[1024];   // update 2-JUL-25, @RDunn, char *cmdBuf pointer is allocated on the stack but not initialized, could point anywhere
      strcpy(cmdBuf,QUX);  // QUX is path to QUX.exe (e.g. C:\PROGRA~1\QSPICE\QUX.exe)
      strcat(cmdBuf," ");  // Space character
      strcat(cmdBuf,inst->fname);   // filename
      Display("\nPostProcess : %s\n",cmdBuf);
      Display("Press Abort to continue...\n");

      // command execution
      system(cmdBuf);
      //system("\"C:\\Program Files\\QSPICE\\QUX.exe\" filename.csv");
   }
   Display("\nSimulation completed. \"%s\" is saved.\n",inst->fname);
}

extern "C" __declspec(dllexport) void Destroy(struct sFRANALYZERKSK *inst)
{
   free(inst);
}
