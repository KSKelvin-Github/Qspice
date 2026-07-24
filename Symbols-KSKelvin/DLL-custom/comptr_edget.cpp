// Automatically generated C++ file on Wed Oct 15 23:01:48 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD comptr_edget.cpp kernel32.lib

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
#undef _Q
#undef riseT
#undef fallT

struct sCOMPTR_EDGET
{
  // declare the structure here
  double lastQ;
};

extern "C" __declspec(dllexport) void comptr_edget(struct sCOMPTR_EDGET **opaque, double t, union uData *data)
{
   double  in1   = data[0].d; // input
   double  in2   = data[1].d; // input
   bool   &Q     = data[2].b; // output
   bool   &_Q    = data[3].b; // output
   double &riseT = data[4].d; // output
   double &fallT = data[5].d; // output

   if(!*opaque)
   {
      *opaque = (struct sCOMPTR_EDGET *) malloc(sizeof(struct sCOMPTR_EDGET));
      bzero(*opaque, sizeof(struct sCOMPTR_EDGET));
   }
   struct sCOMPTR_EDGET *inst = *opaque;

// Implement module evaluation code here:

   // Compare the two input values
   if (in1 >= in2)
   {
      Q = 1;
      _Q = 0;
   }
   else
   {
      Q = 0;
      _Q = 1;
   }

   // Detect rising edge on Q output (transition from 0 to 1)
   if (Q && !inst->lastQ)
      riseT = t;  // Capture the current time as the rising edge timestamp

   // Detect falling edge on Q output (transition from 1 to 0)
   if (!Q && inst->lastQ)
      fallT = t;  // Capture the current time as the falling edge timestamp

   // Store the current Q value for edge detection in the next execution cycle
   inst->lastQ = Q;

}

extern "C" __declspec(dllexport) void Trunc(struct sCOMPTR_EDGET *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sCOMPTR_EDGET
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sCOMPTR_EDGET tmp = *inst;
      comptr_edget(&(&tmp), t, data);

      if(tmp.lastQ != inst->lastQ)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sCOMPTR_EDGET *inst)
{
   free(inst);
}
