// Automatically generated C++ file on Fri Aug 15 01:50:05 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD phaseshiftpwm360_4outputs.cpp kernel32.lib

#include <malloc.h>

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
#undef CLKext
#undef PhaseStpB
#undef PhaseStpC
#undef PhaseStpD
#undef A
#undef _A
#undef B
#undef _B
#undef C
#undef _C
#undef D
#undef _D
#undef CLKa
#undef CLKb
#undef CLKc
#undef CLKd

struct sPHASESHIFTPWM360_4OUTPUTS
{
  // declare the structure here
  // declare the structure here
  bool init;             // Initialization flag (true after first setup)
  double lastT;          // Timestamp of the previous processing cycle
  double lastT_CLKint;   // Timestamp of the previous internal clock
  bool CLKmaster;        // Master clock
  bool lastCLKmaster;    // Previous state of the master clock (for edge detection)
  double nCLKa;          // Counter for number of CLKa pulses generated
  double nCLKb;          // Counter for number of CLKb pulses generated
  double nCLKc;          // Counter for number of CLKc pulses generated
  double nCLKd;          // Counter for number of CLKd pulses generated
  double lastT_CLKa;     // Timestamp of the last CLKa rising edge
  double lastT_CLKb;     // Timestamp of the last CLKb rising edge
  double lastT_CLKc;     // Timestamp of the last CLKc rising edge
  double lastT_CLKd;     // Timestamp of the last CLKd rising edge
  bool triggredB;        // Flag indicating if CLKb has been triggered in current cycle
  bool triggredC;        // Flag indicating if CLKc has been triggered in current cycle
  bool triggredD;        // Flag indicating if CLKd has been triggered in current cycle
  double CLKperiod;      // Measured period of the input clock signal
  double PhaseStpB_CLKin;// Phase septoint B sampled at CLKin rising edge
  double PhaseStpC_CLKin;// Phase septoint C sampled at CLKin rising edge
  double PhaseStpD_CLKin;// Phase septoint D sampled at CLKin rising edge
  bool lastA;            // Previous state of output A (for edge detection/state tracking)
  bool last_A;           // Previous state of complementary output _A
  bool lastB;            // Previous state of output B
  bool last_B;           // Previous state of complementary output _B
  bool lastC;            // Previous state of output C
  bool last_C;           // Previous state of complementary output _C
  bool lastD;            // Previous state of output D
  bool last_D;           // Previous state of complementary output _D
  bool lastCLKa;         // Previous state of CLKa signal
  bool lastCLKb;         // Previous state of CLKb signal
  bool lastCLKc;         // Previous state of CLKc signal
  bool lastCLKd;         // Previous state of CLKd signal
};

extern "C" __declspec(dllexport) void phaseshiftpwm360_4outputs(struct sPHASESHIFTPWM360_4OUTPUTS **opaque, double t, union uData *data)
{
   bool   CLKext        = data[ 0].b; // input
   double PhaseStpB     = data[ 1].d; // input
   double PhaseStpC     = data[ 2].d; // input
   double PhaseStpD     = data[ 3].d; // input
   double deadtime      = data[ 4].d; // input parameter
   bool   intCLK        = data[ 5].b; // input parameter
   double fsw           = data[ 6].d; // input parameter
   double PhaseOffset   = data[ 7].d; // input parameter
   double PhaseAtMaxStp = data[ 8].d; // input parameter
   double v2degree      = data[ 9].d; // input parameter
   bool  &A             = data[10].b; // output
   bool  &_A            = data[11].b; // output
   bool  &B             = data[12].b; // output
   bool  &_B            = data[13].b; // output
   bool  &C             = data[14].b; // output
   bool  &_C            = data[15].b; // output
   bool  &D             = data[16].b; // output
   bool  &_D            = data[17].b; // output
   bool  &CLKa          = data[18].b; // output
   bool  &CLKb          = data[19].b; // output
   bool  &CLKc          = data[20].b; // output
   bool  &CLKd          = data[21].b; // output

   if(!*opaque)
   {
      *opaque = (struct sPHASESHIFTPWM360_4OUTPUTS *) malloc(sizeof(struct sPHASESHIFTPWM360_4OUTPUTS));
      bzero(*opaque, sizeof(struct sPHASESHIFTPWM360_4OUTPUTS));
   }
   struct sPHASESHIFTPWM360_4OUTPUTS *inst = *opaque;

// Implement module evaluation code here:
   // Initialization
   if(*ForKeeps & !inst->init)  // Check if initialization is not done yet
   {
      A = 0; _A = 0;
      B = 0; _B = 0;
      C = 0; _C = 0;
      D = 0; _D = 0;
      inst->nCLKa = 0; inst->nCLKb = 0;
      inst->nCLKc = 0; inst->nCLKd = 0;
      inst->init = true;  // Mark initialization as complete
      if(!intCLK) Display("External Clock is Enabled, CLKext determines Switching Frequency\n");
      else Display("Internal Clock is Enabled, Switching Frequency (fsw) = %.0fkHz\n",fsw/1e3);
   }

   // Reset CLKa and CLKb
   CLKa=0;  // Clear CLKa pulse signal
   CLKb=0;  // Clear CLKb pulse signal
   CLKc=0;  // Clear CLKc pulse signal
   CLKd=0;  // Clear CLKd pulse signal

   // Select between external or internal clock source
   if(!intCLK) // If using external clock mode
   {
      inst->CLKmaster=CLKext; // Use external clock signal directly
   }
   else  // Internal clock mode
   {
      inst->CLKmaster=false;  // Start with clock low
      double TfromCLKint = t-inst->lastT_CLKint;   // Calculate time since last internal clock edge
      if(TfromCLKint >= 1/fsw)   // If elapsed time >= switching period
      {
         inst->CLKmaster=true;   // Generate clock pulse (rising edge)
         inst->lastT_CLKint = t; // Update timestamp of last internal clock edge
      }
   }

   // action at rising edge of CLKin
   if(!inst->lastCLKmaster & inst->CLKmaster)  // Detect rising edge of input clock
   {
      inst->CLKperiod = t - inst->lastT_CLKa;   // Calculate clock period

      // Determine sign of slope (v2degree) based on PhaseAtMaxStp and PhaseOffset
      if(PhaseAtMaxStp > PhaseOffset & v2degree < 0) v2degree = -v2degree;
      if(PhaseAtMaxStp < PhaseOffset & v2degree > 0) v2degree = -v2degree;
      if(PhaseOffset > 359) PhaseOffset=359;
      if(PhaseAtMaxStp > 359) PhaseAtMaxStp=359;

      // Calculate inst->PhaseStpB_CLKin
      inst->PhaseStpB_CLKin = PhaseStpB*v2degree+PhaseOffset;  // Phase setpoint B at clock edge
      if (v2degree >= 0){
         if(inst->PhaseStpB_CLKin < PhaseOffset) inst->PhaseStpB_CLKin = PhaseOffset;
         if(inst->PhaseStpB_CLKin > PhaseAtMaxStp) inst->PhaseStpB_CLKin = PhaseAtMaxStp;
      }
      else{
         if(inst->PhaseStpB_CLKin < PhaseAtMaxStp) inst->PhaseStpB_CLKin = PhaseAtMaxStp;
         if(inst->PhaseStpB_CLKin > PhaseOffset) inst->PhaseStpB_CLKin = PhaseOffset;
      }

      // Calculate inst->PhaseStpC_CLKin
      inst->PhaseStpC_CLKin = PhaseStpC*v2degree+PhaseOffset;  // Phase setpoint C at clock edge
      if (v2degree >= 0){
         if(inst->PhaseStpC_CLKin < PhaseOffset) inst->PhaseStpC_CLKin = PhaseOffset;
         if(inst->PhaseStpC_CLKin > PhaseAtMaxStp) inst->PhaseStpC_CLKin = PhaseAtMaxStp;
      }
      else{
         if(inst->PhaseStpC_CLKin < PhaseAtMaxStp) inst->PhaseStpC_CLKin = PhaseAtMaxStp;
         if(inst->PhaseStpC_CLKin > PhaseOffset) inst->PhaseStpC_CLKin = PhaseOffset;
      }

      // Calculate inst->PhaseStpD_CLKin
      inst->PhaseStpD_CLKin = PhaseStpD*v2degree+PhaseOffset;  // Phase setpoint D at clock edge
      if (v2degree >= 0){
         if(inst->PhaseStpD_CLKin < PhaseOffset) inst->PhaseStpD_CLKin = PhaseOffset;
         if(inst->PhaseStpD_CLKin > PhaseAtMaxStp) inst->PhaseStpD_CLKin = PhaseAtMaxStp;
      }
      else{
         if(inst->PhaseStpD_CLKin < PhaseAtMaxStp) inst->PhaseStpD_CLKin = PhaseAtMaxStp;
         if(inst->PhaseStpD_CLKin > PhaseOffset) inst->PhaseStpD_CLKin = PhaseOffset;
      }

      CLKa = 1;               // Set CLKa
      _A = 0;                 // Reset complementary output _A
      inst->lastT_CLKa = t;   // Update last CLKa time
      inst->triggredB = 0;    // Reset CLKb trigger flag
      inst->triggredC = 0;    // Reset CLKc trigger flag
      inst->triggredD = 0;    // Reset CLKd trigger flag
      inst->nCLKa++;          // Increment CLKa edge counter
   }
   double TfromCLKa = t-inst->lastT_CLKa; // TfromCLKa : time since last CLKa

   // action at phase shifted CLKb
   double TphaseB = inst->PhaseStpB_CLKin/360*inst->CLKperiod;   // Calculate time to PhaseStpB
   if (TfromCLKa >= TphaseB & !inst->triggredB) // Check if time for phase-shifted pulse
   {
      CLKb = 1;               // Set CLKb
      _B = 0;                 // Reset complementary output _B
      inst->lastT_CLKb = t;   // Update last CLKb time
      inst->triggredB = 1;    // Set CLKb trigger flag
      inst->nCLKb++;          // Increment CLKb edge counter
   }
   double TfromCLKb = t-inst->lastT_CLKb; // TfromCLKb : time since last CLKb

   // action at phase shifted CLKc
   double TphaseC = inst->PhaseStpC_CLKin/360*inst->CLKperiod;   // Calculate time to PhaseStpC
   if (TfromCLKa >= TphaseC & !inst->triggredC) // Check if time for phase-shifted pulse
   {
      CLKc = 1;               // Set CLKc
      _C = 0;                 // Reset complementary output _C
      inst->lastT_CLKc = t;   // Update last CLKc time
      inst->triggredC = 1;    // Set CLKc trigger flag
      inst->nCLKc++;          // Increment CLKc edge counter
   }
   double TfromCLKc = t-inst->lastT_CLKc; // TfromCLKc : time since last CLKc

   // action at phase shifted CLKd
   double TphaseD = inst->PhaseStpD_CLKin/360*inst->CLKperiod;   // Calculate time to PhaseStpD
   if (TfromCLKa >= TphaseD & !inst->triggredD) // Check if time for phase-shifted pulse
   {
      CLKd = 1;               // Set CLKd
      _D = 0;                 // Reset complementary output _D
      inst->lastT_CLKd = t;   // Update last CLKd time
      inst->triggredD = 1;    // Set CLKd trigger flag
      inst->nCLKd++;          // Increment CLKd edge counter
   }
   double TfromCLKd = t-inst->lastT_CLKd; // TfromCLKd : time since last CLKd

   // Generate Phase-Shifted Output
   if(inst->nCLKa >= 2) // Only generate outputs after 2 clock pulse from CLKa
   {
      // Generate A pulse with deadtime
      if(TfromCLKa > deadtime & !A) A=1;           // Turn on A after deadtime
      if(TfromCLKa > inst->CLKperiod/2 & A) A=0;   // Turn off A at half period

      // Generate _A pulse with deadtime
      if(TfromCLKa > inst->CLKperiod/2 + deadtime & !_A) _A=1; // Turn on _A after 1/2 period + deadtime
   }
   if(inst->nCLKb >= 2) // Only generate outputs after 2 clock pulse from CLKb
   {
      // Generate B pulse with deadtime
      if(TfromCLKb > deadtime & !B) B=1;           // Turn on B after deadtime
      if(TfromCLKb > inst->CLKperiod/2 & B) B=0;   // Turn off B at half period

      // Generate _B pulse with deadtime
      if(TfromCLKb > inst->CLKperiod/2 + deadtime & !_B) _B=1; // Turn on _B after 1/2 period + deadtime
   }
   if(inst->nCLKc >= 2) // Only generate outputs after 2 clock pulse from CLKc
   {
      // Generate C pulse with deadtime
      if(TfromCLKc > deadtime & !C) C=1;           // Turn on C after deadtime
      if(TfromCLKc > inst->CLKperiod/2 & C) C=0;   // Turn off C at half period

      // Generate _C pulse with deadtime
      if(TfromCLKc > inst->CLKperiod/2 + deadtime & !_C) _C=1; // Turn on _C after 1/2 period + deadtime
   }
   if(inst->nCLKd >= 2) // Only generate outputs after 2 clock pulse from CLKd
   {
      // Generate D pulse with deadtime
      if(TfromCLKd > deadtime & !D) D=1;           // Turn on D after deadtime
      if(TfromCLKd > inst->CLKperiod/2 & D) D=0;   // Turn off D at half period

      // Generate _D pulse with deadtime
      if(TfromCLKd > inst->CLKperiod/2 + deadtime & !_D) _D=1; // Turn on _D after 1/2 period + deadtime
   }

   // Update previous state variables
   inst->lastCLKmaster = inst->CLKmaster;
   inst->lastT = t;

   // Remember output states
   inst->lastA = A;
   inst->last_A = _A;
   inst->lastB = B;
   inst->last_B = _B;
   inst->lastC = C;
   inst->last_C = _C;
   inst->lastD = D;
   inst->last_D = _D;
   inst->lastCLKa = CLKa;
   inst->lastCLKb = CLKb;
   inst->lastCLKc = CLKc;
   inst->lastCLKd = CLKd;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sPHASESHIFTPWM360_4OUTPUTS *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sPHASESHIFTPWM360_4OUTPUTS
}

extern "C" __declspec(dllexport) void Trunc(struct sPHASESHIFTPWM360_4OUTPUTS *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sPHASESHIFTPWM360_4OUTPUTS
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sPHASESHIFTPWM360_4OUTPUTS tmp = *inst;
      phaseshiftpwm360_4outputs(&(&tmp), t, data);

      if((tmp.lastA != inst->lastA)|(tmp.last_A != inst->last_A)|
         (tmp.lastB != inst->lastB)|(tmp.last_B != inst->last_B)|
         (tmp.lastC != inst->lastC)|(tmp.last_C != inst->last_C)|
         (tmp.lastD != inst->lastD)|(tmp.last_D != inst->last_D)|
         (tmp.lastCLKa != inst->lastCLKa)|(tmp.lastCLKb != inst->lastCLKb)|
         (tmp.lastCLKc != inst->lastCLKc)|(tmp.lastCLKd != inst->lastCLKd))
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sPHASESHIFTPWM360_4OUTPUTS *inst)
{
   free(inst);
}
