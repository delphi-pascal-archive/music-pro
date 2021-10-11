unit UPianoCntrl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MidiCntPattern, MidiControlsPanel,UPianoMd, ToolWin, ComCtrls,
  Buttons, PianoGrid;

type
  TCntlMd_Form = class(TForm)
    MdCntrPn_ScBx: TScrollBox;
    MidiControlsPanel: TMidiControlsPanel;
    procedure MidiControlsPanelNoteParams_On(Sender: TObject; Note: TNote);
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  CntlMd_Form: TCntlMd_Form;

implementation

Uses UMidiSound;

{$R *.dfm}

{>>On modifie les param�tres de la note s�lectionn�e}
procedure TCntlMd_Form.MidiControlsPanelNoteParams_On(Sender: TObject;
  Note: TNote);
begin
  //On modifie les propri�t�s de la note
  NoteGrid_Define_MidiEvents(MidiGridStream,Note);
end;

end.
