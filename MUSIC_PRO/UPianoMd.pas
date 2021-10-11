unit UPianoMd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BrowserMidi, Menus, ComCtrls, ToolWin, Piano, StdCtrls, TimeLine,
  Buttons, GaugeBar, DuringTime, Player, ExtCtrls, potentio, Bass, BassMidi,
  PianoGrid, hh, hh_funcs, D6OnHelpFix;

type
  TPiano_Form = class(TForm)
    Browser_ScBx: TScrollBox;
    Piano_MnMenu: TMainMenu;
    Files_MnItem: TMenuItem;
    New_MnItem: TMenuItem;
    Open_MnItem: TMenuItem;
    Save_MnItem: TMenuItem;
    Export_MnItem: TMenuItem;
    To_Wav_MnItem: TMenuItem;
    To_Midi_MnItem: TMenuItem;
    Exit_MnItem: TMenuItem;
    Notes_MnItem: TMenuItem;
    Edition_MnItem: TMenuItem;
    SelectMode_MnItem: TMenuItem;
    SelectAllMode_MnItem: TMenuItem;
    DeleteMode_MnItem: TMenuItem;
    MoveMode_MnItem: TMenuItem;
    CopyMode_MnItem: TMenuItem;
    PastMode_MnItem: TMenuItem;
    Actions_MnItem: TMenuItem;
    Play_MnItem: TMenuItem;
    Stop_MnItem: TMenuItem;
    Pause_MnItem: TMenuItem;
    FF_MnItem: TMenuItem;
    RW_MnItem: TMenuItem;
    Windows_MnItem: TMenuItem;
    Mix_MnItem: TMenuItem;
    Tracks_MnItem: TMenuItem;
    Pattern_MnItem: TMenuItem;
    Help_MnItem: TMenuItem;
    Piano_ClBr: TCoolBar;
    Piano_TlBr: TToolBar;
    New_Bt: TSpeedButton;
    Open_Bt: TSpeedButton;
    Save_Bt: TSpeedButton;
    Separator1_TlBt: TToolButton;
    OctaveUp_Bt: TSpeedButton;
    OctaveDown_Bt: TSpeedButton;
    Octave_MnItem: TMenuItem;
    UpOctave_MnItem: TMenuItem;
    DownOctave_MnItem: TMenuItem;
    Record_MnItem: TMenuItem;
    StartRecord_MnItem: TMenuItem;
    StopRecord_MnItem: TMenuItem;
    UpMax_Bt: TSpeedButton;
    DownMax_Bt: TSpeedButton;
    Volume_GgBr: TGaugeBar;
    Tempo_GgBr: TGaugeBar;
    Player: TPlayer;
    CntrlMd_Pn: TPanel;
    PitchBend_Pot: TPotentio;
    Velocity_Pot: TPotentio;
    Sustain_Pot: TPotentio;
    PortTime_Pot: TPotentio;
    ChannPress_Pot: TPotentio;
    Volume_Pot: TPotentio;
    Modulation_Pot: TPotentio;
    PortSwitch_Pot: TPotentio;
    Resonance_Pot: TPotentio;
    PortNote_Pot: TPotentio;
    Panoramic_Pot: TPotentio;
    Vibrato_Pot: TPotentio;
    Expression_Pot: TPotentio;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    NilMode_MnItem: TMenuItem;
    AddMode_MnItem: TMenuItem;
    Midi_Properties_MnItem: TMenuItem;
    Params_MnItems: TMenuItem;
    DuringTime: TDuringTime;
    Piano_ScBx: TScrollBox;
    BrowserMidi: TBrowserMidi;
    TimeLine: TTimeLine;
    Piano: TPiano;
    PianoGrid: TPianoGrid;
    File_Creating_PrBr: TProgressBar;
    procedure New_MnItemClick(Sender: TObject);
    procedure Open_MnItemClick(Sender: TObject);
    procedure Save_MnItemClick(Sender: TObject);
    procedure Exit_MnItemClick(Sender: TObject);
    procedure To_Midi_MnItemClick(Sender: TObject);
    procedure To_Wav_MnItemClick(Sender: TObject);
    procedure UpOctave_MnItemClick(Sender: TObject);
    procedure NilMode_MnItemClick(Sender: TObject);
    procedure Mix_MnItemClick(Sender: TObject);
    procedure Tracks_MnItemClick(Sender: TObject);
    procedure Pattern_MnItemClick(Sender: TObject);
    procedure Play_MnItemClick(Sender: TObject);
    procedure Stop_MnItemClick(Sender: TObject);
    procedure Pause_MnItemClick(Sender: TObject);
    procedure RW_MnItemClick(Sender: TObject);
    procedure PianoGridNote_Off_Event(Sender: TObject; Note: TNote);
    procedure PianoGridNote_On_Event(Sender: TObject; Note: TNote);
    procedure DuringTimeDblClick(Sender: TObject);
    procedure DuringTimeTimeChange(Sender: TObject);
    procedure Volume_GgBrChange(Sender: TObject);
    procedure Tempo_GgBrChange(Sender: TObject);
    procedure BrowserMidiSndFntClick_Event(Sender: TObject);
    procedure PianoGridClick(Sender: TObject);
    procedure PianoNoteIn(const Note: Byte);
    procedure PianoOffNoteIn(const Note: Byte);
    procedure BrowserMidiInstrClick_Event(Sender: TObject);
    procedure PianoGridAddNote(const Note: TNote);
    procedure UpMax_BtClick(Sender: TObject);
    procedure Midi_Properties_MnItemClick(Sender: TObject);
    procedure StartRecord_MnItemClick(Sender: TObject);
    procedure StopRecord_MnItemClick(Sender: TObject);
    procedure Params_MnItemsClick(Sender: TObject);
    procedure DuringTimeDuringOfTimeClick(Sender: TObject);
    procedure DuringTimeTimeClick(Sender: TObject);
    procedure Piano_ScBxClick(Sender: TObject);
    procedure PianoGridPlaying_Event(Sender: TObject);
    procedure FF_MnItemClick(Sender: TObject);
    procedure Help_MnItemClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Piano_Form: TPiano_Form;
  MidiGridStream,MidiGdNoteStream:HStream;
  MidiGridSndFont,MidiGdNoteSndFont:BASS_MIDI_FONT;

implementation

Uses UFiles, UPianoCntrl, UMix, UTracks, UMidiSound, UPatternMd, UGnSound,
  UParams, UAcquisitionMd, UGnBass, UMain;

{$R *.dfm}

{>>Créer un nouveau projet }
procedure TPiano_Form.New_MnItemClick(Sender: TObject);
begin
  //On supprime toutes les notes de PianoGrid
  PianoGrid.NoteCnt.Clear;
  //On rafraichit PianoGrid
  PianoGrid.Refresh;
  //On rafraichit MdCntrPn
  CntlMd_Form.MidiControlsPanel.Refresh;
end;

{>>Ouvrir un projet}
procedure TPiano_Form.Open_MnItemClick(Sender: TObject);
begin
  //Avec OpenDialog faire
  With OpenDialog Do
    Begin
      //On définit le filtre
      Filter:='PatternFiles|*.pnf';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If Not Execute Then Exit;
      //On ouvre le projet filename
      Open_Project(FileName,[BrowserMidi,PianoGrid,CntlMd_Form.MidiControlsPanel]);
      //On rafraichit BrowserMidi
      BrowserMidi.Refresh;
      //On rafraichit PianoGrid
      PianoGrid.Refresh;
      //On rafraichit MdCntrPn
      CntlMd_Form.MidiControlsPanel.Refresh;
    End;
end;

{>>Sauvegarder un projet}   
procedure TPiano_Form.Save_MnItemClick(Sender: TObject);
begin
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='PatternFiles|*.pnf';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If Not Execute Then Exit;
      //On sauve le projet dans le fichier filename
      Save_Project(FileName,[BrowserMidi,PianoGrid,CntlMd_Form.MidiControlsPanel]);
    End;
end;

{>>Créer un fichier Midi}
procedure TPiano_Form.To_Midi_MnItemClick(Sender: TObject);
begin
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='Fichier Midi|*.midi';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé ou que le tempo est nul on sort
      If (Not Execute) Or (Tempo_GgBr.Pos=0)  Then Exit;
      //On crée le fichier Midi
      Piano_To_MidiFile(FileName);
    End;
end;

{>>Créer un fichier Wav}
procedure TPiano_Form.To_Wav_MnItemClick(Sender: TObject);
Var
 TempMidiFile,SndFontFilename:String;
begin
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='Fichier Wav|*.Wav';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé ou que tout n'est pas renseigné sur le Wav on sort
      If (Not Execute) Or (Not Params_Wav_Midi_Completed)  Then Exit;
      //On définit TempMidiFile
      TempMidiFile:=ChangeFileExt(ExtractFileDir(ParamStr(0))+'\Temps\'+ExtractFileName(FileName),'midi');
      //On crée un midiFile temporaire
      Piano_To_MidiFile(TempMidiFile);
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
          MidiStream_To_WavFile(TempMidiFile,FileName,SndFontFilename,File_Creating_PrBr);
        End;
      //On supprime le midi temporaire  
      DeleteFile(TempMidiFile);
    End;
end;

{>>Fermeture de l'application}
procedure TPiano_Form.Exit_MnItemClick(Sender: TObject);
begin
  //On appelle la procédure Close de la page principale
  Main_Form.Close;
end;

{>>Augmentation/Diminution de l'octave}
procedure TPiano_Form.UpOctave_MnItemClick(Sender: TObject);
Var
  IncValue:Integer;
begin
 //Si le sender est UpOctave_MnItem alors IncValuevaut 1 sinon il vaut -1
  If Sender=UpOctave_MnItem Then IncValue:=1 Else IncValue:=-1;
  //On incrémente l'Octave dans PianoGrid
  PianoGrid.Octave:=PianoGrid.Octave+IncValue;
  //On rafraichit PianoGrid 
  PianoGrid.Refresh;
  //On incrémente l'octave dans le piano
  Piano.Octave:=Piano.Octave+IncValue;
  //On rafraichit le piano
  Piano.Refresh
end;

{>>Sélection du mode pour PianoGrid}
procedure TPiano_Form.NilMode_MnItemClick(Sender: TObject);
Var
  IndexSender,IndexNote:Cardinal;
begin
  //On récupère dans IndexSender l'index du Sender
  IndexSender:=Edition_MnItem.IndexOf(Sender As TMenuItem);
  //Avec PianoGrid faire
  With PianoGrid Do
  Case IndexSender Of
    0..3 : Mode:=TMode(IndexSender); //On modifie le mode de PianoGrid
    4    : CopyNote; //On copie la sélection
    5    : PastNote; //On colle la sélection
    6    : Begin
             If NoteCnt.Count>0 Then //Si on a des notes
             For IndexNote:=0 To (NoteCnt.Count-1) Do //Pour toutes les notes
             NoteCnt.Items[IndexNote].Selected:=True; //On les sélectionne
           End;
    7    : DelNote; //On supprime la sélection
  End;
  //On rafraichit le PianoGrid
  PianoGrid.Refresh;
end;

{>>Affichage du Mix}
procedure TPiano_Form.Mix_MnItemClick(Sender: TObject);
begin
  //On affiche Mix_Form
  Mix_Form.Show;
end;

{>>Affichage des Tracks}
procedure TPiano_Form.Tracks_MnItemClick(Sender: TObject);
begin
  //On affiche Tracks_Form
  Tracks_Form.Show;
end;

{>>Affichage de la pattern}
procedure TPiano_Form.Pattern_MnItemClick(Sender: TObject);
begin
  //On affiche Pattern_Form
  Pattern_Form.Show;
end;

{>>On affiche les controles midi}
procedure TPiano_Form.Midi_Properties_MnItemClick(Sender: TObject);
begin
  //On affiche CntlMd_Form
  CntlMd_Form.Show;
end;

{>>Affichage du panel des paramètres}
procedure TPiano_Form.Params_MnItemsClick(Sender: TObject);
begin
  //On affiche Params_Form
  Params_Form.Show;
end;

{>>Lecture de la grille}
procedure TPiano_Form.Play_MnItemClick(Sender: TObject);
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
      //On initialise MidiGridStream
      Initialize_MidiStream(MidiGridStream,BASS_SAMPLE_FLOAT);
      //On définit le nom du fichier SoundFont
      SndFontFilename:=SoundFont.Items[SoundFontSelected].FileName;
      //On charge la SoundFont
      Load_SoundFont(MidiGridStream,MidiGridSndFont,SndFontFilename);
      //On joue MidiPatternStream
      BASS_ChannelPlay(MidiGridStream,True);    
      //On définit que la lecture aura lieu vers la droite
      PianoGrid.PlayDirection:=PlToRight;
      //On active la lecture
      PianoGrid.Start:=True;
      //On lance la TimeLine
      TimeLine.Start:=True;
      //On change le volume
      Volume_GgBrChange(Sender);             
    End;
end;

{>>Arret de la grille}
procedure TPiano_Form.Stop_MnItemClick(Sender: TObject);
begin
  //On désactive la lecture de PianoGrid
  PianoGrid.Stop;
  //On désactive la lecture de TimeLine
  TimeLine.Stop;
  //On libère la SoundFont
  Free_SoundFont(MidiGridStream,MidiGridSndFont);
  //On libère MidiGridStream
  Finalize_MidiStream(MidiGridStream);
  //Avec PianoGrid faire
  With PianoGrid Do
    Begin
      //On repositionne Max
      Max:=Max-Min;
      //On repositionne Min
      Min:=0;
      //On repositionne le curseur
      Pos:=0;
    End;
  //Avec TimeLine faire
  With TimeLine Do
    Begin
      //On repositionne Max
      Max:=Max-Min;
      //On repositionne Min
      Min:=0;
      //On repositionne le curseur
      Pos:=0;
    End;
end;

{>>Pause de la grille}
procedure TPiano_Form.Pause_MnItemClick(Sender: TObject);
begin
  //Si MidiGridStream existe alors
  If MidiGridStream<>0 Then
    Begin
      //On active/désactive la lecture de PianoGrid
      PianoGrid.Start:=Not PianoGrid.Start;
      //On active/désactive la lecture de TimeLine
      TimeLine.Start:=PianoGrid.Start;
      //On réinitialise le temps
    End;  
end;

{>>Retour de la grille}
procedure TPiano_Form.RW_MnItemClick(Sender: TObject);
begin
  //La lecture aura lieu vers la droite dans PianoGrid
  PianoGrid.PlayDirection:=PlToLeft;
  //La lecture aura lieu vers la droite dans TimeLine
  TimeLine.PlayDirection:=CsToLeft;
  //On réinitialise le temps
  Player.Time:=0;
end;

{>>Avance de la grille}
procedure TPiano_Form.FF_MnItemClick(Sender: TObject);
begin
  //La lecture aura lieu vers la gauche dans PianoGrid
  PianoGrid.PlayDirection:=PlToRight;
  //La lecture aura lieu vers la gauche dans TimeLine
  TimeLine.PlayDirection:=CsToRight;
  //On réinitialise le temps
  Player.Time:=0;
end;

{>>Arrets des notes}
procedure TPiano_Form.PianoGridNote_Off_Event(Sender: TObject;
  Note: TNote);
begin
  //Avec la note faire
  With Note Do
    Begin
      //On jouer la note avec tout ces paramètres
      Press_Note(MidiGridStream,Channel,Note,0);
      //On ajoute la note dans le piano
      Piano.Add_NoteOff(Note);
      //On rafraichit le piano
      Piano.Refresh;
    End;
end;

{>>Lectures des notes}
procedure TPiano_Form.PianoGridNote_On_Event(Sender: TObject; Note: TNote);
begin
  //On définit les évènements de la note
  NoteGrid_Define_MidiEvents(MidiGridStream,Note);
  //Avec la note faire
  With Note Do
    Begin
      //On joue la note avec tout ces paramètres
      Press_Note(MidiGridStream,Channel,Note,Velocity);
      //On ajoute la note dans le piano
      Piano.Add_NoteOn(Note);
    End;
  //On rafraichit le piano
  Piano.Refresh;
end;

{>>Modification du temps de lecture}
procedure TPiano_Form.PianoGridPlaying_Event(Sender: TObject);
begin
  //On incrémente le temps écoulé dans Player
  Player.Time:=PianoGrid.PlayingTime;
end;

{>>Modification de la durée d'une note}
procedure TPiano_Form.DuringTimeDblClick(Sender: TObject);
begin
  //On modifie la durée dans PianoGrid
  PianoGrid.DuringOfTime:=DuringTime.DuringOfTime;
  //On modifie la durée dans TimeLine
  TimeLine.DuringOfTime:=DuringTime.DuringOfTime;
end;

{>>Modification du temps}
procedure TPiano_Form.DuringTimeTimeChange(Sender: TObject);
begin
  //On modifie le temps dans PianoGrid
  PianoGrid.Time:=DuringTime.Time;
  //On modifie le temps dans TimeLine
  TimeLine.Time:=DuringTime.Time;
end;

{>>Modification du volume}
procedure TPiano_Form.Volume_GgBrChange(Sender: TObject);
begin
  //On change le volume de MidiGridStream
  Change_Volume_Stream(MidiGridStream,Volume_GgBr.Pos);
end;

{>>Modification du tempo}
procedure TPiano_Form.Tempo_GgBrChange(Sender: TObject);
begin
  //On change le tempo dans la grille
  PianoGrid.Tempo:=Tempo_GgBr.Pos;
  //On change le tempo dans la TimeLine
  TimeLine.Tempo:=Tempo_GgBr.Pos;
  //On change le Tempo du métronome
  Change_Tempo(MetronomeStream,Tempo_GgBr.Pos);
end;

{>>Modification de la durée d'une note}
procedure TPiano_Form.DuringTimeDuringOfTimeClick(Sender: TObject);
begin
  //On change la durée d'une note dans la grille
  PianoGrid.DuringOfTime:=DuringTime.DuringOfTime;
  //On change la durée d'une note dans la TimeLine
  TimeLine.DuringOfTime:=DuringTime.DuringOfTime;
end;

{>>Modification du Temps}
procedure TPiano_Form.DuringTimeTimeClick(Sender: TObject);
begin
  //On change la durée d'une note dans la grille
  PianoGrid.Time:=DuringTime.Time;
  //On change la durée d'une note dans TimeLine
  TimeLine.Time:=DuringTime.Time;
end;

{>>Sélection d'une SoundFont}
procedure TPiano_Form.BrowserMidiSndFntClick_Event(Sender: TObject);
Var
  SndFontFilename:String;
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
  //Si une SoundFont est sélectionnée alors
  If SoundFontSelected>-1 Then
    Begin
      //On définit le nom du fichier SoundFont
      SndFontFilename:=SoundFont.Items[SoundFontSelected].FileName;
      //On charge la nouvelle SoundFont
      Load_SoundFont(MidiPatternStream,MidiGridSndFont,SndFontFilename);
    End;
end;

{>>Changement de la note sélectionnée}
procedure TPiano_Form.PianoGridClick(Sender: TObject);
begin
  //On rafraichit MdCntrPn
  CntlMd_Form.MidiControlsPanel.Refresh;
end;

{>>Appuye d'une note sur le piano}
procedure TPiano_Form.PianoNoteIn(const Note: Byte);
Var
  SndFontFilename:String;
  PianoNote:TNote;
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
  //Si une SoundFont et un instrument sont sélectionnés alors
  If (SoundFontSelected>-1) And (InstrumentSelected>-1) Then
    Begin
      //On définit le nom du fichier SoundFont
      SndFontFilename:=SoundFont.Items[SoundFontSelected].FileName;
      //On crée MidiGdNoteStream
      Initialize_MidiStream(MidiGdNoteStream,BASS_SAMPLE_FLOAT);
      //On charge la SoundFont
      Load_SoundFont(MidiGdNoteStream,MidiGdNoteSndFont,SndFontFilename);
      //On joue MidiGdNoteStream
      BASS_ChannelPlay(MidiGdNoteStream,True);
      //On change le volume de MidiGdNoteStream
      Change_Volume_Stream(MidiGdNoteStream,Volume_GgBr.Pos);
      //On crée PianoNote
      PianoNote:=TNote.Create(Nil);
      //On définit la note de PianoNote
      PianoNote.Note:=Note;
      //On définit les paramètres de PianoNote
      PianoGridAddNote(PianoNote);
      //On définit les évènements de PianoNote
      NoteGrid_Define_MidiEvents(MidiGdNoteStream,PianoNote);
      //On joue PianoNote
      Press_Note(MidiGdNoteStream,PianoNote.Channel,Note,PianoNote.Velocity);
      //On libère PianoNote
      PianoNote.Free;
    End;
end;

{>>Relachement d'une note sur le piano}
procedure TPiano_Form.PianoOffNoteIn(const Note: Byte);
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
  //Si une SoundFont et un instrument sont sélectionnés alors
  If (SoundFontSelected>-1) And (InstrumentSelected>-1) Then
    Begin
      //On libère la SoundFont     
      Free_SoundFont(MidiGdNoteStream,MidiGdNoteSndFont);
      //On libère MidiGdNoteStream
      Finalize_MidiStream(MidiGdNoteStream);
    End;
end;

{>>Sélection d'un instrument}
procedure TPiano_Form.BrowserMidiInstrClick_Event(Sender: TObject);
begin
  //On définit l'instrument comme celui de la grille
  PianoGrid.InstrumentSelected:=BrowserMidi.InstrumentSelected;
end;

{>>Ajout d'une note}
procedure TPiano_Form.PianoGridAddNote(const Note: TNote);
Var
  IndexCmp:Cardinal;
begin
  //Avec BrowserMidi faire
  With BrowserMidi Do
    Begin
      //Si on a une percussion le Channel est le neuvième
      If InstrumentSelected In [112..119] Then Note.Channel:=9
      //Sinon c'est l'instrument divisé par 8
      Else Note.Channel:=InstrumentSelected Div 8;
    End;
  //Pour tout les composants faire
  For IndexCmp:=0 To (ComponentCount-1) Do
  //Si le composant IndexCmp est un TPotentio alors
  If (Components[IndexCmp] Is TPotentio) Then
  //Avec ce dernier définit comme un TPotentio faire
  With (Components[IndexCmp] As TPotentio) Do
  //On définit la valeur de la propriété midi correspondante
  Note.SetByte(Tag+3,Pos);
  //On définie la nature de l'instrument
  Note.Instr:=PianoGrid.InstrumentSelected;
  //On définit la note sélectionnée
  PianoGrid.OnClick(Self);  
end;

{>>Augmentation des valeurs Max et Min de TimeLine et PianoGrid}
procedure TPiano_Form.UpMax_BtClick(Sender: TObject);
Var
  IncTime:Integer;
begin
 //Si le sender est UpMax_Bt alors IncValue vaut 1 sinon il vaut -1
  If Sender=UpMax_Bt Then IncTime:=1 Else IncTime:=-1;
  //On incrémente Min dans TimeLine
  TimeLine.Min:=TimeLine.Min+IncTime;
  //On incrémente Max dans TimeLine
  TimeLine.Max:=TimeLine.Max+IncTime;
  //On incrémente Min dans PianoGrid
  PianoGrid.Min:=PianoGrid.Min+IncTime;
  //On incrémente Max dans PianoGrid
  PianoGrid.Max:=PianoGrid.Max+IncTime;
  //On rafraichit TimeLine
  TimeLine.Refresh;
  //On rafraichit PianoGrid  
  PianoGrid.Refresh;
end;

{>>Lancement de l'acquisition Midi}
procedure TPiano_Form.StartRecord_MnItemClick(Sender: TObject);
begin
  //Avec Acquisition_Md_Form faire
  With Acquisition_Md_Form Do
    Begin
      //On lance l'acquisition
      Start_Acquisition;
      //On affiche la form
      Show;
    End;
end;

{>>Arret de l'acquisition Midi}
procedure TPiano_Form.StopRecord_MnItemClick(Sender: TObject);
begin
  With Acquisition_Md_Form Do
    Begin
      //On arrette l'acquisition
      Stop_Acquisition;
      //On cache la form
      Hide;
    End;
end;

{>>Positionnement des ScrollBox}
procedure TPiano_Form.Piano_ScBxClick(Sender: TObject);
begin
  //On aligne la scrollbar de MdCntrPn_ScBx à celle de Piano_ScBx
  CntlMd_Form.MdCntrPn_ScBx.HorzScrollBar.Position:=Piano_ScBx.HorzScrollBar.Position;
end;

{>>Affichage de l'aide}
procedure TPiano_Form.Help_MnItemClick(Sender: TObject);
begin
  HtmlHelp(0, PChar(mHelpFile), HH_DISPLAY_TOC,0);
end;

end.
