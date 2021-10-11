unit ButtonComps;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TEncartaButton = class(TCustomControl)
  private
    Cap : string;
    Col : TColor;
    Border: TColor;
    OverFColor: TColor;
    OverColor: TColor;
    DownColor: TColor;
    MDown: TMouseEvent;
    MUp: TMouseEvent;
    MEnter : TNotifyEvent;
    MLeave : TNotifyEvent;
    Enab: Boolean;
    Bmp: TBitmap;
    SCap: Boolean;
    BtnClick: TNotifyEvent;
    procedure SetCol(Value: TColor);
    procedure SetBorder(Value: TColor);
    procedure SetCap(Value: string);
    procedure SetBmp(Value: TBitmap);
    procedure SetSCap(Value: Boolean);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure SetParent(Value: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;
  published
    property Caption : string read Cap write SetCap;
    property Color : TColor read Col write SetCol;
    property ColorBorder : TColor read Border write SetBorder;
    property Enabled : Boolean read Enab write Enab;
    property OnMouseDown: TMouseEvent read MDown write MDown;
    property OnMouseUp: TMouseEvent read MUp write MUp;
    property OnMouseEnter: TNotifyEvent read MEnter write MEnter;
    property OnMouseLeave: TNotifyEvent read MLeave write MLeave;
    property OnClick: TNotifyEvent read BtnClick write BtnClick;
    property Glyph: TBitmap read Bmp write SetBmp;
    property ColorOverCaption: TColor read OverFColor write OverFColor;
    property ColorOver: TColor read OverColor write OverColor;
    property ColorDown: TColor read DownColor write DownColor;
    property ShowCaption: Boolean read SCap write SetSCap;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
    property Font;
  end;

  TAOLButton = class(TCustomControl)
  private
    Cap : string;
    Col : TColor;
    RaiseCol: TColor;
    MDown: TMouseEvent;
    MUp: TMouseEvent;
    MLeave : TNotifyEvent;
    Enab: Boolean;
    BtnClick: TNotifyEvent;
    procedure SetCol(Value: TColor);
    procedure SetCap(Value: string);
    procedure SetRaiseCol(Value: TColor);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure SetParent(Value: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption : string read Cap write SetCap;
    property Color : TColor read Col write SetCol;
    property RaiseColor : TColor read RaiseCol write SetRaiseCol;
    property Enabled : Boolean read Enab write Enab;
    property OnMouseDown: TMouseEvent read MDown write MDown;
    property OnMouseUp: TMouseEvent read MUp write MUp;
    property OnMouseLeave: TNotifyEvent read MLeave write MLeave;
    property OnClick: TNotifyEvent read BtnClick write BtnClick;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
    property Font;
  end;

  TImageButton = class(TCustomControl)
  private
    MOver: TBitmap;
    MDown: TBitmap;
    MUp: TBitmap;
    Bmp: TBitmap;
    ActualBmp: TBitmap;
    BmpDAble: TBitmap;
    BtnClick: TNotifyEvent;
    OnMDown: TMouseEvent;
    OnMUp: TMouseEvent;
    OnMEnter: TNotifyEvent;
    OnMLeave: TNotifyEvent;
    procedure SetMOver(Value: TBitmap);
    procedure SetMDown(Value: TBitmap);
    procedure SetMUp(Value: TBitmap);
    procedure SetBmp(Value: TBitmap);
    procedure SetBmpDAble(Value: TBitmap);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    Destructor Destroy; override;    
  published
    property BitmapOver: TBitmap read MOver write SetMOver;
    property BitmapDown: TBitmap read MDown write SetMDown;
    property BitmapUp: TBitmap read MUp write SetMUp;
    property BitmapDisabled: TBitmap read BmpDAble write SetBmpDAble;
    property Bitmap: TBitmap read Bmp write SetBmp;
    property OnClick: TNotifyEvent read BtnClick write BtnClick;
    property OnMouseDown: TMouseEvent read OnMDown write OnMDown;
    property OnMouseUp: TMouseEvent read OnMUp write OnMUp;
    property OnMouseEnter: TNotifyEvent read OnMEnter write OnMEnter;
    property OnMouseLeave: TNotifyEvent read OnMLeave write OnMLeave;
    property Enabled;
    property ShowHint;
    property ParentShowHint;
  end;

  TSelButton = class(TCustomControl)
  private
    Cap : string;
    Col : TColor;
    Border: TColor;
    OverFColor: TColor;
    OverColor: TColor;
    DownColor: TColor;
    MDown: TMouseEvent;
    MUp: TMouseEvent;
    MEnter : TNotifyEvent;
    MLeave : TNotifyEvent;
    Enab: Boolean;
    BtnClick: TNotifyEvent;
    Alment: TAlignment;
    BWidth: Longint;
    procedure SetCol(Value: TColor);
    procedure SetBorder(Value: TColor);
    procedure SetCap(Value: string);
    procedure SetAlment(Value: TAlignment);
    procedure SetBWidth(Value: Longint);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure SetParent(Value: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption : string read Cap write SetCap;
    property Color : TColor read Col write SetCol;
    property ColorBorder : TColor read Border write SetBorder;
    property Enabled : Boolean read Enab write Enab;
    property OnMouseDown: TMouseEvent read MDown write MDown;
    property OnMouseUp: TMouseEvent read MUp write MUp;
    property OnMouseEnter: TNotifyEvent read MEnter write MEnter;
    property OnMouseLeave: TNotifyEvent read MLeave write MLeave;
    property OnClick: TNotifyEvent read BtnClick write BtnClick;
    property ColorOverCaption: TColor read OverFColor write OverFColor;
    property ColorOver: TColor read OverColor write OverColor;
    property ColorDown: TColor read DownColor write DownColor;
    property Alignment: TAlignment read Alment write SetAlment;
    property BorderWidth: Longint read BWidth write SetBWidth;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
    property Font;
  end;

  TSquareButton = class(TCustomControl)
  private
    Cap : string;
    Col : TColor;
    Border: TColor;
    OverFColor: TColor;
    OverBorderCol: TColor;
    DownBorderCol: TColor;
    MDown: TMouseEvent;
    MUp: TMouseEvent;
    MEnter : TNotifyEvent;
    MLeave : TNotifyEvent;
    Enab: Boolean;
    BtnClick: TNotifyEvent;
    Alment: TAlignment;
    BWidth: Longint;
    procedure SetCol(Value: TColor);
    procedure SetBorder(Value: TColor);
    procedure SetCap(Value: string);
    procedure SetAlment(Value: TAlignment);
    procedure SetBWidth(Value: Longint);
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure MouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure Click; override;
    procedure SetParent(Value: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption : string read Cap write SetCap;
    property Color : TColor read Col write SetCol;
    property ColorBorder : TColor read Border write SetBorder;
    property Enabled : Boolean read Enab write Enab;
    property OnMouseDown: TMouseEvent read MDown write MDown;
    property OnMouseUp: TMouseEvent read MUp write MUp;
    property OnMouseEnter: TNotifyEvent read MEnter write MEnter;
    property OnMouseLeave: TNotifyEvent read MLeave write MLeave;
    property OnClick: TNotifyEvent read BtnClick write BtnClick;
    property ColorOverCaption: TColor read OverFColor write OverFColor;
    property Alignment: TAlignment read Alment write SetAlment;
    property ColorOverBorder: TColor read OverBorderCol write OverBorderCol;
    property BorderWidth: Longint read BWidth write SetBWidth;
    property DownBorderColor: TColor read DownBorderCol write DownBorderCol;
    property ShowHint;
    property ParentShowHint;
    property OnMouseMove;
    property Font;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Buttons', [TEncartaButton, TAOLButton, TImageButton, TSelButton,
    TSquareButton]);
end;

constructor TEncartaButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 86;
  Height := 22;
  Col := clBtnFace;
  OverFColor := clBlack;
  OverColor := $000ABED8;
  DownColor := $000ABED8;
  Canvas.Brush.Color := clBlack;
  Border := $00828F99;
  Font.Name := 'Arial';
  Font.Color := clBlack;
  Enab := true;
  Bmp := TBitmap.Create;
  ShowHint := true;
  SCap := true;
end;

Destructor TEncartaButton.Destroy;
begin
  Bmp.Free;
  inherited;
end;

procedure TEncartaButton.SetParent(Value: TWinControl);
begin
  inherited;
  if Value <> nil then Cap := Name;
end;

procedure TEncartaButton.Paint;
var TextWidth, TextHeight : Longint;
begin
  inherited Paint;
  Canvas.Font := Font;
  Canvas.Brush.Color := Col;
  Canvas.FillRect(Rect(1,1,Width-1,Height-1));
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  Canvas.Font.Color := $00D6E0E0;
  if Bmp.Empty = false then begin
     if SCap = true then begin
        Canvas.BrushCopy(Rect(Width div 2 - (Bmp.Width+TextWidth) div 2-1,Height div 2 - Bmp.Height div 2,
               bmp.width+Width div 2 - (Bmp.Width+TextWidth) div 2,bmp.height+Height div 2 - Bmp.Height div 2),
               bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
        Canvas.Font.Color := Font.Color;
        Canvas.TextOut(Width div 2 + (Bmp.Width-TextWidth) div 2+5-1,Height div 2-TextHeight div 2,Cap);
     end else Canvas.BrushCopy(Rect(Width div 2-Bmp.Width div 2,Height div 2-Bmp.Height div 2,
                     bmp.width+Width div 2-Bmp.Width div 2,bmp.height+Height div 2-Bmp.Height div 2),
                     bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
  end else begin
     Canvas.Font.Color := Font.Color;
     if SCap = true then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);
  end;
  Canvas.Brush.Color := Border;
  Canvas.FrameRect(Rect(0,0,Width,Height));
end;

procedure TEncartaButton.Click;
begin
  inherited Click;
  Paint;
  if Enab then if Assigned(BtnClick) then BtnClick(Self);
end;

procedure TEncartaButton.SetCol(Value: TColor);
begin
  Col := Value;
  Paint;
end;

procedure TEncartaButton.SetBorder(Value: TColor);
begin
  Border := Value;
  Paint;
end;

procedure TEncartaButton.SetCap(Value: string);
begin
  Cap := value;
  Paint;
end;

procedure TEncartaButton.SetBmp(Value: TBitmap);
begin
  Bmp.Assign(value);
  invalidate;
end;

procedure TEncartaButton.SetSCap(value: Boolean);
begin
  SCap := Value;
  Paint;
end;

procedure TEncartaButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MDown) then MDown(Self, Button, Shift, X, Y);
      Canvas.Brush.Color := DownColor;
      Canvas.FillRect(Rect(1,1,Width-1,Height-1));

      if Bmp.Empty = false then begin
         if SCap = true then begin
            Canvas.BrushCopy(Rect(Width div 2 - (Bmp.Width+TextWidth) div 2-1+1,Height div 2 - Bmp.Height div 2+1,
                   bmp.width+Width div 2 - (Bmp.Width+TextWidth) div 2+1,bmp.height+Height div 2 - Bmp.Height div 2+1),
                   bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
            Canvas.TextOut(Width div 2 + (Bmp.Width-TextWidth) div 2+5-1+1,Height div 2-TextHeight div 2+1,Cap);
         end else Canvas.BrushCopy(Rect(Width div 2-Bmp.Width div 2+1,Height div 2-Bmp.Height div 2+1,
                         bmp.width+Width div 2-Bmp.Width div 2+1,bmp.height+Height div 2-Bmp.Height div 2+1),
                         bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
      end else if SCap = true then Canvas.TextOut(Width div 2 - TextWidth div 2+1,Height div 2-TextHeight div 2+1,Cap);

      Canvas.Brush.Color := Border;
      Canvas.FrameRect(Rect(0,0,Width,Height));
      Canvas.Pen.Color := $00EDF4F8;
      Canvas.Polyline([Point(Width-1,0),Point(Width-1,Height)]);
      Canvas.Polyline([Point(Width,Height-1),Point(-1,Height-1)]);
      Canvas.Pen.Color := $004F4F4F;
      Canvas.Polyline([Point(0,Height-2),Point(0,0)]);
      Canvas.Polyline([Point(0,0),Point(Width-1,0)]);
  end;
end;

procedure TEncartaButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
    MouseOverButton: Boolean;
    P: TPoint;
begin
  inherited MouseUp(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MUp) then MUp(Self, Button, Shift, X, Y);
      GetCursorPos(P);
      MouseOverButton := (FindDragTarget(P, True) = Self);
      if MouseOverButton then begin
         Canvas.Brush.Color := OverColor;
         Canvas.FillRect(Rect(1,1,Width-1,Height-1));
         Canvas.Font.Color := OverFColor;

         if Bmp.Empty = false then begin
            if SCap = true then begin
               Canvas.BrushCopy(Rect(Width div 2 - (Bmp.Width+TextWidth) div 2-1,Height div 2 - Bmp.Height div 2,
                      bmp.width+Width div 2 - (Bmp.Width+TextWidth) div 2,bmp.height+Height div 2 - Bmp.Height div 2),
                      bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
               Canvas.TextOut(Width div 2 + (Bmp.Width-TextWidth) div 2+5-1,Height div 2-TextHeight div 2,Cap);
            end else Canvas.BrushCopy(Rect(Width div 2-Bmp.Width div 2,Height div 2-Bmp.Height div 2,
                            bmp.width+Width div 2-Bmp.Width div 2,bmp.height+Height div 2-Bmp.Height div 2),
                            bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
         end else if SCap = true then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);

         Canvas.Brush.Color := Border;
         Canvas.FrameRect(Rect(0,0,Width,Height));
         Canvas.Pen.Color := $00EDF4F8;
         Canvas.Polyline([Point(0,Height-2),Point(0,0)]);
         Canvas.Polyline([Point(0,0),Point(Width-1,0)]);
         Canvas.Pen.Color := $004F4F4F;
         Canvas.Polyline([Point(Width-1,0),Point(Width-1,Height)]);
         Canvas.Polyline([Point(Width,Height-1),Point(-1,Height-1)]);
      end;
  end;
end;

procedure TEncartaButton.MouseEnter(var Message: TMessage);
var TextWidth, TextHeight : Integer;
begin
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if Enab then begin
     Canvas.Brush.Color := OverColor;
     Canvas.FillRect(Rect(1,1,Width-1,Height-1));
     Canvas.Font.Color := OverFColor;

     if Bmp.Empty = false then begin
        if SCap = true then begin
           Canvas.BrushCopy(Rect(Width div 2 - (Bmp.Width+TextWidth) div 2-1,Height div 2 - Bmp.Height div 2,
                  bmp.width+Width div 2 - (Bmp.Width+TextWidth) div 2,bmp.height+Height div 2 - Bmp.Height div 2),
                  bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
           Canvas.TextOut(Width div 2 + (Bmp.Width-TextWidth) div 2+5-1,Height div 2-TextHeight div 2,Cap);
        end else Canvas.BrushCopy(Rect(Width div 2-Bmp.Width div 2,Height div 2-Bmp.Height div 2,
                        bmp.width+Width div 2-Bmp.Width div 2,bmp.height+Height div 2-Bmp.Height div 2),
                        bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
     end else if SCap = true then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);

     Canvas.Brush.Color := Border;
     Canvas.FrameRect(Rect(0,0,Width,Height));
     Canvas.Pen.Color := $00EDF4F8;
     Canvas.Polyline([Point(0,Height-2),Point(0,0)]);
     Canvas.Polyline([Point(0,0),Point(Width-1,0)]);
     Canvas.Pen.Color := $004F4F4F;
     Canvas.Polyline([Point(Width-1,0),Point(Width-1,Height)]);
     Canvas.Polyline([Point(Width,Height-1),Point(-1,Height-1)]);
  end;
end;

procedure TEncartaButton.MouseLeave(var Message: TMessage);
var TextWidth, TextHeight : Integer;
begin
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  Canvas.Brush.Color := Col;
  Canvas.FillRect(Rect(1,1,Width-1,Height-1));
  Canvas.Font.Color := $00D6E0E0;
  Canvas.Brush.Color := Col;
  Canvas.Font.Color := Font.Color;

  if Bmp.Empty = false then begin
     if SCap = true then begin
        Canvas.BrushCopy(Rect(Width div 2 - (Bmp.Width+TextWidth) div 2-1,Height div 2 - Bmp.Height div 2,
               bmp.width+Width div 2 - (Bmp.Width+TextWidth) div 2,bmp.height+Height div 2 - Bmp.Height div 2),
               bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
        Canvas.Font.Color := Font.Color;
        Canvas.TextOut(Width div 2 + (Bmp.Width-TextWidth) div 2+5-1,Height div 2-TextHeight div 2,Cap);
     end else Canvas.BrushCopy(Rect(Width div 2-Bmp.Width div 2,Height div 2-Bmp.Height div 2,
                     bmp.width+Width div 2-Bmp.Width div 2,bmp.height+Height div 2-Bmp.Height div 2),
                     bmp,Rect(0,0,bmp.width,bmp.height),bmp.Canvas.pixels[0,0]);
  end else if SCap = true then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);

  Canvas.Brush.Color := Border;
  Canvas.FrameRect(Rect(0,0,Width,Height));
end;

constructor TAOLButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 89;
  Height := 23;
  Col := $00A56934;
  Canvas.Brush.Color := clBlack;
  Font.Name := 'Arial';
  Font.Color := clWhite;
  Font.Size := 8;
  Font.Style :=[fsBold];
  Enab := true;
  ShowHint := true;
  RaiseCol := $00D7A28A;
end;

procedure TAOLButton.SetParent(Value: TWinControl);
begin
  inherited;
  if Value <> nil then Cap := Name;
end;

procedure TAOLButton.Paint;
var TextWidth, TextHeight : Longint;
begin
  inherited Paint;
  Canvas.Font := Font;
  Canvas.Brush.Color := Col;
  Canvas.FillRect(Rect(1,1,Width-1,Height-1));

  Canvas.Brush.Color := RaiseCol;
  Canvas.FillRect(Rect(1,1,3,Height-1));
  Canvas.FillRect(Rect(1,1,Width-1,3));
  Canvas.Brush.Color := clBlack;
  Canvas.FillRect(Rect(Width-1,1,Width-3,Height-1));
  Canvas.FillRect(Rect(Width-1,Height-1,1,Height-3));

  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  Canvas.Font.Color := $00D6E0E0;

  Canvas.Brush.Color := Col;
  Canvas.Font.Color := Font.Color;
  Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);

  Canvas.Brush.Color := clBlack;
  Canvas.FrameRect(Rect(0,0,Width,Height));
end;

procedure TAOLButton.Click;
begin
  inherited Click;
  Paint;
  if Enab then if Assigned(BtnClick) then BtnClick(Self);
end;

procedure TAOLButton.SetCol(Value: TColor);
begin
  Col := Value;
  Paint;
end;

procedure TAOLButton.SetCap(Value: string);
begin
  Cap := value;
  Paint;
end;

procedure TAOLButton.SetRaiseCol(Value: TColor);
begin
  RaiseCol := value;
  Paint;
end;

procedure TAOLButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MDown) then MDown(Self, Button, Shift, X, Y);
      Canvas.Brush.Color := Color;
      Canvas.FillRect(Rect(1,1,Width-1,Height-1));

      Canvas.Brush.Color := clBlack;
      Canvas.FillRect(Rect(1,1,Width-1,2));

      Canvas.Brush.Color := Col;
      Canvas.TextOut(Width div 2 - TextWidth div 2+2,Height div 2-TextHeight div 2+2,Cap);

      Canvas.Brush.Color := clBlack;
      Canvas.FrameRect(Rect(0,0,Width,Height));
  end;
end;

procedure TAOLButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseUp(Button, Shift, X, Y);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MUp) then MUp(Self, Button, Shift, X, Y);
      if (X>0) and (Y>0) and (X<=Width) and (Y<=Height) then Paint;
  end;
end;

procedure TAOLButton.MouseLeave(var Message: TMessage);
begin
  Paint;
end;

constructor TImageButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MOver := TBitmap.Create;
  MDown := TBitmap.Create;
  MUp := TBitmap.Create;
  Bmp := TBitmap.Create;
  BmpDAble := TBitmap.Create;
  ActualBmp := TBitmap.Create;
  Width := 50;
  Height := 50;
  Canvas.Brush.Color := clBtnFace;
  ShowHint := true;
end;

Destructor TImageButton.Destroy;
begin
  MOver.Free;
  MDown.Free;
  MUp.Free;
  Bmp.Free;
  BmpDAble.Free;
  ActualBmp.Free;
  inherited;
end;

procedure TImageButton.Paint;
begin
  inherited Paint;
  if ActualBmp.Width = 0 then ActualBmp.Assign(Bmp);
  Canvas.FillRect(Rect(0,0,Width,Height));
  if Enabled or (BmpDAble.Width = 0) then Canvas.Draw(0,0,ActualBmp)
  else begin
    Width := BmpDAble.Width;
    Height := BmpDAble.Height;
    Canvas.Draw(0,0,BmpDAble);
  end;
end;

procedure TImageButton.Click;
begin
  inherited Click;
  Paint;
  if Enabled then if Assigned(BtnClick) then BtnClick(Self);
end;

procedure TImageButton.SetMOver(Value: TBitmap);
begin
  MOver.Assign(Value);
  Paint;
end;

procedure TImageButton.SetMDown(Value: TBitmap);
begin
  MDown.Assign(Value);
  Paint;
end;

procedure TImageButton.SetMUp(Value: TBitmap);
begin
  MUp.Assign(Value);
  Paint;
end;

procedure TImageButton.SetBmp(Value: TBitmap);
begin
  Bmp.Assign(Value);
  ActualBmp.Assign(Value);
  Width := Bmp.Width;
  Height := Bmp.Height;
  Paint;
end;

procedure TImageButton.SetBmpDAble(Value: TBitmap);
begin
  BmpDAble.Assign(Value);
  paint;
end;

procedure TImageButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if (Button = mbLeft) and Enabled then begin
     if Assigned (OnMDown) then OnMDown(Self, Button, Shift, X, Y);
     if MDown.Width > 0 then begin
        ActualBmp.Assign(MDown);
        Width := MDown.Width;
        Height := MDown.Height;
        Paint;
     end;
  end;
end;

procedure TImageButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var MouseOverButton: Boolean;
    P: TPoint;
begin
  inherited MouseUp(Button, Shift, X, Y);
  MouseOverButton:=False;
  if (Button = mbLeft) and Enabled then begin
     if Assigned (OnMUp) then OnMUp(Self, Button, Shift, X, Y);
     if MUp.Width > 0 then begin
        GetCursorPos(P);
        MouseOverButton := (FindDragTarget(P, True) = Self);
        if MouseOverButton then begin
           Width := MUp.Width;
           Height := MUp.Height;
           Canvas.FillRect(Rect(0,0,Width,Height));
           Canvas.Draw(0,0,MUp);
        end else begin
           Width := bmp.Width;
           Height := Bmp.Height;
           Canvas.FillRect(Rect(0,0,Width,Height));
           Canvas.Draw(0,0,Bmp);
        end;
     end else begin
        if MouseOverButton = false then begin
           Width := MOver.Width;
           Height := MOver.Height;
           Canvas.FillRect(Rect(0,0,Width,Height));
           Canvas.Draw(0,0,MOver);
        end else begin
           Width := bmp.Width;
           Height := Bmp.Height;
           Canvas.FillRect(Rect(0,0,Width,Height));
           Canvas.Draw(0,0,Bmp);
        end;
     end;
  end;
end;

procedure TImageButton.MouseEnter(var Message: TMessage);
begin
  if Enabled then begin
     if MOver.Width > 0 then begin
        ActualBmp.Assign(MOver);
        Width := MOver.Width;
        Height := MOver.Height;
        Paint;
     end;
  end;
end;

procedure TImageButton.MouseLeave(var Message: TMessage);
begin
  if Enabled then begin
     if Bmp.Width > 0 then begin
        ActualBmp.Assign(Bmp);
        Width := Bmp.Width;
        Height := Bmp.Height;
        Paint;
     end;
  end;
end;

constructor TSelButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 105;
  Height := 20;
  Col := clBtnFace;
  OverFColor := clBlack;
  OverColor := $00A4B984;
  DownColor := $00A4B984;
  Canvas.Brush.Color := clBlack;
  Border := clGray;
  Font.Name := 'Arial';
  Font.Color := clGray;
  Font.Size := 8;
  Enab := true;
  ShowHint := true;
  Alment := taLeftJustify;
  BWidth := 1;
end;

procedure TSelButton.SetParent(Value: TWinControl);
begin
  inherited;
  if Value <> nil then Cap := Name;
end;

procedure TSelButton.Paint;
var TextWidth, TextHeight : Longint;
    i: Longint;
begin
  inherited Paint;
  Canvas.Font := Font;
  Canvas.Brush.Color := Col;
  Canvas.FillRect(Rect(1,1,Width-1,Height-1));
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  Canvas.Font.Color := $00D6E0E0;

  Canvas.Font.Color := Font.Color;
  if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);
  if Alment = taLeftJustify then Canvas.TextOut(5,Height div 2-TextHeight div 2,Cap);
  if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 6,Height div 2-TextHeight div 2,Cap);

  Canvas.Brush.Color := Border;
  for i := 0 to BWidth-1 do Canvas.FrameRect(Rect(i,i,Width-i,Height-i));
end;

procedure TSelButton.Click;
begin
  inherited Click;
  Paint;
  if Enab then if Assigned(BtnClick) then BtnClick(Self);
end;

procedure TSelButton.SetCol(Value: TColor);
begin
  Col := Value;
  Paint;
end;

procedure TSelButton.SetBorder(Value: TColor);
begin
  Border := Value;
  Paint;
end;

procedure TSelButton.SetCap(Value: string);
begin
  Cap := value;
  Paint;
end;

procedure TSelButton.SetAlment(Value: TAlignment);
begin
  Alment := Value;
  Paint;
end;

procedure TSelButton.SetBWidth(Value: Longint);
begin
  BWidth := value;
  Paint;
end;

procedure TSelButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
    i: Longint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MDown) then MDown(Self, Button, Shift, X, Y);
      Canvas.Brush.Color := DownColor;
      Canvas.FillRect(Rect(1,1,Width-1,Height-1));

      if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2+1,Height div 2-TextHeight div 2+1,Cap);
      if Alment = taLeftJustify then Canvas.TextOut(5+1,Height div 2-TextHeight div 2+1,Cap);
      if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 6-1,Height div 2-TextHeight div 2+1,Cap);

      Canvas.Brush.Color := Border;
      for i := 0 to BWidth-1 do Canvas.FrameRect(Rect(i,i,Width-i,Height-i));
  end;
end;

procedure TSelButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
    i: Longint;
    MouseOverButton: Boolean;
    P: TPoint;
begin
  inherited MouseUp(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MUp) then MUp(Self, Button, Shift, X, Y);
      GetCursorPos(P);
      MouseOverButton := (FindDragTarget(P, True) = Self);
      if MouseOverButton then begin
         Canvas.Brush.Color := OverColor;
         Canvas.FillRect(Rect(1,1,Width-1,Height-1));
         Canvas.Font.Color := OverFColor;

         if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);
         if Alment = taLeftJustify then Canvas.TextOut(5,Height div 2-TextHeight div 2,Cap);
         if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 6,Height div 2-TextHeight div 2,Cap);

         Canvas.Brush.Color := Border;
         for i := 0 to BWidth-1 do Canvas.FrameRect(Rect(i,i,Width-i,Height-i));
      end;
  end;
end;

procedure TSelButton.MouseEnter(var Message: TMessage);
var TextWidth, TextHeight : Integer;
    i: Longint;
begin
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if Enab then begin
     Canvas.Brush.Color := OverColor;
     Canvas.FillRect(Rect(1,1,Width-1,Height-1));
     Canvas.Font.Color := OverFColor;

     if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);
     if Alment = taLeftJustify then Canvas.TextOut(5,Height div 2-TextHeight div 2,Cap);
     if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 6,Height div 2-TextHeight div 2,Cap);

     Canvas.Brush.Color := Border;
     for i := 0 to BWidth-1 do Canvas.FrameRect(Rect(i,i,Width-i,Height-i));
  end;
end;

procedure TSelButton.MouseLeave(var Message: TMessage);
var TextWidth, TextHeight : Integer;
    i: integer;
begin
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  Canvas.Brush.Color := Col;
  Canvas.FillRect(Rect(1,1,Width-1,Height-1));
  Canvas.Font.Color := $00D6E0E0;
  Canvas.Brush.Color := Col;
  Canvas.Font.Color := Font.Color;

  if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2,Cap);
  if Alment = taLeftJustify then Canvas.TextOut(5,Height div 2-TextHeight div 2,Cap);
  if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 6,Height div 2-TextHeight div 2,Cap);

  Canvas.Brush.Color := Border;
  for i := 0 to BWidth-1 do Canvas.FrameRect(Rect(i,i,Width-i,Height-i));
end;

constructor TSquareButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 113;
  Height := 17;
  Col := clBtnFace;
  OverFColor := clWhite;
  Canvas.Brush.Color := clBlack;
  Border := clBlack;
  Font.Name := 'Arial';
  Font.Color := clBlack;
  Font.Size := 8;
  Enab := true;
  ShowHint := true;
  Alment := taLeftJustify;
  OverBorderCol := clBlack;
  BWidth := 2;
  DownBorderCol := clWhite;
end;

procedure TSquareButton.SetParent(Value: TWinControl);
begin
  inherited;
  if Value <> nil then Cap := Name;
end;

procedure TSquareButton.Paint;
var TextWidth, TextHeight : Longint;
begin
  inherited Paint;
  Canvas.Font := Font;
  Canvas.Brush.Color := Col;
  Canvas.FillRect(Rect(0,0,Width,Height));

  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  Canvas.Font.Color := $00D6E0E0;

  Canvas.Font.Color := Font.Color;
  if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2-1,Cap);
  if Alment = taLeftJustify then Canvas.TextOut(6,Height div 2-TextHeight div 2-1,Cap);
  if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 7,Height div 2-TextHeight div 2-1,Cap);

  Canvas.Brush.Color := Border;
  Canvas.FillRect(Rect(0,Height,Width,Height-BWidth));
  Canvas.FillRect(Rect(0,0,BWidth,Height));
end;

procedure TSquareButton.Click;
begin
  inherited Click;
  Paint;
  if Enab then if Assigned(BtnClick) then BtnClick(Self);
end;

procedure TSquareButton.SetCol(Value: TColor);
begin
  Col := Value;
  Paint;
end;

procedure TSquareButton.SetBorder(Value: TColor);
begin
  Border := Value;
  Paint;
end;

procedure TSquareButton.SetCap(Value: string);
begin
  Cap := value;
  Paint;
end;

procedure TSquareButton.SetAlment(Value: TAlignment);
begin
  Alment := Value;
  Paint;
end;

procedure TSquareButton.SetBWidth(Value: Longint);
begin
  BWidth := Value;
  Paint;
end;

procedure TSquareButton.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MDown) then MDown(Self, Button, Shift, X, Y);
      Canvas.Brush.Color := Col;
      Canvas.FillRect(Rect(0,0,Width,Height));

      if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2-1,Cap);
      if Alment = taLeftJustify then Canvas.TextOut(6,Height div 2-TextHeight div 2-1,Cap);
      if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 7,Height div 2-TextHeight div 2-1,Cap);

      Canvas.Brush.Color := DownBorderCol;
      Canvas.FillRect(Rect(0,Height,Width,Height-BWidth));
      Canvas.FillRect(Rect(0,0,BWidth,Height));
  end;
end;

procedure TSquareButton.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var TextWidth, TextHeight : Longint;
    P: TPoint;
    MouseOverButton: Boolean;
begin
  inherited MouseUp(Button, Shift, X, Y);
  TextWidth := Canvas.TextWidth(Cap);
  TextHeight := Canvas.TextHeight(Cap);
  if (Button = mbLeft) and Enab then begin
      if Assigned (MUp) then MUp(Self, Button, Shift, X, Y);
      GetCursorPos(P);
      MouseOverButton := (FindDragTarget(P, True) = Self);
      if MouseOverButton then begin
         Canvas.Brush.Color := Col;
         Canvas.FillRect(Rect(0,0,Width,Height));
         Canvas.Font.Color := OverFColor;

         if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2-1,Cap);
         if Alment = taLeftJustify then Canvas.TextOut(6,Height div 2-TextHeight div 2-1,Cap);
         if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 7,Height div 2-TextHeight div 2-1,Cap);

         Canvas.Brush.Color := OverBorderCol;
         Canvas.FillRect(Rect(0,Height,Width,Height-BWidth));
         Canvas.FillRect(Rect(0,0,BWidth,Height));
      end;
  end;
end;

procedure TSquareButton.MouseEnter(var Message: TMessage);
var TextWidth, TextHeight : Longint;
begin
  if Enab then begin
     TextWidth := Canvas.TextWidth(Cap);
     TextHeight := Canvas.TextHeight(Cap);
     Canvas.Brush.Color := Col;
     Canvas.FillRect(Rect(0,0,Width,Height));
     Canvas.Font.Color := OverFColor;

     if Alment = taCenter then Canvas.TextOut(Width div 2 - TextWidth div 2,Height div 2-TextHeight div 2-1,Cap);
     if Alment = taLeftJustify then Canvas.TextOut(6,Height div 2-TextHeight div 2-1,Cap);
     if Alment = taRightJustify then Canvas.TextOut(Width - TextWidth - 7,Height div 2-TextHeight div 2-1,Cap);

     Canvas.Brush.Color := OverBorderCol;
     Canvas.FillRect(Rect(0,Height,Width,Height-BWidth));
     Canvas.FillRect(Rect(0,0,BWidth,Height));
  end;
end;

procedure TSquareButton.MouseLeave(var Message: TMessage);
begin
  Paint;
end;

end.
