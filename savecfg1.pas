unit SaveCfg1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, bbutils,
  lazbbinifiles,  ShellAPI;

type

  { TFSaveCfg }

  TFSaveCfg = class(TForm)
    BtnCancel: TButton;
    BtnOK: TButton;
    CBXShortCut: TCheckBox;
    EGrpName: TEdit;
    EGrpComment: TEdit;
    ImgGrpIcon: TImage;
    Label1: TLabel;
    LGrpComment: TLabel;
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
    procedure Translate(LngFile: TBbiniFile);
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
  EGrpComment.Enabled:= RbtnSaveAs.Checked;
  LGrpComment.Enabled:= RbtnSaveAs.Checked; ;
end;

procedure TFSaveCfg.Translate(LngFile: TBbIniFile);
var
  DefaultCaption: String;
begin
  if assigned (Lngfile) then
  with LngFile do
  begin
    BtnOK.Caption:= ReadString('common', 'OKBtn', BtnOK.Caption);
    BtnCancel.Caption:= ReadString('common', 'CancelBtn', BtnCancel.Caption);
    DefaultCaption:= ReadString('common', 'DefaultCaption', '...');
    Caption := ReadString('FSaveCfg', 'Caption', Caption);
    Label1.Caption:= Format(ReadString('FSaveCfg', 'Label1.Caption',
                     'Le groupe de programmes a été mofifié.%sVoulez-vous enregistrer ces modifications ?'),
                               [#13#10]);
    RBtnSave.Caption:= ReadString('FSaveCfg', 'RBtnSave.Caption', RBtnSave.Caption);
    RBtnSaveAs.Caption:= ReadString('FSaveCfg', 'RBtnSaveAs.Caption', RBtnSaveAs.Caption);
    CBXShortCut.Caption:= ReadString('FSaveCfg', 'CBXShortCut.Caption', CBXShortCut.Caption);
    LGrpIcon.Caption:= ReadString('FSaveCfg', 'LGrpIcon.Caption', LGrpIcon.Caption);
    ImgGrpIcon.Hint:= ReadString('FSaveCfg', 'ImgGrpIcon.Hint', ImgGrpIcon.Hint);
    LGrpComment.Caption:= ReadString('FSaveCfg', 'LGrpComment.Caption', LGrpComment.Caption);
  end;

end;

end.

