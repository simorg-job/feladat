program teszt_feladat;

uses
  Vcl.Forms,
  UfrmMain in 'Form\UfrmMain.pas' {frmMain},
  UCSVModule in 'CSVModule\UCSVModule.pas',
  UDM in 'DataModule\UDM.pas' {DM: TDataModule},
  UfrmBase in 'Form\UfrmBase.pas' {frmBase},
  UfrmBaseList in 'Form\UfrmBaseList.pas' {frmBaseList},
  UfrmPersonList in 'Form\UfrmPersonList.pas' {frmPersonList},
  UfrmBaseEdit in 'Form\UfrmBaseEdit.pas' {frmBaseEdit},
  UfrmPersonEdit in 'Form\UfrmPersonEdit.pas' {frmPersonEdit},
  UfrmAddressEdit in 'Form\UfrmAddressEdit.pas' {frmAddressEdit},
  UfrmPhoneEdit in 'Form\UfrmPhoneEdit.pas' {frmPhoneEdit};

{$R *.res}

begin
  DM := TDM.Create(Application);
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmPhoneEdit, frmPhoneEdit);
  frmMain.DBConnectionLink := DM.FDConnection1;
  Application.Run;
end.
