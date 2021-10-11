{>>Dans cette unit�, on va traiter tout ce qui concerne le son en g�n�ral}

unit UGnSound;

interface

Uses  Forms, Windows, SysUtils, Classes, Math, StdCtrls,Bass,BassAsio, Bass_VST,BassMidi,Dialogs,BrowserTracks, TracksMix, TracksGrid, Bassmix, Bass_FX,Graphics,DSPEffect, UParams;

Function LastPart_InMix:TPart;
Function Params_Wav_Midi_Completed:Boolean;
Function Params_Mp3_Completed:Boolean;
Procedure Start_Metronome(RythmFile:String);
Procedure Stop_Metronome;
Procedure Change_Tempo(AStream:HStream;Tempo:Integer);
Procedure Scan_Part(Part:TPart);
Procedure Add_Part_To_TracksGrid(SoundFileName:String;Track:TTrack);
Procedure Start_Recording(Track:TTrack;DestFile:String);
Procedure Close_AllEffectPanels;
Procedure Show_DspPanel(DSP:TDSP);
Procedure Show_EgalizerPanel(Egalizer:TEgalizer);
Procedure Show_VSTPanel(VST:TVST);
Procedure Add_Egalizer_Bands(Egalizer:TEgalizer);
Procedure Add_VST_Params(VST:TVST);
Procedure Create_MixSound(Flag:DWord);
Procedure Change_Effects;
Procedure Play_Mix;
Procedure Stop_Mix;

Var
  MetronomeStream:HStream;
  MetronomeSndFont:BASS_MIDI_FONT;
  
implementation

Uses UTracks, UMidiSound, UGnBass, UDSP, UMix, UEqualizer;

{>>Fonction pour savoir la dur�e de MasterStream}
Function LastPart_InMix:TPart;
Var
  IndexTrack,IndexPart:Cardinal;
  LastEndTime:Integer;
Begin
  //On d�finit le r�sultat par d�faut
  Result:=Nil;
  //LastEndTime par d�faut
  LastEndTime:=0;
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //Si on a des Tracks
      If TrackCnt.Count>0 Then
      //Pour tout les Tracks faire
      For IndexTrack:=0 To (TrackCnt.Count-1) Do
      //Avec le Track IndexTrack faire
      With TrackCnt.Items[IndexTrack] Do
        Begin
          //S'il y a des parties alors
          If PartCnt.Count>0 Then
          //Pour toutes les parties faire
          For IndexPart:=0 To (PartCnt.Count-1) Do
          //Avec la partie IndexPart
          With PartCnt.Items[IndexPart] Do
          //Si EndTime est plus grand que TempResult alors
          If EndTime>LastEndTime Then
            Begin
              //LastEndTime est EndTime
              LastEndTime:=EndTime;
              //On retourne le Part correspondant
              Result:=PartCnt.Items[IndexPart];
            End;
        End;
    End;
End;

{>>Fonction pour savoir si les parametres Wav sont complets}
Function Params_Wav_Midi_Completed:Boolean;
Var
 IndexCmp:Cardinal;
 Cmp:TComponent;
Begin
  //R�sultat par d�faut
  Result:=False;
  //Avec Params_Form faire
  With Params_Form Do
    Begin
      //Pour tout les composants faire
      For IndexCmp:=0 To (ComponentCount-1) Do
        Begin
          //On d�finit Cmp comme le composant index IndexParam
          Cmp:=Components[IndexCmp];
          //If le tag du composant n'est pas compris entre 33 et 42 on continue
          If Not (Cmp.Tag In [33..42]) Then Continue;
          //Si Cmp est une TListBox et que rien n'es s�lectionn� on sort
          If (Cmp Is TListBox) And ((Cmp As TListBox).ItemIndex=-1) Then Exit;
          //Si Cmp est un TM�mo et qu'il est vide on sort
          If (Cmp Is TMemo) And ((Cmp As TMemo).Text='') Then Exit;
        End;
      //Le r�sultat est vrai
      Result:=True;  
    End;
End;

{>>Fonction pour savoir si les parametres Mp3 sont complets}
Function Params_Mp3_Completed:Boolean;
Var
 IndexCmp:Integer;
 Cmp:TComponent;
Begin
  //R�sultat par d�faut
  Result:=False;
  //Avec Params_Form faire
  With Params_Form Do
  //Pour tout les composants faire
  For IndexCmp:=0 To (ComponentCount-1) Do
    Begin
      //On d�finit Cmp comme le composant index IndexParam
      Cmp:=Components[IndexCmp];
      //If le tag du composant n'est pas compris entre 33 et 42 on continue
      If Not (Cmp.Tag In [44..58]) Then Continue;
      //Si Cmp est une TListBox et que rien n'es s�lectionn� on sort
      If (Cmp Is TListBox) And ((Cmp As TListBox).ItemIndex=-1) Then Exit;
      //Le r�sultat est vrai
      Result:=True;
    End;
End;

{>>Proc�dure pour lancer le m�tronome}
Procedure Start_Metronome(RythmFile:String);
Var
  MetronomeSndFontFile:String;
Begin
  //On d�finit le nom du fichier de la SoundFont
  MetronomeSndFontFile:=ExtractFileDir(ParamStr(0))+'\Plugins\SoundFont\2MBGMGS.SF2';
  //Si le fichier MetronomeSndFontFile n'existe pas on sort
  If Not FileExists(MetronomeSndFontFile) Then Exit;
  //On arrete le m�tronome
  Stop_Metronome;
  //On cr�e MetronomeStream en utilisant le fichier RyhmFile
  MetronomeStream:=BASS_MIDI_StreamCreateFile(FALSE,PChar(RythmFile),0,0,BASS_STREAM_DECODE,44100);
  //S'il n'y a pas d'erreur
  If BASS_ErrorGetCode=0 Then
    Begin
      //On charge la SoundFont MetronomeSndFont
      Load_SoundFont(MetronomeStream,MetronomeSndFont,MetronomeSndFontFile);
      //S'il n'y a pas d'erreur
      If BASS_ErrorGetCode=0 Then
        Begin
          //On cr�e MetronomeStream comme un Tempo Stream
          MetronomeStream:=BASS_FX_TempoCreate(MetronomeStream,BASS_SAMPLE_LOOP or BASS_FX_FREESOURCE);
          //S'il n'y a pas d'erreur
          If BASS_ErrorGetCode=0 Then
          //On joue MetronomeStream
          BASS_ChannelPlay(MetronomeStream,True);
        End;  
    End;
End;

{>>Proc�dure pour arreter le m�tronome}
Procedure Stop_Metronome;
Begin
  //Si MetronomeStream existe alors
  If (MetronomeStream<>0) Then
    Begin
      //On lib�re la SoundFont MetronomeSndFont
      Free_SoundFont(MetronomeStream,MetronomeSndFont);
      //On libere MetronomeStream
      Finalize_MidiStream(MetronomeStream);
    End;
End;

{>>Proc�dure pour changer le Tempo d'un stream}
Procedure Change_Tempo(AStream:HStream;Tempo:Integer);
Var
  PercentTempo:Float;
Begin
  //On d�finit le tempo en pourcentage
  PercentTempo:=(Tempo/133 -1)*100;
  //On change le Tempo
  BASS_ChannelSetAttribute(AStream,BASS_ATTRIB_TEMPO,PercentTempo);
End;

{>>Procedure pour scanner une partie}
Procedure Scan_Part(Part:TPart);
Var
  LengthInBytes,LengthInSec,PosInPx,PosInBytes,Pic,LeftPic,RightPic:Integer;
Const
  BPB: DWord=BASS_POS_BYTE;
Begin
  //Avec Part faire
  With Part Do
    Begin
      //On d�finit la longueur de Streamen bytes
      LengthInBytes:=BASS_ChannelGetLength(Stream,BPB);
      //On d�finit la longueur de Stream en millisecondes
      LengthInSec:=Round(BASS_ChannelBytes2Seconds(Stream,LengthInBytes)*1000);
      //Avec le BitMap de Picture faire
      With Picture.Bitmap Do
        Begin
          //On d�finit sa largueur
          Width:=Tracks_Form.TracksGrid.MsToPixel(LengthInSec);
          //On d�finit sa hauteur
          Height:=Tracks_Form.TracksGrid.HeightTrack;
          //Avec le Canvas faire
          With Canvas Do
            Begin
              //On d�finit la couleur
              Pen.Color:=ClBlack;
              //On r�p�te
              Repeat
                //On d�finit la possition en bytes
                PosInBytes:=BASS_ChannelGetPosition(Stream,BPB);
                //On d�finit la position en pixel
                PosInPx:=Tracks_Form.TracksGrid.MsToPixel(Round(BASS_ChannelBytes2Seconds(Stream,PosInBytes)*1000));
                //On r�cup�re l'intensit� de Stream
                Pic:=BASS_ChannelGetLevel(Stream);
                //On en d�duit l'intensit� du canal de gauche
                LeftPic:=LOWORD(Pic);
                //On en d�duit l'intensit� du canal de droite
                RightPic:=HIWORD(Pic);
                //On se place � mi-hauteur du canvas
                MoveTo(PosInPx,Height Div 2);
                //On trace une droite verticale pour indiquer la valeur de LeftPic
                LineTo(PosInPx,Height Div 2 - Round(LeftPic*Height / (2*32768)));
                //On se place � mi-hauteur du canvas
                MoveTo(PosInPx,Height Div 2);
                //On trace une droite verticale pour indiquer la valeur de RightPic
                LineTo(PosInPx,Height Div 2 +Round(RightPic*Height / (2*32768)));
                //On d�freeze le syst�me
                Application.ProcessMessages;
              //Jusqu'� la fin de Stream
              Until PosInBytes>=BASS_ChannelGetLength(Stream,BPB);
              //On rafraichit TracksGrid
              Tracks_Form.TracksGrid.Refresh;
            End;
        End;
    End;
End;

{>>Procedure pour ajouter une partie dans le TracksGrid}
Procedure Add_Part_To_TracksGrid(SoundFileName:String;Track:TTrack);
Var
  NewPart:TPart;
  AFreq,AChan,LengthPart:Integer;
  DefaultSndFontName:String;
  ScanMidiFont:BASS_MIDI_FONT;
Const
  BPB: DWord=BASS_POS_BYTE;  
Begin
  //On d�finit le nom de la SoundFont par d�faut
  DefaultSndFontName:=ExtractFileDir(ParamStr(0))+'\Plugins\SoundFont\2MBGMGS.SF2';
  //Si la SoundFont existe et  les param�tres Wav/Midi sont complets alors
  If (FileExists(DefaultSndFontName)) And (Params_Wav_Midi_Completed) Then
    Begin
      //Avec Params_Form faire
      With Params_Form Do
        Begin
          //On d�finit la fr�quence
          AFreq:=StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]);
          //On d�finit le nombre de canaux
          AChan:=Round(NbChannel_LsBx.ItemIndex+1);
        End;
      //On cr�e le stream du Track
      Create_TrackStream(Track,AFreq,AChan);
      //On cr�er une nouvelle partie dans Track
      NewPart:=Track.PartCnt.Add;
      //Avec cette nouvelle partie faire
      With NewPart Do
        Begin
          //On d�finit FileName comme SoundFileName
          FileName:=SoundFileName;
          //On d�finit Name
          Name:=ExtractFileName(FileName);
          //Si peut cr�er NewStream alors
          If Create_PartStream(NewPart,AFreq) Then
            Begin
              //On charge la soundfont par d�faut dans PartTempMidiFont
              Load_SoundFont(Stream,ScanMidiFont,DefaultSndFontName);
              //On d�finit BeginTime
              BeginTime:=0;
              //On d�finit LengthPart comme la longueur en bytes de Stream
              LengthPart:=BASS_ChannelGetLength(Stream,BPB);
              //On d�finit EndTime comme LengthPart en secondes
              EndTime:=Round(BASS_ChannelBytes2Seconds(Stream,LengthPart)*1000);
              //On d�finit OffSetTime
              OffSetTime:=0;
              //On scan NewStream
              Scan_Part(NewPart);
              //On lib�re ScanMidiFont
              Free_SoundFont(Stream,ScanMidiFont);
            End
          //Sinon on supprime NewPart
          Else Track.PartCnt.Delete(Track.PartCnt.Count-1);
        End;
    End;
End;

{>>Procedure pour lancer une acquisition}
Procedure Start_Recording(Track:TTrack;DestFile:String);
Var
  RecordPart:TPart;
  RecFreq,RecChannels:Integer;
Begin
  //Avec Tracks_Form.SaveDialog faire
  With Tracks_Form.SaveDialog Do
    Begin
      RecordPart:=Track.PartCnt.Add;
      //Avec RecordPart faire
      With RecordPart Do
        Begin
          //On d�finit le d�but de RecordPart
          BeginTime:=0;
          //La fin de RecordPart
          EndTime:=0;
          //On d�finit l'OffSet de RecordPart
          OffSetTime:=0;
          //Le nom du fichier rattach�
          FileName:=DestFile;
          //Son nom
          Name:=ExtractFileName(FileName);
        End;
      //Avec Params_Form
      With Params_Form Do
        Begin
          //On d�finit la fr�quence d'enregistrement
          RecFreq:=Round(StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]));
          //On d�finit le nombre de canaux pour l'enregistrement
          RecChannels:=Round(NbChannel_LsBx.ItemIndex+1);
          //On lance l'enregistrement
          Create_RecordStream(RecordPart,RecFreq,RecChannels);
        End;
    End;  
End;    

{>>Proc�dure pour fermer tout les panels d'effets}
Procedure Close_AllEffectPanels;
Var
  IndexTrack,IndexEffect:Integer;
  CrTypeEffect:TMxTypeEffect;
Begin
  //On ferme Equalizer_Form
  Equalizer_Form.Hide;
  //On ferme DSP_Form
  DSP_Form.Hide;
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //S'il y a des Tracks alors
      If TrackCnt.Count>0 Then
      //Pour tout les Tracks faire 
      For IndexTrack:=0 To (TrackCnt.Count-1) Do
        Begin
          //Pour les VSTI et VSTE faire
          For CrTypeEffect:=TMxVSTI To TMxVSTE Do
          //Avec ce type d'effet faire
          With TrackCnt.Items[IndexTrack].ItemsEffect[Ord(CrTypeEffect)] Do
            Begin
              //S'il y en a alors
              If Count>0 Then
              //Pour tout les VST de ce type faire
              For IndexEffect:=0 To (Count-1) Do
              //Avec le VST IndexEffect faire
              With (Items[IndexEffect] As TVST) Do
              //Si VSTForm est assign� on ferme cette fiche
              if Assigned(VSTForm) Then VSTForm.Hide;
            End;
        End;
    End;
End;

{>>Proc�dure pour afficher le panel d'un DSP}
Procedure Show_DspPanel(DSP:TDSP);
Const
  CoeffBt:Array[0..21] Of Float=(1,0.1,1,10,10,10,1,0.01,0.01,100,0.1,0.1,100,10,1,100,100,100,10,0.1,10,10);
Var
 ParamIndex:Integer;
Begin
  //On ferme tout les panels;
  Close_AllEffectPanels;
  //Avec DSP_Form faire
  With DSP_Form Do
   Begin
     //On d�finit le type de DSP
     DSPEffect.TypeDSP:=TTypeDSP(DSP.TypeDSP);   
     //On affiche DSP_Form
     Show;
     //Pour tout les param�tres faire
     For ParamIndex:=0 To 21 Do
     //La position du bouton ParamIndex est la valeur du param�tre
     DSPEffect.GetButton(ParamIndex).Pos:=Round(DSP.GetReal(ParamIndex)*CoeffBt[ParamIndex]);
     //On r�cup�re le lDelay dans le bouton ALDelay
     DSPEffect.ALDelay.Pos:=Round(DSP.lDelay*0.01);
   End;  
End;      

{>>Proc�dure pour afficher le panel d'un �qalizer}
Procedure Show_EgalizerPanel(Egalizer:TEgalizer);
Var
 BandIndex,ParamIndex:Integer;
Begin
  //On ferme tout les panels;
  Close_AllEffectPanels;
  //Avec DSP_Form faire
  With Equalizer_Form Do
   Begin
     //Pour tout les bandes faire
     For BandIndex:=0 To 9 Do
     //Avec la bande BandIndex faire
     With Equalizer.GetGauges(BandIndex) Do
       Begin
         //Pour tout les param�tres faire
         For ParamIndex:=0 To 3 Do
         //On attribue la valeur au param�tre ParamIndex
         SetParam(ParamIndex,Round(Egalizer.BandCnt.Items[BandIndex].GetSingle(ParamIndex)));
       End;
     //On affiche Equalizer_Form
     Show;
   End;
End;

{>>Proc�dure pour afficher le panel d'un VST}
Procedure Show_VSTPanel(VST:TVST);
var
  VST_Info: BASS_VST_INFO;
  IndexParam:Cardinal;  
Begin
  //On ferme tout les panels;
  Close_AllEffectPanels;
  //Avec VST Faire
  With VST Do
    Begin
      //Si VSTForm n'existe pas alors
      If not Assigned(VSTForm) then
        Begin
           VSTForm:= TForm.Create(Nil);
          //Si on peut r�cup�rer les infos du VST dans VST_Info
          If BASS_VST_GetInfo(Stream,@VST_Info) then
            Begin;
              //Si on peut �diter le VST alors
              If VST_Info.hasEditor<>0 then
              //Avec VSTForm faire
              With VSTForm Do
                Begin
                  //On d�finit sa largeur par d�faut
                  ClientHeight := 150;
                  //On d�finit sa longueur par d�faut
                  ClientWidth  := 300;
                  //On d�finit son titre
                  Caption := 'MUSIC PRO - '+string(VST_Info.EffectName);
                  //Avec VST_Info faire
                  With VST_Info Do
                    Begin
                      //Si la largeur du VST est non nul, on l'assigne � celle de la fiche
                      If EditorHeight<>0 Then ClientHeight:=EditorHeight;
                      //Si la longueur du VST est non nul, on l'assigne � celle de la fiche
                      If EditorWidth<>0 Then ClientWidth  := EditorWidth;
                      //Si on a pu int�grer le panel d'�dition du VST � VSTForm alors
                      If BASS_VST_EmbedEditor(Stream,Handle) then
                      //On rend la fen�tre visible
                      Visible:=True;
                    End;
                End;
            End;
        End
      //Sinon on affiche VSTForm  
      Else VSTForm.Show;          
      //S'il y a des param�tres alors
      If VSTParamCnt.Count>0 Then
      //Pour tous les param�tres faire
      For IndexParam:=0 To (VST.VSTParamCnt.Count-1) Do
      //On envoit dans le Stream la valeur du param�tre IndexParam
      BASS_VST_SetParam(Stream,IndexParam,VSTParamCnt.Items[IndexParam].Value);
     End;
End;

{>>Proc�dure pour ajouter les bandes d'un egalizer}
Procedure Add_Egalizer_Bands(Egalizer:TEgalizer);
Var
  IndexBand:Cardinal;
Begin
  //Pour toutes les bandes
  For IndexBand:=0 To 9 Do
  //Avec la bande que l'on cr�e, on fait
  With Egalizer.BandCnt.Add Do 
    Begin
      BandWidth:=1;
      Q:=0;
      Gain:=0;
      Center:=Trunc(30*Power(2,IndexBand));
    End;      
End;  

{>>Proc�dure pour ajouter les param�tres d'un VST}
Procedure Add_VST_Params(VST:TVST);
Var
  IndexParam,CountParam:Cardinal;
Begin
  //Si le Stream de VST existe
  If VST.Stream<>0 Then
    Begin
      //On r�cup�re le nombre de param�tres du VST
      CountParam:=BASS_VST_GetParamCount(VST.Stream);
      //Si ce nombre est sup�rieur � z�ro
      If CountParam>0 Then
      //Pour tout les param�tres
      For IndexParam:=0 To (CountParam-1) Do
      //On cr�e le param�tre correspondant
      VST.VSTParamCnt.Add;
    End;  
End;

{>>Proc�dure pour jouer le son}
Procedure Create_MixSound(Flag:DWord);
Var
  AFreq,AChan,IndexTrack:Integer;
Begin
  //Si les param�tres Wav/Midi sont complets alors
  If (Params_Wav_Midi_Completed) Then
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //Avec Params_Form faire
      With Params_Form Do
        Begin
          //On d�finit la fr�quence
          AFreq:=StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]);
          //On d�finit le nombre de canaux
          AChan:=Round(NbChannel_LsBx.ItemIndex+1);
        End;
      //Si MasterStream n'est pas en pause alors
      If BASS_ChannelIsActive(MasterStream)<>BASS_ACTIVE_PAUSED Then
        Begin
          //On cr�e MasterStream  comme un mix
          MasterStream:=BASS_Mixer_StreamCreate(AFreq,AChan,Flag);
          //Pour tout les Tracks faire
          For IndexTrack:=0 To (TrackCnt.Count-1) Do
          //Avec le track IndexTrack faire
          With TrackCnt.Items[IndexTrack] Do
            Begin
              //On ajoute le Track IndexTrack
              Add_Track_In_Mix(TrackCnt.Items[IndexTrack]);
              //On switch le Track
              Switch_Track_In_Mix(TrackCnt.Items[IndexTrack],Not Mute);
              //On change le panoramic
              Change_Pan_Stream(Stream,(RightCanal-50)*2);
              //On change le volume
              Change_Volume_Stream(Stream,Volume);
            End;
        End;
    End;
End;

{>>Proc�dure pour jouer les effets}
Procedure Change_Effects;
Const
  BPB: DWord=BASS_POS_BYTE;
Var
  IndexTrack,IndexPart,MdEtIndex,IndexEffect:Integer;
  PosInBytes:QWORD;
  PosInMSec:Integer;
  CrTypeEffect:TMxTypeEffect;
  Active_To_Effect:Boolean;
Begin
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //Pour tout les Tracks faire
      For IndexTrack:=0 To (TrackCnt.Count-1) Do
        Begin
          //Avec le Track s�lectionn� faire
          With TrackCnt.Items[IndexTrack] Do
            Begin
              //Si le track IndexTrack n'est pas mut� alors
              If Not Mute Then
              //Pour tout les types d'effet faire
              For CrTypeEffect:=TMxSoundFont To TMxEqualizer Do
                Begin
                  //On defreeze l'application
                  Application.ProcessMessages;
                  //Avec ce type effet faire
                  With ItemsEffect[Ord(CrTypeEffect)] Do
                    Begin
                      //S'il y a des effets de ce type
                      If Count>0 Then
                      //Pour tout les effets de ce type
                      For IndexEffect:=0 To (Count-1) Do
                      //Avec l'effet IndexEffect faire
                      With (Items[IndexEffect] As TCustomCollectionItem) Do
                        Begin
                          //On defreeze l'application
                          Application.ProcessMessages;
                          //On r�cup�re la position en Bytes
                          PosInBytes:=BASS_ChannelGetPosition(MasterStream,BPB);
                          //On transpose la position en millisecondes
                          PosInMSec:=Round(BASS_ChannelBytes2Seconds(MasterStream,PosInBytes)*1000);
                          //On d�finit la valeur par d�faut de Active_To_Effect
                          Active_To_Effect:=False;
                          //Si PosInMSec est compris entre B�ginTime et EndTime et que l'effet n'est pas mut� alors Active_To_Effect est mis � True
                          If (PosInMSec>=BeginTime) And (PosInMSec<=EndTime) And (Mute=False) Then Active_To_Effect:=True;
                          //Si on est au d�but ou Active_To_Effect est diff�rent d'Actif Alors
                          If (PosInMSec<5) Or (Active_To_Effect<>Actif) Then
                            Begin
                              //On change le caract�re de Actif_To_Effect
                              Actif:=Active_To_Effect;
                              //Suivant le type d'effet faire
                              Case CrTypeEffect Of
                                //Si c'est une SoundFont, on la switch
                                TMxSOUNDFONT : Switch_SndFont(TrackCnt.Items[IndexTrack],SoundFontCnt.Items[IndexEffect],Active_To_Effect);
                                //Si c'est un VSTI, on le switch
                                TMxVSTI : Switch_VST(TrackCnt.Items[IndexTrack],VSTICnt.Items[IndexEffect],Active_To_Effect);
                                //Si c'est un VSTE, on le switch
                                TMxVSTE : Switch_VST(TrackCnt.Items[IndexTrack],VSTECnt.Items[IndexEffect],Active_To_Effect);
                                //Si c'est un DSP, on le switch
                                TMxDSP : Switch_DSP(TrackCnt.Items[IndexTrack],DSPCnt.Items[IndexEffect],Active_To_Effect);
                                //Si c'est un EQUALIZER, on le switch
                                TMxEQUALIZER  : Switch_Egalizer(TrackCnt.Items[IndexTrack],EgalizerCnt.Items[IndexEffect],Active_To_Effect);
                              End;
                              //Avec le BrTrack correspondant au Track IndexTrack faire
                              With Tracks_Form.BrowserTracks.BrTracksCnt.Items[IndexTrack] Do
                              //Si le Track est de type Midi et qu'il y a des parties alors
                              If (BrPanelTrack.TypeTrack=TtMidi) And (PartCnt.Count>0) Then
                                Begin
                                  //Si on a un VSTI ou un VSTE alors
                                  If CrTypeEffect In [TMxVSTI,TMxVSTE] Then
                                  //Pour toutes les Parties faire
                                  For IndexPart:=0 To (PartCnt.Count-1) Do
                                      Begin
                                        //Pour tout les �v�nements Midi faire
                                        For MdEtIndex:=MIDI_EVENT_NOTE to MIDI_EVENT_DRUM_RESONANCE Do
                                        //On d�finit un synchronizeur
                                        BASS_ChannelSetSync((Items[IndexEffect] As TCustomCollectionItem).Stream, BASS_SYNC_MIDI_EVENT,MdEtIndex,@MidiEventToVST,Pointer(MdEtIndex));
                                      End;
                                End;
                            End;
                        End;
                    End;
                End;
            End;
        End;
    End;
End;

{>>Procedure pour jouer MasterStream}
Procedure Play_Mix;
Begin
  //On cr�e MasterStream
  Create_MixSound(BASS_SAMPLE_FLOAT);
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //On joue MasterStream
      BASS_ChannelPlay(MasterStream,False);
      //Tant que MasterStrram est jou� faire
      While BASS_ChannelIsActive(MasterStream)=BASS_ACTIVE_PLAYING Do
      //On change les effets
      Change_Effects;
    End;  
End;


{>>Procedure pour arreter MasterStream}
Procedure Stop_Mix;
Begin
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //On arrete de jouer MasterStream
      BASS_ChannelStop(MasterStream);
      //On lib�re MasterStream
      BASS_StreamFree(MasterStream);
    End;  
End;


end.
