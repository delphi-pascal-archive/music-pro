{
  BASSMIDI 2.4 Delphi unit
  Copyright (c) 2006-2009 Un4seen Developments Ltd.

  See the BASSMIDI.CHM file for more detailed documentation
}

unit BassMIDI;

interface

uses Windows, Bass;

const
  // Additional config options
  BASS_CONFIG_MIDI_COMPACT   = $10400;
  BASS_CONFIG_MIDI_VOICES    = $10401;
  BASS_CONFIG_MIDI_AUTOFONT  = $10402;

  // Additional sync types
  BASS_SYNC_MIDI_MARKER      = $10000;
  BASS_SYNC_MIDI_CUE         = $10001;
  BASS_SYNC_MIDI_LYRIC       = $10002;
  BASS_SYNC_MIDI_TEXT        = $10003;
  BASS_SYNC_MIDI_EVENT       = $10004;
  BASS_SYNC_MIDI_TICK        = $10005;

  // Additional BASS_MIDI_StreamCreateFile/etc flags
  BASS_MIDI_DECAYEND         = $1000;
  BASS_MIDI_NOFX             = $2000;
  BASS_MIDI_DECAYSEEK        = $4000;

  // Marker types
  BASS_MIDI_MARK_MARKER      = 0; // marker events
  BASS_MIDI_MARK_CUE         = 1; // cue events
  BASS_MIDI_MARK_LYRIC       = 2; // lyric events
  BASS_MIDI_MARK_TEXT        = 3; // text events

  // MIDI events
  MIDI_EVENT_NOTE            = 1;
  MIDI_EVENT_PROGRAM         = 2;
  MIDI_EVENT_CHANPRES        = 3;
  MIDI_EVENT_PITCH           = 4;
  MIDI_EVENT_PITCHRANGE      = 5;
  MIDI_EVENT_DRUMS           = 6;
  MIDI_EVENT_FINETUNE        = 7;
  MIDI_EVENT_COARSETUNE      = 8;
  MIDI_EVENT_MASTERVOL       = 9;
  MIDI_EVENT_BANK            = 10;
  MIDI_EVENT_MODULATION      = 11;
  MIDI_EVENT_VOLUME          = 12;
  MIDI_EVENT_PAN             = 13;
  MIDI_EVENT_EXPRESSION      = 14;
  MIDI_EVENT_SUSTAIN         = 15;
  MIDI_EVENT_SOUNDOFF        = 16;
  MIDI_EVENT_RESET           = 17;
  MIDI_EVENT_NOTESOFF        = 18;
  MIDI_EVENT_PORTAMENTO      = 19;
  MIDI_EVENT_PORTATIME       = 20;
  MIDI_EVENT_PORTANOTE       = 21;
  MIDI_EVENT_MODE            = 22;
  MIDI_EVENT_REVERB          = 23;
  MIDI_EVENT_CHORUS          = 24;
  MIDI_EVENT_CUTOFF          = 25;
  MIDI_EVENT_RESONANCE       = 26;
  MIDI_EVENT_REVERB_MACRO    = 30;
  MIDI_EVENT_CHORUS_MACRO    = 31;
  MIDI_EVENT_REVERB_TIME     = 32;
  MIDI_EVENT_REVERB_DELAY    = 33;
  MIDI_EVENT_REVERB_LOCUTOFF = 34;
  MIDI_EVENT_REVERB_HICUTOFF = 35;
  MIDI_EVENT_REVERB_LEVEL    = 36;
  MIDI_EVENT_CHORUS_DELAY    = 37;
  MIDI_EVENT_CHORUS_DEPTH    = 38;
  MIDI_EVENT_CHORUS_RATE     = 39;
  MIDI_EVENT_CHORUS_FEEDBACK = 40;
  MIDI_EVENT_CHORUS_LEVEL    = 41;
  MIDI_EVENT_CHORUS_REVERB   = 42;
  MIDI_EVENT_DRUM_FINETUNE   = 50;
  MIDI_EVENT_DRUM_COARSETUNE = 51;
  MIDI_EVENT_DRUM_PAN        = 52;
  MIDI_EVENT_DRUM_REVERB     = 53;
  MIDI_EVENT_DRUM_CHORUS     = 54;
  MIDI_EVENT_DRUM_CUTOFF     = 55;
  MIDI_EVENT_DRUM_RESONANCE  = 56;
  MIDI_EVENT_TEMPO           = 62;
  MIDI_EVENT_MIXLEVEL        = $10000;
  MIDI_EVENT_TRANSPOSE       = $10001;

  // BASS_CHANNELINFO type
  BASS_CTYPE_STREAM_MIDI     = $10d00;

  // Additional attributes
  BASS_ATTRIB_MIDI_PPQN      = $12000;
  BASS_ATTRIB_MIDI_TRACK_VOL = $12100; // + track #

  // Additional tag type
  BASS_TAG_MIDI_TRACK        = $11000; // + track #, track text : array of null-terminated ANSI strings

  // BASS_ChannelGetLength/GetPosition/SetPosition mode
  BASS_POS_MIDI_TICK         = 2; // tick position


type
  HSOUNDFONT = DWORD;   // soundfont handle

  BASS_MIDI_FONT = record
	font: HSOUNDFONT;   // soundfont
	preset: LongInt;    // preset number (-1=all)
	bank: Longint;
  end;

  BASS_MIDI_FONTINFO = record
	name: PAnsiChar;
	copyright: PAnsiChar;
	comment: PAnsiChar;
	presets: DWORD;     // number of presets/instruments
	samsize: DWORD;     // total size (in bytes) of the sample data
	samload: DWORD;     // amount of sample data currently loaded
	samtype: DWORD;     // sample format (CTYPE) if packed
  end;

  BASS_MIDI_MARK = record
    track: DWORD;       // track containing marker
	pos: DWORD;         // marker position
	text: PAnsiChar;    // marker text
  end;


const
  bassmididll = 'bassmidi.dll';

function BASS_MIDI_StreamCreate(channels,flags,freq:DWORD): HSTREAM; stdcall; external bassmididll;
function BASS_MIDI_StreamCreateFile(mem:BOOL; fl:pointer; offset,length:QWORD; flags,freq:DWORD): HSTREAM; stdcall; external bassmididll;
function BASS_MIDI_StreamCreateURL(URL:PAnsiChar; offset:DWORD; flags:DWORD; proc:DOWNLOADPROC; user:Pointer; freq:DWORD): HSTREAM; stdcall; external bassmididll;
function BASS_MIDI_StreamCreateFileUser(system,flags:DWORD; var procs:BASS_FILEPROCS; user:Pointer; freq:DWORD): HSTREAM; stdcall; external bassmididll;
function BASS_MIDI_StreamGetMark(handle:HSTREAM; type_,index:DWORD; var mark:BASS_MIDI_MARK): BOOL; stdcall; external bassmididll;
function BASS_MIDI_StreamSetFonts(handle:HSTREAM; var fonts:BASS_MIDI_FONT; count:DWORD): BOOL; stdcall; external bassmididll;
function BASS_MIDI_StreamGetFonts(handle:HSTREAM; var fonts:BASS_MIDI_FONT; count:DWORD): DWORD; stdcall; external bassmididll;
function BASS_MIDI_StreamLoadSamples(handle:HSTREAM): BOOL; stdcall; external bassmididll;
function BASS_MIDI_StreamEvent(handle:HSTREAM; chan,event,param:DWORD): BOOL; stdcall; external bassmididll;
function BASS_MIDI_StreamGetEvent(handle:HSTREAM; chan,event:DWORD): DWORD; stdcall; external bassmididll;
function BASS_MIDI_StreamGetChannel(handle:HSTREAM; chan:DWORD): HSTREAM; stdcall; external bassmididll;

function BASS_MIDI_FontInit(fname:PChar; flags:DWORD): HSOUNDFONT; stdcall; external bassmididll;
function BASS_MIDI_FontFree(handle:HSOUNDFONT): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontGetInfo(handle:HSOUNDFONT; var info:BASS_MIDI_FONTINFO): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontGetPreset(handle:HSOUNDFONT; preset,bank:LongInt): PAnsiChar; stdcall; external bassmididll;
function BASS_MIDI_FontLoad(handle:HSOUNDFONT; preset,bank:LongInt): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontCompact(handle:HSOUNDFONT): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontPack(handle:HSOUNDFONT; outfile,encoder:PChar; flags:DWORD): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontUnpack(handle:HSOUNDFONT; outfile:PChar; flags:DWORD): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontSetVolume(handle:HSOUNDFONT; volume:Single): BOOL; stdcall; external bassmididll;
function BASS_MIDI_FontGetVolume(handle:HSOUNDFONT): Single; stdcall; external bassmididll;

implementation

end.
