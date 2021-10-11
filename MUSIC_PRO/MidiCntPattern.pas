{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit MidiCntPattern;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, PatternMidi, Dialogs;

type
  TMidiCntPattern = class(TCustomControl)
  private
    fColorPanels: TColor;
    fColorValues: TColor;
    fColorTitle:TColor;
    fColorTextTitle:TColor;
    fTitle:String;
    fPatternMidi: TPatternMidi;
    fMoving: boolean;
    fOnChange: TNotifyEvent;
    procedure SetColorPanels(Value: TColor);
    procedure SetColorValues(Value: TColor);
    procedure SetColorTitle(Value: TColor);
    procedure SetColorTextTitle(Value: TColor);
    Procedure SetTitle(Value:String);     
    procedure SetPatternMidi(Value: TPatternMidi);
    procedure Moving(X, Y: integer);
  protected
    { Déclarations protégées }
  public
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure Paint; override;
    procedure Resize; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Color;
    Property Visible;
    property ColorPanels: TColor Read fColorPanels Write SetColorPanels;
    property ColorValues: TColor Read fColorValues Write SetColorValues;
    property ColorTitle: TColor Read fColorTitle Write SetColorTitle;
    property ColorTextTitle: TColor Read fColorTextTitle Write SetColorTextTitle;
    Property Title:String Read fTitle Write SetTitle;
    property PatternMidi: TPatternMidi Read fPatternMidi Write SetPatternMidi;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;
    Property OnDblClick;
    Property OnChange:TNotifyEvent Read fOnChange Write fOnChange;
  end;

Var
  Effect:Integer;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TMidiCntPattern]);
end;

constructor TMidiCntPattern.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered := True;
  Effect:=-1;
  fMoving := False;
  Color:=$00CCCCD7;
  fColorPanels:=$00757575;
  fColorValues:=$00A3A3B6;
  fColorTitle:=$00757575;
  fColorTextTitle:=ClRed;
  fTitle:='EFFETS MIDI';
  fOnChange:=Nil;
end;

destructor TMidiCntPattern.Destroy;
begin
  inherited;
end;

procedure TMidiCntPattern.SetColorPanels(Value: TColor);
begin
  fColorPanels := Value;
  Invalidate;
end;

procedure TMidiCntPattern.SetColorValues(Value: TColor);
begin
  fColorValues := Value;
  Invalidate;
end;

procedure TMidiCntPattern.SetColorTitle(Value: TColor);
begin
  fColorTitle:= Value;
  Invalidate;
end;

procedure TMidiCntPattern.SetColorTextTitle(Value: TColor);
begin
  fColorTextTitle := Value;
  Invalidate;
end;

Procedure TMidiCntPattern.SetTitle(Value:String);
begin
  fTitle := Value;
  Invalidate;
end;

procedure TMidiCntPattern.SetPatternMidi(Value: TPatternMidi);
begin
  fPatternMidi := Value;
  Invalidate;
end;

procedure TMidiCntPattern.Paint;
const
  NameMidiEffect: array [0..12] of
    string = ('Channel', 'ChannelPressure', 'Velocity', 'Volume', 'PitchBend',
              'Modulation', 'PortamentoTime', 'PortamentoSwitch', 'PortamentoNote',
              'Resonance', 'Expression', 'Panoramic', 'Sustain');
var
  HeightLine, IndexParams, HeightText, TextTop, TextLeft, Value: integer;
  ValueCoeff: real;
  PatternsRect,ValueRect,TitleRect: TRect;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;  
  ValueString: string;
begin
  inherited;
  Value      := 0;
  HeightLine := (Self.Height-20) div 13;    
  with Self.Canvas do
  begin
    Pen.Color:=ClBlack;
    Brush.Color:=Color;
    Rectangle(ClientRect);  
    with PatternsRect do
    begin
      Top    := 20;
      Bottom := Height;
      Left   := 0;
      Right  := Round(Width * 0.2);
      Brush.Color := ColorPanels;
      Rectangle(PatternsRect);
    end;
    with TitleRect do
    begin
      Top    := 0;
      Bottom := 20+Pen.Width;
      Left   := 0;
      Right  := Width;
      Brush.Color :=fColorTitle;
      Rectangle(TitleRect);
    end;
    HeightText:=TextHeight(fTitle);
    TextTop:=(20-HeightText) Div 2;
    Font.Style:=[fsBold,fsUnderline];
    Font.Color:=fColorTextTitle;
    TextOut(10,TextTop,fTitle);
    Font.Style:=Font.Style-[fsBold,fsUnderline];
    for IndexParams := 0 to 12 do
    begin
      Pen.Color:=ClBlack;
      MoveTo(0, IndexParams * HeightLine+20);         
      LineTo(Width, IndexParams * HeightLine+20);
      HeightText  := TextHeight(NameMidiEffect[IndexParams]);
      TextTop     := 20+Round(HeightLine * (IndexParams + 0.5)) - HeightText div 2;
      TextLeft    := Round(0.02 * Width);
      Font.Color:=ClWhite;
      TextOut(TextLeft, TextTop, NameMidiEffect[IndexParams]);
      if Assigned(fPatternMidi) then
      begin
        ValueCoeff := Width * 0.75 / 127;
       with ValueRect do
        begin
          With fPatternMidi Do
          If InstrumentSelected>-1 Then
          with InstrPatternCnt.Items[InstrumentSelected] do
            case IndexParams of
              0: Value  := Channel;
              1: Value  := ChannelPressure;
              2: Value  := Velocity;
              3: Value  := Volume;
              4: Value  := PitchBend;
              5: Value  := Modulation;
              6: Value  := PortamentoTime;
              7: Value  := PortamentoSwitch;
              8: Value  := PortamentoNote;
              9: Value  := Resonance;
              10: Value := Expression;
              11: Value := Pan;
              12: Value := Sustain;
              Else Break;
            end;
          Left   := Round(Width * 0.20);
          Right  := Left + Round(ValueCoeff * Value);
          Top    := 20+Round(IndexParams * HeightLine) + 2*Pen.Width;
          Bottom := 20+Round((IndexParams + 1) * HeightLine) - 2*Pen.Width;
          Pen.Color := fColorValues;
          Brush.Style := BsSolid;
          Brush.Color := fColorValues;
          Rectangle(ValueRect);
          UpperCorner[0]:=Point(Right,Top);
          UpperCorner[1]:=Point(Left,Top);
          UpperCorner[2]:=Point(Left,Bottom);
          LowerCorner[0]:=Point(Left,Bottom);
          LowerCorner[1]:=Point(Right,Bottom);
          LowerCorner[2]:=Point(Right,Top);
          Brush.Color:=ClWhite;
          Pen.Color:=ClWhite;
          Polyline(UpperCorner);
          Brush.Color:=$005F5F5F;
          Pen.Color:=$005F5F5F;
          Polyline(LowerCorner);       
          ValueString := IntToStr(Value);
          HeightText  := TextHeight(ValueString);
          TextTop     := 20+Round(HeightLine * (IndexParams + 0.5)) - HeightText div 2;
          TextLeft    := Left + Round(ValueCoeff * Value) + 5;
          Brush.Style := BsClear;
          Font.Color:=ClBlack;
          TextOut(TextLeft, TextTop, ValueString);
        end;
      end;
    end;
  end;
end;

procedure TMidiCntPattern.Resize;
begin
  inherited;
  Width  := 600;
  Height := 215;    
end;

procedure TMidiCntPattern.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  if (Assigned(fPatternMidi)) and (fPatternMidi.InstrumentSelected > -1) then
  begin
    Effect := ((Y-20)*13) div (Height-20);
    fMoving := True;
    Moving(X, Y);
  end;
end;

procedure TMidiCntPattern.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
  Moving(X, Y);
end;

procedure TMidiCntPattern.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: integer);
begin
  inherited;
  Effect:=-1;
  if (Assigned(fPatternMidi)) and (fPatternMidi.InstrumentSelected > -1) then
    fMoving := False;
end;


procedure TMidiCntPattern.Moving(X, Y: integer);
type
  TEffects = (Channel, ChannelPressure);
var
  XPos, XMin, XMax, Value: Integer;
  ValueCoeff: real;
begin
  Value      := 0;
  ValueCoeff := Width * 0.75  / 127;
  with fPatternMidi Do
  If Assigned(fPatternMidi) And (InstrumentSelected>-1) Then
  With InstrPatternCnt.Items[InstrumentSelected] do
    begin
      begin
        case Effect of
          0: Value  := Channel;
          1: Value  := ChannelPressure;
          2: Value  := Velocity;
          3: Value  := Volume;
          4: Value  := PitchBend;
          5: Value  := Modulation;
          6: Value  := PortamentoTime;
          7: Value  := PortamentoSwitch;
          8: Value  := PortamentoNote;
          9: Value  := Resonance;
          10: Value := Expression;
          11: Value := Pan;
          12: Value := Sustain;
        end;
        XPos := Round(Width * 0.20) + Round(ValueCoeff * Value);
        XMin := XPos-20;
        XMax := XPos+20;
        if (X > XMin) and (X < XMax) then
        begin
          Value := Round((X - Self.Width * 0.20) / ValueCoeff);
          if Value > 127 then
            Value := 127;
          If Value<0 Then
            Value:=0;
          if fMoving = True then
            case Effect of
              0: Channel  := Value;
              1: ChannelPressure := Value;
              2: Velocity := Value;
              3: Volume   := Value;
              4: PitchBend := Value;
              5: Modulation := Value;
              6: PortamentoTime := Value;
              7: PortamentoSwitch := Value;
              8: PortamentoNote := Value;
              9: Resonance := Value;
              10: Expression := Value;
              11: Pan     := Value;
              12: Sustain := Value;
            end;
          if (Effect = 0) and (Channel > 15) then
            Channel := 15;
          Self.Invalidate;
          If Assigned(fOnChange) Then fOnChange(Self);
        end;
      end;
    end;
end;



end.
