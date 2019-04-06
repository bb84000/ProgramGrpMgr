unit prefs1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,  BBUtils, ShellAPI;

type

  { TPrefs }

  TPrefs = class(TForm)
    BtnCancel: TButton;
    BtnOK: TButton;
    CBHideInTaskBar: TCheckBox;
    CBLangue: TComboBox;
    CBMiniInTray: TCheckBox;
    CBNoChkNewVer: TCheckBox;
    CBSavSizePos: TCheckBox;
    CBStartWin: TCheckBox;
    CBXShortCut: TCheckBox;
    ImgGrpIcon: TImage;
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
  end;

var
  Prefs: TPrefs;

implementation

{$R *.lfm}

{ TPrefs }

procedure TPrefs.FormCreate(Sender: TObject);
begin
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

end.

