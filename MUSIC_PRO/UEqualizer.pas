unit UEqualizer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TracksMix, bass_fx, Bass, EqualizerControl;

type
  TEqualizer_Form = class(TForm)
    Equalizer: TEqualizerControl;
    procedure EqualizerBand0Change(Sender: TObject);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  Equalizer_Form: TEqualizer_Form;

implementation

uses UMix, UTracks;

{$R *.dfm}

procedure TEqualizer_Form.EqualizerBand0Change(Sender: TObject);
Var
  BandEq  : BASS_BFX_PEAKEQ;
begin
 //Avec TracksMix faire
  With Mix_Form.TracksMix Do
  //Si un Track est s�lectionn� alors
  If TrackMixCnt.ItemIndex>=0 Then
    Begin
      //Avec le Track s�lectionn� faire
      With TrackMixCnt.Items[TrackMixCnt.ItemIndex].TrackMixPn Do
      //Si un effet est s�lectionn� alors
      If EffectCnt.ItemIndex>=0 Then
        Begin
          //Avec l'effet s�lectionn� faire
          With EffectCnt.Items[EffectCnt.ItemIndex].EffectTab Do
          //S'il s'agit d'un effet DSP
          If (Effect=TMxEqualizer) Then
            Begin
              //Avec Track s�lectionn� dans TracksGrid faire
              With Tracks_Form.TracksGrid.TrackCnt.Items[TrackMixCnt.ItemIndex] Do
                Begin
                  //Avec Sender comme une TGaugeBar faire
                  With Sender As TGaugeBar Do
                    Begin
                      //On d�finit le lBand de BandEq
                      BandEq.lBand:=Tag;
                      //Si Q est non nul alors on d�finit le fQ de BandEq
                      If Q<>0 Then BandEq.fQ :=Q
                      //Sinon on d�finit le fBandwidth de BandEq
                      Else BandEq.fBandwidth:=Bandwidth;
                      //On d�finit le fCenter  de BandEq
                      BandEq.fCenter:=Center;
                      //On d�finit le fGain  de BandEq
                      BandEq.fGain:=Gain;
                      //On l'applique l'effet � tout les canaux
                      BandEq.lChannel:= BASS_BFX_CHANALL;
                      //On envoit les param�tres au Stream de l'effet
                      BASS_FXSetParameters(EgalizerCnt.Items[EffectIndex].Stream,@BandEq);
                    End;  
                End;
            End;
        End;
    End;
end;



end.
