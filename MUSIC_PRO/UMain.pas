unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ButtonComps, ExtCtrls, Bass, TracksGrid, TracksMix, hh, hh_funcs, D6OnHelpFix;

type
  TMain_Form = class(TForm)
    BackGround_Image: TImage;
    User_Lb: TLabel;
    Psw_Lb: TLabel;
    Enter_Bt: TAOLButton;
    Login_Ed: TEdit;
    Psw_Ed: TEdit;
    procedure Create_Folders;
    procedure Enter_BtClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    function HelpHook(Command: Word; Data: LongInt; var CallHelp: Boolean): Boolean;
  public
  end;

var
  Main_Form: TMain_Form;
  IntroMusicStream:HStream;
  mHelpFile: string;

implementation

Uses Md5, UGnBass, UFiles, UTracks, UMidiSound, UPianoMd, UPatternMd;

{$R *.dfm}
{$R MP_Res.res}

const
  HH_HELP_CONTEXT         = $000F;
  HH_DISPLAY_TOPIC        = $0000;

function HtmlHelp(hwndCaller: HWND; pszFile: PChar; uCommand: UINT; dwData: DWORD): HWND; stdcall; external 'HHCTRL.OCX' name 'HtmlHelpA';

{>>Procédure pour s'identifier}
procedure TMain_Form.Enter_BtClick(Sender: TObject);
begin
  // Si le login saisit a le bon hash et
  If (MD5Print(MD5String(Login_Ed.Text))='f9000ed0c1f3168b96894c425fffce74') AND
  // Si le mot de passe saisit a le bon hash et
  (MD5Print(MD5String(Psw_Ed.Text))='ce2c5cd3a2c59ba4180d5a7eb601eb8e') then
    Begin
      //On ouvre Sound_Form
      Tracks_Form.Show;
      //On libère IntroMusicStream
      BASS_StreamFree(IntroMusicStream);
      //On ferme la fiche
      Main_Form.Hide;
    End;
end;

{>>Procédure pour initialiser la musique de départ}
procedure TMain_Form.FormActivate(Sender: TObject);
Var
  Way:String;
begin
  //Si on ne peut pas initialiser Bass et les plugins on sort
  If Not Init_Bass Then Halt(0);
  //On créer les extensions mgf et mpf si elles n'existent pas
  Initialize_Extensions;
  //On créé les répertoires spéciaux
  Create_Folders;
  //On joue la musique d'intro
  Way:=ExtractFileDir(ParamStr(0));
  //Si le fichier Intro.MP3 existe
  If FileExists(Way+'\Ressources\Intro.MP3') Then
    Begin
      //on crée IntroMusicStream
      IntroMusicStream:=BASS_StreamCreateFile(FALSE,PChar(Way+'\Ressources\Intro.MP3'),0,0,BASS_SAMPLE_FLOAT);
      //On joue IntroMusicStream
      BASS_ChannelPlay(IntroMusicStream,True);
    End;
end;

{>>Procédure pour créer les répertoires temporaires et de plugins}
procedure TMain_Form.Create_Folders;
Const
  Folders:Array [0..5] Of String=
  ('\Plugins','\Plugins\VSTE','\Plugins\VSTI','\Plugins\Asio','\Plugins\SoundFont','\Temps');
Var
  Way:String;
  IndexFolder:Cardinal;
Begin
  //Redirection des appels à l'aide 16-bit vers notre gestionnaire d'évènement
  Application.OnHelp := HelpHook;
  //Recherche du chemin du fichier d'aide
  mHelpFile := ExtractFilePath(ParamStr(0)) + 'Ressources\MP_HND.chm';
  //On retourne le chemin complet du fichier d'aide
  mHelpFile := ExpandFileName(mHelpFile);
  //On définit le chemin de l'application
  Way:=ExtractFileDir(ParamStr(0));
  //Pour tout les dossiers faire
  For IndexFolder:=0 To 5 Do
  //Si le dossier Way+Folders[IndexFolder] n'existe pas alors
  If Not DirectoryExists(Way+Folders[IndexFolder]) Then
  //On le crée
  CreateDir(Way+Folders[IndexFolder]);
End;

procedure TMain_Form.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  IndexTrack:Cardinal;
begin
  //Libération de IntroMusicStream
  BASS_StreamFree(IntroMusicStream);
  //On libère Bass et ses plugins
  Free_Bass;
  //Avec Piano_Form faire
  With Piano_Form Do
    Begin
      //On libère MidiGridSndFont
      Free_SoundFont(MidiGridStream,MidiGridSndFont);
      //On libère MidiGridStream
      Finalize_MidiStream(MidiGridStream);
      //On libère MidiGdNoteSndFont
      Free_SoundFont(MidiGdNoteStream,MidiGdNoteSndFont);
      //On libère MidiGdNoteStream
      Finalize_MidiStream(MidiGdNoteStream);
    End;
  //Avec Pattern_Form faire  
  With Pattern_Form Do
    Begin
      //On libère MidiPatternSndFont
      Free_SoundFont(MidiPatternStream,MidiPatternSndFont);
      //On libère MidiPatternStream
      Finalize_MidiStream(MidiPatternStream);
    End;
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //Pour tout les Tracks
      For IndexTrack:=0 To (TrackCnt.Count-1) Do
      //On les supprime du Mix
      Del_Track_In_Mix(TrackCnt.Items[IndexTrack]);
      //On libère MasterStream
      Bass_StreamFree(MasterStream);
    End;         
end;

function  TMain_Form.HelpHook(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
begin
  //Désactivation des appels à l'aide 16-bit
  CallHelp := False;
  //Test sur le paramètre Command qui permet de savoir le type d'aide à ouvrir
  if (Command in [Help_Context]) then
  //Ouverture de l'aide
  HtmlHelp(0, PChar(mHelpFile), HH_HELP_CONTEXT, Data)
  //Sinon
  else
  //Réactivation des appels à l'aide 16-bit
  CallHelp := true;
  //Résultat égal vrai
  Result := true;
end;

end.
