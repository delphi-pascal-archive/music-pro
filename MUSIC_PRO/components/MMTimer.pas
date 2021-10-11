unit MMTimer;
{
                                       _,_
                                      (___)
                                     //'''\\
                                      (o o)
+--------------------------------oOOO--(_)-------------------------------------+
|  Le timer multimedia offre le gros avantage d'une pr�cision bien meilleure   |
|  (une vraie milliseconde), ainsi que la possibilt� de travailler en mode     |
|  one shoot (un coup), ce qui �vite d'�crire Timer1.Enabled := false dans     |
|  l'�v�menent timer (c'est quand m�me plus �l�gant ! Non ?)                           |
|  Il est par contre plus gourmand en ressources CPU                           |
+---------------------------------------------oOOO-----------------------------+
                                    |__/\__|
                                     ||  ||
                                    ooO  Ooo  Ken@vo
--------------------------------------------------------------------------------

}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem, Math;

type
  // Modes de fonctionnement
  TTIMERMode = (TIME_ONESHOT,TIME_PERIODIC);

  TMMTimer = class(TComponent)
  private
    { D�clarations priv�es }
    fwTimerID : DWord;        // Identifier MMTimer
    FInterval: integer;       // Itervalle
    fEnabled: boolean;	      // Tourne
    fwTimerRes : Word;        // R�solution du MMTimer (= mini du timer)
    fTimermode : TTimerMode;  // Mode (OneShot ou Periodic)
    FOnTimer: TNotifyEvent;   // Ev�nement
  protected
    { D�clarations prot�g�es }
    procedure setEnabled( b: boolean );
    procedure SetInterval(value : Integer);
    procedure SetTimerMode(value : TTimerMode);
    procedure Start;
    procedure Stop;
  public
    { D�clarations publiques }
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    { D�clarations publi�es }
    property Enabled: boolean read FEnabled write setEnabled default false;
    property Interval: integer read FInterval write SetInterval;
    property TimerMode : TTimerMode read fTimerMode write SetTimerMode;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

procedure Register;

implementation

// Fonction CallBack (un timer a d�clench�)
// Commune � tous les MMTimer cr��s
// Determine lequel (dwUser), et lance l'�v�nement correspondant
procedure TimerCallback(wTimerID : integer; msg : integer;
     dwUser, dw1, dw2 : dword); stdcall;
begin
  // dwUser = DWord(self)   (voir fonction timeSetEvent)
  // si l'objet existe encore
  if not (TObject(dwUser) is TMMTimer) then
    exit;
  if not(TMMTimer(dwUser).fwTimerID = wTimerID) then
    exit;
  // si Ev�nement assign� -> En�nement OnTimer
  if assigned(TMMTimer(dwUser).fOnTimer) then
    TMMTimer(dwUser).OnTimer(TObject(dwUser));
end;


constructor TMMTimer.Create( AOwner: TComponent );
var
  tc : TimeCaps;
begin
  Inherited Create(Aowner);
  //
  if (timeGetDevCaps(@tc, sizeof(TIMECAPS)) <> TIMERR_NOERROR) then
    exit;
  // Resolution min du timer =
  //   sa propre r�solution si sup ou �gale � milliseconde
  //   1 milliseconde sinon
  fwTimerRes := min(max(tc.wPeriodMin, 1), tc.wPeriodMax);
  timeBeginPeriod(fwTimerRes);
  // Valeurs par d�faut
  fInterval :=10;
  fTimerMode := TIME_PERIODIC;
  fEnabled := False;
end;

destructor TMMTimer.Destroy;
begin
  if fEnabled then
    Stop;           // Arr�t du timer
  inherited Destroy;
end;

// d�marrage/Arr�t du timer
procedure TMMTimer.SetEnabled( b: boolean );
begin
  // L�, je ne pense pas qu'il faille des explications compl�mentaires
  if b <>fEnabled then
    begin
      fEnabled := b;
      if fEnabled then Start
      else Stop;
    end;
end;

procedure TMMTimer.SetInterval(value : Integer);
begin
  if (Value <>fInterval) and (value >= fwTimerRes) then
    begin
      // il faut l'arr�ter
      Stop;
      // Nouvel intervalle
      fInterval := Value;
      // puis le red�marrer si il tounait
      if fEnabled then
        Start;
    end;
end;

procedure TMMTimer.SetTimerMode(value : TTimerMode);
begin
  if (Value <>fTimerMode)  then
    begin
      // il faut l'arr�ter
      Stop;
      // Nouveau mode
      fTimerMode := Value;
      // puis le red�marrer si il tournait
      if fEnabled then
        Start;
    end;
end;

procedure TMMTimer.Start;
begin
   // D�marrage Timer
   fwTimerID := timeSetEvent(
        fInterval,                     // delai
        fwTimerRes,                    // resolution
        @TimerCallback,                // fonction callback
        DWord(Self),	               // Passage du composant lui m�me
        Cardinal(fTimerMode));         // Mode OneShot ou Periodic
end;

procedure TMMTimer.Stop;
begin
  // Arret timer
  timeKillEvent(fwTimerID);
end;

procedure Register;
begin
  RegisterComponents('DelphiFr', [TMMTimer]);
end;

end.
