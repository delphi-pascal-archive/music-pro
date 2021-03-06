{
  BASSASIO 1.0 Delphi unit
  Copyright (c) 2005-2009 Un4seen Developments Ltd.

  See the BASSASIO.CHM file for more detailed documentation
}

unit BassASIO;

interface

uses Windows;

const
  BASSASIOVERSION = $100;             // API version

  // error codes returned by BASS_ASIO_ErrorGetCode
  BASS_OK                = 0; // all is OK
  BASS_ERROR_DRIVER      = 3; // can't find a free/valid driver
  BASS_ERROR_FORMAT      = 6; // unsupported sample format
  BASS_ERROR_INIT        = 8; // BASS_ASIO_Init has not been successfully called
  BASS_ERROR_START       = 9; // BASS_ASIO_Start has/hasn't been called
  BASS_ERROR_ALREADY     = 14; // already initialized/started
  BASS_ERROR_NOCHAN      = 18; // no channels are enabled
  BASS_ERROR_ILLPARAM    = 20; // an illegal parameter was specified
  BASS_ERROR_DEVICE      = 23; // illegal device number
  BASS_ERROR_NOTAVAIL    = 37; // not available
  BASS_ERROR_UNKNOWN     = -1; // some other mystery error

  // sample formats
  BASS_ASIO_FORMAT_16BIT = 16; // 16-bit integer
  BASS_ASIO_FORMAT_24BIT = 17; // 24-bit integer
  BASS_ASIO_FORMAT_32BIT = 18; // 32-bit integer
  BASS_ASIO_FORMAT_FLOAT = 19; // 32-bit floating-point

  // BASS_ASIO_ChannelReset flags
  BASS_ASIO_RESET_ENABLE = 1;  // disable channel
  BASS_ASIO_RESET_JOIN   = 2;  // unjoin channel
  BASS_ASIO_RESET_PAUSE  = 4;  // unpause channel
  BASS_ASIO_RESET_FORMAT = 8;  // reset sample format to native format
  BASS_ASIO_RESET_RATE   = 16; // reset sample rate to device rate
  BASS_ASIO_RESET_VOLUME = 32; // reset volume to 1.0

  // BASS_ASIO_ChannelIsActive return values
  BASS_ASIO_ACTIVE_DISABLED = 0;
  BASS_ASIO_ACTIVE_ENABLED  = 1;
  BASS_ASIO_ACTIVE_PAUSED   = 2;


type
  DWORD = Cardinal;
  BOOL = LongBool;
  FLOAT = Single;

  // device info structure
  BASS_ASIO_DEVICEINFO = record
    name: PAnsiChar;        // description
    driver: PAnsiChar;      // driver
  end;

  BASS_ASIO_INFO = record
	name: array[0..31] of AnsiChar;	// driver name
	version: DWORD;	            // driver version
	inputs: DWORD;
	outputs: DWORD;
	bufmin: DWORD;
	bufmax: DWORD;
	bufpref: DWORD;
	bufgran: integer;
  end;

  BASS_ASIO_CHANNELINFO = record
	group: DWORD;
	format: DWORD;	            // sample format (BASS_ASIO_FORMAT_xxx)
	name: array[0..31] of AnsiChar;	// channel name
  end;

  ASIOPROC = function(input:BOOL; channel:DWORD; buffer:Pointer; length:DWORD; user:Pointer): DWORD; stdcall;
  {
    ASIO channel callback function.
    input  : input? else output
    channel: channel number
    buffer : Buffer containing the sample data
    length : Number of bytes
    user   : The 'user' parameter given when calling BASS_ASIO_ChannelEnable
    RETURN : The number of bytes written (ignored with input channels)
  }


const
  bassasiodll = 'bassasio.dll';

function BASS_ASIO_GetVersion: DWORD; stdcall; external bassasiodll;
function BASS_ASIO_ErrorGetCode(): DWORD; stdcall; external bassasiodll;
function BASS_ASIO_GetDeviceInfo(device:DWORD; var info:BASS_ASIO_DEVICEINFO): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_SetDevice(device:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_GetDevice(): DWORD; stdcall; external bassasiodll;
function BASS_ASIO_Init(device:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_Free(): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ControlPanel(): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_GetInfo(var info:BASS_ASIO_INFO): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_SetRate(rate:double): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_GetRate(): double; stdcall; external bassasiodll;
function BASS_ASIO_Start(buflen:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_Stop(): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_IsStarted(): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_GetLatency(input:BOOL): DWORD; stdcall; external bassasiodll;
function BASS_ASIO_GetCPU(): float; stdcall; external bassasiodll;
function BASS_ASIO_Monitor(input:Integer; output,gain,state,pan:DWORD): BOOL; stdcall; external bassasiodll;

function BASS_ASIO_ChannelGetInfo(input:BOOL; channel:DWORD; var info:BASS_ASIO_CHANNELINFO): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelReset(input:BOOL; channel:Integer; flags:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelEnable(input:BOOL; channel:DWORD; proc:ASIOPROC; user:Pointer): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelEnableMirror(channel:DWORD; input2:BOOL; channel2:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelJoin(input:BOOL; channel:DWORD; channel2:Integer): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelPause(input:BOOL; channel:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelIsActive(input:BOOL; channel:DWORD): DWORD; stdcall; external bassasiodll;
function BASS_ASIO_ChannelSetFormat(input:BOOL; channel:DWORD; format:DWORD): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelGetFormat(input:BOOL; channel:DWORD): DWORD; stdcall; external bassasiodll;
function BASS_ASIO_ChannelSetRate(input:BOOL; channel:DWORD; rate:double): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelGetRate(input:BOOL; channel:DWORD): double; stdcall; external bassasiodll;
function BASS_ASIO_ChannelSetVolume(input:BOOL; channel:Integer; volume:single): BOOL; stdcall; external bassasiodll;
function BASS_ASIO_ChannelGetVolume(input:BOOL; channel:Integer): single; stdcall; external bassasiodll;
function BASS_ASIO_ChannelGetLevel(input:BOOL; channel:DWORD): single; stdcall; external bassasiodll;

implementation

end.
