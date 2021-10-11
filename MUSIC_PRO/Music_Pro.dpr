program Music_Pro;

uses
  Forms,
  UMain in 'UMain.pas' {Main_Form},
  UFiles in 'UFiles.pas',
  UParams in 'UParams.pas' {Params_Form},
  UTracks in 'UTracks.pas' {Tracks_Form},
  UMix in 'UMix.pas' {Mix_Form},
  UPianoMd in 'UPianoMd.pas' {Piano_Form},
  UPianoCntrl in 'UPianoCntrl.pas' {CntlMd_Form},
  UPatternMd in 'UPatternMd.pas' {Pattern_Form},
  UMidiSound in 'UMidiSound.pas',
  UGnSound in 'UGnSound.pas',
  UAcquisitionMd in 'UAcquisitionMd.pas' {Acquisition_Md_Form},
  UAsio in 'UAsio.pas' {Asio_Form},
  UEqualizer in 'UEqualizer.pas' {Equalizer_Form},
  UDSP in 'UDSP.pas' {DSP_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.CreateForm(TParams_Form, Params_Form);
  Application.CreateForm(TTracks_Form, Tracks_Form);
  Application.CreateForm(TMix_Form, Mix_Form);
  Application.CreateForm(TPiano_Form, Piano_Form);
  Application.CreateForm(TCntlMd_Form, CntlMd_Form);
  Application.CreateForm(TPattern_Form, Pattern_Form);
  Application.CreateForm(TAcquisition_Md_Form, Acquisition_Md_Form);
  Application.CreateForm(TAsio_Form, Asio_Form);
  Application.CreateForm(TEqualizer_Form, Equalizer_Form);
  Application.CreateForm(TDSP_Form, DSP_Form);
  Application.Run;
end.
