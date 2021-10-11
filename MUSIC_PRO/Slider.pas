unit Slider;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics;

type
  TSlider = class(TCustomControl)
  private
    fCaption:String;  
    fColorBackGrnd:TColor;   
    fColorSlot:TColor;
    fMin:Integer;
    fMax:Integer;
    fPos:Integer;
    fOnChange : TNotifyEvent;
    Procedure Set_Caption(Value:String);   
    Procedure Set_ColorSlot(Value:TColor);
    Procedure Set_ColorBackGrnd(Value:TColor);
    Procedure Set_Min(Value:Integer);
    Procedure Set_Max(Value:Integer);
    Procedure Set_Pos(Value:Integer);
  protected
    procedure Resize; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Caption : String Read fCaption Write Set_Caption;
    Property ColorSlot:TColor Read fColorSlot Write Set_ColorSlot;
    Property ColorBackGrnd:TColor Read fColorBackGrnd Write Set_ColorBackGrnd;
    Property Min:Integer Read fMin Write Set_Min;
    Property Max:Integer Read fMax Write Set_Max;
    Property Pos:Integer Read fPos Write Set_Pos;
    Property Tag;
    Property Enabled;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;   
    Property OnDblClick;    
    Property Color;
    Property OnChange:TNotifyEvent Read fOnChange Write fOnChange;
    Property OnEnter;
    Property OnExit;
    Property OnKeyPress;
    Property OnKeyDown;
    Property OnKeyUp;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TSlider]);
end;

constructor TSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  Width:=44;
  fMin:=-50;
  fMax:=50;
  fPos:=0;
  Color:=$00A3B4BE;
  ColorSlot:=clWhite;
end;

destructor TSlider.Destroy;
begin
  inherited;
end;

Procedure TSlider.Set_Caption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

Procedure TSlider.Set_ColorSlot(Value:TColor);
begin
  fColorSlot:=Value;
  Invalidate;
end;

Procedure TSlider.Set_ColorBackGrnd(Value:TColor);
begin
  fColorBackGrnd:=Value;
  Invalidate;
end;

Procedure TSlider.Set_Min(Value:Integer);
begin
  if (Value<=fPos) And (Value<fMax) Then
    Begin
      fMin:=Value;
      Invalidate;
    End;
end;

Procedure TSlider.Set_Max(Value:Integer);
begin
  if (Value>=fPos) And (Value>fMin) Then
    Begin
      fMax:=Value;
      Invalidate;
    End;
end;

Procedure TSlider.Set_Pos(Value:Integer);
begin
  if (Value>=fMin) And (Value<=fMax) Then
    Begin
      fPos:=Value;
      Invalidate;
    End;
end;

procedure TSlider.Resize;
Begin
  InHerited;
  Width:=100;
  Height:=35;
End;

procedure TSlider.Paint;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  SlotRect,Rect:TRect;
  X,WidthText,HeightText:Integer;
  ValueStr:String;
Begin
  InHerited;
  With Canvas Do
    Begin
      Pen.Width:=2;
      UpperCorner[0]:=Point(0,Height);
      UpperCorner[1]:=Point(0,0);
      UpperCorner[2]:=Point(Width,0);
      LowerCorner[0]:=Point(0,Self.Height);
      LowerCorner[1]:=Point(Width,Height);
      LowerCorner[2]:=Point(Width,0);
      Pen.Color:=ClWhite;
      Polyline(UpperCorner);
      Pen.Color:=$00657271;
      Polyline(LowerCorner);

      Pen.Width:=1;
      Brush.Color:=fColorBackGrnd;
      With Rect Do
      Begin
        Left:=Width Div 10;
        Right:=9*Width Div 10;
        Top:=55*Height Div 100;
        Bottom:=95*Height Div 100;
      End;
      Rectangle(Rect);            

      X:=(8*Width Div 10)*(fPos-fMin) Div (fMax-fMin)+Width Div 10;
      Pen.Width:=1;
      Brush.Color:=fColorSlot;
      With SlotRect Do
      Begin
        Left:=X-2;
        Right:=X+2;
        Top:=55*Height Div 100;
        Bottom:=95*Height Div 100;
      End;
      Rectangle(SlotRect);

      Pen.Width:=0;      
      ValueStr:=fCaption+' '+IntToStr(fPos);
      WidthText:=(Width-TextWidth(ValueStr)) Div 2;
      HeightText:=(Height Div 2 - TextHeight(ValueStr)) Div 2;
      Brush.Style:=BsClear;
      TextOut(WidthText,HeightText,ValueStr);
    End;
End;


procedure TSlider.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If SSLeft In Shift Then  
  MouseMove(Shift, X, Y);
End;

procedure TSlider.MouseMove(Shift: TShiftState; X, Y: Integer);
Begin
  InHerited;
  If SSLeft In Shift Then
  Begin
    fPos:=(X-Width Div 10)*(fMax-fMin) Div (8*Width Div 10)+fMin;
    If fPos>fMax Then fPos:=fMax;
    if fPos<fMin Then fPos:=fMin;
    Invalidate;
    If Assigned(fOnChange) Then fOnChange(Self);
  End;  
End;

end.
