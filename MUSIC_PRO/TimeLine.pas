{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit TimeLine;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, Controls, Graphics, DuringTime, MMSystem, Math;

type

  TDirection=(CsToRight,CsToLeft);

{>>TKnMdTimer : piqué à Kénavo}
  TKnMdTimer = class(TComponent)
  private
    fwTimerID : DWord;
    FInterval: Integer;
    fEnabled: boolean;
    fwTimerRes : Word;
    FOnTimer: TNotifyEvent;
    FCountTime:Integer;
  protected
    procedure setEnabled( b: boolean );
    procedure SetInterval(value : Integer);
    procedure Start;
    procedure Stop;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    Property CountTime : Integer Read FCountTime Write FCountTime;
  published
    property Enabled: boolean read FEnabled write setEnabled default false;
    property Interval: integer read FInterval write SetInterval;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;
 
  {>>TITLE}
  TPanelTitle = class(TCustomControl)
  private
    fColorTitle:TColor;
    fColorSubTitle:TColor;
    fColorRectTitle:TColor;
    fTitle:String;
    fSubTitle:String;
    Procedure setColorTitle(Value:TColor);
    Procedure setColorSubTitle(Value:TColor);
    Procedure setColorRectTitle(Value:TColor);
    Procedure SetTitle(Value:String);
    Procedure SetSubTitle(Value:String);
  protected
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property ColorTitle:TColor Read fColorTitle Write SetColorTitle;
    Property ColorSubTitle:TColor Read fColorSubTitle Write SetColorSubTitle;
    Property ColorRectTitle:TColor Read fColorRectTitle Write SetColorRectTitle;
    Property Title:String Read fTitle Write SetTitle;
    Property SubTitle:String Read fSubTitle Write SetSubTitle;
  end;

  {>>TimeLine}
  TTimeLine = class(TCustomControl)
  private
    fMin:      integer;
    fMax:      integer;
    fPos:      real;
    fPanelTitle:TPanelTitle;    
    fTime:     integer;
    fColorCursor: TColor;
    fTempo:    integer;
    fDuringOfTime: TDuringOfTime;
    fUnityTime:Integer;
    Moving:Boolean;
    fStart:Boolean;
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetPos(Value: real);
    Procedure SetColorCursor(Value:TColor);
    procedure SetTempo(Value: integer);
    procedure SetDuringOfTime(Value: TDuringOfTime);
    procedure SetTime(Value:Integer);
    procedure SetStart(Value:Boolean);
    procedure TimeRule;
    procedure DrawCursor;
    procedure TimerStarting(Sender: TObject);
  protected
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: integer); override;    
  public
    Timer: TKnMdTimer;
    PlayDirection:TDirection;    
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Stop;
    Property Start:Boolean Read fStart Write SetStart;
    Property UnityTime:Integer Read fUnityTime Write fUnityTime;      
  published
    property Min: integer Read fMin Write SetMin;
    property Max: integer Read fMax Write SetMax;
    property Pos: real Read fPos Write SetPos;
    Property PanelTitle:TPanelTitle Read fPanelTitle Write fPanelTitle;    
    Property Color;
    property ColorCursor: TColor Read fColorCursor Write SetColorCursor;	
    property Time: integer Read fTime Write SetTime;
    property Tempo: integer Read fTempo Write SetTempo;
    property DuringOfTime: TDuringOfTime Read fDuringOfTime Write SetDuringOfTime;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TTimeLine]);
end;

procedure TimerCallback(wTimerID : UInt; msg : UInt; dwUser, dw1, dw2 : dword); stdcall;
begin
  if (not (TObject(dwUser) is TKnMdTimer)) Or (not(TKnMdTimer(dwUser).fwTimerID = wTimerID)) then exit;
  if assigned(TKnMdTimer(dwUser).fOnTimer) then TKnMdTimer(dwUser).OnTimer(TObject(dwUser));
  TKnMdTimer(dwUser).CountTime:=TKnMdTimer(dwUser).CountTime+TKnMdTimer(dwUser).Interval;
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
  FCountTime:=0;  
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

{>>TITLE}
constructor TPanelTitle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorRectTitle:=$00AE8051;
  Title:='MUSIC PRO';
  fColorTitle:=$0098D7F1;
  SubTitle:='TIMELINE';
  fColorSubTitle:=clRed;
  DoubleBuffered:=True;
end;

destructor TPanelTitle.Destroy;
begin
  inherited;
end;

Procedure TPanelTitle.setColorTitle(Value:TColor);
Begin
  fColorTitle:=Value;
  Invalidate;
End;

Procedure TPanelTitle.setColorSubTitle(Value:TColor);
Begin
  fColorSubTitle:=Value;
  Invalidate;
End;

Procedure TPanelTitle.setColorRectTitle(Value:TColor);
Begin
  fColorRectTitle:=Value;
  Invalidate;
End;

Procedure TPanelTitle.SetTitle(Value:String);
Begin
  fTitle:=Value;
  Invalidate;
End;

Procedure TPanelTitle.SetSubTitle(Value:String);
Begin
  fSubTitle:=Value;
  Invalidate;
End;

procedure TPanelTitle.Resize;
Begin
  Width:=128;
  If Height<43 Then
  Height:=43;
  Invalidate;
End;

procedure TPanelTitle.Paint;
Var
  RectTitle:TRect;
  WidthString,HeightString,LeftString,TopString:Integer;
Begin
  InHerited;
  With Canvas Do
    Begin
      Brush.Style:=BsClear;
      With RectTitle Do
        Begin
          Left:=0;
          Right:=Self.Width;
          Top:=0;
          Bottom:=38;
          Brush.Color:=Self.fColorRectTitle;
          Pen.Color:=ClBlack;
          Pen.Width:=1;
          Rectangle(RectTitle);

          Font.Name:='ARIAL';
          Font.Size:=10;
          Font.Color:=fColorTitle;
          LeftString:=Round(0.05*Self.Width);
          TopString:=Pen.Width;
          TextOut(LeftString,TopString,fTitle);

          Font.Name:='Comic Sans MS';
          Font.Size:=8;
          Font.Color:=Self.fColorSubTitle;
          WidthString:=TextWidth(fSubTitle);
          HeightString:=TextHeight(fSubTitle);
          LeftString:=Self.Width-WidthString-10;
          TopString:=Bottom-Pen.Width-HeightString;
          TextOut(LeftString,TopString,fSubTitle);
        End;
    End
End;

{>>TimeLine}
constructor TTimeLine.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  fMin      := 0;
  fMax      := 10;
  Color    := $00AE8051;
  fPos      := 0;
  Moving   := False;
  Timer     := TKnMdTimer.Create(Self);
  Timer.Interval:=10;
  Timer.Enabled := False;
  Timer.OnTimer := TimerStarting;
  fPanelTitle:=TPanelTitle.Create(Self);
  With fPanelTitle Do
    Begin
      Parent:=Self;
      Name:='PanelTitle';
      SetSubComponent(True);
      Top:=7;
      Left:=7;
      Width:=128;
      Height:=33;
    End;
  fTempo    := 60;
  fDuringOfTime := QuarterNote;
  fTime     := 4;
end;

destructor TTimeLine.Destroy;
begin
  Timer.Free;
  inherited;
end;              

procedure TTimeLine.SetMin(Value: integer);
begin
  fMin := Value;
  Invalidate;
end;

procedure TTimeLine.SetMax(Value: integer);
begin
  fMax := Value;
  Invalidate;
end;

procedure TTimeLine.SetPos(Value: real);
begin
  fPos := Value;
  if fPos < fMin then fPos := fMin;
  if fPos > fMax then fPos := fMax;
  Invalidate;
end;

procedure TTimeLine.SetColorCursor(Value: TColor);
begin
  fColorCursor := Value;
  Invalidate;
end;

procedure TTimeLine.SetTempo(Value: integer);
begin
  fTempo := Value;
  SetDuringOfTime(fDuringOfTime);
end;

procedure TTimeLine.SetDuringOfTime(Value: TDuringOfTime);
var
  DuringCoef: real;
begin
  fDuringOfTime := Value;
  DuringCoef     := 4;
  case fDuringOfTime of
    WholeNote: DuringCoef  := 4;
    HalfNote: DuringCoef  := 2;
    QuarterNote: DuringCoef  := 1;
    Quavers: DuringCoef := 0.5;
    SixteenthNote: DuringCoef := 0.25;
    DemiSemiQuavers: DuringCoef := 0.125;
  end;
  fUnityTime :=(Round(60 * DuringCoef * 1000)) div fTempo;
end;

procedure TTimeLine.SetTime(Value:Integer);
begin
  fTime:=Value;
  Invalidate;
end;

procedure TTimeLine.SetStart(Value:Boolean);
begin
  SetDuringOfTime(fDuringOfTime);
  Timer.Enabled :=Value;
  fStart:=Value;
end;

procedure TTimeLine.Stop;
begin
  Timer.Enabled :=False;
  fPos:=0;
end;

procedure TTimeLine.TimerStarting(Sender: TObject);
Var
  DecPrg:Integer;
begin
  DecPrg:=fMax-fMin;
  If PlayDirection=CsToRight Then FPos :=FPos+10/(FTime*fUnityTime)
  Else FPos :=FPos-10/(FTime*fUnityTime);
  if fPos >= fMax then
  Begin
    Inc(fMin,DecPrg);
    Inc(fMax,DecPrg);
  End;
  if fPos <= fMin then
  Begin
    Dec(fMin,DecPrg);
    Dec(fMax,DecPrg);
  End;
  Invalidate;
End;

procedure TTimeLine.Resize;
begin
  Height := 50;
  Invalidate;
end;

procedure TTimeLine.Paint;
begin
  inherited;
  With Canvas Do
    Begin
      TimeRule;
      DrawCursor;
    End;  
end;

procedure TTimeLine.TimeRule;
var
  IndexLine, Nm, LeftText, TopText: integer;
begin
  with Canvas do
  begin
    Nm := 0;
    Width := (fMax - fMin) *fTime * 20 + 200;
    Pen.Color:=fColorCursor;
    Brush.Style:=BsClear;
    Pen.Width := 2;
    MoveTo(140, Height*9 Div 10);
    LineTo(Width - 60, Height*9 Div 10);
    Pen.Width := 1;
    Font.Name:='MS Serif';
    Font.Size:=6;
    Font.Color:=fColorCursor;
    for IndexLine := 0 to (fMax-fMin) * fTime do
    begin
      MoveTo(140+IndexLine*20,Height*9 Div 10);
      LineTo(140+IndexLine*20,2*Height Div 3);
      if (IndexLine mod Time = 0) then
      begin
        MoveTo(140+IndexLine*20, Height*9 Div 10);
        LineTo(140+IndexLine*20, Height Div 2);
	LeftText:=140+IndexLine*20-TextWidth(IntToStr(fMin + Nm)) Div 2;
	TopText:=Height Div 2-TextHeight(IntToStr(fMin + Nm));
        TextOut(LeftText,TopText,IntToStr(fMin + Nm));
        Inc(Nm);
      End;
    end;
  end;
end;

procedure TTimeLine.DrawCursor;
var
  Triangular: array [0..2] of TPoint;
  LPos:  Integer;
begin
  With Canvas Do
    Begin
      Brush.Color :=fColorCursor;
      Brush.Style := BsSolid;
      LPos :=Round(140+(Width-200)*(fPos-fMin) / (fMax-fMin));
      Triangular[0] := Point(LPos, Height Div 4);
      Triangular[1] := Point(LPos + 4,Height Div 6);
      Triangular[2] := Point(LPos - 4, Height Div 6);
      Polygon(Triangular);
    End;
end;

procedure TTimeLine.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  LPos: real;
begin
  inherited;
  if Shift = [ssLeft] then
  begin
    LPos := 140 + ((Width - 200) * (fPos - fMin) / (fMax - fMin));
    if (X <= LPos + 10) and (X >= LPos - 10) and (Y >= Height Div 6) and
      (Y <= Height Div 4) then Moving:=True;
  end;
end;                          

procedure TTimeLine.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
  if (Moving = True) and (Shift = [ssLeft]) then
  begin
    if X < 140 then X := 140;
    if X > Width - 60 then X := Width - 60;
    Pos:= (X - 140) * (fMax - fMin) / (Width - 200) + fMin;
  end;
end;

procedure TTimeLine.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  Moving := False;
end;

End.