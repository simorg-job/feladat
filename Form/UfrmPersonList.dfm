inherited frmPersonList: TfrmPersonList
  Caption = 'frmPersonList'
  ClientHeight = 599
  ClientWidth = 954
  StyleElements = [seFont, seClient, seBorder]
  ExplicitLeft = 3
  ExplicitTop = 3
  ExplicitWidth = 970
  ExplicitHeight = 638
  TextHeight = 15
  object Splitter1: TSplitter [0]
    Left = 0
    Top = 317
    Width = 954
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = -35
  end
  inherited tbrMenuSor: TToolBar
    Width = 954
    ButtonWidth = 54
    ExplicitWidth = 622
    inherited btnKilep: TToolButton
      ExplicitWidth = 54
    end
    inherited btnKilepSeparator: TToolButton
      Left = 54
      ExplicitLeft = 54
    end
    object ToolButton1: TToolButton
      Left = 62
      Top = 0
      Action = acInsert
    end
    object ToolButton2: TToolButton
      Left = 116
      Top = 0
      Action = acEdit
    end
    object ToolButton3: TToolButton
      Left = 170
      Top = 0
      Action = acDelete
    end
  end
  inherited DBGrid1: TDBGrid
    Width = 954
    Height = 262
    DataSource = dsMaster
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
  end
  object pnlPersonDetail: TPanel [3]
    Left = 0
    Top = 320
    Width = 954
    Height = 279
    Align = alBottom
    Caption = 'pnlPersonDetail'
    ShowCaption = False
    TabOrder = 2
    object gbxPersonBase: TGroupBox
      Left = 8
      Top = 6
      Width = 809
      Height = 91
      Caption = 'Szem'#233'ly alap adatok'
      TabOrder = 0
      object edVezeteknev: TLabeledEdit
        Left = 5
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
        Left = 199
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
        Left = 393
        Top = 37
        Width = 121
        Height = 23
        EditLabel.Width = 102
        EditLabel.Height = 15
        EditLabel.Caption = 'Szem'#233'lyi Azonos'#237't'#243
        TabOrder = 2
        Text = ''
      end
      object edLakcimAzon: TLabeledEdit
        Left = 520
        Top = 37
        Width = 121
        Height = 23
        EditLabel.Width = 94
        EditLabel.Height = 15
        EditLabel.Caption = 'Lakcim Azonos'#237't'#243
        TabOrder = 3
        Text = ''
      end
    end
    object gbxPersonAddressDetail: TGroupBox
      Left = 8
      Top = 103
      Width = 449
      Height = 154
      Caption = 'C'#237'm adatok'
      TabOrder = 1
      object lvAddress: TListView
        AlignWithMargins = True
        Left = 5
        Top = 20
        Width = 439
        Height = 129
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
      end
    end
    object gbxPersonPhone: TGroupBox
      Left = 463
      Top = 103
      Width = 354
      Height = 154
      Caption = 'El'#233'rhet'#337's'#233'gek'
      TabOrder = 2
      object lvPersonPhone: TListView
        AlignWithMargins = True
        Left = 5
        Top = 20
        Width = 344
        Height = 129
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
        ExplicitLeft = 16
        ExplicitTop = 32
        ExplicitWidth = 305
        ExplicitHeight = 94
      end
    end
  end
  inherited FDQuery2: TFDQuery
    MasterSource = dsMaster
  end
  inherited alCommands: TActionList
    inherited acExit: TAction
      OnExecute = acExitExecute
    end
    object acInsert: TAction
      Caption = #218'j ...'
      ImageIndex = 77
      OnExecute = acInsertExecute
    end
    object acEdit: TAction
      Caption = 'Szerkeszt'
      ImageIndex = 80
      OnExecute = acEditExecute
    end
    object acDelete: TAction
      Caption = 'T'#246'r'#246'l'
      ImageIndex = 109
      OnExecute = acDeleteExecute
    end
  end
  object dsMaster: TDataSource
    DataSet = FDQuery1
    OnDataChange = dsMasterDataChange
    Left = 328
    Top = 192
  end
  object dsDetail: TDataSource
    DataSet = FDQuery2
    Left = 472
    Top = 248
  end
  object FDQuery3: TFDQuery
    Left = 472
    Top = 128
  end
  object FDQuery4: TFDQuery
    Left = 576
    Top = 136
  end
end
