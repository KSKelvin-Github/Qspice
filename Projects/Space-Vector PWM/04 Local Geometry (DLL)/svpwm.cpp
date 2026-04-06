// Automatically generated C++ file on Sat Apr  4 19:01:20 2026
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD -o svpwm.cpp kernel32.lib

#include <malloc.h>
#include <math.h>
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
#undef alpha
#undef beta
#undef s1
#undef s4
#undef s3
#undef s6
#undef s5
#undef s2
#undef sawth
#undef REFph
#undef sector
#undef REFmag

struct sSVPWM
{
  // declare the structure here
  double maxstep; // suggested max simulation timestep
  bool last_s1;   // Previous state of upper switch for phase A
  bool last_s3;   // Previous state of upper switch for phase B
  bool last_s5;   // Previous state of upper switch for phase C
};

extern "C" __declspec(dllexport) void svpwm(struct sSVPWM **opaque, double t, union uData *data)
{
   double  alpha     = data[ 0].d; // input
   double  beta      = data[ 1].d; // input
   double  fsampling = data[ 2].d; // input parameter
   double  segment   = data[ 3].d; // input parameter
   bool   &s1        = data[ 4].b; // output
   bool   &s4        = data[ 5].b; // output
   bool   &s3        = data[ 6].b; // output
   bool   &s6        = data[ 7].b; // output
   bool   &s5        = data[ 8].b; // output
   bool   &s2        = data[ 9].b; // output
   double &sawth     = data[10].d; // output
   double &REFph     = data[11].d; // output
   double &sector    = data[12].d; // output
   double &REFmag    = data[13].d; // output
   double &thres_s1  = data[14].d; // output
   double &thres_s3  = data[15].d; // output
   double &thres_s5  = data[16].d; // output

   if(!*opaque)
   {
      *opaque = (struct sSVPWM *) malloc(sizeof(struct sSVPWM));
      bzero(*opaque, sizeof(struct sSVPWM));
   }
   struct sSVPWM *inst = *opaque;

// Implement module evaluation code here:

   // Suggested maximum simulation timestep
   inst->maxstep = 1.0/fsampling/100;

   // Calculate PWM period from sampling frequency
   double Ts=1.0/fsampling;

   // Calculate reference voltage vector magnitude and angle
   REFmag = hypot(alpha,beta);         // Euclidean norm: sqrt(alpha² + beta²)
   REFph = atan2(-beta,-alpha)+M_PI;   // Phase angle from Cartesian coordinates, [0, 2p] range

   // Determine which sector the reference vector falls into (6 sectors of 60°(pi/3) each)
   sector = trunc(REFph/(M_PI/3))+1;

   // Generate normalized symmetric triangular carrier waveform (range 0 to 1) synchronized with PWM period
   // Creates triangle wave that rises from 0 to 1 over Ts/2, then falls back to 0 over Ts/2
   sawth = (fabs(fmod(t, Ts) - Ts/2.0) * 2.0)/Ts;   // Normalized so peak = 1.0

   // Calculate timing for T1 and T2
   double phi = REFph-trunc(REFph*3.0/M_PI)*M_PI/3.0;
   // Uses relative angle within the current sector (0° to 60°), with respect to Vk [normalized Ts=1]
   // Values are normalized such that T1+T2+T0 = 1 (where Ts=1)
   double T1 = sqrt(3.0)*REFmag*sin(M_PI/3-phi);
   double T2 = sqrt(3.0)*REFmag*sin(phi);
   // Zero vector on-time (remaining time in switching period) [normalized Ts=1]
   double T0 = 1 - (T1 + T2);

   // Calculate PWM threshold values for each phase based on sector and switching segment
   // These thresholds determine when each upper switch (s1, s3, s5) turns ON during the carrier period
   // Different thresholds create the required switching sequence for each sector

   // 3-segment switching pattern with local geometry
   if(segment==3){
      if(sector==1){
         thres_s1 = T1+T2;
         thres_s3 = T2;
         thres_s5 = 0;
      }else if(sector==2){
         thres_s1 = T0+T1;
         thres_s3 = T0+T1+T2;
         thres_s5 = T0;
      }else if(sector==3){
         thres_s1 = 0;
         thres_s3 = T1+T2;
         thres_s5 = T2;
      }else if(sector==4){
         thres_s1 = T0;
         thres_s3 = T0+T1;
         thres_s5 = T0+T1+T2;
      }else if(sector==5){
         thres_s1 = T2;
         thres_s3 = 0;
         thres_s5 = T1+T2;
      }else{
         thres_s1 = T0+T1+T2;
         thres_s3 = T0;
         thres_s5 = T0+T1;
      }
   }
   // 5-segment switching pattern with local geometry
   else if(segment==5){
      if(sector==1){
         thres_s1 = T0+T1+T2;
         thres_s3 = T0+T2;
         thres_s5 = T0;
      }else if(sector==2){
         thres_s1 = T1;
         thres_s3 = T1+T2;
         thres_s5 = 0;
      }else if(sector==3){
         thres_s1 = T0;
         thres_s3 = T0+T1+T2;
         thres_s5 = T0+T2;
      }else if(sector==4){
         thres_s1 = 0;
         thres_s3 = T1;
         thres_s5 = T1+T2;
      }else if(sector==5){
         thres_s1 = T0+T2;
         thres_s3 = T0;
         thres_s5 = T0+T1+T2;
      }else{
         thres_s1 = T1+T2;
         thres_s3 = 0;
         thres_s5 = T1;
      }
   }
   // 7-segment switching pattern with local geometry
   else if(segment==7){
      if(sector==1){
         thres_s1 = T0/2+T1+T2;
         thres_s3 = T0/2+T2;
         thres_s5 = T0/2;
      }else if(sector==2){
         thres_s1 = T0/2+T1;
         thres_s3 = T0/2+T1+T2;
         thres_s5 = T0/2;
      }else if(sector==3){
         thres_s1 = T0/2;
         thres_s3 = T0/2+T1+T2;
         thres_s5 = T0/2+T2;
      }else if(sector==4){
         thres_s1 = T0/2;
         thres_s3 = T0/2+T1;
         thres_s5 = T0/2+T1+T2;
      }else if(sector==5){
         thres_s1 = T0/2+T2;
         thres_s3 = T0/2;
         thres_s5 = T0/2+T1+T2;
      }else{
         thres_s1 = T0/2+T1+T2;
         thres_s3 = T0/2;
         thres_s5 = T0/2+T1;
      }
   }

   // Comparator: Generate PWM signals by comparing normalized triangular carrier with thresholds
   // Switch turns ON when carrier waveform (sawth) is BELOW the threshold value
   if(thres_s1 > sawth) s1=true; else s1 = false;
   if(thres_s3 > sawth) s3=true; else s3 = false;
   if(thres_s5 > sawth) s5=true; else s5 = false;


   // Generate complementary switching signals for lower switches
   // This prevents shoot-through conditions in the inverter
   s4=!s1;  // Lower switch A is complement of upper switch A
   s6=!s3;  // Lower switch B is complement of upper switch B
   s2=!s5;  // Lower switch C is complement of upper switch C

   /// Store current switching states for potential future use
   inst->last_s1 = s1;
   inst->last_s3 = s3;
   inst->last_s5 = s5;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sSVPWM *inst, double t)
{
   return inst->maxstep; // implement a good choice of max timestep size that depends on struct sSVPWM
}

extern "C" __declspec(dllexport) void Trunc(struct sSVPWM *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sSVPWM
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sSVPWM tmp = *inst;
      svpwm(&(&tmp), t, data);
      if( (tmp.last_s1 != inst->last_s1)|(tmp.last_s3 != inst->last_s3)|(tmp.last_s5 != inst->last_s5) )
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sSVPWM *inst)
{
   free(inst);
}
