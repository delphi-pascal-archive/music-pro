{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit DrumSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs;

type

  TOnNote_Event = procedure(Sender: TObject; ANote: byte) of object;
  TOnSilence_Event = procedure(Sender: TObject) of object;
  TTouch = (Nothing, HitHat, BassDrum, FloorTom, Snare, RideCymbal, CrashCymbal, TomFirst, TomSecond);

  TDrum = record
    Key:  char;
    Note: byte;
  end;

  TDrumSet = class(TCustomControl)
  private
    fHitHat:     TDrum;
    fBassDrum:   TDrum;
    fFloorTom:   TDrum;
    fSnare:      TDrum;
    fRideCymbal: TDrum;
    fCrashCymbal: TDrum;
    fTomFirst:   TDrum;
    fTomSecond:  TDrum;
    fSpace:      char;
    fOnNoteEvent: TOnNote_Event;
    fOnSilenceEvent: TOnSilence_Event;
    fTouch:      TTouch;
    procedure Draw_Circle(X, Y, Width, SizePen, Coeff: integer; PenColor, BrushColor: TColor);
    procedure Draw_Cymbale(X, Y, Width: integer);
    procedure Draw_HitHat(X, Y, Width: integer);
    procedure Draw_Tom(X, Y, Width: integer);
    procedure Draw_FoodPedal(X, Y, Width, Height: integer);
    procedure Draw_Seat(X, Y, Width: integer);
    procedure Draw_BassDrum(X, Y, Width: integer);
    procedure Draw_DownFixation(X, Y, DimCircle, YFix: integer);
    procedure Draw_UpFixation(X, Y, DimCircle, YFix: integer);
  protected
    procedure ReSize; Override;
    procedure Paint; Override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure KeyPress(var Key: char); override;
    procedure KeyDown(var Key: word; Shift: TShiftState); override;
    procedure KeyUp(var Key: word; Shift: TShiftState); override;
  published
    property Key_HitHat: char Read fHitHat.Key Write fHitHat.Key;
    property Key_BassDrum: char Read fBassDrum.Key Write fBassDrum.Key;
    property Key_FloorTom: char Read fFloorTom.Key Write fFloorTom.Key;
    property Key_Snare: char Read fSnare.Key Write fSnare.Key;
    property Key_RideCymbal: char Read fRideCymbal.Key Write fRideCymbal.Key;
    property Key_CrashCymbal: char Read fCrashCymbal.Key Write fCrashCymbal.Key;
    property Key_TomFirst: char Read fTomFirst.Key Write fTomFirst.Key;
    property Key_TomSecond: char Read fTomSecond.Key Write fTomSecond.Key;
    property Space: char Read fSpace Write fSpace;
    property Color;
    property OnNote_Event: TOnNote_Event Read fOnNoteEvent Write fOnNoteEvent;
    property OnSilence_Event: TOnSilence_Event Read fOnSilenceEvent Write fOnSilenceEvent;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TDrumSet]);
end;


constructor TDrumSet.Create(AOwner: TComponent);
begin
  inherited;
  FOnNoteEvent := nil;
  FOnSilenceEvent := nil;
  fHitHat.Key := 'A';
  fBassDrum.Key := 'B';
  fFloorTom.Key := 'C';
  fSnare.Key := 'D';
  fRideCymbal.Key := 'E';
  fCrashCymbal.Key := 'F';
  fTomFirst.Key := 'G';
  fTomSecond.Key := 'H';
  fHitHat.Note := 42;
  fBassDrum.Note := 33;
  fFloorTom.Note := 41;
  fSnare.Note := 31;
  fRideCymbal.Note := 59;
  fCrashCymbal.Note := 49;
  fTomFirst.Note := 48;
  fTomSecond.Note := 47;
  fTouch := Nothing;
  doublebuffered  := True;
end;

destructor TDrumSet.Destroy;
begin
  inherited Destroy;
end;

procedure TDrumSet.Paint;
var
  XTouch, YTouch, WidthTouch: cardinal;
begin
  inherited;
  Draw_BassDrum(Width div 2, 1 * Height div 3, Width div 8);
  Draw_Cymbale(Width div 5, 1 * Height div 3, Width div 6);
  Draw_Cymbale(4 * Width div 5, 1 * Height div 3, Width div 6);
  Draw_HitHat(9 * Width div 10, 3 * Height div 4, Width div 6);
  Draw_Tom(4 * Width div 10, 1 * Height div 3, Width div 7);
  Draw_Tom(6 * Width div 10, 1 * Height div 3, Width div 7);
  Draw_Tom(3 * Width div 10, 3 * Height div 4, Width div 7);
  Draw_Tom(7 * Width div 10, 3 * Height div 4, Width div 6);
  Draw_FoodPedal(Width div 2, 3 * Height div 5, 5, 8);
  Draw_Seat(Width div 2, 6 * Height div 7, Width div 9);
  XTouch     := 0;
  YTouch     := 0;
  WidthTouch := Width div 10;
  case fTouch of
    HitHat:
    begin
      XTouch := 9 * Width div 10;
      YTouch := 3 * Height div 4;
    end;
    BassDrum:
    begin
      XTouch := Width div 2;
      YTouch := 1 * Height div 3;
    end;
    FloorTom:
    begin
      XTouch := 3 * Width div 10;
      YTouch := 3 * Height div 4;
    end;
    Snare:
    begin
      XTouch := 7 * Width div 10;
      YTouch := 3 * Height div 4;
    end;
    RideCymbal:
    begin
      XTouch := Width div 5;
      YTouch := Height div 3;
    end;
    CrashCymbal:
    begin
      XTouch := 4 * Width div 5;
      YTouch := Height div 3;
    end;
    TomFirst:
    begin
      XTouch := 4 * Width div 10;
      YTouch := 1 * Height div 3;
    end;
    TomSecond:
    begin
      XTouch := 6 * Width div 10;
      YTouch := 1 * Height div 3;
    end;
  end;
  if fTouch <> Nothing then
    Draw_Circle(XTouch, YTouch, WidthTouch, 1, 100, ClRed, ClRed);
end;

procedure TDrumSet.Draw_Circle(X, Y, Width, SizePen, Coeff: integer;
  PenColor, BrushColor: TColor);
var
  Rect: TRect;
begin
  Rect.Left   := Round(X - (Width div 2) * (Coeff / 100));
  Rect.Right  := Round(X + (Width div 2) * (Coeff / 100));
  Rect.Top    := Round(Y + (Width div 2) * (Coeff / 100));
  Rect.Bottom := Round(Y - (Width div 2) * (Coeff / 100));
  with Canvas do
  begin
    Pen.Width   := SizePen;
    Pen.Color   := PenColor;
    Brush.Color := BrushColor;
    Ellipse(Rect);
  end;
end;

procedure TDrumSet.Draw_Cymbale(X, Y, Width: integer);
begin
  Draw_Circle(X, Y, Width, 2, 100, ClBlack, $0033AEE3);
  Draw_Circle(X, Y, Width, 2, 90, ClBlack, $0064C1EA);
  Draw_Circle(X, Y, Width, 1, 80, ClBlack, $0001D8FE);
  Draw_Circle(X, Y, Width, 1, 50, ClBlack, $0001EBFE);
  Draw_Circle(X, Y, Width, 1, 25, ClBlack, $0002F0FD);
  Draw_Circle(X, Y, Width, 4, 5, ClBlack, ClBlack);
end;

procedure TDrumSet.Draw_HitHat(X, Y, Width: integer);
begin
  Draw_Cymbale(Round(1.02 * X), Round(1.02 * Y), Width);
  Draw_Cymbale(X, Y, Width);
end;

procedure TDrumSet.Draw_Tom(X, Y, Width: integer);
begin
  Draw_Circle(X, Y - Width div 2, Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(X, Y + Width div 2, Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(X - Width div 2, Y, Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(X + Width div 2, Y, Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(Round(X + 0.7 * Width / 2), Round(Y + 0.7 * Width / 2), Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(Round(X - 0.7 * Width / 2), Round(Y + 0.7 * Width / 2), Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(Round(X + 0.7 * Width / 2), Round(Y - 0.7 * Width / 2), Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(Round(X - 0.7 * Width / 2), Round(Y - 0.7 * Width / 2), Width, 2, 15, ClBlack, ClBlack);
  Draw_Circle(X, Y, Width, 2, 100, ClBlack, ClWhite);
  Draw_Circle(X, Y, Width, 2, 85, ClWhite, $00F2F2F2);
end;

procedure TDrumSet.Draw_FoodPedal(X, Y, Width, Height: integer);
var
  Points: array[1..4] of TPoint;
begin
  Points[1] := Point(X - Width, Y + Height);
  Points[2] := Point(Round(X - 1.4 * Width), Y - Height);
  Points[3] := Point(Round(X + 1.4 * Width), Y - Height);
  Points[4] := Point(X + Width, Y + Height);
  Canvas.Pen.Color := ClBlack;
  Canvas.Brush.Color := ClBlack;
  Canvas.Polygon(Points);
end;

procedure TDrumSet.Draw_Seat(X, Y, Width: integer);
begin
  Draw_Circle(X, Y, Width, 2, 100, ClBlack, ClBlack);
  with Canvas do
  begin
    Pen.Width   := 5;
    Pen.Color   := ClWhite;
    Brush.Color := ClWhite;
    MoveTo(x, Y - Width div 3);
    LineTo(x, Y + Width div 3);
    MoveTo(X - Width div 3, Y);
    LineTo(X + Width div 3, y);
  end;
end;

procedure TDrumSet.Draw_BassDrum(X, Y, Width: integer);
begin
  Draw_Circle(X, Y, Width, 2, 100, ClBlack, ClBlack);
  with Canvas do
  begin
    Pen.Width   := 2;
    Pen.Color   := ClBlack;
    Brush.Color := $00DADADA;
    Rectangle(X - Width div 2, Y + 3 * Width div 5, X + Width div 2, Y - 3 * Width div 5);
    Rectangle(X - Round(1.15 * Width / 2), Y + 3 * Width div 5, X - Width div 2, Y - 3 * Width div 5);
    Rectangle(X + Round(1.15 * Width / 2), Y + 3 * Width div 5, X + Width div 2, Y - 3 * Width div 5);
    Rectangle(X - Round(1.25 * Width / 2), Y + Round(2.5 * Width / 5), X -
      Round(1.15 * Width / 2), Y + Round(1.5 * Width / 5));
    Rectangle(X + Round(1.25 * Width / 2), Y + Round(2.5 * Width / 5), X +
      Round(1.15 * Width / 2), Y + Round(1.5 * Width / 5));
    Rectangle(X - Round(1.25 * Width / 2), Y - Round(2.5 * Width / 5), X -
      Round(1.15 * Width / 2), Y - Round(1.5 * Width / 5));
    Rectangle(X + Round(1.25 * Width / 2), Y - Round(2.5 * Width / 5), X +
      Round(1.15 * Width / 2), Y - Round(1.5 * Width / 5));
    MoveTo(X - Round(1.25 * Width / 2), Y - Round(2.5 * Width / 5));
    LineTo(X + Round(1.25 * Width / 2) - Pen.Width, Y - Round(2.5 * Width / 5));
    MoveTo(X - Round(1.25 * Width / 2), Y + Round(2.5 * Width / 5));
    LineTo(X + Round(1.25 * Width / 2) - Pen.Width, Y + Round(2.5 * Width / 5));
    Draw_DownFixation(X - Width div 7, Y + Round(1.5 * Width / 5), 7, Y + 3 * Width div 5);
    Draw_DownFixation(X - 2 * Width div 5, Y + Round(1.5 * Width / 5), 7, Y + 3 * Width div 5);
    Draw_DownFixation(X + Width div 7, Y + Round(1.5 * Width / 5), 7, Y + 3 * Width div 5);
    Draw_DownFixation(X + 2 * Width div 5, Y + Round(1.5 * Width / 5), 7, Y + 3 * Width div 5);
    Draw_UpFixation(X - Width div 7, Y - Round(1.5 * Width / 5), 7, Y - 3 * Width div 5);
    Draw_UpFixation(X - 2 * Width div 5, Y - Round(1.5 * Width / 5), 7, Y - 3 * Width div 5);
    Draw_UpFixation(X + Width div 7, Y - Round(1.5 * Width / 5), 7, Y - 3 * Width div 5);
    Draw_UpFixation(X + 2 * Width div 5, Y - Round(1.5 * Width / 5), 7, Y - 3 * Width div 5);
  end;
end;

procedure TDrumSet.Draw_DownFixation(X, Y, DimCircle, YFix: integer);
begin
  Draw_Circle(X, Y, DimCircle, 1, 100, ClBlack, $00DADADA);
  with Canvas do
  begin
    MoveTo(X, Y + DimCircle div 2);
    LineTo(Round(0.995 * X), YFix);
    MoveTo(X, Y + DimCircle div 2);
    LineTo(X, YFix);
    MoveTo(X, Y + DimCircle div 2);
    LineTo(Round(1.005 * X), YFix);
  end;
end;

procedure TDrumSet.Draw_UpFixation(X, Y, DimCircle, YFix: integer);
begin
  Draw_Circle(X, Y, DimCircle, 1, 100, ClBlack, $00DADADA);
  with Canvas do
  begin
    MoveTo(X, Y - DimCircle div 2);
    LineTo(Round(0.995 * X), YFix);
    MoveTo(X, Y - DimCircle div 2);
    LineTo(X, YFix);
    MoveTo(X, Y - DimCircle div 2);
    LineTo(Round(1.005 * X), YFix);
  end;
end;

procedure TDrumSet.ReSize;
begin
  InHerited;
  Width  := 537;
  Height := 201;
end;

procedure TDrumSet.KeyPress(var Key: char);
begin
  inherited KeyPress(Key);
  if (Key = fSpace) then
    fOnSilenceEvent(Self);
  if (Key = Self.fHitHat.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fHitHat.Note);
  if (Key = fBassDrum.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fBassDrum.Note);
  if (Key = fFloorTom.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fFloorTom.Note);
  if (Key = fSnare.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fSnare.Note);
  if (Key = fRideCymbal.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fRideCymbal.Note);
  if (Key = fCrashCymbal.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fCrashCymbal.Note);
  if (Key = fTomFirst.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fTomFirst.Note);
  if (Key = fTomSecond.Key) and (Assigned(fOnNoteEvent)) then
    fOnNoteEvent(Self, fTomSecond.Note);
end;

procedure TDrumSet.KeyDown(var Key: word; Shift: TShiftState);
begin
  inherited;
  fTouch := Nothing;
  if char(Key) = fHitHat.Key then
    fTouch := HitHat;
  if char(Key) = fBassDrum.Key then
    fTouch := BassDrum;
  if char(Key) = fFloorTom.Key then
    fTouch := FloorTom;
  if char(Key) = fSnare.Key then
    fTouch := Snare;
  if char(Key) = fRideCymbal.Key then
    fTouch := RideCymbal;
  if char(Key) = fCrashCymbal.Key then
    fTouch := CrashCymbal;
  if char(Key) = fTomFirst.Key then
    fTouch := TomFirst;
  if char(Key) = fTomSecond.Key then
    fTouch := TomSecond;
  Invalidate;
end;

procedure TDrumSet.KeyUp(var Key: word; Shift: TShiftState);
begin
  inherited;
  fTouch := Nothing;
  Invalidate;
end;

end.
