// Automatically generated C++ file on Sun Nov 22 14:17:42 2026
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD -o pi_block.cpp kernel32.lib

#include <malloc.h>

// Include Simulink Coder Generated C Files (Wrapped in extern "C")
// Tell Digital Mars compiler to also search the qspice_bundle subfolder for headers
#pragma includepath "qspice_bundle"
extern "C" {
#include "qspice_bundle/pi_simulink.h"
#include "qspice_bundle/pi_simulink.c"
}

extern "C" __declspec(dllexport) void (*Display)(const char *format, ...)       = 0; // works like printf()
extern "C" __declspec(dllexport) void (*EXIT)(const char *format, ...)          = 0; // print message like printf() but exit(0) afterward
extern "C" __declspec(dllexport) const double *DegreesC                         = 0; // pointer to current circuit temperature
extern "C" __declspec(dllexport) const int *StepNumber                          = 0; // pointer to current step number
extern "C" __declspec(dllexport) const int *NumberSteps                         = 0; // pointer to estimated number of steps
extern "C" __declspec(dllexport) const char* const *InstanceName                = 0; // pointer to address of instance name
extern "C" __declspec(dllexport) const char *QUX                                = 0; // path to QUX.exe
extern "C" __declspec(dllexport) const bool *ForKeeps                           = 0; // pointer to whether being evaluated non-hypothetically
extern "C" __declspec(dllexport) const bool *HoldICs                            = 0; // pointer to whether instance initial conditions are being held
extern "C" __declspec(dllexport) const void *GUI_HWND                           = 0; // pointer to Window handle of QUX.exe
extern "C" __declspec(dllexport) const double *CKTtime                          = 0;
extern "C" __declspec(dllexport) const double *CKTdelta                         = 0;
extern "C" __declspec(dllexport) const int *IntegrationOrder                    = 0;
extern "C" __declspec(dllexport) const char *InstallDirectory                   = 0;
extern "C" __declspec(dllexport) double (*EngAtof)(const char **string)         = 0;
extern "C" __declspec(dllexport) const char *(*BinaryFormat)(unsigned int data)                          = 0; // BinaryFormat(0x1C) returns "0b00011100"
extern "C" __declspec(dllexport) const char *(*EngFormat   )(double x, const char *units, int numDgts)   = 0; // EngFormat(1e-6, "s", 6) returns "1µs"
extern "C" __declspec(dllexport) int (*DFFT)(struct sComplex *u, bool inv, unsigned int N, double scale) = 0; // Discrete Fast Fourier Transform
extern "C" __declspec(dllexport) void (*bzero)(void *ptr, unsigned int count)   = 0;

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

// #undef pin names lest they collide with names in any header file(s) you might include.
#undef err
#undef u

struct sPI_BLOCK
{
  // declare the structure here
  double nextSampleTime;   // Next scheduled discrete sampling timestamp (s)
  bool latch;              // Edge-detection flag used by Trunc() to refine timestep at sample instants
};

extern "C" __declspec(dllexport) void pi_block(struct sPI_BLOCK **opaque, double t, union uData *data)
{
   double  err = data[0].d; // input
   double  kp  = data[1].d; // input parameter
   double  ki  = data[2].d; // input parameter
   double  Ts  = data[3].d; // input parameter
   double &u   = data[4].d; // output

   if(!*opaque)
   {
      *opaque = (struct sPI_BLOCK *) malloc(sizeof(struct sPI_BLOCK));
      bzero(*opaque, sizeof(struct sPI_BLOCK));
   }
   struct sPI_BLOCK *inst = *opaque;

// Implement module evaluation code here:

   inst->latch=false;
   // Sample control signals at sampling frequency
   if(t >= inst->nextSampleTime){
      inst->latch=true;
      // Latch control signals at sampling instant (zero-order hold)
      inst->nextSampleTime = inst->nextSampleTime+Ts;
      // Only compute in non-Hypothetical evaluation
      if (*ForKeeps) {
         // Map QSPICE inputs to Simulink External Inputs struct (_U)
         pi_simulink_U.err = err;
         pi_simulink_U.kp  = kp;
         pi_simulink_U.ki  = ki;
         pi_simulink_U.Ts  = Ts;
         pi_simulink_U.rst = 0.0;

         // Execute one discrete step of the Simulink model
         pi_simulink_step();

         // Latch Simulink output for zero-order hold
         u = pi_simulink_Y.u;
      }
   }
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sPI_BLOCK *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sPI_BLOCK
}

extern "C" __declspec(dllexport) void Trunc(struct sPI_BLOCK *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sPI_BLOCK
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sPI_BLOCK tmp = *inst;
      pi_block(&(&tmp), t, data);
   // if(tmp != *inst) // implement a meaningful way to detect if the state has changed
   //    *timestep = ttol;
      if(tmp.latch != inst->latch)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sPI_BLOCK *inst)
{
   free(inst);
}
