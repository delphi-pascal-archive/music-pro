{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit BrowserMidi;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics, Menus, Dialogs;

  
Type

  {>>TITLE}
  TBrowserMidiTitle = class(TCustomControl)
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

{>>TSoundFont}
 TSoundFont = class(TCollectionItem)
  private
    fFileName: string;
    fName: string;	
    fBank:     integer;
    fOnChange: TNotifyEvent;
  protected
    procedure AssignTo(Dest : TPersistent); override;
    procedure Change; virtual;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source : TPersistent); override;
  published
    Property Bank:Integer Read fBank Write fBank;
    Property FileName:String Read fFileName Write fFileName;
    Property Name:String Read fName Write fName;
    property OnChange    :TNotifyEvent read fOnChange write fOnChange;
  end;

{>>TSoundFontCnt}
  TSoundFontCnt = class(TOwnedCollection)
  protected
    function GetItem(Index: integer): TSoundFont;
    procedure SetItem(Index: integer; Value: TSoundFont);
  public
    constructor Create(AOwner: TPersistent);
    function Add: TSoundFont;
    property Items[Index: integer]: TSoundFont Read GetItem Write SetItem;
  end;
  
  TSndFntClick_Event=TNotifyEvent;
  TInstrClick_Event=TNotifyEvent;  

{>>TBrowserMidi}
  TBrowserMidi = class(TCustomControl)
  private
    fSoundFont:TSoundFontCnt;
    fBrowserMidiTitle:TBrowserMidiTitle;
    fColorCategories:TColor;
    fColorSndFont:TColor;
    fColorInstrType:TColor;
    fColorInstr:TColor;
    fColorSelected:TColor;
    SndFontShowed:Boolean;
    InstrShowed:Integer;
    fOnInstrClick_Event:TInstrClick_Event;
    fOnSndFntClick_Event:TSndFntClick_Event;	
    Procedure Set_ColorCategories(Value:TColor);
    Procedure Set_ColorSndFont(Value:TColor);
    Procedure Set_ColorInstrType(Value:TColor);
    Procedure Set_ColorInstr(Value:TColor);
    Procedure Set_ColorSelected(Value:TColor);
    Procedure Draw_Panel(Caption:String; ATop:Integer;AColor:TColor);
  protected
    procedure Paint; override;
    procedure Resize;  override;  
    procedure MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer); override;
  public
    SoundFontSelected:Integer;
    InstrumentSelected:Integer;
    Function InstrToString(Instrument:Byte):String;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Color;
    Property ColorCategories:TColor Read fColorCategories Write Set_ColorCategories;
    Property ColorSndFont:TColor Read fColorSndFont Write Set_ColorSndFont;
    Property ColorInstr:TColor Read fColorInstr Write Set_ColorInstr;
    Property ColorInstrType:TColor Read fColorInstrType Write Set_ColorInstrType;
    Property ColorSelected:TColor Read fColorSelected Write Set_ColorSelected;
    Property SoundFont:TSoundFontCnt Read fSoundFont Write fSoundFont;
    Property BrowserMidiTitle:TBrowserMidiTitle Read fBrowserMidiTitle Write fBrowserMidiTitle;
    property OnSndFntClick_Event:TSndFntClick_Event Read fOnSndFntClick_Event Write fOnSndFntClick_Event;
    Property OnInstrClick_Event:TInstrClick_Event Read fOnInstrClick_Event Write fOnInstrClick_Event;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;	
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TBrowserMidi]);
end;

{>>TITLE}
constructor TBrowserMidiTitle.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fColorRectTitle:=ClSilver;
  Title:='MUSIC PRO';
  fColorTitle:=$0012526D;
  SubTitle:='Midi Browser';
  fColorSubTitle:=$001A7297;
end;

destructor TBrowserMidiTitle.Destroy;
begin
  inherited;
end;

Procedure TBrowserMidiTitle.setColorTitle(Value:TColor);
Begin
  fColorTitle:=Value;
  Invalidate;
End;

Procedure TBrowserMidiTitle.setColorSubTitle(Value:TColor);
Begin
  fColorSubTitle:=Value;
  Invalidate;
End;

Procedure TBrowserMidiTitle.setColorRectTitle(Value:TColor);
Begin
  fColorRectTitle:=Value;
  Invalidate;
End;

Procedure TBrowserMidiTitle.SetTitle(Value:String);
Begin
  fTitle:=Value;
  Invalidate;
End;

Procedure TBrowserMidiTitle.SetSubTitle(Value:String);
Begin
  fSubTitle:=Value;
  Invalidate;
End;

procedure TBrowserMidiTitle.Resize;
Begin
  Width:=163;
  If Height<49 Then
  Height:=49;
  Invalidate;
End;

procedure TBrowserMidiTitle.Paint;
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
          Left:=0;
          Right:=Self.Width;
          Top:=0;
          Bottom:=49;
          Brush.Color:=Self.fColorRectTitle;
          Pen.Color:=ClBlack;
          Pen.Width:=4;
          Rectangle(RectTitle);

          Font.Name:='ARIAL';
          Font.Size:=14;
          Font.Color:=fColorTitle;
          LeftString:=Round(0.05*Self.Width);
          TopString:=Pen.Width;
          TextOut(LeftString,TopString,fTitle);

          Font.Name:='Comic Sans MS';
          Font.Size:=11;
          Font.Color:=Self.fColorSubTitle;
          WidthString:=TextWidth(fSubTitle);
          HeightString:=TextHeight(fSubTitle);
          LeftString:=Self.Width-WidthString-5;
          TopString:=Bottom-Pen.Width-HeightString;
          TextOut(LeftString,TopString,fSubTitle);
        End;
    End
End;

{>>TBrowserMidi}
constructor TBrowserMidi.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  fSoundFont:=TSoundFontCnt.Create(Self);
  fBrowserMidiTitle:=TBrowserMidiTitle.Create(Self);
  RegisterClass(TBrowserMidiTitle); 
  With fBrowserMidiTitle Do
    Begin
     Parent:=Self;
     Top:=0;
     Left:=0;
     Height:=49;
    End;
  InstrShowed:=-1;
  SoundFontSelected:=-1;
  InstrumentSelected:=-1;
  SndFontShowed:=False;
  Color:=$00757575;
  fColorCategories:=$00A3A3A3;
  fColorSndFont:=$00CCCCD7;
  fColorInstr:=$00CCCCD7;
  fColorInstrType:=$00A3A3B6;
  fColorSelected:=$00CAEBF9;
end;

destructor TBrowserMidi.Destroy;
begin
  fSoundFont.Free;
  fBrowserMidiTitle.Free;
  inherited;
end;  

procedure TBrowserMidi.Set_ColorCategories(Value: TColor);
begin
  fColorCategories:=Value;
  Self.Invalidate;
end;

procedure TBrowserMidi.Set_ColorSndFont(Value: TColor);
begin
  fColorSndFont:=Value;
  Self.Invalidate;
end;
procedure TBrowserMidi.Set_ColorInstrType(Value: TColor);
begin
  fColorInstrType:=Value;
  Self.Invalidate;
end;
procedure TBrowserMidi.Set_ColorInstr(Value: TColor);
begin
  fColorInstr:=Value;
  Self.Invalidate;
end;

procedure TBrowserMidi.Set_ColorSelected(Value: TColor);
begin
  fColorSelected:=Value;
  Self.Invalidate;
end;

Function TBrowserMidi.InstrToString(Instrument:Byte):String;
const
  InstrName: array [0..15] of array [0..7] of string =
	(('PIANO A QUEUE','PIANO CONCERT','PIANO ELECT','PIANO HONKY-TON',
	'PIANO ELECT 1','PIANO ELECT 2','CLAVECIN','CLAVICORDE'),

	('CÉLESTA','CARILLON','BOÎTE À MUSIQUE','VIBRAPHONE',
	'MARIMBA','XYLOPHONE','CLOCHES','TYMPANON'),

	('ORGUE HAMMOND','ORGUE PERCUSSIF','ORGUE ELECT','GRAND ORGUE',
	'HARMONIUM','ACCORDÉON','HARMONICA','BANDONEON'),

	('GUITARE CLASS','GUITARE FOLK','GUITARE ELECT JAZZ','GUITARE ELECT CLAIRE',
	'GUITARE MUTED','GUITARE SATURÉE','GUITARE DIST','HARMONIQUES'),

	('BASSE ACOUST','BASSE  ELECT - DOIGT','BASSE  ELECT - MED','BASSE FRETLESS',
	'BASSE SLAP 1','BASSE SLAP 2','BASSE SYNTHÉ 1','BASSE SYNTHÉ 2'),

	('VIOLON','VIOLE','VIOLONCELLE','CONTREBASSE',
	'CORDES TREMOLO','CORDES PIZZICATO','HARPE','TIMBALES'),

	('QUARTET CORDES 1','QUARTET CORDES 2','CORDES SYNTHÉ 1','CORDES SYNTHÉ 2',
	'VOIX AAHS','VOIX OOHS','VOIX SYNTHÉ','COUP D''ORCHESTRE'),

	('TROMPETTE','TROMBONE','TUBA','TROMPETTE BOUCHÉE',
	'CORS','ENSEMBLE DE CUIVRES','CUIVRES SYNTHÉ 1','CUIVRES SYNTHÉ 2'),

	('SAXO SOPRANO','SAXO ALTO','SAXO TÉNOR','SAXO BARYTON',
	'SAXO HAUTBOIS','CORS ANGLAIS','BASSON','CLARINETTE'),

	('PICCOLO','FLÛTE','FLÛTE À BEC','FLÛTE DE PAN',
	'BOUTEILLE','SHAKUHACHI','SIFFLET','OCARINA'),

	('SIGNAL CARRÉ','SIGNAL TRIANGLE','ORGUE À VAPEUR','CHIFF',
	'CHARANG','VOIX SOLO','QUINTE','BASSE'),

	('NEW AGE','WARM','POLYSYNTH','CHŒUR',
	'ARCHET','MÉTALLIQUE','HALO','SWEEP'),

	('PLUIE','BANDE SON','CRISTAL','ATMOSPHÈRE',
	'BRIGHTNESS','GOBLINS','ECHOS','SCIE-FIC'),

	('SITAR','BANJO','SHAMISEN','KOTO',
	'KALIMBA','CORNEMUSE','VIOLON FOLKLORIQUE','SHANAI'),

	('SONNERIE','AGOGO','PERCUS. ACIER','WOODBLOCK',
	'TAIKO','TOM MÉLODIQUE','PERCUS. SYNTHÉ','CYMBALE INVERSÉE'),

	('CORDES GUITARES','RESPIRATION','RIVAGE','CHANT D''OISEAUX',
	'SONNERIE TÉLÉPHONE','HÉLICOPTÈRE','APPLAUDISSEMENTS','COUP DE FEU'));
Begin
  Result:=InstrName[Instrument Div 8, Instrument Mod 8];
End;        
        
procedure TBrowserMidi.Resize;
Begin
  InHerited;
  Width:=163;
End;

procedure TBrowserMidi.Paint;
const
  TypeInstrName: array [0..15] of string =
        ('PIANOS','PERCUSSIONS CHROMATIQUES','ORGUES','GUITARES',
        'BASSES','CORDES','ENSEMBLES ET CHOEURS','CUIVRES',
        'INSTRUMENTS À ANCHES','FLUTES','LEAD SYNTHÉTISEURS','PAD SYNTHÉTISEURS',
        'EFFETS SYNTHÉTISEURS','INSTRUMENTS ETHNIQUES','PERCUSSIONS','EFFETS SONORES');
Var
  IndexPn,IndexInstr,TopRect:Integer;
  ColorBkGn:TColor;
Begin
  InHerited;
  With Canvas Do
    Begin
      Brush.Style:=BsClear;
      Brush.Color:=ClBlack;
      Rectangle(ClientRect);
      TopRect:=fBrowserMidiTitle.Height;
      Draw_Panel('SOUNDFONT',TopRect,fColorCategories);
      If (fSoundFont.Count>0) And (SndFontShowed) Then
      For IndexPn:=0 To (fSoundFont.Count-1) Do
	Begin
	  Inc(TopRect,19); 
          If SoundFontSelected<>IndexPn Then ColorBkGn:=fColorSndFont
          Else ColorBkGn:=fColorSelected;
	  Draw_Panel(fSoundFont.Items[IndexPn].Name,TopRect,ColorBkGn);
	End;

      Inc(TopRect,19);
      Draw_Panel('INSTRUMENTS',TopRect,fColorCategories);
      For IndexPn:=0 To 15 Do
	Begin
	  Inc(TopRect,19);
	  Draw_Panel(TypeInstrName[IndexPn],TopRect,fColorInstrType);
          If InstrShowed=IndexPn Then
          For IndexInstr:=0 To 7 Do
	    Begin
	      Inc(TopRect,19);
              If InstrumentSelected<>IndexInstr+IndexPn*8 Then ColorBkGn:=fColorSndFont
              Else ColorBkGn:=fColorSelected;
	      Draw_Panel(InstrToString(IndexPn*8+IndexInstr),TopRect,ColorBkGn);
	    End;
	End;
      Height:=TopRect+19;  
    End;
End;

Procedure TBrowserMidi.Draw_Panel(Caption:String; ATop:Integer; AColor:TColor);
Var
  Rect:TRect;
  LeftText,TopText:Integer;
Begin
  With Canvas Do
  Begin
    With Rect Do
      Begin
        Left:=0;
	Right:=Width;
	Top:=ATop;
	Bottom:=Top+19;
	LeftText:=((Right-Left)-TextWidth(Caption)) Div 2;
	TopText:=ATop+((Bottom-Top)-TextHeight(Caption)) Div 2;
      End;
    Brush.Color:=AColor;
    Rectangle(Rect);
    Brush.Style:=BsClear;
    Font.Color:=ClBlack;
    Font.Name:='Arial';
    Font.Size:=8;
    TextOut(LeftText,TopText,Caption);
  End;
End;

procedure TBrowserMidi.MouseDown(Button: TMouseButton;Shift: TShiftState; X, Y: Integer);
Var
  DecY, DecTitle:Integer;
Begin
  InHerited;
  If SSLeft In Shift Then
    Begin
      DecTitle:=fBrowserMidiTitle.Height;
      If (Y<19+DecTitle) And (fSoundFont.Count>0) Then SndFontShowed:=Not SndFontShowed;
      If Not SndFontShowed Then DecY:=38+DecTitle Else DecY:=44+DecTitle+fSoundFont.Count*19;
      IF ssDouble In Shift Then
      If (Y>19+DecTitle) And (Y<DecY-19) Then
        Begin
    	  SoundFontSelected:=(Y-22-DecTitle) Div 19;
	  If Assigned(fOnSndFntClick_Event) Then fOnSndFntClick_Event(Self);
	End;
          
      If (InstrShowed=-1) And (Y>30+DecTitle) Then InstrShowed:=(Y-DecY) Div 19;
      If (InstrShowed<>-1) Then
	Begin
	  If (Y>DecY) And (Y<DecY+(InstrShowed+1)*19) Then InstrShowed:=(Y-DecY) Div  19;
	  If (Y>19+DecY+InstrShowed*19+152) Then InstrShowed:=(Y -DecY -152) Div  19;  
          IF ssDouble In Shift Then
          If (Y-DecY>(InstrShowed+1)*19) And (Y-DecY<(InstrShowed+1)*19+176) Then
	    Begin
	      InstrumentSelected:=(Y-DecY-(InstrShowed+1)*19) Div 19+InstrShowed*8;
	      If Assigned(fOnInstrClick_Event) Then fOnInstrClick_Event(Self);
	    End;
          IF (Y>DecY-19) And (Y<DecY) Then InstrShowed:=-1;
	End;
      Invalidate;
    End;
End;  

{>>TSoundFontCnt}
constructor TSoundFontCnt.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner,TSoundFont);
end;

function TSoundFontCnt.Add:TSoundFont;
begin
  Result := TSoundFont(inherited Add);
end;

function TSoundFontCnt.GetItem(Index: integer):TSoundFont;
begin
  Result := TSoundFont(inherited Items[Index]);
end;

procedure TSoundFontCnt.SetItem(Index: integer; Value:TSoundFont);
begin
  inherited SetItem(Index, Value);
end;

{>>TSoundFont}
constructor TSoundFont.Create;
begin
  inherited Create(ACollection);
end;

destructor TSoundFont.Destroy;
begin
  inherited Destroy;
end;

procedure TSoundFont.AssignTo(Dest: TPersistent);
begin
  if Dest is TSoundFont then
    with TSoundFont(Dest) do begin
      fOnChange := self.fOnChange;
      fFileName    := Self.fFileName;
      fName:=Self.fName;
      fBank:=Self.fBank;
      Change;
    end
  else
    inherited AssignTo(Dest);
end;

procedure TSoundFont.Assign(Source : TPersistent);
begin
  if source is TSoundFont then
     with TSoundFont(Source) do
       AssignTo(Self)
  else
     inherited Assign(source);
end;


procedure TSoundFont.Change;
begin
  if Assigned(fOnChange) then
    fOnChange(Self);
end;

End.