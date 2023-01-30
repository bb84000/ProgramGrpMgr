//******************************************************************************
// Settings  dialog unit for ProgramGrpManager (Lazarus)
// bb - sdtp - january 2023
//******************************************************************************
unit prefs1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  BBUtils, lazbbcontrols, ShellAPI, lazbbinifiles;

type

  { TPrefs }

  TPrefs = class(TForm)
    BtnCancel: TButton;
    BtnOK: TButton;
    CBHideInTaskBar: TCheckBox;
    CBIconCache: TCheckBox;
    CBLangue: TComboBox;
    CBMiniInTray: TCheckBox;
    CBNoChkNewVer: TCheckBox;
    CBSavSizePos: TCheckBox;
    CBStartWin: TCheckBox;
    CBXDesktopMnu: TCheckBox;
    CBXShortCut: TCheckBox;
    CBBold: TCheckBox;
    CBItal: TCheckBox;
    CBUnder: TCheckBox;
    ColorPickerBkgnd: TColorPicker;
    ColorPickerFont: TColorPicker;
    EGrpGroupName: TEdit;
    EGrpComment: TEdit;
    ESize: TEdit;
    ImgGrpIcon: TImage;
    LGrpName: TLabel;
    LGrpComment: TLabel;
    LTextStyle: TLabel;
    LBkgndColor: TLabel;
    LTextColor: TLabel;
    LWinVer: TLabel;
    LGrpIcon: TLabel;
    LLangue: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure CBMiniInTrayClick(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure ImgGrpIconDblClick(Sender: TObject);
  private

  public
    IconDefFile: String;
    IconFile: String;
    IconIndex: Integer;
    ImgChanged: Boolean;
    procedure Translate(lngFile: TBbiniFile);
  end;

var
  Prefs: TPrefs;

implementation

{$R *.lfm}

{ TPrefs }

procedure TPrefs.FormCreate(Sender: TObject);
begin
   Inherited;
   IconFile:= '';
   IconIndex:= -1;
   ImgChanged:= False;

end;

procedure TPrefs.CBMiniInTrayClick(Sender: TObject);
begin
  CBHideInTaskBar.Enabled:= CBMiniInTray.Checked;
end;




procedure TPrefs.ImgGrpIconDblClick(Sender: TObject);
begin
  IconFile:= IconDefFile;
  if PickIcon(0, IconFile, IconIndex) then
  begin
     ImgGrpIcon.Picture.Icon.Handle:= ExtractIcon(Handle, PChar(IconFile), IconIndex);
     ImgChanged:= True;
  end;
end;

procedure TPrefs.Translate(LngFile: TBbIniFile);
var
  DefaultCaption: String;
begin
  if assigned (Lngfile) then
  with LngFile do
  begin
    BtnOK.Caption:= ReadString('common', 'OKBtn', BtnOK.Caption);
    BtnCancel.Caption:= ReadString('common', 'CancelBtn', BtnCancel.Caption);
    DefaultCaption:= ReadString('common', 'DefaultCaption', '...');
    Caption:=Format(ReadString('Prefs','Caption','Préférences de %s'), [DefaultCaption]);
    CBStartWin.Caption:= ReadString('Prefs', 'CBStartWin.Caption', CBStartWin.Caption);
    CBSavSizePos.Caption:= ReadString('Prefs', 'CBSavSizePos.Caption', CBSavSizePos.Caption);
    CBNoChkNewVer.Caption:= ReadString('Prefs', 'CBNoChkNewVer.Caption', CBNoChkNewVer.Caption);
    LLangue.Caption:= ReadString('Prefs', 'LLangue.Caption', LLangue.Caption);
    CBMiniInTray.Caption:= ReadString('Prefs', 'CBMiniInTray.Caption', CBMiniInTray.Caption);
    CBMiniInTray.Hint:= ReadString('Prefs', 'CBMiniInTray.Hint',  CBMiniInTray.Hint);
    CBHideInTaskBar.Caption:= ReadString('Prefs', 'CBHideInTaskBar.Caption', CBHideInTaskBar.Caption);
    CBHideInTaskBar.Hint:= ReadString('Prefs', 'CBHideInTaskBar.Hint',  CBHideInTaskBar.Hint);
    CBXShortCut.Caption:= ReadString('Prefs', 'CBXShortCut.Caption', CBXShortCut.Caption);
    LGrpIcon.Caption:= ReadString('Prefs', 'LGrpIcon.Caption', LGrpIcon.Caption);
    ImgGrpIcon.Hint:= ReadString('Prefs', 'ImgGrpIcon.Hint', ImgGrpIcon.Hint);
    LGrpComment.Caption:= ReadString('Prefs', 'LGrpComment.Caption', LGrpComment.Caption);
    LGrpName.Caption:= ReadString('Prefs', 'LGrpName.Caption', LGrpName.Caption);;
    CBXDesktopMnu.Caption:= ReadString('Prefs', 'CBXDesktopMnu.Caption',  CBXDesktopMnu.Caption);
    CBXDesktopMnu.Hint:= StringReplace(ReadString('Prefs', 'CBXDesktopMnu.Hint', CBXDesktopMnu.Hint),
                               '%s', #13#10, [rfReplaceAll]);
    LBkgndColor.Caption:= ReadString('Prefs', 'LBkgndColor.Caption', LBkgndColor.Caption);
    LTextColor.Caption:= ReadString('Prefs', 'LTextColor.Caption', LTextColor.Caption);
    CBBold.Caption:= ReadString('Prefs', 'CBBold.Caption', CBBold.Caption);
    CBItal.Caption:= ReadString('Prefs', 'CBItal.Caption', CBItal.Caption);
    CBUnder.Caption:= ReadString('Prefs', 'CBUnder.Caption', CBUnder.Caption);
    ESize.Hint:=  ReadString('Prefs', 'ESize.Hint', ESize.Hint);
    LTextStyle.Caption:= ReadString('Prefs', 'LTextStyle.Caption', LTextStyle.Caption);
  end;
end;

end.

