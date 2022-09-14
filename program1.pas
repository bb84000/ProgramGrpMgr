//******************************************************************************
// Main unit for ProgramGrpManager (Lazarus)
// bb - sdtp - august 2022
//******************************************************************************
unit program1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Buttons, StdCtrls, CommCtrl, WinDirs, bbutils, shlobj, laz2_DOM,
  laz2_XMLRead, laz2_XMLWrite, files1, Registry, LCLIntf, Menus, ExtDlgs,
  ShellAPI, SaveCfg1, prefs1, property1, lazbbinifiles, LoadGroup1, LazUTF8,
  LoadConf1, Config1, lazbbosver, lazbbutils, lmessages, lazbbaboutupdate,
  Clipbrd, FileUtil;

const
  WM_NEWINSTANCE = WM_USER + 101;
  WP_restaure = 0;

type
  { int64 or longint type for Application.QueueAsyncCall}
  {$IFDEF CPU32}
    iDays= LongInt;
  {$ENDIF}
  {$IFDEF CPU64}
    iDays= Int64;
  {$ENDIF}

  { TFProgram }

  SaveType = (None, State, All);

  AttributeType = (atString, atInteger, atDatetime, atBoolean);



  TFProgram = class(TForm)
    CBDisplay: TComboBox;
    CBSort: TComboBox;
    ImgMnus: TImageList;
    ImgPrgSel: TImage;
    LPrgSel: TLabel;
    ListView1: TListView;
    PMnuAddBkgndImg: TMenuItem;
    PMnuPaste: TMenuItem;
    PMnuCopy: TMenuItem;
    N3: TMenuItem;
    PMnuDelBkgndImg: TMenuItem;
    N41: TMenuItem;
    OPictDlg: TOpenPictureDialog;
    PTrayMnuQuit: TMenuItem;
    N7: TMenuItem;
    PTrayMnuAbout: TMenuItem;
    N6: TMenuItem;
    PTrayMnuMaximize: TMenuItem;
    PTrayMnuRestore: TMenuItem;
    PTrayMnuMinimize: TMenuItem;
    N1: TMenuItem;
    PMnuRun: TMenuItem;
    PMnuPrefs: TMenuItem;
    PMnuLoadConf: TMenuItem;
    PMnuAbout: TMenuItem;
    N5: TMenuItem;
    PMnuQuit: TMenuItem;
    N4: TMenuItem;
    PMnuRunAs: TMenuItem;
    PMnuProps: TMenuItem;
    PMnuDelete: TMenuItem;
    PMnuGroup: TMenuItem;
    PMnuHideBars: TMenuItem;
    PMnuFolder: TMenuItem;
    PMnuAddFile: TMenuItem;
    PMnuSave: TMenuItem;
    N2: TMenuItem;
    ODlg1: TOpenDialog;
    PnlPrgsel: TPanel;
    PnlImgSel: TPanel;
    PnlStatus: TPanel;
    PnlTop: TPanel;
    LVPMnu: TPopupMenu;
    SDD1: TSelectDirectoryDialog;
    TrayMnu: TPopupMenu;
    SBGroup: TSpeedButton;
    SBFolder: TSpeedButton;
    SBAddFile: TSpeedButton;
    SBAbout: TSpeedButton;
    SBQuit: TSpeedButton;
    SBLoadConf: TSpeedButton;
    SBPrefs: TSpeedButton;
    SBSave: TSpeedButton;
    TrayProgman: TTrayIcon;
    procedure CBDisplayChange(Sender: TObject);
    procedure CBSortChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ListView1CustomDraw(Sender: TCustomListView; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure ListView1CustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure ListView1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListView1Resize(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure LVPMnuPopup(Sender: TObject);
    procedure PMnuAddBkgndImgClick(Sender: TObject);
    procedure PMnuCopyClick(Sender: TObject);
    procedure PMnuDelBkgndImgClick(Sender: TObject);
    procedure PMnuDeleteClick(Sender: TObject);
    procedure PMnuHideBarsClick(Sender: TObject);
    procedure PMnuPasteClick(Sender: TObject);
    procedure PMnuPropsClick(Sender: TObject);
    procedure PMnuRunClick(Sender: TObject);
    procedure PnlTopResize(Sender: TObject);
    procedure PTrayMnuMaximizeClick(Sender: TObject);
    procedure PTrayMnuMinimizeClick(Sender: TObject);
    procedure PTrayMnuRestoreClick(Sender: TObject);
    procedure SBAboutClick(Sender: TObject);
    procedure SBAddFileClick(Sender: TObject);
    procedure SBFolderClick(Sender: TObject);
    procedure SBGroupClick(Sender: TObject);
    procedure SBLoadConfClick(Sender: TObject);
    procedure SBPrefsClick(Sender: TObject);
    procedure SBQuitClick(Sender: TObject);
    procedure SBSaveClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TrayProgmanDblClick(Sender: TObject);
  private
    First: Boolean;
    OSTarget: String;
    AppDataPath: String;
    DesktopPath : String;
    StartMenuPath: String;
    PrgMgrAppsData: string;
    ProgName: String;
    sProgramsGroup: String;
    LocalizedName: String;
    Settings: Tconfig;
    oldw: array [0..50] of Integer;
    ListeFichiers: TFichierList;
    ImgList: TImageList;
    // Config file and values
    ConfigFile: String;
    ListeChange, SettingsChange, WStateChange: Bool;
    SMnuMaskBars, SMnuShowBars: String;
    //langue: Integer;
    LangFile: TBbiniFile;

    LangNums: TStringList;
    CurLang: Integer;
    CompileDateTime: TDateTime;
    IconDefFile: String;
    SystemRoot: String;
    ShortCutName: String;
    sBackupPrefs: String;
    YesBtn, NoBtn, CancelBtn: String;
    ExecName, ExecPath: String;
    FPropertyCaption: string;
    DeleteOKMsg: String;
    PtArray : array of Tpoint;
    IcoSize: Integer;
    FMinWidth, FminHeight : Integer;
    BarsHeight: Integer;
    HideBarsHeight, ShowBarsheight: Integer;
    NoLongerChkUpdates: String;
    CheckVerChanged: Boolean;
    NoDeleteGroup, DeleteGrpMsg: String;
    MnuAddImageStr: String;
    MnuRepImageStr: String;
    LangStr: string;
    OldConfig: Boolean;
    Version: String;
    cache: Boolean;
    use64bitcaption: string;
    BkGndPicture: Tpicture;
    sCannotGetNewVerList: String;
    sNoLongerChkUpdates: String;
    sUrlProgSite: String;
    ChkVerInterval: Int64;
    Iconized: Boolean;
    PrevLeft: Integer;
    PrevTop: Integer;
    function GetGrpParam: String;
    procedure LoadCfgFile(FileName: String);
    procedure LoadConfig(GrpName: String);
    function SaveConfig(GrpName: String; Typ: SaveType): Bool;
    procedure LVDisplayFiles;
    function GetFile(FileName: string):TFichier;
    function PMnuEnable (PMenu: TmenuItem; BtnBMP: TbitMap; Enable: Boolean):Boolean;
    function PMnuEnable (PMenu: TmenuItem; InImgList: TImageList; Enable: Boolean; ListIndex:Integer):Boolean;
    function StateChanged: SaveType;
    procedure ListeFichiersOnChange(sender: TObject);
    procedure SettingsOnChange(sender: TObject);
    procedure SettingsOnStateChange(sender: TObject);
    procedure ModLangue;
    function ClosestItem(pt: Tpoint; ptArr:array of Tpoint): TlistItem;
    function ReadFolder(strPath: string; Directory: Bool): Integer;
    procedure EnumerateResourceNames(Instance: THandle; var list: TStringList);
    procedure GetIconRes(filename: string; index:integer; var Ico: TIcon);
    procedure WMActivate(var AMessage: TLMActivate); message LM_ACTIVATE;
    procedure OnDeactivate(Sender: TObject);
    procedure OnQueryendSession(var Cancel: Boolean);
    procedure OnEndSession(Sender: TObject);
    procedure CheckUpdate(days: iDays);
    procedure OnAppMinimize(Sender: TObject);
    function HideOnTaskbar: boolean;
  public
     OSVersion: TOSVersion ;
  end;

 const
   // Message sent to a listview to set the space between icons
   LVM_SETICONSPACING =  LVM_FIRST+ 53;

var
  FProgram: TFProgram;
  prevHandle: HWND;

  // Windows functions declarations
  PrivateExtractIcons: function(lpszFile: PChar; nIconIndex, cxIcon, cyIcon: integer;
                                  phicon: PHANDLE; piconid: PDWORD; nicon, flags: DWORD):
                                  DWORD stdcall;
  SHDefExtractIcon: function (pszIconFile:PChar; iIndex:Longint; uFlags:UINT; var phiconLarge:THandle; var phiconSmall:Thandle;
                              nIconSize:UINT):HRESULT; stdcall;
  ShutdownBlockReasonCreate: function (Handle: hWnd; Msg: lpcwstr): Bool; StdCall;
  ShutdownBlockReasonDestroy: function (Handle: hWnd): Bool; StdCall;

  function EnumWindowsProc(WHandle: HWND; LParM: LParam): LongBool;StdCall;Export;

implementation

{$R *.lfm}

{ TFProgram }

// Enumerate Windows to search a previous instance with the same group name
// If there is a previous instance, we will close it when the current instance is activated
// and restore it if it is minimized

function EnumWindowsProc(WHandle: HWND; LParM: LParam): LongBool;StdCall;Export;
var
  Title, ClassName:array[0..128] of char;
  phandle: HWND;
  i: INteger;
begin
  Title:= '';
  ClassName:= '';
  Result:=True;
  GetWindowText(wHandle, Title,128);
  GetClassName(wHandle, ClassName,128);
  if IsWindowVisible(wHandle) then
  begin
    if (AnsiToUTF8(Title)=FProgram.GetGrpParam) and (ClassName='Window') then
    begin
      prevHandle:= WHandle;
     end;
   end;
end;

// Needed to proper display image in listbox.

procedure TFProgram.WMActivate(var AMessage: TLMActivate);
begin
  if AMessage.Active = WA_INACTIVE then Listview1.Invalidate ;
end;

// Slower than message passing

procedure TFProgram.OnDeactivate(Sender: TObject);
begin
  Listview1.Invalidate ;
end;

procedure TFProgram.OnQueryendSession(var Cancel: Boolean);
var
  reason: PWidechar;
begin
  reason:= PWideChar(UTF8Decode(sBackupPrefs));
  if assigned(ShutdownBlockReasonCreate) then ShutdownBlockReasonCreate(Application.Handle, reason);
  Cancel:= False;
end;

procedure TFProgram.OnEndSession(Sender:TObject);
var
  reg:TRegistry;
  RunRegKeyVal, RunRegKeySz: string;
begin
  if ListeChange then SaveConfig(FProgram.Settings.GroupName, All)
  else SaveConfig(FProgram.Settings.GroupName, State)   ;
  if not FProgram.Settings.StartWin then
  begin
    reg := TRegistry.Create;
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\RunOnce', True) ;
    //Voir Startwin
    RunRegKeyVal:= FProgram.ProgName+'_'+FProgram.Settings.GroupName;
    RunRegKeySz:= '"'+Application.ExeName+'" Grp='+FProgram.Settings.GroupName;
    reg.WriteString(RunRegKeyVal, RunRegKeySz) ;
    reg.CloseKey;
    if Assigned(reg) then FreeAndNil(reg);
  end;
  Application.ProcessMessages;
  if assigned(ShutdownBlockReasonDestroy) then ShutdownBlockReasonDestroy(Application.Handle);
end;

// Intercept minimize system system command to correct
// wrong window placement on restore from tray

procedure TFProgram.OnAppMinimize(Sender: TObject);
begin
  if Settings.HideInTaskbar then
  begin
    PrevLeft:= left;
    PrevTop:= top;
    WindowState:= wsMinimized;
    PTrayMnuMinimize.enabled:= false;
    PTrayMnuRestore.enabled:= true;
    PTrayMnuMaximize.enabled:= true;
    Iconized:= HideOnTaskbar;
  end;
end;

// Hide icon on taskbar if needed

function TFProgram.HideOnTaskbar: boolean;
begin
  result:= false;
  if Settings.MiniInTray and Settings.HideInTaskbar then
  begin
    result:= true;
    visible:= false;
    PTrayMnuRestore.Enabled:= true;
  end;
end;

// retrieve command line parameters



function TFProgram.GetGrpParam: String;
var
  s: string;
  s1: string;
  p: Integer;
  param: String;
begin
  Result:= 'Default';
  s:= GetCommandLine;
  p:= Pos(Application.ExeName, s);
  if p > 0 then
  begin
    s1:= Copy(s, p+length(Application.ExeName), length(s));
    if length(s1) > 0 then
    begin
      if (s1[1]= #34) or (s1[1]= #39) then
      s1:= Copy(s1, 3, length(s1)) else
      s1:= Copy(s1, 2, length(s1));
      s1:= StringReplace(s1, #34, '', [rfReplaceAll]);
      param:= StringReplace(s1, #39, '', [rfReplaceAll]);
      p:= Pos('Grp=', param);
      if p > 0 then
      begin
        Result := AnsiToUTF8(Copy(param, p+4, length(param)));
      end;
    end;
  end;
end;


// Form creation

procedure TFProgram.FormCreate(Sender: TObject);
var
  aPath : Array[0..MaxPathLen] of Char; //Allocate memory
begin
  inherited;
  Application.OnQueryEndSession := @OnQueryendSession;
  Application.ONEndSession:= @OnEndSession;
  // Intercept minimize system command
  Application.OnMinimize:=@OnAppMinimize;
  prevHandle:= 0;
  EnumWindows(@EnumWindowsProc,0);
  // Some things have to be run only on the first form activation
  // so, we set first at true
  First:= True;
  // Dynamic load of windows functions needed as then can not exist on some old windows versions
  Pointer(PrivateExtractIcons) := GetProcAddress(GetModuleHandle('user32.dll'),'PrivateExtractIconsA');
  Pointer(SHDefExtractIcon) := GetProcAddress(GetModuleHandle('shell32.dll'),'SHDefExtractIconA');
  Pointer(ShutdownBlockReasonCreate):= GetProcAddress(GetModuleHandle('user32.dll'), 'ShutdownBlockReasonCreate');
  Pointer(ShutdownBlockReasonDestroy):= GetProcAddress(GetModuleHandle('user32.dll'), 'ShutdownBlockReasonDestroy');

  // Compilation date/time
  try
    CompileDateTime:= Str2Date({$I %DATE%}, 'YYYY/MM/DD')+StrToTime({$I %TIME%});
  except
    CompileDateTime:=  now();
  end;
  ListeFichiers:= TFichierList.Create;
  Settings:= TConfig.Create;
  ImgList:= TImageList.Create(self);
  LazGetShortLanguageID(LangStr);
  If (length(Settings.LangStr)= 0) then Settings.LangStr:= LangStr;
  // Fix official program name to avoid trouble if exe name is changed
  ExecName:= ExtractFileName(Application.ExeName);
  ExecPath:= ExtractFilePath(Application.ExeName);
  ProgName:= 'ProgramGrpMgr';
  LocalizedName:= 'Gestionnaire de Groupe de Programmes';

   // Chargement des chaînes de langue...
  LangFile:= TBbIniFile.create(ExecPath+ProgName+'.lng');
  LangNums:= TStringList.Create;
  Settings.GroupName:= GetGrpParam;

  ListeChange:= False;
  SettingsChange:= False;
  // Get special folders
  SHGetSpecialFolderPath(0, aPath ,CSIDL_APPDATA,false);
  AppDataPath:= aPath;
  SHGetSpecialFolderPath(0,aPath , CSIDL_DESKTOP,false);
  DesktopPath:= aPath;
  SHGetSpecialFolderPath(0,aPath , CSIDL_WINDOWS,false);
  SystemRoot:= aPath;
  SHGetSpecialFolderPath(0,aPath , CSIDL_COMMON_STARTMENU,false);
  StartMenuPath:= aPath;
  PrgMgrAppsData:= AppDataPath+'\'+ProgName+'\';
  if not DirectoryExists (PrgMgrAppsData) then
  begin
    CreateDir(PrgMgrAppsData);
  end;
  IconDefFile:= SystemRoot+'\system32\imageres.dll';
  Listview1.DoubleBuffered:= true;
  BkGndPicture:= nil;


end;


procedure TFProgram.FormDestroy(Sender: TObject);
begin
  if Assigned(ListeFichiers) then FreeAndNil(ListeFichiers);
  if Assigned(ImgList) then FreeAndNil(ImgList);
  if Assigned(langnums) then FreeAndNil(langnums);
  if Assigned(langfile) then FreeAndNil(langfile);
  if Assigned(Settings) then FreeAndNil(Settings);
end;


// Hide tools and status bars

procedure TFProgram.PMnuHideBarsClick(Sender: TObject);
begin
  If Settings.HideBars then
  begin
    FMinHeight:= BarsHeight+GetSystemMetrics(SM_CYCAPTION)+142;
    Settings.HideBars:= False;
    PnlTop.Visible:= True;
    PnlStatus.Visible:= True;
    PMnuHideBars.Caption:= SMnuMaskBars;
    Height:= HideBarsheight+BarsHeight;
  end else
  begin
    FMinHeight:= GetSystemMetrics(SM_CYCAPTION)+142;
    Settings.HideBars:= True;
    PnlTop.Visible:= False;
    PnlStatus.Visible:= False;
    PMnuHideBars.Caption:= SMnuShowBars;
    Height:= ShowBarsHeight-BarsHeight;
  end;
end;

procedure TFProgram.PMnuPasteClick(Sender: TObject);
begin
  if ListeFichiers.PasteFromClipboard then LVDisplayFiles;
end;

// Form activation

procedure TFProgram.FormActivate(Sender: TObject);
var
  reg: Tregistry;
  IniFile: TBbInifile;
  rec: TRect;
begin
  inherited;
  if not first then exit;
  Settings.GroupName:= GetGrpParam;
  // We get Windows Version
  OSVersion:= TOSVersion.Create(LangStr, LangFile);
  // For popup menu, retrieve bitmap from buttons
  CropBitmap(SBGroup.Glyph, PmnuGroup.Bitmap, SBGroup.Enabled);
  CropBitmap(SBFolder.Glyph, PMnuFolder.Bitmap, SBFolder.Enabled);
  CropBitmap(SBAddFile.Glyph, PMnuAddFile.Bitmap, SBAddFile.Enabled);
  CropBitmap(ImgMnus, PMnuAddBkgndImg.Bitmap, True, 0);
  CropBitmap(ImgMnus, PMnuDelBkgndImg.Bitmap, False, 1);
  CropBitmap(ImgMnus, PMnuCopy.Bitmap, True,2);
  CropBitmap(ImgMnus, PMnuPaste.Bitmap, false,3);
  PmnuEnable (PMnuSave, SBSave.Glyph, false);
  CropBitmap(SBPrefs.Glyph, PMnuPrefs.Bitmap, SBPrefs.Enabled);
  CropBitmap(SBLoadConf.Glyph, PMnuLoadConf.Bitmap, SBLoadConf.Enabled);
  CropBitmap(SBAbout.Glyph, PMnuAbout.Bitmap, SBAbout.Enabled);
  CropBitmap(SBQuit.Glyph, PMnuQuit.Bitmap, SBQuit.Enabled);
  CropBitmap(SBAbout.Glyph, PTrayMnuAbout.Bitmap, SBAbout.Enabled);
  CropBitmap(SBQuit.Glyph, PTrayMnuQuit.Bitmap, SBQuit.Enabled);
  BarsHeight:= ClientHeight-ListView1.Height;
  {$IFDEF CPU32}
     OSTarget := '32 bits';
  {$ENDIF}
  {$IFDEF CPU64}
     OSTarget := '64 bits';
  {$ENDIF}
  // Check inifile with URLs, if not present, then use default
  IniFile:= TBbInifile.Create('ProgramGrpMgr.ini');
  AboutBox.ChkVerURL := IniFile.ReadString('urls', 'ChkVerURL','https://github.com/bb84000/ProgramGrpMgr/releases/latest');
  AboutBox.UrlWebsite:= IniFile.ReadString('urls', 'UrlWebSite','https://www.sdtp.com');
  sUrlProgSite:= IniFile.ReadString('urls', 'UrlProgSite','https://github.com/bb84000/ProgramGrpMgr/wiki'); // can be localized
  AboutBox.UrlSourceCode:=IniFile.ReadString('urls', 'UrlSourceCode','https://github.com/bb84000/ProgramGrpMgr');
  ChkVerInterval:= IniFile.ReadInt64('urls', 'ChkVerInterval', 3);
  if assigned(inifile) then FreeAndNil(inifile);
  // A previous instance is already running (we didnt see it as it was minimized ?) so we close it
  if prevHandle>0 then postMessage(prevHandle, WM_CLOSE, 0, 0);
  // Now load settings
  LoadConfig(Settings.GroupName);
  // if the previous running instance was minimized, then we show the new instance
  if prevHandle>0 then PTrayMnuRestoreClick(self);
  // In case of program's first use
  if length(Settings.LastVersion)=0 then Settings.LastVersion:= version;
  // check if desktop context menu enabled and change settings checkbox according.
  reg := TRegistry.Create;
  reg.RootKey := HKEY_CLASSES_ROOT;
  Settings.DeskTopMnu:= reg.KeyExists('Directory\Background\shell\ProgramGrpMgr');
  Prefs.CBXDesktopMnu.Checked:= Settings.DeskTopMnu;
  reg.CloseKey;
  reg.free;
  if (Pos('64', OSVersion.Architecture)>0) and (OsTarget='32 bits') then
  begin
    ShowMessage(use64bitcaption);
  end;

  Application.QueueAsyncCall(@CheckUpdate, ChkVerInterval);       // async call to let icons loading
end;

// Parameter days defines the updates interval in days

procedure TFProgram.CheckUpdate(days: iDays);
var
  errmsg: string;
  sNewVer: string;
  CurVer, NewVer: int64;
  alertpos: TPosition;
  alertmsg: string;
begin
  //Dernière recherche il y a "days" jours ou plus ?
  errmsg := '';
  alertmsg:= '';
  if not visible then alertpos:= poDesktopCenter
  else alertpos:= poMainFormCenter;
  if (Trunc(Now)>= Trunc(Settings.LastUpdChk)+days) and (not Settings.NoChkNewVer) then
  begin
     Settings.LastUpdChk := Trunc(Now);
     AboutBox.Checked:= true;
     AboutBox.ErrorMessage:='';
     //AboutBox.version:= '0.1.0.0' ;
     sNewVer:= AboutBox.ChkNewVersion;
     errmsg:= AboutBox.ErrorMessage;
     if length(sNewVer)=0 then
     begin
       if length(errmsg)=0 then alertmsg:= sCannotGetNewVerList
       else alertmsg:= errmsg;
       begin
         if AlertDlg(Caption,  alertmsg, ['OK', CancelBtn, sNoLongerChkUpdates],
                  true, mtError, alertpos)= mrYesToAll then Settings.NoChkNewVer:= true;
       end;
       exit;
     end;
     NewVer := VersionToInt(sNewVer);
     // Cannot get new version
     if NewVer < 0 then exit;
     CurVer := VersionToInt(AboutBox.version);
     if NewVer > CurVer then
     begin
       Settings.LastVersion:= sNewVer;
       AboutBox.LUpdate.Caption := Format(AboutBox.sUpdateAvailable, [sNewVer]);
       AboutBox.NewVersion:= true;
       AboutBox.ShowModal;
     end else
     begin
       AboutBox.LUpdate.Caption:= AboutBox.sNoUpdateAvailable;
     end;
     Settings.LastUpdChk:= now;
   end else
   begin
    if VersionToInt(Settings.LastVersion)>VersionToInt(version) then
       AboutBox.LUpdate.Caption := Format(AboutBox.sUpdateAvailable, [Settings.LastVersion]) else
       AboutBox.LUpdate.Caption:= AboutBox.sNoUpdateAvailable;
   end;
   AboutBox.LUpdate.Hint:= AboutBox.sLastUpdateSearch + ': ' + DateToStr(Settings.LastUpdChk);

end;

procedure TFProgram.FormChangeBounds(Sender: TObject);
begin
  Listview1.Invalidate;
end;

// Form drop files

procedure TFProgram.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var
 i: integer;
begin
  if length(FileNames) > 0 then
  begin
    For i:= 0 to length(Filenames)-1 do
      ListeFichiers.AddFile(GetFile(FileNames[i]));
      ListeChange:= True;
      LVDisplayFiles;
  end;
end;

procedure TFProgram.FormPaint(Sender: TObject);
begin
  LIstView1.Invalidate;
end;

procedure TFProgram.FormResize(Sender: TObject);
var
  BorderWidths: Integer;
begin
  BorderWidths:= Width-ClientWidth;
  if Settings.HideBars then begin
     ShowBarsHeight:= Height+BarsHeight;
      FminWidth:= 250;
     HideBarsHeight:= Height;
  end else
  begin
     HideBarsHeight:= Height-BarsHeight;
     FMinWidth := SBQuit.Left+SBQuit.Width+10+CBDisplay.Width+10+CBSort.Width+BorderWidths;
      if (Width < FMinWidth) then Width:= FMinWidth;
     ShowBarsHeight:= Height;
  end;
end;

procedure TFProgram.FormShow(Sender: TObject);
begin
  ListView1.Invalidate;
end;

function TFProgram.PMnuEnable (PMenu: TmenuItem; InImgList: TImageList; Enable: Boolean; ListIndex: Integer):Boolean;
begin
  PMenu.Enabled:= Enable;
  CropBitmap(InImgList, PMenu.Bitmap, Enable, ListIndex);
  result:= Enable;
end;

function TFProgram.PMnuEnable (PMenu: TmenuItem; BtnBMP: TbitMap; Enable: Boolean):Boolean;
begin
  PMenu.Enabled:= Enable;
  CropBitmap(BtnBmp, PMenu.Bitmap, Enable);
  result:= Enable;
end;

// Load settings data and file list

procedure TFProgram.LoadConfig(GrpName: String);
var
  i: Integer;
  LangFound: Boolean;
  winstate: TWindowState;
begin
  with Settings do
  begin
    GrpIconFile:= '';
    GrpIconIndex:= 0;
    GroupName:= GrpName;
  end;
  ConfigFile:= PrgMgrAppsData+GrpName+'.xml';

 If not FileExists(ConfigFile) then
  begin
    If FileExists (PrgMgrAppsData+Settings.GroupName+'.bk0') then
    begin
      RenameFile(PrgMgrAppsData+Settings.GroupName+'.bk0', ConfigFile);
      For i:= 1 to 5
      do if FileExists (PrgMgrAppsData+Settings.GroupName+'.bk'+IntToStr(i))     // Renomme les précédentes si elles existent
       then  RenameFile(PrgMgrAppsData+Settings.GroupName+'.bk'+IntToStr(i), PrgMgrAppsData+Settings.GroupName+'.bk'+IntToStr(i-1));
    end else
    begin
      SaveConfig(Settings.GroupName, All)
    end;
  end;
  LoadCfgFile(ConfigFile);
  if Settings.GroupName <> GrpName then Settings.GroupName := GrpName;
  // Détermination de la langue
  //LangFound:= false;
  // old settings used nubers instead characters
  if Settings.LangStr='12' then Settings.LangStr:= 'fr';
  LangFound:= false;
  LangFile.ReadSections(LangNums);
  if LangNums.Count > 1 then
    For i:= 0 to LangNums.Count-1 do
    begin
      Prefs.CBLangue.Items.Add (LangFile.ReadString(LangNums.Strings[i],'Language', 'Aucune'));
      If LangNums.Strings[i] = Settings.LangStr then LangFound:= True;
    end;
  // Si la langue n'est pas traduite, alors on passe en Anglais
  If not LangFound then
   begin
    Settings.LangStr := 'en';
  end;
  CurLang:= LangNums.IndexOf(Settings.LangStr);
  Modlangue;
  // bakground colour
  ListView1.Color:= Settings.BkgrndColor;
  // Text Colour
  ListView1.Font.Color:= Settings.TextColor;
  // text style
  if Pos('B', upperCase(Settings.TextStyle)) >0 then ListView1.Font.Style:= [fsBold];
  if Pos('I', upperCase(Settings.TextStyle)) >0 then ListView1.Font.Style:= ListView1.Font.Style+[fsItalic];
  if Pos('U', upperCase(Settings.TextStyle)) >0 then ListView1.Font.Style:= ListView1.Font.Style+[fsUnderline];
  // text size
  ListView1.Font.Size:= Settings.TextSize;
  // Background Image
  PMnuAddBkgndImg.Caption:= MnuAddImageStr;
  if fileExists (Settings.BkgrndImage) then
  try
    BkGndPicture:= TPicture.Create;
    BkGndPicture.LoadFromFile(Settings.BkgrndImage);
    PMnuDelBkgndImg.Enabled:= PMnuEnable (PMnuDelBkgndImg, ImgMnus, true, 1);
    PMnuAddBkgndImg.Caption:= MnuRepImageStr;
  except
    BkGndPicture:= nil;
    Settings.BkgrndImage:='';
    PMnuDelBkgndImg.Enabled:= PMnuEnable (PMnuDelBkgndImg, ImgMnus, false, 1);
  end;
  // Taille et position précédentes
  if Settings.SavSizePos then
  begin
    Position:= poDesktopCenter;
    Try
      WinState := TWindowState(StrToInt('$' + Copy(Settings.WState, 1, 4)));
      Top := StrToInt('$' + Copy(Settings.WState, 5, 4));
      Left := StrToInt('$' + Copy(Settings.WState, 9, 4));
      Height := StrToInt('$' + Copy(Settings.WState, 13, 4));
      Width := StrToInt('$' + Copy(Settings.WState, 17, 4));
    except
    end;
    TrayProgman.Visible:= Settings.MiniInTray;
    WindowState := WinState;
    PrevLeft:= left;
    PrevTop:= top;
    Case WindowState of
      wsNormal: begin
        PTrayMnuRestore.Enabled:= False;
        PTrayMnuMinimize.Enabled:= True;
        PTrayMnuMaximize.Enabled:= True;
      end;
      wsMinimized: begin
        PTrayMnuRestore.Enabled:= True;
        PTrayMnuMinimize.Enabled:= False;
        PTrayMnuMaximize.Enabled:= True;
        WindowState:=wsNormal;
        Application.Minimize;
      end;
      wsMaximized: begin
        PTrayMnuRestore.Enabled:= True;
        PTrayMnuMinimize.Enabled:= True;
        PTrayMnuMaximize.Enabled:= False;
      end;
    end;
    if not visible then HideOnTaskbar;
    PnlTop.Visible:= not Settings.HideBars;
    PnlStatus.Visible:= not Settings.HideBars;
    if Settings.HideBars then begin
      PMnuHideBars.Caption:= SMnuShowBars;
    end else
    begin
      PMnuHideBars.Caption:= SMnuMaskBars;
    end;
  end;
  CBDisplay.ItemIndex:= Settings.IconDisplay;
  CBSort.ItemIndex:= Settings.IconSort;
  Application.Title:= Settings.GroupName;
  Caption:= Settings.GroupName;
  If not FileExists(Settings.GrpIconFile) then Settings.GrpIconFile:= Application.ExeName;
  Application.Icon.Handle:= ExtractIconU(handle, Settings.GrpIconFile, Settings.GrpIconIndex);
  TrayProgman.Icon:= Application.Icon;
  version:= GetVersionInfo.ProductVersion;
  // Aboutbox
  AboutBox.Image1.Picture.Icon.Handle:= Application.Icon.Handle;
  AboutBox.LProductName.Caption:= GetVersionInfo.ProductName+' ('+OsTarget+')';
  AboutBox.LCopyright.Caption:= GetVersionInfo.CompanyName+' - '+DateTimeToStr(CompileDateTime);
  AboutBox.LVersion.Caption:= 'Version: '+Version;
  //AboutBox.LVersion.Hint:= OSVersion.VerDetail;
  AboutBox.LUpdate.Hint := AboutBox.sLastUpdateSearch + ': ' + DateToStr(Settings.LastUpdChk);
  AboutBox.Version:= Version;
  AboutBox.ProgName:= ProgName;
  // Dont want to have the same icon handle
  ImgPrgSel.Picture.Icon.Handle:=  ExtractIconU(handle, Settings.GrpIconFile, Settings.GrpIconIndex);
  // Pointer to files and settings change
  ListeFichiers.OnChange:=  @ListeFichiersOnChange;
  Settings.OnChange:= @SettingsOnChange;
  Settings.OnStateChange:= @SettingsOnStateChange;
  LVDisplayFiles;
end;

// load the settings file

procedure TFProgram.LoadCfgFile(FileName: String);
var
  CfgXML: TXMLDocument;
  SettingsNode, FilesNode : TDOMNode;
begin
Try
  OldConfig:= False;
  ReadXMLFile(CfgXML, FileName);
    With CfgXML do
    begin
      // Main settings, check if old or new config file
      SettingsNode:= DocumentElement.FindNode('settings');
      if SettingsNode = nil then
      begin
        SettingsNode:= DocumentElement;
        oldConfig:= True;
      end;
      Settings.ReadXMLNode(SettingsNode);
      // files settings
      FilesNode:= DocumentElement.FindNode('files');
      if FilesNode = nil then FilesNode:= DocumentElement;
      ListeFichiers.ReadXMLNode(FilesNode);
     end;
  finally
    FreeAndNil(CfgXML);
  end;
end;

function TFProgram.SaveConfig(GrpName: String; Typ: SaveType): Bool;
var
  CfgXML: TXMLDocument;
  RootNode, SettingsNode, FilesNode :TDOMNode;
  i: Integer;
  Reg: TRegistry;
  FilNamWoExt: String;
  RunRegKeyVal, RunRegKeySz: String;
begin
  if OldConfig then Typ:= All;                        // always save to new config if it is old one
  if (Typ= None) then exit;
  // Current state
  if Settings.IconDisplay < 0 then Settings.IconDisplay:= 3;
  if Settings.IconSort < 0 then Settings.IconSort:= 0;
  // Window position
  Settings.WState:= '';
  if self.Top < 0 then self.Top:= 0;
  if self.Left < 0 then self.Left:= 0;
  // Main form size and position
  Settings.WState:= IntToHex(ord(self.WindowState), 4)+IntToHex(self.Top, 4)+
                      IntToHex(self.Left, 4)+IntToHex(self.Height, 4)+IntToHex(self.width, 4);
  Settings.BkgrndColor:= ListView1.Color;
  // LOad or create config file
  ConfigFile:= PrgMgrAppsData+GrpName+'.xml';
  try
     // If oldconfig, then create a new file, else read existing config file
    if FileExists(ConfigFile) and (not OldConfig) then
    begin
      ReadXMLFile(CfgXml, ConfigFile);
      RootNode := CfgXML.DocumentElement;
    end else
    begin
      Settings.IconCache:= false;
      CfgXML := TXMLDocument.Create;
      RootNode := CfgXML.CreateElement('config');
      CfgXML.Appendchild(RootNode);
    end;
    if (Typ= State) or (Typ = All) then
    begin
      SettingsNode:= RootNode.FindNode('settings');
      if SettingsNode <> nil then RootNode.RemoveChild(SettingsNode);
      SettingsNode:= CfgXML.CreateElement('settings');
      Settings.SaveXMLnode(SettingsNode);
      RootNode.Appendchild(SettingsNode);
      WStateChange:= false;
    end;
    if (Typ = All) then
    begin
      FilesNode:= RootNode.FindNode('files');
      if FilesNode <> nil then RootNode.RemoveChild(FilesNode);
      FilesNode:= CfgXML.CreateElement('files');
      ListeFichiers.SaveToXMLnode(FilesNode);
      RootNode.Appendchild(FilesNode);
      // Sauvegarde du cache seulement si on a modifié la liste
      try
        if (cache=false and Settings.IconCache) then SaveImageListToFile(ImgList,PrgMgrAppsData+Settings.GroupName+'.imglst' ) ;
      except
      end;
    end;
    // On sauvegarde les versions précédentes
    FilNamWoExt:= TrimFileExt(ConfigFile);
    if FileExists (FilNamWoExt+'.bk5')                   // Efface la plus ancienne
    then  DeleteFile(FilNamWoExt+'.bk5');                // si elle existe
    For i:= 4 downto 0
    do if FileExists (FilNamWoExt+'.bk'+IntToStr(i))     // Renomme les précédentes si elles existent
       then  RenameFile(FilNamWoExt+'.bk'+IntToStr(i), FilNamWoExt+'.bk'+IntToStr(i+1));
    if FileExists (ConfigFile)
    then  RenameFile(ConfigFile, FilNamWoExt+'.bk0');
    // Et on sauvegarde la nouvelle config
    writeXMLFile(CfgXML, ConfigFile);
  finally
    //On vérifie que ces valeurs sont bien dans le registre
    Reg:= TRegistry.Create;
    Reg.RootKey:= HKEY_CURRENT_USER;
    Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True);
    // No need to transcode
     RunRegKeyVal:= ProgName+'_'+Settings.GroupName;
    RunRegKeySz:= '"'+Application.ExeName+'" Grp='+Settings.GroupName;
    if Settings.StartWin  then  // Démarrage avec Windows coché
    begin
      if not Reg.ValueExists(RunRegKeyVal) then
      reg.WriteString(RunRegKeyVal, RunRegKeySz);
      Reg.CloseKey;
    end else if Reg.ValueExists(RunRegKeyVal) then
    begin
      Reg.DeleteValue(RunRegKeyVal);
      Reg.CloseKey;
    end;
    ListeChange:= false;
    SettingsChange:= false;
    Reg.Free;
    FreeAndNil(CfgXML);
  end;
end;

function TFProgram.StateChanged : SaveType;
begin
  result:= none;
  if Top < 0 then Top:= 0;
  if Left < 0 then Left:= 0;
  // seulement si on veut sauvegarder la taille et la position
  if Settings.SavSizePos then
    Settings.WState:= IntToHex(ord(WindowState), 4)+IntToHex(Top, 4)+
                      IntToHex(Left, 4)+IntToHex(Height, 4)+IntToHex(width, 4);

  If (Prefs.ImgChanged or WStateChange or CheckVerChanged) then
  begin
    result:= State ;
  end;
  If ListeChange or SettingsChange or (not Fileexists (PrgMgrAppsData+Settings.GroupName+'.imglst')) then
  begin
    result:= All;
  end;
end;

procedure TFProgram.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  If ListeChange or SettingsChange then
  begin
    if OSVersion.VerMaj > 5 then   // Vista et après
    FSaveCfg.IconDefFile:= SystemRoot+'\system32\imageres.dll' else
    FSaveCfg.IconDefFile:= SystemRoot+'\system32\shell32.dll';
    FSaveCfg.EGrpName.Text:= Settings.GroupName;
    FSaveCfg.ImgGrpIcon.Picture.Icon:= Application.Icon;
    If FSaveCfg.Showmodal = mrOK then
    begin
      if FSaveCfg.RBtnSaveAs.Checked then
      begin
        if length(FSaveCfg.EGrpName.Text) > 0 then Settings.GroupName:= FSaveCfg.EGrpName.Text;
      end;

      if FSaveCfg.CBXShortCut.Checked then
      begin
        if length(FSaveCfg.IconFile) > 0 then Settings.GrpIconFile:= FSaveCfg.IconFile;
        if FSaveCfg.IconIndex >=0 then Settings.GrpIconIndex:= FSaveCfg.IconIndex;
        CreateShortcut(Application.ExeName, DesktopPath, Settings.GroupName, '','', 'Grp='+Settings.GroupName,
                       sProgramsGroup+' '+Settings.GroupName, Settings.GrpIconFile, Settings.GrpIconIndex);
      end;
      SaveConfig(Settings.GroupName, All);
    end;
  end else
  begin
    SaveConfig(Settings.GroupName, StateChanged);
  end;

end;


procedure TFProgram.ListeFichiersOnChange(sender: TObject);
begin
  ListeChange:= True;
  SBSave.Enabled:= True;
  PMnuSave.Enabled:= True;
  PMnuEnable(PmnuSave, SBSave.Glyph, true);
end;

procedure TFProgram.SettingsOnChange(sender: TObject);
begin
  SettingsChange:= True;
  SBSave.Enabled:= True;
  PMnuSave.Enabled:= True;
  PMnuEnable(PmnuSave, SBSave.Glyph, True);
end;

procedure TFProgram.SettingsOnStateChange(sender: TObject);
begin
  WStateChange:= True;
end;

function TFProgram.GetFile(FileName: string):TFichier;
var
  ExeName : string;
begin
  ExeName:='';
  if Uppercase(ExtractFileExt(FileName))='.LNK' then
  begin
    GetShortcutItems(FileName, ExeName, Result.Params, Result.StartPath, Result.Description,
                     Result.IconFile, Result.IconIndex);
     Result.Name:= ExtractFileName(ExeName);
     Result.Path:= ExtractFilePath(ExeName);
     Result.DisplayName:= TrimFileExt(ExtractFileName(FileName));
  end else
  begin
    ExeName:= FileName;
    Result.Name:= ExtractFileName(ExeName);
    Result.Path:= ExtractFilePath(ExeName);
    Result.DisplayName:= TrimFileExt(ExtractFileName(ExeName));
    Result.Description:= ExtractFileName(ExeName);
    Result.IconFile:= ExeName;
    Result.IconIndex:= 0;
   end;
    Result.TypeName:= FileGetType (ExeName);
    Result.Size:= FileGetSize(ExeName);
   try
     Result.Date:= FileGetDateTime (ExeName, ftCreate);
   except
     Result.Date:= Now();
   end;
end;


// Procedure to display icons and other in the listview

procedure TFProgram.LVDisplayFiles;
var
  ListItem: TListItem;
  Flag: Integer;
  CurIcon: TIcon;
  i: Integer;
  w: Integer;
  hIcon, hicons: Thandle;
  ItemPos: Tpoint;
  IcoInfo: TICONINFO;

  hnd: THandle;
begin
  if ListeFichiers.Count = 0 then
  begin
    ListView1.Clear;
    exit;
  end;
    Case CBDisplay.ItemIndex of
    0: begin
         IcoSize:= 128;
         //Flag:= SHIL_JUMBO;
         Flag:= SHIL_EXTRALARGE;
       end;
    1: begin
         IcoSize:= 96;
         Flag:= SHIL_EXTRALARGE;
         // Flag:= SHIL_JUMBO;
        end;
    2: begin
         IcoSize:= 48;
         Flag:= SHIL_EXTRALARGE;
       end;
    3: begin
         IcoSize:= 32;
         Flag:= SHIL_LARGE;
       end;
    4: begin
         IcoSize:= 16;
         Flag:= SHIL_SMALL;
       end;
    else begin
           IcoSize:= 32; // Default value
           Flag:= SHIL_SMALL;
         end;
  end;
    Case CBSort.ItemIndex of
      0: ListeFichiers.SortType:= cdcNone;
      1: begin
           ListeFichiers.SortDirection:= ascend;
           ListeFichiers.SortType:= cdcDisplayName;
         end;
      2: begin
           ListeFichiers.SortDirection:= descend;
           ListeFichiers.SortType:= cdcDisplayName;
         end;
      3: begin
           ListeFichiers.SortDirection:= ascend;
           ListeFichiers.SortType:= cdcDate;
         end;
      4: begin
           ListeFichiers.SortDirection:= descend;
           ListeFichiers.SortType:= cdcDate;
         end;
    end;
    if (ListeChange and FileExists(PrgMgrAppsData+Settings.GroupName+'.imglst' ))
    then DeleteFile(PrgMgrAppsData+Settings.GroupName+'.imglst' );
    ListeFichiers.DoSort;
    ListView1.Clear;
    ImgList.Clear;
    ImgList.Height:= IcoSize;
    ImgList.Width:= IcoSize;
     // Set spacing of icons in listview
    PostMessage(Listview1.Handle,LVM_SETICONSPACING, 0,MakeLParam(Word(-1), Word(-1)));
    Application.ProcessMessages;                             // To allow all components to be created instead index off bounds error
    ListView1.LargeImages:= ImgList;
    // ImageList in cache
    // load it and assign the image list to listview
    // Need to post listview message as listview handle is readonly
    cache:= false;
    If (FileExists(PrgMgrAppsData+Settings.GroupName+'.imglst' ) and (settings.IconCache)) then
    begin
      try
        hnd:= LoadImageListFromFile(PrgMgrAppsData+Settings.GroupName+'.imglst' );
      except
      end;
      if hnd=0 then                                          // wrong cache file, delete it
      begin
        DeleteFile(PrgMgrAppsData+Settings.GroupName+'.imglst' );
      end else
      begin
        PostMessage(Listview1.Handle,LVM_SETIMAGELIST, LVSIL_NORMAL, hnd);
        cache:= true;
      end;
    end;
    // Create a temporary TIcon
    CurIcon := TIcon.Create;
    CurIcon.Height:= IcoSize;
    CurIcon.Width:= IcoSize;
    setLength(PtArray, ListeFichiers.Count);
    for i:= 0 to ListeFichiers.Count-1 do
    begin
      ListItem := ListView1.Items.Add;
      ListItem.Caption := ListeFichiers.GetItem(i).DisplayName;
      W:= LPrgSel.Canvas.TextWidth(ListItem.Caption);
      if W > oldw[0] then oldw[0]:= w;
      ListItem.SubItems.Add(IntToStr(ListeFichiers.GetItem(i).Size div 1024)+' Ko');
      W:= LPrgSel.Canvas.TextWidth(ListItem.SubItems[0]);
      if W > oldw[1] then oldw[1]:= w;
      ListItem.SubItems.Add(ListeFichiers.GetItem(i).TypeName);
      W:= LPrgSel.Canvas.TextWidth(ListItem.SubItems[1]);
      if W > oldw[2] then oldw[2]:= w;
      ListItem.SubItems.Add(DateTimeToStr(ListeFichiers.GetItem(i).Date));

      if cache then
      begin
        ListItem.ImageIndex:= i;
      end else
      begin
        If Assigned(SHDefExtractIcon) then
        begin
          //Function only from W2000, and can be discontinued ?
          // Do not display properly low color depth icons
          if (SHDefExtractIcon(PChar(ListeFichiers.GetItem(i).IconFile), ListeFichiers.GetItem(i).IconIndex,
                             0, hicon, hicons, IcoSize) = 0) and ( not ListeFichiers.GetItem(i).OldIcon) then
          // Or this one
          {If (PrivateExtractIcons ( PChar(ListeFichiers.GetItem(i).IconFile), ListeFichiers.GetItem(i).IconIndex,
                     IcoSize, Icosize, @hIcon, @nIconId, 1, LR_LOADFROMFILE) <>0) and (hIcon <> 0) and
                     (ListeFichiers.GetItem(i).OldIcon = false) then }
          begin
            CurIcon.handle:= hicon;
            GetIconInfo(hicon, @IcoInfo);
            ListItem.ImageIndex := ImageList_Add(ImgList.ResolutionByIndex[0].Reference.Handle, IcoInfo.hbmColor, IcoInfo.hbmMask);
            //ListItem.ImageIndex :=  i;
          end else
          begin
            // This one only get the first icon in file
            GetIconFromFile(ListeFichiers.GetItem(i).IconFile ,CurIcon, Flag,0) ;
            //GetIconRes(ListeFichiers.GetItem(i).IconFile, ListeFichiers.GetItem(i).IconIndex, CurIcon);
            ListItem.ImageIndex := ImageList_AddIcon(ImgList.ResolutionByIndex[0].Reference.Handle, CurIcon.Handle);
          end;
        end;
      end;
       // Create an array of items coordinates
      ItemPos.x:= (Listview1.Items.Item[i].Position.x) +(IcoSize div 2);    // center coordinate
      ItemPos.y:= (Listview1.Items.Item[i].Position.y) +(IcoSize div 2);
      PtArray[i]:= ItemPos;
    end;
    if assigned(CurIcon) then FreeAndNil(CurIcon);
end;

// Find the closest point

function TFProgram.ClosestItem(pt: Tpoint; ptArr:array of Tpoint): TlistItem;
var
  i, tmpresult: integer;
  tmpdist, distance: Integer;
begin
  // Brute method : compare squared distances (Pythagore theorem)
  tmpresult:= 0;
  // Substract half icon size to x coordinates to properly move item
  distance:= sqr(pt.x-ptArr[0].x)+sqr(pt.y-ptArr[0].y);
  for i:= 1 to Length(ptArr)-1 do
  begin
    tmpdist:= sqr(pt.x-ptArr[i].x)+sqr(pt.y-ptArr[i].y);
    if tmpdist < distance then
    begin
      distance:= tmpdist;
      tmpresult:= i;
    end;
  end;
  if tmpresult < 0 then tmpresult:= 0;
  result:= ListView1.GetItemAt(PtArray[tmpresult].x, PtArray[tmpresult].y);
end;


procedure TFProgram.ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  Pt: Tpoint;
  currentItem, nextItem, dropItem : TListItem;
begin
  // Sans objet si on a un ordre de tri !
  if CBSort.ItemIndex <> 0 then exit;
  if Sender = Source then
  begin
    with TListView(Sender) do
    begin
      Pt.X:= X;
      Pt.Y:= Y;
      DropItem:= GetItemAt(X,Y);
      // If DropItem = nil then DropItem:=GetNearestItem(Pt, sdAll);
      // Replaced with own routine Don't work
      If DropItem = nil then   DropItem:= ClosestItem(Pt, PtArray);
      currentItem := Selected;
      while currentItem <> nil do
      begin
        NextItem := GetNextItem(currentItem, sdAll, [lIsSelected]) ;
        ListeFichiers.SortType:= cdcNone;
        if Assigned(dropItem) then  ListeFichiers.DoMove(currentItem.Index, DropItem.Index);
        FreeAndNil(currentItem);
        currentItem := nextItem;
       end;
      LVDisplayFiles;
    end;
  end;
end;

procedure TFProgram.ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = ListView1);
end;


procedure TFProgram.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  try
    // when llist change generate an error
    ListView1.Hint:= ListeFichiers.GetItem(Item.Index).Description ;
    LPrgSel.Caption:= ListView1.Hint;
    ListView1.Invalidate;
  except
  end;
end;


procedure TFProgram.PMnuRunClick(Sender: TObject);
  var
 Item : TListItem;
 LinkInfo: TShellLinkInfoStruct;
 s, sparam, sstartpath: string;
begin
  Item := ListView1.Selected;
  If Item <> nil then
  begin
    s:= ListeFichiers.GetItem(Item.Index).Path + ListeFichiers.GetItem(Item.index).Name;
    sparam:= ListeFichiers.GetItem(Item.Index).Params;
    sstartpath:= ListeFichiers.GetItem(Item.Index).StartPath;
    ZeroMemory(@LinkInfo, SizeOf(LinkInfo));
    StrPCopy (LinkInfo.FullPathAndNameOfLinkFile, s);
    GetLinkInfo(@LinkInfo);
    // Is it a shortcut
    // We replace shortcut link by real program location
    if Uppercase(ExtractFileExt(s))='.LNK' then
    begin
      s:= LinkInfo.FullPathAndNameOfFileToExecute;
      sparam:= LinkInfo.ParamStringsOfFileToExecute;
      sstartpath:= LinkInfo.FullPathAndNameOfWorkingDirectory;
    end;
    If UpperCase(Tcomponent(Sender).Name) = 'PMNURUN' then Exec(0, s , 'open', sparam, sstartpath);    // Run menu
    If UpperCase(Tcomponent(Sender).Name) = 'LISTVIEW1' then Exec(0, s ,'open', sparam, sstartpath);  // Double click Listview item
    If UpperCase(Tcomponent(Sender).Name) = 'PMNURUNAS' then Exec(0, s ,'runas', sparam, sstartpath); // Run As admin menu}
  end;
end;

procedure TFProgram.PnlTopResize(Sender: TObject);
begin
  CBSort.Left:= PnlTop.Width-CBSort.Width-8;
  CBDisplay.Left:= CBSort.Left- CBDisplay.Width-6;
end;


procedure TFProgram.PTrayMnuMaximizeClick(Sender: TObject);
begin
  PTrayMnuRestore.Enabled:= True;
  PTrayMnuMinimize.Enabled:= True;
  PTrayMnuMaximize.Enabled:= False;
  //ShowWindow(handle, SW_SHOWMAXIMIZED);
  WindowState:=wsMaximized;
  visible:= true;
  Application.BringToFront;
end;

procedure TFProgram.PTrayMnuMinimizeClick(Sender: TObject);
begin
  PTrayMnuRestore.Enabled:= True;
  PTrayMnuMinimize.Enabled:= False;
  PTrayMnuMaximize.Enabled:= True;
  PrevLeft:= left;
  PrevTop:= top;
  //ShowWindow(Application.Handle, SW_SHOWMINIMIZED);
  Application.Minimize;
end;

procedure TFProgram.PTrayMnuRestoreClick(Sender: TObject);
begin
  PTrayMnuRestore.Enabled:= False;
  PTrayMnuMinimize.Enabled:= True;
  PTrayMnuMaximize.Enabled:= True;
  //ShowWindow(handle, SW_SHOWNORMAL);
  WindowState:=wsNormal;
  //Need to reload position as it can change during hide in taskbar process
  visible:= true;
  //Application.BringToFront;
  left:= PrevLeft;
  top:= PrevTop;
end;

function TFProgram.ReadFolder(strPath: string; Directory: Bool): Integer;
var
  i: Integer;
  SearchRec: TSearchRec;
  FileAttr: Bool;
begin
  ZeroMemory(@SearchRec, SizeOf(TSearchRec));
  i := FindFirst(strPath + '*.*', faAnyFile, SearchRec);
  while i = 0 do
  begin
    FileAttr:= ((SearchRec.Attr and FaDirectory)<> FaDirectory) ;
    if FileAttr then ListeFichiers.AddFile(GetFile(strPath + SearchRec.Name));
    i := FindNext(SearchRec);
  end;
  Result:= ListeFichiers.Count;
end;

// Buttons click management
procedure TFProgram.SBGroupClick(Sender: TObject);
var
  i: Integer;
  SearchRec: TSearchRec;
  FileAttr: Bool;
  LI: TListItem;
  GroupXML: TXMLDocument;
  IconFile: String;
  IconIndex: Integer;
  MyIcon: TIcon;
  s: String;
  capt: array  [0..1] of string;
  inode: TDOMNode;
begin
  capt[0]:= YesBtn;
  capt[1]:= NoBtn;
  ZeroMemory(@SearchRec, SizeOf(TSearchRec));
  GroupXML:= TXMLDocument.Create;
  MyIcon:= TIcon.Create;
    with FloadGroup do
      begin
      LV1.Clear;
      IL1.Clear;
      BtnOK.Enabled:= False;
      BtnDelete.Enabled:= False;
      i := FindFirst(PrgMgrAppsData + '*.xml', faAnyFile, SearchRec);
      while i = 0 do
      begin
        FileAttr:= ((SearchRec.Attr and FaDirectory)<> FaDirectory) ;
        if FileAttr then
        begin
          ReadXMLFile(GroupXML, PrgMgrAppsData+SearchRec.Name);
          inode:= GroupXML.DocumentElement.FindNode('settings');
          if inode =  nil then inode:= GroupXML.DocumentElement;
          try
            s:= TDOMElement(iNode).GetAttribute('groupname');
            IconFile:= TDOMElement(iNode).GetAttribute('grpiconfile');
            IconIndex:= StrToInt(TDOMElement(iNode).GetAttribute('grpiconindex'));
          except
            IconIndex:= 0;
          end;
          LI := LV1.Items.Add;
           if length(s) > 0 then LI.Caption := s else LI.Caption:= TrimFileExt(ExtractFileName(PrgMgrAppsData+SearchRec.Name));
           MyIcon.Handle:= ExtractIconU(Handle, PChar(IconFile), IconIndex);
           if MyIcon.handle > 0 then LI.ImageIndex :=IL1.AddIcon(MyIcon);
         end;
        i := FindNext(SearchRec);
    end;
  Case ShowModal of
      // Charge un groupe
    mrOK: begin
            ListeFichiers.Reset;
            LoadConfig(LV1.Selected.Caption);
          end;
      // Crée un groupe
    mrYes: begin
             ListeFichiers.Reset;
             LVDisplayFiles;
             LoadConfig(FLoadGroup.BtnNew.Caption);
             ListeFichiersOnChange(Self);
           end;
      // Supprime un groupe
    mrRetry: if LV1.Selected.Caption = Settings.GroupName
               then MsgDlg(Caption, NoDeleteGroup, mtInformation, [mbOK],capt, 0)
               else
               begin
               If MsgDlg (Caption, Format(DeleteGrpMsg, [LV1.Selected.Caption]),
                     mtWarning,[mbYes, mbNo],capt, 0) = mrYes
                 then DeleteFile(PrgMgrAppsData+LV1.Selected.Caption+'.xml') ;
               end;
    end;
  end;
  FreeAndNil(GroupXML);
  FreeAndNil(MyIcon);
end;

procedure TFProgram.SBFolderClick(Sender: TObject);
var
  curdir: string;
begin
  SDD1.InitialDir:= StartMenuPath;
  if SDD1.Execute then
  begin
    CBDisplay.ItemIndex:= 2;
    CBSort.ItemIndex:= 1;
    curdir:= SDD1.FileName+'\';
    ReadFolder(curdir, False);
    LVDisplayFiles;
  end;
end;

procedure TFProgram.SBAddFileClick(Sender: TObject);
begin
  ODlg1.InitialDir:= StartMenuPath;
  If ODlg1.Execute then
    begin
     ListeFichiers.AddFile(GetFile(ODlg1.FileName));
     LVDisplayFiles;
    end;
end;


procedure TFProgram.SBSaveClick(Sender: TObject);
begin
  if OSVersion.VerMaj > 5 then   // Vista et après
  FSaveCfg.IconDefFile:= SystemRoot+'\system32\imageres.dll' else
  FSaveCfg.IconDefFile:= SystemRoot+'\system32\shell32.dll';
  FSaveCfg.EGrpName.Text:= Settings.GroupName;
  FSaveCfg.ImgGrpIcon.Picture.Icon.Handle:= ExtractIconU(handle, Settings.GrpIconFile, Settings.GrpIconIndex);
  If FSaveCfg.Showmodal = mrOK then
  begin
    if FSaveCfg.RBtnSaveAs.Checked then
    begin
      if length(FSaveCfg.EGrpName.Text) > 0 then Settings.GroupName:= FSaveCfg.EGrpName.Text;
    end;
    if length(FSaveCfg.IconFile) > 0 then Settings.GrpIconFile:= FSaveCfg.IconFile;
    if FSaveCfg.IconIndex >=0 then Settings.GrpIconIndex:= FSaveCfg.IconIndex;
    if FSaveCfg.CBXShortCut.Checked then
    begin
      if length(FSaveCfg.IconFile) > 0 then Settings.GrpIconFile:= FSaveCfg.IconFile;
      if FSaveCfg.IconIndex >=0 then Settings.GrpIconIndex:= FSaveCfg.IconIndex;
      CreateShortcut(Application.ExeName, DesktopPath, Settings.GroupName, '','', 'Grp='+Settings.GroupName,
                     sProgramsGroup+' '+Settings.GroupName, Settings.GrpIconFile, Settings.GrpIconIndex);
    end;
    SaveConfig(Settings.GroupName, StateChanged);
    ListeChange:= False;
    SettingsChange:= False;
    SBSave.Enabled:= False;
    PMnuSave.Enabled:= PMnuEnable(PMnuSave, SBSave.Glyph,  False);
  end ;
end;

procedure TFProgram.Timer2Timer(Sender: TObject);
begin

end;

procedure TFProgram.SBPrefsClick(Sender: TObject);
var
  OldDSKMnu: Boolean;
  Reg: TRegistry;
  DskCtxKey: String;
  NewStylStr: string;
  NewTXTStyl: TFontStyles;
  TxtStyleChg: Boolean;
begin
  TxtStyleChg:=false;
  With Prefs do
  begin
    LWinVer.Caption:= ' '+OSVersion.VerDetail;
    if OSVersion.VerMaj > 5 then   // Vista et après
    IconDefFile:= SystemRoot+'\system32\imageres.dll' else
    IconDefFile:= SystemRoot+'\system32\shell32.dll';
    ImgGrpIcon.Picture.Icon.Handle:= Application.Icon.Handle;
    CBLangue.ItemIndex:= CurLang;
    CBStartWin.Checked:= Settings.StartWin;
    CBSavSizePos.Checked:= Settings.SavSizePos;
    CBNoChkNewVer.Checked:= Settings.NoChkNewVer;
    CBMiniInTray.Checked:= Settings.MiniInTray;
    CBHideInTaskbar.Enabled:= Settings.MiniInTray;
    CBHideInTaskbar.checked:= Settings.HideInTaskbar;
    CBXDesktopMnu.Checked:= Settings.DeskTopMnu;
    OldDSKMnu:= Settings.DeskTopMnu;
    CBIconcache.Checked:= Settings.IconCache;
    ColorPickerBkgnd.color:= Settings.BkgrndColor;
    ColorPickerFont.color:= Settings.TextColor;
    // Fontstyle
    CBBold.checked:= (fsBold in ListView1.Font.Style);
    CBItal.checked:= (fsItalic in ListView1.Font.Style);
    CBUnder.Checked:= (fsUnderline in Listview1.Font.Style);
    ESize.Caption:= InttoStr(ListView1.Font.Size);
    if ShowModal = mrOK then
    begin
      If CBLangue.ItemIndex <> CurLang then
      begin
        CurLang:= CBLangue.ItemIndex;
        Settings.LangStr:= LangNums[CurLang];
        ModLangue;
        Application.QueueAsyncCall(@CheckUpdate, ChkVerInterval);
      end;
      Settings.StartWin:= CBStartWin.Checked;
      Settings.SavSizePos:= CBSavSizePos.Checked;
      Settings.NoChkNewVer:= CBNoChkNewVer.Checked;
      Settings.MiniInTray:= CBMiniInTray.Checked;
      Settings.IconCache:= CBIconCache.Checked;
      Settings.DeskTopMnu:= CBXDesktopMnu.Checked;
      Settings.BkgrndColor:= ColorPickerBkgnd.color;
      ListView1.Color:= ColorPickerBkgnd.color;
      // Display text properly after color change
      if not (Settings.TextColor= ColorPickerFont.color) then
      begin
        Settings.TextColor:= ColorPickerFont.color;
        ListView1.Font.Color:= ColorPickerFont.color;
        TxtStyleChg:= true;
       end;
      NewStylStr:='';
      if CBBold.checked then NewStylStr:= 'B';
      if CBItal.checked then NewStylStr:= NewStylStr+'I';
      if CBUnder.checked then NewStylStr:=NewStylStr+'U';
      If NewStylStr <> Settings.TextStyle then
      begin
        TxtStyleChg:= true;
        Settings.TextStyle:=NewStylStr;
        NewTXTStyl:= [];
        if Pos('B', upperCase(Settings.TextStyle)) >0 then NewTXTStyl:= NewTXTStyl+[fsBold];
        if Pos('I', upperCase(Settings.TextStyle)) >0 then NewTXTStyl:= NewTXTStyl+[fsItalic];
        if Pos('U', upperCase(Settings.TextStyle)) >0 then NewTXTStyl:= NewTXTStyl+[fsUnderline];
        ListView1.Font.Style:= NewTXTStyl;
      end;
      try
        if Settings.TextSize <> StrToInt(ESize.Caption) then
        begin
          TxtStyleChg:= true;
          ListView1.Font.Size:= StrToInt(ESize.Caption);
          Settings.TextSize:= ListView1.Font.Size;
        end;
      except
      end;
      if TxtStyleChg then LVDisplayFiles;
      If ImgChanged then
      begin
        Application.Icon:= ImgGrpIcon.Picture.Icon ;
        Application.ProcessMessages;
        Settings.GrpIconFile:= IconFile;
        Settings.GrpIconIndex:= IconIndex;
        SBSave.Enabled:= True;
        PMnuSave.Enabled:= PmnuEnable(PMnuSave, SBSave.Glyph, True);
      end;
    end;
    Settings.HideInTaskBar:= CBHideInTaskbar.Checked;
    if CBXShortCut.Checked then
    begin
      CreateShortcut(Application.ExeName, DesktopPath, Settings.GroupName, '','', 'Grp='+Settings.GroupName,
                     sProgramsGroup+' '+Settings.GroupName, Settings.GrpIconFile, Settings.GrpIconIndex);
    end;
    // Program in desktop context menu has changed
    if Settings.DeskTopMnu <> OldDSKMnu then
    begin
      reg := TRegistry.Create(KEY_WRITE);
      reg.RootKey := HKEY_CLASSES_ROOT;
      reg.Access:= KEY_ALL_ACCESS;
      DskCtxKey:= 'Directory\Background\shell\ProgramGrpMgr';
      if Settings.DeskTopMnu then
      begin
        Reg.CreateKey(DskCtxKey);
        Reg.CreateKey(DskCtxKey+'\command');
        Reg.OpenKey(DskCtxKey, true);
        Reg.WriteString('',LocalizedName);
        reg.CloseKey;
        Reg.OpenKey(DskCtxKey+'\command', true);
        Reg.WriteString('',Application.ExeName) ;
      end else
      begin
        Reg.OpenKey(DskCtxKey+'\command', False);
        Reg.DeleteValue('');
        reg.CloseKey;
        Reg.OpenKey(DskCtxKey, False);
        Reg.DeleteValue('');
        reg.CloseKey;
        reg.DeleteKey(DskCtxKey+'\command');
        reg.DeleteKey(DskCtxKey);
      end;
      reg.free;
    end;
    TrayProgman.Visible:= Settings.MiniInTray;
  end;
end;


procedure TFProgram.SBLoadConfClick(Sender: TObject);
var
  s, FilNamWoExt: String;
  i, j, w: integer;
begin
  w:= FloadConf.Width;
  With FloadConf do
  begin
     LB2.Clear;
    FilNamWoExt:= TrimFileExt(ConfigFile);
    j:= 0;
    For i:= 0 to 9 do
    begin
     s:= FilNamWoExt+'.bk'+IntToStr(i);
     If FileExists(s) then
     begin
       FileList [i,0]:= s;
       FileList [i,1]:= DateTimeToStr(FileGetDateTime (s, ftLastWrite));
       LB2.Items.Add(ExtractFileName(FileList[i,0])+' - '+FileList [i,1]);
       inc(j);
     end;
     if LB2.Canvas.TextWidth(ExtractFileName(s)) > LB2.ClientWidth then FloadConf.Width:= w+LB2.Canvas.TextWidth(ExtractFileName(s))- LB2.ClientWidth+6 ;
    end;
    BtnApply.Enabled:= False;
    if ShowModal =  mrOK then
    begin
      if LB2.ItemIndex >= 0 then
      begin
        ListeFichiers.Reset;
        LoadCfgFile(FileList[LB2.ItemIndex,0]);
        LVDisplayFiles;
      end;
    end;
  end;
end;

procedure TFProgram.PMnuAddBkgndImgClick(Sender: TObject);
begin
  if OPictDlg.execute then
  begin
    Settings.BkgrndImage:= OPictDlg.FileName;
    try
      BkGndPicture:= TPicture.Create;
      BkGndPicture.LoadFromFile(Settings.BkgrndImage);
      PMnuAddBkgndImg.Caption:= MnuRepImageStr;
      PMnuDelBkgndImg.Enabled:= PMnuEnable (PMnuDelBkgndImg, ImgMnus, true, 1);
    except
      BkGndPicture:= nil;
      Settings.BkgrndImage:='';
      PMnuDelBkgndImg.Enabled:= PMnuEnable (PMnuDelBkgndImg, ImgMnus, false, 1);
    end;
    ListView1.Invalidate;
  end;

end;


procedure TFProgram.SBAboutClick(Sender: TObject);
var
    chked: Boolean;
    alertmsg, s: String;
begin
  AboutBox.LastUpdate:= Settings.LastUpdChk;
  chked:= AboutBox.Checked;
  AboutBox.ErrorMessage:='';
  //AboutBox.Version:= '0.9.0.0';
  AboutBox.ShowModal;
  // If we have checked update and got an error
  if length(AboutBox.ErrorMessage)>0 then
  begin
    alertmsg := AboutBox.ErrorMessage;
    if AlertDlg(Caption,  alertmsg, ['OK', CancelBtn, NoLongerChkUpdates],
                    true, mtError)= mrYesToAll then Settings.NoChkNewVer:= true;
  end;
  // Truncate date to avoid changes if there is the same day (hh:mm are in the decimal part of the date)
  if (not chked) and AboutBox.Checked then Settings.LastVersion:= AboutBox.LastVersion;
  if trunc(AboutBox.LastUpdate) > trunc(Settings.LastUpdChk) then
  begin
    Settings.LastUpdChk:= AboutBox.LastUpdate;
  end;
end;

procedure TFProgram.SBQuitClick(Sender: TObject);
begin
  close;
end;

// Double click on tray icon restore the program et put it in front of other windows

procedure TFProgram.TrayProgmanDblClick(Sender: TObject);
begin
  PTrayMnuRestoreClick(Sender);
  SetForeGroundWindow(Handle);
end;


// Change display if mouse cursor is on an item or in an other sone of the listview

procedure TFProgram.ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);

var
  hIco: hIcon;
  liOver: TListItem;
begin
  liOver:= ListView1.GetItemAt(X, Y);
  ListView1.Hint:='';
  ImgPrgSel.Picture.Icon.Handle:=  ExtractIconU(handle, Settings.GrpIconFile, Settings.GrpIconIndex);
  // We are on an item
  if liOver <> nil then
  begin
    ListView1.Hint:= ListeFichiers.GetItem(liOver.Index).Description ;
    hIco:= ExtractIconU(handle, ListeFichiers.GetItem(liOver.Index).IconFile,ListeFichiers.GetItem(liOver.Index).IconIndex);
    ImgPrgSel.Picture.Icon.Handle:=  hIco;
  end else
  begin
    if ListView1.Selected <> nil then
    begin
      ListView1.Hint:= ListeFichiers.GetItem(ListView1.Selected.Index).Description;
      hIco:= ExtractIconU(handle, ListeFichiers.GetItem(ListView1.Selected.Index).IconFile,ListeFichiers.GetItem(ListView1.Selected.Index).IconIndex);
      ImgPrgSel.Picture.Icon.Handle:=  hIco;
    end ;
  end;
  LPrgSel.Caption:= ListView1.Hint;
end;

procedure TFProgram.ListView1Resize(Sender: TObject);
begin
  LVDisplayFiles;
end;

procedure TFProgram.LVPMnuPopup(Sender: TObject);
var
  s: String;
begin
  if ListView1.Selected <> nil then
  begin
    PMnuRun.Visible:= True;
    PMnuRunAs.Visible:= True;
    PMnuProps.Visible:= True;
    N1.Visible:= True;
    PMnuDelete.Visible:= True;
    PMnuCopy.visible:= true;
    PMnuPaste.visible:= false;
    PMnuHideBars.Visible:= False;
    N2.Visible:= False;
    PMnuGroup.Visible:= False;
    PMnuFolder.Visible:= False;
    PMnuAddFile.Visible:= False;
    N3.Visible:= False;
    PMnuAddBkgndImg.Visible:= False;
    PMnuDelBkgndImg.Visible:= False;
    N41.Visible:= False;
    N4.Visible:= False;
    PMnuSave.Visible:= False;
    PMnuPrefs.Visible:= False;
    PMnuLoadConf.Visible:= False;
    N4.Visible:= False;
    PMnuAbout.Visible:= False;
    N5.Visible:= False;
    PMnuQuit.Visible:= False;
  end else
  begin
    PMnuRun.Visible:= False;
    PMnuRunAs.Visible:= False;
    PMnuProps.Visible:= False;
    N1.Visible:= False;
    PMnuDelete.Visible:= False;
    PMnuCopy.Visible:= False;
    PMnuPaste.Visible:= true;
    PMnuHideBars.Visible:= True;
    N2.Visible:= True;
    PMnuGroup.Visible:= True;
    PMnuFolder.Visible:= True;
    PMnuAddFile.Visible:= True;
    N3.Visible:= True;
    PMnuAddBkgndImg.Visible:= True;
    PMnuDelBkgndImg.Visible:= True;
    N41.Visible:= True;
    N4.Visible:= True;
    PMnuSave.Visible:= True;
    PMnuPrefs.Visible:= True;
    PMnuLoadConf.Visible:= True;
    N4.Visible:= True;
    PMnuAbout.Visible:= True;
    N5.Visible:= True;
    PMnuQuit.Visible:= True;
  end;
  s:= Clipboard.AsText;
  PMnuPaste.Enabled:= Boolean(pos('#PrgGrpItem#', s)); //Enable paste menu
  CropBitmap(ImgMnus, PMnuPaste.Bitmap, PMnuPaste.Enabled,3);
end;






procedure TFProgram.PMnuCopyClick(Sender: TObject);
begin
   ListeFichiers.CopyToClipboard(ListeFichiers.GetItem(ListView1.Selected.Index));
end;

procedure TFProgram.PMnuDelBkgndImgClick(Sender: TObject);
begin
    Settings.BkgrndImage:='';
  BkGndPicture:= nil;
  PMnuDelBkgndImg.Enabled:= PMnuEnable (PMnuDelBkgndImg, ImgMnus, false, 1);
  PMnuAddBkgndImg.Caption:= MnuAddImageStr;
  ListView1.Invalidate;
end;


procedure TFProgram.CBDisplayChange(Sender: TObject);
begin
  ListeChange:= True;
  SettingsChange:= True;
  LVDisplayFiles;
  Settings.IconDisplay:= CBDisplay.ItemIndex;
  Settings.IconSort:= CBSort.ItemIndex;
  SBSave.Enabled:= True;
  PMnuSave.Enabled:= PMnuEnable(PMnuSave, SBSave.Glyph, True);
end;

procedure TFProgram.CBSortChange(Sender: TObject);
begin
  Settings.IconSort:= CBSort.ItemIndex;
end;

procedure TFProgram.PMnuDeleteClick(Sender: TObject);
var
  i: Integer;
  s: string;
  capt: array  [0..1] of string;
begin
  capt[0]:= YesBtn;
  capt[1]:= NoBtn;
  With ListView1 do
    begin
      if SelCount = 0 then exit
      else
      begin
        If Selcount > 1 then s:= 's' else s:= '';
        If MsgDlg (FProgram.Caption, Format(DeleteOKMsg, [SelCount, s]),
                   mtWarning,[mbYes, mbNo],capt, 0 ) = mrYes then
          for i :=Items.Count-1 downto 0 do
          begin
            if Items[i].Selected then
            ListeFichiers.Delete(i);
          end;
      end;
  end;
  ListeChange:= True;
  LVDisplayFiles;
end;

procedure TFProgram.PMnuPropsClick(Sender: TObject);
var
  Item : TListItem;
  MyFichier: TFichier;
  OldTarget: String;
  siz: double;
  unite: string;
begin
  Item := ListView1.Selected;
  If Item = nil then exit;
  Fproperty.IconDefFile:= IconDefFile;
  MyFichier:=  ListeFichiers.GetItem(Item.Index);
  Fproperty.IconFile:= MyFichier.IconFile;
  Fproperty.IconIndex:= MyFichier.IconIndex;
  Fproperty.Image1.Picture.Icon.Handle:= ExtractAssociatedIconU(Handle, PChar(MyFichier.IconFile), MyFichier.IconIndex);
  Fproperty.Caption:= Format(FpropertyCaption, [MyFichier.DisplayName]);
  FProperty.EDisplayName.Text:= MyFichier.DisplayName;
  FProperty.LTypeName.Caption:= MyFichier.TypeName;
  FProperty.ECible.Text:= MyFichier.Path+ MyFichier.Name;
  FProperty.EParams.Text:= MyFichier.Params;
  OldTarget:= FProperty.ECible.Text;
  Fproperty.EPath.Text:= MyFichier.StartPath;
  siz:= MyFichier.size;
  if (siz >= 0) and  (siz < $400) then unite:= Format(Fproperty.FileSizeCaption+' %.0n %s', [siz, Fproperty.FileSizeByte]);     // less 1Ko
  if (siz >= $400) and  (siz < $100000) then unite:= Format(Fproperty.FileSizeCaption+' %.2n %s', [siz/$400, Fproperty.FileSizeKB]);   // less 1Mo
  if (siz >= $100000) and  (siz < $40000000) then unite:= Format(Fproperty.FileSizeCaption+'  %.2n %s', [siz/$100000, Fproperty.FileSizeMB]);  // less 1Go
  if (siz >= $40000000) then unite:=  Format(Fproperty.FileSizeCaption+' %.2n %s', [siz/$40000000, Fproperty.FileSizeGB]);  // less 1Go
  FProperty.LFileSize.Caption:= unite;
  try
     FProperty.LFiledate.Caption:= FProperty.FileDateCaption+' '+DateTimeToStr(MyFichier.Date) ;
  except
  end;
  FProperty.Memo1.Text:= MyFichier.Description;
  FProperty.PMnuPropsOldIcon.Checked:= MyFichier.OldIcon;
  if FProperty.Showmodal = mrOK then
  begin
      if FProperty.ECible.Text <> OldTarget then
      begin
         ZeroMemory(@MyFichier, sizeOf(MyFichier));
         MyFichier:= GetFile(FProperty.ECible.Text);
         ListeFichiers.ModifyFile(Item.Index, MyFichier );
      end else
      begin
        if MyFichier.StartPath <> Fproperty.EPath.Text then
           ListeFichiers.ModifyField(Item.Index, 'StartPath', Fproperty.EPath.Text);
        if MyFichier.IconFile <> Fproperty.IconFile then
           ListeFichiers.ModifyField(Item.Index, 'IconFile', Fproperty.IconFile);
        if MyFichier.IconIndex <> Fproperty.IconIndex then
           ListeFichiers.ModifyField(Item.Index, 'IconIndex', Fproperty.IconIndex);
        if MyFichier.DisplayName <> FProperty.EDisplayName.Text then
           ListeFichiers.ModifyField(Item.Index, 'DisplayName', FProperty.EDisplayName.Text);
        if MyFichier.Description <> FProperty.Memo1.Text then
           ListeFichiers.ModifyField(Item.Index, 'Description', FProperty.Memo1.Text);
        if MyFichier.Params <> FProperty.EParams.Text then
           ListeFichiers.ModifyField(Item.Index, 'Params', FProperty.EParams.Text);
        if MyFichier.OldIcon <> FProperty.PMnuPropsOldIcon.Checked then
           ListeFichiers.ModifyField(Item.Index, 'OldIcon', FProperty.PMnuPropsOldIcon.Checked);
        if MyFichier.TypeName <> FileGetType(MyFichier.Path+MyFichier.Name) then
           ListeFichiers.ModifyField(Item.Index, 'TypeName', FileGetType(MyFichier.Path+MyFichier.Name));
        if MyFichier.Size <> FileGetSize(MyFichier.Path+MyFichier.Name) then
           ListeFichiers.ModifyField(Item.Index, 'Size', FileGetSize(MyFichier.Path+MyFichier.Name));
        if MyFichier.Date <> FileGetDateTime(MyFichier.Path+MyFichier.Name, ftCreate)then
           ListeFichiers.ModifyField(Item.Index, 'Date', FileGetDateTime(MyFichier.Path+MyFichier.Name, ftCreate));
      end;
       If ListeChange then LVDisplayFiles;
  end;
end;

procedure TFProgram.FormWindowStateChange(Sender: TObject);
begin
  Case WindowState of
      wsNormal: begin
           PTrayMnuRestore.Enabled:= False;
           PTrayMnuMinimize.Enabled:= True;
           PTrayMnuMaximize.Enabled:= True;
         end;
      wsMinimized: begin
           PTrayMnuRestore.Enabled:= True;
           PTrayMnuMinimize.Enabled:= False;
           PTrayMnuMaximize.Enabled:= True;
         end;
      wsMaximized: begin
           PTrayMnuRestore.Enabled:= True;
           PTrayMnuMinimize.Enabled:= True;
           PTrayMnuMaximize.Enabled:= False;
         end;
    end;
  ListView1.Invalidate;
end;



// Display background image

procedure TFProgram.ListView1CustomDraw(Sender: TCustomListView;
  const ARect: TRect; var DefaultDraw: Boolean);
begin
  if BkGndPicture=nil then exit;
  with Sender as TListview do
  begin
      Canvas.StretchDraw(ARect, BkGndPicture.Bitmap);
      Perform(LVM_SETTEXTBKCOLOR, 0, LongInt(CLR_NONE));
      Perform(LVM_SETBKCOLOR,0, LongInt(CLR_NONE));
  end;
end;

// Display customized item text

procedure TFProgram.ListView1CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
var
  txt: string;
  rec: TRect;
  txtstyl: TTextStyle;
begin
  txt:= ListeFichiers.GetItem(Item.Index).DisplayName;;
  rec := Item.DisplayRect(drLabel);
  Item.Caption:=  '';
  if Item.selected then
  begin
    Sender.Canvas.Brush.Color := clHighlight;
    Sender.Canvas.Brush.Style := bsSolid;
    Sender.Canvas.FillRect(rec );
    Sender.Canvas.Font.Color := clHighlightText;
  end else
  begin
    Item.Caption := '';
    Sender.Canvas.brush.color:= clNone;
    Sender.Canvas.brush.Style:= bsClear;
  end;
  txtstyl:= Sender.Canvas.TextStyle;
  txtstyl.Alignment:= taCenter;
  txtstyl.Layout:= tlTop;
  txtstyl.WordBreak := true;
  txtstyl.SingleLine := false;
  Sender.Canvas.TextRect(rec, 0, rec.top, txt, txtstyl );
end;

procedure TFProgram.ListView1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin


end;

// Language translation routines

procedure TFProgram.ModLangue ;
var
  UTF16S: UnicodeString;
  s: string;
begin
LangStr:=  Settings.LangStr;
OSVersion:= TOSVersion.Create(LangStr, LangFile);
AboutBox.LVersion.Hint:= OSVersion.VerDetail;
With LangFile do
 begin
   // MessageBox buttons
   YesBtn:= ReadString(LangStr, 'YesBtn', 'Oui');
   NoBtn:= ReadString(LangStr, 'NoBtn', 'Non');
   CancelBtn:= ReadString(LangStr, 'CancelBtn', 'Annuler');
   LocalizedName:= ReadString(LangStr, 'LocalizedName', LocalizedName);
   //Form
   CBDisplay.Items.Text:= StringReplace(ReadString(LangStr, 'CBDisplay.Items.Text', ''),
                      '%s', #13#10, [rfReplaceAll]);
   CBDisplay.ItemIndex:= Settings.IconDisplay;
   CBSort.Items.Text:=  StringReplace(ReadString(LangStr, 'CBSort.Items.Text',
                      'Pas de tri%sTri par nom (ascendant)%sTri par nom (descendant)%sTri par date (ascendant)%sTri par date (descendant)'),
                     '%s', #13#10, [rfReplaceAll]);
   CBSort.ItemIndex:= Settings.IconSort;
   SDD1.Title:= ReadString(LangStr, 'SDD1.Title', SDD1.Title);
   SBGroup.Hint:= ReadString(LangStr, 'SBGroup.Hint', SBGroup.Hint);
   SBFolder.Hint:= ReadString(LangStr, 'SBFolder.Hint', SBFolder.Hint);
   SBAddFile.Hint:= ReadString(LangStr, 'SBAddFile.Hint', SBAddFile.Hint);
   SBAbout.Hint:= ReadString(LangStr, 'SBAbout.Hint', SBAbout.Hint);
   SBSave.Hint:=  ReadString(LangStr, 'SBSave.Hint', SBSave.Hint);
   SBPrefs.Hint:= ReadString(LangStr, 'SBPrefs.Hint', SBPrefs.Hint);
   SBQuit.Hint:= ReadString(LangStr, 'SBQuit.Hint', SBQuit.Hint);
   SBLoadConf.Hint:= ReadString(LangStr, 'SBLoadConf.Hint', SBLoadConf.Hint);
   ODlg1.Title:= ReadString(LangStr, 'ODlg1.Title', ODlg1.Title);
   PMnuRun.Caption:= ReadString(LangStr, 'PMnuRun.Caption', PMnuRun.Caption);
   PMnuRunAs.Caption:= ReadString(LangStr, 'PMnuRunAs.Caption', PMnuRunAs.Caption);
   PMnuProps.Caption:= ReadString(LangStr, 'PMnuProps.Caption', PMnuProps.Caption);
   PMnuDelete.Caption:= ReadString(LangStr, 'PMnuDelete.Caption', PMnuDelete.Caption);
   PMnuGroup.Caption:= SBGroup.Hint;
   PMnuFolder.Caption:= SBFolder.Hint;
   PMnuAddFile.Caption:= SBAddFile.Hint;
   PMnuAbout.Caption:= SBAbout.Hint;
   PMnuSave.Caption:= SBSave.Hint;
   PMnuPrefs.Caption:= SBPrefs.Hint;
   PMnuLoadConf.Caption:= SBLoadConf.Hint;
   PMnuQuit.Caption:= ReadString(LangStr, 'PMnuQuit.Caption', PMnuQuit.Caption);
   PMnuCopy.Caption:= ReadString(LangStr, 'PMnuCopy.Caption', PMnuCopy.Caption);
   PMnuPaste.Caption:= ReadString(LangStr, 'PMnuPaste.Caption', PMnuPaste.Caption);
   MnuAddImageStr:= ReadString(LangStr, 'MnuAddImageStr', 'Ajouter une image d''arrière plan');
   MnuRepImageStr:= ReadString(LangStr, 'MnuRepImageStr', 'Remplacer l''image d''arrière plan');
   PMnuDelBkgndImg.Caption:= ReadString(LangStr, 'PMnuDelBkGndImage.Caption', PMnuDelBkgndImg.Caption);
   PTrayMnuRestore.Caption:= ReadString(LangStr, 'PTrayMnuRestore.Caption', PTrayMnuRestore.Caption);
   PTrayMnuMinimize.Caption:= ReadString(LangStr, 'PTrayMnuMinimize.Caption', PTrayMnuMinimize.Caption);
   PTrayMnuMaximize.Caption:= ReadString(LangStr, 'PTrayMnuMaximize.Caption', PTrayMnuMaximize.Caption);
   PTrayMnuAbout.Caption:= SBAbout.Hint;
   PTrayMnuQuit.Caption:= PMnuQuit.Caption;
   sBackupPrefs:= ReadString(LangStr, 'BackupPrefs', 'Sauvegarde des préférences');
   SMnuMaskBars:= LangFile.ReadString(LangStr, 'PMnuMaskBars','Masquer la barre de boutons');
   SMnuShowBars:= LangFile.ReadString(LangStr, 'PMnuShowBars','Afficher la barre de boutons');
   if Settings.HideBars then PMnuHideBars.Caption:= SMnuShowBars
   else PMnuHideBars.Caption:= SMnuMaskBars;
   ShortCutName:= ReadString(LangStr, 'ShortCutName', 'Gestionnaire de groupe de programmes');
   DeleteOKMsg:= ReadString(LangStr, 'DeleteOKMsg', 'Vous allez effacer %u élément%s. Etes-vous sur ?');
   sProgramsGroup:= ReadString(LangStr, 'sProgramsGroup', 'Groupe de programmes:');
   sCannotGetNewVerList:=ReadString(LangStr,'CannotGetNewVerList','Liste des nouvelles versions indisponible');
   sNoLongerChkUpdates:=ReadString(LangStr,'NoLongerChkUpdates','Ne plus rechercher les mises à jour');

    // About
    if not AboutBox.checked then AboutBox.LUpdate.Caption:=ReadString(LangStr,'AboutBox.LUpdate.Caption',AboutBox.LUpdate.Caption) else
    begin
      if AboutBox.NewVersion then AboutBox.LUpdate.Caption:= Format(AboutBox.sUpdateAvailable, [AboutBox.LastVersion])
      else AboutBox.LUpdate.Caption:= AboutBox.sNoUpdateAvailable;
    end;
    AboutBox.sLastUpdateSearch:=ReadString(LangStr,'AboutBox.LastUpdateSearch','Dernière recherche de mise à jour');
    AboutBox.sUpdateAvailable:=ReadString(LangStr,'AboutBox.UpdateAvailable','Nouvelle version %s disponible');
    AboutBox.sNoUpdateAvailable:=ReadString(LangStr,'AboutBox.NoUpdateAvailable','Le gestionnaire de programmes est à jour');
    Aboutbox.Caption:=ReadString(LangStr,'Aboutbox.Caption','A propos du Gestionnaire de programmes');
    AboutBox.LProductName.Caption:= caption;
    AboutBox.LProgPage.Caption:= ReadString(LangStr,'AboutBox.LProgPage.Caption', AboutBox.LProgPage.Caption);
    AboutBox.UrlProgSite:= sUrlProgSite+ ReadString(LangStr,'AboutBox.UrlProgSite','Accueil');
    AboutBox.LWebSite.Caption:= ReadString(LangStr,'AboutBox.LWebSite.Caption', AboutBox.LWebSite.Caption);
    AboutBox.LSourceCode.Caption:= ReadString(LangStr,'AboutBox.LSourceCode.Caption', AboutBox.LSourceCode.Caption);

   NoLongerChkUpdates:= ReadString(LangStr, 'NoLongerChkUpdates', 'Ne plus rechercher les mises à jour');
   //NextChkCaption:= ReadString(LangStr, 'NextChkCaption', 'Prochaine vérification');
   NoDeleteGroup:= ReadString(LangStr, 'NoDeleteGroup', 'Impossible de supprimer le groupe en cours');
   DeleteGrpMsg:= ReadString(LangStr, 'DeleteGrpMsg', 'Vous allez effacer le groupe %s. Etes-vous sur ?');

   FSaveCFG.Caption := ReadString(LangStr, 'FSaveCFG.Caption', FSaveCFG.Caption);
   FSaveCfg.Label1.Caption:= StringReplace(ReadString(LangStr, 'FSaveCfg.Label1.Caption',
                              'Le groupe de programmes a été mofifié.%sVoulez-vous enregistrer ces modifications ?'),
                               '%s', #13#10, [rfReplaceAll]);
   FSaveCfg.RBtnSave.Caption:= ReadString(LangStr, 'FSaveCfg.RBtnSave.Caption', FSaveCfg.RBtnSave.Caption);
   FSaveCfg.RBtnSaveAs.Caption:= ReadString(LangStr, 'FSaveCfg.RBtnSaveAs.Caption', FSaveCfg.RBtnSaveAs.Caption);
   FSaveCfg.CBXShortCut.Caption:= ReadString(LangStr, 'FSaveCfg.CBXShortCut.Caption', FSaveCfg.CBXShortCut.Caption);
   FSaveCfg.LGrpIcon.Caption:= ReadString(LangStr, 'FSaveCfg.LGrpIcon.Caption', FSaveCfg.LGrpIcon.Caption);
   FSaveCfg.ImgGrpIcon.Hint:= ReadString(LangStr, 'FSaveCfg.ImgGrpIcon.Hint', FSaveCfg.ImgGrpIcon.Hint);
   FSaveCfg.BtnCancel.Caption:= CancelBtn;
   //AboutBox.Caption:= SBAbout.Hint;

   use64bitcaption:= ReadString(LangStr, 'use64bitcaption', 'Utilisez la version 64 bits de ce programme');

   Prefs.Caption:= ReadString(LangStr, 'Prefs.Caption', Prefs.Caption);
   Prefs.CBStartWin.Caption:= ReadString(LangStr, 'Prefs.CBStartWin.Caption', prefs.CBStartWin.Caption);
   Prefs.CBSavSizePos.Caption:= ReadString(LangStr, 'Prefs.CBSavSizePos.Caption', Prefs.CBSavSizePos.Caption);
   Prefs.CBNoChkNewVer.Caption:= ReadString(LangStr, 'Prefs.CBNoChkNewVer.Caption', Prefs.CBNoChkNewVer.Caption);
   Prefs.LLangue.Caption:= ReadString(LangStr, 'Prefs.LLangue.Caption', Prefs.LLangue.Caption);
   Prefs.BtnCancel.Caption:= CancelBtn;
   Prefs.CBMiniInTray.Caption:= ReadString(LangStr, 'Prefs.CBMiniInTray.Caption', Prefs.CBMiniInTray.Caption);
   Prefs.CBMiniInTray.Hint:= ReadString(LangStr, ' Prefs.CBMiniInTray.Hint',  Prefs.CBMiniInTray.Hint);
   Prefs.CBHideInTaskBar.Caption:= ReadString(LangStr, 'Prefs.CBHideInTaskBar.Caption', Prefs.CBHideInTaskBar.Caption);
   Prefs.CBHideInTaskBar.Hint:= ReadString(LangStr, 'Prefs.CBHideInTaskBar.Hint',  Prefs.CBHideInTaskBar.Hint);
   Prefs.ImgGrpIcon.Hint:= FSaveCfg.ImgGrpIcon.Hint;
   Prefs.LGrpIcon.Caption:= FSaveCfg.LGrpIcon.Caption;
   Prefs.CBXShortCut.Caption:= FSaveCfg.CBXShortCut.Caption;
   Prefs.CBXDesktopMnu.Caption:= ReadString(LangStr, 'Prefs.CBXDesktopMnu.Caption',  Prefs.CBXDesktopMnu.Caption);
   Prefs.CBXDesktopMnu.Hint:= StringReplace(ReadString(LangStr, 'Prefs.CBXDesktopMnu.Hint', Prefs.CBXDesktopMnu.Hint),
                               '%s', #13#10, [rfReplaceAll]);
   Prefs.LBkgndColor.Caption:= ReadString(LangStr, 'Prefs.LBkgndColor.Caption', Prefs.LBkgndColor.Caption);
   Prefs.LTextColor.Caption:= ReadString(LangStr, 'Prefs.LTextColor.Caption', Prefs.LTextColor.Caption);
   Prefs.CBBold.Caption:= ReadString(LangStr, 'Prefs.CBBold.Caption', Prefs.CBBold.Caption);
   Prefs.CBItal.Caption:= ReadString(LangStr, 'Prefs.CBItal.Caption', Prefs.CBItal.Caption);
   Prefs.CBUnder.Caption:= ReadString(LangStr, 'Prefs.CBUnder.Caption', Prefs.CBUnder.Caption);
   Prefs.ESize.Hint:=  ReadString(LangStr, 'Prefs.ESize.Hint', Prefs.ESize.Hint);
   Prefs.LTextStyle.Caption:= ReadString(LangStr, 'Prefs.LTextStyle.Caption', Prefs.LTextStyle.Caption);

   FPropertyCaption:= ReadString(LangStr, 'FPropertyCaption', 'Propriétés de %s');
   FProperty.TSGeneral.Caption:= ReadString(LangStr, 'FProperty.TSGeneral.Caption', FProperty.TSGeneral.Caption);
   FProperty.LFileType.Caption:= ReadString(LangStr, 'FProperty.LFileType.Caption', FProperty.LFileType.Caption);
   FProperty.LDescription.Caption:= ReadString(LangStr, 'FProperty.LDescription.Caption', FProperty.LDescription.Caption);
   FProperty.Caption:= FPropertyCaption;
   FProperty.Image1.Hint:= FSaveCfg.ImgGrpIcon.Hint;
   FProperty.BtnCancel.Caption:= CancelBtn; //FSaveCfg.BtnCancel.Caption;
   FProperty.LCible.Caption:= ReadString(LangStr, 'FProperty.LCible.Caption', FProperty.LCible.Caption);
   FProperty.SBCible.Hint:= ReadString(LangStr, 'FProperty.SBCible.Hint', FProperty.SBCible.Hint);
   FProperty.LParams.Caption:= ReadString(LangStr, 'FProperty.LParams.Caption', FProperty.LParams.Caption);
   FProperty.LPath.Caption:= ReadString(LangStr, 'Fproperty.LPath.Caption', FProperty.LPath.Caption);
   FProperty.PMnuSelectIcon.Caption:= ReadString(LangStr, 'FProperty.PMnuSelectIcon.Caption', FProperty.PMnuSelectIcon.Caption);
   FProperty.PMnuPropsOldIcon.Caption:= ReadString(LangStr, 'FProperty.PMnuPropsOldIcon', FProperty.PMnuPropsOldIcon.Caption);
   FProperty.FileSizeCaption:= ReadString(LangStr, 'FProperty.FileSizeCaption', 'Taille :');
   FProperty.FileDateCaption:= ReadString(LangStr, 'FProperty.FileDateCaption', 'Date :');
   FProperty.FileSizeByte:= ReadString(LangStr, 'FProperty.FileSizeByte', 'octet(s)');
   FProperty.FileSizeKB:= ReadString(LangStr, 'FProperty.FileSizeKB', 'Ko');
   FProperty.FileSizeMB:= ReadString(LangStr, 'FProperty.FileSizeMB', 'Mo');
   FProperty.FileSizeGB:= ReadString(LangStr, 'FProperty.FileSizeGB', 'Go');

   FLoadGroup.Caption:= SBGroup.Hint;
   FLoadGroup.BtnNew.Caption:= ReadString(LangStr, 'FLoadGroup.BtnNew.Caption', FLoadGroup.BtnNew.Caption);
   FLoadGroup.BtnDelete.Caption:= ReadString(LangStr, 'FLoadGroup.BtnDelete.Caption', FLoadGroup.BtnDelete.Caption);
   FLoadGroup.BtnCancel.Caption:= CancelBtn; //SBrow1.CancelBtnCaption;

   FloadConf.Caption:= ReadString(LangStr, 'FloadConf.Caption', FloadConf.Caption);
   FLoadConf.BtnApply.Caption:= ReadString(LangStr, 'FLoadConf.BtnApply.Caption', FLoadConf.BtnApply.Caption);
   FLoadConf.BtnCancel.Caption:= ReadString(LangStr, 'FLoadConf.BtnCancel.Caption', FLoadConf.BtnCancel.Caption);
 end;
end;


// Callback function for enum resources (Experimental)
function EnumProc(hModule: HMODULE; lpszType, lpszName: PChar; lParam: PtrInt): BOOL; stdcall;
begin
  result:= False;
  if lpszName <> nil then
  begin
    if Is_IntResource(lpszName) then TStrings(lParam).Add( '#' + IntToStr(NativeUInt(lpszName)))
    else  TStrings(lParam).Add(lpszName);
    result:= True;
  end;
end;

procedure TFProgram.EnumerateResourceNames(Instance: THandle; var list: TStringList);
begin
  try
    EnumResourceNames(Instance, RT_GROUP_ICON, @EnumProc, PtrInt(list));
  except
  end;
end;

procedure TFProgram.GetIconRes(filename: string; index:integer; var ico: TIcon);
const
  LOAD_LIBRARY_AS_IMAGE_RESOURCE = $00000020;
var
  HInst: THandle;
  IconList: Tstringlist;
  s:String;
begin
  IconList:= TstringList.Create;
  HInst := LoadLibraryEx(PChar(filename), 0, LOAD_LIBRARY_AS_DATAFILE or LOAD_LIBRARY_AS_IMAGE_RESOURCE);
  EnumerateResourceNames(HInst, IconList) ;
  s:= Iconlist[index];
   if  s[1]='#' then
   begin
   s:= Copy (s, 2, length(s)-1);
   ico.LoadFromResourceId(hinst, StrToInt(s));
   end else ico.LoadFromResourceName(hinst,s);
  FreeAndNil(IconList);
end;

end.

