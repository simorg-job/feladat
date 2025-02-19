unit UfrmPersonList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBaseList, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, Vcl.StdCtrls,
  UfrmPersonEdit,
  Vcl.Mask;

type
  TfrmPersonList = class(TfrmBaseList)
    dsMaster: TDataSource;
    pnlPersonDetail: TPanel;
    Splitter1: TSplitter;
    dsDetail: TDataSource;
    gbxPersonBase: TGroupBox;
    edVezeteknev: TLabeledEdit;
    edKeresztnev: TLabeledEdit;
    edSzemelyiAzon: TLabeledEdit;
    edLakcimAzon: TLabeledEdit;
    gbxPersonAddressDetail: TGroupBox;
    gbxPersonPhone: TGroupBox;
    lvAddress: TListView;
    lvPersonPhone: TListView;
    FDQuery3: TFDQuery;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    acInsert: TAction;
    acEdit: TAction;
    acDelete: TAction;
    FDQuery4: TFDQuery;
    procedure acExitExecute(Sender: TObject);
    procedure dsMasterDataChange(Sender: TObject; Field: TField);
    procedure acEditExecute(Sender: TObject);
    procedure acInsertExecute(Sender: TObject);
    procedure acDeleteExecute(Sender: TObject);
  private
    { Private declarations }
    FPersonEdit : TfrmPersonEdit;
    procedure FillUpPersonAddress;
    procedure FillUpPersonPhone;
    // a APersonID = -1, akkor insert mód, különben edit mód
    procedure EditPerson(APersonID : Integer);
    procedure DeletePerson(APersonID : Integer; ASzemelyiAzon, ALakcimAzon : string);
  protected
    procedure SetDBConnectionLink(const Value: TFDConnection); override;
  public
    { Public declarations }

    constructor Create(AOwner : TComponent); override;
    constructor CreateWithParams(AOwner : TComponent; ADBConnectionLink : TFDConnection); virtual;
    destructor Destroy; override;

    procedure SetupForm; override;
  end;

var
  frmPersonList: TfrmPersonList;

implementation

{$R *.dfm}

procedure TfrmPersonList.acDeleteExecute(Sender: TObject);
begin
  if (not dsMaster.DataSet.IsEmpty) then
    DeletePerson(dsMaster.DataSet.FieldByName('ID').AsInteger, dsMaster.DataSet.FieldByName('SZEMELYIAZON').AsString, dsMaster.DataSet.FieldByName('LAKCIMAZON').AsString);

end;

procedure TfrmPersonList.acEditExecute(Sender: TObject);
begin
  inherited;
  if (not dsMaster.DataSet.IsEmpty) then
    EditPerson(dsMaster.DataSet.FieldByName('ID').AsInteger)
  else
    EditPerson(-1);
end;

procedure TfrmPersonList.acExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmPersonList.acInsertExecute(Sender: TObject);
begin
  FPersonEdit.ID := -1;
  FPersonEdit.SetupForm;
  if FPersonEdit.ShowModal = mrOk then
    begin
      // frissíteni kell a fõ listát
    end;
  FDQuery1.Refresh;
end;

constructor TfrmPersonList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPersonEdit := TfrmPersonEdit.CreateWithParams(Self, DBConnectionLink);
end;

constructor TfrmPersonList.CreateWithParams(AOwner: TComponent;
  ADBConnectionLink: TFDConnection);
begin
  inherited CreateWithParams(AOwner, ADBConnectionLink);
  FPersonEdit := TfrmPersonEdit.CreateWithParams(Self, DBConnectionLink);
end;

procedure TfrmPersonList.DeletePerson(APersonID: Integer; ASzemelyiAzon,
  ALakcimAzon: string);

begin
  if (dsMaster.DataSet.IsEmpty) then
    Exit;
  try
    if FDQuery3.Active then
      FDQuery3.Active := False;

    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('DELETE FROM ELERHETOSEG');
    FDQuery4.SQL.Add('WHERE SZEMELYIAZON=:szemelyiazon');
    FDQuery4.ParamByName('szemelyiazon').AsString := ASzemelyiAzon;
    FDQuery4.ExecSQL;

    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('DELETE FROM CIM');
    FDQuery4.SQL.Add('WHERE LAKCIMAZON=:lakcimazon');
    FDQuery4.ParamByName('lakcimazon').AsString := ALakcimAzon;
    FDQuery4.ExecSQL;

    FDQuery4.SQL.Clear;
    FDQuery4.SQL.Add('DELETE FROM SZEMELY');
    FDQuery4.SQL.Add('WHERE ID=:id');
    FDQuery4.ParamByName('id').AsInteger := APersonID;
    FDQuery4.ExecSQL;

    FDQuery1.Refresh;
  except
    on E: Exception do
      begin
        Application.MessageBox(PChar('Hiba történt az adatok törlése közben, hiba: ' + E.Message), PChar('Törlési hiba'), MB_OK or MB_ICONERROR) ;
      end;
  end;
end;

destructor TfrmPersonList.Destroy;
begin
  FPersonEdit.Free;
  inherited Destroy;
end;

procedure TfrmPersonList.dsMasterDataChange(Sender: TObject; Field: TField);
begin
  if dsMaster.State in [dsBrowse] then
    begin
      edVezeteknev.Text := dsMaster.DataSet.FieldByName('VEZETEKNEV').AsString;
      edKeresztnev.Text := dsMaster.DataSet.FieldByName('KERESZTNEV').AsString;
      edSzemelyiAzon.Text := dsMaster.DataSet.FieldByName('SZEMELYIAZON').AsString;
      edLakcimAzon.Text := dsMaster.DataSet.FieldByName('LAKCIMAZON').AsString;
      FillUpPersonAddress;
      FillUpPersonPhone;
    end;
end;

procedure TfrmPersonList.EditPerson(APersonID: Integer);
begin
  FPersonEdit.ID := APersonID;
  FPersonEdit.SetupForm;
  if FPersonEdit.ShowModal = mrOk then
    begin
      // frissíteni kell a fõ listát
    end;
  FDQuery1.Refresh;
end;

procedure TfrmPersonList.FillUpPersonAddress;
var
  item  : TListItem;
begin
  try
    lvAddress.Items.BeginUpdate;
    lvAddress.Items.Clear;

    if not dsMaster.DataSet.IsEmpty then
      begin
        FDQuery2.Close;
        FDQuery2.ParamByName('lakcimazon').AsString := dsMaster.DataSet.FieldByName('LAKCIMAZON').AsString;
        FDQuery2.Open;
        FDQuery2.First;

        while (not FDQuery2.Eof) do
          begin
            item := lvAddress.Items.Add;
            item.Caption := FDQuery2.FieldByName('IRANYITOSZAM').AsString;
            item.SubItems.Add(FDQuery2.FieldByName('TELEPULES').AsString);
            item.SubItems.Add(FDQuery2.FieldByName('UTCA').AsString);
            item.SubItems.Add(FDQuery2.FieldByName('HAZSZAM').AsString);
            item.SubItems.Add(FDQuery2.FieldByName('CIMTIPUS').AsString);
            FDQuery2.Next;
          end;
      end;

  finally
    lvAddress.Items.EndUpdate;
  end;
end;

procedure TfrmPersonList.FillUpPersonPhone;
var
  item  : TListItem;
begin
  try
    lvPersonPhone.Items.BeginUpdate;
    lvPersonPhone.Items.Clear;

    if not dsMaster.DataSet.IsEmpty then
      begin
        FDQuery3.Close;
        FDQuery3.ParamByName('szemelyiazon').AsString := dsMaster.DataSet.FieldByName('SZEMELYIAZON').AsString;
        FDQuery3.Open;
        FDQuery3.First;

        while (not FDQuery3.Eof) do
          begin
            item := lvPersonPhone.Items.Add;
            item.Caption := FDQuery3.FieldByName('ELERHETOSEG').AsString;
            item.SubItems.Add(FDQuery3.FieldByName('ELERHETOSEGTIPUS').AsString);
            FDQuery3.Next;
          end;
      end;

  finally
    lvPersonPhone.Items.EndUpdate;
  end;
end;

procedure TfrmPersonList.SetDBConnectionLink(const Value: TFDConnection);
begin
  inherited SetDBConnectionLink(Value);
  FDQuery3.Connection := DBConnectionLink;
  FDQuery4.Connection := DBConnectionLink;
end;

procedure TfrmPersonList.SetupForm;
begin
  inherited;
  // query-k beállítása
  if FDQuery1.Active then
    FDQuery1.Active := False;

  FDQuery1.SQL.Clear;
  FDQuery1.SQL.Add('SELECT * FROM SZEMELY');

  if FDQuery2.Active then
    FDQuery2.Active := False;

  FDQuery2.SQL.Clear;
  FDQuery2.SQL.Add('SELECT CIMTIPUS, IRANYITOSZAM, TELEPULES, UTCA, HAZSZAM FROM CIM');
  FDQuery2.SQL.Add('WHERE LAKCIMAZON = :lakcimazon');

  if FDQuery3.Active then
    FDQuery3.Active := False;

  FDQuery3.SQL.Clear;
  FDQuery3.SQL.Add('SELECT ELERHETOSEGTIPUS, ELERHETOSEG FROM ELERHETOSEG');
  FDQuery3.SQL.Add('WHERE SZEMELYIAZON = :szemelyiazon');

  // fõ query nyitása
  FDQuery1.Open;
end;

end.
