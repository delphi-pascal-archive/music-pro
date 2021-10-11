unit EffectTab;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs;

type
  TEffect=(TSoundFont,TDSP,TEgalizer,TVSTI,TVSTE);

  {>>SimpleButton}
  TSimpleButton = class(TCustomControl)
  private
    fCaption:String;
    fActived:Boolean;
    fColorActived:TColor;
    Procedure Set_Caption(Value:String);
    Procedure Set_Actived(Value:Boolean);
    Procedure Set_ColorActived(Value:TColor);
  protected
    procedure Paint; override;
    Procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;   
  published
    Property Color;
    Property Tag;
    Property Enabled;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;   
    Property OnDblClick;
    Property Caption : String Read fCaption Write Set_Caption;
    Property Actived : Boolean Read fActived Write Set_Actived;
    Property ColorActived:TColor Read fColorActived Write Set_ColorActived;
  end;

  TEffectTab = class(TCustomControl)
  private
    fCaption:String;
    fFileName:String;
    fFont:TFont;
    fButtons: array[0..2] Of TSimpleButton;
    fReals   : array[0..2] of Single;      
    fEffect:TEffect;
    Procedure Set_Caption(Value:String);
    Procedure Set_Font(Value:TFont);
    Procedure CreateButton(var Button:TSimpleButton;BtLeft,BtTop:Integer; BtName,BtCaption:String);
  protected
    procedure Paint; override;
    procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetButton(index: integer): TSimpleButton;
    procedure SetButton(index: integer; value: TSimpleButton);
    function GetSingle(index: integer): single;
    procedure SetSingle(index: integer; value: single);
  published
    Property Color;
    Property Enabled;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnClick;
    Property OnDblClick;
    Property Font:TFont Read fFont Write Set_Font;
    Property Caption:String Read fCaption Write Set_Caption;
    Property SoloButton:TSimpleButton Index 0 Read GetButton Write SetButton;
    Property MuteButton:TSimpleButton Index 1 Read GetButton Write SetButton;
    Property PanelButton:TSimpleButton Index 2 Read GetButton Write SetButton;
    Property BeginEffect :single index 0 Read GetSingle write SetSingle;
    Property EndEffect   :single index 1 Read GetSingle write SetSingle;
    Property Priority    :single index 2 Read GetSingle write SetSingle;
    Property FileName    :String Read fFileName write fFileName;
    Property Effect:TEffect Read fEffect Write fEffect;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TEffectTab]);
end;

{>>SimpleButton}
constructor TSimpleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorActived:=ClLime;
end;

destructor TSimpleButton.Destroy;
begin
  inherited;
end;

Procedure TSimpleButton.Set_Caption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

Procedure TSimpleButton.Set_Actived(Value:Boolean);
begin
  fActived:=Value;
  Invalidate;
end;

Procedure TSimpleButton.Set_ColorActived(Value:TColor);
begin
  fColorActived:=Value;
  Invalidate;
end;

Procedure TSimpleButton.Click;
begin
  fActived:=Not fActived;
  Invalidate;
end;

procedure TSimpleButton.Paint;
Var
  HeightCaption, WidthCaption:Integer;
  CornerPoint:Array[0..2] Of TPoint;
Begin
  InHerited;
  With Canvas Do
    Begin
      Pen.Color:=ClBlack;
      If Not Actived Then Brush.Color:=Color
      Else Brush.Color:=fColorActived;
      Rectangle(ClientRect);
      HeightCaption:=TextHeight(Caption);
      WidthCaption:=TextWidth(Caption);
      Font.Style:=[fsBold];
      TextOut((Width - WidthCaption) Div 2,(Height - HeightCaption) Div 2, Caption);
      CornerPoint[0]:=Point(Pen.Width,Height-2*Pen.Width);
      CornerPoint[1]:=Point(Width-2*Pen.Width,Height-2*Pen.Width);
      CornerPoint[2]:=Point(Width-2*Pen.Width,0);
      Pen.Color:=ClGray;
     PolyLine(CornerPoint);
    End;
End;

{>>TEffectTab}
constructor TEffectTab.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='Music Pro';
  Color:=$00A3B4BE;
  fFont:=TFont.Create;
  fFont.Style:=[fsBold,fsUnderLine];
  BevelOuter:=bvLowered	;
  CreateButton(fButtons[0],9,20,'SoloBt','S');
  CreateButton(fButtons[1],34,20,'MuteBt','M');
  CreateButton(fButtons[2],59,20,'PanelBt','P');
End;

destructor TEffectTab.Destroy;
Var
  Index:Cardinal;
begin
  For Index:=0 To 2 Do
    Begin
      fButtons[Index].Free;
    End;  
  fFont.Free;
  Inherited Destroy;
end;

Procedure TEffectTab.Set_Caption(Value:String);
Begin
  If (Value<>fCaption) Then
    Begin
      fCaption:=Value;
      Invalidate;
    End;
End;

Procedure TEffectTab.Set_Font(Value:TFont);
Begin
  If Value<>fFont Then
    Begin
      fFont.Assign(Value);
      Invalidate;
    End;
End;

function TEffectTab.GetButton(index: integer): TSimpleButton;
begin
  result := fButtons[index];
end;

procedure TEffectTab.SetButton(index: integer; value: TSimpleButton);
begin
  If fButtons[index] <> value then
  fButtons[index] := value;
end;

function TEffectTab.GetSingle(index: integer): Single;
begin
  result := fReals[index];
end;

procedure TEffectTab.SetSingle(index: integer; value: single);
begin
  if fReals[index] <> value then
  fReals[index] := value;
end;

Procedure TEffectTab.CreateButton(var Button:TSimpleButton;BtLeft,BtTop:Integer; BtName,BtCaption:String);
Begin
  Button:=TSimpleButton.Create(Self);
  With Button Do
    Begin
      Parent:=Self;
      Name:=BtName;
      Width:=16;
      Height:=16;
      Left:=BtLeft;
      Top:=BtTop;
      Color:=$0013AECA;
      Caption:=BtCaption;
      SetSubComponent(True);
      Font.Size:=14;
      Font.Style:=[FsBold];
    End; 
End;

procedure TEffectTab.Paint;
Var
   WidthTextEffect:Integer;
   UpperCorner,LowerCorner:Array [0..2] Of TPoint;
Begin
  InHerited;
  With Canvas Do
    Begin
      Pen.Width:=1;
      Brush.Style:=BsClear;
      Font:=fFont;
      Brush.Style:=BsClear;
      WidthTextEffect:=(Width - TextWidth(fCaption)) Div 2;
      TextOut(WidthTextEffect,2,fCaption);
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
    End;
End;

procedure TEffectTab.Resize;
Begin
  InHerited;
  Width:=81;
  Height:=40;
End;



end.
