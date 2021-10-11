unit UPatternMd;

interface

uses
  Forms, SysUtils, Variants, Classes, Graphics, Controls, StdCtrls,
  Dialogs, BrowserMidi, Menus, ComCtrls, ToolWin, MidiCntPattern,
  PatternMidi, ExtCtrls, Player, GaugeBar, DuringTime, Buttons,
  MidiWriter, Bass, BassMidi, hh, hh_funcs, D6OnHelpFix;

type

  TPattern_Form = class(TForm)
    Browser_ScBx: TScrollBox;
    Pattern_ScBx: TScrollBox;
    Cntrl_Pn: TPanel;
    MidiCntPattern: TMidiCntPattern;
    Volume_GgBr: TGaugeBar;
    Tempo_GgBr: TGaugeBar;
    Player: TPlayer;
    Pattern_MainMenu: TMainMenu;
    Pattern_ClBr: TCoolBar;
    Piano_TlBr: TToolBar;
    New_Bt: TSpeedButton;
    Open_Bt: TSpeedButton;
    Save_Bt: TSpeedButton;
    Separator1_TlBt: TToolButton;
    DownTime_MnItem: TSpeedButton;
    UpTime_MnItem: TSpeedButton;
    AddTrack_Bt: TSpeedButton;
    DelTrack_Bt: TSpeedButton;
    Files_MnItem: TMenuItem;
    Exit_MnItem: TMenuItem;
    Export_MnItem: TMenuItem;
    Export_To_Wav_MnItem: TMenuItem;
    Export_To_Midi_MnItem: TMenuItem;
    Save_MnItem: TMenuItem;
    Open_MnItem: TMenuItem;
    New_MnItem: TMenuItem;
    Pattern_MnItem: TMenuItem;
    Instr_MnItem: TMenuItem;
    InstrDel_MnItem: TMenuItem;
    InstrAdd_MnItem: TMenuItem;
    Step_MnItem: TMenuItem;
    DownStep_MnItem: TMenuItem;
    UpStep_MnItem: TMenuItem;
    Metronome_MnItem: TMenuItem;
    StopMetro_MnItem: TMenuItem;
    MetroPlay_MnItem: TMenuItem;
    Rythm_MnItem: TMenuItem;
    Samba_MnItem: TMenuItem;
    SlowJam_MnItem: TMenuItem;
    Rock3_MnItem: TMenuItem;
    Rock2_MnItem: TMenuItem;
    Rock1_MnItem: TMenuItem;
    PopRock3_MnItem: TMenuItem;
    PopRock2_MnItem: TMenuItem;
    PopRock1_MnItem: TMenuItem;
    MotownGroove_MnItem: TMenuItem;
    LatinGroove_MnItem: TMenuItem;
    JBIsh_MnItem: TMenuItem;
    JazzSwing_MnItem: TMenuItem;
    HeavyBallad_MnItem: TMenuItem;
    HalfTimeShuffle_MnItem: TMenuItem;
    Funk3_MnItem: TMenuItem;
    Funk2_MnItem: TMenuItem;
    Funk1_MnItem: TMenuItem;
    EJam_MnItem: TMenuItem;
    BonzoGroove_MnItem: TMenuItem;
    TicTac_MnItem: TMenuItem;
    Actions_MnItem: TMenuItem;
    RW_MnItem: TMenuItem;
    FF_MnItem: TMenuItem;
    Pause_MnItem: TMenuItem;
    Stop_MnItem: TMenuItem;
    Play_MnItem: TMenuItem;
    Windows_MnItem: TMenuItem;
    PianoRoll_MnItem: TMenuItem;
    Tracks_MnItem: TMenuItem;
    Mixage_MnItem: TMenuItem;
    Help_MnItem: TMenuItem;
    Note_MnItem: TMenuItem;
    B_MnItem: TMenuItem;
    ASharp_MnItem: TMenuItem;
    A_MnItem: TMenuItem;
    GSharp_MnItem: TMenuItem;
    G_MnItem: TMenuItem;
    FSharp_MnItem: TMenuItem;
    F_MnItem: TMenuItem;
    E_MnItem: TMenuItem;
    DSharp_MnItem: TMenuItem;
    D_MnItem: TMenuItem;
    CSharp_MnItem: TMenuItem;
    C_MnItem: TMenuItem;
    Octave_MnItem: TMenuItem;
    Octave10_MnItem: TMenuItem;
    Octave9_MnItem: TMenuItem;
    Octave8_MnItem: TMenuItem;
    Octave7_MnItem: TMenuItem;
    Octave6_MnItem: TMenuItem;
    Octave5_MnItem: TMenuItem;
    Octave4_MnItem: TMenuItem;
    Octave3_MnItem: TMenuItem;
    Octave2_MnItem: TMenuItem;
    Octave1_MnItem: TMenuItem;
    Octave0_MnItem: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    BrowserMidi: TBrowserMidi;
    PatternMidi: TPatternMidi;
    Asio_MnItem: TMenuItem;
    DuringTime: TDuringTime;
    File_Creating_PrBr: TProgressBar;
    procedure New_MnItemClick(Sender: TObject);
    procedure Open_MnItemClick(Sender: TObject);
    procedure Save_MnItemClick(Sender: TObject);
    procedure Export_To_Midi_MnItemClick(Sender: TObject);
    procedure Export_To_Wav_MnItemClick(Sender: TObject);
    procedure Exit_MnItemClick(Sender: TObject);
    procedure UpStep_MnItemClick(Sender: TObject);
    procedure DownStep_MnItemClick(Sender: TObject);
    procedure C_MnItemClick(Sender: TObject);
    procedure Octave0_MnItemClick(Sender: TObject);
    procedure InstrAdd_MnItemClick(Sender: TObject);
    procedure InstrDel_MnItemClick(Sender: TObject);
    procedure Play_MnItemClick(Sender: TObject);
    procedure Stop_MnItemClick(Sender: TObject);
    procedure Pause_MnItemClick(Sender: TObject);
    procedure PatternMidiNote_On_Event(Sender: TObject;
      Instrument: TInstrPattern; Note: TNote);
    procedure PatternMidiNote_Off_Event(Sender: TObject;
      Instrument: TInstrPattern; Note: TNote);
    procedure FF_MnItemClick(Sender: TObject);
    procedure Mixage_MnItemClick(Sender: TObject);
    procedure Tracks_MnItemClick(Sender: TObject);
    procedure PianoRoll_MnItemClick(Sender: TObject);
    procedure BrowserMidiChange(Sender: TObject);
    procedure MidiCntPatternChange(Sender: TObject);
    procedure PatternMidiClick(Sender: TObject);
    procedure BrowserMidiSndFntClick_Event(Sender: TObject);
    procedure Volume_GgBrChange(Sender: TObject);
    procedure Tempo_GgBrChange(Sender: TObject);
    procedure DuringTimeClick(Sender: TObject);
    procedure MetroPlay_MnItemClick(Sender: TObject);
    procedure StopMetro_MnItemClick(Sender: TObject);
    procedure TicTac_MnItemClick(Sender: TObject);
    procedure Asio_MnItemClick(Sender: TObject);
    procedure Params_MnItemsClick(Sender: TObject);
    procedure PatternMidiPlaying_Event(Sender: TObject);
    procedure RW_MnItemClick(Sender: TObject);
    procedure Help_MnItemClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Pattern_Form: TPattern_Form;
  MidiPatternStream:HStream;
  MidiPatternSndFont:BASS_MIDI_FONT;

implementation

Uses UMain, UFiles,UMix, UTracks, UPianoMd, UMidiSound, UParams, UGnSound, UGnBass,
  UAsio;

{$R *.dfm}

{>>Créer un nouveau projet }
procedure TPattern_Form.New_MnItemClick(Sender: TObject);
Const
  DrumsLabel:Array[0..5] Of String=
  ('HIT HAT','CYMBALE CRASH','CYMBALE RIDE','CAISSE CLAIRE','TOM ALTO','TOM MEDIUM');
  DrumsInstr:Array[0..5] Of Byte=(44,49,51,31,50,47);
Var
  IndexInstr,IndexNote:Cardinal;
  NewInstr:TInstrPattern;
begin
  //On arrette la lecture éventuelle
  Stop_MnItemClick(Self);
  //Avec PatternMidi faire
  With PatternMidi Do
    Begin
      //On efface tout les instruments
      InstrPatternCnt.Clear;
      //On redéfinit le nombre de steps
      NbCases:=16;
      //Pour IndexInstr allant de 0 à 5 faire
      For IndexInstr:=0 To 5 Do
        Begin
          //On créer 1 nouvel instrument
          NewInstr:=InstrPatternCnt.Add;
          //On définit les paramètres midi par défaut
          DefaultParams_Pattern(NewInstr);
          //Avec ce dernier faire
          With NewInstr Do
            Begin
              //On définit le channel à 9 (Batterie)
              Channel:=9;
              //On définit le nom de l'instrument
              Instrument:=DrumsLabel[IndexInstr];
              //On définit l'instrument
              Instr:=114;
              //Pour toutes les notes faire
              For IndexNote:=0 To (NbCases-1) Do
              //On définit la valeur de la note
              NoteCnt.Items[IndexNote].Note:=DrumsInstr[IndexInstr];
            End;
        End;
      //On rafraichit le tout  
      Refresh;
      //On rafraichit MidiCntPattern
      MidiCntPattern.Refresh;
    End;      
end;

{>>Ouvrir un projet}
procedure TPattern_Form.Open_MnItemClick(Sender: TObject);
begin
  //Avec OpenDialog faire
  With OpenDialog Do
    Begin
      //On définit le filtre
      Filter:='PatternFiles|*.ptf';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If Not Execute Then Exit;
      //On ouvre le projet filename
      Open_Project(FileName,[BrowserMidi,PatternMidi,MidiCntPattern]);
      //On rafraichit BrowserMidi
      BrowserMidi.Refresh;
      //On rafraichit PatternMidi
      PatternMidi.Refresh;
      //On rafraichit MidiCntPattern      
      MidiCntPattern.Refresh;
    End;
end;

{>>Sauvegarder un projet}
procedure TPattern_Form.Save_MnItemClick(Sender: TObject);
begin
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='PatternFiles|*.ptf';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If Not Execute Then Exit;
      //On sauve le projet dans le fichier filename
      Save_Project(FileName,[BrowserMidi,PatternMidi,MidiCntPattern]);
    End;
end;

{>>Créer un fichier Midi}
procedure TPattern_Form.Export_To_Midi_MnItemClick(Sender: TObject);  
begin
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='Fichier Midi|*.midi';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If (Not Execute) Then Exit;
      //On crée le fichier Midi
      Pattern_To_MidiFile(FileName);
    End;  
end;

{>>Créer un fichier Wav}
procedure TPattern_Form.Export_To_Wav_MnItemClick(Sender: TObject);
Var
 TempMidiFile,SndFontFileName:String;
begin
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='Fichier Wav|*.Wav';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé ou qu'on a pas tout renseigné sur le Wav, on sort
      If (Not Execute) Or (Not Params_Wav_Midi_Completed) Then Exit;
      //On définit TempMidiFile
      TempMidiFile:=ChangeFileExt(ExtractFileDir(ParamStr(0))+'\Temps\'+ExtractFileName(FileName),'midi');
      //On crée un midiFile temporaire
      Pattern_To_MidiFile(TempMidiFile);
      //Si le fichier midi existe et
      If FileExists(TempMidiFile) And
      //qu'une soundfont est sélectionnée alors
      (BrowserMidi.SoundFontSelected>-1) Then
      //Avec BrowserMidi faire
      With BrowserMidi Do
        Begin
          //On définit le nom de la SoundFont
          SndFontFilename:=SoundFont.Items[SoundFontSelected].FileName;
          //On créer le fichier Wav
          MidiStream_To_WavFile(TempMidiFile,FileName,SndFontFileName,File_Creating_PrBr);
        End;
      //On supprime le midi temporaire  
      DeleteFile(TempMidiFile);
    End;  
end;

{>>Fermeture de l'application}
procedure TPattern_Form.Exit_MnItemClick(Sender: TObject);
begin
  //On appelle la procédure Close de la page principale
  Main_Form.Close;
end;

{>>Augmentation du nombre de steps}
procedure TPattern_Form.UpStep_MnItemClick(Sender: TObject);
begin
 //On incrémente le nombre de cases
 PatternMidi.NbCases:=PatternMidi.NbCases+1;
 //On rafraichit PatternMidi
 PatternMidi.Refresh;
end;

{>>Diminution du nombre de steps}
procedure TPattern_Form.DownStep_MnItemClick(Sender: TObject);
begin
  //Si on a plus de 16 cases
  If PatternMidi.NbCases>16 Then
    Begin
      //On diminue le nombre de cases de 1
      PatternMidi.NbCases:=PatternMidi.NbCases-1;
      //On rafraichit PatternMidi 
      PatternMidi.Refresh;
    End;
end;

{>>Sélection d'une note}
procedure TPattern_Form.C_MnItemClick(Sender: TObject);
Var
  IndexNote:Integer;
begin
  //Pour toutes les notes possibles
  For IndexNote:=0 To 11 Do
  //Le MenuItem correspondant n'est pas checké
  Note_MnItem.Items[IndexNote].Checked:=False;
  //Le MenuItem comme sender est checké
  (Sender As TMenuItem).Checked:=True;
end;

{>>Sélection d'un octave}
procedure TPattern_Form.Octave0_MnItemClick(Sender: TObject);
Var
  OctaveNote:Integer;
begin
  //Pour tout les octaves possibles
  For OctaveNote:=0 To 10 Do
  //Le MenuItem correspondant n'est pas checké
  Octave_MnItem.Items[OctaveNote].Checked:=False;
  //Le MenuItem comme sender est checké  
  (Sender As TMenuItem).Checked:=True;
end;

{>>Ajout d'un instrument}
procedure TPattern_Form.InstrAdd_MnItemClick(Sender: TObject);
Const
  PercussionsName : Array [35..81] Of String =
               ('GROSSE CAISSE','GROSSE CAISSE','SIDE STICK','CAISSE CLAIRE','CLAP DE MAINS',
                'CAISSE CLAIRE','TOM BAS','HITHAT AMORTI','TOM HAUT','PÉDALE HITHAT',
                'TOM BASSE','HITHAT OUVERT','TOM MÉDIUM','TOM MÉDIUM','CYMBALE CRASH',
                'TOM ALTO','CYMBALE RIDE','CYMBALE CHINOISE','RIDE BELL','TAMBOURIN',
                'CYMBALE SPLASH','CLOCHE À VACHE','CYMBALE CRASH','VIBRASLAP',
                'CYMBALE RIDE','BONGO ALTO','BONGO BASSE','CONGA AMORTI','CONGA OUVERT',
                'CONGA BASSE','TIMBALE HAUTE','TIMBALE BASSE','AGOGO HAUT','AGOGO BAS',
                'CABASA','MARACAS','PETIT SIFFLET','GRAND SIFFLET','GUIRO COURT',
                'GUIRO LONG','CLAVES','WOODBLOCK HAUT','WOODBLOCK BAS','CUICA AMORTI',
                'CUICA OUVERT','TRIANGLE AMORTI','TRIANGLE OUVERT');
Var
  NewInstr:TInstrPattern;
  CstOctave,CstNote,CstChannel:Byte;
  IndexOctave,IndexNote:Integer;
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
    Begin
      //Si un instrument est sélectionné alors
      If InstrumentSelected>-1 Then
        Begin
          //Initialisation de CstNote
          CstNote:=0;        
          //Initialisation de CstOctave
          CstOctave:=0;
          //Pour tout les octaves faire
          For IndexOctave:=0 To 10 Do
          //Si le MenuItem correspondant est checké alors
          If Octave_MnItem.Items[IndexOctave].Checked Then
          //On définit l'octave comme IndexOctave
          CstOctave:=IndexOctave;
          //Pour toutes les notes faire
          For IndexNote:=0 To 11 Do
          //Si le MenuItem correspondant est checké alors
          If Note_MnItem.Items[IndexNote].Checked Then
          //On définit la note
          CstNote:=IndexNote+CstOctave*11;
          //Si on a une percussion le Channel est le neuvième
          If InstrumentSelected In [112..119] Then CstChannel:=9
          //Sinon c'est l'instrument divisé par 8
          Else CstChannel:=InstrumentSelected Div 8;          
          //On crée un nouvel instrPatternCnt comme assigne à NewPattern
          NewInstr:=PatternMidi.InstrPatternCnt.Add;
          //On définit les paramètres midi par défaut
          DefaultParams_Pattern(NewInstr);          
          //Avec NewPattern faire
          With NewInstr Do
            Begin
              //Si on a batterie et que la note est comprise entre 35 et 81 alors
              If (InstrumentSelected =114) And (CstNote In [35..81]) Then
              //Le nom de l'instrument est celui de la percussion
              Instrument:=PercussionsName[CstNote]
              //Sinon on définit le nom de l'instrument
              Else Instrument:=format(InstrToString(InstrumentSelected)+'-%d',[CstNote]);
              //On définit la valeur midi de l'instrument
              Instr:=InstrumentSelected;
              //On définit le Channel
              Channel:=CstChannel;
              //Si on a des notes alors
              If NoteCnt.Count>0 Then
              //Pour toutes les notes faire
              For IndexNote:=0 To (NoteCnt.Count-1) Do
              //La valeur de la note est SltNote
              NoteCnt.Items[IndexNote].Note:=CstNote;
              //On rafraichit PatternMidi
              PatternMidi.Refresh;
            End;
        End;
    End;
end;

{>>Suppression d'un instrument}
procedure TPattern_Form.InstrDel_MnItemClick(Sender: TObject);
begin
  //Si l'instrument sélectionné est supérieur à 5 alors
  If PatternMidi.InstrumentSelected>5 Then
    Begin
      //On supprime alors le InstrPatternCnt correspondant
      PatternMidi.InstrPatternCnt.Delete(PatternMidi.InstrumentSelected);    
      //On décrémente l'instrument sélectionné
      PatternMidi.InstrumentSelected:=PatternMidi.InstrPatternCnt.Count-1;
      //On rafraichit PatternMidi
      PatternMidi.Refresh;
    End;  
end;

{>>Lecture du pattern}
procedure TPattern_Form.Play_MnItemClick(Sender: TObject);
Var
  SndFontFilename:String;
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
  //Si une SoundFont est sélectionnée alors
  if SoundFontSelected>-1 Then
    Begin
      //On simule le click de Stop_MnItem
      Stop_MnItemClick(Self);
      //On initialise MidiPatternStream
      Initialize_MidiStream(MidiPatternStream,BASS_SAMPLE_FLOAT);
      //On définit le nom du fichier SoundFont
      SndFontFilename:=SoundFont.Items[SoundFontSelected].FileName;
      //On charge la SoundFont
      Load_SoundFont(MidiPatternStream,MidiPatternSndFont,SndFontFilename);
      //On joue MidiPatternStream
      BASS_ChannelPlay(MidiPatternStream,True);
      //On définit que la lecture aura lieu vers la droite
      PatternMidi.PlayDirection:=PlToRight;
      //On active la lecture
      PatternMidi.Start:=True;
      //On change le volume
      Volume_GgBrChange(Sender);
    End;
end;

{>>Arret de la lecture du pattern}
procedure TPattern_Form.Stop_MnItemClick(Sender: TObject);
begin
  //On libère la SoundFont
  Free_SoundFont(MidiPatternStream,MidiPatternSndFont);
  //On libère MidiPatternStream
  Finalize_MidiStream(MidiPatternStream);
  //On désactive la lecture
  PatternMidi.Stop;
end;

{>>Pause de la lecture du pattern}
procedure TPattern_Form.Pause_MnItemClick(Sender: TObject);
begin
  //Si MidiPatternStream existe alors
  If MidiPatternStream<>0 Then
  //On active/désactive la lecture
  PatternMidi.Start:=Not PatternMidi.Start;
end;

{>>Avance de la lecture du pattern}
procedure TPattern_Form.FF_MnItemClick(Sender: TObject);
begin
  //La lecture aura lieu vers la droite
  PatternMidi.PlayDirection:=PlToRight;
  //On réinitialise le temps
  Player.Time:=0;
end;

{>>Retour de la lecture du pattern}
procedure TPattern_Form.RW_MnItemClick(Sender: TObject);
begin
  //La lecture aura lieu vers la gauche
  PatternMidi.PlayDirection:=PlToleft;
  //On réinitialise le temps
  Player.Time:=0;
end;

{>>Lectures des notes}
procedure TPattern_Form.PatternMidiNote_On_Event(Sender: TObject;
  Instrument: TInstrPattern; Note: TNote);
Var
  ChannelNote,VelocityNote,NoteToPlay:Byte;
begin
  //Si la note est activée alors
  If Note.Actived Then
    Begin
      //On définit le Channel
      ChannelNote:=Instrument.Channel;
      //On définit la vélocité
      VelocityNote:=Instrument.Velocity;
      //On définit la note à jouer
      NoteToPlay:=Note.Note;
      Pattern_Define_MidiEvents(MidiPatternStream,Instrument);
      //On jouer la note avec tout ces paramètres
      Press_Note(MidiPatternStream,ChannelNote,NoteToPlay,VelocityNote);
    End;
end;

{>>Arrets des notes}
procedure TPattern_Form.PatternMidiNote_Off_Event(Sender: TObject;
  Instrument: TInstrPattern; Note: TNote);
Var
  ChannelNote,NoteToStop:Byte;
begin
  //Si la note est activée alors
  If Note.Actived Then
    Begin
      //On définit le Channel
      ChannelNote:=Instrument.Channel;
      //On définit la note à arreter
      NoteToStop:=Note.Note;
      //On joue la note avec tout ces paramètres
      Press_Note(MidiPatternStream,ChannelNote,NoteToStop,0);
    End;
end;

{>>Incrémentation du temps}
procedure TPattern_Form.PatternMidiPlaying_Event(Sender: TObject);
begin
  //On incrémente le temps écoulé dans Player
  Player.Time:=PatternMidi.PlayingTime;
  //On rafraichit Player.Refresh;
  Player.Refresh;
end;

{>>Changement de sélection dans BrowserMidi }
procedure TPattern_Form.BrowserMidiChange(Sender: TObject);
begin
  //Si on joue la pattern alors
  If PatternMidi.Start Then
  //On interdit le changement de la soundfont a utiliser
  BrowserMidi.SoundFontSelected:=BrowserMidi.SoundFontSelected;
end;

{>>Changement de sélection de l'instrument de la pattern}
procedure TPattern_Form.PatternMidiClick(Sender: TObject);
begin
  //On rafraichit MidiCntPattern
  MidiCntPattern.Refresh;
end;

{>>Modification des paramètres Midi}
procedure TPattern_Form.MidiCntPatternChange(Sender: TObject);
Var
  Instrument: TInstrPattern;
begin
  //On définit l'instrument sélectionné
  Instrument:=PatternMidi.InstrPatternCnt.Items[PatternMidi.InstrumentSelected];
  //On redéfinit les évènementsde l'instrulent sélectionné
  Pattern_Define_MidiEvents(MidiPatternStream,Instrument);
end;

{>>Affichage du Mix}
procedure TPattern_Form.Mixage_MnItemClick(Sender: TObject);
begin
  //On affiche Mix_Form
  Mix_Form.Show;
end;

{>>Affichage des Tracks}
procedure TPattern_Form.Tracks_MnItemClick(Sender: TObject);
begin
  //On affiche Tracks_Form
  Tracks_Form.Show;
end;

{>>Affichage du Piano}
procedure TPattern_Form.PianoRoll_MnItemClick(Sender: TObject);
begin
  //On affiche Piano_Form
  Piano_Form.Show;
end;

{>>Affichage du panel de l'asio}
procedure TPattern_Form.Asio_MnItemClick(Sender: TObject);
Begin
  //On affiche Asio_Form
  Asio_Form.Show;
end;

{>>Affichage du panel des paramètres}
procedure TPattern_Form.Params_MnItemsClick(Sender: TObject);
begin
  //On affiche Params_Form
  Params_Form.Show;
end;

{>>Sélection d'une SoundFont}
procedure TPattern_Form.BrowserMidiSndFntClick_Event(Sender: TObject);
Var
  SndFontFilename:String;
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
  //Si une SoundFont est sélectionnée alors
  If SoundFontSelected>-1 Then
    Begin
      //On libère la SoundFont précédente
      Free_SoundFont(MidiPatternStream,MidiPatternSndFont);
      //On définit le nom du fichier SoundFont
      SndFontFilename:=SoundFont.Items[SoundFontSelected].FileName;
      //On charge la nouvelle SoundFont
      Load_SoundFont(MidiPatternStream,MidiPatternSndFont,SndFontFilename);
    End;
End;

{>>Modification du volume sonore}
procedure TPattern_Form.Volume_GgBrChange(Sender: TObject);
begin
  //On change le volume de MidiPatternStream
  Change_Volume_Stream(MidiPatternStream,Volume_GgBr.Pos);
  //On change le volume de MetronomeStream
  Change_Volume_Stream(MetronomeStream,Volume_GgBr.Pos);
end;

{>>Modification du tempo}
procedure TPattern_Form.Tempo_GgBrChange(Sender: TObject);
begin
  //On change le tempo dans PatternMidi
  PatternMidi.Tempo:=Tempo_GgBr.Pos;
  //On change le Tempo du métronome
  Change_Tempo(MetronomeStream,Tempo_GgBr.Pos);
end;

{>>Modification de la durée d'une note}
procedure TPattern_Form.DuringTimeClick(Sender: TObject);
begin
  //On change la durée d'une note
  PatternMidi.DuringOfTime:=DuringTime.DuringOfTime;
end;

{>>Lancer le métronome}
procedure TPattern_Form.MetroPlay_MnItemClick(Sender: TObject);
Var
  Way,FormatMetronomeFile,MetronomeFile:String;
  IndexItem:Integer;
begin
  For IndexItem:=0 To (Rythm_MnItem.Count-1) Do
  If Rythm_MnItem.Items[IndexItem].Checked Then
    Begin
      Way:=ExtractFileDir(ParamStr(0))+'\Ressources\';
      If Rythm_MnItem.MenuIndex>-1 Then
        Begin
          MetronomeFile:=Rythm_MnItem.Items[IndexItem].Caption;
          FormatMetronomeFile:=Way+StringReplace(MetronomeFile,'&','',[rfReplaceAll])+'.mid';
          Start_Metronome(FormatMetronomeFile);
          Tempo_GgBrChange(Self);
        End;
    End;
end;

{>>Stopper le métronome}
procedure TPattern_Form.StopMetro_MnItemClick(Sender: TObject);
begin
  Stop_Metronome;
end;

{>>Choix du métronome}
procedure TPattern_Form.TicTac_MnItemClick(Sender: TObject);
Var
  IndexMenu:Integer;
begin
  For IndexMenu:=0 To (Rythm_MnItem.Count-1) Do
    Begin
      If Rythm_MnItem.Items[IndexMenu]<> Sender Then
      Rythm_MnItem.Items[IndexMenu].Checked:=False;
      (Sender As TMenuItem).Checked:=True;
    End;
end;

{>>Affichage de l'aide}
procedure TPattern_Form.Help_MnItemClick(Sender: TObject);
begin
  HtmlHelp(0, PChar(mHelpFile), HH_DISPLAY_TOC,0);
end;

end.
