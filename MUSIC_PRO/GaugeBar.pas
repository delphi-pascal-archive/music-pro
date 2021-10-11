unit GaugeBar;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics;

type

  {>>TGaugeBar}
  TGaugeBar = class(TCustomControl)
  private
    fMin:Integer;
    fMax:Integer;
    fPos:Integer;
    fStickColor:TColor;
    fBackGroundColor:TColor;
    fFullColor:TColor;
    fText:String;
    fOnChange:TNotifyEvent;
    Procedure SetStickColor(Value:TColor);
    Procedure SetBackGroundColor(Value:TColor);
    Procedure SetFullColor(Value:TColor);
    Procedure SetMin(Value:Integer);
    Procedure SetMax(Value:Integer);
    Procedure SetPos(Value:Integer);
    Procedure SetText(Value:String);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    Procedure Resize; override;
  published
    Property StickColor:TColor Read fStickColor Write SetStickColor;
    Property BackGroundColor:TColor Read fBackGroundColor Write SetBackGroundColor;
    Property FullColor:TColor Read fFullColor Write SetFullColor;
    Property Color;
    Property Min:Integer Read fMin Write SetMin;
    Property Max:Integer Read fMax Write SetMax;
    Property Pos:Integer Read fPos Write SetPos;
    Property Text:String Read fText Write SetText;
    Property OnChange:TNotifyEvent Read fOnChange Write fOnChange;    
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
  end;
  
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TGaugeBar]);
end;


{>>TGaugeBar}
constructor TGaugeBar.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  fMin:=0;
  fMax:=100;
  fPos:=50;
  Width:=100;
  fStickColor:=ClRed;
  Color:=$00C08000;
  BackGroundColor:=$00C8D7DD;
  FullColor:=$00400080;
  fText:='Value';
end;

destructor TGaugeBar.Destroy;
begin
  inherited;
end;

Procedure TGaugeBar.SetMin(Value:Integer);
Begin
  If (Value<=fMax) And (Value<=fPos)  Then
    Begin
      fMin:=Value;
      Invalidate;
    End;
End;

Procedure TGaugeBar.SetMax(Value:Integer);
Begin
  If (Value>=fMin) And (Value>=fPos)  Then
    Begin
      fMax:=Value;
      Invalidate;
    End;
End;

Procedure TGaugeBar.SetPos(Value:Integer);
Begin
  If (Pos<>Value) And (Value>=fMin) And (Value<=fMax)  Then
    Begin
      fPos:=Value;
      Invalidate;
      If Assigned(fOnChange) Then fOnChange(Self);
    End;   
End;

Procedure TGaugeBar.SetStickColor(Value:TColor);
Begin
  fStickColor:=Value;
  Invalidate;
End;

Procedure TGaugeBar.SetBackGroundColor(Value:TColor);
Begin
  fBackGroundColor:=Value;
  Invalidate;
End;

Procedure TGaugeBar.SetFullColor(Value:TColor);
Begin
  fFullColor:=Value;
  Invalidate;
End;

Procedure TGaugeBar.SetText(Value:String);
Begin
  fText:=Value;
  Invalidate;
End;

Procedure TGaugeBar.Resize;
begin
  inherited;
  Height:=40;
end;


Procedure TGaugeBar.Paint;
Var
  LeftRect,StickRect,BackGroundRect:TRect;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;  
  WidthText,IndexLine:Integer;
  Str:String;
begin
  inherited;
  With Canvas Do
    Begin             
      Pen.Width:=4;
      UpperCorner[0]:=Point(Width,0);
      UpperCorner[1]:=Point(0,0);
      UpperCorner[2]:=Point(0,Height);
      LowerCorner[0]:=Point(0,Height);
      LowerCorner[1]:=Point(Width,Height);
      LowerCorner[2]:=Point(Width,0);
      Brush.Color:=ClWhite;
      Pen.Color:=ClWhite;
      Polyline(UpperCorner);
      Brush.Color:=$005F5F5F;
      Pen.Color:=$005F5F5F;
      Polyline(LowerCorner);
      Pen.Color:=ClBlack;
      Font.Size:=8;
      Str:=fText+' '+IntToStr(fPos);
      WidthText:=(Width-TextWidth(Str)) Div 2;
      Brush.Style:=BsClear;
      Font.Color:=ClWhite;
      TextOut(WidthText,26,Str);
      Pen.Width:=0;      
      With BackGroundRect Do
        Begin
          Left:=Width Div 10;
          Right:=9*Width Div 10;
          Top:=17;
          Bottom:=23;
          Brush.Color:=fBackGroundColor;
          Rectangle(BackGroundRect);
        End;
      With LeftRect Do
        Begin
          Left:=Width Div 10;
          Right:=Width Div 10+Round((8*Width Div 10)*(fPos-fMin) / (fMax-fMin));
          Top:=17;
          Bottom:=23;
          Brush.Color:=fFullColor;
          Rectangle(LeftRect);
        End;
      Brush.Color:=ClWhite;
      Pen.Color:=ClWhite;
      Pen.Width:=0;
      MoveTo(Width Div 10+1,20);
      LineTo(9*Width Div 10-1,20);
      With StickRect Do
        Begin
          Left:=Round(Width Div 10+(8*Width Div 10)*((fPos-fMin) / (fMax-fMin))-0.01*Width);
          Right:=Round(Width Div 10+(8*Width Div 10)*((fPos-fMin) / (fMax-fMin))+0.01*Width);
          If Left<=0 Then
            Begin
              Left:=0;
              Right:=Round(0.02*Width);
            End;
          If Right>=Width Then
            Begin
              Left:=Round(Width*0.98);
              Right:=Width;
            End;
          Top:=13;
          Bottom:=27;
          Brush.Color:=fStickColor;
          Pen.Color:=ClBlack;
          Pen.Width:=2;
          Rectangle(StickRect);
        End;
        Pen.Width:=0;
        Pen.Color:=ClBlack;
        For IndexLine:=0 To 10 Do
          Begin
            IF IndexLine>(Pos-Min)*10 Div (Max-Min) Then
            Pen.Color:=ClBlack Else Pen.Color:=ClLime;
            MoveTo((Width Div 10-1)+IndexLine*(8*Width Div 10) Div 10,10);
            LineTo((Width Div 10-1)+IndexLine*(8*Width Div 10) Div 10,7-IndexLine Div 2);
          End;
    End;
End;

Procedure TGaugeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer);
Var
  BnMax,BnMin : Integer;
begin
  inherited;
  If (Shift=[SSLeft]) Then
    Begin
      BnMin:=Round((8*Width Div 10)*((fPos-fMin) / (fMax-fMin))-0.01*Width)+Width Div 10;
      BnMax:=Round((8*Width Div 10)*((fPos-fMin) / (fMax-fMin))+0.01*Width)+Width Div 10;
      If (Shift=[SSLeft]) And (X>=BnMin) And (X<=BnMax) Then
      SetPos((X-Width Div 10)*(fMax-fMin) Div (8*Width Div 10)+fMin);
      Invalidate;
    End;
End;

procedure TGaugeBar.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
  If (Shift=[SSLeft]) Then
    Begin
      SetPos((X-Width Div 10)*(fMax-fMin) Div (8*Width Div 10)+fMin);
      Invalidate;
    End;
End;

End.  