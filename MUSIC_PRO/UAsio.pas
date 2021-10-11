{>>Ici on traite l'asio.
La partie CPU provient de Nono 40 : http://nono40.developpez.com/sources/source0056/}

unit UAsio;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Vumeter, StdCtrls, ExtCtrls, Buttons, Bass, BassAsio, XiTrackBar;

type
  TAsio_Form = class(TForm)
    Cpu_Vm: TVumeter;
    Asio_Latency_Vm: TVumeter;
    Asio_Vm: TVumeter;
    Asio_Lb: TLabel;
    Cpu_Lb: TLabel;
    Timer: TTimer;
    Asio_Latency_CkBx: TCheckBox;
    Label1: TLabel;
    Latency_Vm: TVumeter;
    Latency_Lb: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Asio_Form: TAsio_Form;

implementation

uses UParams;

{$R *.dfm}

const
  SystemBasicInformation = 0;
  SystemPerformanceInformation = 2;
  SystemTimeInformation = 3;

type
  TPDWord = ^DWORD;
  TSystem_Basic_Information = packed record
    dwUnknown1: DWORD;
    uKeMaximumIncrement: ULONG;
    uPageSize: ULONG;
    uMmNumberOfPhysicalPages: ULONG;
    uMmLowestPhysicalPage: ULONG;
    uMmHighestPhysicalPage: ULONG;
    uAllocationGranularity: ULONG;
    pLowestUserAddress: Pointer;
    pMmHighestUserAddress: Pointer;
    uKeActiveProcessors: ULONG;
    bKeNumberProcessors: byte;
    bUnknown2: byte;
    wUnknown3: word;
  end;
  TSystem_Performance_Information = packed record
    liIdleTime: LARGE_INTEGER; {LARGE_INTEGER}
    dwSpare: array[0..75] of DWORD;
  end;
  TSystem_Time_Information = packed record
    liKeBootTime: LARGE_INTEGER;
    liKeSystemTime: LARGE_INTEGER;
    liExpTimeZoneBias: LARGE_INTEGER;
    uCurrentTimeZoneId: ULONG;
    dwReserved: DWORD;
  end;

var
  NtQuerySystemInformation: function(infoClass: DWORD;
  buffer: Pointer;
  bufSize: DWORD;
  returnSize: TPDword): DWORD; stdcall = nil;
  liOldIdleTime: LARGE_INTEGER = ();
  liOldSystemTime: LARGE_INTEGER = ();

function Li2Double(x: LARGE_INTEGER): Double;
begin
  Result := x.HighPart * 4.294967296E9 + x.LowPart
end;

Function GetCPUUsage:Float;
var
  SysBaseInfo: TSystem_Basic_Information;
  SysPerfInfo: TSystem_Performance_Information;
  SysTimeInfo: TSystem_Time_Information;
  dbSystemTime: Double;
  dbIdleTime: Double;
begin
  Result:=0;
  if @NtQuerySystemInformation = nil then
  NtQuerySystemInformation := GetProcAddress(GetModuleHandle('ntdll.dll'),'NtQuerySystemInformation');
  if (liOldIdleTime.QuadPart <> 0) then
  begin
    dbIdleTime := Li2Double(SysPerfInfo.liIdleTime) - Li2Double(liOldIdleTime);
    dbSystemTime := Li2Double(SysTimeInfo.liKeSystemTime) - Li2Double(liOldSystemTime);
    If dbSystemTime<>0 Then
      Begin
        dbIdleTime := dbIdleTime / dbSystemTime;
        If SysBaseInfo.bKeNumberProcessors<>0 Then
        dbIdleTime := 100.0 - dbIdleTime * 100.0 / SysBaseInfo.bKeNumberProcessors + 0.5;
        If dbIdleTime<0 Then dbIdleTime:=0;
        Result:=dbIdleTime;
      End;  
  end;
  liOldIdleTime := SysPerfInfo.liIdleTime;
  liOldSystemTime := SysTimeInfo.liKeSystemTime;
end;

{>>Proc�dure � l'affichage de la forme}
procedure TAsio_Form.FormShow(Sender: TObject);
begin
  //On active/d�sactive le timer
  Timer.Enabled:=Asio_Form.Showing;
end;

{>>Proc�dure appel�e par le timer s'il est actif}
procedure TAsio_Form.TimerTimer(Sender: TObject);
Var
  Info:BASS_INFO;
  Asio_Latency:Extended;
begin    
  //On r�cup�re le taux de CPU dans Cpu_Vm
  Cpu_Vm.Pos:=Round(GetCPUUsage);
  //On r�cup�re le taux de CPU utilis� par l'asio dans Asio _Vm
  Asio_Vm.Pos:=Round(BASS_ASIO_GetCPU);
  //Si l'asio est activ� alors
  If BASS_ASIO_IsStarted Then
    Begin
      //On d�termine la latence d'entr�e ou de sorties en seconde de l'asio
      Asio_Latency:=BASS_ASIO_GetLatency(Asio_Latency_CkBx.Checked)/BASS_ASIO_GetRate;
      //On affiche cette derni�re en millisecondes
      Asio_Latency_Vm.Pos:=Round(Asio_Latency*1000);
    End;
  //On r�cup�re les infos du device Audio
  BASS_GetInfo(Info);
  //S'il n'y a pas eu d'erreur alors
  If BASS_ErrorGetCode=0 Then
  //On affiche la latence
  Latency_Vm.Pos:=Info.latency;
end;

end.
