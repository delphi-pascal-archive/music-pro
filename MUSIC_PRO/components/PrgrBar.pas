unit PrgrBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs;

type
  TPrgrBar = class(TCustomControl)
  private
    fColorFirst:TColor;
    fColorSecond:TColor;
    fColorThird:TColor;
    fColorEmpty:TColor;
    fMin:Integer;
    fMax:Integer;
    fPos:Integer;
    Procedure Set_ColorFirst(Value:TColor);
    Procedure Set_ColorSecond(Value:TColor);
    Procedure Set_ColorThird(Value:TColor);
    Procedure Set_ColorEmpty(Value:TColor);
    Procedure Set_Min(Value:Integer);
    Procedure Set_Max(Value:Integer);
    Procedure Set_Pos(Value:Integer);
  protected
    procedure Resize; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property ColorFirst:TColor Read fColorFirst Write Set_ColorFirst;
    Property ColorSecond:TColor Read fColorSecond Write Set_ColorSecond;
    Property ColorThird:TColor Read fColorThird Write Set_ColorThird;
    Property ColorEmpty:TColor Read fColorEmpty Write Set_ColorEmpty;
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
  RegisterComponents('MUSIC_PRO', [TPrgrBar]);
end;

constructor TPrgrBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  Width:=44;
  fMin:=-12;
  fMax:=12;
  fPos:=12;
  Color:=$00A3B4BE;
  ColorFirst:=$009CE8F5;
  ColorSecond:=$001ACBEA;
  ColorThird:=$0013AECA;
  ColorEmpty:=$00F7F4F2;
end;

destructor TPrgrBar.Destroy;
begin
  inherited;
end;

Procedure TPrgrBar.Set_ColorFirst(Value:TColor);
begin
  fColorFirst:=Value;
  Invalidate;
end;

Procedure TPrgrBar.Set_ColorSecond(Value:TColor);
begin
  fColorSecond:=Value;
  Invalidate;
end;

Procedure TPrgrBar.Set_ColorThird(Value:TColor);
begin
  fColorThird:=Value;
  Invalidate;
end;

Procedure TPrgrBar.Set_ColorEmpty(Value:TColor);
begin
  fColorEmpty:=Value;
  Invalidate;
end;

Procedure TPrgrBar.Set_Min(Value:Integer);
begin
  if (Value<=fPos) And (Value<fMax) Then
    Begin
      fMin:=Value;
      Invalidate;
    End;
end;

Procedure TPrgrBar.Set_Max(Value:Integer);
begin
  if (Value>=fPos) And (Value>fMin) Then
    Begin
      fMax:=Value;
      Invalidate;
    End;
end;

Procedure TPrgrBar.Set_Pos(Value:Integer);
begin
  if (Value>=fMin) And (Value<=fMax) Then
    Begin
      fPos:=Value;
      Invalidate;
    End;
end;

procedure TPrgrBar.Resize;
Begin
  InHerited;
  Width:=(Width Div 2)*2;
  If Width<50 Then Width:=50;
  Height:=6*Width;
End;  

procedure TPrgrBar.Paint;
Const
  HeightRect=5;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  HeightCurrent, IndexRect, NbRect, PosInDiv:Integer;
  ElemRect:TRect;
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
      HeightCurrent:=8*Height Div 10;
      NbRect:=HeightCurrent Div HeightRect;
      PosInDiv:=(fMax-fPos)*NbRect Div (fMax-fMin);
      For IndexRect:=0 To (NbRect-1) Do
      With ElemRect Do
        Begin
          Left:=Width Div 3;
          Right:=2*Width Div 3;
          Top:=Height Div 10 + IndexRect*HeightRect ;
          Bottom:=Top+HeightRect;
          If IndexRect<PosInDiv Then Brush.Color:=fColorEmpty
          Else
            Begin
              Brush.Color:=ColorThird;
              If IndexRect<(2*NbRect Div 3) Then Brush.Color:=ColorSecond;
              If IndexRect<(NbRect Div 3) Then Brush.Color:=ColorFirst;
            End;
          Pen.Color:=ClBlack;
          Rectangle(ElemRect);  
        End;
    End;
End;




end.