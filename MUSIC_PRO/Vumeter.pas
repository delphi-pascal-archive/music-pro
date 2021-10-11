{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}
unit Vumeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics;

type
  TVumeter = class(TCustomControl)
  private
    fGradColor: TColor;
    fCursorColor: TColor;
    fLinesColor: TColor;
    fBorderColor: TColor;
    fFontColor: TColor;
    fPos: cardinal;
    procedure SetGradColor(Value: TColor);
    procedure SetCursorColor(Value: TColor);
    procedure SetLinesColor(Value: TColor);
    procedure SetBorderColor(Value: TColor);
    procedure SetFontColor(Value: TColor);
    procedure SetPos(Value: cardinal);
  protected
    { Déclarations protégées }
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure Resize; override;
  published
    property ColorGrad: TColor Read fGradColor Write SetGradColor;
    property ColorCursor: TColor Read fCursorColor Write SetCursorColor;
    property ColorLines: TColor Read fLinesColor Write SetLinesColor;
    property ColorBorder: TColor Read fBorderColor Write SetBorderColor;
    property ColorFont: TColor Read fFontColor Write SetFontColor;
    property Pos: cardinal Read fPos Write SetPos;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TVumeter]);
end;

constructor TVumeter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
end;

destructor TVumeter.Destroy;
begin
  inherited;
end;

procedure TVumeter.SetGradColor(Value: TColor);
begin
  fGradColor := Value;
  Self.Invalidate;
end;

procedure TVumeter.SetCursorColor(Value: TColor);
begin
  fCursorColor := Value;
  Self.Invalidate;
end;

procedure TVumeter.SetLinesColor(Value: TColor);
begin
  fLinesColor := Value;
  Self.Invalidate;
end;


procedure TVumeter.SetBorderColor(Value: TColor);
begin
  fBorderColor := Value;
  Self.Invalidate;
end;

procedure TVumeter.SetFontColor(Value: TColor);
begin
  fFontColor := Value;
  Self.Invalidate;
end;

procedure TVumeter.SetPos(Value: cardinal);
begin
  fPos := Value;
  if fPos > 100 then
    fPos := 100;
  Self.Invalidate;
end;

procedure TVumeter.Resize;
begin
  inherited;
  Self.Height := Round(0.7 * Self.Width);
end;

procedure TVumeter.Paint;
var
  EllipseRect:  TRect;
  AngularIndex: cardinal;
  Xo, Yo, Xf, Yf, R, LV, TV: integer;
  DecX, DecY:   extended;
begin
  inherited;
  with Self.Canvas do
  begin
    Pen.Width   := 2;
    Brush.Color := Self.fGradColor;
    Pen.Color   := Brush.Color;
    Rectangle(Self.ClientRect);

    Brush.Color := Self.fBorderColor;
    Pen.Color   := Brush.Color;
    EllipseRect.Left := Round(Self.Width * 0.1);
    EllipseRect.Right := Round(Self.Width * 0.9);
    EllipseRect.Top := Round(1 * Self.Height / 8);
    EllipseRect.Bottom := Round(10 * Self.Height / 11);
    Ellipse(EllipseRect);

    Brush.Color := Self.fLinesColor;
    Pen.Color := Brush.Color;
    Font.Color := Self.fFontColor;
    Xo := Self.Width div 2;
    Yo := Round(0.83 * Self.Height);
    R  := Self.Width div 3;
    for AngularIndex := 0 to 10 do
    begin
      Brush.Style := BsSolid;
      DecX := R * Cos(PI * (165 - 15 * AngularIndex) / 180);
      DecY := R * Sin(PI * (165 - 15 * AngularIndex) / 180);
      Xf   := Xo + Round(DecX);
      Yf   := Yo - Round(DecY);
      MoveTo(Xo, Yo);
      LineTo(Xf, Yf);
      Brush.Style := BsClear;
      LV := Xf - TextWidth(IntToStr(10 * AngularIndex)) div 2;
      TV := Yf - TextHeight(IntToStr(10 * AngularIndex));
      TextOut(LV, TV, IntToStr(10 * AngularIndex));
    end;

    Brush.Color := Self.fCursorColor;
    Pen.Color := Brush.Color;
    R    := Self.Width div 4;
    DecX := R * Cos(PI * (165 - 1.5 * Pos) / 180);
    DecY := R * Sin(PI * (165 - 1.5 * Pos) / 180);
    Xf   := Xo + Round(DecX);
    Yf   := Yo - Round(DecY);
    MoveTo(Xo, Yo);
    LineTo(Xf, Yf);

    EllipseRect.Left := Round(0.93 * Self.Width / 2);
    EllipseRect.Right := Round(1.07 * Self.Width / 2);
    EllipseRect.Top := Round(0.76 * Self.Height);
    EllipseRect.Bottom := Round(0.86 * Self.Height);
    Brush.Color := ClBlack;
    Pen.Color   := Brush.Color;
    Ellipse(EllipseRect);
  end;
end;

end.
