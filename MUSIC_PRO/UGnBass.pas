{>>Dans cette unité, on va traiter toutes les procédures génériques à Bass}

unit UGnBass;

interface

Uses  Forms,SysUtils,StrUtils,Bass,BassAsio,Bass_VST,BassMidi,Bass_FX,BassMix,Classes,Dialogs,Windows,BrowserTracks,TracksMix,TracksGrid,Graphics;


Function Init_Bass : Boolean;
Function Free_Bass : Boolean;
Function Init_RecordBass : Boolean;
Function Free_RecordBass : Boolean;
Function Init_AsioBass : Boolean;
Function Free_AsioBass : Boolean;
Procedure Change_Volume_Stream(SoundStream:HStream;NewVol:DWord);
Procedure Change_Pan_Stream(SoundStream:HStream;NewPan:Integer);
Function Create_PartStream(APart:TPart;AFreq:Integer) : Boolean;
Function Create_TrackStream(ATrack:TTrack;AFreq,AChan:Integer) : Boolean;
Function Add_Part_In_Track(ATrack:TTrack;APart:TPart):Boolean;
Function Del_Part_In_Track(APart:TPart):Boolean;
Function Add_Track_In_Mix(ATrack:TTrack):Boolean;
Function Del_Track_In_Mix(ATrack:TTrack):Boolean;
Procedure Switch_Track_In_Mix(ATrack:TTrack; Actif:Boolean);
Function Active_Asio(NbChannels:Integer;Input:Boolean):Boolean;
Function Desactive_Asio(NbChannels:Integer;Input:Boolean):Boolean;
Function Set_AsioFreq(NbChannels,AsioFreq:Integer;Input:Boolean):Boolean;
Function Set_AsioVol(NbChannels,AsioVol:Integer;Input:Boolean):Boolean;
Function Set_AsioNbChannels(NbChannels,CountChannels:Integer;Input:Boolean):Boolean;
Function Create_RecordStream(Part:TPart;RecFreq,RecChannels:Integer) : Boolean;
function RecordingCallback(Handle: HRECORD; buffer: Pointer; length: DWORD; user: Pointer): boolean; stdcall;
Procedure Scan_Record(Part:TPart;Length:Integer);
Procedure Create_DSP(Track:TTrack;DSP:TDSP);
Procedure Free_DSP(Track:TTrack;DSP:TDSP);
Procedure Switch_DSP(Track:TTrack;DSP:TDSP; Actif:Boolean);
Procedure Load_DSP(DSP:TDSP);
Procedure Save_DSP(DSP:TDSP);
Procedure Create_Egalizer(Track:TTrack;Egalizer:TEgalizer);
Procedure Free_Egalizer(Track:TTrack;Egalizer:TEgalizer);
Procedure Switch_Egalizer(Track:TTrack; Egalizer:TEgalizer; Actif:Boolean);
Procedure Load_Egalizer(Egalizer:TEgalizer);
Procedure Save_Egalizer(Egalizer:TEgalizer);          
Procedure Create_VST(Track:TTrack;VST:TVST; CreateParams:Boolean);
Procedure Free_VST(Track:TTrack;VST:TVST);
Procedure Switch_VST(Track:TTrack; VST:TVST; Actif:Boolean);
Procedure Load_VST(VST:TVST);
Procedure Save_VST(VST:TVST);
Procedure Create_SndFont(Track:TTrack; SoundFont:TSndFont);
Procedure Free_SndFont(Track:TTrack; SoundFont:TSndFont);
Procedure Switch_SndFont(Track:TTrack; SoundFont:TSndFont; Actif:Boolean);
Procedure MidiEventToVST(VstChan: DWORD; channel: DWORD; data: DWORD;  user: Pointer); stdcall;

implementation

Uses UGnSound, UMidiSound, UParams, UTracks, UFiles;

{>>Procédure pour initialiser Bass}
Function Init_Bass : Boolean;
Const
  PluginsFiles: Array [0..3] Of String=
                ('bass.dll','bass_fx.dll',
                'bassmix.dll','bassmidi.dll');
Var
  Way:String;
  IndexPgFile:Cardinal;
Begin
  //Résultat par défaut
  Result:=False;
  //On définit le chemin de l'application
  Way:=ExtractFilePath(ParamStr(0));
  //Pour tout les plugins
  For IndexPgFile:=0 To 3 Do
  //Si le fichier plugin n'existe pas alors
  If Not FileExists(Way+PluginsFiles[IndexPgFile]) Then
     //On affiche un avertissement d'erreur et on quitte l'application
     Begin
       Showmessage('Des fichiers manquent. L''application va se terminer');
       Exit;
     End;
  //On libère la dll Bass
  BASS_Free;
  //Si la version de la dll Bass est érronnée ou que son initialisation a échoué
  If  (HIWORD(BASS_GetVersion())<>BASSVERSION) or (not BASS_Init(-1,44100,BASS_DEVICE_LATENCY,Application.Handle,nil)) then
    //On affiche un avertissement d'erreur et on quitte l'application
    Begin
      Showmessage('Des fichiers sont érronés. L''application va se terminer');
      Exit;
    End;
  //On configure les Buffers
  BASS_SetConfig(BASS_CONFIG_BUFFER,140);
  //Si pas de problèmes le résultat est vrai
  If BASS_ErrorGetCode=0 Then Result:=True;
End;

{>>Procédure pour libérer Bass}
Function Free_Bass : Boolean;
Begin
  //On libère la dll Bass
  Result:=BASS_Free;
  //Si il y a un échec, on avertit l'utilisateur
  If Result=False then Showmessage('Erreur lors de la libération d''une Dll');
End;

{>>Procédure pour initialiser l'enregistrement}
Function Init_RecordBass : Boolean;
Begin
  //Résultat par défaut
  Result:=False;
  //Si  on ne peut pas initialiser l'enregistrement
  If (Not BASS_RecordInit(-1)) Then
    //On libère le device, on affiche un avertissement d'erreur
    Begin
      BASS_RecordFree;
      Showmessage('Problème pour l''acquisition');
    End
  //Sinon le résultat est vrai
  Else Result:=True;  
End;

{>>Procédure pour libérer Bass}
Function Free_RecordBass : Boolean;
Begin
  //On libère l'enregistrement
  Result:=BASS_RecordFree;
  //Si il y a un échec, on avertit l'utilisateur
  If Result=False then Showmessage('Erreur lors de la libération de l''enregistrement');
End;

{>>Procédure pour initialiser l'enregistrement}
Function Init_AsioBass : Boolean;
Begin
  //Résultat par défaut
  Result:=False;
  //Si l'asio est déja lancé ou qu'on ne peut pas l'initialiser
  If (BASS_ASIO_IsStarted) Or (Not BASS_ASIO_Init(0)) Then
    //On libère l'asio, on affiche un avertissement d'erreur
    Begin
      BASS_ASIO_Free;
      Showmessage('Problème pour l''asio');
    End
  //Sinon le résultat est vrai
  Else Result:=True;  
End;

{>>Procédure pour libérer Bass}
Function Free_AsioBass: Boolean;
Begin
  //On libère l'asio
  Result:=BASS_ASIO_Free;
  //Si il y a un échec, on avertit l'utilisateur
  If Result=False then Showmessage('Erreur lors de la libération de l''asio');
End;

{>>Procédure pour changer le volume d'un stream}
Procedure Change_Volume_Stream(SoundStream:HStream;NewVol:DWord);
Begin
  //Si SoundStream existe alors
  If SoundStream<>0 Then
  //On renvoit dans SoundStream le nouveau volume
  BASS_ChannelSetAttribute(SoundStream,BASS_ATTRIB_VOL, NewVol / 100);
End;

{>>Procédure pour changer le panoramique d'un stream}
Procedure Change_Pan_Stream(SoundStream:HStream;NewPan:Integer);
Begin
  //Si SoundStream existe alors
  If SoundStream<>0 Then
  //On renvoit dans SoundStream le nouveau panoramique
  BASS_ChannelSetAttribute(SoundStream,BASS_ATTRIB_PAN, NewPan / 100);
End;

{>>Fonction pour créer le stream d'une partie}
Function Create_PartStream(APart:TPart;AFreq:Integer) : Boolean;
Const
  Extensions:Array[0..3] Of String=('.Wav','.Mp3','.Midi','.Mid');
Begin
  //Résultat par défaut
  Result:=False;
  //Avec Part faire
  With APart Do
    Begin
      //Si Stream existe alors
      If Stream<>0 Then
      //On le libère
      BASS_StreamFree(Stream);
      //Avec Tracks_Form faire
      With Tracks_Form Do
      //Avec le track correspondant de BrowserTracks de
      With BrowserTracks.BrTracksCnt.Items[BrowserTracks.BrTracksCnt.ItemIndex] Do
      //Si l'extension de FileName est de type Wav ou Mp3 alors
      If AnsiIndexText(ExtractFileExt(FileName), Extensions) In [0,1] Then
        Begin
          //On crée tream comme un Stream classique
          Stream:=BASS_StreamCreateFile(FALSE,PChar(FileName),0,0,BASS_STREAM_DECODE);
          //On définit le type comme un Wav
          BrPanelTrack.TypeTrack:=TtWav;
        End
      Else
        Begin
          //Sinon on le crée comme un MidiStream
          Stream:=BASS_MIDI_StreamCreateFile(FALSE,PChar(FileName),0,0,BASS_STREAM_DECODE,AFreq);
          //On définit le type comme un Wav
          BrPanelTrack.TypeTrack:=TtMidi;
        End;
      //S'il n'y a pas d'erreur alors le résultat est vrai
      If BASS_ErrorGetCode=0 Then Result:=True;
    End;
End;

{>>Fonction pour créer le stream d'un Track}
Function Create_TrackStream(ATrack:TTrack;AFreq,AChan:Integer) : Boolean;
Begin
  //Résultat par défaut
  Result:=True;
  //Avec ATRack faire
  With ATrack Do
    Begin
      //Si le Stream n'existe pas alors
      If Stream=0 Then
      //On crée le Stream
      Stream:=BASS_Mixer_StreamCreate(AFreq,AChan,BASS_STREAM_DECODE);
      //S'il y a une erreur alors
      If Bass_ErrorGetCode<>0 Then
      //Le résultat est faux
      Result:=False;
    End;
End;    

{>>Fonction pour ajouter un stream dans un mix}
Function Add_Part_In_Track(ATrack:TTrack;APart:TPart):Boolean;
Const
  BPB=BASS_POS_BYTE;
Var
  Delay:DWord;
Begin
  //Résultat par défaut
  Result:=False;
  //On supprime Stream de son Mix
  BASS_Mixer_ChannelRemove(APart.Stream);
  //On définit le Delay comme BeginTime en bytes
  Delay:=BASS_ChannelSeconds2Bytes(ATrack.Stream,APart.BeginTime / 1000);
  //On rembobine le stream au début
  BASS_ChannelSetPosition(APart.Stream,0,BPB);       
  //On mixe Stream dans ATrack.Stream
  BASS_Mixer_StreamAddChannelEx(ATrack.Stream,APart.Stream,0,Delay,0);
  //S'il y a pas d'erreurs le résultat est vrai
  If BASS_ErrorGetCode=0 Then Result:=True;
End;

{>>Fonction pour supprimer un stream dans un mix}
Function Del_Part_In_Track(APart:TPart):Boolean;
Begin
  //Résultat par défaut
  Result:=False;
  //On supprime Stream de son Mix
  BASS_Mixer_ChannelRemove(APart.Stream);
  //On supprime Stream
  BASS_StreamFree(APart.Stream);//****
  //S'il y a pas d'erreurs le résultat est vrai
  If BASS_ErrorGetCode=0 Then Result:=True;
End;

{>>Fonction pour ajouter un Track au mixage}
Function Add_Track_In_Mix(ATrack:TTrack):Boolean;
Var
  IndexPart:Integer;
Begin
  //Résultat par défaut
  Result:=False;
  //AvecATrack faire
  With ATrack Do
    Begin
      //S'il admet des parties alors
      If PartCnt.Count>0 Then
      //Pour toutes les parties
      For IndexPart:=0 To (PartCnt.Count-1) Do
      //On additionne la partie IndexPart au Track
      Add_Part_In_Track(ATrack,PartCnt.Items[IndexPart]);
      //On mixe le Track à MasterStream
      BASS_Mixer_StreamAddChannel(Tracks_Form.TracksGrid.MasterStream,Stream,0);
      //S'il y a pas d'erreurs le résultat est vrai
      If BASS_ErrorGetCode=0 Then Result:=True;
    End;
End;

{>>Fonction pour supprimer un stream dans un mix}
Function Del_Track_In_Mix(ATrack:TTrack):Boolean;
Var
  IndexPart,IndexEffect:Integer;
  CrTypeEffect:TMxTypeEffect;
Begin
  //Résultat par défaut
  Result:=False;
  //Avec ATrack faire
  With ATrack Do
    Begin
      //S'il admet des parties alors
      If PartCnt.Count>0 Then
      //Pour toutes les parties
      For IndexPart:=0 To (PartCnt.Count-1) Do
      //On les supprime de ATrack
      Del_Part_In_Track(PartCnt.Items[IndexPart]);    
      //Pour tout les types d'effets faire
      For CrTypeEffect:=TMxSoundFont To TMxEqualizer Do
      //Avec le type d'effet CrTypeEffect faire
      With ItemsEffect[Ord(CrTypeEffect)] Do
        Begin
          //S'il y a des effets de ce type
          If Count>0 Then
          //Pour tout ces effets faire
          For IndexEffect:=0 To (Count-1) Do
          //Suivant le type d'effet
          Case CrTypeEffect Of
            //Si c'est une SoundFont, on la supprime
            TMxSOUNDFONT : Free_SndFont(ATrack,SoundFontCnt.Items[IndexEffect]);
            //Si c'est un VSTI, on le supprime
            TMxVSTI : Free_VST(ATrack,VSTICnt.Items[IndexEffect]);
            //Si c'est un VSTE, on le supprime
            TMxVSTE : Free_VST(ATrack,VSTECnt.Items[IndexEffect]);
            //Si c'est un DSP, on le supprime
            TMxDSP : Free_DSP(ATrack,DSPCnt.Items[IndexEffect]);
            //Si c'est un EQUALIZER, on le supprime
            TMxEQUALIZER  : Free_Egalizer(ATrack,EgalizerCnt.Items[IndexEffect]);
          End;
        End;
      //On supprime le Stream de ATrack de MasterStream
      BASS_Mixer_ChannelRemove(Stream);
      //On supprime Stream
      BASS_StreamFree(Stream);//****
      //S'il y a pas d'erreurs le résultat est vrai
      If BASS_ErrorGetCode=0 Then Result:=True;
    End;
End;

{>>Procédure pour Switcher un stream dans un mix}
Procedure Switch_Track_In_Mix(ATrack:TTrack;Actif:Boolean);
Var
  Vol:Integer;
Begin
  //Si Actif est vrai alors Vol est le volume de ATrack
  If Actif Then Vol:=ATrack.Volume
  //Sinon il est nul
  Else Vol:=0;
  //On change le volume
  Change_Volume_Stream(ATrack.Stream,Vol);
End;

{>>Fonction de callback l'asio}
function AsioProc(input: BOOL; channel: DWORD; buffer: Pointer; length: DWORD;user: Pointer): DWORD; stdcall;
begin
 Result := length;
end;

{>>Fonction pour activer l'asio}
Function Active_Asio(NbChannels:Integer;Input:Boolean):Boolean;
Var
  IndexChannels:Integer;
Begin
  //Résultat par défaut
  Result:=False;
  //Si l'asio est activé alors on l'arette
  If BASS_ASIO_IsStarted Then BASS_ASIO_Stop;
  //Pour tout les canaux
  For IndexChannels:=0 To  (NbChannels-1) Do
    Begin
      //Si le canal n'est pas actif  alors
      If BASS_ASIO_ChannelIsActive(Input,IndexChannels)=BASS_ASIO_ACTIVE_DISABLED Then
      //On active le canal
      BASS_ASIO_ChannelEnable(Input,IndexChannels,@AsioProc,Nil);
    End;
  //Si on peut lancer l'asio alors
  If BASS_ASIO_Start(0) Then Result:=True;
End;

Function Desactive_Asio(NbChannels:Integer;Input:Boolean):Boolean;
Var
  IndexChannels:Integer;
Begin
  //Résultat par défaut
  Result:=False;
  //Pour tout les canaux
  For IndexChannels:=0 To  (NbChannels-1) Do
    Begin
      //On disjoint le canal
      BASS_ASIO_ChannelReset(Input,IndexChannels,BASS_ASIO_RESET_JOIN);
      //Si le canal est actif  alors
      If BASS_ASIO_ChannelIsActive(Input,IndexChannels)=BASS_ASIO_ACTIVE_ENABLED Then
      //On désactive le canal
      BASS_ASIO_ChannelReset(Input,IndexChannels,BASS_ASIO_RESET_ENABLE);
    End;
  //On arrete l'asio
  BASS_ASIO_Stop;
  //Si l'Asio n'est pas activé alors le résultat est vrai
  If Not BASS_ASIO_IsStarted Then Result:=True;
End;

{>>Fonction pour modifier la fréquence de l'asio}
Function Set_AsioFreq(NbChannels,AsioFreq:Integer;Input:Boolean):Boolean;
Var
  IndexChannels:Integer;
Begin
  //Résultat par défaut
  Result:=False;
  //On envoie la fréquence au device
  BASS_ASIO_SetRate(AsioFreq);
  //S'il n'y a pas d'erreurs alors
  If BASS_ASIO_ErrorGetCode=0 Then
    Begin
      //Pour tout les channels qui existent faire
      For IndexChannels:=0 To (NbChannels-1) Do
        Begin
          //Si le channel en question est actif alors
          If BASS_ASIO_ChannelIsActive(Input,IndexChannels)=BASS_ASIO_ACTIVE_ENABLED then
          //On envoit la fréquence au channel
          BASS_ASIO_ChannelSetRate(Input,IndexChannels,AsioFreq);
          //S'il y a une erreur on sort
          If BASS_ASIO_ErrorGetCode<>0 Then Exit;
        End;
      //Le résultat est vrai
      Result:=True;
    End;
End;

{>>Fonction pour modifier le volume de l'asio}
Function Set_AsioVol(NbChannels,AsioVol:Integer;Input:Boolean):Boolean;
Var
  IndexChannels:Integer;
Begin
  //Résultat par défaut
  Result:=False;
  //Pour tout les channels qui existent faire
  For IndexChannels:=0 To (NbChannels-1) Do
    Begin
      //Si le channel en question est actif alors
      If BASS_ASIO_ChannelIsActive(Input,IndexChannels)=BASS_ASIO_ACTIVE_ENABLED then
      //On envoit la fréquence au channel
      BASS_ASIO_ChannelSetVolume(Input,IndexChannels,AsioVol / 1000);
      //S'il y a une erreur on sort
      If BASS_ASIO_ErrorGetCode<>0 Then Exit;
    End;
  //Le résultat est vrai
  Result:=True;
End;

{>>Fonction pour modifier le nombre de canaux}
Function Set_AsioNbChannels(NbChannels,CountChannels:Integer;Input:Boolean):Boolean;
Var
  IndexChannels:Integer;
Begin
  //Résultat par défaut
  Result:=False;
  //Si le nombre de canaux est inférieur au nombre désiré on sort
  If NbChannels<CountChannels Then Exit;
  //Pour tout les canal qui existent faire
  For IndexChannels:=0 To (NbChannels-1) Do
    Begin
      //Si le canal est apres le nombre désiré alors
      If  IndexChannels>CountChannels Then
      //On met le canal en pause
      BASS_ASIO_ChannelPause(Input,IndexChannels)
      //Sinon on réactive le channel
      Else BASS_ASIO_ChannelReset(Input,IndexChannels,BASS_ASIO_RESET_PAUSE);
      //S'il y a une erreur on sort
      If BASS_ASIO_ErrorGetCode<>0 Then Exit;
    End;
  //Le résultat est vrai
  Result:=True;
End;

{>>Fonction pour créer un stream d'enregistrement}
Function Create_RecordStream(Part:TPart;RecFreq,RecChannels:Integer) : Boolean;
Begin
  //On définit le résultat par défaut
  Result:=False;
  //Si RecordStream existe alors
  If Part.Stream<>0 Then
  //On le libère
  BASS_StreamFree(Part.Stream);
  //On crée RecordStream
  Part.Stream:=BASS_RecordStart(RecFreq,RecChannels, MakeLong(0, 50), @RecordingCallback,@Part.ID);
  //S'il n'y a pas eu d'erreur on retourne vrai
  If BASS_ErrorGetCode=0 Then Result:=True;
End;

{>>Fonction callback d'enregistrement}
function RecordingCallback(Handle: HRECORD; buffer: Pointer; length: DWORD; user: Pointer): boolean; stdcall;
Var
  IndexTrack,IndexPart:Integer;
Begin
  //Résultat par défaut
  Result:=True;  
  //Avec Tracks_Form.TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //S'il admet des tracks alors
      If TrackCnt.Count>0 Then
      //Pour tout les tracks faire
      For IndexTrack:=0 To (TrackCnt.Count-1) Do
      ///Avec le Track IndexTrack faire
      With TrackCnt.Items[IndexTrack] Do
        Begin
          //S'il admet des parties alors
          If PartCnt.Count>0 Then
          //Pour tout les parties faire
          For IndexPart:=0 To (PartCnt.Count-1) Do
          //Si la partie IndexPart a pour ID la valeur de User alors
          If @(PartCnt.Items[IndexPart].ID)=User Then
          //Avec la partie IndexPar faire
          With PartCnt.Items[IndexPart] Do
            Begin
              //On incrément EndTime
              EndTime:=EndTime+Round(BASS_ChannelBytes2Seconds(Stream,Length)*1000);
              //On defreeze le systeme
              Application.ProcessMessages;
              //On scanne les données
              Scan_Record(PartCnt.Items[IndexPart],Length);
              //On ajoute les données au fichier correspondant
              Add_Data_To_WavFile(Buffer, Length,FileName);
              //Avec BrowserTracks faire
              With Tracks_Form.BrowserTracks Do
                Begin
                  //Avec le Track correspondant faire
                  With BrTracksCnt.Items[IndexTrack].BrPanelTrack Do
                  //Si le bouton d'acquisition n'est pas appuyé alors
                  If Not AcquisitionBt.Pushed Then
                  //On arrete l'acquisition
                  Result:=False;
                End;
            End;     
        End;
    End;
End;

{>>Procedure pour scanner des données d'enregistrement}
Procedure Scan_Record(Part:TPart;Length:Integer);
Var                      
  Pic,LeftPic,RightPic:Integer;
Begin
  //Avec Track faire
  With Part Do
    Begin
      //Avec le BitMap du Picture faire
      With Picture.Bitmap Do
        Begin
          //On définit la largueur
          Width:=Tracks_Form.TracksGrid.MsToPixel(EndTime-BeginTime)+1;
          //On définit la hauteur
          Height:=Tracks_Form.TracksGrid.HeightTrack;
          //Avec le canvas faire
          With Canvas Do
            Begin
              //On définit la couleur du stylo
              Pen.Color:=ClBlack;
              //On définit le pic du son
              Pic:=BASS_ChannelGetLevel(Stream);
              //On en déduit la partie gauche
              LeftPic:=LOWORD(Pic);
              //On en déduit la partie droite
              RightPic:=HIWORD(Pic);
              //On se place au point (PositionRecord,Height Div 2)
              MoveTo(Width-1,Height Div 2);
              //On trace une droite jusqu'au point correspondant à LeftPic
              LineTo(Width-1,Height Div 2 - Round(LeftPic*Height / (2*32768)));
              //On se place au point (PositionRecord,Height Div 2)
              MoveTo(Width-1,Height Div 2);
              //On trace une droite jusqu'au point correspondant àRightPic
              LineTo(Width-1,Height Div 2 +Round(RightPic*Height / (2*32768)));
              //On rafraichit TracksGrid.
              Tracks_Form.TracksGrid.Refresh;
            End;
         End;
    End;
End;

{>>Procédure pour charger un DSP}
Procedure Create_DSP(Track:TTrack;DSP:TDSP);
Const
  DSPToFlag:Array[TTypeDSP] Of DWord=
    (BASS_FX_BFX_ECHO,BASS_FX_BFX_FLANGER,BASS_FX_BFX_VOLUME,
    BASS_FX_BFX_REVERB,BASS_FX_BFX_LPF,BASS_FX_BFX_DAMP,
    BASS_FX_BFX_AUTOWAH,BASS_FX_BFX_ECHO2,BASS_FX_BFX_PHASER,
    BASS_FX_BFX_ECHO3,BASS_FX_BFX_CHORUS,BASS_FX_BFX_APF,
    BASS_FX_BFX_COMPRESSOR,BASS_FX_BFX_DISTORTION);
Begin
  //Si le Stream de Track existe alors
  If Track.Stream<>0 Then
  //On crée l'effet DSP et on récupère le handle dans Stream
  DSP.Stream:=BASS_ChannelSetFX(Track.Stream,DSPToFlag[DSP.TypeDSP],DSP.Priority);
End;

{>>Procédure pour libérer un DSP}
Procedure Free_DSP(Track:TTrack;DSP:TDSP);
Begin
  //Si les Streams de DSP et Track existent alors
  If (DSP.Stream<>0) And (Track.Stream<>0) Then
  //On libère le DSP
  BASS_ChannelRemoveFX(Track.Stream,DSP.Stream);
End;

{>>Procédure pour switcher un DSP}
Procedure Switch_DSP(Track:TTrack;DSP:TDSP; Actif:Boolean);
Begin
  //Si Actif est faux on libère le DSP
  If Not Actif Then 
    Free_DSP(Track,DSP)
  Else
    Begin
      //On crée l'effet
      Create_DSP(Track,DSP);
      //On charge les valeurs
      Load_DSP(DSP);
    End;
End;

{>>Procédure pour charger un DSP}
Procedure Load_DSP(DSP:TDSP);
Var
  BFX_ECHO:BASS_BFX_ECHO;
  BFX_FLANGER:BASS_BFX_FLANGER;
  BFX_VOLUME:BASS_BFX_VOLUME;
  BFX_REVERB:BASS_BFX_REVERB;
  BFX_LPF:BASS_BFX_LPF;
  BFX_DAMP:BASS_BFX_DAMP;
  BFX_AUTOWAH:BASS_BFX_AUTOWAH;
  BFX_ECHO2:BASS_BFX_ECHO2;
  BFX_PHASER:BASS_BFX_PHASER;
  BFX_ECHO3:BASS_BFX_ECHO3;
  BFX_CHORUS:BASS_BFX_CHORUS;
  BFX_APF:BASS_BFX_APF;
  BFX_COMPRESSOR:BASS_BFX_COMPRESSOR;
  BFX_DISTORTION:BASS_BFX_DISTORTION;
Begin
  //Si le Stream de DSP existe alors
  If (DSP.Stream<>0)Then
    Begin
      //Suivant le type de DSP
      Case DSP.TypeDSP Of
        TEcho :          Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_ECHO);
                           BFX_ECHO.fLevel:=DSP.Level;
                           BFX_ECHO.lDelay:=DSP.LDelay;
                           BASS_FXSetParameters(DSP.Stream,@BFX_ECHO);
                         End;
        TReverb :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_Reverb);
                           BFX_Reverb.fLevel:=DSP.Level;
                           BFX_Reverb.lDelay:=DSP.LDelay;
                           BASS_FXSetParameters(DSP.Stream,@BFX_Reverb);
                         End;
        TFlanger :       Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_FLANGER);
                           BFX_FLANGER.fWetDry:=DSP.WetDry;
                           BFX_FLANGER.fSpeed:=DSP.Speed;
                           BFX_FLANGER.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_FLANGER);
                         End;
        TVolume :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_VOLUME);
                           BFX_VOLUME.fVolume:=DSP.Volume;
                           BFX_VOLUME.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_VOLUME);
                         End;
        TLowPassFilter : Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_LPF);
                           BFX_LPF.fResonance:=DSP.Resonance;
                           BFX_LPF.fCutOffFreq:=DSP.CutOffFreq;
                           BFX_LPF.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_LPF);
                         End;
        TAmplification : Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_DAMP);
                           BFX_DAMP.fTarget:=DSP.Target;
                           BFX_DAMP.fQuiet:=DSP.Quiet;
                           BFX_DAMP.fRate:=DSP.Rate;
                           BFX_DAMP.fGain:=DSP.Gain;
                           BFX_DAMP.fDelay:=DSP.Delay;
                           BFX_DAMP.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_DAMP);
                         End;
        TAutoWah :       Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_AUTOWAH);
                           BFX_AUTOWAH.fDryMix:=DSP.DryMix;
                           BFX_AUTOWAH.fWetMix:=DSP.WetMix;
                           BFX_AUTOWAH.fFeedback:=DSP.Feedback;
                           BFX_AUTOWAH.fRate:=DSP.Rate;
                           BFX_AUTOWAH.fRange:=DSP.Range;
                           BFX_AUTOWAH.fFreq:=DSP.Freq;
                           BFX_AUTOWAH.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_AUTOWAH);   
                         End;
        TPhaser :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_PHASER);
                           BFX_PHASER.fDryMix:=DSP.DryMix;
                           BFX_PHASER.fWetMix:=DSP.WetMix;
                           BFX_PHASER.fFeedback:=DSP.Feedback;
                           BFX_PHASER.fRate:=DSP.Rate;
                           BFX_PHASER.fRange:=DSP.Range;
                           BFX_PHASER.fFreq:=DSP.Freq;
                           BFX_PHASER.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_PHASER);
                         End;
        TEcho2 :         Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_ECHO2);
                           BFX_ECHO2.fDryMix:=DSP.DryMix;
                           BFX_ECHO2.fWetMix:=DSP.WetMix;
                           BFX_ECHO2.fFeedback:=DSP.Feedback;
                           BFX_ECHO2.fDelay:=DSP.Delay;
                           BFX_ECHO2.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_ECHO2);
                         End;
        TEcho3 :         Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_ECHO3);
                           BFX_ECHO3.fDryMix:=DSP.DryMix;
                           BFX_ECHO3.fWetMix:=DSP.WetMix;
                           BFX_ECHO3.fDelay:=DSP.Delay;
                           BFX_ECHO3.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_ECHO3);
                         End;
        TChorus :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_CHORUS);
                           BFX_CHORUS.fDryMix:=DSP.DryMix;
                           BFX_CHORUS.fWetMix:=DSP.WetMix;
                           BFX_CHORUS.fFeedback:=DSP.Feedback;
                           BFX_CHORUS.fRate:=DSP.Rate;
                           BFX_CHORUS.fMinSweep:=DSP.MinSweep;
                           BFX_CHORUS.fMaxSweep:=DSP.MaxSweep;
                           BFX_CHORUS.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_CHORUS);
                         End;
        TAllPassFilter : Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_APF);
                           BFX_APF.fGain:=DSP.Gain;
                           BFX_APF.fDelay:=DSP.Delay;
                           BFX_APF.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_APF);
                         End;
        TCompressor :    Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_COMPRESSOR);
                           BFX_COMPRESSOR.fThreshold:=DSP.Threshold;
                           BFX_COMPRESSOR.fAttacktime:=DSP.Attacktime;
                           BFX_COMPRESSOR.fReleasetime:=DSP.Releasetime;
                           BFX_COMPRESSOR.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_COMPRESSOR);
                         End;
        TDistortion :    Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_DISTORTION);
                           BFX_DISTORTION.fDrive:=DSP.Drive;
                           BFX_DISTORTION.fDryMix:=DSP.DryMix;
                           BFX_DISTORTION.fWetMix:=DSP.WetMix;
                           BFX_DISTORTION.fFeedback:=DSP.Feedback;
                           BFX_DISTORTION.fVolume:=DSP.Volume;
                           BFX_DISTORTION.lChannel:=BASS_BFX_CHANALL;
                           BASS_FXSetParameters(DSP.Stream,@BFX_DISTORTION);
                         End;
      End;
    End;
End;

{>>Procédure pour sauver un DSP}
Procedure Save_DSP(DSP:TDSP);
Var
  BFX_ECHO:BASS_BFX_ECHO;
  BFX_FLANGER:BASS_BFX_FLANGER;
  BFX_VOLUME:BASS_BFX_VOLUME;
  BFX_REVERB:BASS_BFX_REVERB;
  BFX_LPF:BASS_BFX_LPF;
  BFX_DAMP:BASS_BFX_DAMP;
  BFX_AUTOWAH:BASS_BFX_AUTOWAH;
  BFX_ECHO2:BASS_BFX_ECHO2;
  BFX_PHASER:BASS_BFX_PHASER;
  BFX_ECHO3:BASS_BFX_ECHO3;
  BFX_CHORUS:BASS_BFX_CHORUS;
  BFX_APF:BASS_BFX_APF;
  BFX_COMPRESSOR:BASS_BFX_COMPRESSOR;
  BFX_DISTORTION:BASS_BFX_DISTORTION;
Begin
  //Si le Stream de DSP existe alors
  If (DSP.Stream<>0)Then
    Begin
      //Suivant le type de DSP
      Case DSP.TypeDSP Of
        TEcho :          Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_ECHO);
                           DSP.Level:=BFX_ECHO.fLevel;
                           DSP.LDelay:=BFX_ECHO.lDelay;
                         End;
        TReverb :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_Reverb);
                           DSP.Level:=BFX_Reverb.fLevel;
                           DSP.LDelay:=BFX_Reverb.lDelay;
                         End;
        TFlanger :       Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_FLANGER);
                           DSP.WetDry:=BFX_FLANGER.fWetDry;
                           DSP.Speed:=BFX_FLANGER.fSpeed;
                         End;
        TVolume :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_VOLUME);
                           DSP.Volume:=BFX_VOLUME.fVolume;
                         End;
        TLowPassFilter : Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_LPF);
                           DSP.Resonance:=BFX_LPF.fResonance;
                           DSP.CutOffFreq:=BFX_LPF.fCutOffFreq;
                         End;
        TAmplification : Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_DAMP);
                           DSP.Target:=BFX_DAMP.fTarget;
                           DSP.Quiet:=BFX_DAMP.fQuiet;
                           DSP.Rate:=BFX_DAMP.fRate;
                           DSP.Gain:=BFX_DAMP.fGain;
                           DSP.Delay:=BFX_DAMP.fDelay;
                         End;
        TAutoWah :       Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_AUTOWAH);
                           DSP.DryMix:=BFX_AUTOWAH.fDryMix;
                           DSP.WetMix:=BFX_AUTOWAH.fWetMix;
                           DSP.Feedback:=BFX_AUTOWAH.fFeedback;
                           DSP.Rate:=BFX_AUTOWAH.fRate;
                           DSP.Range:=BFX_AUTOWAH.fRange;
                           DSP.Freq:=BFX_AUTOWAH.fFreq;
                         End;
        TPhaser :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_PHASER);
                           DSP.DryMix:=BFX_PHASER.fDryMix;
                           DSP.WetMix:=BFX_PHASER.fWetMix;
                           DSP.Feedback:=BFX_PHASER.fFeedback;
                           DSP.Rate:=BFX_PHASER.fRate;
                           DSP.Range:=BFX_PHASER.fRange;
                           DSP.Freq:=BFX_PHASER.fFreq;
                         End;
        TEcho2 :         Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_ECHO2);
                           DSP.DryMix:=BFX_ECHO2.fDryMix;
                           DSP.WetMix:=BFX_ECHO2.fWetMix;
                           DSP.Feedback:=BFX_ECHO2.fFeedback;
                           DSP.Delay:=BFX_ECHO2.fDelay;
                         End;
        TEcho3 :         Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_ECHO3);
                           DSP.DryMix:=BFX_ECHO3.fDryMix;
                           DSP.WetMix:=BFX_ECHO3.fWetMix;
                           DSP.Delay:=BFX_ECHO3.fDelay;
                         End;
        TChorus :        Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_CHORUS);
                           DSP.DryMix:=BFX_CHORUS.fDryMix;
                           DSP.WetMix:=BFX_CHORUS.fWetMix;
                           DSP.Feedback:=BFX_CHORUS.fFeedback;
                           DSP.Rate:=BFX_CHORUS.fRate;
                           DSP.MinSweep:=BFX_CHORUS.fMinSweep;
                           DSP.MaxSweep:=BFX_CHORUS.fMaxSweep;
                         End;
        TAllPassFilter : Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_APF);
                           DSP.Gain:=BFX_APF.fGain;
                           DSP.Delay:=BFX_APF.fDelay;
                         End;
        TCompressor :    Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_COMPRESSOR);
                           DSP.Threshold:=BFX_COMPRESSOR.fThreshold;
                           DSP.Attacktime:=BFX_COMPRESSOR.fAttacktime;
                           DSP.Releasetime:=BFX_COMPRESSOR.fReleasetime;
                         End;
        TDistortion :    Begin
                           BASS_FXGetParameters(DSP.Stream,@BFX_DISTORTION);
                           DSP.Drive:=BFX_DISTORTION.fDrive;
                           DSP.DryMix:=BFX_DISTORTION.fDryMix;
                           DSP.WetMix:=BFX_DISTORTION.fWetMix;
                           DSP.Feedback:=BFX_DISTORTION.fFeedback;
                           DSP.Volume:=BFX_DISTORTION.fVolume;
                         End;
      End;
    End;  
End;

{>>Procédure pour charger un Egalizer}
Procedure Create_Egalizer(Track:TTrack;Egalizer:TEgalizer);
Var
  IndexBand:Integer;
  BandEq  : BASS_BFX_PEAKEQ;
Begin
  //Si le Stream de Track existe alors
  If Track.Stream<>0 Then
    Begin
      //On crée l'egalizer
      Egalizer.Stream:=BASS_ChannelSetFX(Track.Stream,BASS_FX_BFX_PEAKEQ,Egalizer.Priority);
      //On crée les bandes
      Add_Egalizer_Bands(Egalizer);
      //Pour toutes les bandes
      For IndexBand:=0 To 9 Do
      //Avec la bande IndexBand faire
      With Egalizer.BandCnt.Items[IndexBand] Do
        Begin
          //On définit le numéro de la bande dans BandEq
          BandEq.lBand:=IndexBand;
          //On définit la largueur de la fréquence dans BandEq
          BandEq.fBandwidth:=Bandwidth;
          //On définit la valeur du facteur Q dans BandEq 
          BandEq.fQ:=Q;
          //On définit la fréquence centraile dans BandEq
          BandEq.fCenter:=Center;
          //On définit fGain
          BandEq.fGain:=Gain;
          //On l'applique l'effet à tout les canaux
          BandEq.lChannel:= BASS_BFX_CHANALL;
          //On envoie les paramètres par défaut dans BandEq
          BASS_FXSetParameters(Egalizer.Stream, @BandEq);
        End;
    End;
End;

{>>Procédure pour libérer un Egalizer}
Procedure Free_Egalizer(Track:TTrack;Egalizer:TEgalizer);
Begin
  //Si le Stream de Track existe alors
  If Track.Stream<>0 Then
  //On libère l'egalizer
  BASS_ChannelRemoveFX(Track.Stream,Egalizer.Stream);
End;

{>>Procédure pour switcher un Egalizer}
Procedure Switch_Egalizer(Track:TTrack;Egalizer:TEgalizer; Actif:Boolean);
Begin
  //Si Actif est faux on désactive l'égalizer
  If Not Actif Then Free_Egalizer(Track,Egalizer)
  //Sinon
  Else
    Begin
      //On charge l'égalizer
      Create_Egalizer(Track,Egalizer);
      //On charge les paramètres
      Load_Egalizer(Egalizer);
    End;
End;

{>>Procédure pour charger les paramètres d'un égalizer}
Procedure Load_Egalizer(Egalizer:TEgalizer);
Var
  IndexBand:Integer;
  BandEq  : BASS_BFX_PEAKEQ;
Begin
  //Si le Stream de Egalizer existe alors
  If (Egalizer.Stream<>0)Then
  //Pour toutes les bands faire
  For IndexBand:=0 To 9 Do
  //Avec la Band IndexBand faire
  With Egalizer.BandCnt.Items[IndexBand] Do
    Begin
      //Définir le numéro de la Band
      BandEq.lBand:=IndexBand;
      //On récupère les paramètres de la bande dans BandEq
      BASS_FXGetParameters(Egalizer.Stream, @BandEq);
      //Si Q est non nul alors on définit le fQ de BandEq
      If Q<>0 Then BandEq.fQ:=Q
      //Sinon on définit le fBandwidth de BandEq
      Else BandEq.fBandwidth:=Bandwidth;
      //Sa fréquence centrale
      BandEq.fCenter:=Center;
      //Son gain
      BandEq.fGain:=Gain;
      //On l'applique l'effet à tout les canaux
      BandEq.lChannel:= BASS_BFX_CHANALL;
      //On envoit les paramètres au Stream de l'égalizer
      BASS_FXSetParameters(Egalizer.Stream, @BandEq);
    End;
End;

{>>Procédure pour charger les paramètres d'un égalizer}
Procedure Save_Egalizer(Egalizer:TEgalizer);
Var
  IndexBand:Integer;
  BandEq  : BASS_BFX_PEAKEQ;
Begin
  //Si le Stream de Egalizer existe alors
  If (Egalizer.Stream<>0)Then
  //Pour toutes les bandes faire
  For IndexBand:=0 To 9 Do
  //Avec la bande IndexBand faire
  With Egalizer.BandCnt.Items[IndexBand] Do
    Begin
      //Définir le numéro de la bande
      BandEq.lBand:=IndexBand;
      //On récupère les paramètres de la bande dans BandEq
      BASS_FXGetParameters(Egalizer.Stream, @BandEq);
      //Définir le BandWidth de la bande
      Bandwidth:=BandEq.fBandwidth;
      //Son facteur Q
      Q:=BandEq.fQ;
      //Sa fréquence centrale
      Center:=BandEq.fCenter;
      //Son gain
      Gain:=BandEq.fGain;
    End;
End;

{>>Procédure pour charger un VST}
Procedure Create_VST(Track:TTrack;VST:TVST; CreateParams:Boolean);
Var
  AFreq,AChan:Integer;
Begin
  //Si le Stream de Track existe et  les paramètres Wav/Midi sont complets alors
  If (Track.Stream<>0) And (Params_Wav_Midi_Completed) Then
    Begin
      //Avec Params_Form faire
      With Params_Form Do
        Begin
          //On définit la fréquence
          AFreq:=StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]);
          //On définit le nombre de canaux
          AChan:=Round(NbChannel_LsBx.ItemIndex+1);
        End;
      //Avec VST faire
      With VST Do
      //Si VST est un VSTE alors
      If Collection=Track.VSTECnt Then
      //On crée l'effet VSTE et on récupère le handle dans Stream
      Stream:=BASS_VST_ChannelSetDSP(Track.Stream,Pchar(FileName),BASS_VST_KEEP_CHANS,Priority)
      //Sinon on crée l'effet VSTI et on récupère le handle dans Stream
      Else Stream:=BASS_VST_ChannelCreate(AFreq,AChan,Pchar(FileName),BASS_SAMPLE_FLOAT);
      //Si il faut créer les paramètres, on le fait
      If CreateParams Then Add_VST_Params(VST);
    End;
End;

{>>Procédure pour libérer un VST}
Procedure Free_VST(Track:TTrack;VST:TVST);
Begin
  //Si les Streams de VST et Track existent alors
  If (VST.Stream<>0) And (Track.Stream<>0) Then
    Begin
      //Avec VST faire
      With VST Do
      //Si VST est un VSTE alors
      If Collection=Track.VSTECnt Then
      //On libère le VST comme un VSTE
      BASS_VST_ChannelRemoveDSP(Track.Stream,VST.Stream)
      //Sinon on libère le VST comme un VSTI
      Else BASS_VST_ChannelFree(VST.Stream);
    End;  
End;

{>>Procédure pour switcher un VST}
Procedure Switch_VST(Track:TTrack; VST:TVST; Actif:Boolean);
Begin
  //Si Actif est faux on libère VST
  If Not Actif Then Free_VST(Track,VST)
  //Sinon
  Else
    Begin
      //On crée l'effet
      Create_VST(Track,VST,False);
      //On charge ses paramètres
      Load_VST(VST);
    End;
End;

{>>Procédure pour charger les paramètres d'un VST}
Procedure Load_VST(VST:TVST);
Var
  IndexParam:Cardinal;
Begin
  //Si le Stream de VST existe alors
  If (VST.Stream<>0)Then
    Begin
      //S'il y a des paramètres alors
      If VST.VSTParamCnt.Count>0 Then
      //Pour tous les paramètres faire
      For IndexParam:=0 To (VST.VSTParamCnt.Count-1) Do
      //On envoit dans le Stream la valeur du paramètre IndexParam
      BASS_VST_SetParam(VST.Stream,IndexParam,VST.VSTParamCnt.Items[IndexParam].Value);
    End;
End;

{>>Procédure pour charger les paramètres d'un VST}
Procedure Save_VST(VST:TVST);
Var
  IndexParam:Cardinal;
Begin
  //Si le Stream de VST existe alors
  If (VST.Stream<>0)Then
    Begin
      //S'il y a des paramètres alors
      If VST.VSTParamCnt.Count>0 Then
      //Pour tous les paramètres faire
      For IndexParam:=0 To (VST.VSTParamCnt.Count-1) Do
      //On récupère dans VST la valeur du paramètre IndexParam
      VST.VSTParamCnt.Items[IndexParam].Value:=BASS_VST_GetParam(VST.Stream,IndexParam);
    End;
End;

{>>Procédure pour charger une Soundfont}
Procedure Create_SndFont(Track:TTrack; SoundFont:TSndFont);
Var
  MidiFont:BASS_MIDI_FONT;
  IndexPart:Integer;
Begin
  //Si le Stream de Track existe alors
  If Track.Stream<>0 Then
    Begin
      //Si Track admet des Parties alors
      If Track.PartCnt.Count>0 Then
      //Pour toutes les parties faire
      For IndexPart:=0 To (Track.PartCnt.Count-1) Do
      //On charge MidiFont
      Load_SoundFont(Track.PartCnt.Items[IndexPart].Stream,MidiFont,SoundFont.FileName);
      //On définit le Stream de SoundFont
      SoundFont.Stream:=MidiFont.font;
    End;
End;

{>>Procédure pour libérer une Soundfont}
Procedure Free_SndFont(Track:TTrack; SoundFont:TSndFont);
Var
  MidiFont:BASS_MIDI_FONT;
  IndexPart:Integer;
Begin
  //Si le Stream de Track existe alors
  If Track.Stream<>0 Then
    Begin
      //On définit MidiFont
      MidiFont.font:=SoundFont.Stream;
      //Si Track admet des Parties alors
      If Track.PartCnt.Count>0 Then
      //Pour toutes les parties faire
      For IndexPart:=0 To (Track.PartCnt.Count-1) Do
      //On libère MidiFont
      Free_SoundFont(Track.PartCnt.Items[IndexPart].Stream,MidiFont);
      //On réinitialise le Stream de SoundFont
      SoundFont.Stream:=0;
    End;
End;

{>>Procédure pour switcher une Soundfont}
Procedure Switch_SndFont(Track:TTrack; SoundFont:TSndFont; Actif:Boolean);
Begin
  //Si Actif est faux on libère la SoundFont
  If Not Actif Then Free_SndFont(Track,SoundFont)
  //Sinon on la crée
  Else Create_SndFont(Track,SoundFont);
End;

{>>CallBack pour jouer des évènements Midi dans un VST}
Procedure MidiEventToVST(VstChan: DWORD; channel: DWORD; data: DWORD;  user: Pointer); stdcall;
var
  Chan, Param: Word;
  AUser:DWOrd;
begin
  //Le Channel correspond au HiWord des données
  Chan:= HiWord(data);
  //Le paramètres correspond au LoWord des données
  Param:= LoWord(data);
  //On définit AUser
  AUser:=DWORD(USer);
  //On envoit le paramètres
  BASS_VST_ProcessEvent(VstChan, Chan,AUser, Param);
End;

end.
                        
