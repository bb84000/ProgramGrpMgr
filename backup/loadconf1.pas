unit LoadConf1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TFLoadConf }

  TFLoadConf = class(TForm)
    BtnApply: TButton;
    BtnCancel: TButton;
    LB2: TListBox;
    procedure LB2Click(Sender: TObject);
  private

  public
    FileList : array [0..5 ] of array [0..1] of String;
  end;

var
  FLoadConf: TFLoadConf;

implementation

uses program1;

{$R *.lfm}

{ TFLoadConf }

procedure TFLoadConf.LB2Click(Sender: TObject);
begin
  if LB2.Itemindex >= 0 then BtnApply.enabled:= True;

  //FProgram.LoadCfgFile(FPrgMgr.PrgMgrAppsData+FileList[LB2.ItemIndex,0]);
  //FProgram.LVDisplayFiles;

end;

end.

