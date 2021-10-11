unit UParams;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, URLMon,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, bassasio, Bass, MidiCom, MMSystem,
  XiTrackBar,MixPanel;

type
  TParams_Form = class(TForm)
    DesignBorder_Pn: TPanel;
    Audio_Img: TImage;
    Record_Img: TImage;
    Files_Img: TImage;
    Plugins_Img: TImage;
    Midi_Img: TImage;
    PageControl: TPageControl;
    Audio_TbSh: TTabSheet;
    Record_TbSh: TTabSheet;
    MIDI_TbSh: TTabSheet;
    Plugins_TbSh: TTabSheet;
    Files_TbSh: TTabSheet;
    Audio_Pn: TPanel;
    Midi_Pn: TPanel;
    Record_Pn: TPanel;
    Plugins_Pn: TPanel;
    Files_Pn: TPanel;
    Audios_Listing_GpBx: TGroupBox;
    Audio_Drivers_Lb: TLabel;
    Audio_Drivers_LsBx: TListBox;
    Search_Audio_Drivers_Bt: TSpeedButton;
    Audio_Params_GpBx: TGroupBox;
    Capabilities_Audio_Lb: TLabel;
    Capabilities_Audio_LsBx: TListBox;
    Memory_Lb: TLabel;
    Memory_Ed: TEdit;
    Free_Memory_Lb: TLabel;
    Free_Memory_Ed: TEdit;
    Free_Slots_Lb: TLabel;
    Free_Slots_Ed: TEdit;
    Free_3DSlots_Lb: TLabel;
    Free_3DSlots_Ed: TEdit;
    Minimal_Rate_Lb: TLabel;
    Minimal_Rate_Ed: TEdit;
    Maximal_Rate_Lb: TLabel;
    Maximal_Rate_Ed: TEdit;
    EAX_Supported_Lb: TLabel;
    EAX_Supported_LsBx: TListBox;
    Minimal_Buffer_Lb: TLabel;
    Minimal_Buffer_Ed: TEdit;
    DirectSound_Lb: TLabel;
    DirectSound_Ed: TEdit;
    Nb_Speakers_Lb: TLabel;
    Nb_Speakers_Ed: TEdit;
    File_Driver_Audio_Lb: TLabel;
    File_Driver_Audio_Ed: TEdit;
    Frequency_Audio_Lb: TLabel;
    Frequency_Audio_Ed: TEdit;
    Records_GpBx: TGroupBox;
    Record_Drivers_Lb: TLabel;
    Search_Record_Drivers_Bt: TSpeedButton;
    Record_Drivers_LsBx: TListBox;
    Record_Params_GpBx: TGroupBox;
    Capabilities_Record_Lb: TLabel;
    Format_Lb: TLabel;
    Record_Inputs_Lb: TLabel;
    Enter_Synchronzie_Lb: TLabel;
    File_Driver_Record_Lb: TLabel;
    Frequency_Record_Lb: TLabel;
    Capabilities_Record_LsBx: TListBox;
    Enter_Synchronzie_LsBx: TListBox;
    Record_Inputs_Ed: TEdit;
    Current_Freq_Record_Ed: TEdit;
    File_Driver_Record_Ed: TEdit;
    Format_LsBx: TListBox;
    Soundfonts_Listing_GpBx: TGroupBox;
    Soundfonts_Listing_Lb: TLabel;
    Select_Soundfont_Bt: TSpeedButton;
    Soundfonts_Listing_LsBx: TListBox;
    Input_Midi_GpBx: TGroupBox;
    Midi_Input_Drivers_Lb: TLabel;
    Search_Midi_Input_Drivers_Bt: TSpeedButton;
    Midi_Input_Drivers_LsBx: TListBox;
    Search_SoundFont_Bt: TSpeedButton;
    Asios_Listing_GpBx: TGroupBox;
    Asios_Listing_Lb: TLabel;
    Asios_Listing_LsBx: TListBox;
    Search_Asios_Drivers_Bt: TSpeedButton;
    File_Driver_Asio_Ed: TEdit;
    Inputs_Asio_Ed: TEdit;
    Outputs_Asio_Ed: TEdit;
    Min_Buffer_Asio_Ed: TEdit;
    Max_Buffer_Asio_Ed: TEdit;
    Default_Buffer_Asio_Ed: TEdit;
    Default_Buffer_Asio_Lb: TLabel;
    Max_Buffer_Asio_Lb: TLabel;
    Min_Buffer_Asio_Lb: TLabel;
    Outputs_Asio_Lb: TLabel;
    Inputs_Asio_Lb: TLabel;
    File_Driver_Asio_Lb: TLabel;
    Used_Frequency_Asio_Lb: TLabel;
    Used_Frequency_Asio_LsBx: TListBox;
    Channels_Asio_Lb: TLabel;
    Channels_Asio_LsBx: TListBox;
    Volume_Asio_Lb: TLabel;
    Volume_Asio_TkBr: TXiTrackBar;
    Vsts_Listing_GpBx: TGroupBox;
    Vst_Listing_LsBx: TListBox;
    Search_Vst_Bt: TSpeedButton;
    Active_Asio_Bt: TSpeedButton;
    Vst_Listing_CkBx: TCheckBox;
    Select_Vst_Bt: TSpeedButton;
    Wav_Params_GpBx: TGroupBox;
    NbChannel_Lb: TLabel;
    Sample_Freq_Lb: TLabel;
    BitsPerSample_Lb: TLabel;
    BytePerBloc_Lb: TLabel;
    BytePerSec_Lb: TLabel;
    NbChannel_LsBx: TListBox;
    Sample_Freq_LsBx: TListBox;
    BitsPerSample_LsBx: TListBox;
    Mp3_Params_GpBx: TGroupBox;
    MP3_Freq_Lb: TLabel;
    BitRate_Lb: TLabel;
    MaxBitRate_Lb: TLabel;
    Mode_Lb: TLabel;
    Quality_Lb: TLabel;
    VBR_Quality_Lb: TLabel;
    MP3_Freq_LsBx: TListBox;
    BitRate_LsBx: TListBox;
    MaxBitRate_LsBx: TListBox;
    Quality_LsBx: TListBox;
    Mode_LsBx: TListBox;
    VBR_CkBx: TCheckBox;
    Header_VBR_CkBx: TCheckBox;
    VBT_TkBr: TXiTrackBar;
    Midi_Input_Mid_Lb: TLabel;
    Midi_Input_Pid_Lb: TLabel;
    Midi_Input_OldVers_Lb: TLabel;
    Midi_Input_NewVers_Lb: TLabel;
    Midi_Input_Pid_Ed: TEdit;
    Midi_Input_OldVers_Ed: TEdit;
    Midi_Input_NewVers_Ed: TEdit;
    Midi_Input_Mid_Ed: TEdit;
    Output_Midi_GpBx: TGroupBox;
    Midi_Output_Drivers_Lb: TLabel;
    Search_Midi_Output_Drivers_Bt: TSpeedButton;
    Midi_Output_Mid_Lb: TLabel;
    Midi_Output_Pid_Lb: TLabel;
    Midi_Output_OldVers_Lb: TLabel;
    Midi_Output_NewVers_Lb: TLabel;
    Midi_Output_Drivers_LsBx: TListBox;
    Midi_Output_Pid_Ed: TEdit;
    Midi_Output_OldVers_Ed: TEdit;
    Midi_Output_NewVers_Ed: TEdit;
    Midi_Output_Mid_Ed: TEdit;
    Midi_Output_Technology_Lb: TLabel;
    Midi_Output_Technology_Ed: TEdit;
    Midi_Output_Voices_Ed: TEdit;
    Midi_Output_Notes_Ed: TEdit;
    Midi_Output_Mask_Ed: TEdit;
    Midi_Output_Mask_Lb: TLabel;
    Midi_Output_Notes_Lb: TLabel;
    Midi_Output_Voices_Lb: TLabel;
    Desactive_Asio_Bt: TSpeedButton;
    BytePerBloc_Ed: TEdit;
    BytePerSec_Ed: TEdit;
    Procedure Set_BytePerBloc;
    Procedure Set_BytePerSec;    
    procedure Audio_ImgClick(Sender: TObject);
    procedure Record_ImgClick(Sender: TObject);
    procedure Midi_ImgClick(Sender: TObject);
    procedure Plugins_ImgClick(Sender: TObject);
    procedure Files_ImgClick(Sender: TObject);
    procedure Search_Audio_Drivers_BtClick(Sender: TObject);
    procedure Audio_Drivers_LsBxClick(Sender: TObject);
    procedure Search_Record_Drivers_BtClick(Sender: TObject);
    procedure Record_Drivers_LsBxClick(Sender: TObject);
    procedure Search_Midi_Input_Drivers_BtClick(Sender: TObject);
    procedure Midi_Input_Drivers_LsBxClick(Sender: TObject);
    procedure Search_Midi_Output_Drivers_BtClick(Sender: TObject);
    procedure Midi_Output_Drivers_LsBxClick(Sender: TObject);
    procedure Search_SoundFont_BtClick(Sender: TObject);
    procedure Search_Vst_BtClick(Sender: TObject);
    procedure NbChannel_LsBxClick(Sender: TObject);
    procedure Sample_Freq_LsBxClick(Sender: TObject);
    procedure BitsPerSample_LsBxClick(Sender: TObject);
    procedure Search_Asios_Drivers_BtClick(Sender: TObject);
    procedure Asios_Listing_LsBxClick(Sender: TObject);
    procedure Active_Asio_BtClick(Sender: TObject);
    procedure Used_Frequency_Asio_LsBxClick(Sender: TObject);
    procedure Volume_Asio_TkBrChange(Sender: TObject);
    procedure Channels_Asio_LsBxClick(Sender: TObject);
    procedure Desactive_Asio_BtClick(Sender: TObject);
    procedure Select_Soundfont_BtClick(Sender: TObject);
    procedure Select_Vst_BtClick(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Params_Form: TParams_Form;

implementation

Uses UFiles, UAsio, UGnBass, UMix, UPatternMd, UPianoMd;

{$R *.dfm}

{>>Affichage des TabSheets}
procedure TParams_Form.Audio_ImgClick(Sender: TObject);
begin
  Audio_TbSh.Show;
end;

procedure TParams_Form.Record_ImgClick(Sender: TObject);
begin
  Record_TbSh.Show;
end;

procedure TParams_Form.Midi_ImgClick(Sender: TObject);
begin
  Midi_TbSh.Show;
end;

procedure TParams_Form.Plugins_ImgClick(Sender: TObject);
begin
  Plugins_TbSh.Show;
end;

procedure TParams_Form.Files_ImgClick(Sender: TObject);
begin
  Files_TbSh.Show;
end;


///////////
///AUDIO///
///////////

{>>Proc�dure pour lister les devices audio}
procedure TParams_Form.Search_Audio_Drivers_BtClick(Sender: TObject);
Var
  CountAudio:Integer;
  Info_Device:BASS_DEVICEINFO;
begin
  //On initialise CountAudioDevice
  CountAudio:=1;
  //Tant que la recherche d'un driver aboutit faire
  while BASS_GetDeviceInfo(CountAudio,Info_Device) do
  begin
    //On ajoute dans Audio_Drivers_LsBx la description du device
    Audio_Drivers_LsBx.Items.Add(Info_Device.Name);
    //On incr�mente CountAudio
    Inc(CountAudio);
  end;
end;

{>>S�lection du Device Audio}
procedure TParams_Form.Audio_Drivers_LsBxClick(Sender: TObject);
Var
  InfoDevice:BASS_INFO;
  Info_Device:BASS_DEVICEINFO;
begin
  //Si une carte son est s�lectionn�e alors
  If Audio_Drivers_LsBx.ItemIndex>=0 Then
    Begin
      //Si on ne peut pas initialiser Bass ou l'enregistrement  on sort
      If (Not Init_RecordBass) Then Exit;
      //On s�lectionne le Device (Carte son)
      BASS_SetDevice(Audio_Drivers_LsBx.ItemIndex+1);
      //Si on a pu r�cup�rer les infos du device alors
      If BASS_GetInfo(InfoDevice) Then
      //Avec InfoDevice faire
      With InfoDevice Do
        Begin
          //On d�finit le device a utiliser
          BASS_RecordSetDevice(Audio_Drivers_LsBx.ItemIndex);
          //On affiche ses capacit�s
          Capabilities_Audio_LsBx.ItemIndex:=flags;
          //On affiche la m�moire
          Memory_Ed.Text:=IntToStr(hwsize);
          //On affiche la m�moire libre
          Free_Memory_Ed.Text:=IntToStr(hwfree);
          //On affiche le nombre de slots libres
          Free_Slots_Ed.Text:=IntToStr(freesam);
          //On affiche le nombre de slots 3D libres
          Free_3DSlots_Ed.Text:=IntToStr(free3d);
          //On affiche le taux minimal
          Minimal_Rate_Ed.Text:=IntToStr(minrate);
          //On affiche le taux maximal
          Maximal_Rate_Ed.Text:=IntToStr(maxrate);
          //On affiche sa capacit� � supporter l'EAX
          EAX_Supported_LsBx.ItemIndex:=ord(eax);
          //On affiche le tampon minimal
          Minimal_Buffer_Ed.Text:=IntToStr(minbuf);
          //On affiche la version de Direct Sound
          DirectSound_Ed.Text:=IntToStr(dsver);
          //On affiche le nombre d'�couteurs
          Nb_Speakers_Ed.Text:=IntToStr(speakers);
          //Si on peut r�cup�rer les infos du driver
          If BASS_GetDeviceInfo(Audio_Drivers_LsBx.ItemIndex,Info_Device) Then
          //On affiche le nom du pilote
          File_Driver_Audio_Ed.Text:=ExtractFileName(Info_Device.driver);
          //On affiche la fr�quence courante
          Frequency_Audio_Ed.Text:=IntToStr(freq);
        End;
    End;
end;


////////////
///RECORD///
////////////

{>>Proc�dure pour r�cup�rer l'ensemble des devices pour l'enregistrement}
procedure TParams_Form.Search_Record_Drivers_BtClick(Sender: TObject);
Var
  CountRecord: Integer;
  TypeDevice: PChar;
begin
  //Si l'enregistrement n'a pas �t� initialis� on sort
  If (Audio_Drivers_LsBx.ItemIndex<0 ) Then Exit;
  //On efface Type_Device_LsBx
  Record_Drivers_LsBx.Clear;
  //Initialisation de Count
  CountRecord:=0;
  //Initialisation de TypeDevice
  TypeDevice:=BASS_RecordGetInputName(CountRecord);
  //Tante que TypeDevice est diff�rent de Nil faire
  While TypeDevice<>Nil Do
    Begin
      //On ajoute TypeDevice dans Record_Drivers_LsBx
      Record_Drivers_LsBx.Items.Add(StrPas(TypeDevice));
      //On incr�mente CountRecord
      Inc(CountRecord);
      //On r�cup�re le prochain TypeDevice
      TypeDevice:=BASS_RecordGetInputName(CountRecord);
    End;
end;

{>>Proc�dure pour s�lectionner un device d'enregistrement et r�cup�rer ces infos}
procedure TParams_Form.Record_Drivers_LsBxClick(Sender: TObject);
Var
  RecordInfos:BASS_RECORDINFO;
  Info_Device:BASS_DEVICEINFO;  
begin
  //Si un device est s�lectionn� ainsi qu'une entr�e alors
  If (Audio_Drivers_LsBx.ItemIndex>=0 ) And (Record_Drivers_LsBx.ItemIndex>=0) Then
    Begin
      //On ajuste l'entr�e � utiliser
      BASS_RecordSetInput(Record_Drivers_LsBx.ItemIndex, BASS_INPUT_ON,-1);
      //On r�cup�re les infos du device
      BASS_RecordGetInfo(RecordInfos);
      //S'il n'y a pas d'erreurs alors
      If BASS_ErrorGetCode=0 Then
      //Avec RecordInfos faire
      With RecordInfos Do
        Begin
          //On d�finit les capacit�s du device
          Capabilities_Record_LsBx.ItemIndex:=flags;
          //On d�finit son format
          Format_LsBx.ItemIndex:=formats;
          //On d�finit son nombre d'entr�es
          Record_Inputs_Ed.Text:=IntToStr(inputs);
          //On pr�cise le caract�re synchrone entr�es/sorties
          Enter_Synchronzie_LsBx.ItemIndex:=Ord(singlein);
          //On r�cup�re sa fr�quence courante
          Current_Freq_Record_Ed.Text:=IntToStr(freq);   
          //Si on peut r�cup�rer les infos du driver
          If BASS_RecordGetDeviceInfo(Record_Drivers_LsBx.ItemIndex,Info_Device) Then
          //On d�finit le nom du pilote
          File_Driver_Record_Ed.Text:=ExtractFileName(Info_Device.driver);
        End;
    End;
end;


//////////
///MIDI///
//////////

{>>Proc�dure pour lister les entr�es Midi}
procedure TParams_Form.Search_Midi_Input_Drivers_BtClick(Sender: TObject);
Var
  MidiCom:TMidiCom;
begin
  //On cr�e le compo
  MidiCom:=TMidiCom.Create(Self);
  //On liste les entr�es Midi
  MidiCom.MidiIn_List(Midi_Input_Drivers_LsBx.Items);
  //On lib�re le compo
  MidiCom.Free;
end;

{>>Proc�dure pour r�cup�rer les infos d'une entr�e Midi}
procedure TParams_Form.Midi_Input_Drivers_LsBxClick(Sender: TObject);
Var
  MidiCom:TMidiCom;
begin
  //Si unee entr�e est s�lectionn�e alors
  If Midi_Input_Drivers_LsBx.ItemIndex>=0 Then
    Begin
      //On cr�e le compo
      MidiCom:=TMidiCom.Create(Self);
      //Avec MidiCom faire
      With MidiCom Do
        Begin
          //On r�cup�re les infos du device
          MidiIn_Info(Midi_Input_Drivers_LsBx.ItemIndex);
          //On d�finit le MID
          Midi_Input_Mid_Ed.Text:=IntToStr(Midi_MID);
          //On d�finit le PID
          Midi_Input_Pid_Ed.Text:=IntToStr(Midi_PID);
          //On d�finit l'ancienne version
          Midi_Input_OldVers_Ed.Text:=IntToStr(Midi_MinorVersion);
          //On d�finit la nouvelle version
          Midi_Input_NewVers_Ed.Text:=IntToStr(Midi_MajorVersion);
          //On lib�re le MidiCom
          Free;
        End;
    End;
end;

{>>Proc�dure pour lister les sorties Midi}
procedure TParams_Form.Search_Midi_Output_Drivers_BtClick(Sender: TObject);
Var
  MidiCom:TMidiCom;
begin
  //On cr�e le compo
  MidiCom:=TMidiCom.Create(Self);
  //On liste les sorties Midi
  MidiCom.MidiOut_List(Midi_Output_Drivers_LsBx.Items);
  //On lib�re le compo
  MidiCom.Free;
end;

{>>Proc�dure pour r�cup�rer les infos d'une sortie Midi}
procedure TParams_Form.Midi_Output_Drivers_LsBxClick(Sender: TObject);
Var
  MidiCom:TMidiCom;
begin
  //Si une sortie est s�lectionn�e alors
  If Midi_Output_Drivers_LsBx.ItemIndex>=0 Then
    Begin
      //On cr�e le compo
      MidiCom:=TMidiCom.Create(Self);
      //Avec MidiCom faire
      With MidiCom Do
        Begin
          //On r�cup�re les infos du device
          MidiOut_Info(Midi_Output_Drivers_LsBx.ItemIndex);
          //On d�finit le MID
          Midi_Output_Mid_Ed.Text:=IntToStr(Midi_MID);
          //On d�finit le PID
          Midi_Output_Pid_Ed.Text:=IntToStr(Midi_PID);
          //On d�finit l'ancienne version
          Midi_Output_OldVers_Ed.Text:=IntToStr(Midi_MinorVersion);
          //On d�finit la nouvelle version
          Midi_Output_NewVers_Ed.Text:=IntToStr(Midi_MajorVersion);
          //On d�finit la technologie
          Midi_Output_Technology_Ed.Text:=Midi_Technology;
          //On d�finit le nombre de voix
          Midi_Output_Voices_Ed.Text:=IntToStr(Midi_Voices);
          //On d�finit le nombre de notes
          Midi_Output_Notes_Ed.Text:=IntToStr(Midi_Notes);
          //On d�finit le masque
          Midi_Output_Mask_Ed.Text:=IntToStr(Midi_ChannelMask);
          //On lib�re le MidiCom
          Free;
        End;
    End;
end;


/////////////
///PLUGINS///
/////////////

{>>Proc�dure pour lister des fichiers}
procedure TParams_Form.Search_SoundFont_BtClick(Sender: TObject);
Var
  SoundFontFolder:String;
begin
  //On d�finit le r�pertoire SoundFontFolder
  SoundFontFolder:=ExtractFileDir(Paramstr(0))+'\Plugins\SoundFont';
  //On liste les SoundFont de ce r�pertoire pour les placer dans Soundfonts_Listing_LsBx
  List_Type_File(SoundFontFolder,'*.SF2',Soundfonts_Listing_LsBx);
end;

{>>Proc�dure pour ajouter les SoundFonts}
procedure TParams_Form.Select_Soundfont_BtClick(Sender: TObject);
Var
  IndexItem:Integer;
begin
  //S'il y a des soundfonts alors
  If Soundfonts_Listing_LsBx.Count>0 Then
  //Pour toutes les soundfonts faire
  For IndexItem:=0 To (Soundfonts_Listing_LsBx.Count-1) Do
  //Si la soundfont IndexItem est s�lectionn�e
  If Soundfonts_Listing_LsBx.Selected[IndexItem] Then
    Begin
      //On l'ajoute dans MixPanel.SoundFont
      Mix_Form.MixPanel.SoundFont.Items.Add(Soundfonts_Listing_LsBx.Items.Strings[IndexItem]);
      //Avec la SoundFont qu'on ajoute dans BrowserMidi faire
      With Pattern_Form.BrowserMidi.SoundFont.Add Do
        Begin
          //D�finir le nom du fichier
          FileName:=Soundfonts_Listing_LsBx.Items.Strings[IndexItem];
          //D�finir le nom qui apparait
          Name:=ExtractFileName(FileName);
        End;
      //Avec la SoundFont qu'on ajoute dans BrowserMidi faire
      With Piano_Form.BrowserMidi.SoundFont.Add Do
        Begin
          //D�finir le nom du fichier
          FileName:=Soundfonts_Listing_LsBx.Items.Strings[IndexItem];
          //D�finir le nom qui apparait
          Name:=ExtractFileName(FileName);
        End;
    End;
end;

{>>Proc�dure lister les devices Asio}
procedure TParams_Form.Search_Asios_Drivers_BtClick(Sender: TObject);
Var
  CountAsio:Integer;
  AsioDeviceInfo:BASS_ASIO_DEVICEINFO;
begin
  //On efface Asios_Listing_LsBx
  Asios_Listing_LsBx.Clear;
  //On initialise CountAsio:Integer
  CountAsio:=0;
  //On r�p�te
  Repeat
    //On r�cup�re les infos du device dans AsioDeviceInfo
    BASS_ASIO_GetDeviceInfo(CountAsio,AsioDeviceInfo);
    //S'il n'y a pas eur d'erreur alors
    If BASS_ErrorGetCode<>BASS_ERROR_DEVICE Then
    //On ajoute DeviceName dans Asios_Listing_LsBx
    Asios_Listing_LsBx.Items.Add(AsioDeviceInfo.name);
    //On incr�mente AsioCount
    Inc(CountAsio);
  //Tant qu'on a pas rencontr� une erreur
  Until BASS_ErrorGetCode<>BASS_ERROR_DEVICE;
end;

{>>Proc�dure pour s�lectionner un device Asio et r�cup�rer ces infos}
procedure TParams_Form.Asios_Listing_LsBxClick(Sender: TObject);
Var
  AsioInfo:BASS_ASIO_INFO;
  AsioDeviceInfo:BASS_ASIO_DEVICEINFO;  
begin
  //Si un device asio est s�lectionn� alors
  If Asios_Listing_LsBx.ItemIndex>=0 Then
    Begin
      //Si on ne peut pas initialiser l'asio et activer le driver alors on sort
      If (Not Init_AsioBass) Or (Not BASS_ASIO_SetDevice(Asios_Listing_LsBx.ItemIndex)) Then Exit;
      //On r�cup�re les infos du device dans AsioDeviceInfo
      BASS_ASIO_GetDeviceInfo(Asios_Listing_LsBx.ItemIndex,AsioDeviceInfo);
      //On r�cup�re le pilote
      File_Driver_Asio_Ed.Text:=ExtractFileName(AsioDeviceInfo.driver);
      //On r�cup�re les infos du device dans AsioInfo
      BASS_ASIO_GetInfo(AsioInfo);
      //Avec AsioInfo faire
      With AsioInfo Do
        Begin
          //On r�cup�re le nombre d'entr�es
          Inputs_Asio_Ed.Text:=IntToStr(inputs);
          //On r�cup�re le nombre de sorties
          Outputs_Asio_Ed.Text:=IntToStr(outputs);
          //On r�cup�re le buffer minimal
          Min_Buffer_Asio_Ed.Text:=IntToStr(bufmin);
          //On r�cup�re le buffer maximal
          Max_Buffer_Asio_Ed.Text:=IntToStr(bufmax);
          //On r�cup�re le buffer par d�faut
          Default_Buffer_Asio_Ed.Text:=IntToStr(bufpref);
          //On lib�re l'asio
          Free_AsioBass ;
        End;
    End;        
end;

{>>Procedure pour activer l'Asio}
procedure TParams_Form.Active_Asio_BtClick(Sender: TObject);
begin
  //Si un device asio est s�lectionn� et qu'on peut activer l'asio alors
  If (Asios_Listing_LsBx.ItemIndex>=0) And (Init_AsioBass) Then
    Begin
      //On active le driver Asio
      BASS_ASIO_SetDevice(Asios_Listing_LsBx.ItemIndex);
      //Si on peut activer l'asio en entr�e et
      If (Active_Asio(StrToInt(Inputs_Asio_Ed.Text),True)) And
      //Si on peut activer l'asio en sortie alors
      Active_Asio(StrToInt(Outputs_Asio_Ed.Text),False) Then
        Begin
          //On modifie la fr�quence de l'asio
          Used_Frequency_Asio_LsBx.OnClick(Sender);
          //On modifie le volume
          Volume_Asio_TkBr.OnChange(Sender);
          //On modifie le nombre de canaux de l'asio
          Channels_Asio_LsBx.OnClick(Sender);
          //On d�sactive Active_Asio_Bt
          Active_Asio_Bt.Enabled:=False;
          //On active Desactive_Asio_Bt
          Desactive_Asio_Bt.Enabled:=True;
        End;
    End;
end;

{>>Procedure pour modifier la fr�quence de l'asio}
procedure TParams_Form.Used_Frequency_Asio_LsBxClick(Sender: TObject);
begin
  //Si une fr�quence est s�lectionn�e alors
  If Used_Frequency_Asio_LsBx.ItemIndex>=0 Then
  //Avec Used_Frequency_Asio_LsBx faire
  With Used_Frequency_Asio_LsBx Do
    Begin
      //On modifie la fr�quence dans les entr�es
      Set_AsioFreq(StrToInt(Inputs_Asio_Ed.Text),StrToInt(Items[ItemIndex]),True);
      //On modifie la fr�quence dans les sortie
      Set_AsioFreq(StrToInt(Outputs_Asio_Ed.Text),StrToInt(Items[ItemIndex]),False);
    End;
end;

{>>Procedure pour modifier le volume de l'asio}
procedure TParams_Form.Volume_Asio_TkBrChange(Sender: TObject);
begin
  //Avec Used_Frequency_Asio_LsBx faire
  With Volume_Asio_TkBr Do
  //On modifie le volume dans les sortie
  Set_AsioVol(StrToInt(Outputs_Asio_Ed.Text),Position,False);
end;

{>>Procedure pour modifier le nombre de canaux de l'asio}
procedure TParams_Form.Channels_Asio_LsBxClick(Sender: TObject);
begin
  //Si un canal est s�lectionn� alors
  If Channels_Asio_LsBx.ItemIndex>=0 Then
  //Avec Channels_Asio_LsBx faire
  With Channels_Asio_LsBx Do
    Begin
      //On modifie le nombre de canaux d'entr�es
      Set_AsioNbChannels(StrToInt(Inputs_Asio_Ed.Text),ItemIndex,True);
      //On modifie le nombre de canaux de sorties
      Set_AsioNbChannels(StrToInt(Outputs_Asio_Ed.Text),ItemIndex,False);
    End;  
end;

procedure TParams_Form.Desactive_Asio_BtClick(Sender: TObject);
begin
  //Si on peut d�sactiver les entr�es et
  If Desactive_Asio(StrToInt(Inputs_Asio_Ed.Text),True) And
  //Si on peut d�sactiver les sorties alors  
  Desactive_Asio(StrToInt(Outputs_Asio_Ed.Text),False) Then
    Begin
      //On libere l'asio
      Free_AsioBass;
      //On d�sactive Active_Asio_Bt
      Active_Asio_Bt.Enabled:=True;
      //On active Desactive_Asio_Bt
      Desactive_Asio_Bt.Enabled:=False;
    End;
end;

{>>Recherche des VST}
procedure TParams_Form.Search_Vst_BtClick(Sender: TObject);
Var
  VSTFolder:String;
begin
  //Si on a check� Vst_Listing_CkBx alors
  If Vst_Listing_CkBx.Checked Then
  //On d�finit le r�pertoire VSTFolder comme celui des VSTI
  VSTFolder:=ExtractFileDir(Paramstr(0))+'\Plugins\VSTI'
  //Sinon on d�finit le r�pertoire VSTFolder comme celui des VSTE
  Else VSTFolder:=ExtractFileDir(Paramstr(0))+'\Plugins\VSTE';
  //On liste les VST de ce r�pertoire pour les placer dans Vst_Listing_LsBx
  List_Type_File(VSTFolder,'*.dll',Vst_Listing_LsBx);
end;

{>>Proc�dure pour ajouter les VST}


procedure TParams_Form.Select_Vst_BtClick(Sender: TObject);
Var
  IndexItem:Integer;
  ListEffect:TListEffect;
begin
  //S'il y a des VST alors
  If Vst_Listing_LsBx.Count>0 Then
  //Pour tout les VST faire
  For IndexItem:=0 To (Vst_Listing_LsBx.Count-1) Do
  Begin
  //Si le VST IndexItem est s�lectionn�
  If Vst_Listing_LsBx.Selected[IndexItem] Then
    Begin
      //Si on a s�lectionn� le type VSTI alors ListEffect est Mix_Form.MixPanel.VSTI
      If Vst_Listing_CkBx.Checked Then ListEffect:=Mix_Form.MixPanel.VSTI
      //Sinon Mix_Form.MixPanel.VSTE
      Else ListEffect:=Mix_Form.MixPanel.VSTE;
      //On l'ajoute dans ListEffect
      ListEffect.Items.Add(Vst_Listing_LsBx.Items.Strings[IndexItem]);
    End;
  End;
end;

//////////////
///FICHIERS///
//////////////

{>> Calcul du Bytes Per Bloc}
Procedure TParams_Form.Set_BytePerBloc;
Var
 BPS,BPB:Integer;
begin
  //Si aucun Bits Par Sample ou Channel est s�lectionn� on sort
  If (BitsPerSample_LsBx.ItemIndex<0) Or (NbChannel_LsBx.ItemIndex<0) Then Exit;
  //On d�finit BPS (Bits Par Sample)
  BPS:=StrToInt(BitsPerSample_LsBx.Items[BitsPerSample_LsBx.ItemIndex]);
  //On calcule BPB  (Bytes Par Bloc)
  BPB:=BPS*(NbChannel_LsBx.ItemIndex+1) Div 8;
  //On ajoute le BPB dans BytePerBloc_Mm
  BytePerBloc_Ed.Text:=IntToStr(BPB);
  //On lance Set_BytePerSec
  Set_BytePerSec;
end;

{>> Calcul du Bytes Per Seconde  }
Procedure TParams_Form.Set_BytePerSec;
Var
 BPS,BPB,Freq:Cardinal;
begin
  //Si aucun Bytes par Bloc ou fr�quence est s�lectionn� on sort
  If (Sample_Freq_LsBx.ItemIndex<0) Or (BytePerBloc_Ed.Text='') Then Exit;
  //On d�finit BPB (Bytes Par Bloc)
  BPB:=StrToInt(BytePerBloc_Ed.Text);
  //On d�finit Freq
  Freq:=StrToInt(Sample_Freq_LsBx.Items[Sample_Freq_LsBx.ItemIndex]);
  //On calcul BPB (Bytes Par Seconde )
  BPS:=Freq*BPB;
  //On ajoute BPS dans BytePerSec_Mm
  BytePerSec_Ed.Text:=IntToStr(BPS);
end;

{>> Gestion du caract�re mono/st�r�o}
procedure TParams_Form.NbChannel_LsBxClick(Sender: TObject);
begin
  Set_BytePerBloc;
end;

{>> Gestion de la fr�quence}
procedure TParams_Form.Sample_Freq_LsBxClick(Sender: TObject);
begin
  Set_BytePerSec;
end;

{>>Proc�dure li�e au click de Wav_BitsPerSample_Ls}
procedure TParams_Form.BitsPerSample_LsBxClick(Sender: TObject);
begin
  Set_BytePerBloc;
end;

end.
