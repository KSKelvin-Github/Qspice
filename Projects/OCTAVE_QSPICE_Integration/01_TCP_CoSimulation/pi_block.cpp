// QSPICE Native Berkeley Socket API Client for MATLAB Co-Simulation
//
// To build with Digital Mars C++ Compiler (or right-click -> Compile C++ in QSPICE):
//
//    dmc -mn -WD -o pi_block.cpp kernel32.lib

#include <malloc.h>

// =========================================================================
// 1. QSPICE Built-in Berkeley Socket API Declarations
// =========================================================================
#define PORT_EVALUATE      2
#define PORT_MAX_STEPSIZE  3
#define PORT_TRUNCATE      4
// Function pointers populated automatically by QSPICE when loading the DLL
extern "C" __declspec(dllexport) unsigned int (*BerkeleySocket)(const char *hostPortServiceString, int Ninputs, int Noutputs, unsigned char **buffer) = 0;
extern "C" __declspec(dllexport) int (*SocketSend)(unsigned int socket, unsigned char *buffer, int count) = 0;
extern "C" __declspec(dllexport) int (*SocketRecv)(unsigned int socket, unsigned char *buffer, int count) = 0;
extern "C" __declspec(dllexport) void (*SocketClose)(unsigned int socket) = 0;
extern "C" __declspec(dllexport) double *(*ConfigureBuffer)(unsigned char *buffer, int code) = 0;

// =========================================================================
// 2. QSPICE Simulator Global Pointers & Callback Hooks
// =========================================================================
extern "C" __declspec(dllexport) void (*Display)(const char *format, ...)       = 0;
extern "C" __declspec(dllexport) void (*EXIT)(const char *format, ...)          = 0;
extern "C" __declspec(dllexport) const double *DegreesC                         = 0;
extern "C" __declspec(dllexport) const int *StepNumber                          = 0;
extern "C" __declspec(dllexport) const int *NumberSteps                         = 0;
extern "C" __declspec(dllexport) const char* const *InstanceName                = 0;
extern "C" __declspec(dllexport) const char *QUX                                = 0;
extern "C" __declspec(dllexport) const bool *ForKeeps                           = 0;
extern "C" __declspec(dllexport) const bool *HoldICs                            = 0;
extern "C" __declspec(dllexport) const void *GUI_HWND                           = 0;
extern "C" __declspec(dllexport) const double *CKTtime                          = 0;
extern "C" __declspec(dllexport) const double *CKTdelta                         = 0;
extern "C" __declspec(dllexport) const int *IntegrationOrder                    = 0;
extern "C" __declspec(dllexport) const char *InstallDirectory                   = 0;
extern "C" __declspec(dllexport) double (*EngAtof)(const char **string)         = 0;
extern "C" __declspec(dllexport) const char *(*BinaryFormat)(unsigned int data)                          = 0;
extern "C" __declspec(dllexport) const char *(*EngFormat   )(double x, const char *units, int numDgts)   = 0;
extern "C" __declspec(dllexport) int (*DFFT)(struct sComplex *u, bool inv, unsigned int N, double scale) = 0;
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

int __stdcall DllMain(void *module, unsigned int reason, void *reserved) { return 1; }

#undef err
#undef u

// =========================================================================
// 3. Per-Instance State Structure
// =========================================================================
struct sPI_BLOCK
{
   unsigned int   socket;          // QSPICE Berkeley socket handle
   unsigned char *buffer;          // Packet buffer allocated by BerkeleySocket()
   double         nextSampleTime;  // Next scheduled discrete sampling timestamp (s)
   double         u_hold;          // Zero-order-hold output stored between sample instants
   bool           latch;           // Edge-detection flag used by Trunc()
   bool           hasStarted;     // false on first step of every new simulation
};

// =========================================================================
// 4. Main C-Block Evaluation Function
// =========================================================================
extern "C" __declspec(dllexport) void pi_block(struct sPI_BLOCK **opaque, double t, union uData *data)
{
   double  err = data[0].d; // input
   double  kp  = data[1].d; // input parameter
   double  ki  = data[2].d; // input parameter
   double  Ts  = data[3].d; // input parameter
   double &u   = data[4].d; // output

   // Allocate instance struct and open QSPICE Berkeley Socket once at t = 0
   if (!*opaque)
   {
      *opaque = (struct sPI_BLOCK *) malloc(sizeof(struct sPI_BLOCK));
      bzero(*opaque, sizeof(struct sPI_BLOCK));
      
      // Connect to manually started MATLAB server on 127.0.0.1:55000
      // Ninputs = 5 (err, kp, ki, Ts, rst), Noutputs = 1 (u)
      struct sPI_BLOCK *initInst = *opaque;
      initInst->socket = BerkeleySocket("localhost:55000", 5, 1, &initInst->buffer);
      if (!initInst->socket || !initInst->buffer)
      {
         EXIT("Failed to connect to MATLAB server on localhost:55000.\nStart matlab_tcp_server.m first!\n");
         return;
      }
   }
   struct sPI_BLOCK *inst = *opaque;

   inst->latch = false;

   // Sample control signals at discrete sampling period Ts
   if (t >= inst->nextSampleTime)
   {
      inst->latch = true;

      // Only communicate with MATLAB on accepted (non-hypothetical) timesteps
      if (*ForKeeps)
      {
         inst->nextSampleTime += Ts;

         // Format packet: [int32 PORT_EVALUATE][double t, err, kp, ki, Ts, rst] = 52 bytes
         double *d = ConfigureBuffer(inst->buffer, PORT_EVALUATE);
         d[0] = t;
         d[1] = err;
         d[2] = kp;
         d[3] = ki;
         d[4] = Ts;
         d[5] = inst->hasStarted ? 0.0 : 1.0; // Send rst = 1.0 on first step of each run
         inst->hasStarted = true;

         int sendBytes = sizeof(int) + 6 * sizeof(double);
         if (SocketSend(inst->socket, inst->buffer, sendBytes) <= 0)
         {
            EXIT("SocketSend to MATLAB failed.\n");
            return;
         }

         // Receive 1 double (8 bytes) containing controller output u
         if (SocketRecv(inst->socket, inst->buffer, sizeof(double)) <= 0)
         {
            EXIT("SocketRecv from MATLAB failed.\n");
            return;
         }

         u = *(double *)inst->buffer;
      }
   }
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sPI_BLOCK *inst, double t)
{
   return 1e308;
}

extern "C" __declspec(dllexport) void Trunc(struct sPI_BLOCK *inst, double t, union uData *data, double *timestep)
{
   const double ttol = 1e-9; // 1ns default tolerance
   if (*timestep > ttol)
   {
      struct sPI_BLOCK tmp = *inst;
      pi_block(&(&tmp), t, data);
      if (tmp.latch != inst->latch)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sPI_BLOCK *inst)
{
   // Close the TCP socket cleanly and release per-instance memory at simulation end
   if (inst)
   {
      if (inst->socket)
      {
         SocketClose(inst->socket);
      }
      free(inst);
   }
}
