object DM: TDM
  Height = 387
  Width = 486
  PixelsPerInch = 120
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\PROG\DelphiXE12\kesmarki_teszt_feladat\DB\TEST.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'CharacterSet=UTF8'
      'DriverID=FB')
    Transaction = FDTransaction1
    Left = 136
    Top = 96
  end
  object FDTransaction1: TFDTransaction
    Options.Isolation = xiReadCommitted
    Connection = FDConnection1
    Left = 272
    Top = 96
  end
end
