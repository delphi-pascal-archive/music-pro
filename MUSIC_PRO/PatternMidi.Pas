unit PatternMidi;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, DateUtils, DuringTime, Math, MMSystem;

type

  TDirection=(PlToRight,PlToLeft);

  TPatternMidi = class;

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
  
{>>TNote}
  TNote = class(TCollectionItem)
  Private
    fOnChange: TNotifyEvent;
    fBeginTime:Integer;
    fEndTime:Integer;
    fNote:Byte;
    fActived:Boolean;	
  protected
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
    function GetDisplayName : string; override;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published 
    property BeginTime:integer read fBeginTime write fBeginTime;
    property EndTime:integer read fEndTime write fEndTime;	
    property Note:Byte read fNote write fNote;	
    property Actived:Boolean read fActived write fActived;		
  end;	

{>>TNoteCnt}
  TNoteCnt = class(TOwnedCollection)
  protected  
    function GetItem(Index: integer): TNote;
    procedure SetItem(Index: integer; Value: TNote);
  public
    constructor Create(AOwner:TPersistent);
    function Add: TNote;
    property Items[Index: integer]: TNote Read GetItem Write SetItem;
  end;
  
{>>TInstrPattern}
  TInstrPattern = class(TCollectionItem)
  private { properties }
    fBytes: array[0..14] of Byte;
    fInstrument:String;
    fActived:Boolean;
    fOnChange: TNotifyEvent;
    fCollection  : TCollection;	    
    fNoteCnt:TNoteCnt;  
  protected
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
    function GetDisplayName : string; override;
    property Collection : TCollection  read fCollection write fCollection;
  public
    function GetByte(index: integer): Byte;
    procedure SetByte(index: integer; value: Byte);
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published { properties }
    Property Actived:Boolean Read fActived Write fActived;
    Property NoteCnt:TNoteCnt Read fNoteCnt Write fNoteCnt;  
    Property Instrument:String Read fInstrument Write fInstrument;
    Property Channel : Byte index 0 Read GetByte write SetByte;
    Property Instr : Byte index 1 Read GetByte write SetByte;
    Property Volume : Byte  index 2 Read GetByte write SetByte;
    Property Velocity : Byte index 3 Read GetByte write SetByte;
    Property PitchBend : Byte  index 4 Read GetByte write SetByte;
    Property ChannelPressure : Byte  index 5 Read GetByte write SetByte;
    Property Modulation : Byte  index 6 Read GetByte write SetByte;
    Property PortamentoTime : Byte index 7 Read GetByte write SetByte;
    Property PortamentoSwitch : Byte index 8 Read GetByte write SetByte;
    Property PortamentoNote : Byte  index 9 Read GetByte write SetByte;
    Property Resonance : Byte  index 10 Read GetByte write SetByte;
    Property Pan : Byte  index 11 Read GetByte write SetByte;
    Property Expression : Byte  index 12 Read GetByte write SetByte;
    Property Vibrato : Byte  index 13 Read GetByte write SetByte;
    Property Sustain : Byte  index 14 Read GetByte write SetByte;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TInstrPatternCnt}
  TInstrPatternCnt = class(TOwnedCollection)
  Private
    fOwner : TPersistent;  
  protected
    function GetItem(Index: integer): TInstrPattern;
    procedure SetItem(Index: integer; Value: TInstrPattern);
    function GetOwner: TPersistent; override;	    
  public
    constructor Create(AOwner: TPersistent);
    function Add: TInstrPattern;
    property Items[Index: integer]: TInstrPattern Read GetItem Write SetItem;
  end;

  TNote_On_Event = procedure(Sender: TObject;Instrument:TInstrPattern;Note:TNote) of object;
  TNote_Off_Event = procedure(Sender: TObject;Instrument:TInstrPattern;Note:TNote) of object;
  TInstrClick_Event=TNotifyEvent;
  TPlaying_Event=TNotifyEvent;

  TPatternMidi = class(TCustomControl)
  private
    fColorKeyActive: TColor;
    fColorKeyDesactive: TColor;
    fColorKeyPlayed: TColor;
    fColorInstrfActived: TColor;
    fColorInstrDisfActived: TColor;
    fColorInstr: TColor;
    fOnNote_On: TNote_On_Event;
    fOnNote_Off: TNote_Off_Event;
    fInstrPatternCnt:TInstrPatternCnt;
    fTempo:     integer;
    fDuringOfTime: TDuringOfTime;
    fNbCases:Integer;
    PlayingCursor:Integer;
    fStart:Boolean;
    fOnInstrClick:TInstrClick_Event;
    fOnPlaying:TPlaying_Event;
    Procedure Set_ColorKeyActive(Value: TColor);
    Procedure Set_ColorKeyDesactive(Value: TColor);
    Procedure Set_ColorKeyPlayed(Value: TColor);
    Procedure Set_ColorInstrfActived(Value: TColor);
    Procedure Set_ColorInstrDisfActived(Value: TColor);
    Procedure Set_ColorInstr(Value: TColor);
    procedure SetTempo(Value: integer);
    procedure SetDuringOfTime(Value: TDuringOfTime);
    Procedure SetIntervalTimer(ATempo:Integer;ADuringOfTime:TDuringOfTime);
    Procedure SetNbCases(Value:Integer);
    procedure TimerStarting(Sender: TObject);
    Procedure SetStart(Value:Boolean);
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    InstrumentSelected:Integer;
    PlayingTime:TTime;
    Timer:TKnMdTimer;
    PlayDirection:TDirection;
    Property Start:Boolean Read fStart Write SetStart;
    Procedure Stop;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Procedure Paint; override;
  published
    Property Color;
    Property ColorKeyActive:TColor Read fColorKeyActive Write Set_ColorKeyActive;
    Property ColorKeyDesactive:TColor Read fColorKeyDesactive Write Set_ColorKeyDesactive;
    Property ColorKeyPlayed:TColor Read fColorKeyPlayed Write Set_ColorKeyPlayed;
    Property ColorInstrfActived:TColor Read fColorInstrfActived Write Set_ColorInstrfActived;
    Property ColorInstrDisfActived:TColor Read fColorInstrDisfActived Write Set_ColorInstrDisfActived;
    Property ColorInstr:TColor Read fColorInstr Write Set_ColorInstr;
    Property InstrPatternCnt:TInstrPatternCnt Read fInstrPatternCnt Write fInstrPatternCnt;
    property Note_On_Event: TNote_On_Event Read fOnNote_On Write fOnNote_On;
    property Note_Off_Event: TNote_Off_Event Read fOnNote_Off Write fOnNote_Off;
    property Tempo: integer Read fTempo Write SetTempo;
    property DuringOfTime: TDuringOfTime Read fDuringOfTime Write SetDuringOfTime;
    property NbCases:Integer Read fNbCases Write SetNbCases;
    Property InstrClick_Event:TInstrClick_Event Read fOnInstrClick Write fOnInstrClick;
    Property Playing_Event:TPlaying_Event Read fOnPlaying Write fOnPlaying;
    Property OnMouseMove;
    Property OnMouseDown;
    Property OnMouseUp;
    Property OnClick;
    Property OnDblClick;	
  end;

Var
  DuringNote:Integer;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TPatternMidi]);
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

constructor TPatternMidi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  fNbCases:=16;
  InstrumentSelected:=-1;
  fTempo     := 60;
  fDuringOfTime := QuarterNote;
  PlayingCursor:=0;
  Timer     := TKnMdTimer.Create(Self);
  Timer.Enabled := False;
  Timer.OnTimer := TimerStarting;
  PlayingTime:=0;
  fInstrPatternCnt:=TInstrPatternCnt.Create(Self);
  Color:=$00757575;
  fColorInstr:=$00C08000;
  fColorKeyDesactive:=$00CCCCD7;
  fColorKeyActive:=$008CBBA4;
  fColorKeyPlayed:=ClLime;
  fColorInstrfActived:=ClLime;
end;

destructor TPatternMidi.Destroy;
begin
  fInstrPatternCnt.Free;
  Timer.Free;
  inherited;
end;

Procedure TPatternMidi.Set_ColorKeyActive(Value: TColor);
Begin
  If fColorKeyActive<>Value Then
    Begin
      fColorKeyActive:=Value;
      Invalidate;
    End;
End;

Procedure TPatternMidi.Set_ColorKeyDesactive(Value: TColor);
Begin
  If fColorKeyDesactive<>Value Then
    Begin
      fColorKeyDesactive:=Value;
      Invalidate;
    End;
End;
Procedure TPatternMidi.Set_ColorKeyPlayed(Value: TColor);
Begin
  If fColorKeyPlayed<>Value Then
    Begin
      fColorKeyPlayed:=Value;
      Invalidate;
    End;
End;

Procedure TPatternMidi.Set_ColorInstrfActived(Value: TColor);
Begin
  If fColorInstrfActived<>Value Then
    Begin
      fColorInstrfActived:=Value;
      Invalidate;
    End;
End;

Procedure TPatternMidi.Set_ColorInstrDisfActived(Value: TColor);
Begin
  If fColorInstrDisfActived>Value Then
    Begin
      fColorInstrDisfActived:=Value;
      Invalidate;
    End;
End;

Procedure TPatternMidi.Set_ColorInstr(Value: TColor);
Begin
  If fColorInstr<>Value Then
    Begin
      fColorInstr:=Value;
      Invalidate;
    End;
End;

procedure TPatternMidi.SetTempo(Value: integer);
begin
  fTempo := Value;
  SetIntervalTimer(fTempo,fDuringOfTime);  
end;

procedure TPatternMidi.SetDuringOfTime(Value: TDuringOfTime);
begin
  fDuringOfTime := Value;
  SetIntervalTimer(fTempo,fDuringOfTime);
end;

Procedure TPatternMidi.SetIntervalTimer(ATempo:Integer;ADuringOfTime:TDuringOfTime);
Var
  IndexInstr,IndexNote:Integer;
  DuringCoef:Real;
Begin
  DuringCoef    := 4;
  case ADuringOfTime of
    WholeNote: DuringCoef  := 4;
    HalfNote: DuringCoef  := 2;
    QuarterNote: DuringCoef  := 1;
    Quavers: DuringCoef := 0.5;
    SixteenthNote: DuringCoef := 0.25;
    DemiSemiQuavers: DuringCoef := 0.125;
  end;
  Timer.Interval := (Round(60 * DuringCoef * 1000)) div ATempo;
  DuringNote:=Timer.Interval;
  If fInstrPatternCnt.Count>0 Then
  For IndexInstr:=0 To fInstrPatternCnt.Count-1 Do
    Begin
      With fInstrPatternCnt.Items[IndexInstr] Do
        Begin
          If fNoteCnt.Count>0 Then
          For IndexNote:=0 To fNoteCnt.Count-1 Do
            Begin
              With fNoteCnt.Items[IndexNote] Do
                Begin
                  fBeginTime:=IndexNote*DuringNote;
                  fEndTime:=fBeginTime+DuringNote;
                End;
            End;
        End;
    End;
End;

Procedure TPatternMidi.SetStart(Value:Boolean);
begin
  Timer.Enabled := Value;
  SetDuringOfTime(fDuringOfTime);
  fStart:=Value;
end;

Procedure TPatternMidi.Stop;
begin
  Timer.Enabled :=False;
  PlayingCursor:=0;
  PlayingTime:=0;
end;

Procedure TPatternMidi.SetNbCases(Value:Integer);
Var
  IndexCase,IndexInstr:Integer;
  NewNote:TNote;
begin
  If (Value<>fNbCases) And (fInstrPatternCnt.Count>0) Then
    Begin
      If Value<fNbCases Then
        Begin
          For IndexInstr:=0 To fInstrPatternCnt.Count-1 Do
            Begin
              If fInstrPatternCnt.Items[IndexInstr].fNoteCnt.Count>0 Then
              For IndexCase:=(fNbCases-1) DownTo Value Do
              fInstrPatternCnt.Items[IndexInstr].fNoteCnt.Delete(IndexCase);
            End;  
        End;
      If Value>fNbCases Then
        Begin
          For IndexInstr:=0 To fInstrPatternCnt.Count-1 Do
            Begin
              With fInstrPatternCnt.Items[IndexInstr] Do
              For IndexCase:=fNbCases To Value-1 Do
                Begin
                  NewNote:=fNoteCnt.Add;
                  NewNote.fBeginTime:=(IndexCase-1)*DuringNote;
                  NewNote.fEndTime:=NewNote.fBeginTime+DuringNote;
                End;
            End;
        End;
      fNbCases:=Value;
      Invalidate;
    End;
end;

procedure TPatternMidi.TimerStarting(Sender: TObject);
Var
  IndexInstr:Cardinal;
  InstrumentPlayed:TInstrPattern;
  IncTime:Integer;
begin
  Timer.Enabled:=False;
  IncTime:=Timer.Interval;
  PlayingTime:=PlayingTime+EncodeTime(00,00,IncTime Div 1000 ,IncTime Mod 1000);     
  If Assigned(fOnPlaying) then fOnPlaying(Sender);
  If fInstrPatternCnt.Count>0 Then
  For IndexInstr:=0 To fInstrPatternCnt.Count-1 Do
    Begin
      InstrumentPlayed:=fInstrPatternCnt.Items[IndexInstr];
      If InstrumentPlayed.fActived Then
      With InstrumentPlayed Do
        Begin
          If (fNoteCnt.Items[PlayingCursor].fActived) Then
            Begin
              if Assigned(fOnNote_On) then
              fOnNote_On(Sender,InstrumentPlayed,fNoteCnt.Items[PlayingCursor]);
            End;
          If (PlayingCursor>0) And (fNoteCnt.Items[PlayingCursor-1].fActived) Then
            Begin
              if Assigned(fOnNote_Off) then
              fOnNote_Off(Sender,InstrumentPlayed,fNoteCnt.Items[PlayingCursor-1]);
            End;
        End;
    End;
  If PlayDirection=PlToRight Then
    Begin
      Inc(PlayingCursor);
      If PlayingCursor >= (fNbCases) then
      PlayingCursor:=0;
    End
  Else
    Begin
      Dec(PlayingCursor);
      If PlayingCursor < 0 then
      PlayingCursor:=fNbCases-1;
    End;
  Self.Invalidate;
  Timer.Enabled:=True;  
end;

Procedure TPatternMidi.Paint;
Var
  IndexInstr,IndexNote:Integer;
  PanelRect,NoteRect,CircleRect,PlayedRect:TRect;
  WidthRect,HeightRect,HeightCaption, WidthCaption,IndexLine:Integer;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
Begin
  InHerited;
  If fInstrPatternCnt.Count>0 Then
  Height:=fInstrPatternCnt.Count*20+(fInstrPatternCnt.Count-1)*5+25
  Else Height:=100;
  Width:=200+25*fNbCases;
  With Canvas Do
    Begin
      Brush.Color:=Color;
      Rectangle(ClientRect);
      If fInstrPatternCnt.Count>0 Then
      For IndexInstr:=0 To (fInstrPatternCnt.Count-1) Do
      With fInstrPatternCnt.Items[IndexInstr]Do
        Begin
          Brush.Color:=fColorInstr;
          Pen.Color:=fColorInstr;
          Pen.Width:=2;
          With PanelRect Do
            Begin
              Left:=5;
              Right:=175;
              Top:=5+(IndexInstr)*25;
              Bottom:=Top+20;
              Rectangle(PanelRect);
              WidthRect:=Right-Left;
              HeightRect:=Bottom-Top;
            End;
          UpperCorner[0]:=Point(PanelRect.Right,PanelRect.Top);
          UpperCorner[1]:=Point(PanelRect.Left,PanelRect.Top);
          UpperCorner[2]:=Point(PanelRect.Left,PanelRect.Bottom);
          LowerCorner[0]:=Point(PanelRect.Left,PanelRect.Bottom);
          LowerCorner[1]:=Point(PanelRect.Right,PanelRect.Bottom);
          LowerCorner[2]:=Point(PanelRect.Right,PanelRect.Top);
          Brush.Color:=ClWhite;
          Pen.Color:=ClWhite;
          Polyline(UpperCorner);
          Brush.Color:=$005F5F5F;
          Pen.Color:=$005F5F5F;
          Polyline(LowerCorner);
          HeightCaption:=TextHeight(fInstrument);
          WidthCaption:=TextWidth(fInstrument);
          Font.Color:=ClWhite;
          Font.Style:=[fsBold];
          Brush.Style:=BsClear;
          Font.Name:='Arial';
          Font.Size:=8;
          TextOut(5+(WidthRect-WidthCaption) Div 2,PanelRect.Top+(HeightRect-HeightCaption) Div 2,fInstrument);
          If fActived Then Pen.Color:=fColorInstrfActived
          Else Pen.Color:=fColorInstrDisfActived;
          For IndexLine:=1 To 3 Do
            Begin
              MoveTo(PanelRect.Right+2+3*IndexLine,PanelRect.Top);
              LineTo(PanelRect.Right+2+3*IndexLine,PanelRect.Bottom-Pen.width);
            End;
          For IndexNote:=0 To (fNbCases-1) Do
          With fNoteCnt.Items[IndexNote] Do
            Begin
              If fActived Then Brush.Color:=fColorKeyActive
              Else Brush.Color:=fColorKeyDesactive;
              If (Timer.Enabled) And(IndexNote=PlayingCursor) And (fActived)
              And (fInstrPatternCnt.Items[IndexInstr].fActived) Then
              Brush.Color:=fColorKeyPlayed;
              Pen.Color:=ClBlack;
              With NoteRect Do
                Begin
                  Left:=200+IndexNote*25;
                  Right:=Left+20;
                  Top:=5+IndexInstr*25;
                  Bottom:=Top+20;
                  Rectangle(NoteRect);
                End;
              Pen.Width:=1;
              Brush.Color:=ClBlack;
              With CircleRect Do
                Begin
                  Left:=NoteRect.Left+3;
                  Right:=NoteRect.Left+7;
                  Top:=NoteRect.Top+3;
                  Bottom:=NoteRect.Top+5;
                  Ellipse(CircleRect);
                End;
              With CircleRect Do
                Begin
                  Left:=Left+10;
                  Right:=Right+10;
                  Top:=Top;
                  Bottom:=Bottom;
                  Ellipse(CircleRect);
                End;
              Pen.Width:=2;
              If (IndexNote=PlayingCursor) Then
              Brush.Color:=fColorKeyPlayed
              Else Brush.Color:=$00585858;
              With PlayedRect Do
                Begin
                  Left:=NoteRect.Left+5;
                  Right:=NoteRect.Right-5;
                  Top:=Height-15;
                  Bottom:=Height-5;
                  Ellipse(PlayedRect);
                End;
            End;
        End;
    End;
End;

procedure TPatternMidi.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  IndexInstr,IndexNote:Cardinal;
  NoteTop,NoteBottom,NoteLeft,NoteRight:Integer;
Begin
  InHerited;
  If SSLeft In Shift Then
    Begin
      If fInstrPatternCnt.Count>0 Then
      For IndexInstr:=0 To fInstrPatternCnt.Count-1 Do
        Begin
          NoteTop:=5+IndexInstr*25;
          NoteBottom:=NoteTop+20;
          If (Y>NoteTop) And (Y<NoteBottom) Then
            Begin
              InstrumentSelected:=IndexInstr;
              With fInstrPatternCnt.Items[IndexInstr] Do
                Begin
                  For IndexNote:=0 To (fNbCases-1)  Do
                    Begin
                      NoteLeft:=200+IndexNote*25;
                      NoteRight:=NoteLeft+20;
                      If (X>NoteLeft) And (X<NoteRight) Then
                      With fNoteCnt.Items[IndexNote] Do
                      fActived:=Not fActived;
                    End;
                  If SSDouble In Shift Then
                  If (X>5) And (X<175) Then
                    Begin
                      fActived:=Not fActived;
                      If Assigned(fOnInstrClick) Then fOnInstrClick(Self);
                    End;  
                End;
            End;
        End;
      Invalidate;
    End;
End;    

{>>TInstrPatternCnt}
constructor TInstrPatternCnt.Create(AOwner: TPersistent);
begin
  fOwner := AOwner;
  inherited Create(AOwner,TInstrPattern);
end;

function TInstrPatternCnt.Add:TInstrPattern;
begin
  Result := TInstrPattern(inherited Add);
end;

function TInstrPatternCnt.GetItem(Index: integer):TInstrPattern;
begin
  Result := TInstrPattern(inherited Items[Index]);
end;

procedure TInstrPatternCnt.SetItem(Index: integer; Value:TInstrPattern);
begin
  inherited SetItem(Index, Value);
end;

function TInstrPatternCnt.GetOwner: TPersistent;
begin
  Result := fOwner;
end;

{>>TInstrPattern}
constructor TInstrPattern.Create;
Var
  IndexNote:Integer;
  NewNote:TNote;
begin
  fCollection := (ACollection as TInstrPatternCnt);
  inherited Create(ACollection);
  fNoteCnt:=TNoteCnt.Create(Self);
  For IndexNote:=0 To ((fCollection.Owner As TPatternMidi).fNbCases -1) Do
    Begin
      NewNote:=fNoteCnt.Add;
      NewNote.fBeginTime:=IndexNote*DuringNote;
      NewNote.fEndTime:=NewNote.fBeginTime+DuringNote;
    End;
end;

destructor TInstrPattern.Destroy;
begin
  fNoteCnt.Free;
  inherited Destroy;
end;

procedure TInstrPattern.AssignTo(Dest: TPersistent);
Var
  IndexByte:Cardinal;
begin
  if Dest is TInstrPattern then
  with TInstrPattern(Dest) do
    begin
      For IndexByte:=0 To ((fCollection.Owner As TPatternMidi).fNbCases) Do
      fBytes[IndexByte]:=Self.fBytes[IndexByte];
      fInstrument:=Self.fInstrument;
      fActived:=Self.fActived;
      fOnChange := self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TInstrPattern.Assign(Source : TPersistent);
begin
  if source is TInstrPattern then
     with TInstrPattern(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

function TInstrPattern.GetByte(index: integer): Byte;
begin
  result := fBytes[index];
end;

procedure TInstrPattern.SetByte(index: integer; value: Byte);
begin
  if fBytes[index] <> value then
  begin
    fBytes[index] := value;
    change;
  end;
end;

procedure TInstrPattern.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TInstrPattern.GetDisplayName: string;
begin
  result := 'InstrPattern['+IntToStr(Self.Index)+'] ';
end;

{>>TNoteCnt}
constructor TNoteCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TNote);
end;

function TNoteCnt.Add:TNote;
begin
  Result := TNote(inherited Add);
end;

function TNoteCnt.GetItem(Index: integer):TNote;
begin
  Result := TNote(inherited Items[Index]);
end;

procedure TNoteCnt.SetItem(Index: integer; Value:TNote);
begin
  inherited SetItem(Index, Value);
end;

{>>TNote}
constructor TNote.Create(ACollection: TCollection); 
begin
  inherited Create(ACollection);
end;

destructor TNote.Destroy;
begin
  inherited Destroy;
end;

procedure TNote.AssignTo(Dest: TPersistent);
begin
  if Dest is TNote then
  with TNote(Dest) do
    begin
      fBeginTime:=Self.fBeginTime;
      fEndTime:=Self.fEndTime;
      fNote:=Self.fNote;
      fActived:=Self.fActived;
      fOnChange:=Self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TNote.Assign(Source : TPersistent);
begin
  if source is TNote then
     with TNote(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TNote.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TNote.GetDisplayName: string;
begin
  result := '<'+IntToStr(Self.Index)+'>';
end;



End.
