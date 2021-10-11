{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
{DEEFAZE - 2009 ------- Codage du tempo}

unit MidiWriter;

interface

uses
  Forms,SysUtils, Classes, StrUtils, DateUtils, Dialogs;

type

  TFormatMidi     = (single_track, multiple_tracks_synchronous, multiple_tracks_asynchronous);
  TChannel = 0..15;
  THalfByte = 0..127;
  THour = 0..23;
  TMinSec = 0..59;
  TFr =0..30;
  TSubFr=0..99;
  TKey=-7..7;
  TScale = 0..1;
  TControllerType =(CtBankSelect=0,
                   CtModulationWheel=1,
                   CtBreathControl=2,
                   CtContinuouscontrollerSharp3=3,
                   CtFootController=4,
                   CtPortamentoTime=5,
                   CtDataEntrySlider=6,
                   CtMainVolume=7,
                   CtStereoBalance=8,
                   CtContinuouscontrollerSharp9=9,
                   CtPan=10,
                   CtExpression=11,
                   CtEffectControl1=12,
                   CtEffectControl2=13,
                   CtContinuouscontrollerSharp14=14,
                   CtContinuouscontrollerSharp15=15,
                   CtGeneralPurposeSlider1=16,
                   CtGeneralPurposeSlider2=17,
                   CtGeneralPurposeSlider3=18,
                   CtGeneralPurposeSlider4=19,
                   CtContinuouscontrollerSharp20=20,
                   CtContinuouscontrollerSharp21=21,
                   CtContinuouscontrollerSharp22=22,
                   CtContinuouscontrollerSharp23=23,
                   CtContinuouscontrollerSharp24=24,
                   CtContinuouscontrollerSharp25=25,
                   CtContinuouscontrollerSharp26=26,
                   CtContinuouscontrollerSharp27=27,
                   CtContinuouscontrollerSharp28=28,
                   CtContinuouscontrollerSharp29=29,
                   CtContinuouscontrollerSharp30=30,
                   CtContinuouscontrollerSharp31=31,
                   CtBankSelectFine=32,
                   CtModulationWheelFine=33,
                   CtBreathControlFine=34,
                   CtContinuouscontrollerSharp3Fine=35,
                   CtFootControllerFine=36,
                   CtPortamentoTimeFine=37,
                   CtDataEntrySliderFineFine=38,
                   CtMainVolumeFine=39,
                   CtStereoBalanceFine=40,
                   CtContinuouscontrollerSharp9Fine=41,
                   CtPanFine=42,
                   CtExpressionFine=43,
                   CtEffectControl1Fine=44,
                   CtEffectControl2Fine=45,
                   CtContinuouscontrollerSharp14Fine=46,
                   CtContinuouscontrollerSharp15Fine=47,
                   CtContinuouscontrollerSharp16=48,
                   CtContinuouscontrollerSharp17=49,
                   CtContinuouscontrollerSharp18=50,
                   CtContinuouscontrollerSharp19=51,
                   CtContinuouscontrollerSharp20Fine=52,
                   CtContinuouscontrollerSharp21Fine=53,
                   CtContinuouscontrollerSharp22Fine=54,
                   CtContinuouscontrollerSharp23Fine=55,
                   CtContinuouscontrollerSharp24Fine=56,
                   CtContinuouscontrollerSharp25Fine=57,
                   CtContinuouscontrollerSharp26Fine=58,
                   CtContinuouscontrollerSharp27Fine=59,
                   CtContinuouscontrollerSharp28Fine=60,
                   CtContinuouscontrollerSharp29Fine=61,
                   CtContinuouscontrollerSharp30Fine=62,
                   CtContinuouscontrollerSharp31Fine=63,
                   CtHoldpedalSwitch=64,
                   CtPortamentoSwitch=65,
                   CtSustenutoPedalSwitch=66,
                   CtSoftPedalSwitch=67,
                   CtLegatoPedalSwitch=68,
                   CtHoldPedal2Switch=69,
                   CtSoundVariation=70,
                   CtSoundTimbre=71,
                   CtSoundReleaseTime=72,
                   CtSoundAttackTime=73,
                   CtSoundBrighness=74,
                   CtSoundControl6=75,
                   CtSoundControl7=76,
                   CtSoundControl8=77,
                   CtSoundControl9=78,
                   CtSoundControl10=79,
                   CtGeneralPurposeButton1=80,
                   CtGeneralPurposeButton2=81,
                   CtGeneralPurposeButton3=82,
                   CtGeneralPurposeButton4=83,
                   CtPortamentoNote=84,
                   CtUndefinedSwitch2=85,
                   CtUndefinedSwitch3=86,
                   CtUndefinedSwitch4=87,
                   CtUndefinedSwitch5=88,
                   CtUndefinedSwitch6=89,
                   CtUndefinedSwitch7=90,
                   CtEffectsLevel=91,
                   CtTremuloLevel=92,
                   CtChorusLevel=93,
                   CtCelesteLevel=94,
                   CtPhaserLevel=95,
                   CtDataentryAd1=96,
                   CtDataentryDel1=97,
                   CtNonRegisteredParameterNumber1=98,
                   CtNonRegisteredParameterNumber2=99,
                   CtRegisteredParameterNumber1=100,
                   CtRegisteredParameterNumber2=101,
                   CtUndefined1=102,
                   CtUndefined2=103,
                   CtUndefined3=104,
                   CtUndefined4=105,
                   CtUndefined5=106,
                   CtUndefined6=107,
                   CtUndefined7=108,
                   CtUndefined8=109,
                   CtUndefined9=110,
                   CtUndefined10=111,
                   CtUndefined11=112,
                   CtUndefined12=113,
                   CtUndefined13=114,
                   CtUndefined14=115,
                   CtUndefined15=116,
                   CtUndefined16=117,
                   CtUndefined17=118,
                   CtUndefined18=119,
                   CtAllSoundOff=120,
                   CtAllControllersOff=121,
                   CtLocalKeyboardSwitch=122,
                   CtAllNotesOff=123,
                   CtOmniModeOff=124,
                   CtOmniModeOn=125,
                   CtMonophonicModeOn=126,
                   CtPolyphonicModeOn=127);

TMidiWriter = class(TComponent)
  private
    fFormatMidi:   TFormatMidi;
    fNbTracks:     Byte;
    fDivision: word;
    EventsStream:   TMemoryStream;
    TrackStream:    TMemoryStream;
    Tempo:Integer;
  protected
    Function DeltaTimeToTicks(Value:Integer):Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize_Track;
    procedure Finalize_Track;
    procedure Create_MidiFile(AFile: string);
    procedure Add_NoteOn_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Note, Velocity: THalfByte);
    procedure Add_NoteOff_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Note, Velocity: THalfByte);
    procedure Add_Controller_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const ControllerType: TControllerType; Const Value: THalfByte);
    procedure Add_ProgramChange_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Program_Number: THalfByte);
    procedure Add_ChannelAfterTouch_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Amount: THalfByte);
    procedure Add_NoteAftertouch_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Note, Amount: THalfByte);
    procedure Add_PitchBend_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Value:Word);
    procedure Add_SequenceNumber_Event(Const SeqNmber: Word);
    procedure Add_Event_String(Const DeltaTime : Integer; Const Event_Type:Byte;Const AText: string);
    procedure Add_Text_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_CopyrightNotice_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_TrackName_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_InstrumentName_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_Lyrics_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_Marker_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_CuePoint_Event(Const DeltaTime : Integer; Const AText: string);
    procedure Add_ChannelPrefix_Event(Const DeltaTime : Integer; Const Channel: TChannel);
    procedure Add_EndOfTrack_Event;
    procedure Add_SetTempo_Event(Const DeltaTime : Integer; Const BPM: Integer);
    procedure Add_SMPTEOffset_Event(Const DeltaTime : Integer; Const Hours : THour; Const Mins, Secs : TMinSec; Const Fr:TFr;  Const SubFr: TSubFr);
    procedure Add_TimeSignature_Event(Const DeltaTime : Integer; Const Numer, Denom, Metro, TtNds: byte);
    procedure Add_KeySignature_Event(Const DeltaTime : Integer; Const Key : TKey; Const Scale: TScale);
    procedure Add_SequencerSpecific_Event(Const DeltaTime : Integer; Information :Variant);
  published
    property NbTracks: Byte Read fNbTracks Write fNbTracks;
    property FormatMidi: TFormatMidi Read fFormatMidi Write fFormatMidi;
    property Division: word Read fDivision Write fDivision;
  end;
  

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TMidiWriter]);
end;  
  
Procedure SwapBytes(Const Data; Count: byte);
var
  B: PByte;
  E: PByte;
  T: byte;
begin
  B := PByte(@Data);
  E := PByte(integer(B) + Count - 1);
  while integer(B) < integer(E) do
  begin
    T  := E^;
    E^ := B^;
    B^ := T;
    Inc(B);
    Dec(E);
  end;
end;  

function ByteCount(del : Longint) : byte;
var
  d : Longint;
  b : byte;
begin
  d := del;
  b := 1;
  while d >= 128 do
  begin
    d := (d shr 7);
    b := b + 1;
  end;
  ByteCount := b;
end;

procedure VLQ(del : Integer ;AStream:TStream);
var
  d  : Longint;
  w:array of LongInt;
  tel,k: byte;
begin
  If Not Assigned(AStream) Then Exit;
  d := del;
  tel := ByteCount(d);
  SetLength(W,tel);
  w[0]:=byte(d and $0000007F);
  if tel<>1 then 
  for k := 1 to tel-1 do
  begin
    d := d shr 7;
    w[k]:=byte((d and $0000007F) or $80);
  end;
  for k:=High(W) DownTo Low(W) Do
  AStream.Write(w[k],1);
end;

Procedure WordToLSB_MSB(Value:WORD;AStream:TStream);
var
  MSB,LSB:Byte;
begin
  If Not Assigned(AStream) Then Exit;
  LSB:=Value and $7f;
  MSB:=(Value and $3f80) * 2;
  AStream.Write(LSB,1);
  AStream.Write(MSB,1);	
end;

Procedure Write_Tempo(Const MPQN: Longword; AStream:TStream);
var
  vMPQN : array[0..2] of Byte;
  k:Integer;
begin
  If Not Assigned(AStream) Then Exit;
  vMPQN[0] := Byte($FF And MPQN);
  vMPQN[1] := Byte($FF And (MPQN shr 8));
  vMPQN[2] := Byte($FF And (MPQN shr 16));
  for k:=2  DownTo 0 Do
  AStream.Write(vMPQN[k],1);
end;

constructor TMidiWriter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fFormatMidi := single_track;
  fNbTracks   := 1;
  fDivision:=96;
  Tempo:=120;
  EventsStream := TMemoryStream.Create;
end;

destructor TMidiWriter.Destroy;
begin
  If Assigned(EventsStream) Then
  EventsStream.Free;
  inherited;
end;

Function TMidiWriter.DeltaTimeToTicks(Value:Integer):Integer;
Begin
  Result :=Value*fDivision*Tempo Div 60000 ;  
End;

procedure TMidiWriter.Initialize_Track;
begin
  EventsStream.Position:=0;
end;

procedure TMidiWriter.Finalize_Track;
Type
  TTrackHeader=Record
    ID : Array[0..3] Of Char;
    Size:LongWord;
  End;
Var
  TrackHeader:TTrackHeader;
begin
  if not Assigned(EventsStream) then
    Exit;
  if not Assigned(TrackStream) then
    TrackStream := TMemoryStream.Create;
  with TrackStream do
    try
      Add_EndOfTrack_Event;
      TrackHeader.ID:='MTrk';
      TrackHeader.Size:=EventsStream.size;
      SwapBytes(TrackHeader.Size, SizeOf(TrackHeader.Size));
      Write(TrackHeader,8);
      EventsStream.Position:=0;
      CopyFrom(EventsStream, EventsStream.Size);      
      While EventsStream.Position<EventsStream.Size Do
      Application.ProcessMessages;
    Except
      Showmessage('Une erreur a eu lieu');
      TrackStream.Free;
    end;
end;

procedure TMidiWriter.Create_MidiFile(AFile: string);
Type
  TChunkHeader=Record
    ID : Array[0..3] Of Char;
    Size:LongWord;
    Format:Word;
    NbTracks:Word;
    Division:Word;
  End;
var
  MidiStream: TFileStream;
  ChunkHeader:TChunkHeader;
begin
  if not Assigned(TrackStream) then Exit;
  MidiStream := TFileStream.Create(AFile, fmCreate);
  with MidiStream do
    try
      ChunkHeader.ID := 'MThd';
      ChunkHeader.Size   :=6;
      SwapBytes(ChunkHeader.Size,4);
      ChunkHeader.Format := 0;
      case fFormatMidi of
        single_track: ChunkHeader.Format := 0;
        multiple_tracks_synchronous: ChunkHeader.Format := 1;
        multiple_tracks_asynchronous: ChunkHeader.Format := 2;
      end;
      SwapBytes(ChunkHeader.Format,2);
      ChunkHeader.NbTracks   :=Self.fNbTracks;
      SwapBytes(ChunkHeader.NbTracks,2);
      ChunkHeader.Division   :=Self.fDivision;
      SwapBytes(ChunkHeader.Division,2);
      Write(ChunkHeader, 14);
      TrackStream.Position:=0;
     MidiStream.CopyFrom(TrackStream, 0);
    finally  
      TrackStream.Free;
      MidiStream.Free;
    end;
end;

{>>MIDI Channel Events}
procedure TMidiWriter.Add_NoteOn_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Note, Velocity: THalfByte);
var
  NoteOn_Val: byte;
begin
  If (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      NoteOn_Val:=144 + Channel; Write(NoteOn_Val,1);
      Write(Note,1);
      Write(Velocity,1);
    End;
end;

procedure TMidiWriter.Add_NoteOff_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Note, Velocity: THalfByte);
var
  NoteOff_Val: byte;
begin
  If (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      NoteOff_Val:=128 + Channel; Write(NoteOff_Val,1);
      Write(Note,1);
      Write(Velocity,1);
    End;
end;

procedure TMidiWriter.Add_Controller_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const ControllerType: TControllerType; Const Value: THalfByte);
var
  Control_Val,Type_Val: byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  Control_Val:= 176 + Channel;
  Type_Val:= Ord(ControllerType);
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      Write(Control_Val,1);
      Write(Type_Val,1);
      Write(Value,1);
    End;
end;

procedure TMidiWriter.Add_ProgramChange_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Program_Number: THalfByte);
var
  PrgrChg_Val:Byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      PrgrChg_Val:=192 + Channel; Write(PrgrChg_Val,1);
      Write(Program_Number,1);
    End;
end;

procedure TMidiWriter.Add_ChannelAfterTouch_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Amount: THalfByte);
var
  AfterTouch_Val:Byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      AfterTouch_Val:=208 + Channel; Write(AfterTouch_Val,1);
      Write(Amount,1);
    End;
end;

procedure TMidiWriter.Add_NoteAftertouch_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Note, Amount: THalfByte);
var
  AfterTouch_Val:Byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      AfterTouch_Val:=160 + Channel; Write(AfterTouch_Val,1);
      Write(Note,1);
      Write(Amount,1);
    End;
end;

procedure TMidiWriter.Add_PitchBend_Event(Const DeltaTime : Integer; Const Channel : TChannel; Const Value:Word);
var
  PitchBend_Val: byte;
begin
  if (not Assigned(TrackStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      PitchBend_Val:=224 + Channel; Write(PitchBend_Val,1);
      WordToLSB_MSB(Value,EventsStream);
    End;
end;

procedure TMidiWriter.Add_SequenceNumber_Event(Const SeqNmber: Word);
var
  Meta_Val,Event_Type: byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(0,EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:= 0; Write(Event_Type,1);
      VLQ(SizeOf(SeqNmber),EventsStream);
      WordToLSB_MSB(SeqNmber,EventsStream );
    End;
end;

procedure TMidiWriter.Add_Event_String(Const DeltaTime : Integer; Const Event_Type:Byte;Const AText: string);
var
  Meta_Val: byte;
begin
  if (not Assigned(EventsStream)) Or (AText='') then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Write(Event_Type,1);
      VLQ(Length(AText),EventsStream);
      Write(AText,Length(AText));
    End;
end;

procedure TMidiWriter.Add_Text_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,1,AText);
end;

procedure TMidiWriter.Add_CopyrightNotice_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,2,AText);
end;

procedure TMidiWriter.Add_TrackName_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,3,AText);
end;

procedure TMidiWriter.Add_InstrumentName_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,4,AText);
end;

procedure TMidiWriter.Add_Lyrics_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,5,AText);
end;

procedure TMidiWriter.Add_Marker_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,6,AText);
end;

procedure TMidiWriter.Add_CuePoint_Event(Const DeltaTime : Integer; Const AText: string);
Begin
  Add_Event_String(DeltaTime,7,AText);
end;

procedure TMidiWriter.Add_ChannelPrefix_Event(Const DeltaTime : Integer; Const Channel: TChannel);
var
  Meta_Val,Event_Type,Size_Event: byte;
begin
  if (not Assigned(EventsStream)) or (Channel > 15) then Exit;
  With EventsStream Do
    Begin
      VLQ(0,EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:= 32; Write(Event_Type,1);
      Size_Event:=1; Write(Size_Event,1);
      Write(Channel,1);
    End;
end;

procedure TMidiWriter.Add_EndOfTrack_Event;
var
  SwPrefEnd, SwEndOfTrack_HexVal, SwType, SwSize: byte;
begin
  If (Not Assigned(EventsStream)) Then Exit;
  With EventsStream Do
    Begin
      SwPrefEnd := 0; Write(SwPrefEnd,1);
      SwEndOfTrack_HexVal:=255; Write(SwEndOfTrack_HexVal,1);
      SwType:=47; Write(SwType,1);
      SwSize:=0; Write(SwSize,1);
    End;
end;

procedure TMidiWriter.Add_SetTempo_Event(Const DeltaTime : Integer; Const BPM: Integer);
var
  Meta_Val,Event_Type,SwSize: byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      Tempo:=BPM;
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);  
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:=81; Write(Event_Type,1);
      SwSize:=3; Write(SwSize,1);
      Write_Tempo(60000000 Div BPM,EventsStream);
    End;
end;

procedure TMidiWriter.Add_SMPTEOffset_Event(Const DeltaTime : Integer; Const Hours : THour; Const Mins, Secs : TMinSec; Const Fr:TFr;  Const SubFr: TSubFr);
var
  Meta_Val,Event_Type,Size_Event: byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:=84; Write(Event_Type,1);
      Size_Event:=5; Write(Size_Event,1);
      Write(Hours,1);
      Write(Mins,1);
      Write(Secs,1);
      Write(Fr,1);
      Write(SubFr,1);
    End;
end;

procedure TMidiWriter.Add_TimeSignature_Event(Const DeltaTime : Integer; Const Numer, Denom, Metro, TtNds: byte);
var
  Meta_Val,Event_Type,Size_Event: byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:=88; Write(Event_Type,1);
      Size_Event:=4; Write(Size_Event,1);
      Write(Numer,1);
      Write(Denom,1);
      Write(Metro,1);
      Write(TtNds,1);
    End;
end;

procedure TMidiWriter.Add_KeySignature_Event(Const DeltaTime : Integer; Const Key : TKey; Const Scale: TScale);
var
  Meta_Val,Event_Type,Size_Event: byte;
begin
  if (not Assigned(EventsStream)) then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:=89; Write(Event_Type,1);
      Size_Event:=2; Write(Size_Event,1);
      Write(Key,1);
      Write(Scale ,1);
    End;
end;

procedure TMidiWriter.Add_SequencerSpecific_Event(Const DeltaTime : Integer; Information :Variant);
var
  Meta_Val,Event_Type: byte;
begin
  if (not Assigned(EventsStream))then Exit;
  With EventsStream Do
    Begin
      VLQ(DeltaTimeToTicks(DeltaTime),EventsStream);
      Meta_Val:=255; Write(Meta_Val,1);
      Event_Type:=127; Write(Event_Type,1);
      VLQ(SizeOf(Information),EventsStream );
      SwapBytes(Information,SizeOf(Information));
      Write(Information,SizeOf(Information));
    End;   
end;

end.
