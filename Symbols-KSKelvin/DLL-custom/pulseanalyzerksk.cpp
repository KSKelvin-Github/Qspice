// Automatically generated C++ file on Wed Oct  8 18:11:01 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD pulseanalyzerksk.cpp kernel32.lib

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
#undef in1
#undef in2
#undef Q
#undef freq
#undef duty
#undef count

struct sPULSEANALYZERKSK
{
  // declare the structure here
  double lastQ;
  double lastT;
};

extern "C" __declspec(dllexport) void pulseanalyzerksk(struct sPULSEANALYZERKSK **opaque, double t, union uData *data)
{
   double  in1   = data[0].d; // input
   double  in2   = data[1].d; // input
   bool   &Q     = data[2].b; // output
   double &freq  = data[3].d; // output
   double &duty  = data[4].d; // output
   double &count = data[5].d; // output

   if(!*opaque)
   {
      *opaque = (struct sPULSEANALYZERKSK *) malloc(sizeof(struct sPULSEANALYZERKSK));
      bzero(*opaque, sizeof(struct sPULSEANALYZERKSK));
   }
   struct sPULSEANALYZERKSK *inst = *opaque;

// Implement module evaluation code here:

   // Comparator
   if (in1 >= in2)   // Compare input signals
      Q = 1;         // Set output high when in1 >= in2
   else
      Q = 0;         // Set output low when in1 < in2

   // Timing Analysis
   if (Q && !inst->lastQ){    // Detect rising edge (current Q=1, previous Q=0)
      if(count>0)             // Only calculate frequency after first complete cycle
         freq = 1/(t-inst->lastT);  // Calculate frequency: 1 / time between rising edges
      if(t>0)                 // Avoid counting at simulation start (t=0)
         count = count + 1;   // Increment edge counter
      inst->lastT = t;        // Store timestamp of this rising edge for next calculation
   }
   if (!Q && inst->lastQ){    // Detect falling edge (current Q=0, previous Q=1)
      if(count>0){            // Only calculate duty cycle after first complete cycle
         duty = (t-inst->lastT)*freq;  // Calculate duty cycle: pulse width * frequency
      }
   }

   inst->lastQ = Q;  // Store current Q state for edge detection in next cycle
}

extern "C" __declspec(dllexport) void Trunc(struct sPULSEANALYZERKSK *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sPULSEANALYZERKSK
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sPULSEANALYZERKSK tmp = *inst;
      pulseanalyzerksk(&(&tmp), t, data);

      if(tmp.lastQ != inst->lastQ)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sPULSEANALYZERKSK *inst)
{
   free(inst);
}
