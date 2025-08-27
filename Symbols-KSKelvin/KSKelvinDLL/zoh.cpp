// Automatically generated C++ file on Sun Jul 21 11:20:29 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD zoh.cpp kernel32.lib

#include <malloc.h>

extern "C" __declspec(dllexport) int (*Display)(const char *format, ...) = 0; // works like printf()
extern "C" __declspec(dllexport) const double *DegreesC                  = 0; // pointer to current circuit temperature

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

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sZOH *inst)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sZOH
}

extern "C" __declspec(dllexport) void Trunc(struct sZOH *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sZOH
   const double ttol = 1e-9;
   if(*timestep > ttol)
   {
      double &OUT = data[2].d; // output

      // Save output vector
      const double _OUT = OUT;

      struct sZOH tmp = *inst;
      zoh(&(&tmp), t, data);
   // if(tmp != *inst) // implement a meaningful way to detect if the state has changed
   //    *timestep = ttol;
      if(tmp.last_CLK != inst->last_CLK)
         *timestep = ttol;

      // Restore output vector
      OUT = _OUT;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sZOH *inst)
{
   free(inst);
}
