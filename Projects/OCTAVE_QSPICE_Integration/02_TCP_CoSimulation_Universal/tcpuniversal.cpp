// QSPICE Native Berkeley Socket API Client for MATLAB/Octave Universal Co-Simulation
//
// Block Name: TcpUniversal
//   Inputs     : in1 .. in8               (data[0]  .. data[7])
//   Parameters : TcpParam1 .. TcpParam8   (data[8]  .. data[15])
//                Ts                       (data[16])
//   Outputs    : out1 .. out8             (data[17] .. data[24])
//
// Binary Protocol (Little-Endian, 127.0.0.1:55000):
//   Send to MATLAB/Octave (156 bytes):
//     - 4 bytes   (int32)   : Command code (PORT_EVALUATE = 2)
//     - 152 bytes (19x f64) : [t, in1..in8, TcpParam1..TcpParam8, Ts, rst]
//   Receive from MATLAB/Octave (64 bytes):
//     - 64 bytes  (8x f64)  : [out1..out8]
//
// To build with Digital Mars C++ Compiler (or right-click -> Compile C++ in QSPICE):
//
//    dmc -mn -WD -o tcpuniversal.cpp kernel32.lib

#include <malloc.h>

// 1. QSPICE Built-in Berkeley Socket API Declarations
#define PORT_EVALUATE      2
#define PORT_MAX_STEPSIZE  3
#define PORT_TRUNCATE      4
// Function pointers populated automatically by QSPICE when loading the DLL
extern "C" __declspec(dllexport) unsigned int (*BerkeleySocket)(const char *hostPortServiceString, int Ninputs, int Noutputs, unsigned char **buffer) = 0;
extern "C" __declspec(dllexport) int (*SocketSend)(unsigned int socket, unsigned char *buffer, int count) = 0;
extern "C" __declspec(dllexport) int (*SocketRecv)(unsigned int socket, unsigned char *buffer, int count) = 0;
extern "C" __declspec(dllexport) void (*SocketClose)(unsigned int socket) = 0;
extern "C" __declspec(dllexport) double *(*ConfigureBuffer)(unsigned char *buffer, int code) = 0;

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
#undef in1
#undef in2
#undef in3
#undef in4
#undef in5
#undef in6
#undef in7
#undef in8
#undef out1
#undef out2
#undef out3
#undef out4
#undef out5
#undef out6
#undef out7
#undef out8

struct sTCPUNIVERSAL
{
   // declare the structure here
   unsigned int   socket;          // QSPICE Berkeley socket handle
   unsigned char *buffer;          // Packet buffer allocated by BerkeleySocket()
   double         nextSampleTime;  // Next scheduled discrete sampling timestamp (s)
   bool           latch;           // Edge-detection flag used by Trunc()
   bool           hasStarted;      // false on first step of every new simulation
};

extern "C" __declspec(dllexport) void tcpuniversal(struct sTCPUNIVERSAL **opaque, double t, union uData *data)
{
   double  in1       = data[ 0].d; // input
   double  in2       = data[ 1].d; // input
   double  in3       = data[ 2].d; // input
   double  in4       = data[ 3].d; // input
   double  in5       = data[ 4].d; // input
   double  in6       = data[ 5].d; // input
   double  in7       = data[ 6].d; // input
   double  in8       = data[ 7].d; // input
   double  Ts        = data[ 8].d; // input parameter
   double  TcpParam1 = data[ 9].d; // input parameter
   double  TcpParam2 = data[10].d; // input parameter
   double  TcpParam3 = data[11].d; // input parameter
   double  TcpParam4 = data[12].d; // input parameter
   double  TcpParam5 = data[13].d; // input parameter
   double  TcpParam6 = data[14].d; // input parameter
   double  TcpParam7 = data[15].d; // input parameter
   double  TcpParam8 = data[16].d; // input parameter
   double &out1      = data[17].d; // output
   double &out2      = data[18].d; // output
   double &out3      = data[19].d; // output
   double &out4      = data[20].d; // output
   double &out5      = data[21].d; // output
   double &out6      = data[22].d; // output
   double &out7      = data[23].d; // output
   double &out8      = data[24].d; // output

   if(!*opaque)
   {
      *opaque = (struct sTCPUNIVERSAL *) malloc(sizeof(struct sTCPUNIVERSAL));
      bzero(*opaque, sizeof(struct sTCPUNIVERSAL));

      // Connect to manually started MATLAB/Octave server on 127.0.0.1:55000
      // Ninputs  = 18 (in1..in8, TcpParam1..TcpParam8, Ts, rst)  [plus t -> 19 doubles]
      // Noutputs = 8  (out1..out8)
      struct sTCPUNIVERSAL *initInst = *opaque;
      initInst->socket = BerkeleySocket("localhost:55000", 18, 8, &initInst->buffer);
      if (!initInst->socket || !initInst->buffer)
      {
         EXIT("Failed to connect to MATLAB/Octave server on localhost:55000.\nStart matlab_tcp_universal_server_java.m or octave_tcp_universal_server_tcpserver.m first!\n");
         return;
      }
   }
   struct sTCPUNIVERSAL *inst = *opaque;

// Implement module evaluation code here:
   inst->latch = false;

   // Sample signals at discrete sampling period Ts
   if (t >= inst->nextSampleTime)
   {
      inst->latch = true;

      // Only communicate with MATLAB/Octave on accepted (non-hypothetical) timesteps
      if (*ForKeeps)
      {
         inst->nextSampleTime += Ts;

         // Format packet: [int32 PORT_EVALUATE][19 doubles] = 156 bytes
         double *d = ConfigureBuffer(inst->buffer, PORT_EVALUATE);
         d[0]  = t;
         d[1]  = in1;
         d[2]  = in2;
         d[3]  = in3;
         d[4]  = in4;
         d[5]  = in5;
         d[6]  = in6;
         d[7]  = in7;
         d[8]  = in8;
         d[9]  = TcpParam1;
         d[10] = TcpParam2;
         d[11] = TcpParam3;
         d[12] = TcpParam4;
         d[13] = TcpParam5;
         d[14] = TcpParam6;
         d[15] = TcpParam7;
         d[16] = TcpParam8;
         d[17] = Ts;
         d[18] = inst->hasStarted ? 0.0 : 1.0; // Send rst = 1.0 on first step of each run
         inst->hasStarted = true;

         int sendBytes = sizeof(int) + 19 * sizeof(double);
         if (SocketSend(inst->socket, inst->buffer, sendBytes) <= 0)
         {
            EXIT("SocketSend to MATLAB/Octave failed.\n");
            return;
         }

         // Receive 8 doubles (64 bytes) containing outputs out1..out8
         int recvBytes = 8 * sizeof(double);
         if (SocketRecv(inst->socket, inst->buffer, recvBytes) <= 0)
         {
            EXIT("SocketRecv from MATLAB/Octave failed.\n");
            return;
         }

         double *rx = (double *)inst->buffer;
         out1 = rx[0];
         out2 = rx[1];
         out3 = rx[2];
         out4 = rx[3];
         out5 = rx[4];
         out6 = rx[5];
         out7 = rx[6];
         out8 = rx[7];
      }
   }
}

extern "C" __declspec(dllexport) double MaxExtStepSize(struct sTCPUNIVERSAL *inst, double t)
{
   return 1e308; // implement a good choice of max timestep size that depends on struct sTCPUNIVERSAL
}

extern "C" __declspec(dllexport) void Trunc(struct sTCPUNIVERSAL *inst, double t, union uData *data, double *timestep)
{ // limit the timestep to a tolerance if the circuit causes a change in struct sTCPUNIVERSAL
   const double ttol = 1e-9; // 1ns default tolerance
   if(*timestep > ttol)
   {
      struct sTCPUNIVERSAL tmp = *inst;
      tcpuniversal(&(&tmp), t, data);
      if (tmp.latch != inst->latch)
         *timestep = ttol;
   }
}

extern "C" __declspec(dllexport) void Destroy(struct sTCPUNIVERSAL *inst)
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
