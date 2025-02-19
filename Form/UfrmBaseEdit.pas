// alap szerkeszt� ablak amib�l az adatszerkesz� formokat sz�rmaztatni kell
unit UfrmBaseEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBase, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.ImageList,
  Vcl.ImgList, System.Actions, Vcl.ActnList, Vcl.ComCtrls, Vcl.ToolWin;

type
  TfrmBaseEdit = class(TfrmBase)
    UjIkonok32: TImageList;
    UjIkonok32disabled: TImageList;
    tbrMenuSor: TToolBar;
    btnKilep: TToolButton;
    btnKilepSeparator: TToolButton;
    alCommands: TActionList;
    acExit: TAction;
    acSave: TAction;
    ToolButton1: TToolButton;
  private
    { Private declarations }
    FID         : Integer;
    FID_String  : string;
    FID_String2 : string;
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    constructor CreateWithParams(AOwner : TComponent; ADBConnectionLink : TFDConnection); virtual;

    // t�rol� mez�k �rt�k�nek t�rl�s�re
    procedure ClearFields;

    // �ltal�nos c�l� t�rol� tulajdons�g int
    property ID : Integer read FID write FID;
    // �ltal�nos c�l� t�rol� tulajdons�g string
    property ID_String : string read FID_String write FID_String;
    property ID_String2 : string read FID_String2 write FID_String2;
  end;

var
  frmBaseEdit: TfrmBaseEdit;

implementation

{$R *.dfm}

{ TfrmBaseEdit }

procedure TfrmBaseEdit.ClearFields;
begin
  FID := -1;
  FID_String := '';
  FID_String2 := '';
end;

constructor TfrmBaseEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ClearFields;
end;

constructor TfrmBaseEdit.CreateWithParams(AOwner: TComponent;
  ADBConnectionLink: TFDConnection);
begin
  inherited CreateWithParams(AOwner, ADBConnectionLink);
  ClearFields;
end;

end.
