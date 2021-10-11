unit UMix;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Bass,Bass_VST,MasterMix, DSPEffect, TracksGrid, TracksMix, MixPanel, ComCtrls, ToolWin, Menus,
  StdCtrls, ExtCtrls;

type
  TMix_Form = class(TForm)
    Mix_ScBx: TScrollBox;
    MixPanel_Pn: TPanel;
    MasterMix_Pn: TPanel;
    MixPanel: TMixPanel;
    TracksMix: TTracksMix;
    MasterMix: TMasterMix;
    procedure TracksMixSolo_Event(Sender: TObject);
    procedure TracksMixMute_Event(Sender: TObject);
    procedure TracksMixPanel_Event(Sender: TObject);
    procedure TracksMixFaderChange_Event(Sender: TObject);
    procedure TracksMixSliderChange_Event(Sender: TObject);
    procedure MasterMixSliderChange(Sender: TObject);
    procedure MasterMixFaderChange(Sender: TObject);
    procedure TracksMixEffectClick(Sender: TObject);
    procedure MixPanelAddMixPnBtClick(Sender: TObject);
    procedure MixPanelDelMixPnBtClick(Sender: TObject);
    procedure TracksMixClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Mix_Form: TMix_Form;

implementation

uses UTracks, UGnSound, UGnBass, UDSP, UEqualizer;
{$R *.dfm}

{>>Sélection des Items}
procedure TMix_Form.TracksMixClick(Sender: TObject);
begin
  //Avec les Tracks de TracksMix faire
  With TracksMix.TrackMixCnt Do
    Begin
      //On sélectionne le même Track dansTracksGrid
      Tracks_Form.TracksGrid.TrackCnt.ItemIndex:=ItemIndex;
      //On sélectionne le même Track dans BrowserTracks
      Tracks_Form.BrowserTracks.BrTracksCnt.ItemIndex:=ItemIndex;
    End;
end;

{>>Procédure pour rajouter un effet}
procedure TMix_Form.MixPanelAddMixPnBtClick(Sender: TObject);
Var
  CrTypeEffect:TMxTypeEffect;
  CrListEffect:TListEffect;
  NewEffect:TEffect;
begin
  //Avec TracksMix.TrackMixCnt faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Si un Track a été sélectionné et que les délimitateurs sont visibles alors
      If (ItemIndex>=0) And (Tracks_Form.TrackTime.Delims_Show) Then
      //Avec MixPanel faire
      With MixPanel Do
        Begin
          //Pour tout les types d'effets faire
          For CrTypeEffect:=TMxSoundFont To TMxEqualizer Do
            Begin
              //On définit la ListBox correspondant à l'effet;
              CrListEffect:=GetListEffect(Ord(CrTypeEffect));
              //Si  un Item est sélectionné dans la listbox correspondante alors
              If CrListEffect.ItemIndex>=0 Then
                Begin
                  //Avec le Track sélectionné faire
                  With Items[ItemIndex].TrackMixPn.EffectCnt Do
                    Begin
                      //On créer un nouvel effet
                      NewEffect:=Add;
                      //On sélectionne cet effet
                      ItemIndex:=Count-1;
                    End;
                  //Avec ce dernier faire
                  With NewEffect.EffectTab Do
                    Begin
                      //On définit le FileName
                      FileName:=CrListEffect.Items.Strings[CrListEffect.ItemIndex];
                      //Définir le caption
                      Caption:=changeFileExt(ExtractFileName(FileName),'');
                      //Le type d'effet
                      Effect:=CrTypeEffect;
                      //On le désactive
                      MuteButton.Actived:=False;
                      //On rafraichit TracksMix
                      TracksMix.Refresh;
                      //On sélectionne l'item dans TracksGrid
                      Tracks_Form.TracksGrid.TrackCnt.ItemIndex:=ItemIndex;
                      //Avec TracksGrid faire
                      With Tracks_Form.TracksGrid Do
                        Begin
                          //Avec le Track correspondant dans TracksGrid, faire
                          With TrackCnt.Items[ItemIndex] Do
                            Begin
                              //On ajoute dans le Track, l'effet correspondant et on fait avec
                              With (ItemsEffect[Ord(CrTypeEffect)].Add As TCustomCollectionItem) Do
                                Begin
                                  //Son FileName
                                  FileName:=NewEffect.EffectTab.FileName;
                                  //Sa priorité
                                  Priority:=NewEffect.Index;
                                  //On définit son EffectIndex
                                  EffectIndex:=ItemsEffect[Ord(CrTypeEffect)].Count-1;
                                  //On met Mute à False
                                  Mute:=False;
                                  //Son Offset
                                  OffsetTime:=0;
                                  //Si on a un effet de type DSP alors
                                  If Effect=TMxDSP Then
                                    Begin
                                      //On définit le type de DSP dans NewEffect
                                      NewEffect.EffectTab.TypeDSP:=TMxTypeDSP(CrListEffect.ItemIndex);
                                      //On définit le type de DSP dans le Track
                                      DSPCnt.Items[EffectIndex].TypeDSP:=TTypeDSP(CrListEffect.ItemIndex);
                                    End;
                                  //Suivant la nature de l'effet
                                  Case Effect Of
                                    //Si c'est une SoundFont, on la charge
                                    TMxSOUNDFONT : Create_SndFont(TrackCnt.Items[ItemIndex],SoundFontCnt.Items[EffectIndex]);
                                    //Si c'est un VSTI, on le charge
                                    TMxVSTI :  Create_VST(TrackCnt.Items[ItemIndex],VSTICnt.Items[EffectIndex],True);
                                    //Si c'est un VSTE, on le charge
                                    TMxVSTE :  Create_VST(TrackCnt.Items[ItemIndex],VSTECnt.Items[EffectIndex],True);
                                    //Si c'est un DSP, on le charge
                                    TMxDSP :  Create_DSP(TrackCnt.Items[ItemIndex],DSPCnt.Items[EffectIndex]);
                                    //Si c'est un EQUALIZER, on le charge
                                    TMxEQUALIZER  :  Create_Egalizer(TrackCnt.Items[ItemIndex],EgalizerCnt.Items[EffectIndex]);
                                  End;
                                End;
                              //Avec le track correspondant dans BrowserTracks faire
                              With Tracks_Form.BrowserTracks.BrTracksCnt.Items[ItemIndex] Do
                              //On simule le click du bouton WriteBt
                              BrPanelTrack.WriteBt.OnClick(Self);
                            End;
                        End;
                    End;
                End;
            End;
        End;
    End;
End;

{>>Procédure pour supprimer un effet}
procedure TMix_Form.MixPanelDelMixPnBtClick(Sender: TObject);
Var
  CrTypeEffect:TMxTypeEffect;
  IndexEffect:Integer;
Begin
  //Avec TracksMix.TrackMixCnt faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Si un Track est sélectionné alors
      If ItemIndex>=0 Then
      //Avec le TrackMixPn  du Track sélectionné faire
      With Items[ItemIndex].TrackMixPn Do
        Begin
          //S'il y a des effets et qu'un effet est sélectionné alors
          If (EffectCnt.Count>0) And (EffectCnt.ItemIndex>=0) Then
          //Avec l'EffectTab de l'effet sélectionné faire
          With EffectCnt.Items[ItemIndex].EffectTab Do
            Begin
              //Avec TracksGrid faire
              With Tracks_Form.TracksGrid Do
                Begin
                  //Pour tout les types d'effets faire
                  For CrTypeEffect:=TMxSoundFont To TMxEqualizer Do
                  //Avec le type d'effet correspondant pour le Track sélectionné faire
                  With TrackCnt.Items[TrackCnt.ItemIndex] Do
                    Begin
                      With ItemsEffect[Ord(CrTypeEffect)] Do
                        Begin
                          //S'il y a des effets alors
                          If Count>0 Then
                          //Pour tout les effets faire
                          For IndexEffect:=(Count-1) To 0 Do
                          //Avec l'effet IndexEffect faire
                          With (Items[IndexEffect] As TCustomCollectionItem) Do
                            Begin
                              //Si la priorité est supérieur à EffectIndex, on décrémente la priorité
                              If Priority>EffectIndex Then Priority:=Priority-1;
                              //Si la priopriété est égale à EffectIndex et que le type d'effet est celui sélectionné faire
                              If (Priority=EffectIndex) And (Effect=CrTypeEffect) Then
                                Begin
                                  Case Effect Of
                                    //Si c'est une SoundFont, on la supprime
                                    TMxSOUNDFONT : Free_SndFont(TrackCnt.Items[TrackCnt.ItemIndex],SoundFontCnt.Items[IndexEffect]);
                                    //Si c'est un VSTI, on le supprime
                                    TMxVSTI : Free_VST(TrackCnt.Items[TrackCnt.ItemIndex],VSTICnt.Items[IndexEffect]);
                                    //Si c'est un VSTE, on le supprime
                                    TMxVSTE : Free_VST(TrackCnt.Items[TrackCnt.ItemIndex],VSTECnt.Items[IndexEffect]);
                                    //Si c'est un DSP, on le supprime
                                    TMxDSP : Free_DSP(TrackCnt.Items[TrackCnt.ItemIndex],DSPCnt.Items[IndexEffect]);
                                    //Si c'est un EQUALIZER, on le supprime
                                    TMxEQUALIZER  : Free_Egalizer(TrackCnt.Items[TrackCnt.ItemIndex],EgalizerCnt.Items[IndexEffect]);
                                  End;
                                  //On supprime l'effet dans TracksGrid
                                  Delete(IndexEffect);
                                End;
                            End;
                        End;
                    End;
                End;
              //On supprime l'effet dans TrackMix
              EffectCnt.Delete(EffectCnt.ItemIndex);
            End;
        End;
      End;
end;

{>>Procédure pour mettre en solo un effet}
procedure TMix_Form.TracksMixSolo_Event(Sender: TObject);
Const
  BPB: DWord=BASS_POS_BYTE;
Var
  IndexEffect:Integer;
Begin
  //Avec TracksMix.TrackMixCnt faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Avec le track sélectionné faire
      With Items[ItemIndex].TrackMixPn Do
        Begin
          //Avec TracksGrid faire
          With Tracks_Form.TracksGrid Do
            Begin
              //Si un effect est sélectionné
              If EffectCnt.ItemIndex>=0 Then
              //Avec le Track correspondant dans TracksGrid faire
              With TrackCnt.Items[TrackCnt.ItemIndex] Do
              //Pour tout les effets
              For IndexEffect:=0 To (EffectCnt.Count-1) Do
              //Avec l'effet IndexEffect faire
              With EffectCnt.Items[IndexEffect].EffectTab Do
                Begin
                  //Si l'effet n'est pas celui sélectionné alors
                  If IndexEffect<>EffectCnt.ItemIndex Then
                    Begin
                      //On désactive le bouton de solo
                      SoloButton.Actived:=False;
                      //On désactive le bouton de Mute
                      MuteButton.Actived:=True;
                    End
                  //Sinon l'activation du Mute est identique au solo
                  Else MuteButton.Actived:=False;
                  //Avec ce type d'effet dans le Track faire
                  With ItemsEffect[Ord(Effect)] Do
                  //S'il y a des effets de ce type alors
                  If (Count>0) Then
                  //Avec l'effet définit comme un TCustomCollectionItem faire
                  With (Items[EffectIndex] As TCustomCollectionItem) Do
                  //On active/désactive l'effet
                  Mute:=Not SoloButton.Actived;
                  //On change les effets
                  Change_Effects;
                End;
            End;
        End;
    End;
end;

{>>Procédure pour activer/désactiver le mute d'un effet}
procedure TMix_Form.TracksMixMute_Event(Sender: TObject);
Const
  BPB: DWord=BASS_POS_BYTE;
Var
  IndexEffect:Integer;
Begin
  //Avec TracksMix.TrackMixCnt faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Avec le TrackMixPn de ce track faire
      With Items[ItemIndex].TrackMixPn Do
        Begin
          //Pour tout les effets
          For IndexEffect:=0 To (EffectCnt.Count-1) Do
          //On désactive le bouton de solo
          EffectCnt.Items[IndexEffect].EffectTab.SoloButton.Actived:=False;
          //Si un effect est sélectionné
          If EffectCnt.ItemIndex>=0 Then
          //Avec l'effet sélectionné faire
          With EffectCnt.Items[EffectCnt.ItemIndex].EffectTab Do
            Begin
              //Avec TracksGrid faire
              With Tracks_Form.TracksGrid Do
                Begin
                  //Avec le Track sélectionné faire
                  With TrackCnt.Items[TrackCnt.ItemIndex] Do
                    Begin
                      //Avec ce type d'effet dans le Track faire
                      With ItemsEffect[Ord(Effect)] Do
                      //S'il y a des effets de ce type alors
                      If (Count>0) Then
                        Begin
                          //Avec l'effet sélectionné définit comme un TCustomCollectionItem faire
                          With (Items[EffectIndex] As TCustomCollectionItem) Do
                          //On active/désactive l'effet
                          Mute:=MuteButton.Actived;
                          //On change les effets
                          Change_Effects;
                        End;
                    End;
                End;
            End;
        End;
    End;
end;

{>>Procédure pour afficher un effet}
procedure TMix_Form.TracksMixPanel_Event(Sender: TObject);
Begin
  //Avec TracksMix.TrackMixCnt faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Si un Track est sélectionné
      If ItemIndex>=0 Then
      //Avec le Track sélectionné faire
      With Items[ItemIndex].TrackMixPn Do
        Begin
          //Avec le Track sélectionné dans TracksGrid faire
          With Tracks_Form.TracksGrid.TrackCnt.Items[ItemIndex] Do
            Begin
              //Si un effect est sélectionné
              If EffectCnt.ItemIndex>=0 Then
              //Avec l'effet sélectionné faire
              With EffectCnt.Items[EffectCnt.ItemIndex].EffectTab Do
              //Suivant sa nature faire
              Case Effect Of
                //Si c'est une SoundFont, on sort
                TMxSOUNDFONT : Exit;
                //Si c'est un VSTI, on l'affiche
                TMxVSTI : Show_VSTPanel(VSTICnt.Items[EffectCnt.ItemIndex]);
                //Si c'est un VSTE, on l'affiche
                TMxVSTE : Show_VSTPanel(VSTECnt.Items[EffectCnt.ItemIndex]);
                //Si c'est un DSP, on l'affiche
                TMxDSP : Show_DspPanel(DSPCnt.Items[EffectCnt.ItemIndex]);
                //Si c'est un EQUALIZER, on l'affiche
                TMxEQUALIZER  : Show_EgalizerPanel(EgalizerCnt.Items[EffectCnt.ItemIndex]);
              End;
            End;
        End;
    End;
End;

{>>Procédure pour afficher les BeginTime et EndTime d'un effet}
procedure TMix_Form.TracksMixEffectClick(Sender: TObject);
Begin
  //Avec TracksMix.TrackMixCnt faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Avec le TrackMixPn de ce track faire
      With Items[ItemIndex].TrackMixPn Do
        Begin
          //Avec l'effet sélectionné faire
          With EffectCnt.Items[EffectCnt.ItemIndex].EffectTab Do
            Begin
              //Avec TracksGrid faire
              With Tracks_Form.TracksGrid Do
                Begin
                  //Avec le Track sélectionné faire
                  With TrackCnt.Items[ItemIndex] Do
                    Begin
                       //Avec l'effet sélectionné définit comme un TCustomCollectionItem faire
                       With (ItemsEffect[Ord(Effect)].Items[EffectIndex] As TCustomCollectionItem) Do
                         Begin
                           //On affiche le BeginTime dans le TrackTime
                           Tracks_Form.TrackTime.LeftDelim:=BeginTime;
                           //On affiche le EndTime dans le TrackTime
                           Tracks_Form.TrackTime.RightDelim:=EndTime;
                           //On affiche les délimitateurs
                           Tracks_Form.TrackTime.Delims_Show:=True;
                           //On rafraichit TrackTime
                           Tracks_Form.TrackTime.Refresh;
                         End;
                    End;
                End;
            End;
        End;
    End;
end;

{>>Procédure pour modifier le volume d'un Track}
procedure TMix_Form.TracksMixFaderChange_Event(Sender: TObject);
Begin
  //Avec les Tracks de TracksMix faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Avec le Track sélectionné, dans TracksGrid faire
      With Tracks_Form.TracksGrid.TrackCnt.Items[ItemIndex] Do
        Begin
          //Avec le Track dans TrackMix faire
          With Items[ItemIndex].TrackMixPn Do
            Begin
              //On définit le volume du Track comme la position du Fader
              Volume:=Fader.Pos;
              //Changement du volume
              Change_Volume_Stream(Stream,Volume);
              //On modifie la position de la ProgressBar
              PrgrBarr.Pos:=Fader.Pos;
            End;  
        End;
    End;
end;

{>>Procédure pour modifier le panoramique d'un Track}
procedure TMix_Form.TracksMixSliderChange_Event(Sender: TObject);
Begin
  //Avec les Tracks de TracksMix faire
  With TracksMix.TrackMixCnt Do
    Begin
      //Avec le Track sélectionné, dans TracksGrid faire
      With Tracks_Form.TracksGrid.TrackCnt.Items[ItemIndex] Do
        Begin
          //Avec le Track dans TrackMix faire
          With Items[ItemIndex].TrackMixPn Do
            Begin
              //On définit le pourcentage de voie droite
              RightCanal:=50+Slider.Pos;
              //On définit le pourcentage de voie gauche
              LeftCanal:=100-RightCanal;
              //Changement du panoramique
              Change_Pan_Stream(Stream,(RightCanal-50)*2);
            End;
        End;
    End;
end;

{>>Procédure pour modifier le volume général}
procedure TMix_Form.MasterMixFaderChange(Sender: TObject);
begin
  //Avec TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //On définit le volume général
      Volume:=MasterMix.Fader.Pos;
      //Changement du volume
      Change_Volume_Stream(MasterStream,Volume);
    End;
  //On change la position de la ProgressBar
  MasterMix.PrgrBar.Pos:=MasterMix.Fader.Pos;
end;

{>>Procédure pour modifier le panoramique général}
procedure TMix_Form.MasterMixSliderChange(Sender: TObject);
begin
  //Avec le Track sélectionné, dans TracksGrid faire
  With Tracks_Form.TracksGrid Do
    Begin
      //On définit le pourcentage de voie droite
      RightCanal:=50+MasterMix.Slider.Pos;
      //On définit le pourcentage de voie gauche
      LeftCanal:=100-RightCanal;
      //Changement du panoramique
      Change_Pan_Stream(MasterStream,(RightCanal-50)*2);
    End;
end;

end.
