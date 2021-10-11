unit UTracks;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, TrackTime, StrUtils, TracksGrid, BrowserTracks, Menus,
  Buttons, StdCtrls, Bass, DuringTime, DialogEx,TracksMix, bassmix, hh, hh_funcs,
  D6OnHelpFix, MP3Coder, MP3Coder_Dll;

type
  TTracks_Form = class(TForm)
    Tracks_MnMenu: TMainMenu;
    Files_MnItem: TMenuItem;
    Tracks_ClBr: TCoolBar;
    Tracks_TlBr: TToolBar;
    Tracks_ScBx: TScrollBox;
    TrackTime: TTrackTime;
    New_MnItem: TMenuItem;
    Open_MnItem: TMenuItem;
    Save_MnItem: TMenuItem;
    Exit_MnItem: TMenuItem;
    Edition_MnItem: TMenuItem;
    Copy_MnItem: TMenuItem;
    Past_MnItem: TMenuItem;
    Select_MnItem: TMenuItem;
    Move_MnItem: TMenuItem;
    Cut_MnItem: TMenuItem;
    Tracks_MnItem: TMenuItem;
    AddTrack_MnItem: TMenuItem;
    DelTracks_MnItem: TMenuItem;
    SelectAll_MnItem: TMenuItem;
    Delete_MnItem: TMenuItem;
    RenameTrack_MnItem: TMenuItem;
    Actions_MnItem: TMenuItem;
    Play_MnItem: TMenuItem;
    Stop_MnItem: TMenuItem;
    Pause_MnItem: TMenuItem;
    Export_To_Wav_MnItem: TMenuItem;
    Windows_MnItem: TMenuItem;
    Mix_MnItem: TMenuItem;
    PianoRoll_MnItem: TMenuItem;
    Pattern_MnItem: TMenuItem;
    Help_MnItem: TMenuItem;
    Separator1_TlBt: TToolButton;
    New_Bt: TSpeedButton;
    Open_Bt: TSpeedButton;
    Save_Bt: TSpeedButton;
    AddTrack_Bt: TSpeedButton;
    DelTrack_Bt: TSpeedButton;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    NilMode_MnItem: TMenuItem;
    Merge_MnItem: TMenuItem;
    Params_MnItem: TMenuItem;
    Zoom_Bt: TSpeedButton;
    DownTime_MnItem: TSpeedButton;
    UpTime_MnItem: TSpeedButton;
    Asio_MnItem: TMenuItem;
    Name_Modif_MnItem: TMenuItem;
    Name_Valid_MnItem: TMenuItem;
    Cursors_MnItem: TMenuItem;
    Pos_Show_MnItem: TMenuItem;
    Delims_Show_MnItem: TMenuItem;
    Pos_Delims_Show_MnItem: TMenuItem;
    Pos_Delims_Move_MnItem: TMenuItem;
    Pos_Move_MnItem: TMenuItem;
    Delims_Move_MnItem: TMenuItem;
    Nili_Move_MnItem: TMenuItem;
    BrowserTracks: TBrowserTracks;
    File_Creating_PrBr: TProgressBar;
    TracksGrid: TTracksGrid;
    Export_Mix_MnItem: TMenuItem;
    Export_To_Mp3_MnItem: TMenuItem;
    Procedure Initialize_CollectionTracks(ACollection:TCollection);
    procedure New_MnItemClick(Sender: TObject);
    procedure Open_MnItemClick(Sender: TObject);
    procedure Save_MnItemClick(Sender: TObject);
    procedure AddTrack_BtClick(Sender: TObject);
    procedure Export_To_Wav_MnItemClick(Sender: TObject);
    procedure Exit_MnItemClick(Sender: TObject);
    procedure DelTrack_BtClick(Sender: TObject);
    procedure NilMode_MnItemClick(Sender: TObject);
    procedure Play_MnItemClick(Sender: TObject);
    procedure Mix_MnItemClick(Sender: TObject);
    procedure PianoRoll_MnItemClick(Sender: TObject);
    procedure Pattern_MnItemClick(Sender: TObject);
    procedure Params_MnItemClick(Sender: TObject);
    procedure UpTime_MnItemClick(Sender: TObject);
    procedure BrowserTracksOpen_Event(Sender: TObject);
    procedure BrowserTracksMute_Event(Sender: TObject);
    procedure BrowserTracksSolo_Event(Sender: TObject);
    procedure BrowserTracksAcquisition_Event(Sender: TObject);
    procedure Zoom_BtMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TracksGridDeletePart(Sender: TObject; CrTrack: TTrack;
      CrPart: TPart);
    procedure TracksGridPastPart(Sender: TObject; CrTrack: TTrack;
      CrPart: TPart);
    procedure TracksGridCutPart(Sender: TObject; CrTrack: TTrack; LeftPart,
      RightPart, DelPart: TPart);
    procedure Asio_MnItemClick(Sender: TObject);
    procedure BrowserTracksWrite_Event(Sender: TObject);
    procedure BrowserTracksRead_Event(Sender: TObject);
    procedure Name_Modif_MnItemClick(Sender: TObject);
    procedure Pos_Show_MnItemClick(Sender: TObject);
    procedure Nili_Move_MnItemClick(Sender: TObject);
    procedure BrowserTracksClick(Sender: TObject);
    procedure TracksGridClick(Sender: TObject);
    procedure TrackTimeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Help_MnItemClick(Sender: TObject);
    procedure Export_To_Mp3_MnItemClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Tracks_Form: TTracks_Form;

implementation

Uses UMain, UMix, UFiles, UPatternMd, UPianoMd, UParams, UGnSound, UGnBass,
  UAsio, UEqualizer, UDSP;

{$R *.dfm}

{>>Initialisation d'une collection}
Procedure TTracks_Form.Initialize_CollectionTracks(ACollection:TCollection);
Var
  IndexItems:Cardinal;
Begin
  //On nettoye la collection
  ACollection.Clear;
  //Pour tout les items faire
  For IndexItems:=0 To 4 Do
  //On créer un CollectionItem
  ACollection.Add;
End;

{>>Démarrage d'un nouveau projet}
procedure TTracks_Form.New_MnItemClick(Sender: TObject);
begin
  //Avec Mix_Form faire
  With Mix_Form Do
    Begin
      //Initialisation de BrowserTracks
      Initialize_CollectionTracks(BrowserTracks.BrTracksCnt);
      //Initialisation de TracksGrid
      Initialize_CollectionTracks(TracksGrid.TrackCnt);
      //Initialisation de TracksMix
      Initialize_CollectionTracks(TracksMix.TrackMixCnt);
      //Avec MasterMix faire
      With MasterMix Do
        Begin
          //On remet PrgrBarLeft à zéro
          PrgrBar.Pos:=0;
          //On remet Slider à zéro
          Slider.Pos:=0;
        End;
      //Avec MixPanel faire
      With MixPanel Do
        Begin
          //On nettoye DSP
          DSP.Clear;
          //On nettoye VSTE
          VSTE.Clear;
          //On nettoye VSTI
          VSTI.Clear;
          //On nettoye SoundFont
          SoundFont.Clear;
        End;
      //On rafraichit BrowserTracks
      BrowserTracks.Refresh;
      //On rafraichit TracksGrid
      TracksGrid.Refresh;
      //On rafraichit MixPanel
      MixPanel.Refresh;
      //On rafraichit TracksMix
      TracksMix.Refresh;
      //On rafraichit MixPanel
      MasterMix.Refresh;
    End;
end;

{>>Ouvrir un projet}
procedure TTracks_Form.Open_MnItemClick(Sender: TObject);
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
      //Avec Mix_Form faire
      With Mix_Form Do
        Begin
          //On ouvre le projet filename
          Open_Project(FileName,[BrowserTracks,TracksGrid,TrackTime,MixPanel,TracksMix]);
          //On rafraichit BrowserTracks
          BrowserTracks.Refresh;
          //On rafraichit TracksGrid
          TracksGrid.Refresh;
          //On rafraichit MixPanel
          MixPanel.Refresh;
          //On rafraichit TracksMix
          TracksMix.Refresh;
          //On rafraichit MixPanel
          MasterMix.Refresh;
        End;  
    End;
end;

{>>Sauvegarder un projet}
procedure TTracks_Form.Save_MnItemClick(Sender: TObject);
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
      //Avec Mix_Form faire
      With Mix_Form Do
      //On sauve le projet dans le fichier filename
      Save_Project(FileName,[BrowserTracks,TracksGrid,TrackTime,MixPanel,TracksMix]);
    End;
end;

{>>Mixage sous le format Wav}
procedure TTracks_Form.Export_To_Wav_MnItemClick(Sender: TObject);
begin
  //Si on a complété tout les paramètres alors
  If Params_Wav_Midi_Completed Then
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='Fichier Wav|*.Wav';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If (Not Execute) Then Exit;
      //On arrete la lecture de MasterStream
      Stop_MnItem.Click;
      //On créer le fichier wav
      Mix_To_WavFile(FileName);
    End;
end;

{>>Fermeture de l'application}
procedure TTracks_Form.Exit_MnItemClick(Sender: TObject);
begin
  //On appelle la procédure Close de la page principale
  Main_Form.Close;
end;

{>>Ajouter une piste}
procedure TTracks_Form.AddTrack_BtClick(Sender: TObject);
begin
  //On ajoute une piste dans TracksGrid
  TracksGrid.TrackCnt.Add;
  //On ajoute une piste dans BrowserTracks
  BrowserTracks.BrTracksCnt.Add;
  //On ajoute une piste dans TracksMix
  Mix_Form.TracksMix.TrackMixCnt.Add;
end;

{>>Suppression d'une piste}
procedure TTracks_Form.DelTrack_BtClick(Sender: TObject);
begin
  With TracksGrid.TrackCnt Do
    Begin
      //Si un Track est sélectionné alors
      If (ItemIndex>-1) Then
        Begin
          //On supprime le Track du mix
          Del_Track_In_Mix(Items[ItemIndex]);
          //Si on a plus de 5 pistes alors
          If Count>5 Then
            Begin
              //On la supprime dans TracksGrid
              Delete(ItemIndex);
              //On la supprime dans BrowserTracks
              BrowserTracks.BrTracksCnt.Delete(ItemIndex);
              //On la supprime dans TracksMix
              Mix_Form.TracksMix.TrackMixCnt.Delete(ItemIndex);
              //On rafraichit TracksGrid
              Refresh;
              //On rafraichit BrowserTracks
              BrowserTracks.Refresh;
              //On rafraichit TracksMix
              Mix_Form.TracksMix.Refresh;
            End;
        End;  
    End;
End;

{>>Renommer ou non un Track}
procedure TTracks_Form.Name_Modif_MnItemClick(Sender: TObject);
Var
  ReadOnly:Boolean;
begin
  //Si le Sender est Name_Modif_MnItem alors ReadOnly est vrai
  If Sender=Name_Modif_MnItem Then ReadOnly:=False
  //Sinon il est faux
  Else ReadOnly:=True;
  //Avec BrowserTracks.BrTracksCnt faire
  With BrowserTracks.BrTracksCnt Do
    Begin
      //Si un track est sélectionné
      If ItemIndex>-1 Then
      //On attribue à la propriété ReadOnly de l'Edit la valeur de ReadOnly
      Items[ItemIndex].BrPanelTrack.Edit.ReadOnly:=ReadOnly;
      //Si on valide alors
      If ReadOnly Then
      //Avec le Track correspondant dans TracksMix faire
      With Mix_Form.TracksMix.TrackMixCnt.Items[ItemIndex].TrackMixPn Do
      //On définit le caption comme le nom du track
      Caption:=Items[ItemIndex].BrPanelTrack.Edit.Text;
    End;
end;

{>>Procédure pour voir ou non les curseurs}
procedure TTracks_Form.Pos_Show_MnItemClick(Sender: TObject);
begin
  //Avec le Sender considéré comme un TMenuItem faire
  With (Sender As TMenuItem) Do
    Begin
      //On change la propriété Checked
      Checked:=Not Checked;
      //Si le sender est alors on modifie la propriété Pos_Show de TrackTime
      If Sender=Pos_Show_MnItem Then TrackTime.Pos_Show:=Checked
      //Sinon la propriété Delims_Show de TrackTime
      Else TrackTime.Delims_Show:=Checked;
    End;
  //On rafraichit TracksGrid
  TracksGrid.Refresh;
end;

{>>Procédure pour déplacer ou non les curseurs}
procedure TTracks_Form.Nili_Move_MnItemClick(Sender: TObject);
Var
  IndexMenu:Integer;
begin
  //Avec Pos_Delims_Move_MnItem faire
  With Pos_Delims_Move_MnItem Do
  //Pour tout ses enfants faire
  For IndexMenu:=0 To (Count-1) Do
    Begin
      //Si l'enfant IndexMenu n'est pas le sender alors cet enfant n'est pas coché
      If Items[IndexMenu]<> Sender Then Items[IndexMenu].Checked:=False
      //Sinon
      Else
        Begin
          //Cet enfant est coché
          Items[IndexMenu].Checked:=True;
          //On définit le type de CursorMode de TrackTime
          TrackTime.CursorMode:=TCursorMode(IndexMenu);
        End;  
    End;
end;    

{>>Rafraichissement de TracksGrid}
procedure TTracks_Form.TrackTimeMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TracksGrid.Refresh;
end;

{>>Procédure pour zoomer/dézoomer}
procedure TTracks_Form.Zoom_BtMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //Avec sender comme un TSpeedButton faire
  With (Sender As TSpeedButton) Do
    Begin
      //Si on click à gauche alors on décremente le zoom
      If X<Width Div 3 Then TrackTime.Zoom:=TrackTime.Zoom-1;
      //Si on click à droite on incrémente le zoom
      If X>2*Width Div 3 Then TrackTime.Zoom:=TrackTime.Zoom+1;
      //La taille de tracksGrid est celle de TimeLine
      TracksGrid.Width:=TrackTime.Width;
      //On rafraichit TracksGrid
      TracksGrid.refresh;
    End;  
end;

{>>Sélection du mode pour TracksGrid}
procedure TTracks_Form.NilMode_MnItemClick(Sender: TObject);
Var
  IndexSender,IndexTrack,IndexPart:Cardinal;
begin
  //On récupère dans IndexSender l'index du Sender
  IndexSender:=Edition_MnItem.IndexOf(Sender As TMenuItem);
  //Avec TracksGrid faire
  With TracksGrid Do
  //Suivant la nature du sender faire
  Case IndexSender Of
    0,1,2: Mode:=TMode(IndexSender); //On modifie le mode de TracksGrid
    3    : Begin
             If TrackCnt.Count>0 Then //Si on a des tracks alors
             For IndexTrack:=0 To (TrackCnt.Count-1) Do //Pour toutes les trakcs
             With TrackCnt.Items[IndexTrack] Do //Avec le track d'index IndexTrack
               Begin
                 If PartCnt.Count>0 Then //S'il a des parts alors
                 For IndexPart:=0 To (PartCnt.Count-1) Do //Pour tout les parts
                 PartCnt.Items[IndexPart].Selected:=True;//On les sélectionne
               End;
           End;    
    4    : CopyParts; //On copie la sélection
    5    : PastParts; //On colle la sélection
    6    : CutParts; //On coupe la sélection
    7    : MergeParts ; //On fusionne les parts           
    8    : DelParts; //On supprime la sélection
  End;
  //On rafraichit le TracksGrid
  TracksGrid.Refresh;
end;

{>>Procédure appelée lors de la suppression d'une partie}
procedure TTracks_Form.TracksGridDeletePart(Sender: TObject;
  CrTrack: TTrack; CrPart: TPart);
begin
  //On supprime CrPart de son mix
  Del_Part_In_Track(CrPart);
end;

{>>Procédure appelée lors du collé d'une partie}
procedure TTracks_Form.TracksGridPastPart(Sender: TObject; CrTrack: TTrack;
  CrPart: TPart);
Const
  Extensions:Array[0..3] Of String=('.Wav','.Mp3','.Midi','.Mid');
begin
  //Avec CrTrack.PartCnt faire
  With CrTrack.PartCnt Do
   Begin
     //Si CrTrack admet des parties et que leurs types different alors
     If (Count>0) And (Items[0].FileName<>CrPart.FileName) Then
     //On supprime CrPart
     CrTrack.PartCnt.Delete(CrPart.Index)
     //Sinon
     Else
      //Avec le Track correspondant dans BrowserTracks faire
       With BrowserTracks.BrTracksCnt.Items[CrTrack.Index].BrPanelTrack Do
       Begin
         //Si on a un fichier de type Wav ou MP3 alors
         If AnsiIndexText(ExtractFileExt(CrPart.FileName), Extensions) In [0,1] Then
         //On définit TypeTrack comme TtWav sinon comme TtMidi
         TypeTrack:=TtWav Else TypeTrack:=TtMidi;
         //On mix crPart dans le CrTrack
         Add_Part_In_Track(CrTrack,CrPart);
         //On rafraichit BrowserTracks
         BrowserTracks.Refresh;
       End;
   End;
end;

{>>Procédure appelée lors du coupé d'une partie}
procedure TTracks_Form.TracksGridCutPart(Sender: TObject; CrTrack: TTrack;
  LeftPart, RightPart, DelPart: TPart);
begin
  //On mixe LeftPart dans CrTrack
  Add_Part_In_Track(CrTrack,LeftPart);
  //On mixe RightPart dans CrTrack
  Add_Part_In_Track(CrTrack,RightPart);
  //On supprime DelPart de son mix
  Del_Part_In_Track(DelPart);
end;

{>>Sélection des Items}
procedure TTracks_Form.TracksGridClick(Sender: TObject);
begin
  //Avec les Tracks de TracksGrid faire
  With TracksGrid.TrackCnt Do
    Begin
      //On sélectionne le même Track dans TracksMix
      Mix_Form.TracksMix.TrackMixCnt.ItemIndex:=ItemIndex;
      //On sélectionne le même Track dans BrowserTracks
      BrowserTracks.BrTracksCnt.ItemIndex:=ItemIndex;
    End;
end;

{>>Lecture,Arret,Pause de MasterStream}
procedure TTracks_Form.Play_MnItemClick(Sender: TObject);
Var
  IndexSender:Cardinal;
begin
   //On récupère dans IndexSender l'index du Sender
  IndexSender:=Actions_MnItem.IndexOf(Sender As TMenuItem);
  //Suivant la nature du sender faire
  Case IndexSender Of
    //On joue MasterStream
    0 : Play_Mix;
    //On arrette MasterStream
    1 : Stop_Mix;
    //On met MasterStream en pause
    2 : BASS_ChannelPause(TracksGrid.MasterStream);
  End;
end;

{>>Affichage du panel de Mixage}
procedure TTracks_Form.Mix_MnItemClick(Sender: TObject);
begin
  Mix_Form.Show;
end;

{>>Affichage du panel du PianoRoll}
procedure TTracks_Form.PianoRoll_MnItemClick(Sender: TObject);
begin
  Piano_Form.Show;
end;

{>>Affichage du panel du Pattern}
procedure TTracks_Form.Pattern_MnItemClick(Sender: TObject);
begin
  Pattern_Form.Show;
end;

{>>Affichage du panel de l'asio}
procedure TTracks_Form.Asio_MnItemClick(Sender: TObject);
begin
  Asio_Form.Show;
end;

{>>Affichage du panel des paramètres}
procedure TTracks_Form.Params_MnItemClick(Sender: TObject);
begin
  Params_Form.Show;
end;                        

{>>Modification de la TimeLine}
procedure TTracks_Form.UpTime_MnItemClick(Sender: TObject);
Var
  Incr:Integer;
begin
  //Initialisation de Incr
  Incr:=0;
  //Suivant le tag du bouton
  Case (Sender As TSpeedButton).Tag Of
    0 : Incr:=1 ; //S'il est de 0 alors Incr=1
    1 :  Incr:=-1; //S'il est de 1 alors Incr=-1
  End;
  //Avec TrackTime faire
  With TrackTime Do
    Begin
      //On incrémente Max de Incr
      Max:=Max+Incr;
      //On le rafraichit
      Refresh;
      //On change la taille de TracksGrid
      TracksGrid.Width:=Width;
      //On rafraichit TracksGrid
      TracksGrid.Refresh;
    End;
end;

{>>Ajout d'un morceau}
procedure TTracks_Form.BrowserTracksOpen_Event(Sender: TObject);
Var
  Extension:String;
begin
  //Avec TrackCnt faire
  With TracksGrid.TrackCnt Do
    Begin
      //Avec le Track sélectionné faire
      With Items[BrowserTracks.BrTracksCnt.ItemIndex] Do
      //S'il a déjà des parties alors
      If PartCnt.Count>0 Then
      //Extension est définit comme l'extension du nom du fichier de la premiere partie
      Extension:='*'+ExtractFileExt(PartCnt.Items[0].FileName)
      //Sinon on définit extension comme '*.Wav;*.Mp3;*.Midi;*.Mid'
      Else Extension:='*.Wav;*.Mp3;*.Midi;*.Mid';
      //Avec OpenDialog faire
      With OpenDialog Do
        Begin
          //On définit son filtre
          Filter:='Fichiers sons|'+Extension;
          //On définit l'extension par défaut comme filter
          DefaultExt:=Filter;
          //S'il n'est pas executé on sort;
          If Not Execute Then Exit;
          //On ajoute une partie dans TrackGrid
          Add_Part_To_TracksGrid(FileName,Items[BrowserTracks.BrTracksCnt.ItemIndex]);
        End;
    End;
end;

{>>Acquisition d'un enregistrement}
procedure TTracks_Form.BrowserTracksAcquisition_Event(Sender: TObject);
begin
  //Avec BrowserTracks.BrTracksCnt faire
  With BrowserTracks.BrTracksCnt Do
    Begin             
      //Avec le Track sélectionné faire
      With Items[ItemIndex].BrPanelTrack Do
        Begin
          //Si le track est de type Midi on sort
          If TypeTrack=TtMidi Then Exit;
          //Si le bouton n'est pas appuyé alors
          If AcquisitionBt.Pushed Then
            Begin
              //Avec SaveDialog faire
              With SaveDialog Do
                Begin
                  //On définit le filtre
                  Filter:='Fichiers Wav|*.Wav';
                  //L'extension par défaut
                  DefaultExt:=Filter;
                  //S'il n'est pas executé alors
                  If Execute then
                  //On lance l'acquisition
                  Start_Recording(TracksGrid.TrackCnt.Items[BrowserTracks.BrTracksCnt.ItemIndex],FileName);
                End;
            End;
        End;
    End;
End;

{>>Mêttre en sourdine un track}
procedure TTracks_Form.BrowserTracksMute_Event(Sender: TObject);
Var
  IndexTrack:Integer;
begin
  //Avec BrowserTracks faire
  With BrowserTracks Do
    Begin
      //Pour tout les Tracks
      For IndexTrack:=0 To (BrTracksCnt.Count-1) Do
      //On désactive le SoloBt
      BrTracksCnt.Items[IndexTrack].BrPanelTrack.SoloBt.Pushed:=False;
      //Avec le Track sélectionné
      With BrTracksCnt.Items[BrTracksCnt.ItemIndex].BrPanelTrack Do
        Begin
          //On active/désactive le Track
          Active:=Not Active;
          //Avec TracksGrid faire
          With TracksGrid Do
            Begin
              //On active/désactive le Track au niveau de TracksGrid
              TrackCnt.Items[BrTracksCnt.ItemIndex].Mute:=Not Active;
              //On switch le Track
              Switch_Track_In_Mix(TrackCnt.Items[BrTracksCnt.ItemIndex],Active);
            End;
        End;
    End;
end;

{>>Mettre en solo un track}
procedure TTracks_Form.BrowserTracksSolo_Event(Sender: TObject);
Var
  IndexTrack:Integer;
begin
  //Avec BrowserTracks faire
  With BrowserTracks Do
    Begin
      //Pour tout les Tracks faire
      For IndexTrack:=0 To (BrTracksCnt.Count-1) Do
      //Avec le panel correspondant au Track dans BrowserTracks faire
      With BrowserTracks.BrTracksCnt.Items[IndexTrack].BrPanelTrack Do
        Begin
          //Si c'est celui sélectionné alors SoloBt est enfoncé
          If IndexTrack<>BrTracksCnt.ItemIndex Then SoloBt.Pushed:=False;
          //On active/désactive le Track
          Active:=SoloBt.Pushed;
          //On enfonce/désenfonce MuteBt.Pushed
          MuteBt.Pushed:=Not SoloBt.Pushed;
          //Avec TracksGrid faire
          With TracksGrid Do
            Begin
              //On active/désactive le Track au niveau de TracksGrid
              TrackCnt.Items[BrTracksCnt.ItemIndex].Mute:=Not Active;
              //On switch le Track
              Switch_Track_In_Mix(TrackCnt.Items[IndexTrack],Active);
            End;
        End;
    End;
end;

{>>Procédure pour modifier un effet}
procedure TTracks_Form.BrowserTracksWrite_Event(Sender: TObject);
Begin
  //Avec les Tracks de TracksGrid faire
  With TracksGrid.TrackCnt Do
    Begin
      //Avec le track sélectionné faire
      With Items[ItemIndex] Do
        Begin
          //Avec le Track correspondant qui se trouve dans TracksMix faire
          With  Mix_Form.TracksMix.TrackMixCnt.Items[ItemIndex].TrackMixPn Do
          //Si un effet est sélectionné alors
          If EffectCnt.ItemIndex>=0 Then
            Begin
              //Avec ce dernier faire
              With EffectCnt.Items[EffectCnt.ItemIndex].EffectTab Do
                Begin
                  //Avec ce type d'effet faire
                  With (ItemsEffect[Ord(Effect)]) Do
                    Begin
                      //Si les délimitateurs sont visibles alors
                      If TrackTime.Delims_Show Then
                      //Avec cet effet dans TracksGrid faire
                      With (Items[EffectIndex] As TCustomCollectionItem) Do
                        Begin
                          //On définit le début de l'effet
                          BeginTime:=TrackTime.LeftDelim;
                          //On définit la fin de l'effet
                          EndTime:=TrackTime.RightDelim;
                        End;
                      //Suivant la nature de l'effet
                      Case Effect Of
                        //Si c'est un VSTI, on sauve ses paramètres
                        TMxVSTI : Save_VST(VSTICnt.Items[EffectIndex]);
                        //Si c'est un VSTE, on sauve ses paramètres
                        TMxVSTE : Save_VST(VSTECnt.Items[EffectIndex]);
                        //Si c'est un DSP, on sauve ses paramètres
                        TMxDSP : Save_DSP(DSPCnt.Items[EffectIndex]);
                        //Si c'est un egalizer, on sauve ses paramètres
                        TMxEQUALIZER  : Save_Egalizer(EgalizerCnt.Items[EffectIndex]);
                      End;
                    End;
                End;
            End;
        End;    
    End;
end;

{>>Procédure pour activer/désactiver tout les effets}
procedure TTracks_Form.BrowserTracksRead_Event(Sender: TObject);
Var
  CrTypeEffect:TMxTypeEffect;
  IndexEffect:Integer;  
Begin
  //Avec TracksGrid faire
  With TracksGrid Do
    Begin
      //Avec le Track sélectionné faire
      With TrackCnt.Items[TrackCnt.ItemIndex] Do
        Begin
          //Pour tout les types d'effet faire
          For CrTypeEffect:=TMxVSTI To TMxEqualizer Do
          //Avec ce type effet faire
          With ItemsEffect[Ord(CrTypeEffect)] Do
            Begin
              //S'il y en a alors
              If Count>0 Then
              //Pour tout les effets de ce type faire
              For IndexEffect:=0 To (Count-1) Do
              //Avec l'effet IndexEffect faire
              With (Items[IndexEffect] As TCustomCollectionItem) Do
              //On active/désactive le Mute de l'effet
              Mute:=(Sender As TBrCstButton).Pushed;
              //On change les effets
              Change_Effects;
            End;
        End;
    End;
end;

{>>Sélection des Items}
procedure TTracks_Form.BrowserTracksClick(Sender: TObject);
begin
  //Avec les Tracks de BrowserTracks faire
  With BrowserTracks.BrTracksCnt Do
    Begin
      //On sélectionne le même Track dans TracksMix
      Mix_Form.TracksMix.TrackMixCnt.ItemIndex:=ItemIndex;
      //On sélectionne le même Track dans TracksGrid
      TracksGrid.TrackCnt.ItemIndex:=ItemIndex;
    End;
end;

{>>Affichage de l'aide}
procedure TTracks_Form.Help_MnItemClick(Sender: TObject);
begin
  HtmlHelp(0, PChar(mHelpFile), HH_DISPLAY_TOC,0);
end;

procedure TTracks_Form.Export_To_Mp3_MnItemClick(Sender: TObject);
Const
  MpegQuality: Array [0..3] Of MPEG_QUALITY=(NORMAL_QUALITY, LOW_QUALITY, HIGH_QUALITY, VOICE_QUALITY);
  MpegMode: Array [0..3] Of TMP3CoderMode=(STEREO, JSTEREO, DUALCHANNEL, MONO);
Var
  MP3Coder:TMP3Coder;
  TempFileWav:String;
begin
  //Si on a complété tout les paramètres Wav et MP3 alors
  If (Params_Wav_Midi_Completed) And (Params_Mp3_Completed) Then
  //Avec SaveDialog faire
  With SaveDialog Do
    Begin
      //On définit le filtre
      Filter:='Fichier Mp3|*.Mp3';
      //Ainsi que l'extension par défaut
      DefaultExt:=Filter;
      //S'il n'est pas executé on sort
      If (Not Execute) Then Exit;
      //On arrete la lecture de MasterStream
      Stop_MnItem.Click;
      //On définit TempFileWav
      TempFileWav:=ChangeFileExt(ExtractFilePath(ParamStr(0))+'Temps\'+ExtractFileName(FileName),'.Wav');
      //On créer le fichier wav temporaire
      Mix_To_WavFile(TempFileWav);
      //On crée MP3Coder
      MP3Coder:=TMP3Coder.Create(Self);
      //Avec MP3Coder faire
      With Mp3Coder Do
        Begin
          //On définit les fichiers à coder
          InputFiles.Add(TempFileWav);
          //Avec Params_Form faire
          With Params_Form Do
            Begin
              //On définit SampleRate
              SampleRate:=StrToInt(MP3_Freq_LsBx.Items[MP3_Freq_LsBx.ItemIndex]);
              //On définit Bitrate
              Bitrate:=StrToInt(BitRate_LsBx.Items[BitRate_LsBx.ItemIndex]);
              //On définit MaxBitrate
              MaxBitrate:=StrToInt(MaxBitRate_LsBx.Items[MaxBitRate_LsBx.ItemIndex]);
              //On définit WriteVBRHeader
              WriteVBRHeader:=Header_VBR_CkBx.Checked;
              //On définit EnableVBR
              EnableVBR:=VBR_CkBx.Checked;
              //On définit VBRQuality
              VBRQuality:=VBT_TkBr.Position;
              //On définit Quality
              Quality:=MpegQuality[Quality_LsBx.ItemIndex];
              //On définit le Mode
              Mode:=MpegMode[Mode_LsBx.ItemIndex];
              //On définit le nom du fichier Mp3
              OutputFiles.Add(FileName);
              //On lance le codage
              ProcessFiles;
            End;
        End;
    End;
end;

end.
