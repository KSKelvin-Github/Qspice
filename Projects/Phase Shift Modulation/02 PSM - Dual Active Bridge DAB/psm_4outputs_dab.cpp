// Automatically generated C++ file on Tue Aug 19 10:30:19 2025
//
// To build with Digital Mars C++ Compiler:
//
//    dmc -mn -WD psm_4outputs_dab.cpp kernel32.lib

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
#undef CLKr
#undef PhBdeg
#undef PhCdeg
#undef PhDdeg
#undef debug1
#undef debug2

struct sPSM_4OUTPUTS_DAB
{
  // declare the structure here
  bool init;             // Initialization flag (true after first setup)
  double lastT;          // Timestamp of the previous processing cycle
  double lastT_CLKint;   // Timestamp of the previous internal clock
  bool CLKmaster;        // Master clock
  bool lastCLKmaster;    // Previous state of the master clock (for edge detection)
  unsigned int nCLKr;    // Counter for number of CLKa pulses generated
  unsigned int nCLKa;    // Counter for number of CLKa pulses generated
  unsigned int nCLKb;    // Counter for number of CLKb pulses generated
  unsigned int nCLKc;    // Counter for number of CLKc pulses generated
  unsigned int nCLKd;    // Counter for number of CLKd pulses generated
  double lastT_CLKr;     // Timestamp of the last CLKr rising edge
  double lastT_CLKa;     // Timestamp of the last CLKa rising edge
  double lastT_CLKb;     // Timestamp of the last CLKb rising edge
  double lastT_CLKc;     // Timestamp of the last CLKc rising edge
  double lastT_CLKd;     // Timestamp of the last CLKd rising edge
  bool triggeredA;       // Flag indicating if CLKa has been triggered in current cycle
  bool triggeredB;       // Flag indicating if CLKb has been triggered in current cycle
  bool triggeredC;       // Flag indicating if CLKc has been triggered in current cycle
  bool triggeredD;       // Flag indicating if CLKd has been triggered in current cycle
  double CLKperiod;      // Measured period of the input clock signal
  double PhaseStpB_CLK;  // Phase septoint B sampled at CLK rising edge
  double PhaseStpC_CLK;  // Phase septoint C sampled at CLK rising edge
  double PhaseStpD_CLK;  // Phase septoint D sampled at CLK rising edge
  bool lastA;            // Previous state of output A (for edge detection/state tracking)
  bool last_A;           // Previous state of complementary output _A
  bool lastB;            // Previous state of output B
  bool last_B;           // Previous state of complementary output _B
  bool lastC;            // Previous state of output C
  bool last_C;           // Previous state of complementary output _C
  bool lastD;            // Previous state of output D
  bool last_D;           // Previous state of complementary output _D
  bool lastCLKr;         // Previous state of CLKr signal
  bool lastCLKa;         // Previous state of CLKa signal
  bool lastCLKb;         // Previous state of CLKb signal
  bool lastCLKc;         // Previous state of CLKc signal
  bool lastCLKd;         // Previous state of CLKd signal
  bool NoWarning;        // NoWarning message is required
};

extern "C" __declspec(dllexport) void psm_4outputs_dab(struct sPSM_4OUTPUTS_DAB **opaque, double t, union uData *data)
{
   bool    CLKext         = data[ 0].b; // input
   double  PhaseStpB      = data[ 1].d; // input
   double  PhaseStpC      = data[ 2].d; // input
   double  PhaseStpD      = data[ 3].d; // input
   bool    ConsoleDisplay = data[ 4].b; // input parameter
   double  deadtime       = data[ 5].d; // input parameter
   bool    intCLK         = data[ 6].b; // input parameter
   double  fsw            = data[ 7].d; // input parameter
   double  minPhaseStp    = data[ 8].d; // input parameter
   double  v2degree       = data[ 9].d; // input parameter
   bool   &A              = data[10].b; // output
   bool   &_A             = data[11].b; // output
   bool   &B              = data[12].b; // output
   bool   &_B             = data[13].b; // output
   bool   &C              = data[14].b; // output
   bool   &_C             = data[15].b; // output
   bool   &D              = data[16].b; // output
   bool   &_D             = data[17].b; // output
   bool   &CLKa           = data[18].b; // output
   bool   &CLKb           = data[19].b; // output
   bool   &CLKc           = data[20].b; // output
   bool   &CLKd           = data[21].b; // output
   bool   &CLKr           = data[22].b; // output
   double &PhBdeg         = data[23].d; // output
   double &PhCdeg         = data[24].d; // output
   double &PhDdeg         = data[25].d; // output
   double &debug1         = data[26].d; // output
   double &debug2         = data[27].d; // output

   if(!*opaque)
   {
      *opaque = (struct sPSM_4OUTPUTS_DAB *) malloc(sizeof(struct sPSM_4OUTPUTS_DAB));
      bzero(*opaque, sizeof(struct sPSM_4OUTPUTS_DAB));
   }
   struct sPSM_4OUTPUTS_DAB *inst = *opaque;

// Implement module evaluation code here:
   // Phase Shift Control System
   //
   // Key Concepts:
   // 1. A reference clock (CLKr) is generated from either external or internal source
   // 2. Outputs C can be phase-shifted relative to CLKr
   // 3. minPhaseStp allows negative phase shifts by pre-shifting Output A relative to CLKr
   // 4. Phase shifts of C is clamped to 0°-359° relative to CLKr
   // 5. Outputs B is relative to CLKa, Output D is relative to CLKc, only from 0°-360° (not support -ve phase setpoint)


   // Initialization Block - Runs once at startup
   if(*ForKeeps & !inst->init)  // Check if initialization is not done yet
   {
      // Reset all outputs and counters
      A = 0; _A = 0;
      B = 0; _B = 0;
      C = 0; _C = 0;
      D = 0; _D = 0;

      // Reset clock edge counters
      inst->nCLKa = 0; inst->nCLKb = 0;
      inst->nCLKc = 0; inst->nCLKd = 0;

      inst->CLKperiod = 0; // Initialize clock period
      inst->init = true;   // Mark initialization as complete

      // Display configuration
      Display("Phase-Shift Modulation DLL Module\n");
      Display(" - Output C with phase setpoint reference to A [minPhaseStp,minPhaseStp+360°)\n");
      Display(" - Output B with phase setpoint reference to A [0°,360°)\n");
      Display(" - Output D with phase setpoint reference to C [0°,360°)\n");
      Display("PSM Configuration:\n");
      if(!intCLK) Display(" - External Clock Mode, CLKext drives Switching Frequency\n");
      else Display(" - Internal Clock Mode, Switching Frequency (fsw) = %.0fkHz\n",fsw/1e3);


      Display(" - minPhaseStp=%.0f°: Output A leads reference clock CLKr by %.0f°\n",minPhaseStp,-minPhaseStp);
      Display(" - v2degree=%.0f°: PhaseStp(°)=%.0f°*PhaseStp(V)\n",v2degree,v2degree);
      Display(" - Valid Phase Setpoint Range for C(toA): [%.0f°,%.0f°)\n",minPhaseStp,minPhaseStp+360);
      Display(" - Valid Phase Setpoint Range for B(toA),D(toC) : [0°,360°)\n");
   }

   // Reset CLKa and CLKb
   CLKr=0;  // Clear CLKr pulse signal (Reference clock)
   CLKa=0;  // Clear CLKa pulse signal (Phase-shifted output A)
   CLKb=0;  // Clear CLKb pulse signal (Phase-shifted output B)
   CLKc=0;  // Clear CLKc pulse signal (Phase-shifted output C)
   CLKd=0;  // Clear CLKd pulse signal (Phase-shifted output D)

   // Clock Source Selection
   if(!intCLK) // External clock mode
   {
      inst->CLKmaster=CLKext; // Directly use external clock
   }
   else  // Internal clock generation
   {
      inst->CLKmaster=false;  // Start with clock low
      double TfromCLKint = t-inst->lastT_CLKint;   // Time since last internal clock edge

      // Generate clock pulse when period elapsed
      if(TfromCLKint >= 1/fsw)   // If elapsed time >= switching period
      {
         inst->CLKmaster=true;   // Rising edge
         inst->lastT_CLKint = t; // Update edge timestamp
      }
   }

   // Ensure v2degree conversion factor is positive
   if (v2degree < 0) v2degree = -v2degree;

   // Reference Clock (CLKr) Handling
   if(!inst->lastCLKmaster & inst->CLKmaster)  // Detect rising edge
   {
      // Calculate clock period (time between rising edges)
      inst->CLKperiod = t - inst->lastT_CLKr;

      // Generate reference clock pulse
      CLKr = 1;               // Set CLKr : Reference Clock
      inst->lastT_CLKr = t;   // Update last CLKr time
      inst->nCLKr++;          // Increment CLKr edge counter

      // C is reference to reference clock CLKr, as to achieve negative phase for C to A
      // Calculate phase setpoints relative to CLKr (with minPhaseStp offset)
      // Output C Phase Calculation (PhaseStpC reference to A, inst->PhaseStpC_CLK reference to CLKr)
      inst->PhaseStpC_CLK = PhaseStpC*v2degree-minPhaseStp;  // Phase setpoint C at clock edge, shift [-ve minPhaseStp]
      if (inst->PhaseStpC_CLK > 359) inst->PhaseStpC_CLK = 359;  // max phase = 359o
      if (inst->PhaseStpC_CLK < 0) inst->PhaseStpC_CLK = 0;      // min phase = 0o
      PhCdeg = inst->PhaseStpC_CLK+minPhaseStp;

      // Reset all trigger flags
      inst->triggeredA = 0;   // Reset CLKa trigger flag
      inst->triggeredC = 0;   // Reset CLKc trigger flag

      // Special handling for external clock first edge
      if(!intCLK & inst->nCLKr==1)
      {
         inst->CLKperiod=0;   // Discard first period measurement
         CLKr = 0;            // Suppress first pulse
      }

      // Diagnostic display
      if(ConsoleDisplay)
      {
         Display("t=%.15f, CLKfreq=%.1fkHz",t,1/inst->CLKperiod/1e3);
         Display(", PhB-A=%.1f°",PhBdeg);
         Display(", PhC-A=%.1f°",PhCdeg);
         Display(", PhD-C=%.1f°\n",PhDdeg);
      }
   }
   double TfromCLKr = t-inst->lastT_CLKr; // TfromCLKr : time since last CLKr (reference clock edge)

   // All outputs are reference to reference clock CLKr, as to achieve negative phase for B,C,D to A
   // Output A Generation (with minPhaseStp pre-shift, reference to CLKr)
   //    - pre-shift [-ve minPhaseStp] to reference clock (allow other outputs with negative phase to A)
   double TphaseA = -minPhaseStp/360.0*inst->CLKperiod;  // PhaseStpA pre-shift by minPhaseStp to reference clock
   if (TfromCLKr >= TphaseA & !inst->triggeredA)         // Check if time since last CLKr equal PhaseA setpoint time & Output A is not yet set
   {
      // Generate A clock pulse CLKa
      CLKa = 1;               // Set CLKa
      _A = 0;                 // Reset complementary output _A
      inst->lastT_CLKa = t;   // Update last CLKa time
      inst->triggeredA = 1;   // Reset CLKa trigger flag
      inst->nCLKa++;          // Increment CLKa edge counter

      // Output B Phase Calculation (PhaseStpB reference to A, inst->PhaseStpB_CLK reference to CLKa)
      inst->PhaseStpB_CLK = PhaseStpB*v2degree;  // Phase setpoint B at clock edge
      if (inst->PhaseStpB_CLK > 359) inst->PhaseStpB_CLK = 359;  // max phase = 359o
      if (inst->PhaseStpB_CLK < 0) inst->PhaseStpB_CLK = 0;      // min phase = 0o
      PhBdeg = inst->PhaseStpB_CLK;  // Absolute phase for display

      inst->triggeredB = 0;   // Reset CLKb trigger flag
   }
   double TfromCLKa = t-inst->lastT_CLKa; // TfromCLKa : time since last CLKa

   // Output B Generation (PhaseStpB reference to CLKa)
   double TphaseB = inst->PhaseStpB_CLK/360*inst->CLKperiod; // Calculate time to PhaseStpB
   if (TfromCLKa >= TphaseB & !inst->triggeredB)   // Check if time since last CLKa equal PhaseB setpoint time & Output B is not yet set
   {
      // Generate B clock pulse CLKb
      CLKb = 1;               // Set CLKb
      _B = 0;                 // Reset complementary output _B
      inst->lastT_CLKb = t;   // Update last CLKb time
      inst->triggeredB = 1;   // Set CLKb trigger flag
      inst->nCLKb++;          // Increment CLKb edge counter
   }
   double TfromCLKb = t-inst->lastT_CLKb; // TfromCLKb : time since last CLKb

   // Output C Generation (PhaseStpC reference to CLKr)
   double TphaseC = inst->PhaseStpC_CLK/360*inst->CLKperiod; // Calculate time to PhaseStpC
   if (TfromCLKr >= TphaseC & !inst->triggeredC)   // Check if time since last CLKr equal PhaseC setpoint time & Output C is not yet set
   {
      // Generate C clock pulse CLKc
      CLKc = 1;               // Set CLKc
      _C = 0;                 // Reset complementary output _C
      inst->lastT_CLKc = t;   // Update last CLKc time
      inst->triggeredC = 1;   // Set CLKc trigger flag
      inst->nCLKc++;          // Increment CLKc edge counter

      // Output D Phase Calculation (PhaseStpD reference to C, inst->PhaseStpD_CLK reference to CLKc)
      inst->PhaseStpD_CLK = PhaseStpD*v2degree;  // Phase setpoint D at clock edge
      if (inst->PhaseStpD_CLK > 359) inst->PhaseStpD_CLK = 359;  // max phase = 359o
      if (inst->PhaseStpD_CLK < 0) inst->PhaseStpD_CLK = 0;      // min phase = 0o
      PhDdeg = inst->PhaseStpD_CLK;

      inst->triggeredD = 0;   // Reset CLKd trigger flag
   }
   double TfromCLKc = t-inst->lastT_CLKc; // TfromCLKc : time since last CLKc

   // Output D Generation (PhaseStpD reference to CLKr)
   double TphaseD = inst->PhaseStpD_CLK/360*inst->CLKperiod; // Calculate time to PhaseStpD
   if (TfromCLKc >= TphaseD & !inst->triggeredD)   // Check if time since last CLKc equal PhaseD setpoint time & Output D is not yet set
   {
      // Generate D clock pulse CLKd
      CLKd = 1;               // Set CLKd
      _D = 0;                 // Reset complementary output _D
      inst->lastT_CLKd = t;   // Update last CLKd time
      inst->triggeredD = 1;   // Set CLKd trigger flag
      inst->nCLKd++;          // Increment CLKd edge counter
   }
   double TfromCLKd = t-inst->lastT_CLKd; // TfromCLKd : time since last CLKd

   // PWM Generation with Deadtime (for all outputs)
   if(inst->nCLKa >= 2) // Only generate outputs after 2 clock cycles from CLKa
   {
      // Generate A pulse with deadtime
      if(TfromCLKa > deadtime & !A) A=1;           // Turn on A after deadtime
      if(TfromCLKa > inst->CLKperiod/2 & A) A=0;   // Turn off A at half period

      // Generate _A pulse with deadtime
      if(TfromCLKa > inst->CLKperiod/2 + deadtime & !_A) _A=1; // Turn on _A after 1/2 period + deadtime
   }
   if(inst->nCLKb >= 2) // Only generate outputs after 2 clock cycles from CLKb
   {
      // Generate B pulse with deadtime
      if(TfromCLKb > deadtime & !B) B=1;           // Turn on B after deadtime
      if(TfromCLKb > inst->CLKperiod/2 & B) B=0;   // Turn off B at half period

      // Generate _B pulse with deadtime
      if(TfromCLKb > inst->CLKperiod/2 + deadtime & !_B) _B=1; // Turn on _B after 1/2 period + deadtime
   }
   if(inst->nCLKc >= 2) // Only generate outputs after 2 clock cycles from CLKc
   {
      // Generate C pulse with deadtime
      if(TfromCLKc > deadtime & !C) C=1;           // Turn on C after deadtime
      if(TfromCLKc > inst->CLKperiod/2 & C) C=0;   // Turn off C at half period

      // Generate _C pulse with deadtime
      if(TfromCLKc > inst->CLKperiod/2 + deadtime & !_C) _C=1; // Turn on _C after 1/2 period + deadtime
   }
   if(inst->nCLKd >= 2) // Only generate outputs after 2 clock cycles from CLKd
   {
      // Generate D pulse with deadtime
      if(TfromCLKd > deadtime & !D) D=1;           // Turn on D after deadtime
      if(TfromCLKd > inst->CLKperiod/2 & D) D=0;   // Turn off D at half period

      // Generate _D pulse with deadtime
      if(TfromCLKd > inst->CLKperiod/2 + deadtime & !_D) _D=1; // Turn on _D after 1/2 period + deadtime
   }

   // Safety Checks (run once after init)
   if(inst->init & !inst->NoWarning)
   {
      // warning if deadtime more than 80% > half of period
      if(deadtime >= inst->CLKperiod/2*0.8 & inst->CLKperiod > 0)
      {
         Display("Warning! Deadtime > 80% of half-period?!\n");
         inst->NoWarning = true;
      }
      // warning if deadtime less than 0
      if(deadtime < 0)
      {
         Display("Warning! Negative deadtime?!\n");
         inst->NoWarning = true;
      }
   }

   // Update previous state variables
   inst->lastCLKmaster = inst->CLKmaster;
   inst->lastT = t;

   // Store all output states for next cycle
   inst->lastA = A;
   inst->last_A = _A;
   inst->lastB = B;
   inst->last_B = _B;
   inst->lastC = C;
   inst->last_C = _C;
   inst->lastD = D;
   inst->last_D = _D;

   // Store clock states
   inst->lastCLKr = CLKr;
   inst->lastCLKa = CLKa;
   inst->lastCLKb = CLKb;
   inst->lastCLKc = CLKc;
   inst->lastCLKd = CLKd;
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sPSM_4OUTPUTS_DAB *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sPSM_4OUTPUTS_DAB
}

extern "C" __declspec(dllexport) void Trunc(struct sPSM_4OUTPUTS_DAB *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sPSM_4OUTPUTS_DAB
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sPSM_4OUTPUTS_DAB tmp = *inst;
      psm_4outputs_dab(&(&tmp), t, data);

      if((tmp.lastA != inst->lastA)|(tmp.last_A != inst->last_A)|
         (tmp.lastB != inst->lastB)|(tmp.last_B != inst->last_B)|
         (tmp.lastC != inst->lastC)|(tmp.last_C != inst->last_C)|
         (tmp.lastD != inst->lastD)|(tmp.last_D != inst->last_D)|
         (tmp.lastCLKr != inst->lastCLKr)|
         (tmp.lastCLKa != inst->lastCLKa)|(tmp.lastCLKb != inst->lastCLKb)|
         (tmp.lastCLKc != inst->lastCLKc)|(tmp.lastCLKd != inst->lastCLKd))
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sPSM_4OUTPUTS_DAB *inst)
{
   free(inst);
}
