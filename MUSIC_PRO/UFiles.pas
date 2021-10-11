{>>Dans cette unité, on va traiter tous ce qui touche aux fichiers}

unit UFiles;

interface

Uses Forms,Classes,StdCtrls,Windows,SysUtils,Controls,Registry, Bass, BassMix, BassMidi, ComCtrls, Dialogs;

Procedure Create_Extension(Key,Ext,Icon:String);
Procedure Initialize_Extensions;
procedure List_Type_File(AFolder, Extension:String;AListBox:TListBox);
procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
procedure Save_Project(DestFile:String;Components:Array Of TComponent);
procedure Open_Project(SourceFile:String;Components:Array Of TComponent);
Procedure Create_Wav_Header(Stream:TStream; Length:QWord);
Procedure Stream_To_WavFile(AStream:HStream; DestFile:String; ProgressBar:TProgressBar);
Procedure MidiStream_To_WavFile(SourceFile,DestFile,SoundFont:String; ProgressBar:TProgressBar);
Procedure Add_Data_To_WavFile(Data:Pointer; Length:Integer; DestFile:String);
Procedure Mix_To_WavFile(DestFile:String);
Procedure Pattern_To_MidiFile(DestFile:String);
Procedure Piano_To_MidiFile(DestFile:String);
implementation

Uses UTracks,UPatternMd,UPianoMd,DuringTime,MidiWriter,UParams,UGnSound;

{>>Création d'une extension}
Procedure Create_Extension(Key,Ext,Icon:String);
Var
  Reg:TRegistry;
Begin
  //On crée Reg
 Reg:= TRegistry.Create;
  With Reg Do 
    Try
      //On définit le RootKey
      RootKey := HKEY_CLASSES_ROOT;
      //On ouvre ou crée la clé Key
      OpenKey(Key,True);
      //On écrit sa déscription
      WriteString('','Fichier de Music');
      //On ferme la clé
      CloseKey;
      //On ouvre ou crée la Clée Ext
      OpenKey(Ext,True);
      //On écrit l'extension
      WriteString('',Key);
      //On ferme la clé
      CloseKey;
      //On ouvre ou crée la Clée Key+'\DefaultIcon'
      OpenKey(Key+'\DefaultIcon',True);
      //On écrit le nom fichier .ico associé
      WriteString('',ExtractFileDir(ParamStr(0))+'\Ressources\'+Icon);
      //On ferme la clé
      CloseKey;
    Finally
     //On libere Reg
     Free;
   End;  
End;

{>>On crée les extensions spécifiques à music pro}
Procedure Initialize_Extensions;
Begin
  Create_Extension('PianoFiles','.pnf','PianoGrid.ico');
  Create_Extension('PatternFiles','.ptf','Pattern.ico');
  Create_Extension('TracksFiles','.tgf','TracksGrid.ico');     
End;

{>>Procédure pour lister des fichiers}
procedure List_Type_File(AFolder, Extension:String;AListBox:TListBox);
var
  FilesList: TStringList;
begin
  //On crée FileList
  FilesList := TStringList.Create;
  try
    //On efface la ListBox
    AListBox.Clear;
    //On récupere les fichiers ayant l'extension ciblée
    FindFiles(FilesList,AFolder,Extension);
    //On ajoute le nom des fichiers dans la listbox
    AListBox.Items.Assign(FilesList);
  finally
   //On libere FilesList
    FilesList.Free;
  end;
end;

{>>Procédure pour lister un type de fichier}
procedure FindFiles(FilesList: TStringList; StartDir, FileMask: string);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';
  IsFound :=FindFirst(StartDir+FileMask, faAnyFile-faDirectory, SR) = 0;
  while IsFound do begin
    FilesList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
    Application.ProcessMessages;
  end;
  FindClose(SR);
  DirList := TStringList.Create;
  IsFound := FindFirst(StartDir+'*.*', faAnyFile, SR) = 0;
  while IsFound do begin
    if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
    DirList.Add(StartDir + SR.Name);
    IsFound := FindNext(SR) = 0;
    Application.ProcessMessages;
  end;
  FindClose(SR);
  for i := 0 to DirList.Count - 1 do
  FindFiles(FilesList, DirList[i], FileMask);
  DirList.Free;
end;

{>>Procédure pour sauvegarder un projet}
procedure Save_Project(DestFile:String;Components:Array Of TComponent);
Var
  FS:TFileStream;
  IndexElmt:Integer;
Begin
  //On crée FS en mode création
  FS:=TFileStream.Create(DestFile,fmCreate);
  //On essaye
  Try
    //Pour tout les éléments du tableau
    For IndexElmt:=Low(Components) To High(Components) Do
    //D'enregistrer le composant correspondant
    FS.WriteComponent(Components[IndexElmt]);
  //Finalement
  Finally
    //On libere FS
    FS.Free;
  End;
End;

{>>Procédure pour ouvrir un projet}
procedure Open_Project(SourceFile:String;Components:Array Of TComponent);
Var
  FS:TFileStream;
  IndexElmt:Integer;
Begin
  //On crée FS en mode lecture
  FS:=TFileStream.Create(SourceFile,fmOpenRead);
  //On essaye
  Try
    //Pour tout les éléments du tableau
    For IndexElmt:=Low(Components) To High(Components) Do
    //De lire le flux dans le composant correspondant
    FS.ReadComponent(Components[IndexElmt]);
  //Finalement
  Finally
    //On libere FS
    FS.Free;
  End;
End;

{>>Procédure pour créer le header d'un fichier wav}
Procedure Create_Wav_Header(Stream:TStream; Length:QWord);
Type
  TWAVHeader= packed record
    riff:array[0..3] of Char;
    len: DWord;
    cWavFmt: array[0..7] of Char;
    dwHdrLen: DWord;
    wFormat: Word;
    wNumChannels: Word;
    dwSampleRate: DWord;
    dwBytesPerSec: DWord;
    wBlockAlign: Word;
    wBitsPerSample: Word;
    cData: array[0..3] of Char;
    dwDataLen: DWord;
  end;
Var
  WAVHeader:TWAVHeader;
Begin
  //Si Stream est assigné alors
  If Assigned(Stream) Then
    Begin
      //Avec Params_Form faire
      With Params_Form Do
        Begin
          //Avec WavHeader faire
          With WavHeader Do
            Begin
              //On définit l'ID du type fichier
              Riff := 'RIFF';
              //On définit Len
              Len:=Length+SizeOf(WavHeader)-8;
              //On définit l'ID du bloc
              cWavFmt:='WAVEfmt ';
              //La taille du bloc
              dwHdrLen:=16;
              //Le type de format
              wFormat:=1;
              //Le nombre de canaux
              wNumChannels:=Round(NbChannel_LsBx.ItemIndex+1);
              //La fréquence
              dwSampleRate:=Round(StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]));
              //Le nombre de bytes par seconde
              dwBytesPerSec:=Round(StrToInt(BytePerSec_Ed.Text));
              //Le nombre de bytes par bloc
              wBlockAlign:=Round(StrToInt(BytePerBloc_Ed.Text));
              //Le nombre de Bits par sample
              wBitsPerSample:=Round(StrToInt(BitsPerSample_LsBx.Items[BitsPerSample_LsBx.ItemIndex]));
	      //On écrit l'ID des données
              cData := 'data';
              //On définit dwDataLen
              dwDataLen:=Length;
            End;
          //On écrit WavHeader dans Stream
          Stream.Write(WavHeader,SizeOf(WavHeader));
        End;
    End;
End;    

{>>Procédure transformer un Stream en fichier Wav}
Procedure Stream_To_WavFile(AStream:HStream; DestFile:String; ProgressBar:TProgressBar);
Var
  Buf : Array [0..10000] of BYTE;
  FS:TFileStream;
  BytesRead:Integer;
  Length:QWord;
Const
  BPB: DWord=BASS_POS_BYTE;
Begin
  //On crée FS
  FS:=TFileStream.Create(DestFile,fmCreate);
  //On essaye
  Try
    //On définit Length
    Length:=BASS_ChannelGetLength(AStream,BPB);
    //On crée le header
    Create_Wav_Header(FS,Length);
    //Tant que on a pas récupéré toutes les données faire
    While BASS_ChannelIsActive(AStream)=BASS_ACTIVE_PLAYING Do
      Begin;
        //On récupère les données de AStream dans Buf
        BytesRead := BASS_ChannelGetData(AStream, @buf, 10000);
        //On écrit ces données dans FS
        FS.Write(buf, BytesRead);
        //On incrémente ProgressBar
        ProgressBar.Position:=100*(FS.Size-40) Div Length;
        //On défreeze le systeme
        Application.ProcessMessages;
      End;
  //Finalement
  Finally
    //On remet ProgressBar à zéro
    ProgressBar.Position:=0;
    //On libere AStream
    BASS_StreamFree(AStream);
    //On libère FS
    FreeAndNil(FS);
  End;
End;

{>>Procedure pour ajouter des données à un fichier wav}
Procedure Add_Data_To_WavFile(Data:Pointer; Length:Integer; DestFile:String);
Var
  FS:TFileStream;
  Flag:DWord;
  InfoSize:Integer;
Begin
  //Si le fichier n'existe pas alors
  If Not FileExists(DestFile) Then
  //Flag est fmCreate sinon est fmOpenWrite
  Flag:=fmCreate Else Flag:=fmOpenWrite ;
  //On créer FS en écriture
  FS:=TFileStream.Create(DestFile,Flag);
    //On essaye
    Try
      //On se place au début du fichier
      FS.Position:=0;
      //On crée le header
      Create_Wav_Header(FS,0);
      //On place FS à la fin
      FS.Position:=FS.Size;
      //On écrit les données dans FS
      FS.Write(Data^,Length);
      //On se place à "Len"
      FS.Position := 4;
      //On détermine la taille du fichier
      InfoSize := FS.Size - 8;
      //On écrit cette taille
      FS.Write(InfoSize, 4);
      //On détermine la taille des données
      Dec(InfoSize,$24);
      //On se place à dwDataLen
      FS.Position := 40;
      //On écrit la taille des données
      FS.Write(InfoSize, 4);
    //Finalement
    Finally
      //On libère FS
      FS.Free;
    End;
End;

{>>Procédure pour transformer un mix en fichier wav}
Procedure Mix_To_WavFile(DestFile:String);
Var
  Buf : Array [0..49] Of BYTE;
  FS:TFileStream;
  BytesRead:Integer;
  Length : QWord;
  DuringLastPart, PosLastPart:Double;
Const
  BPB: DWord=BASS_POS_BYTE;
Begin
  //On crée MasterStream
  Create_MixSound(BASS_STREAM_DECODE);
  //On crée FS
  FS:=TFileStream.Create(DestFile,fmCreate);
  //On essaye
  Try
    //Avec TracksGrid faire
    With Tracks_Form.TracksGrid Do
      Begin
        //On définit Length
        Length:=BASS_ChannelSeconds2Bytes(MasterStream,LastPart_InMix.EndTime Div 1000);
        //On crée le header
        Create_Wav_Header(FS,Length);
        //On détermine la durée de la dernière partie
        DuringLastPart:=LastPart_InMix.EndTime-LastPart_InMix.BeginTime;
        //On répète
        Repeat
          //On définit la position de la dernière partie
          PosLastPart:=BASS_ChannelBytes2Seconds(LastPart_InMix.Stream,BASS_Mixer_ChannelGetPosition(LastPart_InMix.Stream,BPB))*1000;
          //On change les effets
          Change_Effects;
          //On récupère les données de AStream dans Buf
          BytesRead := BASS_ChannelGetData(MasterStream, @buf, SizeOf(Buf));
          //On écrit ces données dans FS
          FS.Write(buf, BytesRead);
          //On incrémente File_Creating_PrBr 
          Tracks_Form.File_Creating_PrBr.Position:=100*(FS.Size-40) Div Length;
          //On défreeze le systeme
          Application.ProcessMessages;
        //Jusqu'à que l'on soit à la fin de la dernière partie  
        Until PosLastPart>=DuringLastPart;
      End;
  //Finalement
  Finally
    //On libère FS
    FreeAndNil(FS);
    //On libere AStream
    BASS_StreamFree(Tracks_Form.TracksGrid.MasterStream);
    //On remet File_Creating_PrBr à zéro
    Tracks_Form.File_Creating_PrBr.Position:=0;
  End;
End;

{>>Procedure pour transformer un fichier Midi en fichie Wav}
Procedure MidiStream_To_WavFile(SourceFile,DestFile,SoundFont:String; ProgressBar:TProgressBar);
Var
  MidiStream:HStream;
  SndFont:BASS_MIDI_FONT;
  Freq:Integer;
Begin
  //Avec Params_Form faire
  With Params_Form Do
    Begin
      //On définit Freq
      Freq:=StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]);
      //On crée MidiStream
      MidiStream:=BASS_MIDI_StreamCreateFile(False,PChar(SourceFile),0,0,BASS_STREAM_DECODE,Freq);
      //S'il n'y a pas eu d'erreur alors
      If BASS_ErrorGetCode=0 Then
        Begin
          //On crée la SoundFont
          SndFont.Font:=BASS_MIDI_FontInit(Pchar(SoundFont),0);
          //On définit le préset
          SndFont.Preset := -1;
          //On définit la banl
 	  SndFont.Bank := 0;
          //On envoye la font dans MidiStream
          BASS_MIDI_StreamSetFonts(MidiStream,SndFont,1);
          //On transforme MidiStream en fichier wav
          Stream_To_WavFile(MidiStream,DestFile,ProgressBar);
          //On libère la font
          BASS_MIDI_FontFree(SndFont.font);
          //On libère MidiStream
          BASS_StreamFree(MidiStream);
        End;
    End;
End;

{>>Procédure pour créer un fichier Midi à partir du Pattern}
Procedure Pattern_To_MidiFile(DestFile:String);
Const
 EqWhole:Array [TDuringOfTime] Of Byte=(0,1,2,3,4,5);
 Metro:Array [TDuringOfTime] Of Byte=(96,48,24,12,6,3);
Var
  MidiWriter:TMidiWriter;
  IndexInstr,IndexNote,RefTime:Integer;
  Num,Denom,Rythm,Pulse:Byte;
begin
  MidiWriter:=TMidiWriter.Create(Nil);
  //Avec Pattern_Form faire
  With Pattern_Form Do
  //On essaye
  Try
    //Avc MidiWriter faire
    With MidiWriter Do
      Begin
        //On définit le Format Midi 
        FormatMidi:=multiple_tracks_synchronous;
        //On définit le nombre de tracks par défaut
        NbTracks:=0;
        //La division est de 96 (valeur standard)
        Division:=96;
        //Pour tout les instruments faire
        For IndexInstr:=0 To (Pattern_Form.PatternMidi.InstrPatternCnt.Count-1) Do
        //Avec l'instrument IndexInstr faire
        With Pattern_Form.PatternMidi.InstrPatternCnt.Items[IndexInstr] Do
          Begin
            //Si l'instrument n'est pas activé on continue la boucle
            If Not Actived Then Continue;
            //On incrémente NbTracks
            NbTracks:=NbTracks+1;            
            //On initialise le track
            Initialize_Track;
            //S'il s'agit du premier track alors
            If NbTracks=1 Then
            //On ajoute le tempo
            Add_SetTempo_Event(0,Tempo_GgBr.Pos);
            //Avec DuringTime
            With DuringTime Do
              Begin
                //On définit le numérateur
                Num:=Time;
                //On définit le dénominateur
                Denom:=EqWhole[DuringOfTime];
                //On définit le rythme
                Rythm:=Metro[DuringOfTime];
                //On définit la pulsation
                Pulse:=8;
              End;
            //On ajoute la signature du temps
            Add_TimeSignature_Event(0,Num,Denom,Rythm,Pulse);
            //On ajoute le volume
            Add_Controller_Event(0,Channel,CtMainVolume,Volume);
            //On ajoute la modulation
            Add_Controller_Event(0,Channel,CtModulationWheel,Modulation);
            //On ajoute le portamentoTime
            Add_Controller_Event(0,Channel,CtPortamentoTime,PortamentoTime);
            //On ajoute le portamentoNote
            Add_Controller_Event(0,Channel,CtPortamentoNote,PortamentoNote);
            //On ajoute le portamentoSwitch
            Add_Controller_Event(0,Channel,CtPortamentoSwitch,PortamentoSwitch);
            //On ajoute la résonance
            Add_Controller_Event(0,Channel,CtSoundTimbre,Resonance);
            //On ajoute le panomamic
            Add_Controller_Event(0,Channel,CtPan,Pan);
            //On ajoute l'expression
            Add_Controller_Event(0,Channel,CtExpression,Expression);
            //Le vibrato
            Add_Controller_Event(0,Channel,CtCelesteLevel,Vibrato);
            //On ajoute le sustain
            Add_Controller_Event(0,Channel,CtHoldpedalSwitch,Sustain);
            //On ajoute le PitchBend
            Add_PitchBend_Event(0,Channel,PitchBend);
            //On change l'instrument
            Add_ProgramChange_Event(0,Channel,Instr);
            //On définit la valeur par défaut de RefTime            
            RefTime:=0;
            //S'il y a des notes
            If NoteCnt.Count>0 Then
            //Pour toutes les notes
            For IndexNote:=0 To (NoteCnt.Count-1) Do
            //Avec la note IndexNote faire
            with NoteCnt.Items[IndexNote] Do
              Begin
                //Si la note est activée alors
                If Actived Then
                  Begin
                    //On ajoute un Note_On avec la vélocité      
                    Add_NoteOn_Event(BeginTime-RefTime,Channel,Note,Velocity);
                    //On ajoute un Note_Off
                    Add_NoteOff_Event(EndTime-BeginTime,Channel,Note,0);
                    //RefTime est définit comme EndTime
                    RefTime:=EndTime;
                  End;               
              End; 
            //On finalise le track
            Finalize_Track;
          End;
        //On crée le fichier Midi
        Create_MidiFile(DestFile);                 
      End;  
    //Finalement
    Finally
      //On libère MidiWriter
      MidiWriter.Free;
    End;
end;

{>>Procédure pour créer un fichier Midi à partir du Piano}
Procedure Piano_To_MidiFile(DestFile:String);
Const
 EqWhole:Array [TDuringOfTime] Of Byte=(0,1,2,3,4,5);
 Metro:Array [TDuringOfTime] Of Byte=(96,48,24,12,6,3);
Var
  MidiWriter:TMidiWriter;
  RefTime:Integer;
  IndexInstr,IndexNote:Cardinal;
  Num,Denom,Rythm,Pulse:Byte;
begin
  MidiWriter:=TMidiWriter.Create(Nil);
  //Avec Pattern_Form faire
  With Piano_Form Do
  //On essaye
  Try
    //Avc MidiWriter faire
    With MidiWriter Do
      Begin
        //On définit le Format Midi comme plusieurs Tracks synchrones
        FormatMidi:=multiple_tracks_synchronous;
        //On définit le nombre de tracks par défaut
        NbTracks:=0;
        //La division est de 96 (valeur standard)
        Division:=96;
        //Si le piano n'est pas vide alors
        If PianoGrid.NoteCnt.Count>0 Then
        //Pour tout les instruments
        For IndexInstr:=0 To 127 Do
          Begin
            //On initialise le track
            Initialize_Track;
            //On définit la valeur par défaut de RefTime
            RefTime:=0;
            //Le nombre de tracks est IndexInstr+1
            NbTracks:=IndexInstr+1;
            //S'il s'agit du premier track alors
            If NbTracks=1 Then
              Begin
                //On ajoute le tempo
                Add_SetTempo_Event(0,Tempo_GgBr.Pos);
                //Avec DuringTime
                With DuringTime Do
                  Begin
                    //On définit le numérateur
                    Num:=Time;
                    //On définit le dénominateur
                    Denom:=EqWhole[DuringOfTime];
                    //On définit le rythme
                    Rythm:=Metro[DuringOfTime];
                    //On définit la pulsation
                    Pulse:=8;
                  End;
                //On ajoute la signature du temps
                Add_TimeSignature_Event(0,Num,Denom,Rythm,Pulse);
              End;
            //Pour toutes les notes faire
            For IndexNote:=0 To (PianoGrid.NoteCnt.Count-1) Do
              Begin
                //Avec la note IndexNote faire
                With PianoGrid.NoteCnt.Items[IndexNote] Do
                  Begin
                    //Si l'instrument est différent de IndexInstr on saute cette étape
                    If Instr<>IndexInstr Then Continue;
                    //On ajoute un Note_On avec la vélocité
                    Add_NoteOn_Event(BeginTime-RefTime,Channel,Note,Velocity);
                    //On ajoute le volume
                    Add_Controller_Event(0,Channel,CtMainVolume,Volume);
                    //On ajoute la modulation
                    Add_Controller_Event(0,Channel,CtModulationWheel,Modulation);
                    //On ajoute le portamentoTime
                    Add_Controller_Event(0,Channel,CtPortamentoTime,PortamentoTime);
                    //On ajoute le portamentoNote
                    Add_Controller_Event(0,Channel,CtPortamentoNote,PortamentoNote);
                    //On ajoute le portamentoSwitch
                    Add_Controller_Event(0,Channel,CtPortamentoSwitch,PortamentoSwitch);
                    //On ajoute la résonance
                    Add_Controller_Event(0,Channel,CtSoundTimbre,Resonance);
                    //On ajoute le panomamic
                    Add_Controller_Event(0,Channel,CtPan,Pan);
                    //On ajoute l'expression
                    Add_Controller_Event(0,Channel,CtExpression,Expression);
                    //Le vibrato
                    Add_Controller_Event(0,Channel,CtCelesteLevel,Vibrato);
                    //On ajoute le sustain
                    Add_Controller_Event(0,Channel,CtHoldpedalSwitch,Sustain);
                    //On ajoute le PitchBend
                    Add_PitchBend_Event(0,Channel,PitchBend);
                    //On change l'instrument
                    Add_ProgramChange_Event(0,Channel,Instr);
                    //On ajoute un Note_Off
                    Add_NoteOff_Event(EndTime-BeginTime,Channel,Note,0);
                  End;
                //RefTime est définit comme EndTime
                RefTime:=PianoGrid.NoteCnt.Items[IndexNote].EndTime;
              End;
            //On finalise le track
            Finalize_Track;
          End;
        //On crée le fichier Midi
        Create_MidiFile(DestFile);
      End;  
  //Finalement
  Finally
    //On libère MidiWriter
    MidiWriter.Free;
  End;
End;

end.
