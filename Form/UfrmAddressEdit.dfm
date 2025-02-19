inherited frmAddressEdit: TfrmAddressEdit
  Caption = 'frmAddressEdit'
  ClientHeight = 246
  ClientWidth = 438
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 454
  ExplicitHeight = 285
  TextHeight = 15
  inherited tbrMenuSor: TToolBar
    Width = 438
  end
  object edIRSZ: TLabeledEdit [1]
    Left = 8
    Top = 96
    Width = 57
    Height = 23
    EditLabel.Width = 23
    EditLabel.Height = 15
    EditLabel.Caption = 'IRSZ'
    TabOrder = 1
    Text = ''
  end
  object edTelepules: TLabeledEdit [2]
    Left = 71
    Top = 96
    Width = 354
    Height = 23
    EditLabel.Width = 49
    EditLabel.Height = 15
    EditLabel.Caption = 'Telep'#252'l'#233's'
    TabOrder = 2
    Text = ''
  end
  object edUtca: TLabeledEdit [3]
    Left = 8
    Top = 144
    Width = 321
    Height = 23
    EditLabel.Width = 24
    EditLabel.Height = 15
    EditLabel.Caption = 'Utca'
    TabOrder = 3
    Text = ''
  end
  object edHazszam: TLabeledEdit [4]
    Left = 335
    Top = 144
    Width = 90
    Height = 23
    EditLabel.Width = 47
    EditLabel.Height = 15
    EditLabel.Caption = 'H'#225'zsz'#225'm'
    TabOrder = 4
    Text = ''
  end
  object edCimtipus: TLabeledEdit [5]
    Left = 8
    Top = 192
    Width = 121
    Height = 23
    EditLabel.Width = 51
    EditLabel.Height = 15
    EditLabel.Caption = 'C'#237'm t'#237'pus'
    TabOrder = 5
    Text = ''
  end
  inherited FDQuery1: TFDQuery
    Left = 96
    Top = 128
  end
  inherited FDQuery2: TFDQuery
    Left = 296
    Top = 80
  end
  inherited UjIkonok32: TImageList
    Left = 176
    Top = 72
  end
  inherited UjIkonok32disabled: TImageList
    Left = 224
    Top = 152
  end
  inherited alCommands: TActionList
    inherited acExit: TAction
      OnExecute = acExitExecute
    end
    inherited acSave: TAction
      OnExecute = acSaveExecute
    end
  end
end
