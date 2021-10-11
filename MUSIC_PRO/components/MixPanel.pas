{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}

unit MixPanel;

interface

uses
  Forms,Windows, Messages, SysUtils, Classes, Controls, Dialogs, Graphics, StdCtrls, ExtCtrls,TracksGrid;

type

  {>>TITLE}
  TMixPanelTitle = class(TCustomControl)
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

  {>>MixPnButton}
  TMixPnButton = class(TGraphicControl)
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

  {>>TListEffect}
  TListEffect = class(TListBox)
  private
  protected
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); override;
  public
    procedure Resize; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  {>>TMixPanel}
  TMixPanel = class(TCustomControl)
  private
    fListEffects : array[0..4] Of TListEffect;
    fPanelEffects: array[0..4] Of TPanel;
    fButtons: array[0..1] Of TMixPnButton;
    fMixPanelTitle:TMixPanelTitle;
    fSelectedColor:TColor;
    fListBoxColor:TColor;
    fPanelColor:TColor;
    Procedure SetSelectedColor(Value:TColor);
    Procedure SetListBoxColor(Value:TColor);
    Procedure SetPanelColor(Value:TColor);
    Procedure CreateButton(var Button:TMixPnButton;BtLeft,BtTop:Integer; BtCaption:String);
    Procedure ListBoxDblClick(Sender:TObject);
  protected
    procedure Resize; override;
    procedure Paint; override;    
  public
    function GetButton(index: integer): TMixPnButton;
    procedure SetButton(index: integer; value: TMixPnButton);
    function GetListEffect(index: integer): TListEffect;
    procedure SetListEffect(index: integer; value: TListEffect);  
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Color;
    Property SoundFont:TListEffect Index 0 Read GetListEffect Write SetListEffect;
    Property VSTI:TListEffect Index 1 Read GetListEffect Write SetListEffect;
    Property VSTE:TListEffect Index 2 Read GetListEffect Write SetListEffect;
    Property DSP:TListEffect Index 3 Read GetListEffect Write SetListEffect;
    Property EQUALIZER:TListEffect Index 4 Read GetListEffect Write SetListEffect;
    Property SelectedColor:TColor Read fSelectedColor Write SetSelectedColor;
    Property ListBoxColor:TColor Read fListBoxColor Write SetListBoxColor;
    Property PanelColor:TColor Read fPanelColor Write SetPanelColor;
    Property AddMixPnButton:TMixPnButton Index 0 Read GetButton Write SetButton;
    Property DelMixPnButton:TMixPnButton Index 1 Read GetButton Write SetButton;
    Property MixPanelTitle:TMixPanelTitle Read fMixPanelTitle Write fMixPanelTitle;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TMixPanel]);
end;

{>>TITLE}
constructor TMixPanelTitle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorRectTitle:=$00CBD5DA;
  Title:='Music Pro';
  fColorTitle:=clWhite;
  SubTitle:='Mix Panel';
  fColorSubTitle:=$000F16AC;
end;

destructor TMixPanelTitle.Destroy;
begin
  Inherited Destroy;
end;

Procedure TMixPanelTitle.setColorTitle(Value:TColor);
Begin
  fColorTitle:=Value;
  Invalidate;
End;

Procedure TMixPanelTitle.setColorSubTitle(Value:TColor);
Begin
  fColorSubTitle:=Value;
  Invalidate;
End;

Procedure TMixPanelTitle.setColorRectTitle(Value:TColor);
Begin
  fColorRectTitle:=Value;
  Invalidate;
End;

Procedure TMixPanelTitle.SetTitle(Value:String);
Begin
  fTitle:=Value;
  Invalidate;
End;

Procedure TMixPanelTitle.SetSubTitle(Value:String);
Begin
  fSubTitle:=Value;
  Invalidate;
End;

procedure TMixPanelTitle.Resize;
Begin
  inherited;
  Width:=105;
  Height:=49;
  Invalidate;
End;

procedure TMixPanelTitle.Paint;
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
          Right:=Self.Width;
          Top:=1;
          Bottom:=49;
          Brush.Color:=Self.fColorRectTitle;
          Pen.Color:=ClBlack;
          Pen.Width:=2;
          Rectangle(RectTitle);

          Font.Name:='ARIAL';
          Font.Size:=12;
          Font.Color:=fColorTitle;
          LeftString:=Round(0.05*Self.Width);
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

{>>MixPnButton}
constructor TMixPnButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fClicked:=False;
end;

destructor TMixPnButton.Destroy;
begin
  inherited;
end;

Procedure TMixPnButton.SetColorLine(Value:TColor);
begin
  fColorLine:=Value;
  Invalidate;
end;

Procedure TMixPnButton.SetColorTop(Value:TColor);
begin
  Self.fColorTop:=Value;
  Self.Invalidate;
end;

Procedure TMixPnButton.SetColorBottom(Value:TColor);
begin
  fColorBottom:=Value;
  Invalidate;
end;

Procedure TMixPnButton.SetCaption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

procedure TMixPnButton.Paint;
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
          Bottom:=Self.Height Div 2 ;
          Left:=6;
          Right:=Self.Width-6;
          Brush.Color:=fColorTop;
          Pen.Color:=fColorTop;
          Rectangle(RectTop);
        End;
      With RectBottom Do
        Begin
          Top:=Self.Height Div 2;
          Bottom:=Self.Height-6;
          Left:=6;
          Right:=Self.Width-6;
          Brush.Color:=fColorBottom;
          Pen.Color:=fColorBottom;
          Rectangle(RectBottom );
        End;
      Brush.Color:=fColorLine;
      Pen.Color:=fColorLine;
      Pen.Width:=2;
      MoveTo(5,Height Div 2);
      LineTo(Width-7,Height Div 2);
      HeightCaption:=TextHeight(Caption);
      WidthCaption:=TextWidth(Caption);
      Brush.Style:=BsClear;
      TextOut((Width - WidthCaption) Div 2,(Height - HeightCaption) Div 2, Caption);
    End;
End;

Procedure TMixPnButton.DrawBorder;
Var
  LeftColor, RightColor:TColor;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
Begin
  If Not fClicked Then
    Begin
      LeftColor:=ClWhite;
      RightColor:=$00657271;
    End
  Else
    Begin
      LeftColor:=$00657271;
      RightColor:=ClWhite;
    End;
  With Self.Canvas Do
    Begin
      Pen.Width:=1;
      UpperCorner[0]:=Point(Pen.Width,Height-Pen.Width);
      UpperCorner[1]:=Point(Pen.Width,Pen.Width);
      UpperCorner[2]:=Point(Width-Pen.Width,Pen.Width);
      LowerCorner[0]:=Point(Pen.Width,Self.Height-Pen.Width);
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

procedure TMixPnButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If Shift=[SSLeft] Then
    Begin
      fClicked:= True;
      Invalidate;
    End; 
End;

procedure TMixPnButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
   fClicked:= False;
   Invalidate;
End;

{>>TListEffect}
constructor TListEffect.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Style:=lbOwnerDrawFixed;
End;

destructor TListEffect.Destroy;
begin
  Inherited Destroy;
end;

procedure TListEffect.Resize;
begin
  inherited;
  Width:=105;
  Height:=45;
  Invalidate;
end;

procedure TListEffect.DrawItem(Index: Integer;
                               Rect: TRect; State: TOwnerDrawState);  
Begin
  InHerited;
  if odSelected in State then
    Begin
      Canvas.Brush.Color:= (Parent As TMixPanel).SelectedColor;
      Canvas.Font.Color:= clwhite;
    end
  else
    begin
      Canvas.Brush.Color:= Color;
      Canvas.Font.Color:= Font.Color;
    end;
  Canvas.FillRect(Rect);
  Canvas.TextOut(Rect.Left, Rect.Top, Items[Index]);
End;



{>>TMixPanel}
constructor TMixPanel.Create(AOwner: TComponent); 
Const
  NameListe:Array[0..4] Of String=('SOUNDFONT',
                                   'VSTI',
                                   'VSTE',
                                   'DSP',
                                   'EQUALIZER');
Var
  Index:Cardinal;
begin
  inherited Create(AOwner);
  RegisterClass(TMixPnButton);
  RegisterClass(TMixPanelTitle);
  RegisterClass(TPanel);
  RegisterClass(TListEffect);    
  Color:=$00A3B4BE;
  fListBoxColor:=$00CBD5DA;
  fPanelColor:=$0013AECA;
  fMixPanelTitle:=TMixPanelTitle.Create(Self);
  With fMixPanelTitle Do
    Begin
      Parent:=Self;
      Left:=5;
      Top:=5;
    End;
  For Index:=0 To 4 Do
    Begin
      fPanelEffects[Index]:=TPanel.Create(Self);
      With fPanelEffects[Index] Do
        Begin
          Parent:=Self;
          Left:=5;
          Width:=105;
          Height:=20;
          Caption:=NameListe[Index];
          BevelOuter:=bvLowered;
          BevelWidth:=2;
          Top:=86+65*Index;
        End;
      fListEffects[Index]:=TListEffect.Create(Self);
      With fListEffects[Index] Do
        Begin
          Parent:=Self;
          Left:=5;
          Top:=106+65*Index;
          SetSubComponent(True);
          OnDblClick:=ListBoxDblClick;
        End;
    End;
  CreateButton(fButtons[0],8,56,'A');
  CreateButton(fButtons[1],63,56,'D');
End;

destructor TMixPanel.Destroy;
Var
  Index:Cardinal;
begin
  For Index:=0 To 1 Do
  fButtons[Index].Free;
  For Index:=0 To 4 Do
    Begin
      fPanelEffects[Index].Free;
      fListEffects[Index].Free;
    End;
  Inherited Destroy;
end;

Procedure TMixPanel.setSelectedColor(Value:TColor);
Begin
  If Value<>fSelectedColor Then
    Begin
      fSelectedColor:=Value;
      Invalidate;
    End;
End;

Procedure TMixPanel.setListBoxColor(Value:TColor);
Begin
  If Value<>fListBoxColor Then
    Begin
      fListBoxColor:=Value;
      Invalidate;
    End;
End;

Procedure TMixPanel.SetPanelColor(Value:TColor);
Begin
  If Value<>fPanelColor Then
    Begin
      fPanelColor:=Value;
      Invalidate;
    End;
End;

Procedure TMixPanel.CreateButton(var Button:TMixPnButton;BtLeft,BtTop:Integer; BtCaption:String);
Begin
  Button:=TMixPnButton.Create(Self);
  With Button Do
    Begin
      Parent:=Self;
      Width:=42;
      Height:=28;
      Left:=BtLeft;
      Top:=BtTop;
      Caption:=BtCaption;
      SetSubComponent(True);
      Font.Size:=14;
      Font.Style:=[FsBold];
      ColorTop:=$00FFE6E1;
      ColorBottom:=$00E8E8E8;
      ColorLine:=$0041C9D3;
    End; 
End;

function TMixPanel.GetListEffect(index: integer): TListEffect;
begin
  result := fListEffects[index];
end;

procedure TMixPanel.SetListEffect(index: integer; value: TListEffect);
begin
  If fListEffects[index] <> value then
  fListEffects[index] := value;
end;

function TMixPanel.GetButton(index: integer): TMixPnButton;
begin
  result := fButtons[index];
end;

procedure TMixPanel.SetButton(index: integer; value: TMixPnButton);
begin
  If fButtons[index] <> value then
  fButtons[index] := value;
end;   

procedure TMixPanel.Resize;
Begin
  InHerited;
  Width:=115;
  Height:=416;
End;

procedure TMixPanel.Paint;
Var
  LeftColor, RightColor:TColor;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  Index:Cardinal;
Begin
  InHerited;
  For Index:=0 To 4 Do
    Begin
      fListEffects[Index].Color:=fListBoxColor;
      fPanelEffects[Index].Color:=fPanelColor;
    End;
  With Canvas Do
    Begin
      LeftColor:=ClWhite;
      RightColor:=$00657271;
      Pen.Width:=1;
      UpperCorner[0]:=Point(Pen.Width,Height-Pen.Width);
      UpperCorner[1]:=Point(Pen.Width,Pen.Width);
      UpperCorner[2]:=Point(Width-Pen.Width,Pen.Width);
      LowerCorner[0]:=Point(Pen.Width,Self.Height-Pen.Width);
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

procedure TMixPanel.ListBoxDblClick(Sender:TObject);
Begin
  With (Sender As TListBox) Do
  If ItemIndex>-1 Then Selected[0] := false;
End;

End.