{AUTEUR : FRANCKY23012301 - 2008 ------- Gratuit pour une utilisation non commerciale}

unit TrackTime;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, ExtCtrls, Menus, Dialogs;

type
  TDuringOfTime   = (WholeNote, HalfNote, QuarterNote, Quavers, SixteenthNote, DemSemiQuavers);
  TCursorMode=(None,PosMode,DelimsMode);
  TTrackTime = class(TCustomControl)
  private
    fColorUp:TColor;
    fColorMiddle:TColor;
    fColorDown:TColor;
    fMin:Integer;
    fMax:Integer;
    fTime:Integer;
    fTempo:Integer;
    fDuringOfTime: TDuringOfTime;
    fZoom:Integer;
    fLeftDelim:Integer;
    fRightDelim:Integer;
    fPos:Integer;
    fDelims_Show:Boolean;
    fPos_Show:Boolean;
    fCursorMode:TCursorMode;
    Procedure SetColorUp(Value:TColor);
    Procedure SetColorMiddle(Value:TColor);
    Procedure SetColorDown(Value:TColor);
    Procedure SetMin(Value:Integer);
    Procedure SetMax(Value:Integer);
    Procedure SetTime(Value:Integer);
    Procedure SetTempo(Value:Integer);
    procedure SetDuringOfTime(Value: TDuringOfTime);    
    Procedure SetZoom(Value:Integer);
    Procedure SetLeftDelim(Value:Integer);
    Procedure SetRightDelim(Value:Integer);
    Procedure SetPos(Value:Integer);
    Procedure SetDelims_Show(Value:Boolean);
    Procedure SetPos_Show(Value:Boolean);
    Procedure SetCursorMode(Value:TCursorMode);
  protected
    procedure Paint; override;
    Procedure Resize; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer); override;    
    Procedure TimeLine_Painting;
  public 
    DuringCoef:Real;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    Function MsToDiv(MilliSeconde:Integer):Integer;
    Function DivToMs(Division:Integer):Integer;
    Property LeftDelim:Integer Read fLeftDelim Write SetLeftDelim;
    Property RightDelim:Integer Read fRightDelim Write SetRightDelim;
    Property Pos:Integer Read fPos Write SetPos;
    Property Delims_Show:Boolean Read fDelims_Show Write SetDelims_Show;
    Property Pos_Show:Boolean Read fPos_Show Write SetPos_Show;
  published
    Property CursorMode : TCursorMode Read fCursorMode Write SetCursorMode;
    Property ColorUp : TColor Read fColorUp Write SetColorUp;
    Property ColorMiddle : TColor Read fColorMiddle Write SetColorMiddle;
    Property ColorDown : TColor Read fColorDown Write SetColorDown;
    Property Min:Integer Read fMin Write SetMin;
    Property Max:Integer Read fMax Write SetMax;
    Property Time:Integer Read fTime Write SetTime;
    Property Tempo:Integer Read fTempo Write SetTempo;
    property DuringOfTime: TDuringOfTime Read fDuringOfTime Write SetDuringOfTime;
    Property Zoom:Integer Read fZoom Write SetZoom;
    Property OnClick;
    Property OnDblClick;
    Property OnMouseDown;
    Property OnMouseMove;
    Property OnMouseUp;
    Property OnMouseWheel;
    Property OnMouseWheelDown;
    Property OnMouseWheelUp;
    Property OnResize;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music_Pro', [TTrackTime]);
end;

constructor TTrackTime.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DoubleBuffered:=True;
  ColorDown:=$008C9F6C;
  ColorMiddle:=Clwhite;
  fColorUp:=$0096E1FA;
  fDuringOfTime:=QuarterNote;
  DuringCoef := 1;
  fMin:=0;
  fMax:=7;
  fTime:=4;
  Tempo:=60;
  fZoom:=1;
end;

destructor TTrackTime.Destroy;
begin
  inherited;
end;

Function TTrackTime.MsToDiv(MilliSeconde:Integer):Integer;
Begin
  Result:=Round((60*MilliSeconde)/(Tempo*fTime*DuringCoef*1000));
End;

Function TTrackTime.DivToMs(Division:Integer):Integer;
Begin
  Result:=Round((Division*Tempo*fTime*DuringCoef*1000) / 60);
End;

Procedure TTrackTime.SetColorUp(Value:TColor);
begin
  fColorUp:=Value;
  Invalidate;
end;

Procedure TTrackTime.SetColorMiddle(Value:TColor);
begin
  fColorMiddle:=Value;
  Invalidate;
end;

Procedure TTrackTime.SetColorDown(Value:TColor);
begin
  fColorDown:=Value;
  Invalidate;
end;

Procedure TTrackTime.SetMin(Value:Integer);
begin
  If Value<fMax Then
    Begin
      fMin:=Value;
      Invalidate;
    End;  
end;

Procedure TTrackTime.SetMax(Value:Integer);
begin
  If Value>fMin Then
    Begin
      fMax:=Value;
      Invalidate;
    End;
end;

Procedure TTrackTime.SetTime(Value:Integer);
begin
  If Value=0 Then fTime:=1;
  fTime:=Value;
  Invalidate;
end;

Procedure TTrackTime.SetTempo(Value:Integer);
begin
  fTempo:=Value;
  Invalidate;
end;

procedure TTrackTime.SetDuringOfTime(Value: TDuringOfTime);
begin
  fDuringOfTime:=Value;
  case fDuringOfTime of
    WholeNote: DuringCoef  := 4;
    HalfNote: DuringCoef  := 2;
    QuarterNote: DuringCoef  := 1;
    Quavers: DuringCoef := 0.5;
    SixteenthNote: DuringCoef := 0.25;
    DemSemiQuavers: DuringCoef := 0.125;
  end;
  Invalidate;
end;

Procedure TTrackTime.SetZoom(Value:Integer);
begin
  If Value<1 Then Exit;
  fZoom := Value;
  Invalidate;
end;

Procedure TTrackTime.SetLeftDelim(Value:Integer);
begin
  if (fLeftDelim <> Value) And (Value<fRightDelim)  then
  begin
    fLeftDelim := Value;
    Invalidate;
  end;
end;

Procedure TTrackTime.SetRightDelim(Value:Integer);
begin
  if (fRightDelim <> Value) And (Value>fLeftDelim) then
  begin
    fRightDelim := Value;
    Invalidate;
  end;
end;

Procedure TTrackTime.SetPos(Value:Integer);
begin
  fPos := Value;
  Invalidate;
end;

Procedure TTrackTime.SetDelims_Show(Value:Boolean);
begin
  fDelims_Show:= Value;
  Invalidate;
end;

Procedure TTrackTime.SetPos_Show(Value:Boolean);
begin
  fPos_Show:= Value;
  Invalidate;
end;

Procedure TTrackTime.SetCursorMode(Value:TCursorMode);
begin
  fCursorMode:= Value;
  Invalidate;
end;

procedure TTrackTime.Paint;
Var
  LeftPx,RightPx,PosPx:Integer;
Begin
  InHerited;
  TimeLine_Painting;
  If (fDelims_Show) Then
    Begin
      LeftPx:=Round((1200*fLeftDelim*fZoom)/(fTempo*DuringCoef*1000));
      RightPx:=Round((1200*fRightDelim*fZoom)/(fTempo*DuringCoef*1000));
      With Canvas Do
        Begin
          Pen.Color:=ClBlue;
          MoveTo(LeftPx,Height Div 3);
          LineTo(LeftPx,Height);
          MoveTo(RightPx,Height Div 3);
          LineTo(RightPx,Height);
        End;
    End;
  If fPos_Show Then
    Begin
      PosPx:=Round((1200*fPos*fZoom)/(fTempo*DuringCoef*1000));
      With Canvas Do
        Begin
          Pen.Color:=ClRed;
          MoveTo(PosPx,Height Div 3);
          LineTo(PosPx,Height);
        End;
    End;
End;

Procedure TTrackTime.TimeLine_Painting;
Var
  RectUp,RectMiddle,RectDown:TRect;
  IndexMesure,IndexTime,IndexZoom,LeftPos,DivInMs:Integer;
  HeightTextDiv,HeightTextDivInMs:Integer;
Begin
  Width:=(fMax-fMin)*80*fZoom;
  With Canvas Do
    Begin
      Brush.Style:=BsClear;
      Pen.Width:=0;
      Font.Name:='Arial';
      Font.Size:=7;
      Pen.Color:=ClBlack;
      With RectUp Do
        Begin
          Left:=0;
          Right:=Width;
          Top:=0;
          Bottom:=Height Div 3;
          Brush.Color:=fColorUp;
          Rectangle(RectUp);
        End;
      With RectMiddle Do
        Begin
          Left:=0;
          Right:=Width;
          Top:=Height Div 3;
          Bottom:=2*Height Div 3;
          Brush.Color:=fColorMiddle;
          Rectangle(RectMiddle);
        End;
      With RectDown Do
        Begin
          Left:=0;
          Right:=Width;
          Top:=2*Height Div 3;
          Bottom:=Height;
          Brush.Color:=fColorDown;
          Rectangle(RectDown);
        End;
      Brush.Style:=BsClear;
      For IndexMesure:=fMin to fMax Do
        Begin
          LeftPos:=IndexMesure*fTime*20*fZoom;
          MoveTo(LeftPos,Height Div 3);
          LineTo(LeftPos,Height);
          HeightTextDiv:=TextHeight(IntToStr(IndexMesure));
          TextOut(LeftPos+3, (Height - HeightTextDiv) Div 2, IntToStr(IndexMesure));
          DivInMs:=DivToMs(IndexMesure);
          HeightTextDivInMs:=TextHeight(IntToStr(DivInMs)+'ms');
          TextOut(LeftPos+3, (Height Div 3 - HeightTextDivInMs) Div 2, IntToStr(DivInMs)+'ms');
          If IndexMesure<fMax Then
          For IndexTime:=0 To (Time-1) Do
            Begin
              MoveTo(LeftPos+IndexTime*20*fZoom,2*Height Div 3);
              LineTo(LeftPos+IndexTime*20*fZoom,Height);
	      For IndexZoom:=1 To fZoom Do
		Begin
                  MoveTo(LeftPos+IndexTime*20*fZoom+IndexZoom*20,4*Height Div 5);
                  LineTo(LeftPos+IndexTime*20*fZoom+IndexZoom*20,Height);
		End;
            End;   
        End;
    End;
End;

procedure TTrackTime.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: integer);
Begin
  If (fCursorMode=DelimsMode) And (Delims_Show) Then
    Begin
      If SSLeft In Shift Then LeftDelim:=Round(X*(fTempo*DuringCoef*1000) / (1200*fZoom));
      If SSRight In Shift Then RightDelim:=Round(X*(fTempo*DuringCoef*1000)/(1200*fZoom));
      Invalidate;
    End;
  If (fCursorMode=PosMode) And (fPos_Show)Then
  If (SSLeft In Shift) Then
    Begin
      Pos:=Round(X*(fTempo*DuringCoef*1000)/(1200*fZoom));
      Invalidate;
    End;
  InHerited;
End;

Procedure TTrackTime.Resize;
Begin
  Height:=49;
  Invalidate;
End;                     
end.
