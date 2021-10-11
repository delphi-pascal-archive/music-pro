unit EqualizerControl;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, Controls, Graphics, Math,Dialogs;

type

  {>>TGaugeBar}
  TGaugeBar = class(TCustomControl)
  private
    fMin:Integer;
    fMax:Integer;
    fParams  : array[0..3] of Integer;
    fStickColor:TColor;
    fBackGroundColor:TColor;
    fFullColor:TColor;
    fOnChange: TNotifyEvent;    
    Procedure SetStickColor(Value:TColor);
    Procedure SetBackGroundColor(Value:TColor);
    Procedure SetFullColor(Value:TColor);
    Procedure SetMin(Value:Integer);
    Procedure SetMax(Value:Integer);
    Procedure SetGain(Value:Integer);
  protected
    procedure Change; virtual;  
  public
    function  GetParam(index: integer): Integer;
    procedure SetParam(index: integer; value: Integer);
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
    Property Bandwidth:Integer index 0 Read GetParam write SetParam;
    Property Q:Integer index 1 Read GetParam write SetParam;
    Property Gain:Integer index 2 Read GetParam write SetParam;
    Property Center:Integer index 3 Read GetParam write SetParam;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

  {>>TBrowserButton}
  TBrowserButton = class(TGraphicControl)
  private
    fColorLine:TColor; 
    fColorTop:TColor;
    fColorBottom:TColor;
    fClicked:Boolean;
    fCaption:String;
    Procedure SetColorLine(Value:TColor);
    Procedure SetColorTop(Value:TColor);
    Procedure SetColorBottom(Value:TColor);
    Procedure SetCaption(Value:String);
    Procedure DrawBorder;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;     
  public
    Index:Cardinal;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property ColorLine:TColor Read fColorLine Write SetColorLine;
    Property ColorTop:TColor Read fColorTop Write SetColorTop;
    Property ColorBottom:TColor Read fColorBottom Write SetColorBottom;
    Property Tag;
    Property Enabled;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;	
    Property OnDblClick;
    Property Caption : String Read fCaption Write SetCaption;
    Property Font; 
  end;

  {>>TRoundButton}
  TRoundButton = class(TCustomControl)
  private
    fBorderColor: TColor;
    fStickColor: TColor;
    fValuesColor: TColor;
    fMin:   integer;
    fMax:   integer;
    fPos:   integer;
    fVisiblePosition: boolean;
    fTitle:String;
    fOnChange: TNotifyEvent;       
    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetPos(Value: integer);
    procedure SetStickColor(Value: TColor);
    procedure SetBorderColor(Value: TColor);
    procedure SetVisiblePosition(Value: boolean);
    procedure SetValuesColor(Value: TColor);
    Procedure SetTitle(Value:String);
  protected
    procedure Change; virtual;
  public
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property StickColor: TColor Read fStickColor Write SetStickColor;
    property BorderColor: TColor Read fBorderColor Write SetBorderColor;
    property ValuesColor: TColor Read fValuesColor Write SetValuesColor;
    property VisiblePosition: boolean Read fVisiblePosition Write SetVisiblePosition;
    property Title:String Read fTitle Write SetTitle;
    property Min: integer Read fMin Write SetMin default 0;
    property Max: integer Read fMax Write SetMax default 100;
    property Pos: integer Read fPos Write SetPos default 10;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property Color;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

  {>>TEqualizerControl}
  TEqualizerControl = class(TCustomControl)
  private
    fGauges:Array[0..9] Of TGaugeBar;
    fButtons:Array[0..5] Of TBrowserButton;
    fBkGnColor:TColor;
    fGaugeSelected:Integer;
    fBandwidthButton:TRoundButton;
    fQButton:TRoundButton;
    Procedure ClickButton(Sender:TObject);
    Procedure Create_Gauge(Var AGaugeBar:TGaugeBar;AName:String;ALeft,AGain,ACenter,ABandWidth,AQ:Integer);
    Procedure Create_Buttons(Var AButton:TBrowserButton;AName,ACaption:String;ALeft,ATop:Cardinal);
    Procedure Create_RoundButtons(Var AButton:TRoundButton;AName,ATitle:String;AMin,AMax,ALeft,ATop:Cardinal);
    Procedure SetBkGnColor(Value:TColor);
    Procedure SetGaugeSelected(Value:Integer);
  protected
    { Déclarations protégées }
  public
    Property GaugeSelected:Integer Read fGaugeSelected Write SetGaugeSelected;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Procedure Paint; override;
    Procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer); override;
    function GetGauges(index: integer): TGaugeBar;
    procedure SetGauges(index: integer; value: TGaugeBar);
  published
    Property Color;
    Property BkGnColor:TColor Read fBkGnColor Write SetBkGnColor;
    Property Band_0 : TGaugeBar index 0 Read GetGauges write SetGauges;
    Property Band_1 : TGaugeBar index 1 Read GetGauges write SetGauges;
    Property Band_2 : TGaugeBar index 2 Read GetGauges write SetGauges;
    Property Band_3 : TGaugeBar index 3 Read GetGauges write SetGauges;
    Property Band_4 : TGaugeBar index 4 Read GetGauges write SetGauges;
    Property Band_5 : TGaugeBar index 5 Read GetGauges write SetGauges;
    Property Band_6 : TGaugeBar index 6 Read GetGauges write SetGauges;
    Property Band_7 : TGaugeBar index 7 Read GetGauges write SetGauges;
    Property Band_8 : TGaugeBar index 8 Read GetGauges write SetGauges;
    Property Band_9 : TGaugeBar index 9 Read GetGauges write SetGauges;
    Property ButtonBandwidth:TRoundButton Read fBandwidthButton Write fBandwidthButton;
    Property ButtonQ:TRoundButton Read fQButton Write fQButton;
    Property OnMouseDown;
  end;

Const
  DefaultsEqualizerControl : Array [0..5] Of String=('Funk','Dance','Rock','Hard','Overhead','Voix');

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TEqualizerControl]);
end;

{>>TGaugeBar}
constructor TGaugeBar.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  fMin:=-15;
  fMax:=15;
  Gain:=0;
  Bandwidth:=1;
  Q:=0;
  Center:=1;
  Height:=100;
  fStickColor:=ClRed;
  Color:=$00A79AA0;
  BackGroundColor:=$00C8D7DD;
  FullColor:=$00400080;
end;

destructor TGaugeBar.Destroy;
begin
  inherited;
end;

Procedure TGaugeBar.SetMin(Value:Integer);
Begin
  If (Value<fMax) And (Value<=Gain)  Then
    Begin
      fMin:=Value;
      Invalidate;
    End;
End;

Procedure TGaugeBar.SetMax(Value:Integer);
Begin
  If (Value>fMin) And (Value>=Gain)  Then
    Begin
      fMax:=Value;
      Invalidate;
    End;
End;

Procedure TGaugeBar.SetGain(Value:Integer);
Begin
  If (Value>=fMin) And (Value<=fMax)  Then
    Begin
      Gain:=Value;
      Invalidate;
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

Procedure TGaugeBar.Resize;
begin
  inherited;
  Width:=20;
end;

Procedure TGaugeBar.Paint;
Var
  LeftRect,StickRect,BackGroundRect:TRect;
  WidthText,RelHeight:Integer;
  Str:String;
begin
  inherited;
  With Canvas Do
    Begin
      RelHeight:=Round(Height*0.85);
      Font.Size:=8;
      Pen.Width:=2;
      Font.Color:=ClWhite;
      Str:=IntToStr(Gain);
      WidthText:=(Width-TextWidth(Str)) Div 2;
      Brush.Style:=BsClear;
      TextOut(WidthText,RElHeight,Str);
      With BackGroundRect Do
        Begin
          Left:=6;
          Right:=14;
          Top:=0;
          Bottom:=RelHeight;
          Brush.Color:=fBackGroundColor;
          Rectangle(BackGroundRect);
        End;
      With LeftRect Do
        Begin
          Left:=6;
          Right:=14;
          Top:=(Gain-fMax)*RelHeight Div (fMin-fMax);
          Bottom:=RelHeight;
          Brush.Color:=fFullColor;
          Rectangle(LeftRect);
        End;
      Brush.Color:=ClWhite;
      Pen.Color:=ClWhite;
      Pen.Width:=0;
      MoveTo(9,4);
      LineTo(9,RelHeight-4);
      With StickRect Do
        Begin
          Top:=Round((Gain-fMax)*RelHeight Div (fMin-fMax)+0.01*RelHeight);
          Bottom:=Round((Gain-fMax)*RelHeight Div (fMin-fMax)-0.01*RelHeight);
          If Top<=0 Then
            Begin
              Top:=0;
              Bottom:=Round(0.02*RelHeight);
            End;
          If Bottom>=Height Then
            Begin
              Top:=Round(RelHeight*0.98);
              Bottom:=RelHeight;
            End; 
          Left:=2;
          Right:=18;
          Brush.Color:=fStickColor;
          Pen.Color:=ClBlack;
          Pen.Width:=2;
          Rectangle(StickRect);
        End;
    End;
End;

Procedure TGaugeBar.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer);
begin
  inherited;
  If (Shift=[SSLeft]) Then
  MouseMove(Shift,X,Y);
End;

procedure TGaugeBar.MouseMove(Shift: TShiftState; X, Y: integer);
Var
  BnMax,BnMin,RelHeight : Integer;
begin
  inherited;
  If (Shift=[SSLeft]) Then
    Begin
      RelHeight:=Round(Height*0.85);
      BnMin:=Round(RelHeight*((Gain-fMax) / (fMin-fMax))-0.1*RelHeight);
      BnMax:=Round(RelHeight*((Gain-fMax) / (fMin-fMax))+0.1*RelHeight);
      If (Shift=[SSLeft]) And (Y>=BnMin) And (Y<=BnMax) Then
      SetGain(Y*(fMin-fMax) Div RelHeight+fMax);
      Invalidate;
      Change;
    End;
End;

procedure TGaugeBar.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TGaugeBar.GetParam(index: integer): Integer;
begin
  result := fParams[index];
end;

procedure TGaugeBar.SetParam(index: integer; value: Integer);
begin
  if fParams[index] <> value then
  begin
    fParams[index] := value;
    change;
  end;
end;

{>>TBrowserButton}
constructor TBrowserButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorBottom:=$00A6A6A6;
  fColorTop:=$00DADADA;
  fColorLine:=$0097D5C0;
  fClicked:=False;
end;

destructor TBrowserButton.Destroy;
begin
  inherited;
end;

Procedure TBrowserButton.SetColorLine(Value:TColor);
begin
  fColorLine:=Value;
  Invalidate;
end;

Procedure TBrowserButton.SetColorTop(Value:TColor);
begin
  fColorTop:=Value;
  Invalidate;
end;

Procedure TBrowserButton.SetColorBottom(Value:TColor);
begin
  fColorBottom:=Value;
  Invalidate;
end;

Procedure TBrowserButton.SetCaption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

procedure TBrowserButton.Paint;
Var
  RectTop,RectBottom : TRect;
  HeightCaption, WidthCaption:Integer;
Begin
  InHerited;
  DrawBorder;
  With Canvas Do
    Begin
      Font:=Self.Font;
      With RectTop Do
	Begin
	  Top:=6;
	  Bottom:=Height Div 2 ;
	  Left:=6;
	  Right:=Width-6;
	  Brush.Color:=fColorTop;
          Pen.Color:=fColorTop;
	  Rectangle(RectTop);
	End;
      With RectBottom Do
	Begin
	  Top:=Height Div 2;
	  Bottom:=Height-6;
	  Left:=6;
	  Right:=Width-6;
	  Brush.Color:=fColorBottom;
          Pen.Color:=fColorBottom;
	  Rectangle(RectBottom );
	End;
      Brush.Color:=fColorLine;
      Pen.Color:=fColorLine;
      Pen.Width:=2;
      MoveTo(5,Height Div 2);
      LineTo(Width-7,Height Div 2);
      HeightCaption:=Canvas.TextHeight(Caption);
      WidthCaption:=Canvas.TextWidth(Caption);
      Brush.Style:=BsClear;
      TextOut((Width - WidthCaption) Div 2,(Height - HeightCaption) Div 2,Caption);
    End;
End;

Procedure TBrowserButton.DrawBorder;
Var
  LeftColor, RightColor:TColor;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
Begin
  If (fClicked) Or (Not Enabled) Then
    Begin
      LeftColor:=$00657271;
      RightColor:=ClWhite;
    End
  Else
    Begin
      LeftColor:=ClWhite;
      RightColor:=$00657271;
    End;
  With Self.Canvas Do
    Begin
      Pen.Width:=2;
      UpperCorner[0]:=Point(Pen.Width,Height-Pen.Width);
      UpperCorner[1]:=Point(Pen.Width,Pen.Width);
      UpperCorner[2]:=Point(Width-Pen.Width,Pen.Width);
      LowerCorner[0]:=Point(Pen.Width,Height-Pen.Width);
      LowerCorner[1]:=Point(Width-Pen.Width,Height-Pen.Width);
      LowerCorner[2]:=Point(Width-Pen.Width,Pen.Width);
      Brush.Color:=LeftColor;
      Pen.Color:=LeftColor;
      Polyline(UpperCorner);
      Brush.Color:=RightColor;
      Pen.Color:=RightColor;
      Polyline(LowerCorner);
    End;   
End;

procedure TBrowserButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  MouseUp(Button,Shift,X,Y);
End;

procedure TBrowserButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
   fClicked:=Not fClicked;
   Invalidate;
End;

{>>TRoundButton}

constructor TRoundButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fMin := 0;
  fMax := 50;
  fPos := 0;
  fBorderColor := $004B4B4B;
  fStickColor := ClWhite;
  Doublebuffered := True;
end;

destructor TRoundButton.Destroy;
begin
  inherited;
end;

procedure TRoundButton.SetStickColor(Value: TColor);
begin
  if fStickColor = Value then  exit;
  fStickColor := Value;
  Invalidate;
end;

procedure TRoundButton.SetBorderColor(Value: TColor);
begin
  fBorderColor := Value;
  Invalidate;
end;

procedure TRoundButton.SetValuesColor(Value: TColor);
begin
  fValuesColor := Value;
  Invalidate;
end;

procedure TRoundButton.Resize;
begin
  if Width <= 50 then Width := 50;
  Height := Width;
  Invalidate;
end;

procedure TRoundButton.SetMin(Value: integer);
begin
  If (Value<fMax) and (Value<=fPos) Then
  fMin:=Value;
  Invalidate;
end;

procedure TRoundButton.SetMax(Value: integer);
begin
  If (Value>fMin) and (Value>=fPos) Then
  fMax:=Value;
  Invalidate;
end;

procedure TRoundButton.SetPos(Value: integer);
begin
  If (Value<=fMin) Then fPos:=fMin;
  If (Value>=fMax) Then fPos:=FMax;
  fPos:=Value;
  Invalidate;
end;

procedure TRoundButton.SetVisiblePosition(Value: boolean);
begin
  fVisiblePosition := Value;
  Invalidate;
end;

Procedure  TRoundButton.SetTitle(Value:String);
begin
  fTitle := Value;
  Invalidate;
end;

procedure TRoundButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  if Shift = [SSLeft] then
  MouseMove(Shift,X,Y);
end;

procedure TRoundButton.MouseMove(Shift: TShiftState; X, Y: integer);
var
  I: extended;
  fDelta: extended;
begin
  inherited;
  if Shift = [SSLeft] then
  begin
    If Y<>Height Div 2 Then
      Begin
        I:=(X-Width Div 2)/(Y-Height Div 2);
        fDelta:=ArcTan(I);
        If (Y<Height Div 2) Then fDelta:=FDelta+PI;
        If (X<Width Div 2) And (Y>Height Div 2) Then fDelta:=FDelta+2*PI;
        If Abs(fDelta)>=(11*PI/6) then fDelta:=(11*PI/6);
        If Abs(fDelta)<=(PI/6) then fDelta:=(PI/6);
        fPos:=Round(fMin-(fdelta-11*PI/6)*(fMax-fMin)/(10*PI/6));
        Invalidate;
      End;
      With Parent As TEqualizerControl Do
      If GaugeSelected>=0 Then      
        Begin
          fGauges[GaugeSelected].Bandwidth:=fBandwidthButton.fPos;
          fGauges[GaugeSelected].Q:=fQButton.fPos;
          fGauges[GaugeSelected].Change;
        End;
  end;
end;


procedure TRoundButton.Change;
begin
  if Assigned(fOnChange) then fOnChange(Self);
  With (Parent As TEqualizerControl) Do
    Begin
      If fGaugeSelected>=0 Then
      With fGauges[fGaugeSelected] Do
      if Assigned(fOnChange) then fOnChange(fGauges[fGaugeSelected]);
    End;  
end;

procedure TRoundButton.Paint;
var
  R,fDelta:    extended;
  WidthText, HeightText: integer;
  Rect: TRect;
begin
  if not assigned(Parent) then
    exit;
  with Canvas do
  begin
    Brush.Color := fBorderColor;
    Brush.Style := bsSolid;
    Pen.Color   := ClBlack;
    Pen.Width   := 1;
    with Rect do
    begin
      Left   := Round(0.25 *Width);
      Right  := Round(0.75 * Width);
      Top    := Round(0.25 * Width);
      Bottom := Round(0.75 *Width);
    end;
    Ellipse(Rect);
    Brush.Color := fStickColor;
    Pen.Color := Brush.Color;
    Pen.Width := 4;
    R := (3 * Width div 14);
    fdelta:=(fMin-fPos)*(10*PI/6)/(fMax-fMin)+11*PI/6;
    with Rect do
      begin
        MoveTo(Width Div 2, Height Div 2);
        LineTo(Round(R*Sin(fDelta)+Width / 2),Round(R*Cos(fDelta)+Height / 2));
      end;
    Font.Size := Width div 7;
    Font.Name := 'Courrier';
    WidthText := TextWidth(IntToStr(fMax));
    HeightText := TextHeight(IntToStr(fMax));
    R := Width div 2;
    Brush.Style := BsClear;
    Font.Color := fValuesColor;
    TextOut(Round(R * (1 - Cos(-45 * PI / 180))) - WidthText div 10000, Round(R * (1 - Sin(-45 * PI / 180))) - Round(HeightText / 0.8), IntToStr(fMin));
    TextOut(Round(R * (1 - Cos(225 * PI / 180))) - WidthText div 2, Round(R * (1 - Sin(-45 * PI / 180))) - Round(HeightText / 0.9), IntToStr(fMax));
    if VisiblePosition = True then
    begin
      WidthText  := TextWidth(IntToStr(fPos));
      HeightText := TextHeight(IntToStr(fPos));
      TextOut(Width div 2 - WidthText div 2,Round( 0.95*Height-HeightText), IntToStr(fPos));
    end;                 
    WidthText:=TextWidth(fTitle);
    TextOut((Width-WidthText) Div 2,0,fTitle);
  end;
end;

{>>TEqualizerControl}
constructor TEqualizerControl.Create(AOwner: TComponent);
Var
  Index,Center,TopButton,LeftButton:Cardinal;
begin
  inherited Create(AOwner);
  fGaugeSelected:=-1;
  DoubleBuffered:=True;
  Create_RoundButtons(fBandwidthButton,'ButtonBandwidth','BANDWITH',1,50,290,152); //147
  Create_RoundButtons(fQButton,'ButtonQ','Q FACTOR',0,50,388,152);
  For Index:=0 To 9 Do
    Begin
      Center:=Trunc(30*Power(2,Index));
      Create_Gauge(fGauges[Index],'Band'+IntToStr(Index),65*(Index+1),0,Center,1,0);
    End;
  For Index:=0 To 5 Do
    Begin
      TopButton:=150+25*(Index Div 2);        //145
      LeftButton:=175+312*(Index Mod 2);
      Create_Buttons(fButtons[Index],'Button'+IntToStr(Index),DefaultsEqualizerControl[Index],LeftButton,TopButton);
      fButtons[Index].Index:=Index;
    End;
  Color:=$00D5CED5;
  BkGnColor:=$00535353;
end;

destructor TEqualizerControl.Destroy;
Var
  Index:Cardinal;
begin
  fBandwidthButton.Free;
  fQButton.Free;
  For Index:=0 To 9 Do
  fGauges[Index].Free;
  For Index:=0 To 5 Do
  fButtons[Index].Free;
  inherited;
end;

Procedure TEqualizerControl.Resize;
Begin
  Width:=743;
  Height:=235;
End;

Procedure TEqualizerControl.SetBkGnColor(Value:TColor);
Begin
  fBkGnColor:=Value;
  Invalidate;
End;

Procedure TEqualizerControl.ClickButton(Sender:TObject);
Const
  ControlsDefault:Array[0..5] Of Array [0..9] Of Integer=
                  ((0,0,4,0,-4,0,0,6,0,5),
                  (0,0,0,5,0,5,5,5,0,2),
                  (0,0,0,4,-4,-2,0,0,6,0),
                  (0,0,0,10,5,0,5,0,6,0),
                  (0,0,0,-12,-6,-2,0,0,4,0),
                  (0,0,0,2,2,0,6,0,2,0));
Var
  Index:Cardinal;
Begin;
  For Index:=0 To 9 Do
  With fGauges[Index] Do
    Begin
      Gain:=ControlsDefault[(Sender as TBrowserButton).Index,Index];
      If Assigned(fOnChange) Then fOnChange(fGauges[Index]);
    End;
  Invalidate;
End;

Procedure TEqualizerControl.Create_Gauge(Var AGaugeBar:TGaugeBar;AName:String;ALeft,AGain,ACenter,ABandWidth,AQ:Integer);
Begin
  AGaugeBar:=TGaugeBar.Create(Self);
  With AGaugeBar Do
    Begin
      Parent:=Self;
      Name:=AName;
      SetSubComponent(TRUE);
      Left:=ALeft;
      Height:=100;
      Top:=25;
      Gain:=-AGain;
      Center:=ACenter;
      Bandwidth:=ABandWidth;
      Q:=AQ;
    End;
End;

Procedure TEqualizerControl.Create_Buttons(Var AButton:TBrowserButton;AName,ACaption:String;ALeft,ATop:Cardinal);
Begin
  AButton:=TBrowserButton.Create(Self);
  With AButton Do
    Begin
      Parent:=Self;
      Name:=AName;
      SetSubComponent(TRUE);
      Width:=80;
      Height:=25;
      Left:=ALeft;
      Top:=ATop;
      Caption:=ACaption;
      OnClick:=ClickButton;
    End;
End;

Procedure TEqualizerControl.Create_RoundButtons(Var AButton:TRoundButton;AName,ATitle:String;AMin,AMax,ALeft,ATop:Cardinal);
Begin
  AButton:=TRoundButton.Create(Self);
  With AButton Do
    Begin
      Parent:=Self;
      Name:=AName;
      Title:=ATitle;
      SetSubComponent(TRUE);
      Width:=65;
      Height:=65;
      Left:=ALeft;
      Top:=ATop;
      Pos:=AMin;
      Min:=AMin;
      Max:=AMax;
      Color:=$00E9E4E9;
      VisiblePosition:=True;
    End;            
End;

Procedure TEqualizerControl.SetGaugeSelected(Value:Integer);
Begin
  fGaugeSelected:=Value;
  Invalidate;
End;

function TEqualizerControl.GetGauges(index: integer): TGaugeBar;
Begin
  result := fGauges[index];
End;

procedure TEqualizerControl.SetGauges(index: integer; value: TGaugeBar);
Begin
  if fGauges[index] <> value then
  fGauges[index] := value;
End;

Procedure TEqualizerControl.Paint;
Var
  Rect:TRect;
  Index,FreqStrWidth:Cardinal;
  FreqString:String;
Begin
  InHerited;
  With Canvas Do
    Begin
      Pen.Width:=0;
      Brush.Style:=BsClear;
      Pen.Color:=ClBlack;
      Rectangle(ClientRect);
      Font.Color:=ClWhite;
      Pen.Style:=psSolid;
      Brush.Color:=ClWhite;
      Pen.Color:=ClWhite;
      With Rect Do
        Begin
          Left:=8;
          Right:=735;
          Top:=15;
          Bottom:=145;
        End;
        Brush.Color:=fBkGnColor;
        Rectangle(Rect);
        Brush.Color:=ClWhite;
        Pen.Color:=ClWhite;
        Pen.Style:=psDot;
        Brush.Style:=BsClear;
        MoveTo(40,25);
        LineTo(710,25);
        TextOut(10,20,'15dB');
        MoveTo(40,67);
        LineTo(710,67);
        TextOut(10,62,'0dB');
        MoveTo(40,110);
        LineTo(710,110);
        TextOut(10,105,'-15dB');    
        For Index:=0 To 9 Do
          Begin
            FreqString:=IntToStr(fGauges[Index].Center)+'Hz';
            FreqStrWidth:=TextWidth(FreqString);
            TextOut(10+65*(Index+1)-FreqStrWidth Div 2,130,FreqString);
          End;
        If fGaugeSelected>-1 Then
        With Rect Do
          Begin
            Left:=65*(fGaugeSelected+1)-2;
            Right:=65*(fGaugeSelected+1)+20+2;
            Top:=23;
            Bottom:=127;
            Brush.Color:=ClWhite;
            Pen.Color:=ClWhite;
            Pen.Style:=psSolid;
            Rectangle(Rect);
          End;
        With Rect Do
          Begin
            Left:=276;
            Right:=467;
            Top:=151;  //146
            Bottom:=224;     //219
            Brush.Color:=$00E9E4E9;
            Pen.Color:=ClBlack;
            Pen.Style:=psSolid;
            Pen.Width:=2;
            Rectangle(Rect);
          End;
    End;
End;

procedure TEqualizerControl.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer);
Var
  Index:Integer;
Begin
  InHerited;
  If Shift=[SSLeft] Then
    Begin
      For Index:=0 To 10 Do
      If (X>=65*Index) And (X<=65*Index+20) Then
      If GaugeSelected=-1 Then
        Begin
          GaugeSelected:=Index-1;
          fBandwidthButton.SetPos(fGauges[GaugeSelected].Bandwidth);
          fQButton.SetPos(fGauges[GaugeSelected].Q);
        End
      Else
        Begin
          GaugeSelected:=-1;
          fBandwidthButton.fPos:=0;
          fQButton.fPos:=0;
        End;
    End;
End;

end.
