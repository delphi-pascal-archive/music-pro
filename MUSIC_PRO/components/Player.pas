unit Player;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs;

type

 TTypeAction=(Play,Stop,Pause,FF,RW);

  {>>TCstButton}
  TCstButton = class(TCustomControl)
  private
    fColorBorder:TColor;
    fColorButton:TColor;
    fColorOn:TColor;
    fColorOff:TColor;
    fClicked:Boolean;
    fAction:TTypeAction;
    Procedure SetColor_Border(Value:TColor);
    Procedure SetColor_Button(Value:TColor);
    Procedure SetColor_On(Value:TColor);
    Procedure SetColor_Off(Value:TColor);
    Procedure DrawType(Action:TTypeAction);
    Function Fade_To_Black(Color:TColor):TColor;
    Function Fade_To_White(Color:TColor):TColor;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Color;
    Property ColorBorder:TColor Read fColorBorder Write SetColor_Border;
    Property ColorButton:TColor Read fColorButton Write SetColor_Button;
    Property ColorOn:TColor Read fColorOn Write SetColor_On;
    Property ColorOff:TColor Read fColorOff Write SetColor_Off;
    Property Tag;
    Property Enabled;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;
    Property OnDblClick;
  end;

  {>>TPlayer}
  TPlayer = class(TCustomControl)
  private
    fColorBorder:TColor;
    fColorButton:TColor;
    fColorOn:TColor;
    fColorOff:TColor;
    fTime:TTime;
    fCstButtons:Array[0..4] Of TCstButton;
    Procedure SetColor_Border(Value:TColor);
    Procedure SetColor_Button(Value:TColor);
    Procedure SetColor_On(Value:TColor);
    Procedure SetColor_Off(Value:TColor);
    Procedure Set_Time(Value:TTime);
  protected
    function GetButton(index: integer): TCstButton;
    procedure SetButton(index: integer; value: TCstButton);
    Procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property RWButton     :TCstButton index 0 Read GetButton write SetButton;
    Property PauseButton  :TCstButton index 1 Read GetButton write SetButton;
    Property StopButton   :TCstButton index 2 Read GetButton write SetButton;
    Property PlayButton   :TCstButton index 3 Read GetButton write SetButton;
    Property FFButton     :TCstButton index 4 Read GetButton write SetButton;
    Property Color;
    Property ColorBorder:TColor Read fColorBorder Write SetColor_Border;
    Property ColorButton:TColor Read fColorButton Write SetColor_Button;
    Property ColorOn:TColor Read fColorOn Write SetColor_On;
    Property ColorOff:TColor Read fColorOff Write SetColor_Off;
    Property Time:TTime Read fTime Write Set_Time;
    Property Tag;
    Property Enabled;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;
    Property OnDblClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TPlayer]);
end;


{>>CstButton}
constructor TCstButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fClicked:=False;        
end;

destructor TCstButton.Destroy;
begin
  inherited;
end;

Procedure TCstButton.SetColor_Border(Value:TColor);
begin
  fColorBorder:=Value;
  Invalidate;
end;

Procedure TCstButton.SetColor_Button(Value:TColor);
begin
  Self.fColorButton:=Value;
  Self.Invalidate;
end;

Procedure TCstButton.SetColor_On(Value:TColor);
begin
  fColorOn:=Value;
  Invalidate;
end;

Procedure TCstButton.SetColor_Off(Value:TColor);
begin
  fColorOff:=Value;
  Invalidate;
end;

Function TCstButton.Fade_To_Black(Color:TColor):TColor;
var
  R, G, B : Byte;
Begin
  R:=GetRValue(ColorToRGB(Color));  R:=R*95 Div 100;
  G:=GetRValue(ColorToRGB(Color));  G:=G*95 Div 100;
  B:=GetRValue(ColorToRGB(Color));  B:=B*95 Div 100;
  Result:=RGB(R,G,B);
End;

Function TCstButton.Fade_To_White(Color:TColor):TColor;
var
  R, G, B : Byte;
Begin
  R:=GetRValue(ColorToRGB(Color));  R:=R*105 Div 100;
  G:=GetRValue(ColorToRGB(Color));  G:=G*105 Div 100;
  B:=GetRValue(ColorToRGB(Color));  B:=B*105 Div 100;
  Result:=RGB(R,G,B);
End;
     
procedure TCstButton.Paint;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  Rect:TRect;
Begin
  InHerited;
  With Canvas Do
    Begin
      Pen.Width:=2;
      UpperCorner[0]:=Point(9*Width Div 10,Height Div 10);
      UpperCorner[1]:=Point(Width Div 10,Height Div 10);
      UpperCorner[2]:=Point(Width Div 10,9*Height Div 10);
      LowerCorner[0]:=Point(Width Div 10,9*Height Div 10);
      LowerCorner[1]:=Point(9*Width Div 10,9*Height Div 10);
      LowerCorner[2]:=Point(9*Width Div 10,Height Div 10);
      Brush.Color:=Fade_To_White(fColorBorder);
      Pen.Color:=Fade_To_White(fColorBorder);
      Polyline(UpperCorner);
      Brush.Color:=Fade_To_Black(fColorBorder);
      Pen.Color:=Fade_To_Black(fColorBorder);
      Polyline(LowerCorner);
      With Rect Do
        Begin
          Left:=2*Width Div 10;
          Right:=8*Width Div 10;
          Top:=2*Height Div 10;
          Bottom:=8*Height Div 10;
          Brush.Color:=fColorButton;
          Pen.Color:=ColorButton;
          Rectangle(Rect);
        End;
      UpperCorner[0]:=Point(8*Width Div 10,2*Height Div 10);
      UpperCorner[1]:=Point(2*Width Div 10,2*Height Div 10);
      UpperCorner[2]:=Point(2*Width Div 10,8*Height Div 10);
      LowerCorner[0]:=Point(2*Width Div 10,8*Height Div 10);
      LowerCorner[1]:=Point(8*Width Div 10,8*Height Div 10);
      LowerCorner[2]:=Point(8*Width Div 10,2*Height Div 10);
      Pen.Width:=0;
      Brush.Color:=$005C5C5C;
      Pen.Color:=$005C5C5C;
      Polyline(UpperCorner);
      Brush.Color:=ClWhite;
      Pen.Color:=ClWhite;
      Polyline(LowerCorner);
      DrawType(fAction);
    End;   
End;

Procedure TCstButton.DrawType(Action:TTypeAction);
Var
  Rect:TRect;
  ColorUsed:TColor;
  Triangular:Array [0..2] Of TPoint;
Begin
  With Canvas Do
    Begin
      If Not fClicked Then ColorUsed:=fColorOff
      Else ColorUsed:=fColorOn;
      Brush.Color:=ColorUsed;
      Pen.Color:=ColorUsed;
      Case Action Of
        Stop : With Rect Do
                 Begin
                   Left:=3*Width Div 10;
                   Right:=7*Width Div 10+Pen.Width;
                   Top:=3*Height Div 10;
                   Bottom:=7*Height Div 10+Pen.Width;
                   Rectangle(Rect);
                 End;
        Pause : With Rect Do
                 Begin
                   Left:=3*Width Div 10;
                   Right:=Round(4.5*Width / 10);
                   Top:=3*Height Div 10;
                   Bottom:=7*Height Div 10;
                   Rectangle(Rect);
                   Left:=Round(5.5*Width / 10);
                   Right:=7*Width Div 10;
                   Top:=3*Height Div 10;
                   Bottom:=7*Height Div 10;
                   Rectangle(Rect);
                 End;
        Play :  Begin
                  Triangular[0]:=Point(3*Width Div 10,3*Height Div 10);
                  Triangular[1]:=Point(3*Width Div 10,7*Height Div 10);
                  Triangular[2]:=Point(7*Width Div 10,5*Height Div 10);
                  Polygon(Triangular);
                End;
        FF :  Begin
                  Triangular[0]:=Point(3*Width Div 10,3*Height Div 10);
                  Triangular[1]:=Point(3*Width Div 10,7*Height Div 10);
                  Triangular[2]:=Point(Round(4.5*Width / 10),5*Height Div 10);
                  Polygon(Triangular);
                  Triangular[0]:=Point(Round(5.5*Width / 10),3*Height Div 10);
                  Triangular[1]:=Point(Round(5.5*Width / 10),7*Height Div 10);
                  Triangular[2]:=Point(7*Width Div 10,5*Height Div 10);
                  Polygon(Triangular);
                End;
        RW :  Begin
                  Triangular[0]:=Point(Round(4.5*Width / 10),3*Height Div 10);
                  Triangular[1]:=Point(Round(4.5*Width / 10),7*Height Div 10);
                  Triangular[2]:=Point(3*Width Div 10,5*Height Div 10);
                  Polygon(Triangular);
                  Triangular[0]:=Point(7*Width Div 10,3*Height Div 10);
                  Triangular[1]:=Point(7*Width Div 10,7*Height Div 10);
                  Triangular[2]:=Point(Round(5.5*Width / 10),5*Height Div 10);
                  Polygon(Triangular);
                End;
      End;
    End;
End;

procedure TCstButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Var
  IndexButton:Integer;
Begin
  InHerited;
  If Shift=[SSLeft] Then
    Begin
      With (Parent As TPlayer) Do
      For IndexButton:=0 To 4 Do
        Begin
          If GetButton(IndexButton)<>Self Then GetButton(IndexButton).fClicked:=False
          Else
            Begin
              If fAction<>Pause Then fClicked:=True
              Else fClicked:=Not fClicked;
            End;
          GetButton(IndexButton).Invalidate;
        End;
    End;
End;

{>>TPlayer}   
constructor TPlayer.Create(AOwner: TComponent);
Const
  NameButton:Array [0..4] Of String =
  ('RWBt','PauseBt','StopBt','PlayBt','FFBt');
  ActionButton:Array [0..4] Of TTypeAction =
  (RW,Pause,Stop,Play,FF);
Var
  IndexButton:Integer;
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  fTime:=0;
  Color:=$00C08000;
  fColorBorder:=clBlack;
  fColorButton:=$00C08000;
  fColorOff:=clSilver;
  fColorOn:=$0034C7CB;
  For IndexButton:=0 To 4 Do
    Begin
      fCstButtons[indexButton]:=TCstButton.Create(Self);
      With fCstButtons[indexButton] Do
        Begin
          Parent:=Self;
          Name:=NameButton[IndexButton];
          Width:=40;
          Height:=30;
          Left:=5+40*IndexButton;
          Top:=5;
          SetSubComponent(True);
          fAction:=ActionButton[IndexButton];
        End;
    End;
end;

destructor TPlayer.Destroy;
Var
  IndexButton:Integer;
begin
  For IndexButton:=0 To 4 Do
  fCstButtons[indexButton].Free;
  inherited;  
end;

Procedure TPlayer.SetColor_Border(Value:TColor);
begin
  fColorBorder:=Value;
  Invalidate;
end;

Procedure TPlayer.SetColor_Button(Value:TColor);
begin
  Self.fColorButton:=Value;
  Self.Invalidate;
end;

Procedure TPlayer.SetColor_On(Value:TColor);
begin
  fColorOn:=Value;
  Invalidate;
end;

Procedure TPlayer.SetColor_Off(Value:TColor);
begin
  fColorOff:=Value;
  Invalidate;
end;

Procedure TPlayer.Set_Time(Value:TTime);
Begin
  If fTime<>Value Then
    Begin
      fTime:=Value;
      Invalidate;
    End;
End;      

function TPlayer.GetButton(index: integer): TCstButton;
begin
  result := fCstButtons[index];
end;

procedure TPlayer.SetButton(index: integer; value: TCstButton);
begin
  if fCstButtons[index] <> value then
  fCstButtons[index] := value;
end;

Procedure TPlayer.Paint;
Var
  IndexButton, TopText:Integer;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  Str:String;
Begin
  InHerited;
  With Canvas Do
    Begin
      Pen.Width:=4;
      UpperCorner
      [0]:=Point(Width,0);
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
      Brush.Color:=ClBlack;
      Pen.Color:=ClBlack;
      Font.Color:=ClRed;
      Font.Size:=14;
      Str:=FormatDateTime('nn:ss:zzzz',fTime);
      TopText:=(Height-TextHeight(Str)) Div 2;
      TextOut(210,TopText,Str);
    End;
  For IndexButton:=0 To 4 Do
  With fCstButtons[IndexButton] Do
    Begin
      fColorBorder:=Self.fColorBorder;
      fColorButton:=Self.fColorButton;
      fColorOn:=Self.fColorOn;
      fColorOff:=Self.fColorOff;
    End;
End;

procedure TPlayer.Resize;
Begin
  InHerited;
  Height:=40;
  Width:=300;
End;
end.
