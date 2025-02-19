unit UfrmAddressEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBaseEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TfrmAddressEdit = class(TfrmBaseEdit)
    edIRSZ: TLabeledEdit;
    edTelepules: TLabeledEdit;
    edUtca: TLabeledEdit;
    edHazszam: TLabeledEdit;
    edCimtipus: TLabeledEdit;
    procedure acSaveExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
  private
    { Private declarations }
    FTelepules    : string;
    FHazszam      : string;
    FIranyitoszam : string;
    FCimTipus     : string;
    FUtca         : string;
    procedure SetCimTipus(const Value: string);
    procedure SetHazszam(const Value: string);
    procedure SetIranyitoszam(const Value: string);
    procedure SetTelepules(const Value: string);
    procedure SetUtca(const Value: string);
    function ValidateAddressData(var AError : string) : Boolean;
    function SaveCimAdat(var AError : string) : Boolean;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    constructor CreateWithParams(AOwner : TComponent; ADBConnectionLink : TFDConnection); virtual;

    procedure SetupForm; override;

    property CimTipus : string read FCimTipus write SetCimTipus;
    property Iranyitoszam : string read FIranyitoszam write SetIranyitoszam;
    property Telepules : string read FTelepules write SetTelepules;
    property Utca : string read FUtca write SetUtca;
    property Hazszam : string read FHazszam write SetHazszam;
  end;

var
  frmAddressEdit: TfrmAddressEdit;

implementation

{$R *.dfm}

{ TfrmAddressEdit }

procedure TfrmAddressEdit.acExitExecute(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TfrmAddressEdit.acSaveExecute(Sender: TObject);
var
  error : string;
begin
  error := '';
  ModalResult := mrNone;
  if not ValidateAddressData(error) then
    begin
      Application.MessageBox(PChar(error), PChar('Adat rögzítési hiba'), MB_OK + MB_ICONERROR);
      ModalResult := mrNone;
      Exit;
    end;
  if not SaveCimAdat(error) then
    begin
      Application.MessageBox(PChar(error), PChar('Adat rögzítési hiba'), MB_OK + MB_ICONERROR);
      ModalResult := mrNone;
      Exit;
    end;
  ModalResult := mrOk;
end;

constructor TfrmAddressEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTelepules := '';
  FHazszam := '';
  FIranyitoszam := '';
  FCimTipus := '';
  FUtca := '';
end;

constructor TfrmAddressEdit.CreateWithParams(AOwner: TComponent;
  ADBConnectionLink: TFDConnection);
begin
  inherited CreateWithParams(AOwner, ADBConnectionLink);
  FTelepules := '';
  FHazszam := '';
  FIranyitoszam := '';
  FCimTipus := '';
  FUtca := '';
end;

function TfrmAddressEdit.SaveCimAdat(var AError: string): Boolean;
begin
  Result := True;
  AError := '';
  try
    if FIranyitoszam.IsEmpty then
      begin
        // INSERT lesz
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('INSERT INTO CIM (LAKCIMAZON, CIMTIPUS, IRANYITOSZAM, TELEPULES, UTCA, HAZSZAM)');
        FDQuery1.SQL.Add('VALUES (:lakcimazon, :cimtipus, :iranyitoszam, :telepules, :utca, :hazszam)');
        FDQuery1.ParamByName('lakcimazon').AsString := ID_String;
        FDQuery1.ParamByName('cimtipus').AsString := edCimtipus.Text;
        FDQuery1.ParamByName('iranyitoszam').AsString := edIRSZ.Text;
        FDQuery1.ParamByName('telepules').AsString := edTelepules.Text;
        FDQuery1.ParamByName('utca').AsString := edUtca.Text;
        FDQuery1.ParamByName('hazszam').AsString := edHazszam.Text;
        FDQuery1.ExecSQL;
      end
    else
      begin
        // UPDATE lesz
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('UPDATE CIM');
        FDQuery1.SQL.Add('SET CIMTIPUS=:cimtipus, IRANYITOSZAM=:iranyitoszam, TELEPULES=:telepules, UTCA=:utca, HAZSZAM=:hazszam');
        FDQuery1.SQL.Add('WHERE LAKCIMAZON=:lakcimazon AND CIMTIPUS=:cimtipus_old AND IRANYITOSZAM=:iranyitoszam_old AND TELEPULES=:telepules_old AND UTCA=:utca_old AND HAZSZAM=:hazszam_old');
        FDQuery1.ParamByName('lakcimazon').AsString := ID_String;
        FDQuery1.ParamByName('cimtipus').AsString := edCimtipus.Text;
        FDQuery1.ParamByName('iranyitoszam').AsString := edIRSZ.Text;
        FDQuery1.ParamByName('telepules').AsString := edTelepules.Text;
        FDQuery1.ParamByName('utca').AsString := edUtca.Text;
        FDQuery1.ParamByName('hazszam').AsString := edHazszam.Text;

        FDQuery1.ParamByName('cimtipus_old').AsString := FCimTipus;
        FDQuery1.ParamByName('iranyitoszam_old').AsString := FIranyitoszam;
        FDQuery1.ParamByName('telepules_old').AsString := FTelepules;
        FDQuery1.ParamByName('utca_old').AsString := FUtca;
        FDQuery1.ParamByName('hazszam_old').AsString := FHazszam;

        FDQuery1.ExecSQL;
      end;

  except
    on E: Exception do
      begin
        Result := False;
        AError := 'Hiba történt az adatok rögzítése közben, hiba: ' + E.Message;
      end;
  end;
end;

procedure TfrmAddressEdit.SetCimTipus(const Value: string);
begin
  FCimTipus := Value;
  edCimtipus.Text := FCimTipus;
end;

procedure TfrmAddressEdit.SetHazszam(const Value: string);
begin
  FHazszam := Value;
  edHazszam.Text := FHazszam;
end;

procedure TfrmAddressEdit.SetIranyitoszam(const Value: string);
begin
  FIranyitoszam := Value;
  edIRSZ.Text := FIranyitoszam;
end;

procedure TfrmAddressEdit.SetTelepules(const Value: string);
begin
  FTelepules := Value;
  edTelepules.Text := FTelepules;
end;

procedure TfrmAddressEdit.SetupForm;
begin
  //

end;

procedure TfrmAddressEdit.SetUtca(const Value: string);
begin
  FUtca := Value;
  edUtca.Text := FUtca;
end;

function TfrmAddressEdit.ValidateAddressData(var AError: string): Boolean;
var
  s : string;
begin
  Result := True;
  AError := '';
  s := edIRSZ.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Irányítószám mezõ nincs kitöltve';
      Exit;
    end;

  s := edTelepules.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Település mezõ nincs kitöltve';
      Exit;
    end;

  s := edUtca.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Utca mezõ nincs kitöltve';
      Exit;
    end;

  s := edHazszam.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Házszám mezõ nincs kitöltve';
      Exit;
    end;

  s := edCimtipus.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Cím típus mezõ nincs kitöltve';
      Exit;
    end;
end;

end.
