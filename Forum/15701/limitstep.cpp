// Automatically generated C++ file on Mon Nov 13 07:52:12 2023
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD limitstep.cpp kernel32.lib

#include <malloc.h>

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
#undef x

struct sLIMITSTEP
{
  // declare the structure here
  double x;
};

extern "C" __declspec(dllexport) void limitstep(struct sLIMITSTEP **opaque, double t, union uData *data)
{
   double x = data[0].d; // input

   if(!*opaque)
   {
      *opaque = (struct sLIMITSTEP *) malloc(sizeof(struct sLIMITSTEP));
      bzero(*opaque, sizeof(struct sLIMITSTEP));
   }
   struct sLIMITSTEP *inst = *opaque;

// Implement module evaluation code here:
   inst->x = x;
}

extern "C" __declspec(dllexport) void Trunc(struct sLIMITSTEP *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sLIMITSTEP
   const double ttol = 1e-8;
   if(*timestep > ttol)
   {


      // Save output vector

      struct sLIMITSTEP tmp = *inst;
      limitstep(&(&tmp), t, data);
   // if(tmp != *inst) // implement a meaningful way to detect if the state has changed
   //    *timestep = ttol;
      if(tmp.x>0.92 | tmp.x<0.08)
         *timestep = ttol;
      // Restore output vector
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sLIMITSTEP *inst)
{
   free(inst);
}
