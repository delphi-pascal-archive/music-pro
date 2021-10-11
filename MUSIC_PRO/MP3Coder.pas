unit MP3Coder;
{ Composant MP3 encodeur
  Developpé sous D5 Pro Français par Franck Deport
  ( fdeport@free.fr  http://fdeport.free.fr )
  Utilise le Header de la DLL BladeEnc par Jack Kallestrup.


  Version 1.0 du 31/10/2001 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MP3Coder_dll;

type
  EMP3CoderError = class(Exception);

  // Pour la version de la DLL
  TCoderVersion = class(TPersistent)
  private
    FBeV: TBeVersion;
  public
    constructor Create;
    procedure Assign(Source : TPersistent); override;
  published
    property DLLMajorVersion : byte read FBEV.byDLLMajorVersion write FBEV.byDLLMajorVersion;
    property DLLMinorVersion : byte read FBEV.byDLLMinorVersion write FBEV.byDLLMinorVersion;
    property MajorVersion    : byte read FBEV.byMajorVersion    write FBEV.byMajorVersion;
    property MinorVersion    : byte read FBEV.byMinorVersion    write FBEV.byMinorVersion;
  end;

  TMP3CoderMode = (STEREO, JSTEREO, DUALCHANNEL, MONO);

  // Header d'un fichier wav "classique" Longueur 44 octets
  TWaveHeader = record
    Marker1: Array[0..3] of Char; // Normalement 'WAV '
    BytesFollowing: LongInt;
    Marker2: Array[0..3] of Char;
    Marker3: Array[0..3] of Char;
    Fixed1: LongInt;
    FormatTag: Word;
    Channels: Word;
    SampleRate: LongInt;
    BytesPerSecond: LongInt;
    BytesPerSample: Word;
    BitsPerSample: Word;
    Marker4: Array[0..3] of Char;
    DataBytes: LongInt;
  end;

  TProgressEvent = procedure(Sender: TObject; PercentComplete : Word) of object;
  TProcessFileEvent = procedure(Sender: TObject; Num : Word; FileName : string) of object;
  TMP3Coder = class(TComponent)
  private
    FSampleRate: DWORD;
    FReSampleRate: DWORD;
    FMode: INTEGER;
    FBitrate: DWORD;
    FMaxBitrate: DWORD;
    FQuality: MPEG_QUALITY;
    FMpegVersion: DWORD;
    FPsyModel: DWORD;
    FEmphasis: DWORD;
    FPrivate: BOOL;
    FCRC: BOOL;
    FCopyright: BOOL;
    FOriginal: BOOL;
    FWriteVBRHeader: BOOL;
    FEnableVBR: BOOL;
    FVBRQuality: integer;
    FInputFiles: TStrings;
    FOutputFiles: TStrings;
    FCoderVersion: TCoderVersion;
    FDefaultExt: string;
    FFileName: string;
    FBeConfig: TBeConfig;
    FHBeStream: THBeStream;
    FNumSamples: DWORD;
    FBufSize: DWORD;
    FInputBuf: pointer;
    FOutputBuf: pointer;
    FMP3File: TFileStream;
    FWAVFile: TFileStream;
    FOnBeginProcess: TNotifyEvent;
    FOnBeginFile: TProcessFileEvent;
    FOnEndFile: TProcessFileEvent;
    FOnEndProcess: TNotifyEvent;
    FOnProgress: TProgressEvent;
    FCancelProcess: Boolean;
    FWave: TWaveHeader;
    procedure SetSampleRate(Value: DWORD);
    procedure SetBitrate(Value: DWORD);
    procedure SetEnableVBR(Value: BOOL);
    function GetCoderVersion: TCoderVersion;
    procedure SetInputFiles(Value: TStrings);
    procedure SetOutputFiles(Value: TStrings);
    procedure SetMode(Value: TMP3CoderMode);
    function GetMode: TMP3CoderMode;
  protected

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    procedure ProcessFiles;
    function PrepareCoder : TBEERR;
    function UnPrepareCoder(Buf : pointer; var dwWrite : DWORD) : TBEERR;
    procedure CloseCoder;
    procedure CancelProcess;
    function EncodeBuffer(InBuf : pointer; OutBuf : pointer; var OutP : DWORD) : TBEERR;
    property NumSamples: DWORD read FNumSamples default 0;
    property BufSize: DWORD read FBufSize default 0;
  published
    property SampleRate: DWORD read FSampleRate write SetSampleRate default 44100;
    property Bitrate: DWORD read FBitrate write SetBitrate default 128;
    property MaxBitrate: DWORD read FMaxBitrate write FMaxBitrate default 320;
    property Quality: MPEG_QUALITY read FQuality write FQuality default NORMAL_QUALITY;
    property Private: BOOL read FPrivate write FPrivate default false;
    property CRC: BOOL read FCRC write FCRC default true;
    property Mode: TMP3CoderMode read GetMode write SetMode default STEREO;
    property Copyright: BOOL read FCopyright write FCopyright default false;
    property Original: BOOL read FOriginal write FOriginal default false;
    property WriteVBRHeader: BOOL read FWriteVBRHeader write FWriteVBRHeader default false;
    property EnableVBR: BOOL read FEnableVBR write SetEnableVBR default false;
    property VBRQuality: integer read FVBRQuality write FVBRQuality default 4;
    property InputFiles: TStrings read FInputFiles write SetInputFiles;
    property OutputFiles: TStrings read FOutputFiles write SetOutputFiles;
    property CoderVersion: TCoderVersion read GetCoderVersion;
    property DefaultExt: string read FDefaultExt write FDefaultExt;
    property Mp3FileName: string read FFileName write FFileName;
    property OnBeginProcess: TNotifyEvent read FOnBeginProcess write FOnBeginProcess;
    property OnBeginFile: TProcessFileEvent read FOnBeginFile write FOnBeginFile;
    property OnEndFile: TProcessFileEvent read FOnEndFile write FOnEndFile;
    property OnEndProcess: TNotifyEvent read FOnEndProcess write FOnEndProcess;
    property OnProgress: TProgressEvent read FOnProgress write FOnProgress;
  end;

  TMP3CoderStream = class(TFileStream)
  private
    FMP3Coder : TMP3Coder;
    FOutBuf    : pointer;
  protected
    procedure SetMP3Coder(Value : TMP3Coder);
  public
    constructor Create(const FileName: string; Mode: Word);
    destructor Destroy; override;
    property MP3Coder : TMP3Coder read FMP3Coder write SetMP3Coder;
    function Write(const Buffer; Count : Longint) : Longint; override;
    function Read(var Buffer; Count: Longint): Longint; override;
  end;

procedure Register;
{$R MP3Coder.res}
implementation

var
  Err: TBeErr;
  FileLength: DWORD;
  Done: DWORD;
  dwWrite: DWORD;
  toRead: DWORD;
  isRead: DWORD;
  toWrite: DWORD;
  IsWritten: DWORD;
  FWAVFileName: String;
  FMp3FileName: string;
  PrcntComplete: Word;

procedure Register;
begin
  RegisterComponents('FD M.c.s', [TMP3Coder]);
end;

{********** Coder Version *************}
constructor TCoderVersion.Create;
begin
  inherited Create;
  beVersion(FBEV);
end;

procedure TCoderVersion.Assign(Source : TPersistent);
begin
  if Source is TCoderVersion then begin
    FBEV.byDLLMajorVersion := TCoderVersion(Source).FBEV.byDLLMajorVersion;
    FBEV.byDLLMinorVersion := TCoderVersion(Source).FBEV.byDLLMinorVersion;
    FBEV.byMajorVersion := TCoderVersion(Source).FBEV.byMajorVersion;
    FBEV.byMinorVersion := TCoderVersion(Source).FBEV.byMinorVersion;
  end else inherited Assign(Source);
end;

{*********** MP3 Coder ********}
constructor TMP3Coder.Create (AOwner : TComponent);
begin
  inherited Create(AOwner);
  FSampleRate := 44100;
  FBitRate := 128;
  FMaxBitRate := 320;
  FQuality := NORMAL_QUALITY;
  FCRC := true;
  FVBRQuality := 4;
  FInputFiles := TStringList.Create;
  FOutputFiles := TStringList.Create;
  FCoderVersion := TCoderVersion.Create;
  FDefaultExt := '.mp3';
end;

destructor TMP3Coder.Destroy;
begin
  FInputFiles.Free;
  FOutputFiles.Free;
  FCoderVersion.Free;
  inherited Destroy;
end;

procedure TMP3Coder.Assign(Source: TPersistent);
begin
  if Source is TMP3Coder then begin
    FSampleRate := TMP3Coder(Source).FSampleRate;
    FReSampleRate := TMP3Coder(Source).FReSampleRate;
    FMode := TMP3Coder(Source).FMode;
    FBitrate := TMP3Coder(Source).FBitrate;
    FMaxBitrate :=TMP3Coder(Source).FMaxBitrate;
    FQuality := TMP3Coder(Source).FQuality;
    FMpegVersion := TMP3Coder(Source).FMpegVersion;
    FPsyModel := TMP3Coder(Source).FPsyModel;
    FEmphasis := TMP3Coder(Source).FEmphasis;
    FPrivate := TMP3Coder(Source).FPrivate;
    FCRC := TMP3Coder(Source).FCRC;
    FCopyright := TMP3Coder(Source).FCopyright;
    FOriginal := TMP3Coder(Source).FOriginal;
    FWriteVBRHeader := TMP3Coder(Source).FWriteVBRHeader;
    FEnableVBR := TMP3Coder(Source).FEnableVBR;
    FVBRQuality := TMP3Coder(Source).FVBRQuality;
  end else inherited Assign(Source);
end;

procedure TMP3Coder.SetSampleRate(Value : DWORD);
begin
  FSampleRate:=Value;
end;

procedure TMP3Coder.SetBitrate(Value : DWORD);
begin
  FBitrate:=Value;
end;

procedure TMP3Coder.SetEnableVBR(Value : BOOL);
begin
  FEnableVBR:=Value;
  FWriteVBRHeader:=Value;
end;

function TMP3Coder.GetCoderVersion : TCoderVersion;
begin
  Result:=FCoderVersion;
end;

procedure TMP3Coder.SetInputFiles(Value : TStrings);
var
  n: integer;
begin
  with FInputFiles do begin
    Assign(Value);
    FOutputFiles.Clear;
    for n := 0 to Count -1 do
      FOutputFiles.Add(ChangeFileExt(Strings[n], FDefaultExt));
  end;
end;

procedure TMP3Coder.SetOutputFiles(Value : TStrings);
begin
  FOutputFiles.Assign(Value);
end;

procedure TMP3Coder.SetMode(Value : TMP3CoderMode);
begin
  case Value of
    STEREO: FMode:=BE_MP3_MODE_STEREO;
    JSTEREO: FMode:=BE_MP3_MODE_JSTEREO;
    DUALCHANNEL: FMode:=BE_MP3_MODE_DUALCHANNEL;
    MONO: FMode:=BE_MP3_MODE_MONO;
  end;
end;

function TMP3Coder.GetMode: TMP3CoderMode;
begin
  case FMode of
    BE_MP3_MODE_STEREO: Result:=STEREO;
    BE_MP3_MODE_JSTEREO: Result:=JSTEREO;
    BE_MP3_MODE_DUALCHANNEL: Result:=DUALCHANNEL;
  else
    Result:=MONO;
  end;
end;

function TMP3Coder.PrepareCoder : TBEERR;
begin
  FBeConfig.Format.dwConfig:=BE_CONFIG_LAME;
  with FBeConfig.Format.LHV1 do begin
    dwStructVersion := 1;
    dwStructSize := SizeOf(FBeConfig);
    dwSampleRate := FSampleRate;
    dwReSampleRate := 0;
    nMode := FMode;
    dwBitrate := FBitrate;
    dwMaxBitrate := FMaxBitrate;
    nQuality := DWORD(FQuality);
    dwMpegVersion := MPEG1;
    dwPsyModel := 0;
    dwEmphasis := 0;
    bPrivate := FPrivate;
    bCRC := FCRC;
    bCopyright := FCopyright;
    bOriginal := FOriginal;
    bWriteVBRHeader := FWriteVBRHeader;
    bEnableVBR := FEnableVBR;
    nVBRQuality := FVBRQuality;
  end;
  Err := BeInitStream(FBeConfig, FNumSamples, FBufSize, FHBeStream);
  if Err <> BE_ERR_SUCCESSFUL then begin
    Result:=Err;
    Exit;
  end;
  // Reserve le buffer
  GetMem(FOutputBuf, FBufSize);
  Result := Err;
end;

function TMP3Coder.UnprepareCoder(Buf : pointer; var dwWrite : DWORD) : TBEERR;
begin
   Result := beDeinitStream(FHBeStream, Buf, dwWrite);
end;

procedure TMP3Coder.CloseCoder;
begin
  FreeMem(FOutputBuf);
  beCloseStream(FHBeStream);
end;

procedure TMP3Coder.ProcessFiles;
  procedure CleanUp;
  begin
    FreeMem(FInputBuf);
    FWAVFile.Free;
    FMp3File.Free;
  end;

var
  FNum : integer;
  InputBufSize : Word;
begin
  FCancelProcess := false;
  if Assigned(FOnBeginProcess) then FOnBeginProcess(Self);
  // Boucle sur les fichiers à coder
  for FNum := 0 to FInputFiles.Count-1 do begin
    PrepareCoder;
    if Assigned(FOnBeginFile) then FOnBeginFile(Self,FNum,FInputFiles[FNum]);
    // Donne les noms aux fichiers
    FWAVFileName := FInputFiles[FNum];
    FMp3FileName := FOutputFiles[FNum];
    // Création des Streams
    FWAVFile := TFileStream.Create(FWAVFileName,fmOpenRead);
    FMp3File := TFileStream.Create(FMp3FileName,fmCreate or fmShareDenyNone);
    // Lecture d' l'entête du fichier wav
    FWAVFile.Read(FWave,SizeOf(TWaveHeader));
    if FWave.Marker2='WAVE' then begin
      // C'est un fichier Wav
      InputBufSize:=FNumSamples * FWave.BytesPerSample;
      FileLength := FWAVFile.Size - SizeOf(TWaveHeader);
    end else begin
      // C'est un fichier Pcm
      if FMode = BE_MP3_MODE_MONO then InputBufSize := FNumSamples
                                  else InputBufSize := FNumSamples*2;
      FileLength := FWAVFile.Size;
      FWAVFile.Seek(0,soFromBeginning);
    end;
    GetMem(FInputBuf, InputBufSize);
    Done := 0;
    while Done <> FileLength do begin
      if (Done + (InputBufSize) < FileLength) then toRead := InputBufSize
                                              else toRead := FileLength - Done;
      isRead := FWAVFile.Read(FInputBuf^,toRead);
      if isRead <> toRead then begin
        Cleanup;
        CloseCoder;
        raise EMP3CoderError.Create('Read Error');
      end;

      Err := beEncodeChunk(FHBeStream,(toRead div 2), FInputBuf, FOutputBuf, toWrite);
      if Err <> BE_ERR_SUCCESSFUL then begin
        CleanUp;
        CloseCoder;
        raise EMP3CoderError.Create('beEncodeChunk failed '+IntToStr(Err));
      end;

      IsWritten := FMp3File.Write(FOutputBuf^, toWrite);
      if toWrite <> IsWritten then begin
        Cleanup;
        CloseCoder;
        raise EMP3CoderError.Create('Write Error');
      end;

      Done := Done + toRead;
      PrcntComplete := Trunc((Done / FileLength)*100);
      if Assigned(FOnProgress) then FOnProgress(Self,PrcntComplete);
      Application.ProcessMessages;
      if FCancelProcess then begin
        Cleanup;
        CloseCoder;
        Exit;
      end;
    end; {while}

    UnprepareCoder(FOutputBuf,dwWrite);
    IsWritten := FMp3File.Write(FOutputBuf^,dwWrite);
    if dwWrite <> IsWritten then begin
      CleanUp;
      CloseCoder;
      raise EMP3CoderError.Create('Write error');
    end;
    CleanUp;
    CloseCoder;
    if Assigned(FOnEndFile) then FOnEndFile(Self,FNum,FOutputFiles[FNum]);
  end; {for}
  if Assigned(FOnEndProcess) then FOnEndProcess(Self);
end;

procedure TMP3Coder.CancelProcess;
begin
  FCancelProcess:=true;
end;

function TMP3Coder.EncodeBuffer(InBuf :pointer; OutBuf : pointer; var OutP : DWORD) : TBEERR;
begin
  Result := beEncodeChunk(FHBeStream, FNumSamples, InBuf, OutBuf, OutP);
end;

{****** TMP3CoderStream ******}
constructor TMP3CoderStream.Create(const FileName: string; Mode: Word);
begin
  FMP3Coder:=TMP3Coder.Create(Application);
  inherited Create(FileName,fmCreate or fmShareDenyNone);
  FMP3Coder.PrepareCoder;
  GetMem(FOutBuf,FMP3Coder.BufSize);
end;

destructor TMP3CoderStream.Destroy;
var
  FCount : DWORD;
begin
  FMP3Coder.UnprepareCoder(FOutBuf,FCount);
  inherited Write(FOutBuf^,FCount);
  FMP3Coder.CloseCoder;
  FMP3Coder.Free;
  FreeMem(FOutBuf);
  inherited Destroy;
end;

function TMP3CoderStream.Write(const Buffer; Count : Longint) : Longint;
var
 FCount: DWORD;
begin
  if FMP3Coder.EncodeBuffer(pointer(Buffer),FOutBuf,FCount) = BE_ERR_SUCCESSFUL then Result := inherited Write(FOutBuf^,FCount)
                                                                                else Result:=0;
end;

function TMP3CoderStream.Read(var Buffer; Count: Longint): Longint;
begin
   raise EStreamError.Create('Read from stream not supported');
end;

procedure TMP3CoderStream.SetMP3Coder(Value : TMP3Coder);
begin
  FMP3Coder.CloseCoder;
  FMP3Coder.Assign(Value);
  FMP3Coder.PrepareCoder;
end;

end.
