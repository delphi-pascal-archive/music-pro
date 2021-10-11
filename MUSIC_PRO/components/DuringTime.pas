unit DuringTime;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Graphics, Dialogs,ComCtrls;

type

  TDuringOfTime   = (WholeNote, HalfNote, QuarterNote, Quavers, SixteenthNote, DemiSemiQuavers);

  TDuringTime = class(TCustomControl)
  private
    fDuringOfTime:TDuringOfTime;
    fTime:Cardinal;
    DOTUpDown:TUpDown;
    TimeUpDown:TUpDown;
    fOnDOTClick:TNotifyEvent;
    fOnTimeClick:TNotifyEvent;
    Function Create_UpDown(ALeft:Integer):TUpDown;
    Procedure Set_DuringOfTime(Value:TDuringOfTime);
    Procedure Set_Time(Value:Cardinal);
    Procedure DrawNote;
    Procedure DuringOfTimeUDClick(Sender: TObject;Button: TUDBtnType);
    Procedure TimeUDClick(Sender: TObject;Button: TUDBtnType);
   protected
    Procedure Paint; override;
    Procedure Resize; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    Property Color;
    Property DuringOfTime:TDuringOfTime Read fDuringOfTime Write Set_DuringOfTime;
    Property Time:Cardinal Read fTime Write Set_Time;
    Property OnDuringOfTimeClick:TNotifyEvent Read fOnDOTClick Write fOnDOTClick;
    Property OnTimeClick:TNotifyEvent Read fOnTimeClick Write fOnTimeClick;
    Property OnClick;
    Property OnDblClick;
    Property OnMouseDown;
    Property OnMouseUp;
    Property OnMouseMove;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MUSIC_PRO', [TDuringTime]);
end;

constructor TDuringTime.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  fDuringOfTime:=WholeNote;
  fTime:=8;
  Color:=$00C08000;
  DOTUpDown:=Create_UpDown(80);
  DOTUpDown.OnClick:=DuringOfTimeUDClick;
  TimeUpDown:=Create_UpDown(156);
  TimeUpDown.OnClick:=TimeUDClick;
end;

destructor TDuringTime.Destroy;
begin
  DOTUpDown.Free;
  TimeUpDown.Free;
  inherited;
end;

Function TDuringTime.Create_UpDown(ALeft:Integer):TUpDown;
Begin
  Result:=TUpDown.Create(Self);
  With Result Do
    Begin
      Parent:=Self;
      Height:=30;
      Top:=6;
      Left:=ALeft;
      Width:=12;
    End;
End;    

Procedure TDuringTime.Set_DuringOfTime(Value:TDuringOfTime);
begin
  fDuringOfTime:=Value;
  Invalidate;
end;

Procedure TDuringTime.Set_Time(Value:Cardinal);
begin
  fTime:=Value;
  Invalidate;
end;

Procedure TDuringTime.DuringOfTimeUDClick(Sender: TObject;Button: TUDBtnType);
begin
  If Button=btNext Then
    Begin
      If fDuringOfTime>=DemiSemiQuavers Then Exit;
      Inc(fDuringOfTime);
    End;
  If Button=btPrev Then
    Begin
      If fDuringOfTime<=WholeNote Then Exit;
      Dec(fDuringOfTime);
    End;
 If Assigned(fOnDOTClick) Then fOnDOTClick(Self);
 Invalidate;
end;

Procedure TDuringTime.TimeUDClick(Sender: TObject;Button: TUDBtnType);
begin
  If Button=btNext Then
    Begin
      If fTime<=2 Then Exit;
      Dec(fTime);
    End;
  If Button=btPrev Then
    Begin
      If fTime>=8 Then Exit;
      Inc(fTime);
    End;
 If Assigned(fOnTimeClick) Then fOnTimeClick(Self);
 Invalidate;
end;

Procedure TDuringTime.Paint;
Var
  UpperCorner,LowerCorner:Array [0..2] Of TPoint;
  TopText:Integer;
  Str:String;   
  Rect:TRect;
begin
  inherited;
  With Canvas Do
    Begin
      Pen.Width:=4;
      UpperCorner[0]:=Point(Width,0);
      UpperCorner[1]:=Point(0,0);
      UpperCorner[2]:=Point(0,Height);
      LowerCorner[0]:=Point(0,Height);
      LowerCorner[1]:=Point(Width,Height);
      LowerCorner[2]:=Point(Width,0);
      Brush.Color:=ClWhite;
      Pen.Color:=ClWhite;
      Polyline(UpperCorner);
      Brush.Color:=$005F5F5F;
      Pen.Color:=$005F5F5F;
      Polyline(LowerCorner);
      Str:='RYTHME';
      TopText:=(Height-TextHeight(Str)) Div 2;
      Brush.Style:=BsClear;
      Font.Color:=ClWhite;
      TextOut(8,TopText,Str);
      Pen.Width:=1;
      Brush.Color:=ClBlack;
      Pen.Color:=ClBlack;
      DrawNote;
      Brush.Style:=BsClear;
      With Rect Do
        Begin
          Left:=4;
          Right:=94;
          Top:=4;
          Bottom:=37;
          Rectangle(Rect);
        End;                 
      Str:='TEMPS : '+IntTostr(fTime);
      TopText:=(Height-TextHeight(Str)) Div 2;
      Font.Color:=ClWhite;
      TextOut(100,TopText,Str);
      With Rect Do
        Begin
          Left:=97;
          Right:=170;
          Top:=4;
          Bottom:=37;
          Rectangle(Rect);
        End;
    End;
end;

Procedure TDuringTime.DrawNote;
Const
  NoteToInt: Array[TDuringOfTime] of Integer =(0,1,2,3,4,5);
Var
  IndexStrap:Integer;
Begin
  With Canvas Do
    Begin
      If Not (fDuringOfTime In [WholeNote,HalfNote]) Then
      Brush.Style:=BsSolid Else Brush.Style:=BsClear;
      If fDuringOfTime=WholeNote Then
        Begin
          Ellipse(65,17,75,24);
          MoveTo(63,20);
          LineTo(77,20);
        End
      Else
        Begin
          Ellipse(65,25,75,31);
          MoveTo(74,28);
          LineTo(74,10);
          If NoteToInt[fDuringOfTime]>=3 Then
          For IndexStrap:=0 To (NoteToInt[fDuringOfTime]-3) Do
            Begin
            MoveTo(74,10+IndexStrap*4);
            LineTo(78,14+IndexStrap*4);
            MoveTo(78,14+IndexStrap*4);
            LineTo(78,18+IndexStrap*4);
            End;
        End;
    End;
End;

Procedure TDuringTime.Resize;
begin
  inherited;
  Height:=40;
  Width:=174;
end;

end.
