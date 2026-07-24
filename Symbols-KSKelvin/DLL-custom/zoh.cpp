// Automatically generated C++ file on Wed Oct 15 23:24:13 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD zoh.cpp kernel32.lib

#include <malloc.h>

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
#undef CLKin
#undef OUT
#undef CLKo

struct sZOH
{
  // declare the structure here
  bool CLK;
  bool last_CLK;
  double T_CLKr;
};

extern "C" __declspec(dllexport) void zoh(struct sZOH **opaque, double t, union uData *data)
{
   double  IN         = data[0].d; // input
   bool    CLKin      = data[1].b; // input
   bool    InteralCLK = data[2].b; // input parameter
   double  fclk       = data[3].d; // input parameter
   double &OUT        = data[4].d; // output
   bool   &CLKo       = data[5].b; // output

   if(!*opaque)
   {
      *opaque = (struct sZOH *) malloc(sizeof(struct sZOH));
      bzero(*opaque, sizeof(struct sZOH));
   }
   struct sZOH *inst = *opaque;

// Implement module evaluation code here:

   CLKo = 0;   // Initialize clock output to 0 (low)

   // Check if using external clock or internal clock
   if(!InteralCLK)
   {
      // External clock mode: use the provided CLKin signal
      inst->CLK = CLKin;
   }else
   {
      // Internal clock mode: generate clock signal internally
      inst->CLK = 0;    // Default to low state
      // Check if enough time has passed for clock period (1/fclk)
      if(t - inst->T_CLKr >= 1.0/fclk)
      {
         inst->CLK = 1;    // Generate clock pulse (set to high)
         inst->T_CLKr = t; // Record the time when clock rises for next period calculation
      }
   }

   // Detect rising edge on clock signal (positive edge trigger)
   if(inst->CLK && !inst->last_CLK)
   {
      OUT = IN;         // On rising clock edge, latch the input value to output
      CLKo = inst->CLK; // Output the current clock signal
   }

   // Store current clock state for edge detection in next cycle
   inst->last_CLK = inst->CLK;
}

extern "C" __declspec(dllexport) void Trunc(struct sZOH *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sZOH
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sZOH tmp = *inst;
      zoh(&(&tmp), t, data);

      if(tmp.last_CLK != inst->last_CLK)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sZOH *inst)
{
   free(inst);
}
