{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}

unit BrowserTracks;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, StdCtrls, Dialogs;

type

  TBrowserTracks = class;
  TBrTrackCnt = class;
    
  {>>TITLE}
  TBrPanelTitle = class(TCustomControl)
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

  {>>BrCstButton}
  TBrCstButton = class(TCustomControl)
  private
    fColorLine:TColor;
    fColorTop:TColor;
    fColorBottom:TColor;
    fCaption:String;
    fSwitchActif:Boolean;
    fPushed:Boolean;
    Procedure SetColorLine(Value:TColor);
    Procedure SetColorTop(Value:TColor);
    Procedure SetColorBottom(Value:TColor);
    Procedure SetCaption(Value:String);
    Procedure DrawBorder;
    Procedure SetPushed(Value:Boolean);
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
    Property Pushed:Boolean Read fPushed Write SetPushed;
    Property SwitchActif:Boolean Read fSwitchActif Write fSwitchActif;
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

  {>>BrPanelTrack}
  TTrackType=(TtMidi,TtWav);
  
  TBrPanelTrack = class(TCustomControl)
  private
    fTypeTrack:TTrackType;
    fIndex:Integer;
    fActive:Boolean;
    fEdit:TEdit;
    fOpenBt:TBrCstButton;
    fAcquisitionBt:TBrCstButton;	
    fWriteBt:TBrCstButton;
    fReadBt:TBrCstButton;
    fSoloBt:TBrCstButton;
    fMuteBt:TBrCstButton;
    Procedure SetTypeTrack(Value:TTrackType);
    Procedure SetIndex(Value:Integer);
    Procedure SetActive(Value:Boolean);
    Procedure DrawTypeArea;
    Procedure DrawTypeLogo;
    Procedure DrawCircle(X,Y,Width,Height:Integer);
    Procedure CreateButton(var Button:TBrCstButton;BtLeft,BtTop:Integer; BtName,BtCaption:String; ToSwitch:Boolean);
    Procedure EditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    Owner : TPersistent;
    ItemIndex:Integer;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Edit:TEdit Read fEdit Write fEdit;
    property OpenBt:TBrCstButton Read fOpenBt Write fOpenBt;
    property AcquisitionBt:TBrCstButton Read fAcquisitionBt Write fAcquisitionBt;	
    property WriteBt:TBrCstButton Read fWriteBt Write fWriteBt;
    property ReadBt:TBrCstButton Read fReadBt Write fReadBt;	
    property SoloBt:TBrCstButton Read fSoloBt Write fSoloBt;
    property MuteBt:TBrCstButton Read fMuteBt Write fMuteBt;  
    Property TypeTrack:TTrackType Read fTypeTrack Write SetTypeTrack Default TtWav;
    Property TracksIndex:Integer Read fIndex Write SetIndex;
    Property Active:Boolean Read fActive Write SetActive;
  end;

  {>>TRACKS}
  TBrTrack=class(TCollectionItem)
  Private
    fOnChange: TNotifyEvent;  
    fBrPanelTrack:TBrPanelTrack;
    fCollection  : TCollection;
  protected
    function GetDisplayName: string; override;  
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
    property Collection : TCollection  read fCollection write fCollection;
  public
    Owner : TPersistent;
    procedure Assign(Source : TPersistent); override;
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
  Published
    Property BrPanelTrack:TBrPanelTrack Read fBrPanelTrack Write fBrPanelTrack;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;    
  end;

  {>>TRACKSCNT}
  TBrTrackCnt = class(TOwnedCollection)
  Private
    fOwner : TPersistent;
  protected
    function GetOwner: TPersistent; override;
    function GetItem(Index: integer): TBrTrack;
    procedure SetItem(Index: integer; Value: TBrTrack);
  public
    ItemIndex:Integer;
    constructor Create(AOwner: TBrowserTracks);
    function Add: TBrTrack;
    property Items[Index: integer]: TBrTrack Read GetItem Write SetItem;
  end;

    {EVENEMENTS}
    TOpen_Event = procedure(Sender: TObject) of object;
    TAcquisition_Event = procedure(Sender: TObject) of object;
    TWrite_Event = procedure(Sender: TObject) of object;
    TRead_Event = procedure(Sender: TObject) of object;
    TSolo_Event = procedure(Sender: TObject) of object;
    TMute_Event = procedure(Sender: TObject) of object;
	
  {>>BrowserTracks}
  TBrowserTracks = class(TCustomControl)
  private
    fBrPanelTitle:TBrPanelTitle;
    fBrTracksCnt:TBrTrackCnt;
    fOnOpen_Event: TNotifyEvent;
    fOnAcquisition_Event: TNotifyEvent;
    fOnWrite_Event: TNotifyEvent;
    fOnRead_Event:  TNotifyEvent;
    fOnSolo_Event:  TNotifyEvent;
    fOnMute_Event:  TNotifyEvent;
    procedure SetOnOpen_Event(Event : TNotifyEvent);
    procedure SetOnAcquisition_Event(Event : TNotifyEvent);
    procedure SetOnWrite_Event(Event : TNotifyEvent);
    procedure SetOnRead_Event(Event : TNotifyEvent);
    procedure SetOnSolo_Event(Event : TNotifyEvent);
    procedure SetOnMute_Event(Event : TNotifyEvent);    
  protected
    procedure Paint; override;
    procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property BrPanelTitle:TBrPanelTitle Read fBrPanelTitle Write fBrPanelTitle;
    Property BrTracksCnt:TBrTrackCnt Read fBrTracksCnt Write fBrTracksCnt;
    property Open_Event: TNotifyEvent Read fOnOpen_Event Write SetOnOpen_Event;
    property Acquisition_Event: TNotifyEvent Read fOnAcquisition_Event Write SetOnAcquisition_Event;
    property Write_Event: TNotifyEvent Read fOnWrite_Event Write SetOnWrite_Event;
    property Read_Event: TNotifyEvent Read fOnRead_Event Write SetOnRead_Event;
    property Solo_Event: TNotifyEvent Read fOnSolo_Event Write SetOnSolo_Event;
    property Mute_Event: TNotifyEvent Read fOnMute_Event Write SetOnMute_Event;
    Property OnClick;
    Property OnDblClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TBrowserTracks]);
end;

{>>TITLE}
constructor TBrPanelTitle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorRectTitle:=$00935F42;
  Title:='MUSIC PRO';
  fColorTitle:=$00C5C5C5;
  SubTitle:='Browser';
  fColorSubTitle:=$0000BB00;
  DoubleBuffered:=True;
end;

destructor TBrPanelTitle.Destroy;
begin
  inherited;
end;

Procedure TBrPanelTitle.setColorTitle(Value:TColor);
Begin
  fColorTitle:=Value;
  Invalidate;
End;

Procedure TBrPanelTitle.setColorSubTitle(Value:TColor);
Begin
  fColorSubTitle:=Value;
  Invalidate;
End;

Procedure TBrPanelTitle.setColorRectTitle(Value:TColor);
Begin
  fColorRectTitle:=Value;
  Invalidate;
End;

Procedure TBrPanelTitle.SetTitle(Value:String);
Begin
  fTitle:=Value;
  Invalidate;
End;

Procedure TBrPanelTitle.SetSubTitle(Value:String);
Begin
  fSubTitle:=Value;
  Invalidate;
End;

procedure TBrPanelTitle.Resize;
Begin
  Width:=209;
  If Height<49 Then
  Height:=49;
  Invalidate;
End;

procedure TBrPanelTitle.Paint;
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
          Font.Size:=16;
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

{>>BrCstButton}
constructor TBrCstButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fPushed:=False;
  DoubleBuffered:=True;  
end;

destructor TBrCstButton.Destroy;
begin
  inherited;
end;

Procedure TBrCstButton.SetColorLine(Value:TColor);
begin
  fColorLine:=Value;
  Invalidate;
end;

Procedure TBrCstButton.SetColorTop(Value:TColor);
begin
  Self.fColorTop:=Value;
  Self.Invalidate;
end;

Procedure TBrCstButton.SetColorBottom(Value:TColor);
begin
  fColorBottom:=Value;
  Invalidate;
end;

Procedure TBrCstButton.SetCaption(Value:String);
begin
  fCaption:=Value;
  Invalidate;
end;

Procedure TBrCstButton.SetPushed(Value:Boolean);
begin
  fPushed:=Value;
  Invalidate;
end;

procedure TBrCstButton.Paint;
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

Procedure TBrCstButton.DrawBorder;
Var
  LeftColor, RightColor:TColor;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
Begin
  If Not fPushed Then
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
      Pen.Width:=2;
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

procedure TBrCstButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If Shift=[SSLeft] Then
    Begin
      fPushed:=Not fPushed;
      Invalidate;
      If Assigned(Parent) Then
      (Parent As TBrPanelTrack).MouseDown(Button,Shift,X+Left,Y+Top);
    End;
End;

procedure TBrCstButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If Not fSwitchActif Then fPushed:=False;
  Invalidate;
End;

{>>BrPanelTrack}
constructor TBrPanelTrack.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fActive:=True;
  fIndex:=0;
  ItemIndex:=-1;
  fEdit:=TEdit.Create(Self);
  With fEdit Do
    Begin
      Parent:=Self;
      CharCase:=ecUpperCase;
      Font.Size:=10;
      Text:='TRACK';
      ReadOnly:=True;
      AutoSelect:=False;
      Width:=112;
      Height:=26;
      Left:=95;
      Top:=4;
      Color:=ClBlack;
      Font.Color:=ClWhite;
      OnMouseDown:=EditMouseDown;
    End;
  fTypeTrack:=TtWav;
  CreateButton(fOpenBt,66,34,'OpenBt','O', False);
  CreateButton(fAcquisitionBt,66,1,'AcquisitionBt','A', True);
  CreateButton(fWriteBt,94,34,'WriteBt','W', False);
  CreateButton(fReadBt,122,34,'ReadBt','R', True);
  CreateButton(fSoloBt,178,34,'SoloBt','S', True);
  CreateButton(fMuteBt,150,34,'MuteBt','M', True);
end;

Procedure TBrPanelTrack.EditMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  Self.MouseDown(Button,Shift,X,Y);
End;

Procedure TBrPanelTrack.CreateButton(var Button:TBrCstButton;BtLeft,BtTop:Integer; BtName,BtCaption:String; ToSwitch:Boolean);
Begin
  Button:=TBrCstButton.Create(Self);
  With Button Do
    Begin
      Parent:=Self;
      Name:=BtName;
      SetSubComponent(True);
      Width:=28;
      Height:=28;
      Left:=BtLeft;
      Top:=BtTop;
      Caption:=BtCaption;
      SwitchActif:=ToSwitch;
      Font.Size:=14;
      Font.Style:=[FsBold];
      Button.ColorTop:=$00FFE6E1;
      Button.ColorBottom:=$00E8E8E8;
      Button.ColorLine:=$0041C9D3;
    End;
End;

destructor TBrPanelTrack.Destroy;
begin
  fEdit.Free;
  fOpenBt.Free;
  fAcquisitionBt.Free;  
  fWriteBt.Free;
  fReadBt.Free;  
  fSoloBt.Free;
  fMuteBt.Free;
  inherited;
end;

procedure TBrPanelTrack.Resize;
Begin
  Width:=209;
  Height:=65;
  Invalidate;
End;

Procedure TBrPanelTrack.SetTypeTrack(Value:TTrackType);
Begin
  fTypeTrack:=Value;
  Invalidate;
End;

Procedure TBrPanelTrack.SetIndex(Value:Integer);
Begin
  fIndex:=Value;
  Invalidate;
End;

Procedure TBrPanelTrack.SetActive(Value:Boolean);
Begin
  fActive:=Value;
  Invalidate;
End;

Procedure TBrPanelTrack.DrawTypeArea;
Var
  RectType:TRect;
Begin
  With Canvas Do
  With RectType Do
    Begin
      Left:=0;
      Right:=65;
      Top:=0;
      Bottom:=Self.Height;
      Pen.Color:=ClBlack;
      Pen.Width:=1;
      If fTypeTrack=TtMidi Then
      Brush.Color:=$0096E1FA Else
      Brush.Color:=$00ADAE93;
      Rectangle(RectType);
    End;
End;

Procedure TBrPanelTrack.DrawCircle(X,Y,Width,Height:Integer);
Var
  EllipseRect:TRect;
Begin
  With Canvas Do
  With EllipseRect Do
    Begin
      Pen.Width:=1;
      Pen.Color:=ClBlack;
      Pen.Width:=1;
      Left:=X-Width Div 2;
      Right:=X+Width Div 2;
      Top:=Y-Height Div 2;
      Bottom:=Y+Height Div 2;
      Ellipse(EllipseRect);
    End;
End;

Procedure TBrPanelTrack.DrawTypeLogo;
Const
  WavLogo='WAV';
Var
  Index,LeftLetter,TopLetter:Cardinal;
Begin
  With Self.Canvas Do
    Begin
      If fTypeTrack=TtMidi Then
        Begin
          DrawCircle(23,23,35,35);
          Brush.Color:=ClBlack;
          DrawCircle(23,13,4,4);
          DrawCircle(13,23,4,4);
          DrawCircle(33,23,4,4);
          DrawCircle(15,16,4,4);
          DrawCircle(31,16,4,4);
        End
      Else
        Begin
          Brush.Style:=BsClear;
          Font.Size:=14;
          LeftLetter:=8;
          TopLetter:=20;
          For Index:=1 To 3 Do
            Begin
              LeftLetter:=LeftLetter+20*(Index-1);
              If Index=3 Then LeftLetter:=LeftLetter-25;
              TopLetter:=TopLetter-5*(Index-1);
              If Index=3 Then TopLetter:=TopLetter+5;
              TextOut(LeftLetter,TopLetter,WavLogo[index]);
            End;
        End;
     If fActive Then
     Brush.Color:=ClLime
     Else Brush.Color:=ClRed;
     DrawCircle(23,55,10,10);
     Brush.Style:=BsClear;
     TextOut(60-TextWidth(IntToStr(Self.fIndex)),40-TextHeight(IntToStr(Self.fIndex)) Div 2,IntToStr(Self.fIndex));
    End;
End;

procedure TBrPanelTrack.Paint;
Var
  Index:Cardinal;
Begin
  With Canvas Do
    Begin
      Pen.Color:=ClBlack;
      Brush.Color:=$00C9CAB7;
      Rectangle(Self.ClientRect);
      DrawTypeArea;
      Pen.Color:=ClWhite;
      For Index:=1 To Self.Height Do
      If Index Mod 5 = 0  Then
        Begin
          MoveTo(Pen.Width,Index);
          LineTo(65-Pen.Width,Index);
          MoveTo(65,Index);
          LineTo(Width-Pen.Width,Index);
        End;
      DrawTypeLogo;
    End;
End;

procedure TBrPanelTrack.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Begin
  InHerited;
  If Assigned(Parent)Then
  (Parent As TBrowserTracks).MouseDown(Button,Shift,X+Left,Y+Top);
End;

{>>TRACKS}
constructor TBrTrack.Create(ACollection: TCollection);
begin
  fCollection := (ACollection as TBrTrackCnt);
  inherited Create(ACollection);
  Owner:=ACollection.Owner;
  fBrPanelTrack:=TBrPanelTrack.Create(fCollection.Owner  As TComponent);
  With fBrPanelTrack Do
    Begin
      Parent:=(fCollection.Owner As TBrowserTracks);
      SetSubComponent(True);
      Owner:=ACollection.Owner;
      With (Owner As TBrowserTracks) Do
        Begin
          fAcquisitionBt.OnClick:=fOnAcquisition_Event;
          fOpenBt.OnClick:=fOnOpen_Event;
          fReadBt.OnClick:=fOnRead_Event;
          fWriteBt.OnClick:=fOnWrite_Event;
          fSoloBt.OnClick:=fOnSolo_Event;
          fMuteBt.OnClick:=fOnMute_Event;
        End;
    End;
end;

destructor TBrTrack.Destroy;
begin
  fBrPanelTrack.Free;
  inherited Destroy;
end;

procedure TBrTrack.AssignTo(Dest: TPersistent);
begin
  if Dest is TBrTrack then
    with TBrTrack(Dest) do begin
      fBrPanelTrack:=self.fBrPanelTrack;
      fCollection:=Self.fCollection;
      fOnChange := self.fOnChange;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TBrTrack.Assign(Source : TPersistent);
begin
  if source is TBrTrack then
     with TBrTrack(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;

procedure TBrTrack.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

function TBrTrack.GetDisplayName: string;
begin
  result := 'TBrTrack['+IntToStr(Self.Index)+'] ';
end;

{>>TRACKSCNT}
constructor TBrTrackCnt.Create(AOwner: TBrowserTracks);
begin
  fOwner := AOwner;
  inherited Create(AOwner,TBrTrack);
end;

function TBrTrackCnt.Add:TBrTrack;
begin
  Result := TBrTrack(inherited Add);
end;

function TBrTrackCnt.GetItem(Index: integer):TBrTrack;
begin
  Result := TBrTrack(inherited Items[Index]);
end;

procedure TBrTrackCnt.SetItem(Index: integer; Value:TBrTrack);
begin
  inherited SetItem(Index, Value);
end;

function TBrTrackCnt.GetOwner: TPersistent;
begin
  Result := fOwner;
end;

{>>BrowserTracks}
constructor TBrowserTracks.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RegisterClass(TBrPanelTitle);
  RegisterClass(TBrPanelTrack);
  fBrPanelTitle:=TBrPanelTitle.Create(Self);
  With fBrPanelTitle Do
    Begin
      Parent:=Self;
      Top:=0;
      Left:=0;
      Width:=209;
      Height:=49;
    End;
  fBrTracksCnt:=TBrTrackCnt.Create(Self);
  DoubleBuffered:=True;
end;

destructor TBrowserTracks.Destroy;
begin
  fBrTracksCnt.Free;
  fBrPanelTitle.Free;
  inherited;
end;

procedure TBrowserTracks.Resize;
begin
  inherited;
  Width:=209;
  If fBrTracksCnt.Count<=0 Then
  Height:=49;
end;

procedure TBrowserTracks.Paint;
Var
  IndexTracks:Integer;
begin
  inherited;
  If fBrTracksCnt.Count>0 Then
    Begin
      For IndexTracks:=0 To fBrTracksCnt.Count-1 Do
      With fBrTracksCnt.Items[IndexTracks].fBrPanelTrack Do
      Top:=49+IndexTracks*65;
      Self.Height:=49+fBrTracksCnt.Count*65;
    End;
end;

Procedure TBrowserTracks.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  inherited;
  fBrTracksCnt.ItemIndex:=-1;
  If fBrTracksCnt.Count>0 Then
  fBrTracksCnt.ItemIndex:=(Y-fBrPanelTitle.Height) Div fBrTracksCnt.Items[0].fBrPanelTrack.Height;
End;

procedure TBrowserTracks.SetOnOpen_Event(Event : TNotifyEvent);
Var
  Index:Cardinal;
Begin
  fOnOpen_Event := Event;
  If fBrTracksCnt.Count>=0 Then
  For Index:=0 To (fBrTracksCnt.Count-1) Do
  fBrTracksCnt.Items[Index].BrPanelTrack.fOpenBt.OnClick:= fOnOpen_Event;
End;

procedure TBrowserTracks.SetOnAcquisition_Event(Event : TNotifyEvent);
Var
  Index:Cardinal;
Begin
  fOnAcquisition_Event := Event;
  If fBrTracksCnt.Count>=0 Then
  For Index:=0 To (fBrTracksCnt.Count-1) Do
  fBrTracksCnt.Items[Index].BrPanelTrack.fAcquisitionBt.OnClick:= fOnAcquisition_Event;
End;

procedure TBrowserTracks.SetOnWrite_Event(Event : TNotifyEvent);
Var
  Index:Cardinal;
Begin
  fOnWrite_Event := Event;
  If fBrTracksCnt.Count>=0 Then
  For Index:=0 To (fBrTracksCnt.Count-1) Do
  fBrTracksCnt.Items[Index].BrPanelTrack.fWriteBt.OnClick:= fOnWrite_Event;
End;

procedure TBrowserTracks.SetOnRead_Event(Event : TNotifyEvent);
Var
  Index:Cardinal;
Begin
  fOnRead_Event := Event;
  If fBrTracksCnt.Count>=0 Then
  For Index:=0 To (fBrTracksCnt.Count-1) Do
  fBrTracksCnt.Items[Index].BrPanelTrack.fReadBt.OnClick:= fOnRead_Event;
End;

procedure TBrowserTracks.SetOnSolo_Event(Event : TNotifyEvent);
Var
  Index:Cardinal;
Begin
  fOnSolo_Event := Event;
  If fBrTracksCnt.Count>=0 Then
  For Index:=0 To (fBrTracksCnt.Count-1) Do
  fBrTracksCnt.Items[Index].BrPanelTrack.fSoloBt.OnClick:= fOnSolo_Event;
End;

procedure TBrowserTracks.SetOnMute_Event(Event : TNotifyEvent);
Var
  Index:Cardinal;
Begin
  fOnMute_Event := Event;
  If fBrTracksCnt.Count>=0 Then
  For Index:=0 To (fBrTracksCnt.Count-1) Do
  fBrTracksCnt.Items[Index].BrPanelTrack.fMuteBt.OnClick:= fOnMute_Event;
End;

end.
