unit SaveCfg1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, bbutils, ShellAPI;

type

  { TFSaveCfg }

  TFSaveCfg = class(TForm)
    BtnCancel: TButton;
    BtnOK: TButton;
    CBXShortCut: TCheckBox;
    EGrpName: TEdit;
    ImgGrpIcon: TImage;
    Label1: TLabel;
    LGrpIcon: TLabel;
    RBtnSave: TRadioButton;
    RBtnSaveAs: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure ImgGrpIconDblClick(Sender: TObject);
    procedure RadioButtonclick(Sender: TObject);
  private

  public
    IconDefFile: String;
    IconFile: String;
    IconIndex: Integer;

  end;

var
  FSaveCfg: TFSaveCfg;

implementation

{$R *.lfm}

{ TFSaveCfg }

procedure TFSaveCfg.FormCreate(Sender: TObject);
begin
  Inherited;
  IconFile:= '';
  IconIndex:= -1;
end;


procedure TFSaveCfg.ImgGrpIconDblClick(Sender: TObject);
begin
  IconFile:= IconDefFile;
  if PickIcon(0, IconFile, IconIndex) then
  ImgGrpIcon.Picture.Icon.Handle:= ExtractIcon(Handle, PChar(IconFile), IconIndex);

end;

procedure TFSaveCfg.RadioButtonclick(Sender: TObject);
begin
  EGrpName.Enabled:= RbtnSaveAs.Checked;
end;

end.

