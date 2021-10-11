{>>Dans cette unité, on va traiter tout ce qui concerne le son midi}

unit UMidiSound;

interface

Uses Windows, SysUtils, PatternMidi, BassMidi, Bass, PianoGrid, Dialogs;

Procedure Initialize_MidiStream(Var MidiStream:HStream;Flag:DWord);
Procedure Finalize_MidiStream(Var MidiStream:HStream);
Procedure Load_SoundFont(MidiStream:HStream; Var MidiFont:BASS_MIDI_FONT; SndFontFileName:String);
Procedure Free_SoundFont(MidiStream:HStream; MidiFont:BASS_MIDI_FONT);
Procedure DefaultParams_Pattern(Instrument: TInstrPattern);
Procedure Pattern_Define_MidiEvents(MidiStream:HStream; Instrument: TInstrPattern);
Procedure NoteGrid_Define_MidiEvents(MidiStream:HStream; Note:TNote);
Procedure Press_Note(MidiStream:HStream;Channel,Note,Velocity:Byte);

implementation

Uses UPianoMd, UPatternMd, UParams;

Procedure Initialize_MidiStream(Var MidiStream:HStream;Flag:DWord);
Var
  Freq:Cardinal;
Begin
  If MidiStream=0 Then
    Begin
      With Params_Form.Sample_Freq_LsBx Do
        Begin
          If ItemIndex<0 Then Exit;
          Freq:=StrToInt(Items[ItemIndex]);
        End;
      MidiStream:=BASS_MIDI_StreamCreate(128,Flag,Freq);
    End;
End;

Procedure Finalize_MidiStream(Var MidiStream:HStream);
Begin
  If MidiStream<>0 Then
    Begin
      BASS_StreamFree(MidiStream);
      MidiStream:=0;
    End;
End;

Procedure Load_SoundFont(MidiStream:HStream; Var MidiFont:BASS_MIDI_FONT; SndFontFileName:String);
Begin
  If MidiStream<>0 Then
  With MidiFont Do
    Begin
      Font:=BASS_MIDI_FontInit(Pchar(SndFontFileName),0);
      Preset := -1;
      Bank := 0;
      BASS_MIDI_StreamSetFonts(MidiStream,MidiFont,1);
    End;
End;

Procedure Free_SoundFont(MidiStream:HStream; MidiFont:BASS_MIDI_FONT);
Begin
  If (MidiStream<>0) And (MidiFont.Font<>0) Then
  BASS_MIDI_FontFree(MidiFont.Font);
End;

Procedure DefaultParams_Pattern(Instrument: TInstrPattern);
Begin
  With Instrument Do
    Begin
      //On met le volume par défaut à 127
      Volume:=127;
      //On met la vélocité par défaut à 127
      Velocity:=127;
      //On met l'expression par défaut à 127
      Expression:=127;
      //On met la resonance par défaut à 127
      Resonance:=127;
      //Le Sustain est mis à 127
      Sustain:=127;
      //On met le panomarique par défaut à 64
      Pan:=64;
    End;
End;

Procedure Pattern_Define_MidiEvents(MidiStream:HStream; Instrument: TInstrPattern);
Begin
  If MidiStream<>0 Then
    Begin
      With Instrument Do
        Begin
          If (Channel=9) And (Instr=114) Then BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_DRUMS,1)
          Else BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PROGRAM,Instr);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_VOLUME,Volume);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_CHANPRES,ChannelPressure);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_MODULATION,Modulation);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PITCH,PitchBend);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PORTATIME,PortamentoTime);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PORTAMENTO,PortamentoSwitch);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PORTANOTE,PortamentoNote);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PAN,Pan);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_RESONANCE,Resonance);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_REVERB,Vibrato);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_SUSTAIN,Sustain);
          BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_EXPRESSION,Expression);
        End;
    End;
End;

Procedure NoteGrid_Define_MidiEvents(MidiStream:HStream; Note:TNote);
Begin
  If MidiStream<>0 Then
    Begin
      With Note Do
          Begin
            If (Channel=9) And (Instr=114) Then BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_DRUMS,1)
            Else BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PROGRAM,Instr);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_VOLUME,Volume);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_CHANPRES,ChannelPressure);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_MODULATION,Modulation);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PITCH,PitchBend);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PORTATIME,PortamentoTime);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PORTAMENTO,PortamentoSwitch);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PORTANOTE,PortamentoNote);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_PAN,Pan);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_RESONANCE,Resonance);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_REVERB,Vibrato);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_SUSTAIN,Sustain);
            BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_EXPRESSION,Expression);
          End;
    End;
End;

Procedure Press_Note(MidiStream:HStream;Channel,Note,Velocity:Byte);
Var
  Param:DWORD;
Begin
  If MidiStream<>0 Then
    Begin
      If Velocity=0 Then Param:=Note
      Else Param:=MAKEWORD(Note,Velocity);
      BASS_MIDI_StreamEvent(MidiStream,Channel,MIDI_EVENT_NOTE,Param);
    End;
End;

end.
