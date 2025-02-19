unit UfrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Comp.Client,
  UCSVModule, System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList,
  Vcl.ComCtrls, Vcl.ToolWin;

type
  TfrmMain = class(TForm)
    dlgOpenCSV: TOpenDialog;
    Memo1: TMemo;
    UjIkonok32: TImageList;
    UjIkonok32disabled: TImageList;
    tbrMenuSor: TToolBar;
    btnKilep: TToolButton;
    btnKilepSeparator: TToolButton;
    alCommands: TActionList;
    acExit: TAction;
    acPersonList: TAction;
    ToolButton1: TToolButton;
    acCSVImport: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    procedure acExitExecute(Sender: TObject);
    procedure acCSVImportExecute(Sender: TObject);
    procedure acPersonListExecute(Sender: TObject);
  private
    { Private declarations }
    FCSVImport        : TCSVModule;
    FDBConnectionLink : TFDConnection;
    procedure OpenDBConnection;
    procedure SetDBConnectionLink(const Value: TFDConnection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property DBConnectionLink : TFDConnection read FDBConnectionLink write SetDBConnectionLink;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  System.StrUtils, System.Types, UfrmPersonList;

{$R *.dfm}

procedure TfrmMain.acCSVImportExecute(Sender: TObject);
var
  res : Integer;
begin
  if dlgOpenCSV.Execute then
    begin
      res := FCSVImport.ImportCSV(dlgOpenCSV.FileName);
      if res = IMPORT_RES_OK then
        Application.MessageBox(PChar('Az import sikeres'), PChar('Siker'), MB_OK or MB_ICONINFORMATION)
      else
        Application.MessageBox(PChar('Az import NEM sikerült'), PChar('Hiba'), MB_OK or MB_ICONERROR);
    end;
end;

procedure TfrmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.acPersonListExecute(Sender: TObject);
begin
  if not Assigned(frmPersonList) then
    begin
      frmPersonList := TfrmPersonList.CreateWithParams(Self, DBConnectionLink);
    end;
  frmPersonList.WindowState := wsMaximized;
  frmPersonList.SetupForm;
  frmPersonList.ShowModal;
  frmPersonList.Free;
  frmPersonList := nil;
end;

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DBConnectionLink := nil;
  FCSVImport := TCSVModule.Create(Self);
  FCSVImport.DBConnectionLink := DBConnectionLink;
  OpenDBConnection;
end;

destructor TfrmMain.Destroy;
begin
  FCSVImport.Free;
  if DBConnectionLink.Connected then
    DBConnectionLink.Connected := False;
  DBConnectionLink := nil;
  inherited Destroy;
end;

procedure TfrmMain.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDBConnectionLink) then
    FDBConnectionLink := nil;
end;

procedure TfrmMain.OpenDBConnection;
begin
  if Assigned(DBConnectionLink) then
    begin
      if not DBConnectionLink.Connected then
        DBConnectionLink.Connected := True;
    end;
end;

procedure TfrmMain.SetDBConnectionLink(const Value: TFDConnection);
begin
  if Assigned(DBConnectionLink) then
    DBConnectionLink.RemoveFreeNotification(Self);

  FDBConnectionLink := Value;

  if Assigned(DBConnectionLink) then
    DBConnectionLink.FreeNotification(Self);

  if Assigned(FCSVImport) then
    FCSVImport.DBConnectionLink := DBConnectionLink;
  OpenDBConnection;
end;

end.
