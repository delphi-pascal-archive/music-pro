Unit Bass_VST;

interface

uses
  Windows;


const
  BASS_VST_PARAM_CHANGED = 1;
  BASS_VST_EDITOR_RESIZED = 2;
  BASS_VST_AUDIO_MASTER = 3;

  BASS_VST_ERROR_NOINPUTS     = 3000;// the given effect has no inputs and is probably a VST instrument and no effect
  BASS_VST_ERROR_NOOUTPUTS    = 3001; // the given effect has no outputs
  BASS_VST_ERROR_NOREALTIME   = 3002; // the given effect does not support realtime processing
  BASS_VST_KEEP_CHANS         = 00001;

type

BASS_VST_PARAM_INFO = record
    name :  array [0..15] of Char;         // examples: Time, Gain, RoomType
    FUnit : array [0..15] of Char;         // examples: sec, dB, type
    Display : array [0..15] of Char;         // the current value in a readable format, examples: 0.5, -3, PLATE
    defaultValue : single;                 // the default value
    rsvd : array [0..255] of Char;
end;

BASS_VST_INFO = record
    ChannelHandle : DWORD;                 // the channelHandle as given to BASS_VST_ChannelSetDSP()
    uniqueID :DWORD;                       // a unique ID for the effect (the IDs are registered at Steinberg)
    effectName : array [0..79] of Char;    // the effect name
    effectVersion : DWORD;                 // the effect version
    effectVstVersion : DWORD;              // the VST version, the effect was written for
    hostVstVersion : DWORD;                // the VST version supported by BASS_VST, currently 2.4
    productName : array [0..79] of Char;   // the product name, may be empty
    vendorName: array [0..79] of Char;     // the vendor name, may be empty
    vendorVersion : DWORD;                 // vendor-specific version number
    chansIn : DWORD;                       // max. number of possible input channels
    chansOut : DWORD;                      // max. number of possible output channels
    initialDelay : DWORD;                  // for algorithms which need input in the first place, in milliseconds
    hasEditor : DWORD;                     // can the BASS_VST_EmbedEditor() function be called?
    editorWidth : DWORD;                   // initial/current width of the editor, also note BASS_VST_EDITOR_RESIZED
    editorHeight : DWORD;                  // initial/current height of the editor, also note BASS_VST_EDITOR_RESIZED
    aeffect : Pointer;                     // the underlying AEffect object (see the VST SDK)
    rsvd: array [0..255] of Char;
    isInstrument:DWORD;
end;



VSTPROC = procedure (vstHandle : DWORD;Action : DWORD;Param1,Param2,User : DWORD);stdcall;

const BASS_VSTDLL = 'bass_vst.dll';

function BASS_VST_ChannelSetDSP (Channel : DWORD;const DLLFile : PChar;flags: DWORD; priority:Integer): DWORD;stdcall;external BASS_VSTDLL;
function BASS_VST_ChannelRemoveDSP(Channel : DWORD;vstHandle : DWORD): Bool;stdcall;external BASS_VSTDLL;

 function BASS_VST_EmbedEditor(Channel : DWORD;ParentWindow : hwnd): Bool;stdcall;external BASS_VSTDLL;

function BASS_VST_GetInfo(VSTHandle : DWORD;pInfo: Pointer):Bool;stdcall;external BASS_VSTDLL;
function BASS_VST_GetParam(vstHandle : DWORD;paramIndex : integer): single;stdcall;external BASS_VSTDLL;
function BASS_VST_SetParam(vstHandle : DWORD;paramIndex : integer;value : single): Bool;stdcall;external BASS_VSTDLL;
function BASS_VST_GetParamCount(vstHandle : DWORD) : integer;stdcall;external BASS_VSTDLL;
function BASS_VST_GetParamInfo(vstHandle : DWORD;paramIndex : Integer;var Info : BASS_VST_PARAM_INFO): boolean;stdcall;external BASS_VSTDLL;
function BASS_VST_Resume(vstHandle : DWORD):Bool;stdcall;external BASS_VSTDLL;
function BASS_VST_SetCallback(vstHandle : DWORD; PROC : Pointer; user : DWORD):Bool;stdcall;external BASS_VSTDLL;
function BASS_VST_SetLanguage(const Lang : PChar):Bool;stdcall;external BASS_VSTDLL;
function BASS_VST_SetBypass(vstHandle : DWORD; state:boolean):bool;stdcall;external BASS_VSTDLL;
function BASS_VST_GetBypass(vstHandle : DWORD):dword;stdcall;external BASS_VSTDLL;

function BASS_VST_ChannelCreate(freq : DWORD; Chans : DWORD; const DLLFile : PChar; flags: DWORD): DWORD;stdcall;external BASS_VSTDLL;
function BASS_VST_ChannelFree(vstHandle : DWORD): BOOL;stdcall;external BASS_VSTDLL;
function BASS_VST_ProcessEvent(vstHandle : DWORD; midiCh : DWORD; event : DWORD; param : DWORD): BOOL;stdcall;external BASS_VSTDLL;

implementation

end.