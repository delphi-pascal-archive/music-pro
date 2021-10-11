object Mix_Form: TMix_Form
  Left = 6
  Top = 82
  Width = 794
  Height = 458
  AutoSize = True
  Caption = 'MUSIC PRO'
  Color = 10728638
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFF
    FFFFF8F87777888FFFFFFFFFFFFFFFFFFFFF8777733773788FFFFFFFFFFFFFFF
    FF87710000000077788FFFFFFFFFFFFFF8770010011110007188FFFFFFFFFFFF
    870001103173113707778FFFFFFFFFF87001111731871117137788FFFFFFFFF8
    00111138133333371107788FFFFFFF8301111333711733303117788FFFFFFF70
    111333338017337337107788FFFFFF001113333B77F78BB07831778888FFF801
    113333BBBBBBBBB787317788888FF71113333BBB8BBB8BB7771337788888F011
    1337BBBBBBBBBBB7113137778888F0113337BBBBBBBB3BB7703837788888F011
    3777BBBBBBB77B81067017788888F0333777BBBBBB88833176777087888FF073
    3778BBBB888838854747780788F8F7777778BBBB78838830706573173788FF77
    77788BBB88388383170011110818FF177778888BBBB83887800207111177FFF7
    7701188888B38788880040731108FFF77778830788883888888000031117FFFF
    7777887018888888883800071133FFFFF818787883138888838780188108FFFF
    FFF81777777888883888338FFFFFFFFFFFFFFF888877778838837738FFFFFFFF
    FFFFFFFFFFF8777773178771FFFFFFFFFFFFFFFFFFFF7787777778377FFFFFFF
    FFFFFFFFFFFF7878777FF78781FFFFFFFFFFFFFFFFFFF387777FFF78737FFFFF
    FFFFFFFFFFFFF878787FFFF77773FFFFFFFFFFFFFFFFFF8770FFFFFF78730000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Mix_ScBx: TScrollBox
    Left = 115
    Top = 0
    Width = 554
    Height = 423
    Hint = 'Mix_ScBx'
    HorzScrollBar.Size = 5
    VertScrollBar.Size = 5
    VertScrollBar.Visible = False
    TabOrder = 0
    object TracksMix: TTracksMix
      Left = 0
      Top = 0
      Width = 550
      Height = 416
      TrackMixCnt = <
        item
          TrackMixPn.Left = 0
          TrackMixPn.Top = 0
          TrackMixPn.Width = 110
          TrackMixPn.Height = 416
          TrackMixPn.Caption = 'TRACK'
          TrackMixPn.Slider.Left = 5
          TrackMixPn.Slider.Top = 56
          TrackMixPn.Slider.Width = 100
          TrackMixPn.Slider.Height = 35
          TrackMixPn.Slider.Caption = 'Pan'
          TrackMixPn.Slider.ColorSlot = clWhite
          TrackMixPn.Slider.ColorBackGrnd = clBlack
          TrackMixPn.Slider.Min = -50
          TrackMixPn.Slider.Max = 50
          TrackMixPn.Slider.Pos = 0
          TrackMixPn.Slider.Color = 10728638
          TrackMixPn.Slider.OnChange = TracksMixSliderChange_Event
          TrackMixPn.PrgrBarr.Left = 55
          TrackMixPn.PrgrBarr.Top = 91
          TrackMixPn.PrgrBarr.Width = 50
          TrackMixPn.PrgrBarr.Height = 300
          TrackMixPn.PrgrBarr.ColorFirst = 10283253
          TrackMixPn.PrgrBarr.ColorSecond = 1756138
          TrackMixPn.PrgrBarr.ColorThird = 1289930
          TrackMixPn.PrgrBarr.ColorEmpty = 16250098
          TrackMixPn.PrgrBarr.Min = 0
          TrackMixPn.PrgrBarr.Max = 100
          TrackMixPn.PrgrBarr.Pos = 100
          TrackMixPn.PrgrBarr.Color = 10728638
          TrackMixPn.Fader.Left = 5
          TrackMixPn.Fader.Top = 91
          TrackMixPn.Fader.Width = 50
          TrackMixPn.Fader.Height = 300
          TrackMixPn.Fader.ColorSlot = clBlack
          TrackMixPn.Fader.ColorLine = clWhite
          TrackMixPn.Fader.ColorTop = 13484214
          TrackMixPn.Fader.ColorBottom = 11903635
          TrackMixPn.Fader.Min = 0
          TrackMixPn.Fader.Max = 100
          TrackMixPn.Fader.Pos = 100
          TrackMixPn.Fader.Color = 10728638
          TrackMixPn.Fader.OnChange = TracksMixFaderChange_Event
          TrackMixPn.EffectCnt = <>
          TrackMixPn.Color = 10728638
        end
        item
          TrackMixPn.Left = 110
          TrackMixPn.Top = 0
          TrackMixPn.Width = 110
          TrackMixPn.Height = 416
          TrackMixPn.Caption = 'TRACK'
          TrackMixPn.Slider.Left = 5
          TrackMixPn.Slider.Top = 56
          TrackMixPn.Slider.Width = 100
          TrackMixPn.Slider.Height = 35
          TrackMixPn.Slider.Caption = 'Pan'
          TrackMixPn.Slider.ColorSlot = clWhite
          TrackMixPn.Slider.ColorBackGrnd = clBlack
          TrackMixPn.Slider.Min = -50
          TrackMixPn.Slider.Max = 50
          TrackMixPn.Slider.Pos = 0
          TrackMixPn.Slider.Color = 10728638
          TrackMixPn.Slider.OnChange = TracksMixSliderChange_Event
          TrackMixPn.PrgrBarr.Left = 55
          TrackMixPn.PrgrBarr.Top = 91
          TrackMixPn.PrgrBarr.Width = 50
          TrackMixPn.PrgrBarr.Height = 300
          TrackMixPn.PrgrBarr.ColorFirst = 10283253
          TrackMixPn.PrgrBarr.ColorSecond = 1756138
          TrackMixPn.PrgrBarr.ColorThird = 1289930
          TrackMixPn.PrgrBarr.ColorEmpty = 16250098
          TrackMixPn.PrgrBarr.Min = 0
          TrackMixPn.PrgrBarr.Max = 100
          TrackMixPn.PrgrBarr.Pos = 100
          TrackMixPn.PrgrBarr.Color = 10728638
          TrackMixPn.Fader.Left = 5
          TrackMixPn.Fader.Top = 91
          TrackMixPn.Fader.Width = 50
          TrackMixPn.Fader.Height = 300
          TrackMixPn.Fader.ColorSlot = clBlack
          TrackMixPn.Fader.ColorLine = clWhite
          TrackMixPn.Fader.ColorTop = 13484214
          TrackMixPn.Fader.ColorBottom = 11903635
          TrackMixPn.Fader.Min = 0
          TrackMixPn.Fader.Max = 100
          TrackMixPn.Fader.Pos = 100
          TrackMixPn.Fader.Color = 10728638
          TrackMixPn.Fader.OnChange = TracksMixFaderChange_Event
          TrackMixPn.EffectCnt = <>
          TrackMixPn.Color = 10728638
        end
        item
          TrackMixPn.Left = 220
          TrackMixPn.Top = 0
          TrackMixPn.Width = 110
          TrackMixPn.Height = 416
          TrackMixPn.Caption = 'TRACK'
          TrackMixPn.Slider.Left = 5
          TrackMixPn.Slider.Top = 56
          TrackMixPn.Slider.Width = 100
          TrackMixPn.Slider.Height = 35
          TrackMixPn.Slider.Caption = 'Pan'
          TrackMixPn.Slider.ColorSlot = clWhite
          TrackMixPn.Slider.ColorBackGrnd = clBlack
          TrackMixPn.Slider.Min = -50
          TrackMixPn.Slider.Max = 50
          TrackMixPn.Slider.Pos = 0
          TrackMixPn.Slider.Color = 10728638
          TrackMixPn.Slider.OnChange = TracksMixSliderChange_Event
          TrackMixPn.PrgrBarr.Left = 55
          TrackMixPn.PrgrBarr.Top = 91
          TrackMixPn.PrgrBarr.Width = 50
          TrackMixPn.PrgrBarr.Height = 300
          TrackMixPn.PrgrBarr.ColorFirst = 10283253
          TrackMixPn.PrgrBarr.ColorSecond = 1756138
          TrackMixPn.PrgrBarr.ColorThird = 1289930
          TrackMixPn.PrgrBarr.ColorEmpty = 16250098
          TrackMixPn.PrgrBarr.Min = 0
          TrackMixPn.PrgrBarr.Max = 100
          TrackMixPn.PrgrBarr.Pos = 100
          TrackMixPn.PrgrBarr.Color = 10728638
          TrackMixPn.Fader.Left = 5
          TrackMixPn.Fader.Top = 91
          TrackMixPn.Fader.Width = 50
          TrackMixPn.Fader.Height = 300
          TrackMixPn.Fader.ColorSlot = clBlack
          TrackMixPn.Fader.ColorLine = clWhite
          TrackMixPn.Fader.ColorTop = 13484214
          TrackMixPn.Fader.ColorBottom = 11903635
          TrackMixPn.Fader.Min = 0
          TrackMixPn.Fader.Max = 100
          TrackMixPn.Fader.Pos = 100
          TrackMixPn.Fader.Color = 10728638
          TrackMixPn.Fader.OnChange = TracksMixFaderChange_Event
          TrackMixPn.EffectCnt = <>
          TrackMixPn.Color = 10728638
        end
        item
          TrackMixPn.Left = 330
          TrackMixPn.Top = 0
          TrackMixPn.Width = 110
          TrackMixPn.Height = 416
          TrackMixPn.Caption = 'TRACK'
          TrackMixPn.Slider.Left = 5
          TrackMixPn.Slider.Top = 56
          TrackMixPn.Slider.Width = 100
          TrackMixPn.Slider.Height = 35
          TrackMixPn.Slider.Caption = 'Pan'
          TrackMixPn.Slider.ColorSlot = clWhite
          TrackMixPn.Slider.ColorBackGrnd = clBlack
          TrackMixPn.Slider.Min = -50
          TrackMixPn.Slider.Max = 50
          TrackMixPn.Slider.Pos = 0
          TrackMixPn.Slider.Color = 10728638
          TrackMixPn.Slider.OnChange = TracksMixSliderChange_Event
          TrackMixPn.PrgrBarr.Left = 55
          TrackMixPn.PrgrBarr.Top = 91
          TrackMixPn.PrgrBarr.Width = 50
          TrackMixPn.PrgrBarr.Height = 300
          TrackMixPn.PrgrBarr.ColorFirst = 10283253
          TrackMixPn.PrgrBarr.ColorSecond = 1756138
          TrackMixPn.PrgrBarr.ColorThird = 1289930
          TrackMixPn.PrgrBarr.ColorEmpty = 16250098
          TrackMixPn.PrgrBarr.Min = 0
          TrackMixPn.PrgrBarr.Max = 100
          TrackMixPn.PrgrBarr.Pos = 100
          TrackMixPn.PrgrBarr.Color = 10728638
          TrackMixPn.Fader.Left = 5
          TrackMixPn.Fader.Top = 91
          TrackMixPn.Fader.Width = 50
          TrackMixPn.Fader.Height = 300
          TrackMixPn.Fader.ColorSlot = clBlack
          TrackMixPn.Fader.ColorLine = clWhite
          TrackMixPn.Fader.ColorTop = 13484214
          TrackMixPn.Fader.ColorBottom = 11903635
          TrackMixPn.Fader.Min = 0
          TrackMixPn.Fader.Max = 100
          TrackMixPn.Fader.Pos = 100
          TrackMixPn.Fader.Color = 10728638
          TrackMixPn.Fader.OnChange = TracksMixFaderChange_Event
          TrackMixPn.EffectCnt = <>
          TrackMixPn.Color = 10728638
        end
        item
          TrackMixPn.Left = 440
          TrackMixPn.Top = 0
          TrackMixPn.Width = 110
          TrackMixPn.Height = 416
          TrackMixPn.Caption = 'TRACK'
          TrackMixPn.Slider.Left = 5
          TrackMixPn.Slider.Top = 56
          TrackMixPn.Slider.Width = 100
          TrackMixPn.Slider.Height = 35
          TrackMixPn.Slider.Caption = 'Pan'
          TrackMixPn.Slider.ColorSlot = clWhite
          TrackMixPn.Slider.ColorBackGrnd = clBlack
          TrackMixPn.Slider.Min = -50
          TrackMixPn.Slider.Max = 50
          TrackMixPn.Slider.Pos = 0
          TrackMixPn.Slider.Color = 10728638
          TrackMixPn.Slider.OnChange = TracksMixSliderChange_Event
          TrackMixPn.PrgrBarr.Left = 55
          TrackMixPn.PrgrBarr.Top = 91
          TrackMixPn.PrgrBarr.Width = 50
          TrackMixPn.PrgrBarr.Height = 300
          TrackMixPn.PrgrBarr.ColorFirst = 10283253
          TrackMixPn.PrgrBarr.ColorSecond = 1756138
          TrackMixPn.PrgrBarr.ColorThird = 1289930
          TrackMixPn.PrgrBarr.ColorEmpty = 16250098
          TrackMixPn.PrgrBarr.Min = 0
          TrackMixPn.PrgrBarr.Max = 100
          TrackMixPn.PrgrBarr.Pos = 100
          TrackMixPn.PrgrBarr.Color = 10728638
          TrackMixPn.Fader.Left = 5
          TrackMixPn.Fader.Top = 91
          TrackMixPn.Fader.Width = 50
          TrackMixPn.Fader.Height = 300
          TrackMixPn.Fader.ColorSlot = clBlack
          TrackMixPn.Fader.ColorLine = clWhite
          TrackMixPn.Fader.ColorTop = 13484214
          TrackMixPn.Fader.ColorBottom = 11903635
          TrackMixPn.Fader.Min = 0
          TrackMixPn.Fader.Max = 100
          TrackMixPn.Fader.Pos = 100
          TrackMixPn.Fader.Color = 10728638
          TrackMixPn.Fader.OnChange = TracksMixFaderChange_Event
          TrackMixPn.EffectCnt = <>
          TrackMixPn.Color = 10728638
        end>
      Solo_Event = TracksMixSolo_Event
      Mute_Event = TracksMixMute_Event
      Panel_Event = TracksMixPanel_Event
      EffectClick = TracksMixEffectClick
      SliderChange_Event = TracksMixSliderChange_Event
      FaderChange_Event = TracksMixFaderChange_Event
      OnClick = TracksMixClick
    end
  end
  object MixPanel_Pn: TPanel
    Left = 0
    Top = 0
    Width = 119
    Height = 420
    AutoSize = True
    BevelInner = bvLowered
    Color = 10728638
    TabOrder = 1
    object MixPanel: TMixPanel
      Left = 2
      Top = 2
      Width = 115
      Height = 416
      Color = 10728638
      SoundFont.Left = 5
      SoundFont.Top = 106
      SoundFont.Width = 105
      SoundFont.Height = 45
      SoundFont.Style = lbOwnerDrawFixed
      SoundFont.Color = 13358554
      SoundFont.ItemHeight = 16
      SoundFont.TabOrder = 2
      VSTI.Left = 5
      VSTI.Top = 171
      VSTI.Width = 105
      VSTI.Height = 45
      VSTI.Style = lbOwnerDrawFixed
      VSTI.Color = 13358554
      VSTI.ItemHeight = 16
      VSTI.TabOrder = 4
      VSTE.Left = 5
      VSTE.Top = 236
      VSTE.Width = 105
      VSTE.Height = 45
      VSTE.Style = lbOwnerDrawFixed
      VSTE.Color = 13358554
      VSTE.ItemHeight = 16
      VSTE.TabOrder = 6
      DSP.Left = 5
      DSP.Top = 301
      DSP.Width = 105
      DSP.Height = 45
      DSP.Style = lbOwnerDrawFixed
      DSP.Color = 13358554
      DSP.ItemHeight = 16
      DSP.Items.Strings = (
        'Echo'
        'Flanger'
        'Volume'
        'Reverb'
        'LowPassFilter'
        'Amplification'
        'AutoWah'
        'Echo2'
        'Phaser'
        'Echo3'
        'Chorus'
        'AllPassFilter'
        'Compressor'
        'Distortion')
      DSP.TabOrder = 8
      EQUALIZER.Left = 5
      EQUALIZER.Top = 366
      EQUALIZER.Width = 105
      EQUALIZER.Height = 45
      EQUALIZER.Style = lbOwnerDrawFixed
      EQUALIZER.Color = 13358554
      EQUALIZER.ItemHeight = 16
      EQUALIZER.Items.Strings = (
        '10 Bandes')
      EQUALIZER.TabOrder = 10
      SelectedColor = clBlack
      ListBoxColor = 13358554
      PanelColor = 1289930
      AddMixPnButton.Left = 8
      AddMixPnButton.Top = 56
      AddMixPnButton.Width = 42
      AddMixPnButton.Height = 28
      AddMixPnButton.ColorLine = 4311507
      AddMixPnButton.ColorTop = 16770785
      AddMixPnButton.ColorBottom = 15263976
      AddMixPnButton.OnClick = MixPanelAddMixPnBtClick
      AddMixPnButton.Caption = 'A'
      AddMixPnButton.Font.Charset = DEFAULT_CHARSET
      AddMixPnButton.Font.Color = clWindowText
      AddMixPnButton.Font.Height = -19
      AddMixPnButton.Font.Name = 'MS Sans Serif'
      AddMixPnButton.Font.Style = [fsBold]
      DelMixPnButton.Left = 63
      DelMixPnButton.Top = 56
      DelMixPnButton.Width = 42
      DelMixPnButton.Height = 28
      DelMixPnButton.ColorLine = 4311507
      DelMixPnButton.ColorTop = 16770785
      DelMixPnButton.ColorBottom = 15263976
      DelMixPnButton.OnClick = MixPanelDelMixPnBtClick
      DelMixPnButton.Caption = 'D'
      DelMixPnButton.Font.Charset = DEFAULT_CHARSET
      DelMixPnButton.Font.Color = clWindowText
      DelMixPnButton.Font.Height = -19
      DelMixPnButton.Font.Name = 'MS Sans Serif'
      DelMixPnButton.Font.Style = [fsBold]
    end
  end
  object MasterMix_Pn: TPanel
    Left = 672
    Top = 0
    Width = 114
    Height = 424
    BevelInner = bvLowered
    Color = 10728638
    TabOrder = 2
    object MasterMix: TMasterMix
      Left = 2
      Top = 0
      Width = 110
      Height = 416
      Caption = 'MASTER'
      Slider.Left = 5
      Slider.Top = 56
      Slider.Width = 100
      Slider.Height = 35
      Slider.Caption = 'Pan'
      Slider.ColorSlot = clWhite
      Slider.ColorBackGrnd = clBlack
      Slider.Min = -50
      Slider.Max = 50
      Slider.Pos = 0
      Slider.Color = 10728638
      Slider.OnChange = MasterMixSliderChange
      PrgrBar.Left = 55
      PrgrBar.Top = 91
      PrgrBar.Width = 50
      PrgrBar.Height = 300
      PrgrBar.ColorFirst = 10283253
      PrgrBar.ColorSecond = 1756138
      PrgrBar.ColorThird = 1289930
      PrgrBar.ColorEmpty = 16250098
      PrgrBar.Min = 0
      PrgrBar.Max = 100
      PrgrBar.Pos = 100
      PrgrBar.Color = 10728638
      Fader.Left = 5
      Fader.Top = 91
      Fader.Width = 50
      Fader.Height = 300
      Fader.ColorSlot = clBlack
      Fader.ColorLine = clWhite
      Fader.ColorTop = 13484214
      Fader.ColorBottom = 11903635
      Fader.Min = 0
      Fader.Max = 100
      Fader.Pos = 100
      Fader.Color = 10728638
      Fader.OnChange = MasterMixFaderChange
      Color = 10728638
    end
  end
end
