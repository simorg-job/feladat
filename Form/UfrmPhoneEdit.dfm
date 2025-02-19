inherited frmPhoneEdit: TfrmPhoneEdit
  Caption = 'frmPhoneEdit'
  ClientHeight = 140
  ClientWidth = 411
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 427
  ExplicitHeight = 179
  TextHeight = 15
  inherited tbrMenuSor: TToolBar
    Width = 411
  end
  object edElerhetoseg: TLabeledEdit [1]
    Left = 8
    Top = 80
    Width = 264
    Height = 23
    EditLabel.Width = 61
    EditLabel.Height = 15
    EditLabel.Caption = 'El'#233'rhet'#337's'#233'g'
    TabOrder = 1
    Text = ''
  end
  object edElerhetosegTipus: TLabeledEdit [2]
    Left = 278
    Top = 80
    Width = 121
    Height = 23
    EditLabel.Width = 96
    EditLabel.Height = 15
    EditLabel.Caption = 'El'#233'rhet'#337's'#233'g t'#237'pusa'
    TabOrder = 2
    Text = ''
  end
  inherited alCommands: TActionList
    Left = 184
    Top = 24
    inherited acExit: TAction
      OnExecute = acExitExecute
    end
    inherited acSave: TAction
      OnExecute = acSaveExecute
    end
  end
end
