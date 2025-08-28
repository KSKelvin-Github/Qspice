// Automatically generated C++ file on Thu Aug 28 23:58:18 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD zoh.cpp kernel32.lib

#include <malloc.h>

extern "C" __declspec(dllexport) void (*Display)(const char *format, ...)       = 0; // works like printf()
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
#undef OUT
#undef CLK

struct sZOH
{
  // declare the structure here
  bool last_CLK;
};

extern "C" __declspec(dllexport) void zoh(struct sZOH **opaque, double t, union uData *data)
{
   double  IN  = data[0].d; // input
   bool    CLK = data[1].b; // input
   double &OUT = data[2].d; // output

   if(!*opaque)
   {
      *opaque = (struct sZOH *) malloc(sizeof(struct sZOH));
      bzero(*opaque, sizeof(struct sZOH));
   }
   struct sZOH *inst = *opaque;

// Implement module evaluation code here:

   if(CLK && !inst->last_CLK)
      OUT = IN;

   inst->last_CLK = CLK;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sZOH *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sZOH
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
