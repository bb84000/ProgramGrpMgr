unit Property1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, bbutils, shellAPI;

type

  { TFProperty }

  TFProperty = class(TForm)
    BtnCancel: TButton;
    BtnOK: TButton;
    ECible: TEdit;
    EDisplayName: TEdit;
    EParams: TEdit;
    EPath: TEdit;
    Image1: TImage;
    LCible: TLabel;
    LDescription: TLabel;
    LFileType: TLabel;
    LParams: TLabel;
    LPath: TLabel;
    LTypeName: TLabel;
    Memo1: TMemo;
    OD1: TOpenDialog;
    PButtons: TPanel;
    PC1: TPageControl;
    SBCible: TSpeedButton;
    TSGeneral: TTabSheet;
    procedure Image1DblClick(Sender: TObject);
    procedure SBCibleClick(Sender: TObject);
  private

  public
    IconDefFile: String;
    IconFile: String;
    IconIndex: Integer;
    dlgTitle: String;

  end;

var
  FProperty: TFProperty;

implementation

{$R *.lfm}

{ TFProperty }

procedure TFProperty.Image1DblClick(Sender: TObject);
begin
  PickIcon(0, IconFile, IconIndex);
  Image1.Picture.Icon.Handle:= ExtractIcon(Handle, PChar(IconFile), IconIndex);
end;

procedure TFProperty.SBCibleClick(Sender: TObject);
var
  FileInfo: SHFILEINFO;
  LinkInfo: TShellLinkInfoStruct;
  s, s1: string;
begin
Invalidate;
OD1.FileName:= ECible.Text;

if OD1.Execute then
begin
  ECible.Text:= OD1.FileName;
  SHGetFileInfo(PChar(OD1.FileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_DISPLAYNAME);
  EDisplayName.Text:= FileInfo.szDisplayName;
  Memo1.Text:= FileInfo.szDisplayName;
  SHGetFileInfo(PChar(OD1.FileName), 0, FileInfo, SizeOf(FileInfo), SHGFI_TYPENAME);
  LTypeName.Caption:= FileInfo.szTypeName;
  //ZeroMemory(@, SizeOf(LinkInfo));
  LinkInfo:= Default(TShellLinkInfoStruct);
  s:= OD1.FileName ;
  StrPCopy (LinkInfo.FullPathAndNameOfLinkFile, s);
  GetLinkInfo(@LinkInfo);
  If StrLen (LinkInfo.Description) > 0 then Memo1.Text:=  LinkInfo.Description ;
  if StrLen(LinkInfo.FullPathAndNameOfFileContiningIcon) > 0
  then s1:= LinkInfo.FullPathAndNameOfFileContiningIcon else s1:= LinkInfo.FullPathAndNameOfFileToExecute;
  if length(s1) > 0 then
  begin
    IconIndex:= LinkInfo.IconIndex;
    //if FileExists(s1) then s:=  s1 else
    //  begin
    //    s:= StringReplace(s1, 'Program Files (x86)', 'Program Files', [rfIgnoreCase]);
    //    s:= StringReplace(s, '%SystemRoot%', FPrgMgr.SystemRoot,[rfIgnoreCase]);
    //    s:= StringReplace(s, '%UserProfile%', FPrgMgr.UserProfile,[rfIgnoreCase]);
    //  end;

  end;
  IconFile:= s;
  Image1.Picture.Icon.Handle:= ExtractIcon(Handle, PChar(s), 0);
end;


end;

end.

