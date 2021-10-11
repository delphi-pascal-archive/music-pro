unit UDSP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DSPEffect, TracksMix, TracksGrid, StdCtrls,  bass_fx, Bass;

type
  TDSP_Form = class(TForm)
    DSPEffect: TDSPEffect;
    procedure DSPEffectCutOffFreqMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  DSP_Form: TDSP_Form;

implementation

uses UMix, UTracks;

{$R *.dfm}

{>>Procédure pour modifier}
procedure TDSP_Form.DSPEffectCutOffFreqMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
begin
  //Avec TracksMix faire
  With Mix_Form.TracksMix Do
  //Si un Track est sélectionné alors
  If TrackMixCnt.ItemIndex>=0 Then
    Begin
      //Avec le Track sélectionné faire
      With TrackMixCnt.Items[TrackMixCnt.ItemIndex].TrackMixPn Do
      //Si un effet est sélectionné alors
      If EffectCnt.ItemIndex>=0 Then
        Begin
          //Avec l'effet sélectionné faire
          With EffectCnt.Items[EffectCnt.ItemIndex].EffectTab Do
          //S'il s'agit d'un effet DSP
          If (Effect=TMxDSP) Then
            Begin
              //Avec Track sélectionné dans TracksGrid faire
              With Tracks_Form.TracksGrid.TrackCnt.Items[TrackMixCnt.ItemIndex] Do
                Begin
                  //Suivant le type d'effet DSP, on modifie les paramètres de l'effet
                  Case DSPCnt.Items[EffectIndex].TypeDSP Of
                    TEcho :          Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_ECHO);
                                       BFX_ECHO.fLevel:=DSPEffect.ALevel.Pos;
                                       BFX_ECHO.lDelay:=DSPEffect.ALDelay.Pos*100;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_ECHO);
                                     End;
                    TReverb :        Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_REVERB);
                                       BFX_REVERB.fLevel:=DSPEffect.ALevel.Pos;
                                       BFX_REVERB.lDelay:=DSPEffect.ALDelay.Pos*100;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_REVERB);
                                     End;
                    TFlanger :       Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_FLANGER);
                                       BFX_FLANGER.fWetDry:=DSPEffect.AWetDry.Pos;
                                       BFX_FLANGER.fSpeed:=DSPEffect.ASpeed.Pos / 1000;
                                       BFX_FLANGER.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_FLANGER);
                                     End;
                    TVolume :        Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_VOLUME);
                                       BFX_VOLUME.fVolume:=DSPEffect.AVolume.Pos / 100;
                                       BFX_VOLUME.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_VOLUME);
                                     End;
                    TLowPassFilter : Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_LPF);
                                       BFX_LPF.fResonance:=DSPEffect.AResonance.Pos / 10;
                                       BFX_LPF.fCutOffFreq:=DSPEffect.ACutOffFreq.Pos;
                                       BFX_LPF.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_LPF);
                                     End;
                    TAmplification : Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_DAMP);
                                       BFX_DAMP.fTarget:=DSPEffect.ATarget.Pos / 100;
                                       BFX_DAMP.fQuiet:=DSPEffect.AQuiet.Pos / 100;
                                       BFX_DAMP.fRate:=DSPEffect.ARate.Pos / 100;
                                       BFX_DAMP.fGain:=DSPEffect.AGain.Pos / 10;
                                       BFX_DAMP.fDelay:=DSPEffect.ADelay.Pos / 10;
                                       BFX_DAMP.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_DAMP);
                                     End;
                    TAutoWah :       Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_AUTOWAH);
                                       BFX_AUTOWAH.fDryMix:=DSPEffect.ADryMix.Pos / 10;
                                       BFX_AUTOWAH.fWetMix:=DSPEffect.AWetMix.Pos / 10;
                                       BFX_AUTOWAH.fFeedback:=DSPEffect.AFeedback.Pos / 10;
                                       BFX_AUTOWAH.fRate:=DSPEffect.ARate.Pos / 100;
                                       BFX_AUTOWAH.fRange:=DSPEffect.ARange.Pos / 10;
                                       BFX_AUTOWAH.fFreq:=DSPEffect.AFreq.Pos*10;
                                       BFX_AUTOWAH.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_AUTOWAH);
                                     End;
                    TEcho2 :         Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_ECHO2);
                                       BFX_ECHO2.fDryMix:=DSPEffect.ADryMix.Pos / 10;
                                       BFX_ECHO2.fWetMix:=DSPEffect.AWetMix.Pos / 10;
                                       BFX_ECHO2.fFeedback:=DSPEffect.AFeedback.Pos / 10;
                                       BFX_ECHO2.fDelay:=DSPEffect.ADelay.Pos / 10;
                                       BFX_ECHO2.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_ECHO2);
                                     End;
                    TPhaser :        Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_PHASER);
                                       BFX_PHASER.fDryMix:=DSPEffect.ADryMix.Pos / 10;
                                       BFX_PHASER.fWetMix:=DSPEffect.AWetMix.Pos / 10;
                                       BFX_PHASER.fFeedback:=DSPEffect.AFeedback.Pos / 10;
                                       BFX_PHASER.fRate:=DSPEffect.ARate.Pos / 100;
                                       BFX_PHASER.fRange:=DSPEffect.ARange.Pos / 10;
                                       BFX_PHASER.fFreq:=DSPEffect.AFreq.Pos*10;
                                       BFX_PHASER.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_PHASER);
                                     End;
                    TEcho3 :         Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_ECHO3);
                                       BFX_ECHO3.fDryMix:=DSPEffect.ADryMix.Pos / 10;
                                       BFX_ECHO3.fWetMix:=DSPEffect.AWetMix.Pos / 10;
                                       BFX_ECHO3.fDelay:=DSPEffect.ADelay.Pos / 10;
                                       BFX_ECHO3.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_ECHO3);
                                     End;
                    TChorus :        Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_CHORUS);
                                       BFX_CHORUS.fDryMix:=DSPEffect.ADryMix.Pos / 10;
                                       BFX_CHORUS.fWetMix:=DSPEffect.AWetMix.Pos / 10;
                                       BFX_CHORUS.fFeedback:=DSPEffect.AFeedback.Pos / 10;
                                       BFX_CHORUS.fRate:=DSPEffect.ARate.Pos / 100;
                                       BFX_CHORUS.fMinSweep:=DSPEffect.AMinSweep.Pos*100;
                                       BFX_CHORUS.fMaxSweep:=DSPEffect.AMaxSweep.Pos*100;
                                       BFX_CHORUS.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_CHORUS);
                                     End;
                    TAllPassFilter : Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_APF);
                                       BFX_APF.fGain:=DSPEffect.AGain.Pos / 10;
                                       BFX_APF.fDelay:=DSPEffect.ADelay.Pos / 10;
                                       BFX_APF.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_APF);
                                     End;
                    TCompressor :    Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_COMPRESSOR);
                                       BFX_COMPRESSOR.fThreshold:=DSPEffect.AThreshold.Pos / 100;
                                       BFX_COMPRESSOR.fAttacktime:=DSPEffect.AnAttacktime.Pos*10;
                                       BFX_COMPRESSOR.fReleasetime:=DSPEffect.AReleasetime.Pos*10;
                                       BFX_COMPRESSOR.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_COMPRESSOR);
                                     End;
                    TDistortion :    Begin
                                       BASS_FXGetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_DISTORTION);
                                       BFX_DISTORTION.fDrive:=DSPEffect.ADrive.Pos / 10;
                                       BFX_DISTORTION.fDryMix:=DSPEffect.ADryMix.Pos / 10;
                                       BFX_DISTORTION.fWetMix:=DSPEffect.AWetMix.Pos / 10;
                                       BFX_DISTORTION.fFeedback:=DSPEffect.AFeedback.Pos / 10;
                                       BFX_DISTORTION.fVolume:=DSPEffect.AVolume.Pos / 100;
                                       BFX_DISTORTION.lChannel:=BASS_BFX_CHANALL;
                                       BASS_FXSetParameters(DSPCnt.Items[EffectIndex].Stream,@BFX_DISTORTION);
                                     End;
                  End;
                End;
            End;
       End;
    End;
end;

{>>Procédure quand la forme est affichée}
procedure TDSP_Form.FormShow(Sender: TObject);
begin
  //Avec DSPEffect faire
  With DSPEffect Do
  //Suivant le type d'effet DSP, on initialise les paramètres de l'effet
  Case TTypeDSP(DSPEffect.TypeDSP)  Of
    TVolume :          Begin
                         AVolume.Pos:=0;
                         AVolume.Min:=0;
                         AVolume.Max:=100;
                       End;
    TAmplification :   Begin
                         ARate.Pos:=0;
                         ARate.Min:=0;
                         ARate.Max:=100;
                         AGain.Pos:=0;
                         AGain.Min:=0;
                         AGain.Max:=1000;
                         ATarget.Pos:=1;
                         ATarget.Min:=1;
                         ATarget.Max:=100;
                         AQuiet.Pos:=0;
                         AQuiet.Min:=0;
                         AQuiet.Max:=100;
                         AGain.Pos:=0;
                         AGain.Min:=0;
                         AGain.Max:=10;
                         ADelay.Pos:=0;
                         ADelay.Min:=0;
                         ADelay.Max:=60;
                       End;
    TAutoWah,TPhaser : Begin
                         ARate.Pos:=1;
                         ARate.Min:=1;
                         ARate.Max:=999;
                         ADryMix.Pos:=-20;
                         ADryMix.Min:=-20;
                         ADryMix.Max:=20;
                         AWetMix.Pos:=-20;
                         AWetMix.Min:=-20;
                         AWetMix.Max:=20;
                         AFeedback.Pos:=-10;
                         AFeedback.Min:=-10;
                         AFeedback.Max:=10;
                         ARange.Pos:=1;
                         ARange.Min:=1;
                         ARange.Max:=99;
                         AFreq.Pos:=1;
                         AFreq.Min:=1;
                         AFreq.Max:=10;
                       End;
    TChorus  :         Begin
                         ARate.Pos:=1;
                         ARate.Min:=1;
                         ARate.Max:=100000;
                         ADryMix.Pos:=-20;
                         ADryMix.Min:=-20;
                         ADryMix.Max:=20;
                         AWetMix.Pos:=-20;
                         AWetMix.Min:=-20;
                         AWetMix.Max:=20;
                         AFeedback.Pos:=-10;
                         AFeedback.Min:=-10;
                         AFeedback.Max:=10;
                         AMinSweep.Pos:=1;
                         AMinSweep.Min:=1;
                         AMinSweep.Max:=60;
                         AMaxSweep.Pos:=1;
                         AMaxSweep.Min:=1;
                         AMaxSweep.Max:=60;
                       End;
    TDistortion :      Begin
                         AVolume.Pos:=0;
                         AVolume.Min:=0;
                         AVolume.Max:=200;
                         ADrive.Pos:=0;
                         ADrive.Min:=0;
                         ADrive.Max:=50;
                         ADryMix.Pos:=-50;
                         ADryMix.Min:=-50;
                         ADryMix.Max:=50;
                         AWetMix.Pos:=-50;
                         AWetMix.Min:=-50;
                         AWetMix.Max:=50;
                         AFeedback.Pos:=-10;
                         AFeedback.Min:=-10;
                         AFeedback.Max:=10;
                         AVolume.Pos:=0;
                         AVolume.Min:=0;
                         AVolume.Max:=200;
                       End;
    TAllPassFilter :   Begin
                         AGain.Pos:=-10;
                         AGain.Min:=-10;
                         AGain.Max:=10;
                         ADelay.Pos:=0;
                         ADelay.Min:=0;
                         ADelay.Max:=60;
                       End;
    TCompressor :      Begin
                         AThreshold.Pos:=0;
                         AThreshold.Min:=0;
                         AThreshold.Max:=100;
                         AnAttacktime.Pos:=0;
                         AnAttacktime.Min:=0;
                         AnAttacktime.Max:=100;
                         AReleasetime.Pos:=0;
                         AReleasetime.Min:=0;
                         AReleasetime.Max:=500;
                       End;
    TFlanger :         Begin
                         AWetDry.Pos:=00;
                         AWetDry.Min:=0;
                         AWetDry.Max:=100;
                         ASpeed.Pos:=0;
                         ASpeed.Min:=0;
                         ASpeed.Max:=900;
                       End;
    TReverb, TEcho :   Begin
                         ALevel.Pos:=0;
                         ALevel.Min:=0;
                         ALevel.Max:=100;
                         ALDelay.Pos:=12;
                         ALDelay.Min:=12;
                         ALDelay.Max:=300;
                       End;
    TLowPassFilter :   Begin
                         AResonance.Pos:=1;
                         AResonance.Min:=1;
                         AResonance.Max:=100;
                         ACutOffFreq.Pos:=0;
                         ACutOffFreq.Min:=0;
                         ACutOffFreq.Max:=11050;
                       End;
    TEcho2 :           Begin
                         ADryMix.Pos:=-20;
                         ADryMix.Min:=-20;
                         ADryMix.Max:=20;
                         AWetMix.Pos:=-20;
                         AWetMix.Min:=-20;
                         AWetMix.Max:=20;
                         AFeedback.Pos:=-10;
                         AFeedback.Min:=-10;
                         AFeedback.Max:=10;
                         ADelay.Pos:=1;
                         ADelay.Min:=1;
                         ADelay.Max:=60;
                       End;
    TEcho3 :           Begin
                         ADryMix.Pos:=-20;
                         ADryMix.Min:=-20;
                         ADryMix.Max:=20;
                         AWetMix.Pos:=-20;
                         AWetMix.Min:=-20;
                         AWetMix.Max:=20;
                         ADelay.Pos:=1;
                         ADelay.Min:=1;
                         ADelay.Max:=60;
                       End;
  End;
  //On rafraichit DSPEffect
  DSPEffect.Refresh;  
end;

end.
