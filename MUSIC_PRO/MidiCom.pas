{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit MidiCom;

interface

uses
  Windows, SysUtils, Classes, MmSystem, Contnrs;

type

  TOnMidiInReceiveData = procedure(const Status, Data1, Data2: byte; Const Time:Cardinal) of object;
  TOnMidiInBuffer      = procedure(const AStream: TMemoryStream) of object;

  TMidiCom = class(TComponent)
  private
    MidiIn:      THandle;
    MidiOut:     THandle;
    ResultCom:   MMResult;
    MidiInCount: integer;
    MidiOutCount: integer;
    fDataStream: TMemoryStream;
    fDataHeader: TMidiHdr;
    fExData:     array[0..2048] of char;
    fOnMidiInReceiveData: TOnMidiInReceiveData;
    fOnMidiInBuffer: TOnMidiInBuffer;
    procedure Send_MidiInBuffer;
    procedure Send(const AStream: TMemoryStream); overload;
    procedure Send(const AString: string); overload;
    procedure StrToStream(const AString: string; const AStream: TMemoryStream);
  protected
  public
    Midi_MID:Word;
    Midi_PID:Word;
    Midi_MinorVersion:Word;
    Midi_MajorVersion:Word;
    Midi_Name:String;
    Midi_Technology:String;
    Midi_Voices:Word;
    Midi_Notes:Word;
    Midi_ChannelMask:Word;
    function Open_MidiIn(Index: integer): boolean;
    function Open_MidiOut(Index: integer): boolean;
    function Close_MidiIn: boolean;
    function Close_MidiOut: boolean;
    procedure MidiIn_List(AStrings: TStrings);
    Function MidiIn_Info(ADevice:Integer):Boolean;
    procedure MidiOut_List(AStrings: TStrings);
    Function MidiOut_Info(ADevice:Integer):Boolean;
    procedure SendData(Status, Data1, Data2: byte);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnMidiInReceiveData: TOnMidiInReceiveData
      Read fOnMidiInReceiveData Write fOnMidiInReceiveData;
    property OnMidiInBuffer: TOnMidiInBuffer Read fOnMidiInBuffer Write fOnMidiInBuffer;
  end;

var
  AMidiCom: TMidiCom;
  RefTime:Cardinal;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TMidiCom]);
end;

procedure MidiInCallBack(AMidiInHandle: PhMidiIn; aMsg: UInt;
  aData, aMidiData, aTimeStamp: integer); stdcall;
begin
  if AMsg = Mim_Data then
    if AMidiCom.MidiIn <> 0 then
      AMidiCom.OnMidiInReceiveData(aMidiData and $000000FF, (aMidiData and $0000FF00) shr
        8, (aMidiData and $00F0000) shr 16,GetTickCount-RefTime);
  if AMsg = Mim_LongData then
    AMidiCom.Send_MidiInBuffer;
end;

constructor TMidiCom.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MidiInCount := -1;
  MidiOutCount := -1;
  MidiIn      := 0;
  MidiOut     := 0;
  fDataHeader.dwBufferLength := 2048;
  fDataHeader.lpData := fExData;
  fDataStream := TMemoryStream.Create;
  AMidiCom    := Self;
end;

destructor TMidiCom.Destroy;
begin
  fDataStream.Free;
  Close_MidiIn;
  Close_MidiOut;
  inherited;
end;

{>>ENTREE MIDI}

procedure TMidiCom.MidiIn_List(AStrings: TStrings);
var
  Index:  integer;
  InCaps: TMidiInCaps;
begin
  AStrings.Clear;
  for Index := 0 to (MidiInGetNumDevs - 1) do
  begin
    //On récupère les capacités de l'entrée Midi numéro Index
    ResultCom := MidiInGetDevCaps(Index, @InCaps, SizeOf(TMidiInCaps));
    if ResultCom = MmSysErr_NoError then
    begin
      AStrings.Add(InCaps.szPName);
      Inc(MidiInCount);
    end;
  end;
end;

Function TMidiCom.MidiIn_Info(ADevice:Integer):Boolean;
var
  InCaps: TMidiInCaps;
begin
  Result:=False;
  //On récupère les capacités de l'entrée Midi numéro Index
  ResultCom := MidiInGetDevCaps(ADevice, @InCaps, SizeOf(TMidiInCaps));
  If ResultCom = MmSysErr_NoError then
    begin
      Midi_MID:=InCaps.wMid;
      Midi_PID:=InCaps.wPid;
      Midi_MinorVersion:=Low(InCaps.vDriverVersion);
      Midi_MajorVersion:=Hi(InCaps.vDriverVersion);
      Midi_Name:=InCaps.szPname;
      Result:=True;
    end;
end;

function TMidiCom.Open_MidiIn(Index: integer): boolean;
begin
  Result := False;
  if (MidiInCount > -1) and (Index > -1) and (Index <= MidiInCount) then
  begin
    //Si l'entrée Midi a déjà été définit on sort
    if MidiIn <> 0 then
      Exit;
    //On ouvre l'entrée midi :  MidiInCallBack sera le callback utilisé pour récupérer les données recues
    ResultCom := MidiInOpen(@MidiIn, Index, cardinal(@MidiInCallBack),
      Index, CallBack_Function);
    if ResultCom = MmSysErr_NoError then
    begin
      fDataHeader.dwFlags := 0;
      //On prépare le buffer pour l'entrée Midi
      ResultCom := MidiInPrepareHeader(MidiIn, @fDataHeader, SizeOf(TMidiHdr));
      if ResultCom = MmSysErr_NoError then
      begin
        //On envoit un buffer d'entré dans l'entrée Midi
        ResultCom := MidiInAddBuffer(MidiIn, @fDataHeader, SizeOf(TMidiHdr));
        if ResultCom = MmSysErr_NoError then
        begin
          //On allume l'entrée Midi
          ResultCom := MidiInStart(MidiIn);
          if ResultCom = MmSysErr_NoError then
            Begin
              Result := True;
              RefTime:=GetTickCount;
            End;  
        end;
      end;
    end;
  end;
end;

function TMidiCom.Close_MidiIn: boolean;
begin
  Result := False;
  if MidiIn = 0 then
    Exit;
  //On arrète l'entrée midi
  ResultCom := MidiInStop(MidiIn);
  if ResultCom = MmSysErr_NoError then
  begin
    //On détruit l'entrée Midi
    ResultCom := MidiInReset(MidiIn);
    if ResultCom = MmSysErr_NoError then
    begin
      //On nettoye le Buffer
      ResultCom := MidiInUnPrepareHeader(MidiIn, @fDataHeader, SizeOf(TMidiHdr));
      if ResultCom = MmSysErr_NoError then
        Result := True;
    end;
  end;
end;

procedure TMidiCom.Send_MidiInBuffer;
begin
  if fDataHeader.dwBytesRecorded = 0 then
    Exit;
  fDataStream.Write(fExData, fDataHeader.dwBytesRecorded);
  if fDataHeader.dwFlags and MHdr_Done = MHdr_Done then
  begin
    fDataStream.Position := 0;
    fOnMidiInBuffer(fDataStream);
    fDataStream.Clear;
  end;
  fDataHeader.dwBytesRecorded := 0;
  //On prépare le buffer pour l'entrée Midi
  ResultCom := MidiInPrepareHeader(MidiIn, @fDataHeader, SizeOf(TMidiHdr));
  if ResultCom = MmSysErr_NoError then
  begin
    //On envoit un buffer d'entré dans l'entrée Midi
    ResultCom := MidiInAddBuffer(MidiIn, @fDataHeader, SizeOf(TMidiHdr));
  end;
end;


{>>SORTIE MIDI}

procedure TMidiCom.MidiOut_List(AStrings: TStrings);
var
  Index:   integer;
  OutCaps: TMidiOutCaps;
begin
  AStrings.Clear;
  for Index := 0 to (MidiOutGetNumDevs - 1) do
  begin
    //On récupère les capacités de la sortie Midi numéro Index
    ResultCom := MidiOutGetDevCaps(Index, @OutCaps, SizeOf(TMidiOutCaps));
    if ResultCom = MmSysErr_NoError then
    begin
      AStrings.Add(OutCaps.szPName);
      Inc(MidiOutCount);
    end;
  end;
end;

Function TMidiCom.MidiOut_Info(ADevice:Integer):Boolean;
Const
  TechonolgyMidi: Array[0..6] Of String =('MIDIPORT','SYNTH','SQSYNTH','FMSYNTH','MAPPER','WAVETABLE','SWSYNTH');
var
  OutCaps: TMidiOutCaps;
begin
  Result:=False;
  //On récupère les capacités de l'entrée Midi numéro Index
  ResultCom :=MidiOutGetDevCaps(ADevice, @OutCaps, SizeOf(TMidiOutCaps));
  If ResultCom = MmSysErr_NoError then
    begin
      Midi_MID:=OutCaps.wMid;
      Midi_PID:=OutCaps.wPid;
      Midi_MinorVersion:=Low(OutCaps.vDriverVersion);
      Midi_MajorVersion:=Hi(OutCaps.vDriverVersion);
      Midi_Name:=OutCaps.szPname;
      Midi_Technology:=TechonolgyMidi[OutCaps.wTechnology];
      Midi_Voices:=OutCaps.wVoices;
      Midi_Notes:=OutCaps.wNotes;
      Midi_ChannelMask:=OutCaps.wChannelMask;
      Result:=True;
    end;
end;

function TMidiCom.Close_MidiOut: boolean;
begin
  Result    := False;
  ResultCom := MidiOutClose(MidiOut);
  if ResultCom = MmSysErr_NoError then
    Result := True;
end;

function TMidiCom.Open_MidiOut(Index: integer): boolean;
begin
  Result := False;
  if (MidiOutCount > -1) and (Index > -1) and (Index <= MidiOutCount) then
  begin
    if MidiOut <> 0 then
      Exit;
    //Ouverture de la sortie Midi
    ResultCom := MidiOutOpen(@MidiOut, Index, 0, 0, CallBack_Null);
    if ResultCom = MmSysErr_NoError then
      Result := True;
  end;
end;

procedure TMidiCom.SendData(Status, Data1, Data2: byte);
var
  AMsg: cardinal;
begin
  if MidiOut = 0 then
    Exit;
  AMsg      := Status + (Data1 * $100) + (Data2 * $10000);
  //On envoit le message à la sortie Midi
  ResultCom := MidiOutShortMsg(MidiOut, AMsg);
end;

procedure TMidiCom.Send(const AString: string);
var
  AStream: TMemoryStream;
begin
  AStream := TMemoryStream.Create;
  try
    StrToStream(AString, AStream);
    Send(AStream);
  finally
    AStream.Free;
  end;
end;

procedure TMidiCom.Send(const AStream: TMemoryStream);
var
  ADataHeader: TMidiHdr;
begin
  AStream.Position := 0;
  ADataHeader.dwBufferLength := AStream.Size;
  ADataHeader.lpData := AStream.Memory;
  ADataHeader.dwFlags := 0;
  //Préparation de la zone tambon pour la sortie Midi
  ResultCom := MidiOutPrepareHeader(MidiOut, @ADataHeader, SizeOf(TMidiHdr));
  if ResultCom = MmSysErr_NoError then
  begin
    //On envoit le message à la sortie Midi
    ResultCom := MidiOutLongMsg(MidiOut, @ADataHeader, SizeOf(TMidiHdr));
    if ResultCom = MmSysErr_NoError then
      //On nettoye le Buffer
      ResultCom := MidiOutUnPrepareHeader(MidiOut, @ADataHeader, SizeOf(TMidiHdr));
  end;
end;

procedure TMidiCom.StrToStream(const AString: string; const AStream: TMemoryStream);
const
  HexChar = '123456789ABCDEF';
var
  Index: integer;
  Str:   string;
begin
  Str := StringReplace(AnsiUpperCase(AString), '  ', '', [rfReplaceAll]);
  AStream.Position := 0;
  for Index := 1 to (Length(Str) div 2 - 1) do
    PChar(AStream.Memory)[Index - 1] :=
      char(AnsiPos(Str[Index * 2 - 1], HexChar) shl 4 + AnsiPos(Str[Index * 2], HexChar));
end;

end.
