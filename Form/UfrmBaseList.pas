unit UfrmBaseList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UfrmBase, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.Actions,
  Vcl.ActnList, System.ImageList, Vcl.ImgList, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.Grids, Vcl.DBGrids;

type
  TfrmBaseList = class(TfrmBase)
    tbrMenuSor: TToolBar;
    btnKilepSeparator: TToolButton;
    btnKilep: TToolButton;
    UjIkonok32: TImageList;
    UjIkonok32disabled: TImageList;
    alCommands: TActionList;
    acExit: TAction;
    DBGrid1: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseList: TfrmBaseList;

implementation

{$R *.dfm}

end.
