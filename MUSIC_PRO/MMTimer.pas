unit MMTimer;
{
                                       _,_
                                      (___)
                                     //'''\\
                                      (o o)
+--------------------------------oOOO--(_)-------------------------------------+
|  Le timer multimedia offre le gros avantage d'une précision bien meilleure   |
|  (une vraie milliseconde), ainsi que la possibilté de travailler en mode     |
|  one shoot (un coup), ce qui évite d'écrire Timer1.Enabled := false dans     |
|  l'évèmenent timer (c'est quand même plus élégant ! Non ?)                           |
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
    { Déclarations privées }
    fwTimerID : DWord;        // Identifier MMTimer
    FInterval: integer;       // Itervalle
    fEnabled: boolean;	      // Tourne
    fwTimerRes : Word;        // Résolution du MMTimer (= mini du timer)
    fTimermode : TTimerMode;  // Mode (OneShot ou Periodic)
    FOnTimer: TNotifyEvent;   // Evènement
  protected
    { Déclarations protégées }
    procedure setEnabled( b: boolean );
    procedure SetInterval(value : Integer);
    procedure SetTimerMode(value : TTimerMode);
    procedure Start;
    procedure Stop;
  public
    { Déclarations publiques }
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    { Déclarations publiées }
    property Enabled: boolean read FEnabled write setEnabled default false;
    property Interval: integer read FInterval write SetInterval;
    property TimerMode : TTimerMode read fTimerMode write SetTimerMode;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

procedure Register;

implementation

// Fonction CallBack (un timer a déclenché)
// Commune à tous les MMTimer créés
// Determine lequel (dwUser), et lance l'évènement correspondant
procedure TimerCallback(wTimerID : integer; msg : integer;
     dwUser, dw1, dw2 : dword); stdcall;
begin
  // dwUser = DWord(self)   (voir fonction timeSetEvent)
  // si l'objet existe encore
  if not (TObject(dwUser) is TMMTimer) then
    exit;
  if not(TMMTimer(dwUser).fwTimerID = wTimerID) then
    exit;
  // si Evènement assigné -> Enènement OnTimer
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
  //   sa propre résolution si sup ou égale à milliseconde
  //   1 milliseconde sinon
  fwTimerRes := min(max(tc.wPeriodMin, 1), tc.wPeriodMax);
  timeBeginPeriod(fwTimerRes);
  // Valeurs par défaut
  fInterval :=10;
  fTimerMode := TIME_PERIODIC;
  fEnabled := False;
end;

destructor TMMTimer.Destroy;
begin
  if fEnabled then
    Stop;           // Arrêt du timer
  inherited Destroy;
end;

// démarrage/Arrêt du timer
procedure TMMTimer.SetEnabled( b: boolean );
begin
  // Là, je ne pense pas qu'il faille des explications complémentaires
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
      // il faut l'arrêter
      Stop;
      // Nouvel intervalle
      fInterval := Value;
      // puis le redémarrer si il tounait
      if fEnabled then
        Start;
    end;
end;

procedure TMMTimer.SetTimerMode(value : TTimerMode);
begin
  if (Value <>fTimerMode)  then
    begin
      // il faut l'arrêter
      Stop;
      // Nouveau mode
      fTimerMode := Value;
      // puis le redémarrer si il tournait
      if fEnabled then
        Start;
    end;
end;

procedure TMMTimer.Start;
begin
   // Démarrage Timer
   fwTimerID := timeSetEvent(
        fInterval,                     // delai
        fwTimerRes,                    // resolution
        @TimerCallback,                // fonction callback
        DWord(Self),	               // Passage du composant lui même
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
