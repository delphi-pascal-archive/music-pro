{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit Piano;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs;

type

  TOnNote_Event  = procedure(const Note: byte) of object;
  
  TPiano = class(TCustomControl)
  private
    fOctave:Integer;
    fHeightNote:Integer;
    NotePressed:Integer;
    NotesPlayed: array of Byte;
    fOnNoteIn_Event: TOnNote_Event;
    fOffNoteIn_Event: TOnNote_Event;
    Procedure Set_Octave(Value:Integer);
    Procedure Set_HeightNote(Value:Integer);
    function NumberOfNote(Value: integer):integer;
  protected
    procedure Resize; override;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer); override;
  public
    NotesPressed:Boolean;
    Procedure Add_NoteOn(ANote:Byte);
    Procedure Add_NoteOff(ANote:Byte);
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Octave:Integer Read fOctave Write Set_Octave;
    Property HeightNote:Integer Read fHeightNote Write Set_HeightNote;
    property OnNoteIn: TOnNote_Event Read fOnNoteIn_Event Write fOnNoteIn_Event;
    property OffNoteIn: TOnNote_Event Read fOffNoteIn_Event Write fOffNoteIn_Event;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TPiano]);
end;

constructor TPiano.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  Initialize(NotesPlayed);
  NotesPressed:=True;
  NotePressed:=-1;
  Color:=ClGray;
  HeightNote:=25;
end;

destructor TPiano.Destroy;
begin
  Finalize(NotesPlayed);
  inherited;
end;  

procedure TPiano.Set_Octave(Value:Integer);
Begin
  fOctave:=Value;
  If (fOctave>10) Then fOctave:=10;
  If (fOctave<0) Then fOctave:=0;
  Invalidate;
End;

procedure TPiano.Set_HeightNote(Value:Integer);
Begin
  fHeightNote:=Value;
  Invalidate;
End;

Procedure TPiano.Add_NoteOn(ANote:Byte);
Begin
  SetLength(NotesPlayed,High(NotesPlayed)+2);
  NotesPlayed[High(NotesPlayed)]:=ANote;
  Invalidate;
End;

function TPiano.NumberOfNote(Value: integer):integer;
var
  IndexNote: cardinal;
begin
  Result   := -1;
  if High(NotesPlayed) > -1 then
    for IndexNote := 0 to High(NotesPlayed) do
    begin
      if NotesPlayed[IndexNote] = Value then
      Result:= IndexNote;
    end;
end;

Procedure TPiano.Add_NoteOff(ANote:Byte);
var
  PosNote:  integer;
  IndexNote: cardinal;
begin
  PosNote:=NumberOfNote(ANote);
  if (High(NotesPlayed)<=0) Then
    Begin
      SetLength(NotesPlayed,0);
      Invalidate;
      Exit;
    End;  
  If (PosNote>-1) then
  begin
    for IndexNote :=PosNote to (High(NotesPlayed) - 1) do
    NotesPlayed[IndexNote]:=NotesPlayed[IndexNote+1] ;
    SetLength(NotesPlayed, High(NotesPlayed));
    Invalidate;
  end;
End;

procedure TPiano.Resize;
begin
  inherited;
  Self.Width  := 140;
end;

procedure TPiano.Paint;
Const
  NotesName: Array [0..6] Of String =
           ('C','D','E','F','G','A','B');
  SharpNotesName: Array [0..6] Of String =
           ('C#','D#','E#','F#','G#','A#','B#');
  ValueNote:Array[0..6] Of Byte=(0,2,4,5,7,9,11);
  ValueSharpNote:Array[0..6] Of Byte=(1,3,0,6,8,10,0);
var
  LastIndex,IndexLine,LeftText,TopText,OctLine,OctNote,NoteLine,IndexNote:Integer;
  Rect:TRect;
  NoteName:String;
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
begin
  inherited;
  with Self.Canvas do
  begin
    Brush.Color:=ClBlack;
    Rectangle(ClientRect);
    If fOctave=10 Then LastIndex:=12
    Else LastIndex:=14;
    Height:=LastIndex* HeightNote;
    Pen.Color   := ClBlack;
    Font.Style:=[FSBold];
    Font.Color := ClBlack;
    Pen.Width:=0;
    for IndexLine := 0 to (LastIndex-1) do
    begin
      OctLine:=IndexLine Div 7+fOctave;
      OctNote:=IndexLine Mod 7;
      NoteLine:=ValueNote[OctNote]+12*OctLine;
      If (NoteLine=NotePressed) Then
      Brush.Color := ClGray
      Else
        Begin
          Brush.Color := $00EAFFFF;
          If High(NotesPlayed)>-1 then
          For IndexNote := 0 to High(NotesPlayed) do
          If NotesPlayed[IndexNote]=NoteLine Then
          Brush.Color := ClGray;
        End;
      With Rect Do
        Begin
          Left   := 0;
          Right  := Width;
          Top    := IndexLine * HeightNote;
          Bottom := Rect.Top + HeightNote;
        End;
      Rectangle(Rect);
      NoteName:=NotesName[OctNote]+'--'+IntToStr(OctLine);
      LeftText := Round(0.75 * Self.Width);
      TopText  := (HeightNote - TextHeight(NoteName)) div 2 + IndexLine * HeightNote;
      TextOut(LeftText, TopText, NoteName);
    End;         
    Brush.Color := ClBlack;
    Font.Color := ClWhite;
    for IndexLine := 0 to (LastIndex-1) do
    begin
      OctLine:=IndexLine Div 7+fOctave;
      OctNote:=IndexLine Mod 7;
      If (OctLine=11) And (OctNote=4) Then Break;
      NoteName:=SharpNotesName[OctNote]+'--'+IntToStr(OctLine);
      if (SharpNotesName[OctNote]<> 'E#')
      And (SharpNotesName[OctNote] <> 'B#') then
      begin
        NoteLine:=ValueSharpNote[OctNote]+12*OctLine;
        If NoteLine=NotePressed Then
        Brush.Color := ClGray
        Else
          Begin
            Brush.Color := ClBlack;
            If High(NotesPlayed)>-1 then
            For IndexNote := 0 to High(NotesPlayed) do
            If NotesPlayed[IndexNote]=NoteLine Then
            Brush.Color := ClGray;
          End;   
        With Rect Do
          Begin
            Left   := 0;
            Right  := Round(0.5 * Self.Width);
            Top    := IndexLine * HeightNote + Round(0.7 * HeightNote);
            Bottom := (IndexLine + 1) * HeightNote + Round(0.3 * HeightNote);
          End;
        Rectangle(Rect);
        LeftText := Round(0.2 * Self.Width);
        TopText  := (IndexLine + 1) *HeightNote - TextHeight(NoteName) div 2;
        TextOut(LeftText, TopText, NoteName);
      end;
    end;
    Pen.Width:=4;
    UpperCorner[0]:=Point(Width,0);
    UpperCorner[1]:=Point(0,0);
    UpperCorner[2]:=Point(0,Height);
    LowerCorner[0]:=Point(0,Height);
    LowerCorner[1]:=Point(Width,Height);
    LowerCorner[2]:=Point(Width,0);
    Brush.Color:=$005F5F5F;
    Pen.Color:=$005F5F5F;
    Polyline(UpperCorner);
    Brush.Color:=ClWhite;
    Pen.Color:=ClWhite;
    Polyline(LowerCorner);
  End;
end;

procedure TPiano.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Const
  ValueNote:Array[0..6] Of Byte=(0,2,4,5,7,9,11);
  ValueSharpNote:Array[0..6] Of Byte=(1,3,0,6,8,10,0);
var
  NumNote,NumOctave,TypeNote,IndexLine,LastIndex: Integer;
begin
  inherited;
  NotePressed:=-1;
  if X > (0.5*Width) then
    begin
      NumNote:=Y Div fHeightNote;
      NumOctave:= NumNote Div 7 + fOctave;
      TypeNote := NumNote - 7*(NumNote Div 7);
      NotePressed:=ValueNote[TypeNote]+12*NumOctave;
    end
  else
    begin
      If fOctave=10 Then LastIndex:=12
      Else LastIndex:=14;
      For IndexLine:=0 To LastIndex Do
      If (Y>=IndexLine * HeightNote + Round(0.7 * HeightNote)) And
      (Y<=(IndexLine + 1) * HeightNote + Round(0.3 * HeightNote)) Then
      Begin
        NumNote:= Trunc((Y - 0.6 * fHeightNote) / fHeightNote);
        NumOctave:= NumNote Div 7 + fOctave;
        TypeNote := NumNote - 7*(NumNote Div 7);
        If (TypeNote = 2) Or (TypeNote = 6) Then Exit;        
        NotePressed:=ValueSharpNote[TypeNote]+12*NumOctave;
      End;
    End;
  IF NotePressed=-1 Then Exit;
  if (Assigned(fOnNoteIn_Event)) and (NotesPressed = True) then
  fOnNoteIn_Event(NotePressed);  
  Invalidate;
end;

procedure TPiano.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: integer);
Const
  ValueNote:Array[0..6] Of Byte=(0,2,4,5,7,9,11);
  ValueSharpNote:Array[0..4] Of Byte=(1,3,6,8,10);
begin
  inherited;
  if (Assigned(fOffNoteIn_Event)) and (NotesPressed = True) then
  fOffNoteIn_Event(NotePressed);
  NotePressed:=-1;
  Invalidate;     
end;

End.

