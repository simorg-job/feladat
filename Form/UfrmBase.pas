unit UfrmBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet;

type
  TfrmBase = class(TForm)
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
  private
    { Private declarations }
    FDBConnectionLink: TFDConnection;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure SetDBConnectionLink(const Value: TFDConnection); virtual;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    constructor CreateWithParams(AOwner : TComponent; ADBConnectionLink : TFDConnection); virtual;
    destructor Destroy; override;

    procedure SetupForm; virtual; abstract;
    property DBConnectionLink : TFDConnection read FDBConnectionLink write SetDBConnectionLink;
  end;

var
  frmBase: TfrmBase;

implementation

{$R *.dfm}

{ TfrmBase }

constructor TfrmBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

constructor TfrmBase.CreateWithParams(AOwner: TComponent;
  ADBConnectionLink: TFDConnection);
begin
  inherited Create(AOwner);
  DBConnectionLink := ADBConnectionLink;
end;

destructor TfrmBase.Destroy;
begin
  DBConnectionLink := nil; // !!!
  inherited Destroy;
end;

procedure TfrmBase.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDBConnectionLink) then
    FDBConnectionLink := nil;
end;

procedure TfrmBase.SetDBConnectionLink(const Value: TFDConnection);
begin
  if Assigned(DBConnectionLink) then
    DBConnectionLink.RemoveFreeNotification(Self);

  FDBConnectionLink := Value;

  if Assigned(DBConnectionLink) then
    DBConnectionLink.FreeNotification(Self);

  FDQuery1.Connection := DBConnectionLink;
  FDQuery2.Connection := DBConnectionLink;
end;

end.
