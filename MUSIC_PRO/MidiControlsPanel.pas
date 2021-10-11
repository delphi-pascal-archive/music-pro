{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit MidiControlsPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Graphics,
  TimeLine, Math, Menus,PianoGrid;

type

  TMode = (AtNone, AtResize);
  TMidiEffect = (MdChannelPressure,MdVelocity,MdVolume,MdPitchBEnd,MdModulation,
                 MdPortamentoTime,MdPortamentoSwitch,MdPortamentoNote,MdResonance,
                 MdExpression,MdPanoramic,MdPan,MdSustain);
  TNoteParams_Event = procedure(Sender: TObject; Note:TNote) of object;

  TMidiControlsPanel = class(TCustomControl)
  private
    fWidthPanels: Integer;
    fHeightPanels: Integer;
    fColorPanels: TColor;
    fColorValues: TColor;
    fTimeLine: TTimeLine;
    fPianoGrid: TPianoGrid;
    fPanelSelected: integer;
    MidiEffectUsed: TMidiEffect;
    fMode: TMode;
    fPopupMenu: TPopupMenu;
    fOnNoteParams: TNoteParams_Event;
    procedure SetWidthPanels(Value: Integer);
    procedure SetHeightPanels(Value: Integer);
    procedure SetColorPanels(Value: TColor);
    procedure SetColorValues(Value: TColor);
    procedure SetTimeLine(Value: TTimeLine);
    procedure SetPianoGrid(Value: TPianoGrid);
    procedure SetMode(Value: TMode);
    procedure Resizing(Shift: TShiftState; X, Y: integer);
  protected
    procedure MouseDown(Button: TMouseButton; ShIft: TShIftState;
      X, Y: integer); override;
    procedure MouseMove(ShIft: TShIftState; X, Y: integer); override;
    procedure Paint; override;
    procedure Resize; override;
  public
    NoteSelected:TNote;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property WidthPanels: Integer Read fWidthPanels Write SetWidthPanels;
    property HeightPanels: Integer Read fHeightPanels Write SetHeightPanels;
    property ColorPanels: TColor Read fColorPanels Write SetColorPanels;
    property ColorValues: TColor Read fColorValues Write SetColorValues;
    property TimeLine: TTimeLine Read FTimeLine Write SetTimeLine;
    property PianoGrid: TPianoGrid Read FPianoGrid Write SetPianoGrid;
    property Mode: TMode Read fMode Write SetMode;
    property PopupMenu: TPopupMenu Read fPopupMenu Write fPopupMenu;
    property NoteParams_On: TNoteParams_Event Read fOnNoteParams Write fOnNoteParams;
    property Color;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  End;

procedure Register;

implementation

procedure Register;
Begin
  RegisterComponents('Music_Pro', [TMidiControlsPanel]);
End;

constructor TMidiControlsPanel.Create(AOwner: TComponent);
Begin
  inherited Create(AOwner);
  fMode  := AtNone;
  fWidthPanels := 140;
  fHeightPanels := 15;
  fColorPanels:=$00B3CACC;
  Color:=$00C9E0E4;
  fColorValues:=$00B8B8C9;
  fPanelSelected := 0;
  doublebuffered := True;
End;

destructor TMidiControlsPanel.Destroy;
Begin
  inherited;
End;

procedure TMidiControlsPanel.SetTimeLine(Value: TTimeLine);
Begin
  FTimeLine  := Value;
  Width := (FTimeLine.Max-fTimeLine.Min)*20 + fWidthPanels;    
  Invalidate;
End;

procedure TMidiControlsPanel.SetPianoGrid(Value: TPianoGrid);
Begin
  FPianoGrid := Value;
End;

procedure TMidiControlsPanel.SetWidthPanels(Value: Integer);
Begin
  fWidthPanels := Value;
  Invalidate;
End;

procedure TMidiControlsPanel.SetHeightPanels(Value: Integer);
Begin
  fHeightPanels := Value;  
  Invalidate;  
End;

procedure TMidiControlsPanel.SetColorPanels(Value: TColor);
Begin
  fColorPanels := Value;
  Invalidate;
End;

procedure TMidiControlsPanel.SetColorValues(Value: TColor);
Begin
  fColorValues := Value;
  Invalidate;
End;

procedure TMidiControlsPanel.SetMode(Value: TMode);
Begin
  fMode := Value;
End;

procedure TMidiControlsPanel.Paint;
const
  NameMidiEffect: array [0..11] of
    string = ('ChannelPressure','Velocity','Volume','PitchBend',
              'Modulation','PortamentoTime','PortamentoSwitch',
              'PortamentoNote','Resonance','Expression','Panoramic',
              'Sustain');
var
  Text:String;
  Index,Min, Max, Yvalue:      integer;
  XCol, NbCol, NmCol, LeftText,TopText: Integer;
  RectPn,RectValue,RectText: TRect;
Begin
  inherited;
  With Canvas Do
  Begin
    Pen.Color:=ClBlack;
    Pen.Width:=0;
    for Index := 0 to 11 do
    Begin
      with RectPn Do
      Begin
        Left:=0;
        Right:=fWidthPanels;
        Top:=Index * fHeightPanels;
        Bottom:=Top+fHeightPanels;
        Text:=NameMidiEffect[Index];
        LeftText:=(fWidthPanels - TextWidth(Text)) Div 2;
        TopText:=Top+(fHeightPanels - TextHeight(Text)) Div 2;
      End;
      If Index<>fPanelSelected Then Brush.Color:= fColorPanels
      Else Brush.Color:=fColorValues;
      Rectangle(RectPn);
      TextOut(LeftText,TopText,Text);
    End;

    If Assigned(FTimeLine) Then
    Begin
      Pen.Color := ClGray;
      NbCol := (fPianoGrid.Max-fPianoGrid.Min)*fPianoGrid.Time;
      Width := 140+NbCol*20+60;
      NmCol := 0;
      XCol  := fWidthPanels;
      repeat
        MoveTo(XCol, 0);
        LineTo(XCol, Height);
        XCol := XCol + 20;
        Inc(NmCol);
      until NmCol = NbCol + 1;
      Brush.Style := BsClear;
      for Index := 0 to 11 do
      Begin
        MoveTo(fWidthPanels , Index * fHeightPanels);
        LineTo(Width, Index * fHeightPanels);
        If Index <> 0 Then
	Begin
	  Text:=IntToStr(127 - Round(Index *127 / 12));
	  LeftText:=(Width-30) - TextWidth(Text) Div 2;
	  TopText:=Index * fHeightPanels - TextHeight(Text) div 2;
          With RectText Do
          Begin
            Left:=Width-45;
            Right:=Width-15;
            Top:=TopText;
            Bottom:=Top+TextHeight(Text);
            Brush.Style:=BsSolid;
            Rectangle(RectText);
          End;
          Brush.Style:=BsClear;
          TextOut(LeftText,TopText,Text);
	End;
      End;
    End;	

    If (Assigned(fPianoGrid)) Then
    Begin
      If (fPianoGrid.NoteCnt.Count>0) Then
      Begin
        YValue := 0;
	for Index := 0 to (fPianoGrid.NoteCnt.Count-1) do
        With fPianoGrid.NoteCnt.Items[Index] Do
        Begin
          Min := fPianoGrid.TimeToCoord(BeginTime)+fWidthPanels;
          Max := fPianoGrid.TimeToCoord(EndTime)+fWidthPanels;
          If (Note = fPianoGrid.NoteSelected) And (Instr = fPianoGrid.InstrumentSelected)And
          (Min>=fWidthPanels) And (Max<=Width-60) Then
          Begin
            case MidiEffectUsed of
              MdChannelPressure: YValue :=ChannelPressure;
              MdVelocity: YValue := Velocity;
              MdVolume: YValue  := Volume;
              MdPitchBEnd: YValue := PitchBEnd;
              MdModulation: YValue := Modulation;
              MdPortamentoTime: YValue := PortamentoTime;
              MdPortamentoSwitch: YValue := PortamentoSwitch;
              MdPortamentoNote: YValue := PortamentoNote;
              MdResonance: YValue := Resonance;
              MdPan: YValue     := Pan;
              MdSustain: YValue := Sustain;
            End;
            With RectValue Do
            Begin
              Left:=WidthPanels +fPianoGrid.TimeToCoord(BeginTime);
              Right:=fWidthPanels + fPianoGrid.TimeToCoord(EndTime);
              Top :=Height;
              Bottom :=Round(Height * (1 - YValue / 127));
              Brush.Color:=fColorValues;
              Pen.Color:=fColorValues;
              Brush.Style:=BsSolid;
              Rectangle(RectValue);
              Text:=IntToStr(YValue);
              Brush.Style:=BsClear;
              Pen.Color:=ClBlack;
              Font.Color:=ClBlack;
              LeftText:=(RectValue.Left+RectValue.Right-TextWidth(Text)) Div 2;
              TopText:=RectValue.Bottom;
              If TopText>Height-TextHeight(Text) Then TopText:=Height-TextHeight(Text);
              TextOut(LeftText,TopText,Text);
            End;
          End;
        End;
      End;
    End;
    Brush.Color:=Color;
    Pen.Color:=ClBlack;
    Brush.Style := bsClear;
    Rectangle(ClientRect);    
  End;
End;

procedure TMidiControlsPanel.Resize;
Begin
  inherited;
  Height := fHeightPanels * 12;
End;

procedure TMidiControlsPanel.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
Begin
  inherited;
  If x<WidthPanels Then
  Begin
    fPanelSelected:=Y Div fHeightPanels;
    Self.MidiEffectUsed:=TMidiEffect(fPanelSelected);
    Invalidate;
  End;  
  If (Assigned(fPopupMenu)) And (Shift = [ssRight]) Then
  fPopupMenu.Popup(ClientOrigin.X + x, ClientOrigin.Y + y);
  If (Assigned(fPianoGrid)) And (fPianoGrid.NoteCnt.Count>0) Then
  MouseMove(Shift,X,Y);
End;

procedure TMidiControlsPanel.MouseMove(Shift: TShiftState; X, Y: integer);
Begin
  inherited;
  If (Y<0) or (Y>Height) Then Exit;  
  If fMode = AtResize Then Resizing(Shift, X, Y);
End;

procedure TMidiControlsPanel.Resizing(Shift: TShiftState; X, Y: integer);
var
  Min, Max, Value: integer;
  Index: Integer;
Begin
  If fPianoGrid.NoteCnt.Count>0 Then
  for Index := 0 to (fPianoGrid.NoteCnt.Count-1) do
  With fPianoGrid.NoteCnt.Items[Index] Do
  Begin
    Min := fPianoGrid.TimeToCoord(BeginTime)+fWidthPanels;
    Max := fPianoGrid.TimeToCoord(EndTime)+fWidthPanels;
    If (X >= Min) And (X <= Max) And (Note=fPianoGrid.NoteSelected) And
    (Instr=fPianoGrid.InstrumentSelected) Then
    Begin
      Value := Round(127 * (1 - Y / Height));
      If (Shift = [ssLeft]) Then
      case MidiEffectUsed of
        MdChannelPressure: ChannelPressure := Value;
        MdVelocity: Velocity := Value;
        MdVolume: Volume := Value;
        MdPitchBEnd: PitchBEnd := Value;
        MdModulation: Modulation := Value;
        MdPortamentoTime: PortamentoTime := Value;
        MdPortamentoSwitch: PortamentoSwitch := Value;
        MdPortamentoNote: PortamentoNote := Value;
        MdResonance: Resonance := Value;
        MdPan: Pan := Value;
        MdSustain: Sustain := Value;
      End;
      If Assigned(fOnNoteParams) Then fOnNoteParams(Self,fPianoGrid.NoteCnt.Items[Index]);
    End;
    Invalidate;
  End;
End;

End.
