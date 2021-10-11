unit TracksMix;


interface

uses
  Forms, Windows, Messages, SysUtils, Classes, Controls, Graphics,Dialogs;

type
  TMxTypeDSP=(TMxEcho,TMxFlanger,TMxVolume,TMxReverb,TMxLowPassFilter,TMxAmplification,
            TMxAutoWah,TMxEcho2,TMxPhaser,TMxEcho3,TMxChorus,TMxAllPassFilter,TMxCompressor,
	    TDistortion);
			   
  TMxTypeEffect=(TMxSOUNDFONT,TMxVSTI,TMxVSTE,TMxDSP,TMxEQUALIZER);

  TTracksMix=Class;

  {>>TSimpleButton}
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

  {>>TEffectTab}
  TEffectTab = class(TCustomControl)
  private
    fCaption:String;
    fFileName:String;
    fFont:TFont;
    fButtons: array[0..2] Of TSimpleButton;
    fEffectIndex:integer;
    fEffect:TMxTypeEffect;
    fTypeDSP:TMxTypeDSP;
    Procedure Set_Caption(Value:String);
    Procedure Set_Font(Value:TFont);
    Procedure CreateButton(var Button:TSimpleButton;BtLeft,BtTop:Integer; BtName,BtCaption:String);
  protected
    procedure Paint; override;
    procedure Resize; override;
    Procedure Click;  override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetButton(index: integer): TSimpleButton;
    procedure SetButton(index: integer; value: TSimpleButton);
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
    Property EffectIndex:integer Read fEffectIndex write fEffectIndex;
    Property FileName    :String Read fFileName write fFileName;
    Property Effect:TMxTypeEffect Read fEffect Write fEffect;
    Property TypeDSP:TMxTypeDSP Read fTypeDSP Write fTypeDSP;	
  end;

{>>TEffect}
 TEffect = class(TCollectionItem)
  private
    fOnChange: TNotifyEvent;
    fEffectTab:TEffectTab;
    fCollection  : TCollection;
    fTracksMix:TTracksMix;
  protected
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
    function GetDisplayName : string; override;
    property Collection : TCollection  read fCollection write fCollection;    
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    Property EffectTab : TEffectTab Read fEffectTab write fEffectTab;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;  
  
{>>TEffectCnt}
  TEffectCnt = class(TOwnedCollection)
  Private
    fOwner : TPersistent;
    fTracksMix:TTracksMix;
  protected
    function GetItem(Index: Integer): TEffect;
    procedure SetItem(Index: Integer; Value: TEffect);
    function GetOwner: TPersistent; override;
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TEffect;
    Procedure Delete(Index:Integer);
    property Items[Index: Integer]: TEffect Read GetItem Write SetItem;
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
    fOnChange: TNotifyEvent;
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
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;    
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
    Property OnChange:TNotifyEvent Read fOnChange Write fOnChange;    
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

  TTrackMixPn = class(TCustomControl)
  private
    fTracksMix:TTracksMix;  
    ScrollBox:TScrollBox;
    fEffectCnt:TEffectCnt;
    fCaption:String;
    fSlider:TSlider;
    fPrgrBar:TPrgrBar;
    fFader:TFader;
    fOnChange : TNotifyEvent;
    Procedure Set_Caption(Value:String);
  protected
    procedure Resize; override;
    procedure Paint; override;   
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Caption : String Read fCaption Write Set_Caption;
    Property Slider:TSlider Read fSlider Write fSlider;
    Property PrgrBarr:TPrgrBar Read fPrgrBar Write fPrgrBar;
    Property Fader:TFader Read fFader Write fFader;
    Property EffectCnt:TEffectCnt Read fEffectCnt Write fEffectCnt;  
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


{>>TTrackMix}
 TTrackMix = class(TCollectionItem)
  private
    fOnChange: TNotifyEvent;
    fTrackMixPn:TTrackMixPn;
    fCollection  : TCollection;	
  protected
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
    function GetDisplayName : string; override;
    property Collection : TCollection  read fCollection write fCollection;  	
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    Property TrackMixPn : TTrackMixPn Read fTrackMixPn write fTrackMixPn;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;  
  
{>>TTrackMixCnt}
  TTrackMixCnt = class(TOwnedCollection)
  Private
    fOwner : TPersistent;
  protected
    function GetItem(Index: Integer): TTrackMix;
    procedure SetItem(Index: Integer; Value: TTrackMix);
    function GetOwner: TPersistent; override;	
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TPersistent);
    function Add: TTrackMix;
    property Items[Index: Integer]: TTrackMix Read GetItem Write SetItem;
  end;

  {EVENEMENTS}
    TSolo_Event = procedure(Sender: TObject) of object;
    TMute_Event = procedure(Sender: TObject) of object;
    TPanel_Event = procedure(Sender: TObject) of object;
    TEffectClick_Event = procedure(Sender: TObject) of object;
    TSliderChange_Event = procedure(Sender: TObject) of object;
    TPrgrChange_Event = procedure(Sender: TObject) of object;
    TFaderChange_Event = procedure(Sender: TObject) of object;

  {>>TTracksMix}
  TTracksMix = class(TCustomControl)
  private
    fOnChange: TNotifyEvent;
    fTrackMixCnt:TTrackMixCnt;
    fOnSolo_Event:  TNotifyEvent;
    fOnMute_Event:  TNotifyEvent;
    fOnPanel_Event:  TNotifyEvent;
    fOnEffectClick_Event:  TNotifyEvent;
    fOnPrgrChange_Event:  TNotifyEvent;
    fOnSliderChange_Event:  TNotifyEvent;
    fOnFaderChange_Event:  TNotifyEvent;
    procedure SetOnSolo_Event(Event : TNotifyEvent);
    procedure SetOnMute_Event(Event : TNotifyEvent);
    procedure SetOnPanel_Event(Event : TNotifyEvent);
    procedure SetOnEffectClick_Event(Event : TNotifyEvent);
    procedure SetOnPrgrChange_Event(Event : TNotifyEvent);
    procedure SetOnSliderChange_Event(Event : TNotifyEvent);
    procedure SetOnFaderChange_Event(Event : TNotifyEvent);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property TrackMixCnt:TTrackMixCnt Read fTrackMixCnt Write fTrackMixCnt;  
    property Solo_Event : TNotifyEvent Read fOnSolo_Event Write SetOnSolo_Event;
    property Mute_Event: TNotifyEvent Read fOnMute_Event Write SetOnMute_Event;
    property Panel_Event: TNotifyEvent Read fOnPanel_Event Write SetOnPanel_Event;
    property EffectClick: TNotifyEvent Read fOnEffectClick_Event Write SetOnEffectClick_Event;
    property PrgrChange_Event: TNotifyEvent Read fOnPrgrChange_Event Write SetOnPrgrChange_Event;        
    property SliderChange_Event: TNotifyEvent Read fOnSliderChange_Event Write SetOnSliderChange_Event;
    property FaderChange_Event: TNotifyEvent Read fOnFaderChange_Event Write SetOnFaderChange_Event;
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
  RegisterComponents('MUSIC_PRO', [TTracksMix]);
end;

{>>TSimpleButton}
constructor TSimpleButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorActived:=ClLime;
  fActived:=False;
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
  (Parent As TEffectTab).Click;
  InHerited;  
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
  fFont.Name:='Small Fonts';
  fFont.Size:=7;
  BevelOuter:=bvLowered	;
  CreateButton(fButtons[0],9,20,'SoloBt','S');
  CreateButton(fButtons[1],34,20,'MuteBt','M');
  CreateButton(fButtons[2],59,20,'PanelBt','P');
  fButtons[2].ColorActived:=fButtons[2].Color;
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


Procedure TEffectTab.CreateButton(var Button:TSimpleButton;BtLeft,BtTop:Integer; BtName,BtCaption:String);
Begin
  Button:=TSimpleButton.Create(Self);
  With Button Do
    Begin
      Parent:=Self;
      Name:=BtName;
      SetSubComponent(True);      
      Width:=14;
      Height:=16;
      Left:=BtLeft;
      Top:=BtTop;
      Color:=$0013AECA;
      Caption:=BtCaption;
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

Procedure TEffectTab.Click;
Var
  IndexEffect:Integer;
Begin
  If Assigned(Owner) Then
  With (Owner As TTrackMixPn) Do
    Begin
      If fEffectCnt.Count>0 Then
        Begin
          For IndexEffect:=0 To (fEffectCnt.Count-1) Do
          If fEffectCnt.Items[IndexEffect].fEffectTab=Self Then
          fEffectCnt.ItemIndex:=IndexEffect;
        End
      Else fEffectCnt.ItemIndex:=-1;
    End;
  InHerited;
End;

{>>TEffectCnt}
constructor TEffectCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TEffect);
  fOwner := AOwner;
  ItemIndex:=-1;
end;

function TEffectCnt.Add:TEffect;
begin
  Result := TEffect(inherited Add);
end;

Procedure TEffectCnt.Delete(Index:Integer);
begin
  inherited Delete(Index);
  ItemIndex:=-1;     
  (fOwner As TTrackMixPn).ScrollBox.VertScrollBar.Position:=0;
  fTracksMix.Invalidate;
end;

function TEffectCnt.GetItem(Index: Integer):TEffect;
begin
  Result := TEffect(inherited Items[Index]);
end;

procedure TEffectCnt.SetItem(Index: Integer; Value:TEffect);
begin
  inherited SetItem(Index, Value);
end;

function TEffectCnt.GetOwner: TPersistent;
begin
  Result := fOwner;
end;

{>>TEffect}
constructor TEffect.Create(ACollection: TCollection);
begin
  fCollection := (ACollection as TEffectCnt);
  fTracksMix := (ACollection as TEffectCnt).fTracksMix;
  inherited Create(ACollection);
  fEffectTab:=TEffectTab.Create(fCollection.Owner As TTrackMixPn);
  With fEffectTab Do
    Begin
      Parent:=(fCollection.Owner As TTrackMixPn).ScrollBox;
      Name:='EffectTab'+IntToStr(Self.Index);
      SetSubComponent(True);
      With (fTracksMix As TTracksMix) Do
        Begin
          SoloButton.OnClick:=fOnSolo_Event;
          MuteButton.OnClick:=fOnMute_Event;
          PanelButton.OnClick:=fOnPanel_Event;
          fEffectTab.OnClick:=fOnEffectClick_Event;
        End;    
    End;
end;

destructor TEffect.Destroy;
begin
  fEffectTab.Free;
  inherited Destroy;
end;

procedure TEffect.AssignTo(Dest: TPersistent);
begin
  if Dest is TEffect then
    with TEffect(Dest) do begin
      fOnChange := self.fOnChange;
      fEffectTab:= self.fEffectTab;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TEffect.Assign(Source : TPersistent);
begin
  if source is TEffect then
     with TEffect(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TEffect.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TEffect.GetDisplayName: string;
begin
  result := 'Effect['+IntToStr(Self.Index)+'] ';
end;

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
  If Assigned(Parent) Then
  (Parent As TTrackMixPn).MouseDown(Button,Shift,X+Left,Y+Top);
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

procedure TPrgrBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If Assigned(Parent) Then
  (Parent As TTrackMixPn).MouseDown(Button,Shift,X+Left,Y+Top);
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
  If Assigned(Parent) Then
  (Parent As TTrackMixPn).MouseDown(Button,Shift,X+Left,Y+Top);
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

{>>TTrackMixPn}
constructor TTrackMixPn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCaption:='TRACK';
  Color:=$00A3B4BE;
  ScrollBox:=TScrollBox.Create(Self);
  With ScrollBox Do
  Begin
    Parent:=Self;
    Name:='ScrollBox';
    Color:=$00D1DADE;
    Width:=100;
    Height:=46;
    Left:=5;
    Top:=5;
    HorzScrollBar.Size:=3;
    VertScrollBar.Size:=3;
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
    Top:=5+ScrollBox.Top+ScrollBox.Height;
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
  fEffectCnt:=TEffectCnt.Create(Self);
end;

destructor TTrackMixPn.Destroy;
begin
  fEffectCnt.Free;
  ScrollBox.Free;
  fSlider.Free;
  fPrgrBar.Free;
  fFader.Free;
  inherited;
end;

Procedure TTrackMixPn.Set_Caption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

procedure TTrackMixPn.Resize;
Begin
  InHerited;
  Width:=110;
  Height:=416;
End;

procedure TTrackMixPn.Paint;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  TopOffset,DecHeight,WidthText,HeightText:Integer;
  Rect:TRect;
  IndexEffect:Integer;
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
    If fEffectCnt.Count>0 Then
    For IndexEffect:=0 To (fEffectCnt.Count-1) Do
    With fEffectCnt.Items[IndexEffect] Do
    Begin
      If Assigned(fEffectTab) Then
      Begin
        fEffectTab.Left:=8;
        fEffectTab.Top:=1+40*IndexEffect;
      End;
    End;  
  End;
End;

procedure TTrackMixPn.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If Assigned(Parent)Then
  (Parent As TTracksMix).MouseDown(Button,Shift,X+Left,Y+Top);
End;

{>>TTrackMix}
constructor TTrackMix.Create(ACollection: TCollection);
begin
  fCollection := (ACollection as TTrackMixCnt);
  inherited Create(ACollection);
  fTrackMixPn:=TTrackMixPn.Create(fCollection.Owner As TComponent);
  With fTrackMixPn Do
    Begin
      Parent:=(fCollection.Owner As TTracksMix);
      SetSubComponent(True);
      fTracksMix:=Owner As TTracksMix;
      EffectCnt.fTracksMix:=Owner As TTracksMix;
      With (Owner As TTracksMix) Do
        Begin
          fPrgrBar.OnChange:=fOnPrgrChange_Event;
          fSlider.OnChange:=fOnSliderChange_Event;
          fFader.OnChange:=fOnFaderChange_Event;
        End;
    End;  
end;

destructor TTrackMix.Destroy;
begin
  fTrackMixPn.Free;
  inherited Destroy;
end;

procedure TTrackMix.AssignTo(Dest: TPersistent);
begin
  if Dest is TTrackMix then
    with TTrackMix(Dest) do begin
      fOnChange := self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TTrackMix.Assign(Source : TPersistent);
begin
  if source is TTrackMix then
     with TTrackMix(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TTrackMix.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TTrackMix.GetDisplayName: string;
begin
  result := 'TrackMix['+IntToStr(Self.Index)+'] ';
end;

{>>TTrackMixCnt}
constructor TTrackMixCnt.Create(AOwner: TPersistent);
begin
  fOwner := AOwner;
  inherited Create(AOwner,TTrackMix);
end;

function TTrackMixCnt.Add:TTrackMix;
begin
  Result := TTrackMix(inherited Add);
end;

function TTrackMixCnt.GetItem(Index: Integer):TTrackMix;
begin
  Result := TTrackMix(inherited Items[Index]);
end;

procedure TTrackMixCnt.SetItem(Index: Integer; Value:TTrackMix);
begin
  inherited SetItem(Index, Value);
end;

function TTrackMixCnt.GetOwner: TPersistent;
begin
  Result := fOwner;
end;

{>>TTracksMix}
constructor TTracksMix.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RegisterClass(TTrackMixPn);
  fTrackMixCnt:=TTrackMixCnt.Create(Self);
  DoubleBuffered:=True;
end;

destructor TTracksMix.Destroy;
begin
  fTrackMixCnt.Free;
  inherited;
end;

procedure TTracksMix.Paint;
Var
  IndexTrack:Integer;
begin
  inherited;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  With fTrackMixCnt.Items[IndexTrack] Do
  Begin
    fTrackMixPn.Left:=110*IndexTrack;
    fTrackMixPn.Top:=0;
    Width:=110*fTrackMixCnt.Count;
  End;
end;

procedure TTracksMix.Resize;
begin
  inherited;
  Height:=416;
End;

Procedure TTracksMix.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  fTrackMixCnt.ItemIndex:=-1;
  If fTrackMixCnt.Count>0 Then
  fTrackMixCnt.ItemIndex:=X Div fTrackMixCnt.Items[0].fTrackMixPn.Width;
  inherited;
End;

procedure TTracksMix.SetOnSolo_Event(Event : TNotifyEvent);
Var
  IndexTrack,IndexEffect:Cardinal;
Begin
  fOnSolo_Event := Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  With fTrackMixCnt.Items[IndexTrack].fTrackMixPn Do
    Begin
      If EffectCnt.Count>0 Then
      For IndexEffect:=0 To (EffectCnt.Count-1) Do
      EffectCnt.Items[IndexEffect].fEffectTab.SoloButton.OnClick:=fOnSolo_Event;
    End;
End;

procedure TTracksMix.SetOnMute_Event(Event : TNotifyEvent);
Var
  IndexTrack,IndexEffect:Cardinal;
Begin
  fOnMute_Event := Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  With fTrackMixCnt.Items[IndexTrack].fTrackMixPn Do
    Begin
      If EffectCnt.Count>0 Then
      For IndexEffect:=0 To (EffectCnt.Count-1) Do
      EffectCnt.Items[IndexEffect].fEffectTab.MuteButton.OnClick:=fOnMute_Event;
    End;
End;

procedure TTracksMix.SetOnPanel_Event(Event : TNotifyEvent);
Var
  IndexTrack,IndexEffect:Cardinal;
Begin
  fOnPanel_Event:= Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  With fTrackMixCnt.Items[IndexTrack].fTrackMixPn Do
    Begin
      If EffectCnt.Count>0 Then
      For IndexEffect:=0 To (EffectCnt.Count-1) Do
      EffectCnt.Items[IndexEffect].fEffectTab.PanelButton.OnClick:=fOnPanel_Event;
    End;
End;

procedure TTracksMix.SetOnEffectClick_Event(Event : TNotifyEvent);
Var
  IndexTrack,IndexEffect:Cardinal;
Begin
  fOnEffectClick_Event:= Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  With fTrackMixCnt.Items[IndexTrack].fTrackMixPn Do
    Begin
      If EffectCnt.Count>0 Then
      For IndexEffect:=0 To (EffectCnt.Count-1) Do
      EffectCnt.Items[IndexEffect].fEffectTab.OnClick:=fOnEffectClick_Event;
    End;
End;

procedure TTracksMix.SetOnPrgrChange_Event(Event : TNotifyEvent);
Var
  IndexTrack:Cardinal;
Begin
  fOnPrgrChange_Event := Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  fTrackMixCnt.Items[IndexTrack].fTrackMixPn.fPrgrBar.OnChange:=fOnPrgrChange_Event;
End;

procedure TTracksMix.SetOnSliderChange_Event(Event : TNotifyEvent);
Var
  IndexTrack:Cardinal;
Begin
  fOnSliderChange_Event := Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  fTrackMixCnt.Items[IndexTrack].fTrackMixPn.fSlider.OnChange:=fOnSliderChange_Event;
End;

procedure TTracksMix.SetOnFaderChange_Event(Event : TNotifyEvent);
Var
  IndexTrack:Cardinal;
Begin
  fOnFaderChange_Event := Event;
  If fTrackMixCnt.Count>0 Then
  For IndexTrack:=0 To (fTrackMixCnt.Count-1) Do
  fTrackMixCnt.Items[IndexTrack].fTrackMixPn.fFader.OnChange:=fOnFaderChange_Event;
End;

end.
