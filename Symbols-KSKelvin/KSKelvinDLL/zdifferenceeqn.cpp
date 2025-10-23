// Automatically generated C++ file on Mon Oct 20 21:04:47 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD zdifferenceeqn.cpp kernel32.lib

#include <malloc.h>

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
#undef x
#undef y0
#undef clko
#undef x0
#undef x1
#undef x2
#undef x3
#undef y1
#undef y2
#undef y3

struct sZDIFFERENCEEQN
{
  // declare the structure here
  double previousTclk;
  bool last_clko;
};

extern "C" __declspec(dllexport) void zdifferenceeqn(struct sZDIFFERENCEEQN **opaque, double t, union uData *data)
{
   double  x    = data[ 0].d; // input
   double  fclk = data[ 1].d; // input parameter
   double  b0   = data[ 2].d; // input parameter
   double  b1   = data[ 3].d; // input parameter
   double  b2   = data[ 4].d; // input parameter
   double  b3   = data[ 5].d; // input parameter
   double  a1   = data[ 6].d; // input parameter
   double  a2   = data[ 7].d; // input parameter
   double  a3   = data[ 8].d; // input parameter
   double &y0   = data[ 9].d; // output
   bool   &clko = data[10].b; // output
   double &x0   = data[11].d; // output
   double &x1   = data[12].d; // output
   double &x2   = data[13].d; // output
   double &x3   = data[14].d; // output
   double &y1   = data[15].d; // output
   double &y2   = data[16].d; // output
   double &y3   = data[17].d; // output

   if(!*opaque)
   {
      *opaque = (struct sZDIFFERENCEEQN *) malloc(sizeof(struct sZDIFFERENCEEQN));
      bzero(*opaque, sizeof(struct sZDIFFERENCEEQN));
   }
   struct sZDIFFERENCEEQN *inst = *opaque;

// Implement module evaluation code here:

   // Clock output flag - indicates when a new clock cycle occurs
   clko = false;
   // Check if enough time has passed for the next clock cycle (1/fclk period)
   if (t - inst->previousTclk >= 1/fclk)
   {
      clko = true;   // Set clock output flag to true
      inst->previousTclk = t; // Update the previous clock time to current time for next cycle calculation

      // Store current input value as x0
      x0 = x;

      // Compute current output using difference equation:
      // y0 = b0*x0 + b1*x1 + b2*x2 + b3*x3 + a1*y1 + a2*y2 + a3*y3
      y0 = b0*x0+b1*x1+b2*x2+b3*x3+a1*y1+a2*y2+a3*y3;

      // Shift the input delay line
      x3 = x2;
      x2 = x1;
      x1 = x0;

      // Shift the output delay line
      y3 = y2;
      y2 = y1;
      y1 = y0;
   }

   // Store the clock output flag
   inst->last_clko = clko;

}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sZDIFFERENCEEQN *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sZDIFFERENCEEQN
}

extern "C" __declspec(dllexport) void Trunc(struct sZDIFFERENCEEQN *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sZDIFFERENCEEQN
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sZDIFFERENCEEQN tmp = *inst;
      zdifferenceeqn(&(&tmp), t, data);

      // Check if the clock output state has changed between the temporary instance and the main instance
      if(tmp.last_clko != inst->last_clko)
         *timestep = ttol;    // When a clock edge is detected, set the timestep to the tolerance value
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sZDIFFERENCEEQN *inst)
{
   free(inst);
}
