unit DSPEffect;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics, Dialogs;

type

  TTypeDSP=(TEcho,TFlanger,TVolume,TReverb,TLowPassFilter,TAmplification,
            TAutoWah,TEcho2,TPhaser,TEcho3,TChorus,TAllPassFilter,TCompressor,
	    TDistortion);

{>>TRoundButton}
TRoundButton = class(TCustomControl)
  private
    fBorderColor: TColor;
    fStickColor: TColor;
    fValuesColor: TColor;
    fMin:   integer;
    fMax:   integer;
    fPos:   integer;
    fDelta: extended;
    fVisiblePosition: boolean;
    fTitle:String;
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetPos(Value: integer);
    procedure SetStickColor(Value: TColor);
    procedure SetBorderColor(Value: TColor);
    procedure SetVisiblePosition(Value: boolean);
    procedure SetValuesColor(Value: TColor);
    Procedure SetTitle(Value:String);
  protected
    { Protected declarations }
  public
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Title:String Read fTitle Write SetTitle;
    property StickColor: TColor Read fStickColor Write SetStickColor;
    property BorderColor: TColor Read fBorderColor Write SetBorderColor;
    property ValuesColor: TColor Read fValuesColor Write SetValuesColor;
    property VisiblePosition: boolean Read fVisiblePosition Write SetVisiblePosition;
    property Min: integer Read fMin Write SetMin default 0;
    property Max: integer Read fMax Write SetMax default 100;
    property Pos: integer Read fPos Write SetPos default 10;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Color;
  end;

{>>TTypeDSPEffect}
TDSPEffect = class(TCustomControl)
  private
    fBackGroundColor:TColor;
    fPanelColor:TColor;
    fTypeDSP:TTypeDSP;
    fButtons:Array[0..22] Of TRoundButton;
    Procedure SetBackGroundColor(Value:TColor);
    Procedure SetPanelColor(Value:TColor);
    function TypeDSPToString(Const ATypeDSP: TTypeDSP): string;
    Procedure SetTypeDSP(Value:TTypeDSP);
    Procedure CreateButton;
    function NbParams(Const ATypeDSP: TTypeDSP): Cardinal;
  protected
    { Protected declarations }
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    Procedure Paint; override;
    Procedure Resize; override;
    function GetButton(index: integer): TRoundButton;
    procedure SetButton(index: integer; value: TRoundButton);
  published
    Property BackGroundColor:TColor Read fBackGroundColor Write SetBackGroundColor;
    Property TypeDSP: TTypeDSP Read fTypeDSP Write SetTypeDSP;
    Property PanelColor: TColor Read fPanelColor Write SetPanelColor;
    Property ALevel       :TRoundButton index 0 Read GetButton write SetButton;
    Property ADelay       :TRoundButton index 1 Read GetButton write SetButton;
    Property AWetDry      :TRoundButton index 2 Read GetButton write SetButton;
    Property ADryMix      :TRoundButton index 3 Read GetButton write SetButton;
    Property AWetMix      :TRoundButton index 4 Read GetButton write SetButton;
    Property AFeedback    :TRoundButton index 5 Read GetButton write SetButton;
    Property ASpeed       :TRoundButton index 6 Read GetButton write SetButton;
    Property AMinSweep    :TRoundButton index 7 Read GetButton write SetButton;
    Property AMaxSweep    :TRoundButton index 8 Read GetButton write SetButton;
    Property AThreshold :TRoundButton index 9 Read GetButton write SetButton;
    Property AnAttacktime :TRoundButton index 10 Read GetButton write SetButton;
    Property AReleasetime :TRoundButton index 11 Read GetButton write SetButton;
    Property AVolume      :TRoundButton index 12 Read GetButton write SetButton;
    Property AResonance   :TRoundButton index 13 Read GetButton write SetButton;
    Property ACutOffFreq  :TRoundButton index 14 Read GetButton write SetButton;
    Property ATarget      :TRoundButton index 15 Read GetButton write SetButton;
    Property AQuiet       :TRoundButton index 16 Read GetButton write SetButton;
    Property ARate        :TRoundButton index 17 Read GetButton write SetButton;
    Property ARange       :TRoundButton index 18 Read GetButton write SetButton;
    Property AFreq        :TRoundButton index 19 Read GetButton write SetButton;
    Property AGain        :TRoundButton index 20 Read GetButton write SetButton;
    Property ADrive       :TRoundButton index 21 Read GetButton write SetButton;
    Property ALDelay      :TRoundButton index 22 Read GetButton write SetButton;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TDSPEffect]);
end;


constructor TRoundButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Visible:=False;
  fMin := 0;
  fMax := 100;
  fPos := 0;
  Self.fBorderColor := $004B4B4B;
  Self.fStickColor := ClWhite;
  doublebuffered := True;
end;

destructor TRoundButton.Destroy;
begin
  inherited;
end;

Procedure TRoundButton.SetTitle(Value:String);
Begin
  If Assigned(Self) Then
  Begin
    fTitle:=Value;
    Self.Invalidate;
  End;
End;

procedure TRoundButton.SetStickColor(Value: TColor);
begin
  if fStickColor = Value then
    exit;
  fStickColor := Value;
  Self.Invalidate;
end;

procedure TRoundButton.SetBorderColor(Value: TColor);
begin
  fBorderColor := Value;
  Self.Invalidate;
end;

procedure TRoundButton.SetValuesColor(Value: TColor);
begin
  fValuesColor := Value;
  Self.Invalidate;
end;

procedure TRoundButton.Resize;
begin
  Self.Height := Self.Width;
  Self.Invalidate;
end;

procedure TRoundButton.SetMin(Value: integer);
begin
  if (Value < fMax) and (Value <= fPos) then
    fMin := Value;
  fDelta := (270 * (fMin - fPos) / (fMin - fMax) - 45) * PI / 180;
  Self.Invalidate;
end;

procedure TRoundButton.SetMax(Value: integer);
begin
  if (Value > fMin) and (Value >= fPos) then
    fMax := Value;
  fDelta := (270 * (fMin - fPos) / (fMin - fMax) - 45) * PI / 180;
  fPos := Round(fMin - (fMin - fMax) * ((180 * fDelta / PI) + 45) / 270);
  Self.Invalidate;
end;

procedure TRoundButton.SetPos(Value: integer);
begin
  if (Value <= fMin) then
    fPos := fMin;
  if (Value >= fMax) then
    fPos := FMax;
  fPos := Value;
  fDelta := (270 * (fMin - fPos) / (fMin - fMax) - 45) * PI / 180;
  fPos   := Round(fMin - (fMin - fMax) * ((180 * fDelta / PI) + 45) / 270);
  Self.Invalidate;
end;

procedure TRoundButton.SetVisiblePosition(Value: boolean);
begin
  fVisiblePosition := Value;
  Self.Invalidate;
end;

procedure TRoundButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  I: extended;
begin
  inherited;
  if Shift = [SSLeft] then
  begin
    if X <> Self.Width div 2 then
    begin
      I      := (Y - Self.Width div 2) / (X - Self.Width div 2);
      fDelta := ArcTan(I);
      if x > Self.Width div 2 then
        fDelta := FDelta + PI;
      if fDelta >= (225 * PI / 180) then
        fDelta := (225 * PI / 180);
      if fDelta <= (-45 * PI / 180) then
        fDelta := (-45 * PI / 180);
      fPos := Round(fMin + (fMax - fMin) * (fDelta * 180 / PI + 45) / 270);
      Self.Invalidate;
    end;
  end;
end;

procedure TRoundButton.MouseMove(Shift: TShiftState; X, Y: integer);
var
  I: extended;
begin
  inherited;
  if Shift = [SSLeft] then
  begin
    if X <> Self.Width div 2 then
    begin
      I      := (Y - Self.Width div 2) / (X - Self.Width div 2);
      fDelta := ArcTan(I);
      if x > Self.Width div 2 then
        fDelta := FDelta + PI;
      if fDelta >= (225 * PI / 180) then
        fDelta := (225 * PI / 180);
      if fDelta <= (-45 * PI / 180) then
        fDelta := (-45 * PI / 180);
      fPos := Round(fMin + (fMax - fMin) * (fDelta * 180 / PI + 45) / 270);
      Self.Invalidate;
    end;
  end;
end;

procedure TRoundButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
end;

procedure TRoundButton.Paint;
var
  R:    extended;
  WidthText, WidthTitle, HeightText: integer;
  Rect: TRect;
begin
  if not assigned(Parent) then
    exit;
  with Self.Canvas do
  begin
    Brush.Color := fBorderColor;
    Brush.Style := bsSolid;
    Pen.Color   := ClBlack;
    Pen.Width   := 1;
    with Rect do
    begin
      Left   := Round(0.25 * Self.Width);
      Right  := Round(0.75 * Self.Width);
      Top    := Round(0.25 * Self.Width);
      Bottom := Round(0.75 * Self.Width);
    end;
    Ellipse(Rect);
    Brush.Color := fStickColor;
    Pen.Color := Brush.Color;
    Pen.Width := 4;
    R := (3 * Width div 14);
    with Rect do
    begin
      MoveTo(Width div 2, Height div 2);
      LineTo(Self.Width div 2 - Round(R * Cos(fDelta)), Round(Self.Width div
        2 - R * Sin(fDelta)));
    end;
    Font.Size := Self.Width div 8;
    Font.Name := 'Courrier';
    WidthText := TextWidth(IntToStr(fMax));
    HeightText := TextHeight(IntToStr(fMax));
    R := Width div 2;
    Brush.Style := BsClear;
    Font.Color := Self.fValuesColor;
    TextOut(Round(R * (1 - Cos(-45 * PI / 180))) - WidthText div
      10000, Round(R * (1 - Sin(-45 * PI / 180))) - Round(HeightText / 0.8), IntToStr(fMin));
    TextOut(Round(R * (1 - Cos(225 * PI / 180))) - WidthText div
      2, Round(R * (1 - Sin(-45 * PI / 180))) - Round(HeightText / 0.9), IntToStr(fMax));
    if VisiblePosition = True then
    begin
      WidthText  := TextWidth(IntToStr(fPos));
      HeightText := TextHeight(IntToStr(fPos));
      TextOut(Self.Width div 2 - WidthText div 2,Round( 0.95*Self.Height-HeightText), IntToStr(fPos));
    end;
    WidthTitle:=TextWidth(fTitle);
    TextOut((Width-WIdthTitle) Div 2,0,fTitle);
  end;
end;

constructor TDSPEffect.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  fBackGroundColor:=$00404040;
  fPanelColor:=$00E4DCDD;
  DoubleBuffered:=True;
  CreateButton;
  fTypeDSP:=TEcho;
  Invalidate;
end;

destructor TDSPEffect.Destroy;
Var
  Index:Cardinal;
begin
  For Index:=0 To 21 Do
  fButtons[Index].Free;
  inherited;
end;

Procedure TDSPEffect.CreateButton;
Const
  Params:Array[0..22] Of String=('Level','Delay','WetDry','DryMix','WetMix','Feedback',
                                 'Speed','MinSweep','MaxSweep','Threshold','Attacktime',
                                 'Releasetime','Volume','Resonance','CutOffFreq','Target',
                                 'Quiet','Rate','Range','Freq','Gain','Drive','LDelay');
Var
  Index:Cardinal;
Begin
  For Index:=0 To 22 Do
    Begin
      fButtons[Index]:=TRoundButton.Create(Self);
        With fButtons[Index] Do
          Begin
            Parent:=Self;
            Name:=Params[Index];
            Visible:=False;
            Title:=Name;
            Color:=$00E4DCDD;
            fVisiblePosition:=True;
            SetSubComponent(True);
          End;
    End;
End;

Procedure TDSPEffect.SetBackGroundColor(Value:TColor);
Begin
  If Assigned(Self) Then
  Begin
    fBackGroundColor:=Value;
    Self.Invalidate;
  End;
End;

Procedure TDSPEffect.SetPanelColor(Value:TColor);
Begin
  If Assigned(Self) Then
  Begin
    fPanelColor:=Value;
    Self.Invalidate;
  End;
End;

Procedure TDSPEffect.SetTypeDSP(Value:TTypeDSP);
Var
  Index:Cardinal;
Begin
  If Assigned(Self) Then
  Begin
    fTypeDSP:=Value;
    For Index:=0 To 22 Do
    fButtons[Index].Visible:=False;
    Case Value Of
      TEcho,TReverb: Begin
                       fButtons[0].Visible:=True;
                       fButtons[22].Visible:=True;
                     End;
      TFlanger: Begin
                  fButtons[2].Visible:=True;
                  fButtons[6].Visible:=True;
                End;
      TVolume: fButtons[12].Visible:=True;
      TLowPassFilter: Begin
                        fButtons[13].Visible:=True;
                        fButtons[14].Visible:=True;
                        fButtons[19].Visible:=True;
                      End;
      TAmplification: Begin
                        fButtons[15].Visible:=True;
                        fButtons[16].Visible:=True;
                        fButtons[17].Visible:=True;
                        fButtons[1].Visible:=True;
                        fButtons[20].Visible:=True;
                      End;
      TAutoWah,TPhaser: Begin
                          fButtons[3].Visible:=True;
                          fButtons[4].Visible:=True;
                          fButtons[5].Visible:=True;
                          fButtons[17].Visible:=True;
                          fButtons[18].Visible:=True;
                          fButtons[19].Visible:=True;
                    End;
      TEcho2: Begin
                fButtons[3].Visible:=True;
                fButtons[4].Visible:=True;
                fButtons[5].Visible:=True;
                fButtons[1].Visible:=True;
              End;
      TEcho3: Begin
               fButtons[3].Visible:=True;
                fButtons[4].Visible:=True;
                fButtons[1].Visible:=True;
              End;
      TChorus: Begin
                 fButtons[3].Visible:=True;
                 fButtons[4].Visible:=True;
                 fButtons[5].Visible:=True;
                 fButtons[7].Visible:=True;
                 fButtons[8].Visible:=True;
                 fButtons[17].Visible:=True;
               End;
      TAllPassFilter: Begin
                        fButtons[1].Visible:=True;
                        fButtons[20].Visible:=True;
                      End;
      TCompressor: Begin
                     fButtons[9].Visible:=True;
                     fButtons[10].Visible:=True;
                     fButtons[11].Visible:=True;
                   End;
      TDistortion: Begin
                     fButtons[3].Visible:=True;
                     fButtons[5].Visible:=True;
                     fButtons[5].Visible:=True;
                     fButtons[12].Visible:=True;
                     fButtons[21].Visible:=True;
                   End;
  End;
    Resize;
    Invalidate;
  End;
End;

Procedure TDSPEffect.Resize;
Begin
  If Assigned(Self) Then
    Begin
     Height:=120;
     Width:=330+NbParams(fTypeDSP)*60;
    End;
End;

function TDSPEffect.TypeDSPToString(Const ATypeDSP: TTypeDSP): string;
const
  TypeDSPToStr: array[TTypeDSP] of string =
    ('Echo','Flanger','Volume','Reverb','LowPass Filter','Amplification',
     'AutoWah','Echo2','Phaser','Echo3','Chorus','AllPassFilter',
     'Compressor','Distortion');
begin
  Result := TypeDSPToStr[ATypeDSP];
end;

function TDSPEffect.NbParams(Const ATypeDSP: TTypeDSP): Cardinal;
const
  SetNbParams: array[TTypeDSP] of Cardinal=(2,2,1,2,3,5,6,4,6,3,6,2,3,4);
begin
  Result:=SetNbParams[ATypeDSP];
end;

function TDSPEffect.GetButton(index: integer): TRoundButton;
begin
  result := fButtons[index];
end;

procedure TDSPEffect.SetButton(index: integer; value: TRoundButton);
begin
  if fButtons[index] <> value then
  fButtons[index] := value;
end;

Procedure TDSPEffect.Paint;
Var
  R1, G1, B1, R2, G2, B2 : integer;
  Rect:TRect;
   Index, CountButton:Integer;
begin
  inherited;
  R1 := GetRValue(Self.fBackGroundColor);
  G1 := GetGValue(Self.fBackGroundColor);
  B1 := GetBValue(Self.fBackGroundColor);
  R2 := R1+Round(0.85*R1);
  G2 := G1+Round(0.85*G1);
  B2 := B1+Round(0.85*B1);
  With Canvas Do
    Begin
      Brush.Color:=Self.fBackGroundColor;
      Pen.Color:=ClBlack;
      Rectangle(ClientRect);
      Pen.Width:=3;
      Brush.Color:=RGB(R1,G1,B1);
      Pen.Color:=RGB(R2,G2,B2);
      Brush.Color:=RGB(R1,G1,B1);
      MoveTo(115,Round(Self.Height*0.10));
      LineTo(115,Round(Self.Height*0.90));
      MoveTo(Width-50,Round(Self.Height*0.10));
      LineTo(Width-50,Round(Self.Height*0.90));
      Font.Size:=11;
      Font.Name:='BitStream Vera Sans';
      Brush.Style:=BsClear;
      Font.Color:=ClWhite;
      TextOut(125,Round(Self.Height*0.35),TypeDSPToString(fTypeDSP));
      TextOut(10,Round(Self.Height*0.05),'DSP Effect');
      Font.Color:=ClRed;
      Font.Size:=12;
      Font.Name:='MS LineDraw';
      TextOut(Round(Self.Width*0.01),Round(Self.Height*0.5),'MUSIC PRO');      

      Pen.Width:=3;
      Pen.Color:=ClBlack;
      Brush.Color:=ClBlack;
      Brush.Color:=Self.fPanelColor;      
      Rect.Left:=230;
      Rect.Right:=Rect.Left+30+Round((NbParams(fTypeDSP))*60); 
      Rect.Top:=Round(Self.Height*0.10);
      Rect.Bottom:=Round(Self.Height*0.90);
      RoundRect(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom,Round(0.02*(Rect.Right-Rect.Left)),Round(0.02*(Rect.Top-Rect.Bottom)));
      Rect.Left:=Rect.Left+5;
      Rect.Right:=Rect.Right-5;
      Rect.Top:=Rect.Top+5;
      Rect.Bottom:=Rect.Bottom-5;
      RoundRect(Rect.Left,Rect.Top,Rect.Right,Rect.Bottom,Round(0.02*(Rect.Right-Rect.Left)),Round(0.02*(Rect.Top-Rect.Bottom)));

    End;
    CountButton:=0;
    For Index:=0 To 22 Do
      Begin
        If fButtons[Index].Visible Then
          Begin
            fButtons[Index].Width:=60;
            fButtons[Index].Left:=240+CountButton*60;
            fButtons[Index].Top:=Round(Height*0.26);
            Inc(CountButton);
          End
        Else
          Begin
            fButtons[Index].Width:=0;
            fButtons[Index].Left:=0;
            fButtons[Index].Top:=0;
          End;
      End;
end;


end.

