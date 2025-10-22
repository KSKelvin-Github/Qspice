// Automatically generated C++ file on Thu Oct 16 00:06:15 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD rts.cpp kernel32.lib

#include <malloc.h>
#include <cmath>

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
#undef IN
#undef CLKo
#undef mean
#undef min
#undef max
#undef pp
#undef rms

struct sRTS
{
  // declare the structure here
  double lastTinterval;
  double lastT;
  bool lastCLKo;
  double rts_max;
  double rts_min;
  double lastIN;
  double cumsumIN;
  double cumsumIN2;
};

extern "C" __declspec(dllexport) void rts(struct sRTS **opaque, double t, union uData *data)
{
   double  IN        = data[0].d; // input
   double  Tinterval = data[1].d; // input parameter
   bool   &CLKo      = data[2].b; // output
   double &mean      = data[3].d; // output
   double &min       = data[4].d; // output
   double &max       = data[5].d; // output
   double &pp        = data[6].d; // output
   double &rms       = data[7].d; // output

   if(!*opaque)
   {
      *opaque = (struct sRTS *) malloc(sizeof(struct sRTS));
      bzero(*opaque, sizeof(struct sRTS));
   }
   struct sRTS *inst = *opaque;

// Implement module evaluation code here:

   CLKo = 0;

   // statistic max and min
   if (inst->rts_max < IN)   // check max
      inst->rts_max = IN;
   if (inst->rts_min > IN)   // check min
      inst->rts_min = IN;

   // statistic mean and rms
   double deltaT = t - inst->lastT;
   inst->cumsumIN = (inst->lastIN + IN)*deltaT/2 + inst->cumsumIN;  // integral of mean
   inst->cumsumIN2 = (pow(inst->lastIN,2) + pow(IN,2))*deltaT/2 + inst->cumsumIN2; // integral of square

   // @Tinterval, update RTS output
   if (t - inst->lastTinterval >= Tinterval)
   {
      // compute and output RTS data
      CLKo = 1;
      max = inst->rts_max;
      min = inst->rts_min;
      pp = max-min;
      mean = inst->cumsumIN / Tinterval;  // integral divide by interval
      rms = sqrt(inst->cumsumIN2 / Tinterval);  // integral divide by interval and square root

      inst->lastTinterval = t;

      // reset RTS history
      inst->rts_max = IN;
      inst->rts_min = IN;
      inst->cumsumIN = 0;
      inst->cumsumIN2 = 0;

   }

   inst->lastCLKo = CLKo;
   inst->lastT = t;
   inst->lastIN = IN;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sRTS *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sRTS
}

extern "C" __declspec(dllexport) void Trunc(struct sRTS *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sRTS
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sRTS tmp = *inst;
      rts(&(&tmp), t, data);

      if(tmp.lastCLKo != inst->lastCLKo)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sRTS *inst)
{
   free(inst);
}
