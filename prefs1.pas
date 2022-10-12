//******************************************************************************
// Settings  dialog unit for ProgramGrpManager (Lazarus)
// bb - sdtp - february 2021
//******************************************************************************
unit prefs1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  BBUtils, lazbbcontrols, ShellAPI;

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
    procedure Panel1Click(Sender: TObject);
  private

  public
    IconDefFile: String;
    IconFile: String;
    IconIndex: Integer;
    ImgChanged: Boolean;

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

procedure TPrefs.Panel1Click(Sender: TObject);
begin

end;

end.

