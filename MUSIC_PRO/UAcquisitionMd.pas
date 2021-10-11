unit UAcquisitionMd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, MidiCom, MMTimer, PianoGrid;

type
  TAcquisition_Md_Form = class(TForm)
    Midi_Msg_Mm: TMemo;
    Title_Lb: TLabel;
  private
    { Déclarations privées }
  public
    Procedure Start_Acquisition;
    procedure ReceiveData(const Status, Data1, Data2: Byte; Const Time:Cardinal);
    Procedure Parse_To_Memo(Status,Data1,Data2: Byte);
    Procedure Parse_To_Piano(Status,Data1,Data2: Byte; Const Time:Cardinal);
    Procedure Stop_Acquisition;     
  end;


var
  Acquisition_Md_Form: TAcquisition_Md_Form;
  MdCom:TMidiCom;

implementation

uses UParams, UPianoMd;


{$R *.dfm}

Procedure TAcquisition_Md_Form.Start_Acquisition;
Begin
  //On vide le mémo
  Midi_Msg_Mm.Clear;
  //Avec Params_Form faire
  With Params_Form Do
  //Si une entrée midi est sélectionnée alors
  If Midi_Input_Drivers_LsBx.ItemIndex>-1 Then
    Begin
      //On crée MdCom
      MdCom:=TMidiCom.Create(Self);
      //Avec MdCom faire
      With MdCom Do
        Begin
          //On ouvre l'entrée
          Open_MidiIn(Midi_Input_Drivers_LsBx.ItemIndex);
          //On définit la procédure de réception des données
          OnMidiInReceiveData:=ReceiveData;
        End;
    End;
End;

procedure TAcquisition_Md_Form.ReceiveData(const Status, Data1, Data2: Byte;  Const Time:Cardinal);
Begin
  //On parse le message midi dans le mémo
  Parse_To_Memo(Status,Data1,Data2);
  //On parse le message midi dans le piano
  Parse_To_Piano(Status,Data1,Data2, Time);
End;

Procedure TAcquisition_Md_Form.Parse_To_Memo(Status,Data1,Data2: Byte);
Const
  Event:Array[0..7] Of String=('Note_Off','Note_On','Controle','Instrument','After_Touch',
                               'Pitch_Bend','Tempo','Time_Signature');
Var
  Info:String;
Begin
  //Suivant la valeur du Status on définit Info
  Case Status Of
    128..143 : Info:=format('Action:%s - Channel:%d - Note:%d - Vélocité:%d',[Event[0], Status-128,Data1,Data2]);
    144..159 : Info:=format('Action:%s - Channel:%d - Note:%d - Vélocité:%d',[Event[1], Status-144,Data1,Data2]);
    176..191 : Info:=format('Action:%s - Channel:%d - Controle:%d - Valeur:%d',[Event[2], Status-176,Data1,Data2]);
    192..207 : Info:=format('Action:%s - Channel:%d - Instrument:%d',[Event[3], Status-192,Data1]);
    208..223 : Info:=format('Action:%s - Channel:%d - Valeur:%d',[Event[4], Status-208,Data1]);
    224..239 : Info:=format('Action:%s - Channel:%d - Valeur:%d',[Event[5], Status-224,Data1]);
    255  : Begin
             If Data1=81 Then Info:=format('Action:%s - Channel:%d - Valeur:%d',[Event[6], Status-224,Data1]);
             If Data1=88 Then Info:=format('Action:%s - Channel:%d - Valeur:%d',[Event[7], Status-224,Data1]);
           End;
  End;
  //On ajoute Info dans Midi_Msg_Mm
  Midi_Msg_Mm.Lines.Add(Info);
  //On rafraichit le mémo
  Midi_Msg_Mm.Refresh;
End;

Procedure TAcquisition_Md_Form.Parse_To_Piano(Status,Data1,Data2: Byte;  Const Time:Cardinal);
Var
  IndexNote,IndexParams:Integer;
  NewNote:TNote;
  AcquisitionNotes:Array[0..15] Of TNote;
Begin
  //Avec PianoGrid faire
  With Piano_Form.PianoGrid Do
    Begin
      //Suivant la valeur du Status
      Case Status Of
        128..143 : Begin
                     //S'il y a des notes alors
                     If NoteCnt.Count>0 Then
                     //Pour toutes les notes faire
                     For IndexNote:=(NoteCnt.Count-1) DownTo 0 Do
                     //Avec la note IndexNote faire
                     With NoteCnt.Items[IndexNote] Do
                       Begin
                         //Si BeginTime=EndTime et qu'on a le meme channel et la meme note de récupérés alors
                         If (BeginTime=EndTime) And (Channel=Status-128) And (Note=Data1) Then
                         //EnsTime est le temps récupéré
                         EndTime:=Time;
                       End;
                   End;
        144..159 : Begin
                     //On ajoute une nouvelle note
                     NewNote:=NoteCnt.Add;
                     //Avec cette dernirere faire
                     With NewNote Do
                       Begin
                         //Pour tout les parametres midi
                         For IndexParams:=1 To 15 Do
                         //On lui assigne celui de l'acquisitionNotes correspondant
                         SetByte(IndexParams,AcquisitionNotes[Status-144].GetByte(IndexParams));
                         //La note est data1
                         Note:=Data1;
                         //BeginTime est le temps récupéré
                         BeginTime:=Time;
                         //EndTime a la meme valeur que BeginTime
                         EndTime:=BeginTime;
                       End;
                   End;
        176..191 : Begin
                     //Avec AcquisitionNotes ayant le numéro Status-176 faire
                     With AcquisitionNotes[Status-176] Do
                       Begin
                         //On définit le channel
                         Channel:=Status-176;
                         //Suivant la valeur de Data 1
                         Case Data1 Of
                           7 :  Volume:=Data2;   //On définit le volume
                           1 :  Modulation:=Data2;   //On définit la modulation
                           5 :  PortamentoTime:=Data2;   //On définit le portamentoTime
                           65 : PortamentoSwitch:=Data2;   //On définit le portamentoSwitch
                           84 : PortamentoNote:=Data2;   //On définit le portamentoNote
                           71 : Resonance:=Data2;   //On définit la resonance
                           10 : Pan:=Data2;   //On définit le pan
                           64 : Sustain:=Data2;   //On définit le sustain
                           94 : Vibrato:=Data2;   //On définit le vibrato
                         End;
                       End;
                   End;
        192..207 : AcquisitionNotes[Status-192].Instr:=Data2; //On définit l'instrument
        208..223 : AcquisitionNotes[Status-192].ChannelPressure:=Data2; //On définit le ChannelPressure
        224..239 : AcquisitionNotes[Status-192].PitchBend:=Data2; //On définit le PitchBend
      End;
      //On rafraichit le piano
      Refresh;
    End;
End;

Procedure TAcquisition_Md_Form.Stop_Acquisition;
Begin
  //On libère MdCom
  MdCom.Free;
End;

end.
