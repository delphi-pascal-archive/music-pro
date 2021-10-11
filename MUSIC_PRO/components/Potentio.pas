unit potentio;

interface

uses
  SysUtils, Classes, Controls, Forms, Messages, Windows, ExtCtrls, Graphics, Dialogs;

type
  TPotentio = class(TCustomControl)
  private
    fColorFirst:TColor;
    fColorSecond:TColor;
    fColorThird:TColor;
    fColorEmpty:TColor;  
    fBorderColor:TColor;
    fButtonColor:TColor;
    fStickColor:TColor; 	
    fMin : Integer;
    fMax : Integer;
    fPos:Integer;
    fDelta:double;
    fVisiblePosition : Boolean;
    fText : String;
    fOnChange: TNotifyEvent;
    Procedure Set_Min(Value:Integer);
    Procedure Set_Max(Value:Integer);
    Procedure Set_Pos(Value:Integer);
    Procedure Set_ButtonColor(Value:TColor);
    Procedure Set_StickColor(Value:TColor);
    Procedure Set_BorderColor(Value:TColor);
    Procedure Set_ColorFirst(Value:TColor);
    Procedure Set_ColorSecond(Value:TColor);
    Procedure Set_ColorThird(Value:TColor);
    Procedure Set_ColorEmpty(Value:TColor);
    Procedure Set_VisiblePosition(Value:Boolean);
    Procedure Set_Text(Value:String);
  protected
    procedure Change; virtual;  
    procedure Paint; override;
    Procedure Resize; Override;
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;  
  public
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
  published
    Property ButtonColor : TColor Read fButtonColor Write Set_ButtonColor;
    Property StickColor : TColor Read fStickColor Write Set_StickColor;
    Property BorderColor : TColor Read fBorderColor Write Set_BorderColor;
    Property ColorFirst:TColor Read fColorFirst Write Set_ColorFirst;
    Property ColorSecond:TColor Read fColorSecond Write Set_ColorSecond;
    Property ColorThird:TColor Read fColorThird Write Set_ColorThird;
    Property ColorEmpty:TColor Read fColorEmpty Write Set_ColorEmpty;
    Property VisiblePosition : Boolean Read fVisiblePosition Write Set_VisiblePosition;	
    Property Min : Integer Read fMin Write Set_Min Default 0;
    Property Max : Integer Read fMax Write Set_Max Default 100;
    Property Pos : Integer Read fPos Write Set_Pos Default 10;
    Property Text:String Read fText Write Set_Text;
    Property Color;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;    
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TPotentio]);
end;

constructor TPotentio.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  Parent := TWinControl(AOwner);
  doublebuffered  := True;
  fMin:=0;
  fMax:=100;
  fPos:=0;
  fButtonColor:=$002E2E2E;
  fBorderColor:=$004B4B4B;
  fStickColor:=ClWhite;
  Color:=clBtnFace;
  ColorFirst:=$009CE8F5;
  ColorSecond:=$001ACBEA;
  ColorThird:=$0013AECA;
  ColorEmpty:=$00F7F4F2;
end;

destructor TPotentio.Destroy;
begin
  inherited;
end;

Procedure TPotentio.Set_StickColor(Value:TColor);
Begin
  if fStickColor=Value then exit;
  fStickColor:=Value;
  Invalidate;
End;

Procedure TPotentio.Set_ButtonColor(Value:TColor);
Begin
  if fButtonColor=Value then exit;
  fButtonColor:=Value;
  Invalidate;
End;

Procedure TPotentio.Set_BorderColor(Value:TColor);
Begin
  if fBorderColor=Value then exit;
  fBorderColor:=Value;
  Invalidate;
End;

Procedure TPotentio.Set_ColorFirst(Value:TColor);
begin
  if fColorFirst=Value then exit;
  fColorFirst:=Value;
  Invalidate;
end;

Procedure TPotentio.Set_ColorSecond(Value:TColor);
begin
  if fColorSecond=Value then exit;
  fColorSecond:=Value;
  Invalidate;
end;

Procedure TPotentio.Set_ColorThird(Value:TColor);
begin
  if fColorThird=Value then exit;
  fColorThird:=Value;
  Invalidate;
end;

Procedure TPotentio.Set_ColorEmpty(Value:TColor);
begin
  if fColorEmpty=Value then exit;
  fColorEmpty:=Value;
  Invalidate;
end;

Procedure TPotentio.Resize;
Begin
  Self.Height:=Self.Width;
  Invalidate;
End;

Procedure TPotentio.Set_Min(Value:Integer);
Begin
  If (Value<fMax) and (Value<=fPos) Then
  fMin:=Value;
  fdelta:=(fMin-fPos)*(10*PI/6)/(fMax-fMin)+11*PI/6;
  Invalidate;
End;

Procedure TPotentio.Set_Max(Value:Integer);
Begin
  If (Value>fMin) and (Value>=fPos) Then
  fMax:=Value;
  fdelta:=(fMin-fPos)*(10*PI/6)/(fMax-fMin)+11*PI/6;
  Invalidate;
End;

Procedure TPotentio.Set_Pos(Value:Integer);
Begin
  fPos:=Value;
  If (Value<=fMin) Then fPos:=fMin;
  If (Value>=fMax) Then fPos:=FMax;
  fdelta:=(fMin-fPos)*(10*PI/6)/(fMax-fMin)+11*PI/6;
  Invalidate;
End;

Procedure TPotentio.Set_VisiblePosition(Value:Boolean);
Begin
  fVisiblePosition:=Value;
  Invalidate;
End;

Procedure TPotentio.Set_Text(Value:String);
Begin
  fText:=Value;
  Invalidate;
End;

Procedure TPotentio.Paint;
var
  Str:String;
  Rect:TRect;
  R,Teta:double;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;  
  IndexTeta,X1,Y1,X2,Y2,X3,Y3,X4,Y4,WidthText,HeightText:Integer;
begin
  with Self.Canvas Do
  begin
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
    Pen.Width:=0;    
    X1:=Width Div 10;
    Y1:=Height Div 10;
    X2:=9*Width Div 10;
    Y2:=9*Height Div 10;
    R:=4*Width Div 5;
    For IndexTeta:=1 To 10 Do
      Begin
        Teta:=(PI / 6)*IndexTeta;
        X3:=Round(R*Sin(Teta)+Width/2);
        Y3:=Round(R*Cos(Teta)+Height/2);
        X4:=Round(R*Sin(Teta+PI/6)+Width/2);
        Y4:=Round(R*Cos(Teta+PI/6)+Height/2);
        Pen.Color:=ClBlack;
        With Brush Do
          Begin
            If Teta<fDelta Then Color:=fColorEmpty
            Else
              Begin
                If (Teta>=8*PI/6) Then Color:=fColorFirst;
                If (Teta<8*PI/6) And (Teta>=3*PI/6) Then Color:=fColorSecond;
                If (Teta<=3*PI/6) Then Color:=fColorThird;
              End; 
          End;
        Pie(X1,Y1,X2,Y2,X3,Y3,X4,Y4);
      End;
    Brush.Color:=Color;
    With Rect Do
      Begin
        Left:=Width Div 6;
        Right:=5*Width Div 6;
        Top:=Height Div 6;
        Bottom:=5*Height Div 6;
      End;
    Ellipse(Rect);
    Brush.Color:=fBorderColor;
    With Rect Do
      Begin
        Left:=Width Div 5;
        Right:=4*Width Div 5;
        Top:=Height Div 5;
        Bottom:=4*Height Div 5;
      End;
    Ellipse(Rect);
    Brush.Color:=fButtonColor;
    With Rect Do
      Begin
        Left:=13*Width Div 50;
        Right:=37*Width Div 50;
        Top:=13*Height Div 50;
        Bottom:=37*Height Div 50;
      End;
    Ellipse(Rect);
    Pen.Color:=fStickColor;
    R:=10*Width Div 50;      
    MoveTo(Width Div 2, Height Div 2);
    LineTo(Round(R*Sin(fDelta)+Width / 2),Round(R*Cos(fDelta)+Height / 2));

    If VisiblePosition=True Then
      Begin
        Font.Name:='Small Fonts';
        Font.Color:=ClWhite;
        Font.Size:=6;
        Str:=fText+' '+IntToStr(fPos);
        Brush.Style:=BsClear;
        WidthText:=TextWidth(Str);
        HeightText:=TextHeight(Str);
        TextOut((Width- WidthText) Div 2 ,10*Height Div 11 - HeightText Div 2,Str);
      End;
  end;
end;

procedure TPotentio.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Begin
  Inherited;
  MouseMove(Shift,X,Y);
End;

procedure TPotentio.MouseMove(Shift: TShiftState; X,Y: Integer);
Var
 I : Extended;
Begin
  Inherited;
  If Shift=[SSLeft] Then
    Begin
      If Y<>Self.Height Div 2 Then
        Begin
          I:=(X-Self.Width Div 2)/(Y-Self.Height Div 2);
          fDelta:=ArcTan(I);
          If (Y<Height Div 2) Then fDelta:=FDelta+PI;
          If (X<Width Div 2) And (Y>Height Div 2) Then fDelta:=FDelta+2*PI;
          If Abs(fDelta)>=(11*PI/6) then fDelta:=(11*PI/6);
          If Abs(fDelta)<=(PI/6) then fDelta:=(PI/6);
          fPos:=Round(fMin-(fdelta-11*PI/6)*(fMax-fMin)/(10*PI/6));
          Invalidate;
        End;
    End;
End;

procedure TPotentio.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;


end.
