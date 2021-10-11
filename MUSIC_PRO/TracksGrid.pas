{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
{COLLABORATEUR : DEEFAZE - 2008 ------- Code pour les DSP Effects comme AutoWah}

unit TracksGrid;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, Controls, Graphics, TrackTime, MMSystem, Math;

type

  TTypeDSP=(TEcho,TFlanger,TVolume,TReverb,TLowPassFilter,TAmplification,
            TAutoWah,TEcho2,TPhaser,TEcho3,TChorus,TAllPassFilter,TCompressor,
	    TDistortion);

  TMode = (MdNone, MdSelect, MdMove);
  TTracksGrid = class;
  TTrackCnt=class;
  TTrack=class;
  TPartCnt=Class;
  TPart=Class;
  TVST=class;
  TEgalizer=Class;

  TStereo=(Mono,Stereo);

{>>TKnMdTimer : piqué à Kénavo}
  TKnMdTimer = class(TComponent)
  private
    fwTimerID : DWord;
    FInterval: integer;
    fEnabled: boolean;
    fwTimerRes : Word;
    FOnTimer: TNotifyEvent;
  protected
    procedure setEnabled( b: boolean );
    procedure SetInterval(value : Integer);
    procedure Start;
    procedure Stop;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Enabled: boolean read FEnabled write setEnabled default false;
    property Interval: integer read FInterval write SetInterval;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;  

{>>TCustomCollectionItem }
  TCustomCollectionItem = class(TCollectionItem)
  private
    fBeginTime  :Integer;
    fEndTime    :Integer;
    fOffsetTime :Integer;
    fPriority   :Integer;
    fMute :Boolean;
    fActif :Boolean;
    fStream:DWord;
    fName:String;
    fFileName:String;
    fOnChange: TNotifyEvent;
  protected
    procedure Change; virtual;
    procedure AssignTo(Dest : TPersistent); override;  
    function GetDisplayName : string; override;
  public 
    constructor Create(Collection : TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    property BeginTime    : Integer Read fBeginTime Write fBeginTime;
    property EndTime      : Integer Read fEndTime Write fEndTime;
    property OffsetTime   : Integer Read fOffsetTime Write fOffsetTime;
    property Priority     : Integer Read fPriority Write fPriority;
    property Mute         : Boolean Read fMute Write fMute;
    property Actif        : Boolean Read fActif Write fActif;
    property Stream       : DWord Read fStream Write fStream;
    property Name         : String Read fName Write fName;
    property FileName     : String Read fFileName Write fFileName;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TBand}
 TBand = class(TCustomCollectionItem)
  private
    fReals   : array[0..3] of Real;
    fOnChange: TNotifyEvent;
  protected
    procedure Change;  override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;
    function  GetSingle(index: integer): single;
    procedure SetSingle(index: integer; value: single);
    procedure Assign(Source : TPersistent); override;
  published
    Property Bandwidth   :single index 0 Read GetSingle write SetSingle;
    Property Q         :single index 1 Read GetSingle write SetSingle;
    Property Gain    :single index 2 Read GetSingle write SetSingle;
    Property Center        :single index 3 Read GetSingle write SetSingle;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TBandCnt}
  TBandCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TBand;
    procedure SetItem(Index: integer; Value: TBand);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TEgalizer);
    function Add: TBand;
    property Items[Index: integer]: TBand Read GetItem Write SetItem;
  end;

{>>TEgalizer}
 TEgalizer = class(TCustomCollectionItem)
  private
    fBandCnt:TBandCnt;
    fOnChange: TNotifyEvent;
  protected
    procedure Change;  override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    Property BandCnt : TBandCnt Read fBandCnt Write fBandCnt;
    property OnChange:TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TEgalizerCnt}
  TEgalizerCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TEgalizer;
    procedure SetItem(Index: integer; Value: TEgalizer);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TEgalizer;
    property Items[Index: integer]: TEgalizer Read GetItem Write SetItem;
  end;

{>>TDSP}
 TDSP = class(TCustomCollectionItem)
  private 
    fReals   : array[0..21] of Real;
    flDelay:Integer;
    fTypeDSP:TTypeDSP;
    fOnChange: TNotifyEvent;
  protected
    procedure Change; override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    function GetReal(index: integer): Real;
    procedure SetReal(index: integer; value: Real);
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published { properties }
    Property lDelay      :Integer Read flDelay Write flDelay;
    Property Level       :Real index 0 Read GetReal write SetReal;
    Property Delay       :Real index 1 Read GetReal write SetReal;
    Property WetDry      :Real index 2 Read GetReal write SetReal;
    Property DryMix      :Real index 3 Read GetReal write SetReal;
    Property WetMix      :Real index 4 Read GetReal write SetReal;
    Property Feedback    :Real index 5 Read GetReal write SetReal;
    Property Speed       :Real index 6 Read GetReal write SetReal;
    Property MinSweep    :Real index 7 Read GetReal write SetReal;
    Property MaxSweep    :Real index 8 Read GetReal write SetReal;
    Property Threshold   :Real index 9 Read GetReal write SetReal;
    Property Attacktime  :Real index 10 Read GetReal write SetReal;
    Property Releasetime :Real index 11 Read GetReal write SetReal;
    Property Volume      :Real index 12 Read GetReal write SetReal;
    Property Resonance   :Real index 13 Read GetReal write SetReal;
    Property CutOffFreq  :Real index 14 Read GetReal write SetReal;
    Property Target      :Real index 15 Read GetReal write SetReal;
    Property Quiet       :Real index 16 Read GetReal write SetReal;
    Property Rate        :Real index 17 Read GetReal write SetReal;
    Property Range       :Real index 18 Read GetReal write SetReal;
    Property Freq        :Real index 19 Read GetReal write SetReal;
    Property Gain        :Real index 20 Read GetReal write SetReal;
    Property Drive       :Real index 21 Read GetReal write SetReal;
    Property TypeDSP     :TTypeDSP Read fTypeDSP Write fTypeDSP;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TDSPCnt}
  TDSPCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TDSP;
    procedure SetItem(Index: integer; Value: TDSP);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TDSP;
    property Items[Index: integer]: TDSP Read GetItem Write SetItem;
  end;

{>>TVSTParam}
  TVSTParam=class(TCustomCollectionItem)
  protected
    fName:String;
    fUnit:String;
    fDisplay:String;
    fDefaultValue : Single;
    fValue:Single;
    fOnChange: TNotifyEvent;
  protected
    procedure Change; override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    procedure Assign(Source : TPersistent); override;
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;
  Published
    Property Name:String Read fName Write fName;
    Property AUnit:String Read fUnit Write fUnit;
    Property Display:String Read fDisplay Write fDisplay;
    Property DefaultValue:Single Read fDefaultValue Write fDefaultValue;
    Property Value:Single Read fValue Write fValue;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;    
  end;

{>>TVSTParamCnt}
  TVSTParamCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TVSTParam;
    procedure SetItem(Index: integer; Value: TVSTParam);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TVST);
    function Add: TVSTParam;
    property Items[Index: integer]: TVSTParam Read GetItem Write SetItem;
  end;

{>>TVST}
  TVST=class(TCustomCollectionItem)
  private
    fOnChange: TNotifyEvent;
  protected
    fVSTParamCnt:TVSTParamCnt;
    fUniqueID:DWord;
    procedure Change; override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    VSTForm:TForm;
    procedure Assign(Source : TPersistent); override;
    constructor Create(Collection : TCollection);  override; 
    destructor Destroy; override;  
  Published
    property VSTParamCnt: TVSTParamCnt Read FVSTParamCnt Write FVSTParamCnt;
    Property UniqueID:DWord Read fUniqueID Write fUniqueID;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;    
  end;

{>>TVSTCnt}
  TVSTCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TVST;
    procedure SetItem(Index: integer; Value: TVST);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TVST;
    property Items[Index: integer]: TVST Read GetItem Write SetItem;
  end;

{>>TSndFont}
  TSndFont=class(TCustomCollectionItem)
  private
    fOnChange: TNotifyEvent;  
  protected
    fPreset:Integer;
    fBank:Integer;
    procedure Change; override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    procedure Assign(Source : TPersistent); override;
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;  
  Published
    Property Preset:Integer Read fPreset Write fPreset;
    Property Bank:Integer Read fBank Write fBank;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;    
  end;

{>>TSndFontCnt}
  TSndFontCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TSndFont;
    procedure SetItem(Index: integer; Value: TSndFont);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TSndFont;
    property Items[Index: integer]: TSndFont Read GetItem Write SetItem;
  end;

{>>TSlide}
  TSlide=class(TCustomCollectionItem)
  private
    fOnChange: TNotifyEvent;    
  protected
    fBeginVolume:Integer;
    fEndVolume:Integer;
    procedure Change; override;
    procedure AssignTo(Dest : TPersistent); override;
    function GetDisplayName : string; override;
  public
    procedure Assign(Source : TPersistent); override;
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;  
  Published
    Property BeginVolume:Integer Read fBeginVolume Write fBeginVolume;
    Property EndVolume:Integer Read fEndVolume Write fEndVolume;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TSlideCnt}
  TSlideCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TSlide;
    procedure SetItem(Index: integer; Value: TSlide);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TSlide;
    property Items[Index: integer]: TSlide Read GetItem Write SetItem;
  end;
  
{>>TPart}  
 TPart=class(TCustomCollectionItem)
  private
    fOnChange: TNotifyEvent;   		
  protected
    fPicture : TPicture;
    procedure Change; override;
    Procedure SetPicture(Value:TPicture);
    function GetDisplayName : string; override;
  public
    Selected:Boolean; 
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;  
    procedure Assign(Source : TPersistent); override;
  published
    property Picture : TPicture Read FPicture Write SetPicture;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;    
  end;    
  
{>>TPartCnt}
  TPartCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TPart;
    procedure SetItem(Index: integer; Value: TPart);
  public
    constructor Create(AOwner: TTrack);
    function Add: TPart;
    property Items[Index: integer]: TPart Read GetItem Write SetItem;
  end;
  
{>>TTrack}
 TTrack=class(TCustomCollectionItem)
  protected
    fVolume:DWord;
    fStereo:TStereo;	
    fLeftCanal:DWord;
    fRightCanal:DWord;
    fFreq:DWord;
    fTempo:DWord;
    fOnChange: TNotifyEvent;
    fPartCnt:TPartCnt;
    fSlideCnt:TSlideCnt;
    fEffects : array[0..4] of TOwnedCollection;
    function GetAsTSndFontCnt(const index: integer): TSndFontCnt;
    function GetAsTVSTCnt(const index: integer): TVSTCnt;
    function GetAsTDSPCnt(const index: integer): TDSPCnt;
    function GetAsTEgalizerCnt(const index: integer): TEgalizerCnt;
    function GetItemEffect(index: integer): TOwnedCollection;
    procedure SetAsTSndFontCnt(const Index: Integer; const Value: TSndFontCnt);
    procedure SetAsTVSTCnt(const Index: Integer; const Value: TVSTCnt);
    procedure SetAsTDSPCnt(const Index: Integer; const Value: TDSPCnt);
    procedure SetAsTEgalizerCnt(const Index: Integer; const Value: TEgalizerCnt);
    procedure SetItemEffect(index: integer; const Value: TOwnedCollection);
    procedure Change; override;
    function GetDisplayName : string; override;	  
  public
    constructor Create(Collection : TCollection);  override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
    property ItemsEffect[Index: integer]: TOwnedCollection  Read GetItemEffect Write SetItemEffect;
  published
    Property Volume: DWord Read fVolume Write fVolume Default 50;
    Property Stereo: TStereo Read fStereo Write fStereo Default Stereo;
    Property LeftCanal:DWord Read fLeftCanal Write fLeftCanal Default 50;
    Property RightCanal:DWord Read fRightCanal Write fRightCanal Default 50;	
    Property Freq:DWord Read fFreq Write fFreq;
    Property Tempo:DWord Read fTempo Write fTempo;
    Property PartCnt: TPartCnt read fPartCnt write fPartCnt;
    Property SlideCnt: TSlideCnt read fSlideCnt write fSlideCnt;
    Property SoundFontCnt: TSndFontCnt Index 0 read GetAsTSndFontCnt write SetAsTSndFontCnt;
    Property VSTICnt: TVSTCnt Index 1 read GetAsTVSTCnt write SetAsTVSTCnt;
    Property VSTECnt: TVSTCnt Index 2 read GetAsTVSTCnt write SetAsTVSTCnt;
    Property DSPCnt: TDSPCnt Index 3 read GetAsTDSPCnt write SetAsTDSPCnt;
    Property EgalizerCnt: TEgalizerCnt Index 4 read GetAsTEgalizerCnt write SetAsTEgalizerCnt;
    property OnChange: TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TTrackCnt}
  TTrackCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TTrack;
    procedure SetItem(Index: integer; Value: TTrack);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TTrack;
    property Items[Index: integer]: TTrack Read GetItem Write SetItem;
  end;

{>>TTracksGrid}

  TOnActionPart_Event = procedure(Sender: TObject;CrTrack:TTrack;CrPart:TPart) of object;
  TOnCutPart_Event = procedure(Sender: TObject;CrTrack:TTrack;LeftPart,RightPart,DelPart:TPart) of object;

  TTracksGrid = class(TCustomControl)
  private
    fColorBackGround:TColor;
    fColorSelection:TColor;
    fHeightTrack:Integer;
    fTrackTime:TTrackTime;
    fMasterStream:DWord;
    fVolume:DWord;
    fStereo:TStereo;	
    fLeftCanal:DWord;
    fRightCanal:DWord;
    fTrackCnt:TTrackCnt;
    XOld:Integer;
    YOld:Integer;
    fMode:    TMode;
    fStart:Boolean;
    fOnDeletePart_Event:TOnActionPart_Event;
    fOnMergePart_Event:TOnActionPart_Event;
    fOnCopyPart_Event:TOnActionPart_Event;
    fOnPastPart_Event:TOnActionPart_Event;
    fOnCutPart_Event:TOnCutPart_Event;
    fOnMovePart_Event:TOnActionPart_Event;
    Procedure SetColorBackGround(Value:TColor);
    Procedure SetColorSelection(Value:TColor);
    Procedure SetHeightTrack(Value:Integer);
    Procedure SetTrackTime(Value:TTrackTime);
    Procedure Set_Mode(Value:TMode);
    Procedure SetStart(Value:Boolean);
    procedure TimerStarting(Sender: TObject);    
  protected
    Procedure SelectPart(X:Integer);
    Procedure MoveParts(X:Integer);    
  public
    TempPartCnt:TPartCnt;
    Timer:TKnMdTimer;
    Property Start:Boolean Read fStart Write SetStart;
    Procedure Stop;        
    Function MsToPixel(Value:Integer):Integer;
    Function PixelToMs(Value:Integer):Integer;
    Procedure DelParts;
    Procedure MergeParts;
    Procedure CopyParts;
    Procedure PastParts;
    Procedure CutParts;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer); override;
    Procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  published
    Property MasterStream:DWord Read fMasterStream Write fMasterStream;
    Property Volume: DWord Read fVolume Write fVolume;
    Property Stereo: TStereo Read fStereo Write fStereo;
    Property LeftCanal:DWord Read fLeftCanal Write fLeftCanal;
    Property RightCanal:DWord Read fRightCanal Write fRightCanal;
    Property TrackCnt:TTrackCnt Read fTrackCnt Write fTrackCnt;
    Property TrackTime:TTrackTime Read fTrackTime Write SetTrackTime;
    Property HeightTrack:Integer read fHeightTrack Write SetHeightTrack;
    Property ColorBackGround:TColor read fColorBackGround Write SetColorBackGround;
    Property ColorSelection:TColor read fColorSelection Write SetColorSelection;
    property Mode: TMode Read fMode Write Set_Mode;
    property OnDeletePart: TOnActionPart_Event Read fOnDeletePart_Event Write fOnDeletePart_Event;
    property OnMergePart: TOnActionPart_Event Read fOnMergePart_Event Write fOnMergePart_Event;
    property OnCopyPart: TOnActionPart_Event Read fOnCopyPart_Event Write fOnCopyPart_Event;
    property OnPastPart: TOnActionPart_Event Read fOnPastPart_Event Write fOnPastPart_Event;
    property OnCutPart: TOnCutPart_Event Read fOnCutPart_Event Write fOnCutPart_Event;
    property OnMovePart: TOnActionPart_Event Read fOnMovePart_Event Write fOnMovePart_Event;
    Property OnClick;
    Property OnDblClick;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnMouseWheel;
    Property OnMouseWheelDown;
    Property OnMouseWheelUp;
    Property OnResize;
  end;
  
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TTracksGrid]);
end;

procedure TimerCallback(wTimerID : UInt; msg : UInt; dwUser, dw1, dw2 : dword); stdcall;
begin
  if (not (TObject(dwUser) is TKnMdTimer)) Or (not(TKnMdTimer(dwUser).fwTimerID = wTimerID)) then exit;
  if assigned(TKnMdTimer(dwUser).fOnTimer) then TKnMdTimer(dwUser).OnTimer(TObject(dwUser));
end;

{>>TKnMdTimer : piqué à Kénavo}
constructor TKnMdTimer.Create( AOwner: TComponent );
var
  tc : TimeCaps;
begin
  Inherited Create(Aowner);
  if (timeGetDevCaps(@tc, sizeof(TIMECAPS)) <> TIMERR_NOERROR) then exit;
  fwTimerRes := min(max(tc.wPeriodMin, 1), tc.wPeriodMax);
  timeBeginPeriod(fwTimerRes);
  fInterval :=10;
  fEnabled := False;
end;

destructor TKnMdTimer.Destroy;
begin
  if fEnabled then Stop;
  inherited Destroy;
end;

procedure TKnMdTimer.SetEnabled( b: boolean );
begin
  if b <>fEnabled then
    begin
      fEnabled := b;
      if fEnabled then Start
      else Stop;
    end;
end;

procedure TKnMdTimer.SetInterval(value : Integer);
begin
  if (Value <>fInterval) and (value >= fwTimerRes) then
    begin
      Stop;
      fInterval := Value;
      if fEnabled then Start;
    end;
end;

procedure TKnMdTimer.Start;
begin
  fwTimerID := timeSetEvent(fInterval,fwTimerRes,@TimerCallback,DWord(Self),1);
end;

procedure TKnMdTimer.Stop;
begin
  timeKillEvent(fwTimerID);
end;

{>>TTracksGrid}
constructor TTracksGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Timer     := TKnMdTimer.Create(Self);
  Timer.Interval:=10;
  Timer.Enabled := False;
  Timer.OnTimer := TimerStarting;  
  fTrackCnt:=TTrackCnt.Create(Self);
  fTrackCnt.ItemIndex:=-1;
  Width:=500;
  fHeightTrack:=80;
  fColorBackGround:=$00C9CAB7;
  DoubleBuffered:=True;
  XOld:=0;
  YOld:=0;
  TempPartCnt:=TPartCnt.Create(Nil);
  fVolume:=100;
  fLeftCanal:=50;
  fRightCanal:=50;
end;

destructor TTracksGrid.Destroy;
begin
  fTrackCnt.Free;
  TempPartCnt.Free;
  inherited;
end;

Function TTracksGrid.MsToPixel(Value:Integer):Integer;
Begin
   With fTrackTime Do
   Result:=Round((80*Zoom*60*Value) / (Time*Tempo*DuringCoef*1000));
End;

Function TTracksGrid.PixelToMs(Value:Integer):Integer;
Begin
   With fTrackTime Do
  Result:=Round((Value*Time*Tempo*DuringCoef*1000)/(80*Zoom*60));
End;

Procedure TTracksGrid.SetColorBackGround(Value:TColor);
begin
  fColorBackGround:=Value;
  Invalidate;
end;

Procedure TTracksGrid.SetColorSelection(Value:TColor);
begin
  fColorSelection:=Value;
  Invalidate;
end;

Procedure TTracksGrid.SetHeightTrack(Value:Integer);
begin
  fHeightTrack:=Value;
  Invalidate;
end;

Procedure TTracksGrid.SetTrackTime(Value:TTrackTime);
Begin
  fTrackTime:=Value;
  Invalidate;
End;

Procedure TTracksGrid.Set_Mode(Value:TMode);
Begin
  If Value<>fMode Then
    Begin
      fMode:=Value;
      If fMode=MdSelect Then TempPartCnt.Clear;
    End;
End;

Procedure TTracksGrid.SetStart(Value:Boolean);
begin
  Timer.Enabled := Value; 
  fStart:=Value;
end;

Procedure TTracksGrid.Stop;
begin
  Timer.Enabled :=False;
  fTrackTime.Pos:=0;
end;

procedure TTracksGrid.TimerStarting(Sender: TObject);
begin
  Timer.Enabled:=False;
  If Assigned(fTrackTime) Then
    Begin
      fTrackTime.Pos:=fTrackTime.Pos+Timer.Interval;
      Invalidate;
      Application.ProcessMessages;
    End;
  Timer.Enabled:=True;
end;

Procedure TTracksGrid.Paint;
Var
  IndexTrack,IndexPart,ALeftDelim, ARightDelim, APos:Integer;
  LineRect, ImageRect, SelectRect:TRect;
Begin
  InHerited;
  If fTrackCnt.Count>0 Then
  Height:=(fTrackCnt.Count)*fHeightTrack
  Else Height:=80;
  With Canvas Do
    Begin
      Pen.Width:=1;
      Brush.Style:=BsClear;
      Pen.Color:=ClBlack;
      Brush.Color:=fColorBackGround;
      Rectangle(ClientRect);
      If fTrackCnt.Count<=0 Then Exit;
      For IndexTrack:=0 To fTrackCnt.Count-1 Do
        Begin
          With LineRect Do
            Begin
              Left:=0;
              Right:=Width;
              Top:=fHeightTrack*IndexTrack;
              Bottom:=Top+fHeightTrack;
              If IndexTrack=fTrackCnt.ItemIndex Then
              Brush.Color:=fColorSelection
              Else Brush.Color:=fColorBackGround;
              Rectangle(LineRect);
            End;
        End;
      Brush.Color:=ClWhite;
      For IndexTrack:=0 To fTrackCnt.Count-1 Do
        Begin
          If fTrackCnt.Items[IndexTrack].fPartCnt.Count>0 Then
          For IndexPart:=0 To fTrackCnt.Items[IndexTrack].fPartCnt.Count-1 Do
            Begin
              With fTrackTime Do
              With fTrackCnt.Items[IndexTrack].fPartCnt.Items[IndexPart] Do
              With SelectRect Do
                Begin
                  Left:=MsToPixel(BeginTime);
                  Right:=MsToPixel(EndTime);
                  Top:=IndexTrack*fHeightTrack+2;
                  Bottom:=Top+fHeightTrack-4;
                  ImageRect.Left:=Left+3;
                  ImageRect.Right:=Right-3;
                  ImageRect.Top:=Top+3;
                  ImageRect.Bottom:=Bottom-3;
                  Pen.Width:=1;
                  If Selected Then Pen.Color:=ClRed
                  Else Pen.Color:=ClBlack;
                  Canvas.Rectangle(SelectRect);
                  StretchDraw(ImageRect,fPicture.Graphic);
                End;
            End;
        End;
    End;
  If Assigned(fTrackTime) Then
  With Canvas Do
    Begin
      If fTrackTime.Pos_Show Then
        Begin
          Pen.Color:=ClRed;
          APos:=MsToPixel(fTrackTime.Pos);
          MoveTo(APos,1);
          LineTo(APos,Height-1);
        End;
      If fTrackTime.Delims_Show Then
        Begin
          Pen.Color:=ClBlack;
          ALeftDelim:=MsToPixel(fTrackTime.LeftDelim);
          MoveTo(ALeftDelim,0);
          LineTo(ALeftDelim,Height);
          ARightDelim:=MsToPixel(fTrackTime.RightDelim);
          MoveTo(ARightDelim,0);
          LineTo(ARightDelim,Height);
        End;
    End;
End;

Procedure TTracksGrid.DelParts;
Var
  IndexPart,IndexTrack:Integer;
  SdTrack:TTrack;
  SdPart:TPart;
Begin
  If (fTrackCnt.Count>0) And (fTrackCnt.ItemIndex>=0) Then
  For IndexTrack:=0 To (fTrackCnt.Count-1) Do
  With fTrackCnt.Items[IndexTrack] Do
    Begin
      If fPartCnt.Count>0 Then
      For IndexPart:=(fPartCnt.Count-1) DownTo 0 Do
      If fPartCnt.Items[IndexPart].Selected Then
        Begin
          SdTrack:=fTrackCnt.Items[IndexTrack];
          SdPart:=fPartCnt.Items[IndexPart];
          If Assigned(fOnDeletePart_Event) Then
          fOnDeletePart_Event(Self,SdTrack,SdPart);
          fPartCnt.Delete(IndexPart);
        End;  
    End;
  Invalidate;  
End;

Procedure TTracksGrid.MergeParts;
Var
  IndexPart,IndexTrack:Integer;
  SdTrack:TTrack;
  SdPart:TPart;
Begin
  If (fTrackCnt.Count>0) And (fTrackCnt.ItemIndex>=0) Then
  For IndexTrack:=0 To (fTrackCnt.Count-1) Do
  With fTrackCnt.Items[IndexTrack] Do
    Begin
      If fPartCnt.Count>0 Then
      For IndexPart:=0 To (fPartCnt.Count-1) Do
      If (fPartCnt.Items[IndexPart].Selected) And (IndexPart>0) Then
      With fPartCnt.Items[IndexPart] Do
        Begin
          fEndTime:=fEndTime-(fBeginTime-fPartCnt.Items[IndexPart-1].fEndTime);
          fBeginTime:=fPartCnt.Items[IndexPart-1].fEndTime;
          SdTrack:=fTrackCnt.Items[IndexTrack];
          SdPart:=fPartCnt.Items[IndexPart];
          If Assigned(fOnMergePart_Event) Then
          fOnMergePart_Event(Self,SdTrack,SdPart);
        End;
    End;
  Invalidate;
End;

Procedure TTracksGrid.CopyParts;
Var
  IndexTrack,IndexPart:Integer;
  TempPart:TPart;
  SdTrack:TTrack;
  SdPart:TPart;
Begin
  TempPartCnt.Clear;
  If (fTrackCnt.Count>0) Then
  For IndexTrack:=0 To (fTrackCnt.Count-1) Do
  With fTrackCnt.Items[IndexTrack] Do
    Begin
      If PartCnt.Count>0 Then
      For IndexPart:=0 To (PartCnt.Count-1) Do
      With fPartCnt.Items[IndexPart] Do
      If Selected Then
        Begin
          TempPart:=TempPartCnt.Add;
          TempPart.Assign(fPartCnt.Items[IndexPart]);
          SdTrack:=fTrackCnt.Items[IndexTrack];
          SdPart:=fPartCnt.Items[IndexPart];
          If Assigned(fOnCopyPart_Event) Then
          fOnCopyPart_Event(Self,SdTrack,SdPart);
        End;  
    End;
  Invalidate;
End;

Procedure TTracksGrid.PastParts;
Var
  IndexPart:Integer;
  NewPart:TPart;
  SdTrack:TTrack;
Begin
  If (TempPartCnt.Count>0) And (fTrackCnt.ItemIndex>=0) Then
  For IndexPart:=0 To (TempPartCnt.Count-1) Do
  With fTrackCnt.Items[fTrackCnt.ItemIndex] Do
    Begin
      NewPart:=PartCnt.Add;
      NewPart.Assign(TempPartCnt.Items[IndexPart]);
      NewPart.Selected:=False;
      SdTrack:=fTrackCnt.Items[fTrackCnt.ItemIndex];
      If Assigned(fOnPastPart_Event) Then
      fOnPastPart_Event(Self,SdTrack,NewPart);
    End;
  Invalidate;
End;

Procedure TTracksGrid.CutParts;
Var
  IndexTrack,IndexPart:Integer;
  Rect:TRect;
  LeftPart,RightPart:TPart;
  SdTrack:TTrack;
  DelPart:TPart;
Begin
  If Not TrackTime.Delims_Show Then Exit;
  If (fTrackCnt.Count>0) Then
  For IndexTrack:=0 To (fTrackCnt.Count-1) Do
  With fTrackCnt.Items[IndexTrack] Do
    Begin
      If PartCnt.Count>0 Then
      With TrackTime Do
        Begin
          For IndexPart:=(PartCnt.Count-1) DownTo 0 Do
          With fPartCnt.Items[IndexPart] Do
          If (Selected) And (BeginTime<=LeftDelim) And (EndTime>=RightDelim) Then
            Begin
              LeftPart:=PartCnt.Add;
              LeftPart.Assign(fPartCnt.Items[IndexPart]);
              LeftPart.EndTime:=LeftDelim;
              With Rect Do
                Begin
                  Left:=0;
                  Right:=LeftDelim;
                  Top:=0;
                  Bottom:=Picture.Height;
                End;
              LeftPart.Picture.Bitmap.Canvas.CopyRect(Rect,Picture.Bitmap.Canvas,Rect);
              RightPart:=PartCnt.Add;
              RightPart.Assign(fPartCnt.Items[IndexPart]);
              RightPart.BeginTime:=RightDelim;
              RightPart.OffSetTime:=RightDelim;
              With Rect Do
                Begin
                  Left:=RightDelim;
                  Right:=EndTime;
                  Top:=0;
                  Bottom:=Picture.Height;
                End;
              RightPart.Picture.Bitmap.Canvas.CopyRect(Rect,Picture.Bitmap.Canvas,Rect);
              SdTrack:=fTrackCnt.Items[IndexTrack];
              DelPart:=fPartCnt.Items[IndexPart];
              If Assigned(fOnCutPart_Event) Then
              fOnCutPart_Event(Self,SdTrack,LeftPart,RightPart,DelPart);
              fPartCnt.Delete(IndexPart);
            End;
        End;
      Invalidate;  
    End;
End;

Procedure TTracksGrid.SelectPart(X:Integer);
Var
  IndexPart:Integer;
Begin
  If fTrackCnt.ItemIndex>-1 Then
  With fTrackCnt.Items[fTrackCnt.ItemIndex] Do
    Begin
      If PartCnt.Count>0 Then
      For IndexPart:=0 To (PartCnt.Count-1) Do
      With PartCnt.Items[IndexPart] Do
        Begin
          If (PixelToMs(X)>=fBeginTime) And (PixelToMs(X)<=fEndTime) Then
          Selected:=Not Selected;
        End;
    End;
  Invalidate;
End;

Procedure TTracksGrid.MoveParts(X:Integer);
Var
  IndexPart,IndexTrack,VarTime:Integer;
  SdTrack:TTrack;
  SdPart:TPart;  
Begin
  VarTime:=PixelToMs(X-XOld);
  If fTrackCnt.Count>0 Then
  For IndexTrack:=(fTrackCnt.Count-1) DownTo 0 Do
    With fTrackCnt.Items[IndexTrack] Do
    Begin
      If fPartCnt.Count>0 Then
      For IndexPart:=(fPartCnt.Count-1) DownTo 0 Do
      With fPartCnt.Items[IndexPart] Do
      If (Selected) And (fBeginTime+VarTime>=0) Then
        Begin
          Inc(fBeginTime,VarTime);
          Inc(fEndTime,VarTime);
          SdTrack:=fTrackCnt.Items[IndexTrack];
          SdPart:=fPartCnt.Items[IndexPart];
          If Assigned(fOnMovePart_Event) Then
          fOnMovePart_Event(Self,SdTrack,SdPart);
        End;
    End;
  XOld:=X;
  Invalidate;
End;

procedure TTracksGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  fTrackCnt.ItemIndex:=Y Div fHeightTrack;
  Invalidate;
  If (SSLeft In Shift) Then
  Case fMode Of
    MdSelect : If Not (ssShift In Shift) Then SelectPart(X)
                   Else Begin XOld:=X; YOld:=Y; End;
    MdMove : Begin XOld:=X; YOld:=Y; End;
  End;
end;

procedure TTracksGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  If (SSLeft In Shift) and (fMode=MdMove) Then MoveParts(X);
end;

{>>TTrackCnt}
constructor TTrackCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TTrack);
end;

function TTrackCnt.Add:TTrack;
begin
  Result := TTrack(inherited Add);
end;

function TTrackCnt.GetItem(Index: integer):TTrack;
begin
  Result := TTrack(inherited Items[Index]);
end;

procedure TTrackCnt.SetItem(Index: integer; Value:TTrack);
begin
  inherited SetItem(Index, Value);
end;

{>>TTrack}
constructor TTrack.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  fLeftCanal:=50;
  fRightCanal:=50;
  fVolume:=100;
  fPartCnt:=TPartCnt.Create(Self);
  fSlideCnt:=TSlideCnt.Create(Self);  
  fEffects[0]:=TSndFontCnt.Create(Self);
  fEffects[1]:=TVSTCnt.Create(Self);
  fEffects[2]:=TVSTCnt.Create(Self);
  fEffects[3]:=TDSPCnt.Create(Self);
  fEffects[4]:=TEgalizerCnt.Create(Self);
end;

destructor TTrack.Destroy;
Var
  Index:Integer;
begin
  fPartCnt.Free;
  fSlideCnt.Free;
  For Index:=0 To 4 Do
  fEffects[Index].Free;
  inherited Destroy;
end;

procedure TTrack.Assign(Source : TPersistent);
Var
  Index:Integer;
Begin
  if source is TTrack then
  begin
    fVolume:=(Source As TTrack).fVolume;
    fStereo:=(Source As TTrack).fStereo;
    fLeftCanal:=(Source As TTrack).fLeftCanal;
    fRightCanal:=(Source As TTrack).fRightCanal;
    fFreq:=(Source As TTrack).fFreq;
    fTempo:=(Source As TTrack).fTempo;
    fMute:=(Source As TTrack).fMute;
    fName:=(Source As TTrack).fName;
    fPartCnt:=(Source As TTrack).fPartCnt;
    For Index:=0 To 4 Do
    fEffects[Index]:=(Source As TTrack).fEffects[Index];
    fSlideCnt:=(Source As TTrack).fSlideCnt;
  End else
     inherited Assign(source);
End;

procedure TTrack.Change;
Begin
  if Assigned(fOnChange) then
    fOnChange(Self);
End;

function TTrack.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

function TTrack.GetAsTSndFontCnt(const index: integer): TSndFontCnt;
begin
  result := TSndFontCnt(fEffects[index]);
end;

function TTrack.GetAsTVSTCnt(const index: integer): TVSTCnt;
begin
  result := TVSTCnt(fEffects[index]);
end;

function TTrack.GetAsTDSPCnt(const index: integer): TDSPCnt;
begin
  result := TDSPCnt(fEffects[index]);
end;

function TTrack.GetAsTEgalizerCnt(const index: integer): TEgalizerCnt;
begin
  result := TEgalizerCnt(fEffects[index]);
end;

function TTrack.GetItemEffect(index: integer): TOwnedCollection;
begin
  result := fEffects[Index];
end;

procedure TTrack.SetAsTSndFontCnt(const Index: Integer; const Value: TSndFontCnt);
begin
  fEffects[index] := Value;
end;

procedure TTrack.SetAsTVSTCnt(const Index: Integer; const Value: TVSTCnt);
begin
  fEffects[index] := Value;
end;

procedure TTrack.SetAsTDSPCnt(const Index: Integer; const Value: TDSPCnt);
begin
  fEffects[index] := Value;
end;

procedure TTrack.SetAsTEgalizerCnt(const Index: Integer; const Value: TEgalizerCnt);
begin
  fEffects[index] := Value;
end;

procedure TTrack.SetItemEffect(index: integer; const Value: TOwnedCollection);
begin
  fEffects[index] := Value;
end;

{>>TPartCnt}
constructor TPartCnt.Create(AOwner: TTrack);
begin
  inherited Create(AOwner,TPart);
end;

function TPartCnt.Add:TPart;
begin
  Result := TPart(inherited Add);
end;

function TPartCnt.GetItem(Index: integer):TPart;
begin
  Result := TPart(inherited Items[Index]);
end;

procedure TPartCnt.SetItem(Index: integer; Value:TPart);
begin
  inherited SetItem(Index, Value);
end;  

{>>TPart}
constructor TPart.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  fPicture:=TPicture.Create;
end;

destructor TPart.Destroy;
begin
  fPicture.Free;
  inherited Destroy;
end;

Procedure TPart.SetPicture(Value:TPicture);
Begin
  fPicture.Assign(Value);
End;

procedure TPart.Assign(Source : TPersistent);
Begin
  if source is TPart then begin
    inherited Assign(TCustomCollectionItem(Source));
    fPicture.Assign((Source As TPart).fPicture);
    Selected:=(Source As TPart).Selected;
    fOnChange:=(Source As TPart).fOnChange;
    Change;
  End else
     inherited Assign(source);
End;

procedure TPart.Change;
Begin
  if Assigned(fOnChange) then
    fOnChange(Self);
End;

function TPart.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>GESTION DES SLIDE}
constructor TSlideCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TSlide);
end;

function TSlideCnt.Add:TSlide;
begin
  Result := TSlide(inherited Add);
end;

function TSlideCnt.GetItem(Index: integer):TSlide;
begin
  Result := TSlide(inherited Items[Index]);
end;

procedure TSlideCnt.SetItem(Index: integer; Value:TSlide);
begin
  inherited SetItem(Index, Value);
end;

{>>Slide}
constructor TSlide.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

destructor TSlide.Destroy;
begin
  inherited Destroy;
end;

procedure TSlide.AssignTo(Dest: TPersistent);
begin
  if Dest is TSlide then
    with TSlide(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));    
      fBeginVolume:=Self.fBeginVolume;
      fEndVolume:=Self.fEndVolume;
      fOnChange:=Self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TSlide.Assign(Source : TPersistent);
begin
  if source is TSlide then
     with TSlide(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TSlide.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TSlide.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>GESTION DES SNDFONT}
constructor TSndFontCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TSndFont);
end;

function TSndFontCnt.Add:TSndFont;
begin
  Result := TSndFont(inherited Add);
end;

function TSndFontCnt.GetItem(Index: integer):TSndFont;
begin
  Result := TSndFont(inherited Items[Index]);
end;

procedure TSndFontCnt.SetItem(Index: integer; Value:TSndFont);
begin
  inherited SetItem(Index, Value);
end;

{>>SndFont}
constructor TSndFont.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  Preset:=-1;  
  Bank:=0;
end;

destructor TSndFont.Destroy;
begin
  inherited Destroy;
end;

procedure TSndFont.AssignTo(Dest: TPersistent);
begin
  if Dest is TSndFont then
    with TSndFont(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));    
      fPreset:=Self.fPreset;
      fBank:=Self.fBank;
      fOnChange:=Self.fOnChange;
      Change;      
    end
  else
    inherited AssignTo(Dest);
end;

procedure TSndFont.Assign(Source : TPersistent);
begin
  if source is TSndFont then
     with TSndFont(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TSndFont.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TSndFont.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>VSTCnt}
constructor TVSTCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TVST);
end;

function TVSTCnt.Add:TVST;
begin
  Result := TVST(inherited Add);
  Result.Index:=Count-1;
end;

function TVSTCnt.GetItem(Index: integer):TVST;
begin
  Result := TVST(inherited Items[Index]);
end;

procedure TVSTCnt.SetItem(Index: integer; Value:TVST);
begin
  inherited SetItem(Index, Value);
end;

{>>VST}
constructor TVST.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  fVSTParamCnt:=TVSTParamCnt.Create(Self);
end;

destructor TVST.Destroy;
begin
  inherited Destroy;
end;

procedure TVST.AssignTo(Dest: TPersistent);
begin
  if Dest is TVST then
    with TVST(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));    
      fUniqueID := self.UniqueID;
      fVSTParamCnt:=Self.fVSTParamCnt;
      fOnChange:=Self.fOnChange;
      Change;      
    end
  else
    inherited AssignTo(Dest);
end;

procedure TVST.Assign(Source : TPersistent);
begin
  if source is TVST then
     with TVST(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TVST.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TVST.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>VSTSPARAM}
constructor TVSTParamCnt.Create(AOwner: TVST);
begin
  inherited Create(AOwner,TVSTParam);
end;

function TVSTParamCnt.Add:TVSTParam;
begin
  Result := TVSTParam(inherited Add);
end;

function TVSTParamCnt.GetItem(Index: integer):TVSTParam;
begin
  Result := TVSTParam(inherited Items[Index]);
end;

procedure TVSTParamCnt.SetItem(Index: integer; Value:TVSTParam);
begin
  inherited SetItem(Index, Value);
end;

{>>VSTPARAM}
constructor TVSTParam.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

destructor TVSTParam.Destroy;
begin
  inherited Destroy;
end;

procedure TVSTParam.AssignTo(Dest: TPersistent);
begin
  if Dest is TVSTParam then
    with TVSTParam(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));    
      fUnit        :=Self.fUnit;
      fDisplay     :=Self.fDisplay;
      fDefaultValue:=Self.fDefaultValue;
      fValue       :=Self.Value;
      fOnChange    :=Self.fOnChange;
      Change;      
    end
  else
    inherited AssignTo(Dest);
end;

procedure TVSTParam.Assign(Source : TPersistent);
begin
  if source is TVSTParam then
     with TVSTParam(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TVSTParam.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TVSTParam.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>TDSPCnt}
constructor TDSPCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TDSP);
end;

function TDSPCnt.Add:TDSP;
begin
  Result := TDSP(inherited Add);
end;

function TDSPCnt.GetItem(Index: integer):TDSP;
begin
  Result := TDSP(inherited Items[Index]);
end;

procedure TDSPCnt.SetItem(Index: integer; Value:TDSP);
begin
  inherited SetItem(Index, Value);
end;

{>>DSP}
Constructor TDSP.Create(Collection: TCollection);
Var
  N : integer;
begin
  inherited Create(Collection);
  flDelay:=0;
  for N := low(fReals) to high(fReals) do
    fReals[N] := 0;
end;

destructor TDSP.Destroy;
begin
  inherited Destroy;
end;

procedure TDSP.AssignTo(Dest: TPersistent);
begin
  if Dest is TDSP then
    with TDSP(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));
      flDelay   :=Self.flDelay;
      fReals    := Self.fReals;
      fTypeDSP  :=Self.fTypeDSP;
      fOnChange :=Self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TDSP.Assign(Source : TPersistent);
begin
  if source is TDSP then
     with TDSP(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

function TDSP.GetReal(index: integer): Real;
begin
  result := fReals[index];
end;

procedure TDSP.SetReal(index: integer; value: Real);
begin
  if fReals[index] <> value then
  begin
    fReals[index] := value;
    change;
  end;
end;

procedure TDSP.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TDSP.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>TEgalizerCnt}
constructor TEgalizerCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TEgalizer);
end;

function TEgalizerCnt.Add:TEgalizer;
begin
  Result := TEgalizer(inherited Add);
end;

function TEgalizerCnt.GetItem(Index: integer):TEgalizer;
begin
  Result := TEgalizer(inherited Items[Index]);
end;

procedure TEgalizerCnt.SetItem(Index: integer; Value:TEgalizer);
begin
  inherited SetItem(Index, Value);
end;

{>>TEgalizer}
constructor TEgalizer.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  fBandCnt:=TBandCnt.Create(Self);
end;

destructor TEgalizer.Destroy;
begin
  fBandCnt.Free;
  inherited Destroy;
end;

procedure TEgalizer.AssignTo(Dest: TPersistent);
begin
  if Dest is TEgalizer then
    with TEgalizer(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));
      fBandCnt    := Self.fBandCnt;
      fOnChange := self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TEgalizer.Assign(Source : TPersistent);
begin
  if source is TEgalizer then
     with TEgalizer(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TEgalizer.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TEgalizer.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;


{>>TBandCnt}
constructor TBandCnt.Create(AOwner: TEgalizer);
begin
  inherited Create(AOwner,TBand);
end;

function TBandCnt.Add:TBand;
begin
  Result := TBand(inherited Add);
end;

function TBandCnt.GetItem(Index: integer):TBand;
begin
  Result := TBand(inherited Items[Index]);
end;

procedure TBandCnt.SetItem(Index: integer; Value:TBand);
begin
  inherited SetItem(Index, Value);
end;

{>>TBand}
constructor TBand.Create(Collection: TCollection);
Var
  N : integer;
begin
  inherited Create(Collection);
  for N := low(fReals) to high(fReals) do
    fReals[N] := 0;
end;

destructor TBand.Destroy;
begin
  inherited Destroy;
end;

procedure TBand.AssignTo(Dest: TPersistent);
begin
  if Dest is TBand then
  with TBand(Dest) do begin
      inherited Assign(TCustomCollectionItem(Dest));
      fReals    := Self.fReals;
      fOnChange := Self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TBand.Assign(Source : TPersistent);
begin
  if source is TBand then
     with TBand(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

function TBand.GetSingle(index: integer): Single;
begin
  result := fReals[index];
end;

procedure TBand.SetSingle(index: integer; value: single);
begin
  if fReals[index] <> value then
  begin
    fReals[index] := value;
    change;
  end;
end;

procedure TBand.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TBand.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;

{>>TCustomCollectionItem}
constructor TCustomCollectionItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  fBeginTime := 0;
  fEndTime   := 0;
  fPriority  := 0;
  fStream    := 0;
  fMute      :=False;
  fActif     :=False;
end;

destructor TCustomCollectionItem.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomCollectionItem.AssignTo(Dest: TPersistent);
begin
  if Dest is TCustomCollectionItem then
    with TCustomCollectionItem(Dest) do
    begin
      fBeginTime   := Self.fBeginTime;
      fEndTime     := Self.fEndTime;
      fOffsetTime  := Self.fOffsetTime;
      fPriority    := Self.fPriority ;
      fStream      := Self.fStream ;
      fMute        := Self.fMute;
      fActif       :=Self.fActif;
      fName        := Self.fName;
      fFileName    := Self.fFileName;
      fOnChange    :=Self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TCustomCollectionItem.Assign(Source: TPersistent);
begin
  if source is TCustomCollectionItem then
     with TCustomCollectionItem(Source) do
     AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TCustomCollectionItem.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TCustomCollectionItem.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;


End.
