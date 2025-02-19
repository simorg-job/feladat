unit UfrmPhoneEdit;

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
  TfrmPhoneEdit = class(TfrmBaseEdit)
    edElerhetoseg: TLabeledEdit;
    edElerhetosegTipus: TLabeledEdit;
    procedure acSaveExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
  private
    { Private declarations }
    FElerhetosegTipusa: string;
    FElerhetoseg: string;
    procedure SetElerhetoseg(const Value: string);
    procedure SetElerhetosegTipusa(const Value: string);
    function ValidatePhoneData(var AError : string) : Boolean;
    function SaveElerhetosegAdat(var AError : string) : Boolean;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    constructor CreateWithParams(AOwner : TComponent; ADBConnectionLink : TFDConnection); virtual;

    property Elerhetoseg : string read FElerhetoseg write SetElerhetoseg;
    property ElerhetosegTipusa : string read FElerhetosegTipusa write SetElerhetosegTipusa;
  end;

var
  frmPhoneEdit: TfrmPhoneEdit;

implementation

{$R *.dfm}

{ TfrmPhoneEdit }

procedure TfrmPhoneEdit.acExitExecute(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TfrmPhoneEdit.acSaveExecute(Sender: TObject);
var
  error : string;
begin
  error := '';
  ModalResult := mrNone;
  if not ValidatePhoneData(error) then
    begin
      Application.MessageBox(PChar(error), PChar('Adat rögzítési hiba'), MB_OK + MB_ICONERROR);
      ModalResult := mrNone;
      Exit;
    end;
  if not SaveElerhetosegAdat(error) then
    begin
      Application.MessageBox(PChar(error), PChar('Adat rögzítési hiba'), MB_OK + MB_ICONERROR);
      ModalResult := mrNone;
      Exit;
    end;
  ModalResult := mrOk;
end;

constructor TfrmPhoneEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FElerhetosegTipusa := '';
  FElerhetoseg := '';
end;

constructor TfrmPhoneEdit.CreateWithParams(AOwner: TComponent;
  ADBConnectionLink: TFDConnection);
begin
  inherited CreateWithParams(AOwner, ADBConnectionLink);
  FElerhetosegTipusa := '';
  FElerhetoseg := '';
end;

function TfrmPhoneEdit.SaveElerhetosegAdat(var AError: string): Boolean;
begin
  Result := True;
  AError := '';
  try
    if FElerhetoseg.IsEmpty then
      begin
        // INSERT lesz
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('INSERT INTO ELERHETOSEG (SZEMELYIAZON, ELERHETOSEGTIPUS, ELERHETOSEG)');
        FDQuery1.SQL.Add('VALUES (:szemelyiazon, :elerhetosegtipus, :elerhetoseg)');
        FDQuery1.ParamByName('szemelyiazon').AsString := ID_String;
        FDQuery1.ParamByName('elerhetosegtipus').AsString := edElerhetosegTipus.Text;
        FDQuery1.ParamByName('elerhetoseg').AsString := edElerhetoseg.Text;
        FDQuery1.ExecSQL;
      end
    else
      begin
        // UPDATE lesz
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('UPDATE ELERHETOSEG');
        FDQuery1.SQL.Add('SET ELERHETOSEGTIPUS=:elerhetosegtipus, ELERHETOSEG=:elerhetoseg');
        FDQuery1.SQL.Add('WHERE SZEMELYIAZON=:szemelyiazon AND ELERHETOSEGTIPUS=:elerhetosegtipus_old AND ELERHETOSEG=:elerhetoseg_old');
        FDQuery1.ParamByName('szemelyiazon').AsString := ID_String;
        FDQuery1.ParamByName('elerhetosegtipus').AsString := edElerhetosegTipus.Text;
        FDQuery1.ParamByName('elerhetoseg').AsString := edElerhetoseg.Text;

        FDQuery1.ParamByName('elerhetosegtipus_old').AsString := FElerhetosegTipusa;
        FDQuery1.ParamByName('elerhetoseg_old').AsString := FElerhetoseg;

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

procedure TfrmPhoneEdit.SetElerhetoseg(const Value: string);
begin
  FElerhetoseg := Value;
  edElerhetoseg.Text := FElerhetoseg;
end;

procedure TfrmPhoneEdit.SetElerhetosegTipusa(const Value: string);
begin
  FElerhetosegTipusa := Value;
  edElerhetosegTipus.Text := FElerhetosegTipusa;
end;

function TfrmPhoneEdit.ValidatePhoneData(var AError: string): Boolean;
var
  s : string;
begin
  Result := True;
  AError := '';
  s := edElerhetoseg.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Elérhetõség mezõ nincs kitöltve';
      Exit;
    end;

  s := edElerhetosegTipus.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Elérhetõség típusa mezõ nincs kitöltve';
      Exit;
    end;
end;

end.
