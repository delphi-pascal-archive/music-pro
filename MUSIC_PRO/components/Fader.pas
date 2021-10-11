unit Fader;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs;

type
  TFader = class(TCustomControl)
  private
    fColorSlot:TColor;
    fColorLine:TColor;
    fColorTop:TColor;
    fColorBottom:TColor;
    fMin:Integer;
    fMax:Integer;
    fPos:Integer;
    fOnChange : TNotifyEvent;
    Procedure Set_ColorSlot(Value:TColor);
    Procedure Set_ColorLine(Value:TColor);
    Procedure Set_ColorTop(Value:TColor);
    Procedure Set_ColorBottom(Value:TColor);
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
    Property ColorSlot:TColor Read fColorSlot Write Set_ColorSlot;
    Property ColorLine:TColor Read fColorLine Write Set_ColorLine;
    Property ColorTop:TColor Read fColorTop Write Set_ColorTop;
    Property ColorBottom:TColor Read fColorBottom Write Set_ColorBottom;
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
  RegisterComponents('MUSIC_PRO', [TFader]);
end;

constructor TFader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  Width:=44;
  fMin:=-12;
  fMax:=12;
  fPos:=0;
  Color:=$00A3B4BE;
  ColorLine:=clWhite;
  ColorSlot:=clBlack;
  ColorBottom:=$00B5A293;
  ColorTop:=$00CDC0B6;
end;

destructor TFader.Destroy;
begin
  inherited;
end;

Procedure TFader.Set_ColorSlot(Value:TColor);
begin
  fColorSlot:=Value;
  Invalidate;
end;

Procedure TFader.Set_ColorLine(Value:TColor);
begin
  fColorLine:=Value;
  Invalidate;
end;

Procedure TFader.Set_ColorTop(Value:TColor);
begin
  fColorTop:=Value;
  Invalidate;
end;

Procedure TFader.Set_ColorBottom(Value:TColor);
begin
  fColorBottom:=Value;
  Invalidate;
end;

Procedure TFader.Set_Min(Value:Integer);
begin
  if (Value<=fPos) And (Value<fMax) Then
    Begin
      fMin:=Value;
      Invalidate;
    End;
end;

Procedure TFader.Set_Max(Value:Integer);
begin
  if (Value>=fPos) And (Value>fMin) Then
    Begin
      fMax:=Value;
      Invalidate;
    End;
end;

Procedure TFader.Set_Pos(Value:Integer);
begin
  if (Value>=fMin) And (Value<=fMax) Then
    Begin
      fPos:=Value;
      Invalidate;
    End;
end;

procedure TFader.Resize;
Begin
  InHerited;
  Width:=(Width Div 2)*2;
  If Width<50 Then Width:=50;
  Height:=6*Width;
End;  

procedure TFader.Paint;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  SlotRect,BottomRect,TopRect, PanelRect:TRect;
  WidthSlot, HeightSlot,HeightText, DelimTop,DelimBottom, IndexLine:Integer;
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
      WidthSlot:=Width Div 8;
      HeightSlot:=8*Height Div 10;

      Pen.Color:=fColorSlot;
      Brush.Color:=fColorSlot;
      With SlotRect Do
        Begin
          Left:=(Width-WidthSlot) Div 2;
          Right:=Left+WidthSlot;
          Top:=(Height-HeightSlot) Div 2;
          Bottom:=Top+HeightSlot;
        End;
      Rectangle(SlotRect);

      Pen.Color:=fColorLine;
      Brush.Color:=fColorLine;
      Brush.Style:=BsClear;
      Font.Name:='Small Fonts';
      Font.Size:=Width Div 10;
      Font.Color:=ClWhite;
      For IndexLine:=0 To 4 Do
        Begin
          MoveTo(SlotRect.Left Div 2,Height Div 10 + HeightSlot*IndexLine Div 4);
          LineTo(SlotRect.Left,Height Div 10 + HeightSlot*IndexLine Div 4);
          ValueStr:=format('%.1f', [fMax-(fMax-fMin)*IndexLine / 4]);
          HeightText:=TextHeight(ValueStr);
          TextOut(2*Width Div 3,Height Div 10 + HeightSlot*IndexLine Div 4 - HeightText Div 2,ValueStr);
        End;
      MoveTo(SlotRect.Left Div 2,SlotRect.Top);
      LineTo(SlotRect.Left Div 2,SlotRect.Bottom);
        
      DelimTop:=Height Div 10;
      DelimBottom:=9*Height Div 10;
      With TopRect Do
        Begin
          Left:=Width Div 3;
          Right:=2*Width Div 3;
          Bottom:=Round(DelimBottom-(fMin-fPos)*(DelimBottom-DelimTop)/(fMin-fMax));
          Top:=Bottom-2*DelimTop Div 3;
        End;
      Brush.Color:=fColorTop;
      Pen.Color:=fColorTop;
      Rectangle(TopRect);

      With BottomRect Do
        Begin
          Left:=Width Div 3;
          Right:=2*Width Div 3;
          Top:=Round(DelimBottom-(fMin-fPos)*(DelimBottom-DelimTop)/(fMin-fMax));
          Bottom:=Top+2*DelimTop Div 3;
        End;
      Brush.Color:=fColorBottom;
      Pen.Color:=fColorBottom;
      Rectangle(BottomRect);

      Brush.Color:=fColorLine;
      Pen.Color:=fColorLine;
      MoveTo(TopRect.Left,TopRect.Bottom);
      LineTo(TopRect.Right,TopRect.Bottom);

      With BottomRect Do
      For IndexLine:=1 To 2 Do
        Begin
          Brush.Color:=fColorLine;
          Pen.Color:=fColorLine;
          MoveTo(TopRect.Left,Top+(Bottom-Top)*IndexLine Div 3);
          LineTo(TopRect.Right,Top+(Bottom-Top)*IndexLine Div 3);
          Brush.Color:=$00657271;
          Pen.Color:=$00657271;
          MoveTo(TopRect.Left,Top+(Bottom-Top)*IndexLine Div 3+1);
          LineTo(TopRect.Right,Top+(Bottom-Top)*IndexLine Div 3+1);
        End;

      UpperCorner[0]:=Point(TopRect.Right,TopRect.Top);
      UpperCorner[1]:=Point(TopRect.Left,TopRect.Top);
      UpperCorner[2]:=Point(TopRect.Left,BottomRect.Bottom);
      LowerCorner[0]:=Point(TopRect.Left,BottomRect.Bottom);
      LowerCorner[1]:=Point(BottomRect.Right,BottomRect.Bottom);
      LowerCorner[2]:=Point(BottomRect.Right,TopRect.Top);
      Pen.Color:=ClWhite;
      Polyline(UpperCorner);
      Pen.Color:=$00657271;
      Polyline(LowerCorner);   
    End;
End;


procedure TFader.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If SSLeft In Shift Then  
  MouseMove(Shift, X, Y);
End;

procedure TFader.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
  DelimTop,DelimBottom:Integer;
Begin
  InHerited;
  If SSLeft In Shift Then
  Begin
    DelimTop:=Height Div 10;
    DelimBottom:=9*Height Div 10;
    fPos:=Round(fMin-(DelimBottom-Y)*(fMin-fMax)/(DelimBottom-DelimTop));
    If fPos>fMax Then fPos:=fMax;
    if fPos<fMin Then fPos:=fMin;
    Invalidate;
    If Assigned(fOnChange) Then fOnChange(Self);
  End;  
End;

end.
