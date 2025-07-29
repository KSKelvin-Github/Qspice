// Automatically generated C++ file on Tue Jul 29 10:40:07 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD phaseshiftpwm.cpp kernel32.lib

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
extern "C" __declspec(dllexport) const int *CKTnoncon                           = 0;
extern "C" __declspec(dllexport) const char *(*BinaryFormat)(unsigned int data) = 0; // BinaryFormat(0x1C) returns "0b00011100"
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
#undef A
#undef _A
#undef B
#undef _B
#undef CLKa
#undef CLKb

struct sPHASESHIFTPWM
{
  // declare the structure here
  bool init;             // Initialization flag (true after first setup)
  double lastT;          // Timestamp of the previous processing cycle
  double lastT_CLKint;   // Timestamp of the previous internal clock
  bool CLKmaster;        // Master clock
  bool lastCLKmaster;    // Previous state of the master clock (for edge detection)
  double nCLKa;          // Counter for number of CLKa pulses generated
  double nCLKb;          // Counter for number of CLKb pulses generated
  double lastT_CLKa;     // Timestamp of the last CLKa rising edge
  double lastT_CLKb;     // Timestamp of the last CLKb rising edge
  bool triggredB;        // Flag indicating if CLKb has been triggered in current cycle
  double CLKperiod;      // Measured period of the input clock signal
  double PhaseStpB_CLKin;// Phase septoint B sampled at CLKin rising edge
  bool lastA;            // Previous state of output A (for edge detection/state tracking)
  bool last_A;           // Previous state of complementary output _A
  bool lastB;            // Previous state of output B
  bool last_B;           // Previous state of complementary output _B
  bool lastCLKa;         // Previous state of CLKa signal
  bool lastCLKb;         // Previous state of CLKb signal
};

extern "C" __declspec(dllexport) void phaseshiftpwm(struct sPHASESHIFTPWM **opaque, double t, union uData *data)
{
   bool   CLKext      = data[ 0].b; // input
   double PhaseStpB   = data[ 1].d; // input
   double deadtime    = data[ 2].d; // input parameter
   bool   intCLK      = data[ 3].b; // input parameter
   double fsw         = data[ 4].d; // input parameter
   double PhaseAtVmin = data[ 5].d; // input parameter
   double PhaseAtVmax = data[ 6].d; // input parameter
   double v2degree    = data[ 7].d; // input parameter
   bool  &A           = data[ 8].b; // output
   bool  &_A          = data[ 9].b; // output
   bool  &B           = data[10].b; // output
   bool  &_B          = data[11].b; // output
   bool  &CLKa        = data[12].b; // output
   bool  &CLKb        = data[13].b; // output

   if(!*opaque)
   {
      *opaque = (struct sPHASESHIFTPWM *) malloc(sizeof(struct sPHASESHIFTPWM));
      bzero(*opaque, sizeof(struct sPHASESHIFTPWM));
   }
   struct sPHASESHIFTPWM *inst = *opaque;

// Implement module evaluation code here:

   // Initialization
   if(*ForKeeps & !inst->init)  // Check if initialization is not done yet
   {
      A = 0; _A = 0;
      B = 0; _B = 0;
      inst->nCLKa = 0;
      inst->nCLKb = 0;
      inst->init = true;  // Mark initialization as complete
      if(!intCLK) Display("External Clock is Enabled, CLKext determines Switching Frequency\n");
      else Display("Internal Clock is Enabled, Switching Frequency (fsw) = %.0fkHz\n",fsw/1e3);
   }

   // Reset CLKa and CLKb
   CLKa=0;  // Clear CLKa pulse signal
   CLKb=0;  // Clear CLKb pulse signal

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

      // Determine sign of slope (v2degree) based on PhaseAtVmax and PhaseAtVmin
      if(PhaseAtVmax > PhaseAtVmin & v2degree < 0) v2degree = -v2degree;
      if(PhaseAtVmax < PhaseAtVmin & v2degree > 0) v2degree = -v2degree;
      if(PhaseAtVmin > 359) PhaseAtVmin=359;
      if(PhaseAtVmax > 359) PhaseAtVmax=359;

      // Calculate inst->PhaseStpB_CLKin
      inst->PhaseStpB_CLKin = PhaseStpB*v2degree+PhaseAtVmin;  // Phase setpoint B at clock edge
      if (v2degree >= 0){
         if(inst->PhaseStpB_CLKin < PhaseAtVmin) inst->PhaseStpB_CLKin = PhaseAtVmin;
         if(inst->PhaseStpB_CLKin > PhaseAtVmax) inst->PhaseStpB_CLKin = PhaseAtVmax;
      }
      else{
         if(inst->PhaseStpB_CLKin < PhaseAtVmax) inst->PhaseStpB_CLKin = PhaseAtVmax;
         if(inst->PhaseStpB_CLKin > PhaseAtVmin) inst->PhaseStpB_CLKin = PhaseAtVmin;
      }

      CLKa = 1;               // Set CLKa
      _A = 0;                 // Reset complementary output _A
      inst->lastT_CLKa = t;   // Update last CLKa time
      inst->triggredB = 0;    // Reset CLKb trigger flag
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

   // Update previous state variables
   inst->lastCLKmaster = inst->CLKmaster;
   inst->lastT = t;

   // Remember output states
   inst->lastA = A;
   inst->last_A = _A;
   inst->lastB = B;
   inst->last_B = _B;
   inst->lastCLKa = CLKa;
   inst->lastCLKb = CLKb;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sPHASESHIFTPWM *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sPHASESHIFTPWM
}

extern "C" __declspec(dllexport) void Trunc(struct sPHASESHIFTPWM *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sPHASESHIFTPWM
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sPHASESHIFTPWM tmp = *inst;
      phaseshiftpwm(&(&tmp), t, data);

      if((tmp.lastA != inst->lastA)|(tmp.last_A != inst->last_A)|
         (tmp.lastB != inst->lastB)|(tmp.last_B != inst->last_B)|
         (tmp.lastCLKa != inst->lastCLKa)|(tmp.lastCLKb != inst->lastCLKb))
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sPHASESHIFTPWM *inst)
{
   free(inst);
}
