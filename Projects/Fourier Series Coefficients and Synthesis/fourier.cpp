// Automatically generated C++ file on Tue Jul 15 01:44:10 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD fourier.cpp kernel32.lib

#include <malloc.h>
#include <math.h>

extern "C" __declspec(dllexport) int (*Display)(const char *format, ...) = 0; // works like printf()
extern "C" __declspec(dllexport) const double *DegreesC                  = 0; // pointer to current circuit temperature
extern "C" __declspec(dllexport) const int *StepNumber                   = 0; // pointer to current step number
extern "C" __declspec(dllexport) const int *NumberSteps                  = 0; // pointer to estimated number of steps
extern "C" __declspec(dllexport) const char* const *InstanceName         = 0; // pointer to address of instance name
extern "C" __declspec(dllexport) const char *QUX                         = 0; // path to QUX.exe
extern "C" __declspec(dllexport) const bool *ForKeeps                    = 0; // pointer to whether being evaluated non-hypothetically
extern "C" __declspec(dllexport) const bool *HoldICs                     = 0; // pointer to whether instance initial conditions are being held
extern "C" __declspec(dllexport) int (*DFFT)(struct sComplex *u, bool inv, unsigned int N, double scale) = 0; // discrete Fast Fourier function

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
#undef in
#undef out
#undef clkout

#define MaxOrder 16

struct sFOURIER
{
  // declare the structure here
  double lastT;   // Timestamp of the previous sample (for delta time calculation)
  double lastIN;  // Previous input value

  // Integration Cumulative sum
  double cumsumIN;              // Cumulative sum for DC component (a[0]) integration
  double cumsumCOS[MaxOrder+1]; // Cumulative sum for cosine term (a[n] coefficient) integration
  double cumsumSIN[MaxOrder+1]; // Cumulative sum for sine term (b[n] coefficient) integration

  // Fourier coefficients
  double a[MaxOrder+1];      // a[0]=DC, a[1..N]=cosine coefficients
  double b[MaxOrder+1];      // b[1..N]=sine coefficients

  double Tperiod; // Base period length for the Fourier analysis
  double Ttarget; // Next target time when coefficients should be recalculated
  bool init;      // Initialization flag (false until first run)
};

extern "C" __declspec(dllexport) void fourier(struct sFOURIER **opaque, double t, union uData *data)
{
   double  in           = data[0].d; // input
   bool    DisplayCoeff = data[1].b; // input parameter
   double  Tperiod      = data[2].d; // input parameter
   int     order        = data[3].i; // input parameter
   double &out          = data[4].d; // output
   bool   &clkout       = data[5].b; // output


   if(!*opaque)
   {
      *opaque = (struct sFOURIER *) malloc(sizeof(struct sFOURIER));
      bzero(*opaque, sizeof(struct sFOURIER));
   }
   struct sFOURIER *inst = *opaque;

// Implement module evaluation code here:

   // Check if the instance needs initialization
   if (!inst->init){
      // Initialize period and target time with given Tperiod
      inst->Tperiod = Tperiod;
      inst->Ttarget = Tperiod;
      // Mark instance as initialized
      inst->init = true;
   }
   // Calculate time difference since last update
   double dT = t - inst->lastT;
   clkout = false;

   // Perform numerical integration of input signal (in) using trapezoidal rule
   inst->cumsumIN += (in + inst->lastIN)*dT/2;  // trap integration
   // Perform numerical integration for Fourier coefficients using rectangle method
   // (simpler but potentially less accurate than trapezoidal)
   for (int n=1; n <= order; n++){
      inst->cumsumCOS[n] += in*cos(n*2*M_PI/Tperiod*t)*dT; // rectangle integration (simplier)
      inst->cumsumSIN[n] += in*sin(n*2*M_PI/Tperiod*t)*dT; // rectangle integration (simplier)
   }

   // Check if a period is reached
   if (t >= inst->Ttarget){
      // Calculate Fourier coefficients (DC component)
      inst->a[0] = 1/Tperiod*inst->cumsumIN;    // DC component (average)
      inst->cumsumIN = 0;  // Reset integration accumulators for next period
      if (DisplayCoeff){
         Display("\nSimulation time t = %f \n",t); // Display simulation time when period is reached
         Display("   a0 = %9.6f\n",inst->a[0]);   // Display the calculated coefficients
      }

      // Calculate Fourier coefficients (Harmonics)
      for (int n=1; n <= order; n++){
         // Calculate Fourier coefficients
         inst->a[n] = 2/Tperiod*inst->cumsumCOS[n]; // Cosine coefficient of n-th harmonic
         inst->b[n] = 2/Tperiod*inst->cumsumSIN[n]; // Sine coefficient of n-th harmonic
         // Reset integration accumulators for next period
         inst->cumsumCOS[n] = 0;
         inst->cumsumSIN[n] = 0;
         if (DisplayCoeff){
            // Calculate magnitude/phase for each harmonic
            double mag = sqrt(inst->a[n]*inst->a[n] + inst->b[n]*inst->b[n]);
            double phase = -atan2(inst->b[n], inst->a[n]);
            // Display the calculated coefficients
            Display("   a%d = %9.6f; b%d = %9.6f",n,inst->a[n],n,inst->b[n]);
            Display("; mag%d = %4.2f; phase%d = %4.2f\n",n,mag,n,phase*180/M_PI);
         }
      }

      // Set new target time for next period
      inst->Ttarget += Tperiod;
      clkout = true;
   }

   // Reconstruct output signal using the calculated Fourier coefficients
   out = inst->a[0];
   for (int n=1; n <= order; n++){
      out += inst->a[n]*cos(n*2*M_PI/Tperiod*t) + inst->b[n]*sin(n*2*M_PI/Tperiod*t);
   }

   // Store current time and input value for next iteration
   inst->lastT = t;
   inst->lastIN = in;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sFOURIER *inst, double t)
{
   return inst->Tperiod/1e4;
   //return 1e308; // implement a good choice of max timestep size that depends on struct sFOURIER
}

extern "C" __declspec(dllexport) void Destroy(struct sFOURIER *inst)
{
   free(inst);
}
