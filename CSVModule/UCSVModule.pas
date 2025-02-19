unit UCSVModule;

interface

uses
  System.Classes,
  FireDAC.Comp.Client, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, Data.DB, FireDAC.DApt;

const
  IMPORT_RES_OK         = 0;  // imoport sikeres
  IMPORT_RES_NOT_EXISTS = 1;  // forrás csv nem létezik
  IMPORT_RES_DATA_ERROR = 2;  // hiba van a CSV adat sorban
  IMPORT_RES_EXCEPTION  = 3;  // import során kivétel történt

type
  TCSVModule = class(TComponent)
  private
    FDBConnectionLink : TFDConnection;
    FQuery1           : TFDQuery;
    FQuery2           : TFDQuery;
    FQuery3           : TFDQuery;
    FQuery4           : TFDQuery;
    FQuery5           : TFDQuery;
    FQuery6           : TFDQuery;
    procedure SetDBConnectionLink(const Value: TFDConnection);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    function ImportCSV(ASourceCSV : string) : Integer;

    property DBConnectionLink : TFDConnection read FDBConnectionLink write SetDBConnectionLink;
  end;

implementation

uses
  System.StrUtils, System.Types, System.SysUtils, FireDAC.Stan.Param;

{ TCSVModule }

constructor TCSVModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDBConnectionLink := nil;
  FQuery1 := TFDQuery.Create(Self);
  FQuery2 := TFDQuery.Create(Self);
  FQuery3 := TFDQuery.Create(Self);
  FQuery4 := TFDQuery.Create(Self);
  FQuery5 := TFDQuery.Create(Self);
  FQuery6 := TFDQuery.Create(Self);
end;

destructor TCSVModule.Destroy;
begin
  if FQuery1.Active then
    FQuery1.Active := False;
  FQuery1.Free;

  if FQuery2.Active then
    FQuery2.Active := False;
  FQuery2.Free;

  if FQuery3.Active then
    FQuery3.Active := False;
  FQuery3.Free;

  if FQuery4.Active then
    FQuery4.Active := False;
  FQuery4.Free;

  if FQuery5.Active then
    FQuery5.Active := False;
  FQuery5.Free;

  if FQuery6.Active then
    FQuery6.Active := False;
  FQuery6.Free;

  DBConnectionLink := nil;
  inherited Destroy;
end;

function TCSVModule.ImportCSV(ASourceCSV: string): Integer;
var
  line    : string;
  sr      : TStreamReader;
  i       : Integer;
  header  : TStringDynArray;
  data    : TStringDynArray;
begin
  if (not Assigned(FDBConnectionLink)) then
    raise Exception.Create('FDBConnectionLink not set');
  Result := IMPORT_RES_OK;
  i := 0;
  sr := nil;
  if (not FileExists(ASourceCSV)) then
    begin
      Result := IMPORT_RES_NOT_EXISTS;
      Exit;
    end;
  try
    sr := TStreamReader.Create(ASourceCSV, TEncoding.UTF8);
    try
      // lekérdezések az adatokhoz
      FQuery1.SQL.Clear;
      FQuery1.SQL.Add('SELECT COUNT(*) AS CNT FROM SZEMELY');
      FQuery1.SQL.Add('WHERE (SzemelyiAzon=:szemelyiazon)');

      FQuery2.SQL.Clear;
      FQuery2.SQL.Add('INSERT INTO SZEMELY (VEZETEKNEV, KERESZTNEV, SZEMELYIAZON, LAKCIMAZON)');
      FQuery2.SQL.Add('VALUES (:vezeteknev, :keresztnev, :szemelyiazon, :lakcimazon)');

      FQuery3.SQL.Clear;
      FQuery3.SQL.Add('SELECT COUNT(*) AS CNT FROM CIM');
      FQuery3.SQL.Add('WHERE (LAKCIMAZON=:lakcimazon) AND (CIMTIPUS=:cimtipus)');

      FQuery4.SQL.Clear;
      FQuery4.SQL.Add('INSERT INTO CIM (LAKCIMAZON, CIMTIPUS, IRANYITOSZAM, TELEPULES, UTCA, HAZSZAM)');
      FQuery4.SQL.Add('VALUES (:lakcimazon, :cimtipus, :iranyitoszam, :telepules, :utca, :hazszam)');

      FQuery5.SQL.Clear;
      FQuery5.SQL.Add('SELECT COUNT(*) AS CNT FROM ELERHETOSEG');
      FQuery5.SQL.Add('WHERE (SZEMELYIAZON=:szemelyiazon) AND (ELERHETOSEGTIPUS=:elerhetosegtipus)');

      FQuery6.SQL.Clear;
      FQuery6.SQL.Add('INSERT INTO ELERHETOSEG (SZEMELYIAZON, ELERHETOSEGTIPUS, ELERHETOSEG)');
      FQuery6.SQL.Add('VALUES (:szemelyiazon, :elerhetosegtipus, :elerhetoseg)');

      FDBConnectionLink.Transaction.StartTransaction;
      while (not sr.EndOfStream) do
        begin
          line := sr.ReadLine;
          if (i = 0) then
            begin
              // beolvassa a headert, ehhez fogja viszonítani a többi sort
              header := SplitString(line, ';');
            end
          else
            begin
              data := SplitString(line, ';');
              if Length(data) <> Length(header) then
                begin
                  Result := IMPORT_RES_DATA_ERROR;
                  Exit;
                end;

              // szemely adat keresés szemelyiazon alapján, van-e már ilyen rekord
              if FQuery1.Active then
                FQuery1.Active := False;
              FQuery1.ParamByName('szemelyiazon').AsString := data[2];
              FQuery1.Prepare;
              FQuery1.Active := True;
              FQuery1.First;
              if (FQuery1.FieldByName('cnt').AsInteger = 0) then
                begin
                  // INSERT lesz
                  FQuery2.ParamByName('vezeteknev').AsString := data[0];
                  FQuery2.ParamByName('keresztnev').AsString := data[1];
                  FQuery2.ParamByName('szemelyiazon').AsString := data[2];
                  FQuery2.ParamByName('lakcimazon').AsString := data[3];
                  FQuery2.ExecSQL;

                end;
              // cim adat keresése
              if FQuery3.Active then
                FQuery3.Active := False;
              FQuery3.ParamByName('lakcimazon').AsString := data[3];
              FQuery3.ParamByName('cimtipus').AsString := data[4];

              FQuery3.Prepare;
              FQuery3.Active := True;
              FQuery3.First;
              if (FQuery3.FieldByName('cnt').AsInteger = 0) then
                begin
                  // INSERT lesz
                  FQuery4.ParamByName('lakcimazon').AsString := data[3];
                  FQuery4.ParamByName('cimtipus').AsString := data[4];
                  FQuery4.ParamByName('iranyitoszam').AsString := data[5];
                  FQuery4.ParamByName('telepules').AsString := data[6];
                  FQuery4.ParamByName('utca').AsString := data[7];
                  FQuery4.ParamByName('hazszam').AsString := data[8];

                  FQuery4.ExecSQL;
                end;
              // elerhetoseg adat keresése
              if FQuery5.Active then
                FQuery5.Active := False;
              FQuery5.ParamByName('szemelyiazon').AsString := data[2];
              FQuery5.ParamByName('elerhetosegtipus').AsString := data[9];

              FQuery5.Prepare;
              FQuery5.Active := True;
              FQuery5.First;
              if (FQuery5.FieldByName('cnt').AsInteger = 0) then
                begin
                  // INSERT lesz
                  FQuery6.ParamByName('szemelyiazon').AsString := data[2];
                  FQuery6.ParamByName('elerhetosegtipus').AsString := data[9];
                  FQuery6.ParamByName('elerhetoseg').AsString := data[10];

                  FQuery6.ExecSQL;
                end;
            end;
          Inc(i);
        end;
      FDBConnectionLink.Transaction.Commit;
    except
      on E: Exception do
        begin
          Result := IMPORT_RES_EXCEPTION;
        end;
    end;
  finally
    if Assigned(sr) then
      sr.Free;
    SetLength(header, 0);
    SetLength(data, 0);
  end;

end;

procedure TCSVModule.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDBConnectionLink) then
    FDBConnectionLink := nil;
end;

procedure TCSVModule.SetDBConnectionLink(const Value: TFDConnection);
begin
  if Assigned(DBConnectionLink) then
    DBConnectionLink.RemoveFreeNotification(Self);
  FDBConnectionLink := Value;

  if Assigned(DBConnectionLink) then
    begin
      DBConnectionLink.FreeNotification(Self);
      FQuery1.Connection := DBConnectionLink;
      FQuery2.Connection := DBConnectionLink;
      FQuery3.Connection := DBConnectionLink;
      FQuery4.Connection := DBConnectionLink;
      FQuery5.Connection := DBConnectionLink;
      FQuery6.Connection := DBConnectionLink;
    end;
end;

end.
