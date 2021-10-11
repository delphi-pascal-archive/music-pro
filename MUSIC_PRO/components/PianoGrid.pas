{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit PianoGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Graphics, DuringTime, MMSystem, Math,Dialogs;

type       

  TDirection=(PlToRight,PlToLeft);
  TMode = (MdNone, MdAddNote, MdSelectNote, MdMoveNote);

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
    property Interval: Integer read FInterval write SetInterval;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;
   
{>>TNote}
 TNote = class(TCollectionItem)
  private 
    fBytes: array[0..15] of Byte;
    fBeginTime:Integer;
    fEndTime:Integer;
    fOnChange: TNotifyEvent;
  protected
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
    function GetDisplayName : string; override;
  public
    Selected:Boolean;  
    function GetByte(index: Integer): Byte;
    procedure SetByte(index: Integer; value: Byte);
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    Property Note : Byte index 0 Read GetByte write SetByte;
    Property Instr : Byte index 1 Read GetByte write SetByte;
    Property Channel : Byte index 2 Read GetByte write SetByte;
    Property Volume : Byte  index 3 Read GetByte write SetByte;
    Property Velocity : Byte  index 4 Read GetByte write SetByte;
    Property PitchBend : Byte  index 5 Read GetByte write SetByte;
    Property ChannelPressure : Byte  index 6 Read GetByte write SetByte;
    Property Modulation : Byte index 7 Read GetByte write SetByte;
    Property PortamentoTime : Byte index 8 Read GetByte write SetByte;
    Property PortamentoSwitch : Byte  index 9 Read GetByte write SetByte;
    Property PortamentoNote : Byte  index 10 Read GetByte write SetByte;
    Property Resonance : Byte  index 11 Read GetByte write SetByte;
    Property Pan : Byte  index 12 Read GetByte write SetByte;
    Property Sustain : Byte  index 13 Read GetByte write SetByte;
    Property Vibrato  : Byte  index 14 Read GetByte write SetByte;
    Property Expression  : Byte  index 15 Read GetByte write SetByte;    
    Property BeginTime :Integer Read fBeginTime write fBeginTime;
    Property EndTime :Integer Read fEndTime  write fEndTime;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;  
  
{>>TNoteCnt}
  TNoteCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: Integer): TNote;
    procedure SetItem(Index: Integer; Value: TNote);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TNote;
    property Items[Index: Integer]: TNote Read GetItem Write SetItem;
  end;              

  TOnNote_Event  = procedure(const Note: TNote) of object;
  TNote_On_Event = procedure(Sender: TObject;Note:TNote) of object;
  TNote_Off_Event = procedure(Sender: TObject;Note:TNote) of object;
  TPlaying_Event=TNotifyEvent;

{>>TPianoGrid}
  TPianoGrid = class(TCustomControl)
  private
    fColorNote: TColor;
    fColorSelected: TColor;  
    fOctave:Integer;
    fNoteCnt:TNoteCnt;
    fInstrumentSelected:Byte;
    fNoteSelected:Byte;
    fTempo:    Integer;
    fDuringOfTime: TDuringOfTime;
    fMin:Integer;
    fMax:Integer;
    fPos:      real;
    fTime:Integer;
    fMode:    TMode;
    fUnityTime:Integer;
    XOld:Integer;
    YOld:Integer;
    RectSelection:TRect;
    DrawRectSelection:Boolean;
    fOnAddNote:TOnNote_Event;
    fOnNote_On: TNote_On_Event;
    fOnNote_Off: TNote_Off_Event;
    fOnPlaying:TPlaying_Event;    
    fStart:Boolean;
    PlayingCursor:Integer;
    procedure Set_ColorNote(Value: TColor);
    Procedure Set_ColorSelected(Value: TColor);
    Procedure Set_Octave(Value:Integer);
    Procedure Set_InstrumentSelected(Value:Byte);
    Procedure Set_NoteSelected(Value:Byte);
    procedure Set_Tempo(Value: Integer);
    procedure Set_DuringOfTime(Value: TDuringOfTime);
    Procedure Set_Min(Value:Integer);
    Procedure Set_Max(Value:Integer);
    procedure Set_Pos(Value: real);
    procedure Set_Time(Value:Integer);
    procedure Timing(Sender: TObject);
    Procedure Set_Mode(Value:TMode);
    Procedure Set_Start(Value:Boolean);    
  protected
    Procedure AddNote(X,Y:Integer);
    Procedure ResizeNote(X,Y:Integer);
    Procedure SelectNote(X,Y:Integer);
    Procedure SelectNotes;
    Procedure MoveNote(X,Y:Integer);
    Procedure DrawSelection(X,Y:Integer);
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    TempNoteCnt:TNoteCnt;
    PlayDirection:TDirection;
    PlayingTime:TTime;
    Timer:TKnMdTimer;
    Function CoordToTime(Const X:Integer):Integer;
    Function TimeToCoord(Const ATime:Integer):Integer;
    Function CoordToNote(Const Y:Integer):Byte;
    Function PosToCoord:Integer;
    Property Start:Boolean Read fStart Write Set_Start;
    Procedure Stop;
    Procedure DelNote;
    Procedure CopyNote;
    Procedure PastNote;    
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Property UnityTime:Integer Read fUnityTime Write fUnityTime;
  published
    property ColorNote: TColor Read FColorNote Write Set_ColorNote;
    property ColorSelected: TColor Read FColorSelected Write Set_ColorSelected;
    Property Octave:Integer Read fOctave Write Set_Octave;
    Property InstrumentSelected:Byte Read fInstrumentSelected Write Set_InstrumentSelected;
    Property NoteSelected:Byte Read fNoteSelected Write Set_NoteSelected;
    Property NoteCnt:TNoteCnt Read fNoteCnt Write fNoteCnt;    
    property Tempo: Integer Read fTempo Write Set_Tempo;
    property DuringOfTime: TDuringOfTime Read fDuringOfTime Write Set_DuringOfTime;
    Property Min:Integer Read fMin Write Set_Min;
    Property Max:Integer Read fMax Write Set_Max;
    property Pos: real Read fPos Write Set_Pos;
    property Time: Integer Read fTime Write Set_Time;
    property Mode: TMode Read fMode Write Set_Mode;
    Property OnAddNote:TOnNote_Event Read fOnAddNote Write fOnAddNote;
    property Note_On_Event: TNote_On_Event Read fOnNote_On Write fOnNote_On;
    property Note_Off_Event: TNote_Off_Event Read fOnNote_Off Write fOnNote_Off;
    Property Playing_Event:TPlaying_Event Read fOnPlaying Write fOnPlaying;     
    Property Color;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property ShowHint;
  end;  
  
procedure Register;


implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TPianoGrid]);
end;


procedure TimerCallback(wTimerID : UInt; msg : UInt; dwUser, dw1, dw2 : dword); stdcall;
begin
  if ((TObject(dwUser) is TKnMdTimer)) Then
  With TKnMdTimer(dwUser) Do  
    Begin
      If (fwTimerID <> wTimerID) then exit;
      If assigned(fOnTimer) then OnTimer(TObject(dwUser));
      If (Owner As TPianoGrid).PlayDirection=PlToRight Then CountTime:=CountTime+Interval
      Else CountTime:=CountTime-Interval;
    End;    
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

{>>TPianoGrid}
constructor TPianoGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color:=ClWhite;
  fNoteCnt:=TNoteCnt.Create(Self);
  TempNoteCnt:=TNoteCnt.Create(Self);
  Timer      := TKnMdTimer.Create(Self);
  Timer.Interval:=10;
  Timer.OnTimer := Timing;
  fUnityTime:=0;   
  fTempo     := 60;
  fDuringOfTime := QuarterNote;
  fMin:=0;
  fMax:=10;
  fPos:=0;
  fTime:=4;
  fOctave:=0;
  DrawRectSelection:=False;
  DoubleBuffered:=True;
end;

destructor TPianoGrid.Destroy;
begin
  Timer.Free;
  TempNoteCnt.Free;
  fNoteCnt.Free;
  inherited;
end;

procedure TPianoGrid.Set_Octave(Value:Integer);
Begin
  fOctave:=Value;
  If (fOctave>10) Then fOctave:=10;
  If (fOctave<0) Then fOctave:=0;
  Invalidate;
End;

procedure TPianoGrid.Set_InstrumentSelected(Value: Byte);
begin
  If Value<128 Then
  Begin
    fInstrumentSelected:= Value;
    Invalidate;
  End;
end;

procedure TPianoGrid.Set_NoteSelected(Value: Byte);
begin
  If Value<128 Then
  Begin
    fNoteSelected:= Value;
    Invalidate;
  End;
end;

procedure TPianoGrid.Set_ColorNote(Value: TColor);
begin
  FColorNote := Value;
  Invalidate;
end;

procedure TPianoGrid.Set_ColorSelected(Value: TColor);
begin
  FColorSelected := Value;
  Invalidate;
end;

procedure TPianoGrid.Set_Tempo(Value: Integer);
begin
  fTempo := Value;
  Set_DuringOfTime(fDuringOfTime);
end;

procedure TPianoGrid.Set_DuringOfTime(Value: TDuringOfTime);
var
  DuringCoef: real;
  IndexNote,OldUnity:Integer;
begin
  OldUnity:=fUnityTime;
  fDuringOfTime := Value;
  DuringCoef    := 4;
  case fDuringOfTime of
    WholeNote: DuringCoef  := 4;
    HalfNote: DuringCoef  := 2;
    QuarterNote: DuringCoef  := 1;
    Quavers: DuringCoef := 0.5;
    SixteenthNote: DuringCoef := 0.25;
    DemiSemiQuavers: DuringCoef := 0.125;
  end;
  fUnityTime := (Round(60 * DuringCoef * 1000)) div fTempo;
  If fNoteCnt.Count>0 Then
  For IndexNote:=0 To fNoteCnt.Count-1 Do
  With fNoteCnt.Items[IndexNote] Do
    Begin
      BeginTime:=Round(BeginTime*fUnityTime / OldUnity);
      EndTime:=Round(EndTime*fUnityTime / OldUnity);
    End;  
  Invalidate;
end;

Procedure TPianoGrid.Set_Min(Value:Integer);
begin
  fMin:= Value;
  Invalidate;
end;

Procedure TPianoGrid.Set_Max(Value:Integer);
begin
  fMax:= Value;
  Invalidate;
end;

procedure TPianoGrid.Set_Pos(Value: real);
begin
  fPos := Value;
  if fPos < fMin then fPos := fMin;
  if fPos > fMax then fPos := fMax;
  Invalidate;
end;

procedure TPianoGrid.Set_Time(Value:Integer);
begin
  fTime:=Value;
  Invalidate;
end;

procedure TPianoGrid.Timing(Sender: TObject);
Var
  DecPrg,IndexNote,FistTime,LastTime:Integer;
begin
  PlayingTime:=PlayingTime+EncodeTime(00,00,fUnityTime Div 1000 ,fUnityTime Mod 1000);
  If Assigned(fOnPlaying) then fOnPlaying(Sender);  
  DecPrg:=fMax-fMin;
  If PlayDirection=PlToRight Then FPos:=FPos+10/(FTime*fUnityTime)
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
  If fNoteCnt.Count>0 Then
  For IndexNote:=0 To (fNoteCnt.Count-1) Do
  With fNoteCnt.Items[IndexNote] Do
  Begin
    If PlayDirection=PlToRight Then
      Begin
        FistTime:=fBeginTime;
        LastTime:=fEndTime;
      End
    Else
      Begin
        FistTime:=fEndTime;
        LastTime:=fBeginTime;
      End;
    If (FistTime>Timer.CountTime-5) And (FistTime<=Timer.CountTime+5) And (Assigned(fOnNote_On)) Then
    fOnNote_On(Sender,fNoteCnt.Items[IndexNote]);
    If (LastTime>Timer.CountTime-5) And (LastTime<=Timer.CountTime+5) And (Assigned(fOnNote_Off)) Then
    fOnNote_Off(Sender,fNoteCnt.Items[IndexNote]);
  End;
end;

Procedure TPianoGrid.Set_Mode(Value:TMode);
Begin
  If Value<>fMode Then
    Begin
      fMode:=Value;
      If fMode=MdSelectNote Then TempNoteCnt.Clear;
    End;
End;

procedure TPianoGrid.Set_Start(Value:Boolean);
begin
  Timer.Enabled := Value;
  Set_DuringOfTime(fDuringOfTime);
  fStart:=Value;
end;

Procedure TPianoGrid.Stop;
begin
  Timer.Enabled :=False;
  PlayingCursor:=0;
  PlayingTime:=0;
  Timer.CountTime:=0;
end;

Function TPianoGrid.CoordToTime(Const X:Integer):Integer;
begin
  Result:=Trunc(fUnityTime*(fMin*Time+X / 20));
end;

Function TPianoGrid.TimeToCoord(Const ATime:Integer):Integer;
begin
  Result:=Trunc((ATime/fUnityTime-fMin*Time)*20);
end;

Function  TPianoGrid.CoordToNote(Const Y:Integer):Byte;
Var
  NmCase:Integer;
Begin
  NmCase:=Trunc(Y / 14) ;
  Result:=(NmCase+fOctave*12);
End;

Function TPianoGrid.PosToCoord:Integer;
Begin
  Result:=Round((Width-60)*(fPos-fMin) / (fMax-fMin));
End;  

procedure TPianoGrid.Paint;
Const
  WidthCol=20;
  HeightRow=14;
  NotesName: Array [0..23] Of String =
           ('C','C#','D','D#','E','F','F#','G','G#','A','A#','B',
           'C','C#','D','D#','E','F','F#','G','G#','A','A#','B');
var
  NmCol,IndexCol,NmRow,IndexRow,TopText,IndexNote,NmCase:Integer;
  NoteName:String;
  NoteRect,NotesRect:TRect;
begin
  inherited;
  With Canvas Do
    Begin
      Brush.Style:=BsClear;
      Pen.Color:=ClBlack;
      Pen.Style:=psSolid;
      NmCol:=(fMax-fMin)*fTime;
      Width:=20*NmCol+60;
      For IndexCol:=0 To NmCol Do
        Begin
          MoveTo(Round(WidthCol*IndexCol),0);
          LineTo(Round(WidthCol*IndexCol),Height);
        End;
      Brush.Color := $00EAFFFF;
      With NotesRect Do
        Begin
        Left:=Width-60;
        Right:=Width;
        Top:=0;
        Bottom:=Height;
        End;
      Rectangle(NotesRect); 
      Font.Style:=[fsBold];
      If fOctave=10 Then NmRow:=20 Else NmRow:=24;
      Height:=HeightRow * NmRow;
      For IndexRow:=0 To NmRow Do
        Begin
          MoveTo(0,Round(IndexRow*HeightRow));
          LineTo(Width,Round(IndexRow*HeightRow));
          If IndexRow<24 Then
            Begin
              NoteName:=NotesName[IndexRow]+'--'+IntToStr(fOctave+IndexRow Div 12);
              TopText  :=Round(HeightRow*(1+IndexRow*2) / 2)-TextHeight(NoteName) Div 2;
              TextOut(Width-50, TopText, NoteName);
            End;  
        End;

      If fNoteCnt.Count>0 Then
      For IndexNote:=0 To fNoteCnt.Count-1 Do
      With fNoteCnt.Items[IndexNote] Do
        Begin
         If Instr<>fInstrumentSelected Then Continue;
         If (Trunc(Note / 12) In [fOctave,fOctave+1])  And
         (TimeToCoord(fEndTime)<Width-60 ) And
         (TimeToCoord(fBeginTime)>0) Then
          With NoteRect Do
            Begin
             NmCase:=((Note-12*fOctave) Mod 24);
             If Selected Then Brush.Color:=ColorSelected
             Else Brush.Color:=Self.FColorNote;
             Left:=TimeToCoord(fBeginTime);
             If Left<0 Then Left:=0;
             Right:=TimeToCoord(fEndTime);
             If Right>20*NmCol Then Right:=20*NmCol;
             Top:=Round(NmCase*HeightRow );
             Bottom:=Round(Top+HeightRow)+1;
             Rectangle(NoteRect);
            End;
        End;
      Pen.Color:=ClRed;
      MoveTo(PosToCoord,0);
      LineTo(PosToCoord,Height);
      Pen.Color:=ClBlack;
      Brush.Style:=BsClear;        
      Rectangle(ClientRect); 

      If DrawRectSelection Then
        Begin
          Pen.Color:=ClBlue;
          Pen.Style:=psDash;
          Brush.Style:=BsClear;
          Rectangle(RectSelection);
        End;
    End;
end;

Procedure TPianoGrid.AddNote(X,Y:Integer);
Var
  IndexNote,ATime:Integer;
  NewNote:TNote;
  NoteAdd:Byte;
Begin
  If (X>Round((fMax-fMin)*fTime*20)) Then Exit;
  ATime:=CoordToTime(X);
  NoteAdd:=CoordToNote(Y);
  If fNoteCnt.Count>0 Then
    Begin
      For IndexNote:=0 To (fNoteCnt.Count-1) Do
      With fNoteCnt.Items[IndexNote] Do
      If (fBeginTime<=ATime) And (fEndTime>=ATime)  And (Note=NoteAdd) Then Exit;
    End;
  NewNote:=fNoteCnt.Add;
  With NewNote Do
    Begin
      Note:=NoteAdd;
      fBeginTime:=CoordToTime(X);
      fEndTime:=CoordToTime(X+20); 
    End;
  If Assigned(fOnAddNote) Then fOnAddNote(NewNote);
  Invalidate;
End;

Procedure TPianoGrid.DelNote;
Var
  IndexNote:Integer;
Begin
  If fNoteCnt.Count>0 Then
  For IndexNote:=(fNoteCnt.Count-1) DownTo 0 Do
    Begin
      If fNoteCnt.Items[IndexNote].Selected Then
      fNoteCnt.Delete(IndexNote);
    End;
  Invalidate;  
End;

Procedure TPianoGrid.ResizeNote(X,Y:Integer);
Var
  IndexNote,ATime:Integer;
  NoteAdd:Byte;  
Begin
  If (Round(X)>(fMax-fMin)*fTime*20+20) Then Exit;
  ATime:=CoordToTime(X);
  NoteAdd:=CoordToNote(Y);
  If fNoteCnt.Count>0 Then
    Begin
      For IndexNote:=0 To (fNoteCnt.Count-1) Do
      With fNoteCnt.Items[IndexNote] Do
      If (fBeginTime<=ATime) And (fEndTime>=ATime)  And (Note=NoteAdd) Then
      fEndTime:=CoordToTime(X+5);
      Invalidate;
    End;
End;

Procedure TPianoGrid.SelectNote(X,Y:Integer);
Var
  IndexNote,ATime:Integer;
  ANote:Byte;
Begin
  If (Round(X)>(fMax-fMin)*fTime*20) Then Exit;
  ATime:=CoordToTime(X);
  ANote:=CoordToNote(Y);  
  If fNoteCnt.Count>0 Then
    Begin
      For IndexNote:=0 To (fNoteCnt.Count-1) Do
      With fNoteCnt.Items[IndexNote] Do
        Begin
          If (ATime>=fBeginTime) And (ATime<=fEndTime) And (ANote=Note) Then
          Selected:=Not Selected;
        End;
      Invalidate;
    End;
End;

Procedure TPianoGrid.SelectNotes;
Var
  LeftTime,RightTime,TopNote,BottomNote,IndexNote:Integer;
Begin
  With RectSelection Do
    Begin
      LeftTime:=CoordToTime(Left);
      RightTime:=CoordToTime(Right);
      TopNote:=CoordToNote(Top);
      BottomNote:=CoordToNote(Bottom);
      If fNoteCnt.Count>0 Then
        Begin
          For IndexNote:=0 To (fNoteCnt.Count-1) Do
          With fNoteCnt.Items[IndexNote] Do
            Begin
              If (LeftTime<=fBeginTime) And (RightTime>=fEndTime)
              And (TopNote<=Note) And (BottomNote>=Note) Then
              Selected:=Not Selected;
            End;  
        End;
      DrawRectSelection:=False;
      Invalidate;
    End;
End;

Procedure TPianoGrid.CopyNote;
Var
  IndexNote:Integer;
  TempNote:TNote;
Begin
  If fNoteCnt.Count>0 Then
  For IndexNote:=0 To (fNoteCnt.Count-1) Do
    Begin
      If fNoteCnt.Items[IndexNote].Selected Then
        Begin
          TempNote:=TempNoteCnt.Add;
          fNoteCnt.Items[IndexNote].AssignTo(TempNote);
          fNoteCnt.Items[IndexNote].Selected:=False;
        End;
    End;
  Invalidate;
End;

Procedure TPianoGrid.PastNote;
Var
  IndexNote:Integer;
  NewNote:TNote;
Begin
  If TempNoteCnt.Count>0 Then
  For IndexNote:=0 To (TempNoteCnt.Count-1) Do
    Begin
      NewNote:=fNoteCnt.Add;
      TempNoteCnt.Items[IndexNote].AssignTo(NewNote);
      TempNoteCnt.Items[IndexNote].Selected:=False;
      NewNote.Instr:=fInstrumentSelected;
    End;
  fMode:=MdMoveNote;
  TempNoteCnt.Clear;
  Invalidate;
End;

Procedure TPianoGrid.MoveNote(X,Y:Integer);   
Var
  IndexNote,DecNote,DecTime:Integer;
Begin
  DecNote:=CoordToNote(Y)-CoordToNote(Yold);
  DecTime:=CoordToTime(X-Xold);
  For IndexNote:=0 To (fNoteCnt.Count-1) Do
  With fNoteCnt.Items[IndexNote] Do
    Begin
      If Selected Then
        Begin
          Inc(fBeginTime,DecTime);
          Inc(fEndTime,DecTime);
          Note:=Note+DecNote;
        End;
    End;
  XOld:=X;
  YOld:=Y;    
  Invalidate;
End;

Procedure TPianoGrid.DrawSelection(X,Y:Integer);
Begin
  If Not DrawRectSelection Then DrawRectSelection:=True;
  With RectSelection Do
    Begin
      Left:=XOld;
      Top:=YOld;
      Right:=X;
      Bottom:=Y;
      Invalidate;
    End;
End;

procedure TPianoGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  fNoteCnt.ItemIndex:=Trunc(Y / 14) ;
  fNoteSelected:=Self.CoordToNote(Y);
  If (SSLeft In Shift) Then
  Case fMode Of
    MdAddNote : AddNote(X,Y);
    MdSelectNote : If Not (ssShift In Shift) Then SelectNote(X,Y)
                   Else Begin XOld:=X; YOld:=Y; End;
    MdMoveNote : Begin XOld:=X; YOld:=Y; End;
  End;
end;

procedure TPianoGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  If (SSLeft In Shift) Then
  Case fMode Of
    MdAddNote : ResizeNote(X,Y);
    MdSelectNote : If (ssShift In Shift) Then DrawSelection(X,Y);
    MdMoveNote : MoveNote(X,Y);
  End;
end;

procedure TPianoGrid.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  If (fMode=MdSelectNote) And (ssShift In Shift)  Then
  SelectNotes;
end;

{>>TNoteCnt}
constructor TNoteCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TNote);
  ItemIndex:=-1;
end;

function TNoteCnt.Add:TNote;
begin
  Result := TNote(inherited Add);
end;

function TNoteCnt.GetItem(Index: Integer):TNote;
begin
  Result := TNote(inherited Items[Index]);
end;

procedure TNoteCnt.SetItem(Index: Integer; Value:TNote);
begin
  inherited SetItem(Index, Value);
end;

{>>TNote}
constructor TNote.Create;
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
    with TNote(Dest) do begin
      fOnChange := self.fOnChange;
      fBytes    := Self.fBytes;
      fBeginTime:=Self.fBeginTime;
      fEndTime:=Self.fEndTime;
      Selected:=Self.Selected;
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

function TNote.GetByte(index: Integer): Byte;
begin
  result := fBytes[index];
end;

procedure TNote.SetByte(index: Integer; value: Byte);
begin
  if fBytes[index] <> value then
  begin
    fBytes[index] := value;
    change;
  end;
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