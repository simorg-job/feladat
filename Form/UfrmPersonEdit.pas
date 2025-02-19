unit UfrmPersonEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBaseEdit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  System.Actions, Vcl.ActnList, System.ImageList, Vcl.ImgList, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.ComCtrls, Vcl.ToolWin,
  UfrmAddressEdit, UfrmPhoneEdit,
  Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls;

type
  TfrmPersonEdit = class(TfrmBaseEdit)
    gbxPersonBase: TGroupBox;
    edVezeteknev: TLabeledEdit;
    edKeresztnev: TLabeledEdit;
    edSzemelyiAzon: TLabeledEdit;
    edLakcimAzon: TLabeledEdit;
    gbxPersonAddressDetail: TGroupBox;
    lvAddress: TListView;
    gbxPersonPhone: TGroupBox;
    lvPersonPhone: TListView;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton4: TToolButton;
    acInsertAddr: TAction;
    acEditAddr: TAction;
    acDeleteAddr: TAction;
    ToolButton3: TToolButton;
    ToolBar2: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    avInsertPhone: TAction;
    acEditPhone: TAction;
    acDeletePhone: TAction;
    procedure acExitExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acEditAddrExecute(Sender: TObject);
    procedure acEditAddrUpdate(Sender: TObject);
    procedure acInsertAddrExecute(Sender: TObject);
    procedure acInsertAddrUpdate(Sender: TObject);
    procedure acDeleteAddrExecute(Sender: TObject);
    procedure acDeleteAddrUpdate(Sender: TObject);
    procedure acEditPhoneExecute(Sender: TObject);
    procedure avInsertPhoneExecute(Sender: TObject);
    procedure avInsertPhoneUpdate(Sender: TObject);
    procedure acEditPhoneUpdate(Sender: TObject);
    procedure acDeletePhoneExecute(Sender: TObject);
    procedure acDeletePhoneUpdate(Sender: TObject);
  private
    { Private declarations }
    FAddressEdit  : TfrmAddressEdit;
    FPhoneEdit    : TfrmPhoneEdit;

    procedure LoadAddressData(ALakcimAzon : string);
    procedure LoadPhoneData(ASzemelyiAzon : string);
    function ValidatePersonData(var AError : string) : Boolean;
    function CheckLakcimazon(ALakcimAzon : string) : Boolean;
    function CheckSzemelyiazon(ASzemelyiAzon : string) : Boolean;

    function SaveSzemelyAdat(var AError : string) : Boolean;
    procedure EditAddress(ACimTipus, AIranyitoszam, ATelepules, AUtca, AHazszam : string);
    procedure DeleteAddress(ACimTipus, AIranyitoszam, ATelepules, AUtca, AHazszam : string);

    procedure EditPhone(AElerhetoseg, AElerhetosegTipusa : string);
    procedure DeletePhone(AElerhetoseg, AElerhetosegTipusa : string);
  public
    { Public declarations }

    constructor Create(AOwner : TComponent); override;
    constructor CreateWithParams(AOwner : TComponent; ADBConnectionLink : TFDConnection); virtual;
    destructor Destroy; override;
    procedure SetupForm; override;
  end;

var
  frmPersonEdit: TfrmPersonEdit;

implementation

{$R *.dfm}

{ TfrmPersonEdit }

procedure TfrmPersonEdit.acDeleteAddrExecute(Sender: TObject);
var
  cimtipus  : string;
  irsz      : string;
  telepules : string;
  utca      : string;
  hazszam   : string;
begin
  if not Assigned(lvAddress.Selected) then
    Exit;
  irsz := lvAddress.Selected.Caption;
  telepules := lvAddress.Selected.SubItems[0];
  utca := lvAddress.Selected.SubItems[1];
  hazszam := lvAddress.Selected.SubItems[2];
  cimtipus := lvAddress.Selected.SubItems[3];

  DeleteAddress(cimtipus, irsz, telepules, utca, hazszam);
  LoadAddressData(ID_String);
end;

procedure TfrmPersonEdit.acDeleteAddrUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (lvAddress.Selected <> nil) and (ID > -1);
end;

procedure TfrmPersonEdit.acDeletePhoneExecute(Sender: TObject);
var
  elerhetoseg : string;
  elerhetosegtipusa : string;
begin
  if not Assigned(lvPersonPhone.Selected) then
    Exit;
  elerhetoseg := lvPersonPhone.Selected.Caption;
  elerhetosegtipusa := lvPersonPhone.Selected.SubItems[0];

  DeletePhone(elerhetoseg, elerhetosegtipusa);
  LoadPhoneData(ID_String2);

end;

procedure TfrmPersonEdit.acDeletePhoneUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (lvPersonPhone.Selected <> nil);
end;

procedure TfrmPersonEdit.acEditAddrExecute(Sender: TObject);
var
  cimtipus  : string;
  irsz      : string;
  telepules : string;
  utca      : string;
  hazszam   : string;
begin
  if not Assigned(lvAddress.Selected) then
    Exit;
  irsz := lvAddress.Selected.Caption;
  telepules := lvAddress.Selected.SubItems[0];
  utca := lvAddress.Selected.SubItems[1];
  hazszam := lvAddress.Selected.SubItems[2];
  cimtipus := lvAddress.Selected.SubItems[3];

  EditAddress(cimtipus, irsz, telepules, utca, hazszam);

end;

procedure TfrmPersonEdit.acEditAddrUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (lvAddress.Selected <> nil) and (ID > -1);
end;

procedure TfrmPersonEdit.acEditPhoneExecute(Sender: TObject);
var
  elerhetoseg : string;
  elerhetosegtipusa : string;
begin
  if not Assigned(lvPersonPhone.Selected) then
    Exit;
  elerhetoseg := lvAddress.Selected.Caption;
  elerhetosegtipusa := lvAddress.Selected.SubItems[0];

  EditPhone(elerhetoseg, elerhetosegtipusa);
end;

procedure TfrmPersonEdit.acEditPhoneUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (lvPersonPhone.Selected <> nil);
end;

procedure TfrmPersonEdit.acExitExecute(Sender: TObject);
begin
  ModalResult := mrClose;

end;

procedure TfrmPersonEdit.acInsertAddrExecute(Sender: TObject);
begin
  EditAddress('', '', '', '', '');
end;

procedure TfrmPersonEdit.acInsertAddrUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not ID_String.IsEmpty) and (ID > -1);
end;

procedure TfrmPersonEdit.acSaveExecute(Sender: TObject);
var
  error : string;
begin
  error := '';
  if not ValidatePersonData(error) then
    begin
      Application.MessageBox(PChar(error), PChar('Adat rögzítési hiba'), MB_OK + MB_ICONERROR);
      ModalResult := mrNone;
      Exit;
    end;
  if not SaveSzemelyAdat(error) then
    begin
      Application.MessageBox(PChar(error), PChar('Adat rögzítési hiba'), MB_OK + MB_ICONERROR);
      ModalResult := mrNone;
      Exit;
    end;
end;

procedure TfrmPersonEdit.avInsertPhoneExecute(Sender: TObject);
begin
  EditPhone('', '');
end;

procedure TfrmPersonEdit.avInsertPhoneUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (not ID_String2.IsEmpty);
end;

function TfrmPersonEdit.CheckLakcimazon(ALakcimAzon : string): Boolean;
begin
  Result := False;
  if FDQuery2.Active then
    FDQuery2.Active := False;

  FDQuery2.SQL.Clear;
  FDQuery2.SQL.Add('SELECT COUNT(*) AS cnt FROM SZEMELY');
  FDQuery2.SQL.Add('WHERE LAKCIMAZON=:lakcimazon');
  if (ID <> -1) then
    begin
      FDQuery2.SQL.Add(' AND ID <> :id');
      FDQuery2.ParamByName('id').AsInteger := ID;
    end;
  FDQuery2.ParamByName('lakcimazon').AsString := ALakcimAzon;

  FDQuery2.Open;
  FDQuery2.First;
  if FDQuery2.FieldByName('cnt').AsInteger = 0 then
    Result := True;
end;

function TfrmPersonEdit.CheckSzemelyiazon(ASzemelyiAzon: string): Boolean;
begin
  Result := False;
  if FDQuery2.Active then
    FDQuery2.Active := False;

  FDQuery2.SQL.Clear;
  FDQuery2.SQL.Add('SELECT COUNT(*) AS cnt FROM SZEMELY');
  FDQuery2.SQL.Add('WHERE SZEMELYIAZON=:szemelyiazon');
  if (ID <> -1) then
    begin
      FDQuery2.SQL.Add(' AND ID <> :id');
      FDQuery2.ParamByName('id').AsInteger := ID;
    end;
  FDQuery2.ParamByName('szemelyiazon').AsString := ASzemelyiAzon;

  FDQuery2.Open;
  FDQuery2.First;
  if FDQuery2.FieldByName('cnt').AsInteger = 0 then
    Result := True;
end;

constructor TfrmPersonEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAddressEdit := TfrmAddressEdit.CreateWithParams(Self, DBConnectionLink);
  FPhoneEdit := TfrmPhoneEdit.CreateWithParams(Self, DBConnectionLink);
end;

constructor TfrmPersonEdit.CreateWithParams(AOwner: TComponent;
  ADBConnectionLink: TFDConnection);
begin
  inherited CreateWithParams(AOwner, ADBConnectionLink);
  FAddressEdit := TfrmAddressEdit.CreateWithParams(Self, DBConnectionLink);
  FPhoneEdit := TfrmPhoneEdit.CreateWithParams(Self, DBConnectionLink);
end;

procedure TfrmPersonEdit.DeleteAddress(ACimTipus, AIranyitoszam, ATelepules,
  AUtca, AHazszam: string);
begin
  try
    if FDQuery1.Active then
      FDQuery1.Active := False;

    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('DELETE FROM CIM');
    FDQuery1.SQL.Add('WHERE LAKCIMAZON=:lakcimazon AND CIMTIPUS=:cimtipus AND IRANYITOSZAM=:iranyitoszam AND TELEPULES=:telepules AND UTCA=:utca AND HAZSZAM=:hazszam');
    FDQuery1.ParamByName('lakcimazon').AsString := ID_String;
    FDQuery1.ParamByName('cimtipus').AsString := ACimTipus;
    FDQuery1.ParamByName('iranyitoszam').AsString := AIranyitoszam;
    FDQuery1.ParamByName('telepules').AsString := ATelepules;
    FDQuery1.ParamByName('utca').AsString := AUtca;
    FDQuery1.ParamByName('hazszam').AsString := AHazszam;
    FDQuery1.ExecSQL;
  except
    on E: Exception do
      begin
        Application.MessageBox(PChar('Hiba történt az adatok törlése közben, hiba: ' + E.Message), PChar('Törlési hiba'), MB_OK or MB_ICONERROR) ;
      end;
  end;
end;

procedure TfrmPersonEdit.DeletePhone(AElerhetoseg, AElerhetosegTipusa: string);
begin
  try
    if FDQuery1.Active then
      FDQuery1.Active := False;

    FDQuery1.SQL.Clear;
    FDQuery1.SQL.Add('DELETE FROM ELERHETOSEG');
    FDQuery1.SQL.Add('WHERE SZEMELYIAZON=:szemelyiazon AND ELERHETOSEGTIPUS=:elerhetosegtipus AND ELERHETOSEG=:elerhetoseg');
    FDQuery1.ParamByName('szemelyiazon').AsString := ID_String2;
    FDQuery1.ParamByName('elerhetosegtipus').AsString := AElerhetosegTipusa;
    FDQuery1.ParamByName('elerhetoseg').AsString := AElerhetoseg;
    FDQuery1.ExecSQL;
  except
    on E: Exception do
      begin
        Application.MessageBox(PChar('Hiba történt az adatok törlése közben, hiba: ' + E.Message), PChar('Törlési hiba'), MB_OK or MB_ICONERROR) ;
      end;
  end;
end;

destructor TfrmPersonEdit.Destroy;
begin
  FAddressEdit.Free;
  FPhoneEdit.Free;
  inherited Destroy;
end;

procedure TfrmPersonEdit.EditAddress(ACimTipus, AIranyitoszam, ATelepules,
  AUtca, AHazszam: string);
begin
  FAddressEdit.ID := -1;
  FAddressEdit.ID_String := ID_String;  // ebben van a lakcím azonosító
  FAddressEdit.CimTipus := ACimTipus;
  FAddressEdit.Iranyitoszam := AIranyitoszam;
  FAddressEdit.Telepules := ATelepules;
  FAddressEdit.Utca := AUtca;
  FAddressEdit.Hazszam := AHazszam;
  // itt át kell adni az összes mezõt
  FAddressEdit.SetupForm;
  if FAddressEdit.ShowModal = mrOk then
    begin
      // frissíteni kell a fõ listát
    end;
  LoadAddressData(ID_String);
end;

procedure TfrmPersonEdit.EditPhone(AElerhetoseg, AElerhetosegTipusa: string);
begin
  FPhoneEdit.ID := -1;
  FPhoneEdit.ID_String := ID_String2;  // ebben van a személyi azonosító
  FPhoneEdit.Elerhetoseg := AElerhetoseg;
  FPhoneEdit.ElerhetosegTipusa := AElerhetosegTipusa;

  if FPhoneEdit.ShowModal = mrOk then
    begin
      // frissíteni kell a fõ listát
    end;
  LoadPhoneData(ID_String2);
end;

procedure TfrmPersonEdit.LoadAddressData(ALakcimAzon: string);
var
  item  : TListItem;
begin
  // betölti a lakcim adatokat
  try
    lvAddress.Items.BeginUpdate;
    lvAddress.Items.Clear;

    if not ALakcimAzon.IsEmpty then
      begin
        if FDQuery1.Active then
          FDQuery1.Active := False;

        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('SELECT CIMTIPUS, IRANYITOSZAM, TELEPULES, UTCA, HAZSZAM FROM CIM');
        FDQuery1.SQL.Add('WHERE LAKCIMAZON = :lakcimazon');
        FDQuery1.ParamByName('lakcimazon').AsString := ALakcimAzon;
        FDQuery1.Open;
        FDQuery1.First;

        while (not FDQuery1.Eof) do
          begin
            item := lvAddress.Items.Add;
            item.Caption := FDQuery1.FieldByName('IRANYITOSZAM').AsString;
            item.SubItems.Add(FDQuery1.FieldByName('TELEPULES').AsString);
            item.SubItems.Add(FDQuery1.FieldByName('UTCA').AsString);
            item.SubItems.Add(FDQuery1.FieldByName('HAZSZAM').AsString);
            item.SubItems.Add(FDQuery1.FieldByName('CIMTIPUS').AsString);
            FDQuery1.Next;
          end;
      end;

  finally
    lvAddress.Items.EndUpdate;
  end;
end;

procedure TfrmPersonEdit.LoadPhoneData(ASzemelyiAzon: string);
var
  item  : TListItem;
begin
  // betölti a telefon adatokat
  try
    lvPersonPhone.Items.BeginUpdate;
    lvPersonPhone.Items.Clear;

    if not ASzemelyiAzon.IsEmpty then
      begin
        if FDQuery1.Active then
          FDQuery1.Active := False;

        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('SELECT ELERHETOSEGTIPUS, ELERHETOSEG FROM ELERHETOSEG');
        FDQuery1.SQL.Add('WHERE SZEMELYIAZON = :szemelyiazon');
        FDQuery1.ParamByName('szemelyiazon').AsString := ASzemelyiAzon;
        FDQuery1.Open;
        FDQuery1.First;

        while (not FDQuery1.Eof) do
          begin
            item := lvPersonPhone.Items.Add;
            item.Caption := FDQuery1.FieldByName('ELERHETOSEG').AsString;
            item.SubItems.Add(FDQuery1.FieldByName('ELERHETOSEGTIPUS').AsString);
            FDQuery1.Next;
          end;
      end;

  finally
    lvPersonPhone.Items.EndUpdate;
  end;
end;

function TfrmPersonEdit.SaveSzemelyAdat(var AError: string): Boolean;
var
  update_address    : Boolean;
  update_telephone  : Boolean;
  s                 : string;
begin
  Result := True;
  AError := '';
  update_address := False;
  update_telephone := False;
  try
    // kell-e a lakcíc rekordokat UPDATE-ni
    if (not ID_String.IsEmpty) and (CompareStr(ID_String, edLakcimAzon.Text) <> 0) then
      update_address := True;

    // kell-e az elérhetõség rekordokat UPDATE-ni
    if (not ID_String2.IsEmpty) and (CompareStr(ID_String2, edSzemelyiAzon.Text) <> 0) then
      update_telephone := True;
    if (ID = -1) then
      begin
        // INSERT lesz
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('INSERT INTO SZEMELY (VEZETEKNEV, KERESZTNEV, SZEMELYIAZON, LAKCIMAZON)');
        FDQuery1.SQL.Add('VALUES (:vezeteknev, :keresztnev, :szemelyiazon, :lakcimazon)');
        FDQuery1.SQL.Add('RETURNING id');
        FDQuery1.ParamByName('vezeteknev').AsString := edVezeteknev.Text;
        FDQuery1.ParamByName('keresztnev').AsString := edKeresztnev.Text;
        FDQuery1.ParamByName('szemelyiazon').AsString := edSzemelyiAzon.Text;
        FDQuery1.ParamByName('lakcimazon').AsString := edLakcimAzon.Text;
        FDQuery1.Open;
        ID := FDQuery1.Fields[0].AsInteger;
      end
    else
      begin
        // UPDATE lesz
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('UPDATE SZEMELY');
        FDQuery1.SQL.Add('SET VEZETEKNEV=:vezeteknev, KERESZTNEV=:keresztnev, SZEMELYIAZON=:szemelyiazon, LAKCIMAZON=:lakcimazon');
        FDQuery1.SQL.Add('WHERE ID=:id');
        FDQuery1.ParamByName('vezeteknev').AsString := edVezeteknev.Text;
        FDQuery1.ParamByName('keresztnev').AsString := edKeresztnev.Text;
        FDQuery1.ParamByName('szemelyiazon').AsString := edSzemelyiAzon.Text;
        FDQuery1.ParamByName('lakcimazon').AsString := edLakcimAzon.Text;
        FDQuery1.ParamByName('id').AsInteger := ID;
        DBConnectionLink.Transaction.StartTransaction;
        FDQuery1.ExecSQL;
        DBConnectionLink.Transaction.Commit;
      end;

    if update_address then
      begin
        // cím adatokban ki kell cserélni
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('UPDATE CIM');
        FDQuery1.SQL.Add('SET LAKCIMAZON=:lakcimazon');
        FDQuery1.SQL.Add('WHERE LAKCIMAZON=:old');
        FDQuery1.ParamByName('old').AsString := ID_String;
        FDQuery1.ParamByName('lakcimazon').AsString := edLakcimAzon.Text;
        DBConnectionLink.Transaction.StartTransaction;
        FDQuery1.ExecSQL;
        DBConnectionLink.Transaction.Commit;
        ID_String := edLakcimAzon.Text;
        LoadAddressData(ID_String);
      end;
    if update_telephone then
      begin
        // cím adatokban ki kell cserélni
        if FDQuery1.Active then
          FDQuery1.Active := False;
        FDQuery1.SQL.Clear;
        FDQuery1.SQL.Add('UPDATE ELERHETOSEG');
        FDQuery1.SQL.Add('SET SZEMELYIAZON=:szemelyiazon');
        FDQuery1.SQL.Add('WHERE SZEMELYIAZON=:old');
        FDQuery1.ParamByName('old').AsString := ID_String2;
        FDQuery1.ParamByName('szemelyiazon').AsString := edSzemelyiAzon.Text;
        DBConnectionLink.Transaction.StartTransaction;
        FDQuery1.ExecSQL;
        DBConnectionLink.Transaction.Commit;
        ID_String2 := edSzemelyiAzon.Text;
        LoadPhoneData(ID_String2);
      end;

  except
    on E: Exception do
      begin
        Result := False;
        AError := 'Hiba történt az adatok rögzítése közben, hiba: ' + E.Message;
      end;
  end;
end;

procedure TfrmPersonEdit.SetupForm;
begin
  if (ID > -1) then
    begin
      if FDQuery1.Active then
        FDQuery1.Active := False;
      FDQuery1.SQL.Clear;
      FDQuery1.SQL.Add('SELECT * FROM SZEMELY');
      FDQuery1.SQL.Add('WHERE ID = :id');
      FDQuery1.ParamByName('id').AsInteger := ID;
      FDQuery1.Open;
      FDQuery1.First;
      if not FDQuery1.IsEmpty then
        begin
          edVezeteknev.Text := FDQuery1.FieldByName('VEZETEKNEV').AsString;
          edKeresztnev.Text := FDQuery1.FieldByName('KERESZTNEV').AsString;
          edSzemelyiAzon.Text := FDQuery1.FieldByName('SZEMELYIAZON').AsString;
          edLakcimAzon.Text := FDQuery1.FieldByName('LAKCIMAZON').AsString;
          ID_String := FDQuery1.FieldByName('LAKCIMAZON').AsString;
          ID_String2 := FDQuery1.FieldByName('SZEMELYIAZON').AsString;
        end;
    end
  else
    begin
      ID_String := '';
      ID_String2 := '';
    end;

  LoadAddressData(ID_String);
  LoadPhoneData(ID_String2);
end;

function TfrmPersonEdit.ValidatePersonData(var AError: string): Boolean;
var
  s : string;
begin
  Result := True;
  AError := '';
  s := edVezeteknev.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Vezetéknév mezõ nincs kitöltve';
      Exit;
    end;

  s := edKeresztnev.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Keresztnév mezõ nincs kitöltve';
      Exit;
    end;

  s := edSzemelyiAzon.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Személyi azonosító mezõ nincs kitöltve';
      Exit;
    end;

  // ellenõrizni kell a duplikációt
  if not CheckSzemelyiazon(s) then
    begin
      Result := False;
      AError := 'A személyi azonosító már rögzítve van a rendszerben';
      Exit;
    end;

  s := edLakcimAzon.Text;
  if s.IsEmpty then
    begin
      Result := False;
      AError := 'Lakcím azonosító mezõ nincs kitöltve';
      Exit;
    end;

  // ellenõrizni kell a duplikációt
  if not CheckLakcimazon(s) then
    begin
      Result := False;
      AError := 'A megadott lakcím azonosító már rögzítve van a rendszerben';
      Exit;
    end;

end;

end.
