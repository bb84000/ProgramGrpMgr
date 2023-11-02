unit LoadConf1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  lazbbinifiles;

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
    procedure Translate(LngFile: TBbiniFile);
  end;

var
  FLoadConf: TFLoadConf;

implementation

{$R *.lfm}

{ TFLoadConf }

procedure TFLoadConf.LB2Click(Sender: TObject);
begin
  if LB2.Itemindex >= 0 then BtnApply.enabled:= True;

  //FProgram.LoadCfgFile(FPrgMgr.PrgMgrAppsData+FileList[LB2.ItemIndex,0]);
  //FProgram.LVDisplayFiles;

end;

procedure TFLoadConf.Translate(LngFile: TBbIniFile);
begin
  if assigned (Lngfile) then
  with LngFile do
  begin
    BtnCancel.Caption:= ReadString('common', 'CancelBtn', BtnCancel.Caption);
    Caption:= ReadString('FloadConf', 'Caption', Caption);
    BtnApply.Caption:= ReadString('FLoadConf', 'BtnApply.Caption', BtnApply.Caption);
  end;
end;



end.

