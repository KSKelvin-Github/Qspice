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
   bool   &s1        = data[ 3].b; // output
   bool   &s4        = data[ 4].b; // output
   bool   &s3        = data[ 5].b; // output
   bool   &s6        = data[ 6].b; // output
   bool   &s5        = data[ 7].b; // output
   bool   &s2        = data[ 8].b; // output
   double &Tsaw      = data[ 9].d; // output
   double &REFph     = data[10].d; // output
   double &sector    = data[11].d; // output
   double &REFmag    = data[12].d; // output

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

   /// Generate triangular sawtooth waveform synchronized with sampling frequency
   Tsaw = fmod(t,Ts);   // Modulo operation creates repeating ramp from 0 to Ts

   // Calculate duty cycles for adjacent active vectors (Tk and Tk+1)
   double Tk=0; double Tkplus1=0;
   int method=1;  // Selects which formula to use (0: alpha-beta, 1: magnitude-phase, 2: simplified angle)
   // These represent the on-times for the two vectors bordering the current sector
   // Tk = on-time for the first active vector (counter-clockwise from sector start)
   // Tkplus1 = on-time for the second active vector (clockwise from sector end)
   // All formulas produce equivalent results mathematically but differ in computational approach
   if(method==0){
      // Formula 1 : Based on alpha-beta (stationary reference frame) components
      Tk      = sqrt(3.0)*Ts*( sin(sector*M_PI/3.0)*alpha - cos(sector*M_PI/3.0)*beta );
      Tkplus1 = sqrt(3.0)*Ts*( -sin((sector-1)*M_PI/3.0)*alpha + cos((sector-1)*M_PI/3.0)*beta );
   }else if(method==1){
      // Formula 2 : Based on reference voltage magnitude and absolute phase angle
      Tk      = sqrt(3.0)*REFmag*Ts*( sin(sector*M_PI/3.0)*cos(REFph) - cos(sector*M_PI/3.0)*sin(REFph) );
      Tkplus1 = sqrt(3.0)*REFmag*Ts*( -sin((sector-1)*M_PI/3.0)*cos(REFph) + cos((sector-1)*M_PI/3.0)*sin(REFph) );
   }else if(method==2){
      // Formula 3 : Simplified angle-based calculation (most efficient)
      // Uses relative angle within the current sector (0° to 60°), with respect to Vk
      Tk      = sqrt(3.0)*REFmag*Ts*sin(M_PI/3-(REFph-trunc(REFph*3.0/M_PI)*M_PI/3.0));
      Tkplus1 = sqrt(3.0)*REFmag*Ts*sin((REFph-trunc(REFph*3.0/M_PI)*M_PI/3.0));
   }
   // Zero vector on-time (remaining time in switching period)
   double T0      = Ts - (Tk + Tkplus1);

   // Seven-segment SVPWM pattern generation for each sector
   // The switching sequence ensures minimum switching losses and reduces harmonics
   if(sector == 1){
      // Sector 1 switching sequence:
      //  V0   ->  V1   ->  V2   ->  V7   ->  V2   ->  V1  ->   V0
      // (000) -> (100) -> (110) -> (111) -> (110) -> (100) -> (000)
      if(Tsaw < T0/4.0)                                  {s1=false;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tk/2.0))                    {s1=true ;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1/2.0))        {s1=true ;s3=true ;s5=false;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1/2.0+T0/2.0)) {s1=true ;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1+T0/2.0))     {s1=true ;s3=true ;s5=false;}
      else if(Tsaw < (T0/4.0+Tk+Tkplus1+T0/2.0))         {s1=true ;s3=false;s5=false;}
      else                                               {s1=false;s3=false;s5=false;}
   }
   if(sector == 2){
      // Sector 2 switching sequence (modified for single-bit transitions):
      //  V0   ->  V3   ->  V2   ->  V7   ->  V2   ->  V3  ->   V0
      // (000) -> (010) -> (110) -> (111) -> (110) -> (010) -> (000)
      if(Tsaw < T0/4.0)                                  {s1=false;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0))               {s1=false;s3=true ;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk/2.0))        {s1=true ;s3=true ;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk/2.0+T0/2.0)) {s1=true ;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk+T0/2.0))     {s1=true ;s3=true ;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1+Tk+T0/2.0))         {s1=false;s3=true ;s5=false;}
      else                                               {s1=false;s3=false;s5=false;}
   }
   if(sector == 3){
      // Sector 3 switching sequence:
      //  V0   ->  V3   ->  V4   ->  V7   ->  V4   ->  V3  ->   V0
      // (000) -> (010) -> (011) -> (111) -> (011) -> (010) -> (000)
      if(Tsaw < T0/4.0)                                  {s1=false;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tk/2.0))                    {s1=false;s3=true ;s5=false;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1/2.0))        {s1=false;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1/2.0+T0/2.0)) {s1=true ;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1+T0/2.0))     {s1=false;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk+Tkplus1+T0/2.0))         {s1=false;s3=true ;s5=false;}
      else                                               {s1=false;s3=false;s5=false;}
   }
   if(sector == 4){
      // Sector 4 switching sequence (modified for single-bit transitions):
      //  V0   ->  V5   ->  V4   ->  V7   ->  V4   ->  V5  ->   V0
      // (000) -> (001) -> (011) -> (111) -> (011) -> (001) -> (000)
      if(Tsaw < T0/4.0)                                  {s1=false;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0))               {s1=false;s3=false;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk/2.0))        {s1=false;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk/2.0+T0/2.0)) {s1=true ;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk+T0/2.0))     {s1=false;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1+Tk+T0/2.0))         {s1=false;s3=false;s5=true ;}
      else                                               {s1=false;s3=false;s5=false;}
   }
   if(sector == 5){
      // Sector 5 switching sequence:
      //  V0   ->  V5   ->  V6   ->  V7   ->  V6   ->  V5  ->   V0
      // (000) -> (001) -> (101) -> (111) -> (101) -> (001) -> (000)
      if(Tsaw < T0/4.0)                                  {s1=false;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tk/2.0))                    {s1=false;s3=false;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1/2.0))        {s1=true ;s3=false;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1/2.0+T0/2.0)) {s1=true ;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk/2.0+Tkplus1+T0/2.0))     {s1=true ;s3=false;s5=true ;}
      else if(Tsaw < (T0/4.0+Tk+Tkplus1+T0/2.0))         {s1=false;s3=false;s5=true ;}
      else                                               {s1=false;s3=false;s5=false;}
   }
   if(sector == 6){
      // Sector 6 switching sequence (modified for single-bit transitions):
      //  V0   ->  V1   ->  V6   ->  V7   ->  V6   ->  V1  ->   V0
      // (000) -> (100) -> (101) -> (111) -> (101) -> (100) -> (000)
      if(Tsaw < T0/4.0)                                  {s1=false;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0))               {s1=true ;s3=false;s5=false;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk/2.0))        {s1=true ;s3=false;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk/2.0+T0/2.0)) {s1=true ;s3=true ;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1/2.0+Tk+T0/2.0))     {s1=true ;s3=false;s5=true ;}
      else if(Tsaw < (T0/4.0+Tkplus1+Tk+T0/2.0))         {s1=true ;s3=false;s5=false;}
      else                                               {s1=false;s3=false;s5=false;}
   }

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
