unit MasterMix;

interface

uses
  Forms, Windows, Messages, SysUtils, Classes, Controls, Graphics;

type

  {>>TITLE}
  TMasterTitle = class(TCustomControl)
  private
    fColorTitle:TColor;
    fColorSubTitle:TColor;
    fColorRectTitle:TColor;
    fTitle:String;
    fSubTitle:String;
    Procedure setColorTitle(Value:TColor);
    Procedure setColorSubTitle(Value:TColor);
    Procedure setColorRectTitle(Value:TColor);
    Procedure SetTitle(Value:String);
    Procedure SetSubTitle(Value:String);
  protected
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property ColorTitle:TColor Read fColorTitle Write SetColorTitle;
    Property ColorSubTitle:TColor Read fColorSubTitle Write SetColorSubTitle;
    Property ColorRectTitle:TColor Read fColorRectTitle Write SetColorRectTitle;
    Property Title:String Read fTitle Write SetTitle;
    Property SubTitle:String Read fSubTitle Write SetSubTitle;
  end;

  {>>TSlider}
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

  {>>TPrgrBar}
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

  {>>TFader}
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

  TMasterMix = class(TCustomControl)
  private
    fCaption:String;
    fMasterTitle:TMasterTitle;
    fSlider:TSlider;
    fPrgrBar:TPrgrBar;
    fFader:TFader;
    fOnChange : TNotifyEvent;
    Procedure Set_Caption(Value:String);
  protected
    procedure Resize; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Caption : String Read fCaption Write Set_Caption;
    Property Slider:TSlider Read fSlider Write fSlider;
    Property PrgrBar:TPrgrBar Read fPrgrBar Write fPrgrBar;
    Property Fader:TFader Read fFader Write fFader;
    Property MasterTitle:TMasterTitle Read fMasterTitle Write fMasterTitle;    
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
  RegisterComponents('MUSIC_PRO', [TMasterMix]);
end;


{>>TITLE}
constructor TMasterTitle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorRectTitle:=$00CBD5DA;
  Title:='Music Pro';
  fColorTitle:=clWhite;
  SubTitle:='Master';
  fColorSubTitle:=$000F16AC;
end;

destructor TMasterTitle.Destroy;
begin
  Inherited Destroy;
end;

Procedure TMasterTitle.setColorTitle(Value:TColor);
Begin
  fColorTitle:=Value;
  Invalidate;
End;

Procedure TMasterTitle.setColorSubTitle(Value:TColor);
Begin
  fColorSubTitle:=Value;
  Invalidate;
End;

Procedure TMasterTitle.setColorRectTitle(Value:TColor);
Begin
  fColorRectTitle:=Value;
  Invalidate;
End;

Procedure TMasterTitle.SetTitle(Value:String);
Begin
  fTitle:=Value;
  Invalidate;
End;

Procedure TMasterTitle.SetSubTitle(Value:String);
Begin
  fSubTitle:=Value;
  Invalidate;
End;

procedure TMasterTitle.Resize;
Begin
  inherited;
  Width:=100;
  Height:=49;
  Invalidate;
End;

procedure TMasterTitle.Paint;
Var
  RectTitle:TRect;
  WidthString,HeightString,LeftString,TopString:Integer;
Begin
  InHerited;
  With Canvas Do
    Begin
      Brush.Style:=BsClear;
      With RectTitle Do
        Begin
          Left:=1;
          Right:=Width;
          Top:=1;
          Bottom:=Height;
          Brush.Color:=fColorRectTitle;
          Pen.Color:=ClBlack;
          Pen.Width:=2;
          Rectangle(RectTitle);

          Font.Name:='ARIAL';
          Font.Size:=12;
          Font.Color:=fColorTitle;
          LeftString:=Round(0.05*Width);
          TopString:=Pen.Width;
          TextOut(LeftString,TopString,fTitle);

          Font.Name:='Comic Sans MS';
          Font.Size:=13;
          Font.Color:=Self.fColorSubTitle;
          WidthString:=TextWidth(fSubTitle);
          HeightString:=TextHeight(fSubTitle);
          LeftString:=Self.Width-WidthString-10;
          TopString:=Bottom-Pen.Width-HeightString;
          TextOut(LeftString,TopString,fSubTitle);
        End;
    End 
End;

{>>TSlider}
constructor TSlider.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
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

{>>TPrgrBar}
constructor TPrgrBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  Width:=44;
  fMin:=0;
  fMax:=100;
  fPos:=100;
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

{>>TFader}
constructor TFader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  Width:=44;
  fMin:=0;
  fMax:=100;
  fPos:=100;
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
          ValueStr:=format('%.0f', [fMax-(fMax-fMin)*IndexLine / 4]);
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

{>>TMasterMix}
constructor TMasterMix.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCaption:='MASTER';
  Color:=$00A3B4BE;
  fMasterTitle:=TMasterTitle.Create(Self);
  With fMasterTitle Do
    Begin
      Parent:=Self;
      Left:=5;
      Top:=5;
    End;
  fSlider:=TSlider.Create(Self);
  With fSlider Do
  Begin
    Parent:=Self;
    Name:='Slider';
    SetSubComponent(True);
    Width:=100;
    Height:=35;
    Left:=5;
    Top:=56;
    Caption:='Pan';
  End;
  fFader:=TFader.Create(Self);
  With fFader Do
  Begin
    Parent:=Self;
    Name:='Fader';
    SetSubComponent(True);
    Width:=50;
    Height:=300;
    Left:=5;
    Top:=fSlider.Top+fSlider.Height;
  End;
  fPrgrBar:=TPrgrBar.Create(Self);
  With fPrgrBar Do
  Begin
    Parent:=Self;
    Name:='PrgrBar';
    SetSubComponent(True);
    Width:=50;
    Height:=300;     
    Left:=fFader.Left+fFader.Width;
    Top:=fSlider.Top+fSlider.Height;
  End;
end;

destructor TMasterMix.Destroy;
begin
  fMasterTitle.Free;
  fSlider.Free;
//  fFader.Free;
//  fPrgrBar.Free;
  inherited;
end;

Procedure TMasterMix.Set_Caption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

procedure TMasterMix.Resize;
Begin
  InHerited;
  Width:=110;
  Height:=416;
End;

procedure TMasterMix.Paint;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  TopOffset,DecHeight,WidthText,HeightText:Integer;
  Rect:TRect;
Begin
  InHerited;
  With Canvas Do
  Begin
    Pen.Width:=4;
    UpperCorner[0]:=Point(0,Height);
    UpperCorner[1]:=Point(0,0);
    UpperCorner[2]:=Point(Width,0);
    LowerCorner[0]:=Point(0,Self.Height);
    LowerCorner[1]:=Point(Width,Height);
    LowerCorner[2]:=Point(Width,0);
    Pen.Color:=ClWhite;
    Polyline(UpperCorner);
    Pen.Color:=$00AEAEAE;
    Polyline(LowerCorner);
    Pen.Width:=0;
    TopOffset:=fFader.Top+fFader.Height;
    DecHeight:=Height-TopOffset;
    Brush.Color:=$00E1E1E1;
    Pen.Color:=$00E1E1E1; 
    With Rect Do
    Begin
      Left:=5;
      Right:=Width-5;
      Top:=TopOffset+1;
      Bottom:=Height-5;
    End;
    Rectangle(Rect);
    UpperCorner[0]:=Point(Width-6,TopOffset+1);
    UpperCorner[1]:=Point(6,TopOffset+1);
    UpperCorner[2]:=Point(6,Height-5);
    LowerCorner[0]:=Point(6,Height-5);
    LowerCorner[1]:=Point(Width-6,Height-5);
    LowerCorner[2]:=Point(Width-6,TopOffset+1);
    Pen.Color:=$00657271;
    Polyline(UpperCorner);
    Pen.Color:=ClWhite;
    Polyline(LowerCorner);
    WidthText:=(Width-TextWidth(fCaption)) Div 2;
    HeightText:=TopOffset+(DecHeight-TextHeight(fCaption)) Div 2;
    Brush.Style:=BsClear;
    TextOut(WidthText,heightText,fCaption);
  End;
End;


end.
