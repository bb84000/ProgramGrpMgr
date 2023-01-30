unit Property1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, Buttons, Menus, bbutils, shellAPI, lazbbinifiles, files1;

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
    LFiledate: TLabel;
    LFileSize: TLabel;
    LCible: TLabel;
    LDescription: TLabel;
    LFileType: TLabel;
    LParams: TLabel;
    LPath: TLabel;
    LTypeName: TLabel;
    Memo1: TMemo;
    PMnuPropsOldIcon: TMenuItem;
    PMnuSelectIcon: TMenuItem;
    OD1: TOpenDialog;
    PButtons: TPanel;
    PC1: TPageControl;
    PMnuIconProps: TPopupMenu;
    SBCible: TSpeedButton;
    TSGeneral: TTabSheet;
    procedure FormShow(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure SBCibleClick(Sender: TObject);
  private

  public
    IconDefFile: String;
    IconFile: String;
    IconIndex: Integer;
    dlgTitle: String;
    OldIcon: Boolean;
    MyFile: TFichier;
    FileSizeCaption, FileDateCaption, FileSizeByte, FileSizeKB, FileSizeMB, FileSizeGB:  String;
    procedure Translate(lngFile: TBbiniFile);
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

procedure TFProperty.FormShow(Sender: TObject);
var
  siz: double;
  unite: string;
begin
  IconFile:= MyFile.IconFile;
  IconIndex:= MyFile.IconIndex;
  Image1.Picture.Icon.Handle:= ExtractAssociatedIconU(Handle, PChar(MyFile.IconFile), MyFile.IconIndex);
  EDisplayName.Text:= MyFile.DisplayName;
  LTypeName.Caption:= MyFile.TypeName;
  ECible.Text:= MyFile.Path+ MyFile.Name;
  EParams.Text:= MyFile.Params;
  EPath.Text:= MyFile.StartPath;
  siz:= MyFile.size;
  if (siz >= 0) and  (siz < $400) then unite:= Format(FileSizeCaption+' %.0n %s', [siz, FileSizeByte]);     // less 1Ko
  if (siz >= $400) and  (siz < $100000) then unite:= Format(FileSizeCaption+' %.2n %s', [siz/$400, FileSizeKB]);   // less 1Mo
  if (siz >= $100000) and  (siz < $40000000) then unite:= Format(FileSizeCaption+'  %.2n %s', [siz/$100000, FileSizeMB]);  // less 1Go
  if (siz >= $40000000) then unite:=  Format(FileSizeCaption+' %.2n %s', [siz/$40000000, FileSizeGB]);  // less 1Go
  LFileSize.Caption:= unite;
  try
    LFiledate.Caption:= FileDateCaption+' '+DateTimeToStr(MyFile.Date) ;
  except
  end;
  Memo1.Text:= MyFile.Description;
  PMnuPropsOldIcon.Checked:= MyFile.OldIcon;
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

procedure TFProperty.Translate(LngFile: TBbIniFile);
var
  DefaultCaption: String;
begin
  if assigned (Lngfile) then
  with LngFile do
  begin
    BtnOK.Caption:= ReadString('common', 'OKBtn', BtnOK.Caption);
    BtnCancel.Caption:= ReadString('common', 'CancelBtn', BtnCancel.Caption);
    DefaultCaption:= ReadString('common', 'DefaultCaption', '...');
    Caption:= Format(ReadString('FProperty', 'Caption', 'Propriétés de %s'), [EDisplayName.Text])   ;
    FileSizeByte:= ReadString('FProperty', 'FileSizeByte', 'octet(s)');
    FileSizeKB:= ReadString('FProperty', 'FileSizeKB', 'Ko');
    FileSizeMB:= ReadString('FProperty', 'FileSizeMB', 'Mo');
    FileSizeGB:= ReadString('FProperty', 'FileSizeGB', 'Go');
    TSGeneral.Caption:= ReadString('FProperty', 'TSGeneral.Caption', TSGeneral.Caption);
    LFileType.Caption:= ReadString('FProperty', 'LFileType.Caption', LFileType.Caption);
    LDescription.Caption:= ReadString('FProperty', 'LDescription.Caption', LDescription.Caption);
    LCible.Caption:= ReadString('FProperty', 'LCible.Caption', LCible.Caption);
    SBCible.Hint:= ReadString('FProperty', 'SBCible.Hint', SBCible.Hint);
    LParams.Caption:= ReadString('FProperty', 'LParams.Caption', LParams.Caption);
    LPath.Caption:= ReadString('Fproperty', 'LPath.Caption', LPath.Caption);
    PMnuSelectIcon.Caption:= ReadString('FProperty', 'PMnuSelectIcon.Caption', PMnuSelectIcon.Caption);
    PMnuPropsOldIcon.Caption:= ReadString('FProperty', 'PMnuPropsOldIcon.Caption', PMnuPropsOldIcon.Caption);
    FileSizeCaption:= ReadString('FProperty', 'FileSizeCaption', 'Taille :');
    FileDateCaption:= ReadString('FProperty', 'FileDateCaption', 'Date :');
  end;
end;

end.

