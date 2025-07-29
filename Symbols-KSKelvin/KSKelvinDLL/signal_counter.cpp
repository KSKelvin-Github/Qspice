// Automatically generated C++ file on Thu Jul 25 20:15:31 2024
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD signal_counter.cpp kernel32.lib

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
#undef in1
#undef in2
#undef Q
#undef freq
#undef duty
#undef count

struct sSIGNAL_COUNTER
{
  // declare the structure here
  double lastQ;
  double lastT;
};

extern "C" __declspec(dllexport) void signal_counter(struct sSIGNAL_COUNTER **opaque, double t, union uData *data)
{
   double  in1   = data[0].d; // input
   double  in2   = data[1].d; // input
   bool   &Q     = data[2].b; // output
   double &freq  = data[3].d; // output
   double &duty  = data[4].d; // output
   double &count = data[5].d; // output

   if(!*opaque)
   {
      *opaque = (struct sSIGNAL_COUNTER *) malloc(sizeof(struct sSIGNAL_COUNTER));
      bzero(*opaque, sizeof(struct sSIGNAL_COUNTER));
   }
   struct sSIGNAL_COUNTER *inst = *opaque;

// Implement module evaluation code here:
   // compare input, >= set output is same characteristic of Qspice SCHMITT
   if (in1 >= in2)
      Q = 1;
   else
      Q = 0;

   // assign current time (t) at rising or falling edge
   if (Q && !inst->lastQ){
      if(count>0)
         freq = 1/(t-inst->lastT);
      if(t>0)
         count = count + 1;
      inst->lastT = t;
   }
   if (!Q && inst->lastQ){
      if(count>0){
         duty = (t-inst->lastT)*freq;
      }
   }

   inst->lastQ = Q;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sSIGNAL_COUNTER *inst)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sSIGNAL_COUNTER
}

extern "C" __declspec(dllexport) void Trunc(struct sSIGNAL_COUNTER *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sSIGNAL_COUNTER
   const double ttol = 1e-9;
   if(*timestep > ttol)
   {
      bool   &Q     = data[2].b; // output
      double &freq  = data[3].d; // output
      double &duty  = data[4].d; // output
      double &count = data[5].d; // output

      // Save output vector
      const bool   _Q     = Q    ;
      const double _freq  = freq ;
      const double _duty  = duty ;
      const double _count = count;

      struct sSIGNAL_COUNTER tmp = *inst;
      signal_counter(&(&tmp), t, data);
   // if(tmp != *inst) // implement a meaningful way to detect if the state has changed
   //    *timestep = ttol;
      if(tmp.lastQ != inst->lastQ)
         *timestep = ttol;

      // Restore output vector
      Q     = _Q    ;
      freq  = _freq ;
      duty  = _duty ;
      count = _count;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sSIGNAL_COUNTER *inst)
{
   free(inst);
}
