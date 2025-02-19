inherited frmPersonEdit: TfrmPersonEdit
  Caption = 'frmPersonEdit'
  ClientHeight = 559
  ClientWidth = 519
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 535
  ExplicitHeight = 598
  TextHeight = 15
  inherited tbrMenuSor: TToolBar
    Width = 519
  end
  object gbxPersonBase: TGroupBox [1]
    Left = 0
    Top = 55
    Width = 519
    Height = 122
    Align = alTop
    Caption = 'Szem'#233'ly alap adatok'
    TabOrder = 1
    object edVezeteknev: TLabeledEdit
      Left = 13
      Top = 37
      Width = 188
      Height = 23
      EditLabel.Width = 58
      EditLabel.Height = 15
      EditLabel.Caption = 'Vezet'#233'kn'#233'v'
      TabOrder = 0
      Text = ''
    end
    object edKeresztnev: TLabeledEdit
      Left = 207
      Top = 37
      Width = 188
      Height = 23
      EditLabel.Width = 56
      EditLabel.Height = 15
      EditLabel.Caption = 'Keresztn'#233'v'
      TabOrder = 1
      Text = ''
    end
    object edSzemelyiAzon: TLabeledEdit
      Left = 13
      Top = 85
      Width = 121
      Height = 23
      EditLabel.Width = 102
      EditLabel.Height = 15
      EditLabel.Caption = 'Szem'#233'lyi Azonos'#237't'#243
      TabOrder = 2
      Text = ''
    end
    object edLakcimAzon: TLabeledEdit
      Left = 140
      Top = 85
      Width = 121
      Height = 23
      EditLabel.Width = 94
      EditLabel.Height = 15
      EditLabel.Caption = 'Lakcim Azonos'#237't'#243
      TabOrder = 3
      Text = ''
    end
  end
  object gbxPersonAddressDetail: TGroupBox [2]
    Left = 0
    Top = 177
    Width = 519
    Height = 186
    Align = alTop
    Caption = 'C'#237'm adatok'
    TabOrder = 2
    ExplicitTop = 183
    ExplicitWidth = 449
    object lvAddress: TListView
      AlignWithMargins = True
      Left = 5
      Top = 75
      Width = 509
      Height = 106
      Align = alClient
      Columns = <
        item
          Caption = 'IRSZ'
        end
        item
          Caption = 'Telep'#252'l'#233's'
          Width = 100
        end
        item
          Caption = 'Utca'
          Width = 140
        end
        item
          Caption = 'H'#225'zsz'#225'm'
          Width = 60
        end
        item
          Caption = 'C'#237'm t'#237'pus'
          Width = 70
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitLeft = 3
      ExplicitTop = 85
      ExplicitWidth = 484
      ExplicitHeight = 112
    end
    object ToolBar1: TToolBar
      Left = 2
      Top = 17
      Width = 515
      Height = 55
      ButtonHeight = 54
      ButtonWidth = 54
      DisabledImages = UjIkonok32disabled
      Images = UjIkonok32
      ShowCaptions = True
      TabOrder = 1
      ExplicitLeft = 4
      ExplicitTop = 25
      object ToolButton2: TToolButton
        Left = 0
        Top = 0
        Action = acInsertAddr
      end
      object ToolButton4: TToolButton
        Left = 54
        Top = 0
        Action = acEditAddr
      end
      object ToolButton3: TToolButton
        Left = 108
        Top = 0
        Action = acDeleteAddr
      end
    end
  end
  object gbxPersonPhone: TGroupBox [3]
    Left = 0
    Top = 363
    Width = 519
    Height = 182
    Align = alTop
    Caption = 'El'#233'rhet'#337's'#233'gek'
    TabOrder = 3
    object lvPersonPhone: TListView
      AlignWithMargins = True
      Left = 5
      Top = 75
      Width = 509
      Height = 102
      Align = alClient
      Columns = <
        item
          Caption = 'El'#233'rhet'#337's'#233'g'
          Width = 170
        end
        item
          Caption = 'T'#237'pus'
          Width = 120
        end>
      GridLines = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      ExplicitLeft = 3
      ExplicitTop = 78
      ExplicitWidth = 301
      ExplicitHeight = 101
    end
    object ToolBar2: TToolBar
      Left = 2
      Top = 17
      Width = 515
      Height = 55
      ButtonHeight = 54
      ButtonWidth = 65
      DisabledImages = UjIkonok32disabled
      Images = UjIkonok32
      ShowCaptions = True
      TabOrder = 1
      ExplicitLeft = 4
      ExplicitTop = 25
      object ToolButton5: TToolButton
        Left = 0
        Top = 0
        Action = avInsertPhone
      end
      object ToolButton6: TToolButton
        Left = 65
        Top = 0
        Action = acEditPhone
      end
      object ToolButton7: TToolButton
        Left = 130
        Top = 0
        Action = acDeletePhone
      end
    end
  end
  inherited alCommands: TActionList
    inherited acExit: TAction
      Category = 'SzemelyAdat'
      OnExecute = acExitExecute
    end
    inherited acSave: TAction
      Category = 'SzemelyAdat'
      OnExecute = acSaveExecute
    end
    object acInsertAddr: TAction
      Category = 'CimAdat'
      Caption = #218'j...'
      ImageIndex = 77
      OnExecute = acInsertAddrExecute
      OnUpdate = acInsertAddrUpdate
    end
    object acEditAddr: TAction
      Category = 'CimAdat'
      Caption = 'Szerkeszt'
      ImageIndex = 81
      OnExecute = acEditAddrExecute
      OnUpdate = acEditAddrUpdate
    end
    object acDeleteAddr: TAction
      Category = 'CimAdat'
      Caption = 'T'#246'r'#246'l'
      ImageIndex = 109
      OnExecute = acDeleteAddrExecute
      OnUpdate = acDeleteAddrUpdate
    end
    object avInsertPhone: TAction
      Category = 'Elerhet'#337's'#233'g'
      Caption = #218'j...'
      ImageIndex = 77
      OnExecute = avInsertPhoneExecute
      OnUpdate = avInsertPhoneUpdate
    end
    object acEditPhone: TAction
      Category = 'Elerhet'#337's'#233'g'
      Caption = 'Szerkeszt'#233's'
      ImageIndex = 81
      OnExecute = acEditPhoneExecute
      OnUpdate = acEditPhoneUpdate
    end
    object acDeletePhone: TAction
      Category = 'Elerhet'#337's'#233'g'
      Caption = 'T'#246'rl'#233's'
      ImageIndex = 109
      OnExecute = acDeletePhoneExecute
      OnUpdate = acDeletePhoneUpdate
    end
  end
end
