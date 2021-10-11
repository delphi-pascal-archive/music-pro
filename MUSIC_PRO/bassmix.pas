{
  BASSmix 2.4 Delphi unit
  Copyright (c) 2005-2008 Un4seen Developments Ltd.

  See the BASSMIX.CHM file for more detailed documentation
}

Unit BASSmix;

interface

uses Windows, Bass;

const
  // additional BASS_SetConfig option
  BASS_CONFIG_MIXER_FILTER  = $10600;
  BASS_CONFIG_MIXER_BUFFER  = $10601;
  BASS_CONFIG_SPLIT_BUFFER  = $10610;

  // BASS_Mixer_StreamCreate flags
  BASS_MIXER_END     = $10000;  // end the stream when there are no sources
  BASS_MIXER_NONSTOP = $20000;  // don't stall when there are no sources
  BASS_MIXER_RESUME  = $1000;   // resume stalled immediately upon new/unpaused source

  // source flags
  BASS_MIXER_FILTER  = $1000;   // resampling filter
  BASS_MIXER_BUFFER  = $2000;   // buffer data for BASS_Mixer_ChannelGetData/Level
  BASS_MIXER_MATRIX  = $10000;  // matrix mixing
  BASS_MIXER_PAUSE   = $20000;  // don't process the source
  BASS_MIXER_DOWNMIX = $400000; // downmix to stereo/mono
  BASS_MIXER_NORAMPIN = $800000; // don't ramp-in the start

  // envelope types
  BASS_MIXER_ENV_FREQ = 1;
  BASS_MIXER_ENV_VOL  = 2;
  BASS_MIXER_ENV_PAN  = 3;
  BASS_MIXER_ENV_LOOP = $10000; // FLAG: loop

  // additional sync type
  BASS_SYNC_MIXER_ENVELOPE = $10200;

  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_MIXER = $10800;
  BASS_CTYPE_STREAM_SPLIT = $10801;

type
  // envelope node
  BASS_MIXER_NODE = record
	pos: QWORD;
	value: Single;
  end;

const
  bassmixdll = 'bassmix.dll';

function BASS_Mixer_GetVersion: DWORD; stdcall; external bassmixdll;

function BASS_Mixer_StreamCreate(freq, chans, flags: DWORD): HSTREAM; stdcall; external bassmixdll;
function BASS_Mixer_StreamAddChannel(handle: HSTREAM; channel, flags: DWORD): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_StreamAddChannelEx(handle: HSTREAM; channel, flags: DWORD; start, length: QWORD): BOOL; stdcall; external bassmixdll;

function BASS_Mixer_ChannelGetMixer(handle: DWORD): HSTREAM; stdcall; external bassmixdll;
function BASS_Mixer_ChannelFlags(handle, flags, mask: DWORD): DWORD; stdcall; external bassmixdll;
function BASS_Mixer_ChannelRemove(handle: DWORD): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelSetPosition(handle: DWORD; pos: QWORD; mode: DWORD): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelGetPosition(handle, mode: DWORD): QWORD; stdcall; external bassmixdll;
function BASS_Mixer_ChannelGetLevel(handle: DWORD): DWORD; stdcall; external bassmixdll;
function BASS_Mixer_ChannelGetData(handle: DWORD; buffer: Pointer; length: DWORD): DWORD; stdcall; external bassmixdll;
function BASS_Mixer_ChannelSetSync(handle: DWORD; type_: DWORD; param: QWORD; proc: SYNCPROC; user: Pointer): HSYNC; stdcall; external bassmixdll;
function BASS_Mixer_ChannelRemoveSync(handle: DWORD; sync: HSYNC): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelSetMatrix(handle: DWORD; matrix: Pointer): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelGetMatrix(handle: DWORD; matrix: Pointer): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelSetEnvelope(handle, type_: DWORD; var nodes: BASS_MIXER_NODE; count: DWORD): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelSetEnvelopePos(handle, type_: DWORD; pos: QWORD): BOOL; stdcall; external bassmixdll;
function BASS_Mixer_ChannelGetEnvelopePos(handle, type_: DWORD; value: PSingle): QWORD; stdcall; external bassmixdll;

function BASS_Split_StreamCreate(channel, flags: DWORD; chanmap: PLongInt): HSTREAM; stdcall; external bassmixdll;
function BASS_Split_StreamGetSource(handle: HSTREAM): DWORD; stdcall; external bassmixdll;
function BASS_Split_StreamReset(handle: DWORD): BOOL; stdcall; external bassmixdll;

implementation

end.
