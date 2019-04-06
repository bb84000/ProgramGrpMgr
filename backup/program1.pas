//******************************************************************************
// Main unit for ProgramGrpManager (Lazarus)
// bb - sdtp - march 2019
//******************************************************************************
unit program1;

{$mode objfpc}{$H+}

interface

uses
  Windows, Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  Buttons, StdCtrls,  CommCtrl, WinDirs, bbutils, shlobj, laz2_DOM , laz2_XMLRead, laz2_XMLWrite, files1,
  Registry,  LCLIntf, Menus, ShellAPI, About, SaveCfg1, WinVer, prefs1, property1, inifiles,
  chknewver, alert, LoadGroup1, LoadConf1;

type

  { TFProgram }

  SaveType = (None, State, All);

  AttributeType = (atString, atInteger, atDatetime, atBoolean);

  TFProgram = class(TForm)
    CBDisplay: TComboBox;
    CBSort: TComboBox;
    ImageList: TImageList;
    ImgPrgSel: TImage;
    LPrgSel: TLabel;
    ListView1: TListView;
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
    N3: TMenuItem;
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
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
    procedure FormResize(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure ListView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ListView1Resize(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure LVPMnuPopup(Sender: TObject);
    procedure PMnuDeleteClick(Sender: TObject);
    procedure PMnuHideBarsClick(Sender: TObject);
    procedure PMnuPropsClick(Sender: TObject);
    procedure PMnuRunAsClick(Sender: TObject);
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
    procedure TrayProgmanDblClick(Sender: TObject);
  private
    First: Boolean;
    OSTarget: String;
    AppDataPath: String;
    DesktopPath : String;
    StartMenuPath: String;
    PrgMgrAppsData: string;
    ProgName: String;
    oldw: array [0..50] of Integer;
    //ImageList: TImageList;
    ListeFichiers: TFichierList;
    // Config file and values
    ConfigFile: String;
    GroupName: String;
    SavSizePos, PrevSavSizePos: Boolean;
    ListeChange: Bool;
    WState, PrevWState: String;
    GrpIconFile, PrevGrpIconFile: String;
    GrpIconIndex, PrevGrpIconIndex: Integer;
    IconDisplay, PrevIconDisplay: Integer;
    IconSort, PrevIconSort: Integer;
    AppState : Integer;
    LastUpdChk, PrevLastUpdChk: TDateTime;
    NoChkNewVer, PrevNoChkNewVer: Boolean;
    StartWin, PrevStartWin: Boolean;
    MiniInTray, PrevMiniInTray: Boolean;
    HideInTaskBar, PrevHideInTaskBar: Boolean;
    HideBars, PrevHideBars: Boolean;
    SMnuMaskBars, SMnuShowBars: String;
    langue: Integer;
    LangFile: TiniFile;
    LangStr, PrevLangStr: String;
    LangNums: TStringList;
    CurLang: Integer;
    CompileDateTime: TDateTime;
    IconDefFile: String;
    SystemRoot: String;
    ShortCutName: String;
    WinVersion: TWinVersion;
    YesBtn, NoBtn, CancelBtn: String;
    ExecName, ExecPath: String;
    FPropertyCaption: string;
    DeleteOKMsg: String;
    PtArray : array of Tpoint;
    IcoSize: Integer;
    FMinWidth, FminHeight : Integer;
    BarsHeight: Integer;
    HideBarsHeight, ShowBarsheight: Integer;
    UpdateAvailable, NoLongerChkUpdates: String;
    LUpdateCaption, UpdateURL, ChkVerURL: String;
    LastUpdateSearch, LastChkCaption, NextChkCaption: String;
    NoDeleteGroup, DeleteGrpMsg: String;
    Version: String;
    function GetGrpParam: String;
    procedure LoadCfgFile(FileName: String);
    procedure LoadConfig(GrpName: String);
    function SaveConfig(GrpName: String; Typ: SaveType): Bool;
    procedure LVDisplayFiles;
    function GetFile(FileName: string):TFichier;
    procedure CropBitmap(InBitmap, OutBitMap : TBitmap; Enable: Boolean);//X, Y, W, H :Integer);
    function PMnuSaveEnable (Enable: Boolean):Boolean;
    function StateChanged: SaveType;
    procedure ListeFichiersOnChange(sender: TObject);
    procedure ModLangue;
    function ClosestItem(pt: Tpoint; ptArr:array of Tpoint): TlistItem;
    function HidinTaskBar (enable: Boolean): boolean;
    procedure ChkVersion;
    function ShowAlert(Title, AlertStr, StReplace, NoShow: String; var Alert: Boolean):Boolean;
    function ReadFolder(strPath: string; Directory: Bool): Integer;
    function xmlReadValue(xmlDoc: TXMLDocument; Attribute: String; typ: AttributeType): variant;
    function nodeReadValue(inode:  TDOMNode; Attribute: String; typ: AttributeType): variant;
  public

  end;

 const

   WM_INFO_UPDATE = WM_USER + 101;
   WP_NewVersion = 15;

var
  FProgram: TFProgram;
  PrevWndProc: WNDPROC;
  PrivateExtractIcons: function(lpszFile: PChar; nIconIndex, cxIcon, cyIcon: integer;
                                  phicon: PHANDLE; piconid: PDWORD; nicon, flags: DWORD):
                                  DWORD stdcall;


implementation

{$R *.lfm}

{ TFProgram }

//
// Windows Callback function to intercept windows messages
// WM_QUERYENDSESSION
//
function WndCallback(Ahwnd: HWND; uMsg: UINT; wParam: WParam; lParam: LParam):LRESULT; stdcall;
var
  reg: TRegistry;
  s: string;
  CurVer, NewVer: Int64;

begin
  if uMsg=WM_QUERYENDSESSION then
  begin
    if not FProgram.StartWin then
    begin
      reg := TRegistry.Create;
      reg.RootKey := HKEY_CURRENT_USER;
      reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\RunOnce', True) ;
      reg.WriteString(FProgram.ProgName+'_'+FProgram.GroupName, '"'+Application.ExeName+'" Grp='+FProgram.GroupName) ;
      reg.CloseKey;
      reg.free;
      FProgram.SaveConfig(FProgram.GroupName, FProgram.StateChanged);
      Application.ProcessMessages;
    end;
  end;
    // la forme de recherche de mise à jour a envoyé un message
  if uMsg = WM_INFO_UPDATE then
  case wParam of
      WP_NewVersion:
        begin
          s:= string(lParam);
          if length(s) > 0 then
          begin
            CurVer:= VersionToInt(Fprogram.version);
            NewVer:= VersionToInt(s);
            if NewVer > CurVer then
            begin
              AboutBox.LUpdate.Caption:= StringReplace(FProgram.UpdateAvailable, '%s', s, [rfIgnoreCase]);
              if FProgram.ShowAlert(FProgram.Caption, FProgram.UpdateAvailable, s, FProgram.NoLongerChkUpdates, FProgram.NoChkNewVer) then
              FProgram.SBAboutClick(FChkNewVer);
            end;
          end;
        end;
    end;

  result:=CallWindowProc(PrevWndProc,Ahwnd, uMsg, WParam, LParam);
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
    if (s1[1]= #34) or (s1[1]= #39) then
    s1:= Copy(s1, 3, length(s1)) else
    s1:= Copy(s1, 2, length(s1));
    if length(s1) > 0 then
    begin
      s1:= StringReplace(s1, #34, '', [rfReplaceAll]);
      param:= StringReplace(s1, #39, '', [rfReplaceAll]);
      p:= Pos('Grp=', param);
      if p > 0 then GroupName:= AnsiToUTF8(Copy(param, p+4, length(param)));
     Result := GroupName;
    end;
  end;
end;


function TFProgram.ShowAlert(Title, AlertStr, StReplace, NoShow: String; var Alert: Boolean):Boolean;
begin
  Result:= False;
  With AlertBox do
  begin
    Caption:= Title;
    Image1.Picture.Icon:= Application.Icon;
    MAlert.Text:= StringReplace(AlertStr, '%s', stReplace, [rfIgnoreCase, rfReplaceAll]);
    CBNoShowAlert.Caption:= NoShow;
    CBNoShowAlert.Checked:= Alert;
    if not Alert then
   if  ShowModal = mrOK then result:= True;
    Alert:= CBNoShowAlert.Checked;
  end;
end;


// Form creation



procedure TFProgram.FormCreate(Sender: TObject);
var
  aPath : Array[0..MaxPathLen] of Char; //Allocate memory
begin
  inherited;
  // Instanciate windows callback
  PrevWndProc:={%H-}Windows.WNDPROC(SetWindowLongPtr(Self.Handle,GWL_WNDPROC,{%H-}PtrInt(@WndCallback)));
  // Some things have to be run only on the first form activation
  // so, we set first at true
  Pointer(PrivateExtractIcons) := GetProcAddress(GetModuleHandle('user32.dll'),'PrivateExtractIconsA');
  First:= True;
  // Compilation date/time
  try
    CompileDateTime:= Str2Date({$I %DATE%}, 'YYYY/MM/DD')+StrToTime({$I %TIME%});
  except
  end;
  ListeFichiers:= TFichierList.Create;
 // ImageList:= TImageList.Create(self);
  langue:= Lo(GetUserDefaultLangID);
  //langue:=  LANG_ITALIAN;
  If length(LangStr)= 0 then LangStr:= IntToStr(langue);
  // Fix official program name to avoid trouble if exe name is changed
  ExecName:= ExtractFileName(Application.ExeName);
  ExecPath:= ExtractFilePath(Application.ExeName);
  ProgName:= 'ProgramGrpMgr';
   // Chargement des chaînes de langue...
  LangFile:= TIniFile.create(ExecPath+ProgName+'.lng');
  LangNums:= TStringList.Create;
  GroupName:= GetGrpParam;
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
end;

procedure TFProgram.FormDestroy(Sender: TObject);
begin
  FreeAndNil(WinVersion);
  FreeAndNil(ListeFichiers);
  FreeAndNil(langnums);
  FreeAndNil(langfile);

end;




procedure TFProgram.PMnuHideBarsClick(Sender: TObject);
begin
  If HideBars then
  begin
    FMinHeight:= BarsHeight+GetSystemMetrics(SM_CYCAPTION)+142;
    HideBars:= False;
    PnlTop.Visible:= True;
    PnlStatus.Visible:= True;
    PMnuHideBars.Caption:= SMnuMaskBars;
    Height:= HideBarsheight+BarsHeight;
  end else
  begin
    FMinHeight:= GetSystemMetrics(SM_CYCAPTION)+142;
    HideBars:= True;
    PnlTop.Visible:= False;
    PnlStatus.Visible:= False;
    PMnuHideBars.Caption:= SMnuShowBars;
    Height:= ShowBarsHeight-BarsHeight;
  end;

end;



// Form activation

procedure TFProgram.FormActivate(Sender: TObject);
begin
  inherited;
  if not first then exit;
  // We get Windows Version
  WinVersion:= TWinVersion.Create;

  // For popup menu, retrieve bitmap from buttons
  CropBitmap(SBGroup.Glyph, PmnuGroup.Bitmap, SBGroup.Enabled);
  CropBitmap(SBFolder.Glyph, PMnuFolder.Bitmap, SBFolder.Enabled);
  CropBitmap(SBAddFile.Glyph, PMnuAddFile.Bitmap, SBAddFile.Enabled);
  PmnuSaveEnable (False);
  CropBitmap(SBPrefs.Glyph, PMnuPrefs.Bitmap, SBPrefs.Enabled);
  CropBitmap(SBLoadConf.Glyph, PMnuLoadConf.Bitmap, SBLoadConf.Enabled);
  CropBitmap(SBAbout.Glyph, PMnuAbout.Bitmap, SBAbout.Enabled);
  CropBitmap(SBQuit.Glyph, PMnuQuit.Bitmap, SBQuit.Enabled);
  CropBitmap(SBAbout.Glyph, PTrayMnuAbout.Bitmap, SBAbout.Enabled);
  CropBitmap(SBQuit.Glyph, PTrayMnuQuit.Bitmap, SBQuit.Enabled);
  BarsHeight:= ClientHeight-ListView1.Height;
  GroupName:= GetGrpParam;
  {$IFDEF WIN32}
      OSTarget:= '32 bits';
  {$ENDIF}
  {$IFDEF WIN64}
      OSTarget:= '64 bits';
  {$ENDIF}
  LoadConfig(GroupName);
  If (WinVersion.IsWow64) and (OsTarget='32 bits') then
  begin
    ShowMessage('Utilisez la version 64 bits de ce programme');
  end;

end;

// Form drop files

procedure TFProgram.FormDropFiles(Sender: TObject;
  const FileNames: array of String);
var
 i: integer;
begin
  if length(FileNames) > 0 then
  begin
    For i:= 0 to High(Filenames) do
      ListeFichiers.AddFile(GetFile(FileNames[i]));
    ListeChange:= True;
    LVDisplayFiles;
  end;
end;

procedure TFProgram.FormResize(Sender: TObject);
var
  BorderWidths: Integer;
begin
  BorderWidths:= Width-ClientWidth;
  if HideBars then begin
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

function TFProgram.PMnuSaveEnable (Enable: Boolean):Boolean;
begin
  PMnuSave.Enabled:= Enable;
  If Enabled then CropBitmap(SBSave.Glyph, PMnuSave.Bitmap, Enable)
  else CropBitmap(SBSave.Glyph, PMnuSave.Bitmap, Enable);
  result:= Enabled;
end;


procedure TFProgram.LoadConfig(GrpName: String);
var
  i: Integer;
  hWind: HWND;
  LangFound: Boolean;
begin
  GrpIconFile:= '';
  GrpIconIndex:= 0;
  GroupName:= GrpName;
  ConfigFile:= PrgMgrAppsData+GrpName+'.xml';
  If not FileExists(ConfigFile) then
  begin
    If FileExists (PrgMgrAppsData+GroupName+'.bk0') then
    begin
      RenameFile(PrgMgrAppsData+GroupName+'.bk0', ConfigFile);
      For i:= 1 to 5
      do if FileExists (PrgMgrAppsData+GroupName+'.bk'+IntToStr(i))     // Renomme les précédentes si elles existent
       then  RenameFile(PrgMgrAppsData+GroupName+'.bk'+IntToStr(i), PrgMgrAppsData+GroupName+'.bk'+IntToStr(i-1));
    end else
    begin
      SaveConfig(GroupName, all)
    end;
  end;
  LoadCfgFile(ConfigFile);
  // Si le même groupe est déjà actif, on récupère le handle de l'application qui est propriétaire de la fiche
  // In Lazarus, forms have 'Window'Class
  hWind:= GetWindow(FindWindow (Pchar('Window'), Pchar(GroupName)), GW_OWNER) ;
  If hWind > 0 then
  begin
     ShowWindow(hWind, SW_SHOWNORMAL);
     SetForeGroundWindow(hWind);
     Close;
  end;
  // Détermination de la langue
  LangFile.ReadSections(LangNums);
  if LangNums.Count > 1 then
    For i:= 0 to LangNums.Count-1 do
    begin
      Prefs.CBLangue.Items.Add (LangFile.ReadString(LangNums.Strings[i],'Language', 'Aucune'));
      If LangNums.Strings[i] = LangStr then LangFound:= True;
    end;
  // Si la langue n'est pas traduite, alors on passe en Anglais
  If not LangFound then
  //If LangFound then
  begin
    langue:= LANG_ENGLISH;
    LangStr:= IntToStr(langue);
  end;
  CurLang:= LangNums.IndexOf(LangStr);
  PrevLangStr:= LangStr;
  Modlangue;
  // Taille et position précédentes
  if SavSizePos then
  begin
    Try
      AppState:= StrToInt('$'+Copy(WState,1,4));
      Top:= StrToInt('$'+Copy(WState,5,4));
      Left:= StrToInt('$'+Copy(WState,9,4));
      Height:= StrToInt('$'+Copy(WState,13,4));
      Width:= StrToInt('$'+Copy(WState,17,4)) ;
    except
    end;
    TrayProgman.Visible:= MiniInTray;

    if Appstate = SW_SHOWMINIMIZED then
    begin

      ShowWindow(Application.Handle, AppState) ; //  Minimize in task bar is done on application, not on main form
    end else
    begin
      ShowWindow(Handle, AppState);  // Maximize is done on main form, not on application
      //1: normal
      // 2 : Iconized
      //3: Maximized

    end;
    Case AppState of
      1: begin    // Normal
           PTrayMnuRestore.Enabled:= False;
           PTrayMnuMinimize.Enabled:= True;
           PTrayMnuMaximize.Enabled:= True;
         end;
      2: begin   // Minimized
           PTrayMnuRestore.Enabled:= True;
           PTrayMnuMinimize.Enabled:= False;
           PTrayMnuMaximize.Enabled:= True;
         end;
      3: begin   // Maximized
           PTrayMnuRestore.Enabled:= True;
           PTrayMnuMinimize.Enabled:= True;
           PTrayMnuMaximize.Enabled:= False;
         end;
    end;
    HidInTaskBar(HideInTaskBar and MiniInTray);     // ON ne cache que si l'icone est dans la zone de notification !!!
    PnlTop.Visible:= not HideBars;
    PnlStatus.Visible:= not HideBars;
    if HideBars then begin
      PMnuHideBars.Caption:= SMnuShowBars;
    end else
    begin
      PMnuHideBars.Caption:= SMnuMaskBars;
    end;
  end;
  ListeFichiers.OnChange:=  @ListeFichiersOnChange;
  CBDisplay.ItemIndex:= IconDisplay;
  PrevIconDisplay:= IconDisplay;
  CBSort.ItemIndex:= IconSort;
  PrevIconSort:= IconSort;
  Application.Title:= GroupName;
  Caption:= GroupName;
  If not FileExists(GrpIconFile) then GrpIconFile:= Application.ExeName;
  Application.Icon.Handle:= ExtractIconU(handle, GrpIconFile, GrpIconIndex);
  version:= GetVersionInfo.ProductVersion;
  //Version:= '0.5.0.0';
  UpdateUrl:= 'http://www.sdtp.com/versions/version.php?program=programgrpmgr&version=';
  ChkVerURL:= 'http://www.sdtp.com/versions/versions.csv';

  // Aboutbox
  AboutBox.Caption:= 'A propos du Gestionnaire de Groupe de Programmes';
  AboutBox.Image1.Picture.Icon.Handle:= Application.Icon.Handle;
  AboutBox.LProductName.Caption:= GetVersionInfo.ProductName+' ('+OsTarget+')';
  AboutBox.LCopyright.Caption:= GetVersionInfo.CompanyName+' - '+DateTimeToStr(CompileDateTime);
  AboutBox.LVersion.Caption:= 'Version: '+Version;
  AboutBox.UrlUpdate:= UpdateURl+Version;
  AboutBox.LUpdate.Caption:= LUpdateCaption;
  AboutBox.UrlWebsite:=GetVersionInfo.Comments;
  ChkVersion;
  // Dont want to have the same icon handle
  ImgPrgSel.Picture.Icon.Handle:=  ExtractIconU(handle, GrpIconFile, GrpIconIndex);
  LVDisplayFiles;
end;

procedure TFProgram.ChkVersion;
begin
  //Dernière recherche il y a plus de 7 jours ?
  if (Trunc(Now) > LastUpdChk+7) and (not NoChkNewVer) then
  begin
    LastUpdChk:= Trunc(Now);
    FChkNewVer.GetLastVersion (ChkVerURL, 'programgrpmgr', Handle);
  end;
end;

function TFProgram.HidinTaskBar (enable: Boolean): boolean;
begin
  ShowWindow(Application.Handle, SW_HIDE) ;
  if enable then
  begin
    SetWindowLong(Application.Handle, GWL_EXSTYLE, getWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW) ;
  end else
  begin
    SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) and (not WS_EX_TOOLWINDOW));
  end;
  ShowWindow(Application.Handle, SW_SHOW) ;
  Result:= enable;
end;

function TFProgram.xmlReadValue(xmlDoc: TXMLDocument; Attribute: String; typ: AttributeType): variant;
begin
  Case typ of
    atString:
      try
        result:= xmlDoc.DocumentElement{%H-}.AttribStrings[Attribute];
      except
        result:= '';
      end;
    atInteger:
      try
        result:= StrToInt(xmlDoc.DocumentElement.AttribStrings[Attribute]{%H-})
      except
        result:= 0;
      end;
    atDatetime:
      try
        result:= StrToDate(xmlDoc.DocumentElement.AttribStrings[Attribute]{%H-});
      except
        result:= now();
      end;
    atBoolean:
      try
        result:= Bool(StrToInt(xmlDoc.DocumentElement.AttribStrings[Attribute]{%H-}));
      except
        result:= False;
      end;
  end;
end;

function TFProgram.nodeReadValue(inode:  TDOMNode; Attribute: String; typ: AttributeType): variant;
begin
  Case typ of
    atString:
      try
        result:= TDOMElement(iNode){%H-}.GetAttribute(Attribute);
      except
        result:= '';
      end;
    atInteger:
      try
        result:= StrToInt(TDOMElement(iNode).GetAttribute(Attribute){%H-});
      except
        result:= 0;
      end;
   atDatetime:
      try
        result:= StrToDateTime(TDOMElement(iNode).GetAttribute(Attribute){%H-});
      except
        result:= now();
      end;
   atBoolean:
     try
       result:= Bool(StrToInt(TDOMElement(iNode).GetAttribute(Attribute){%H-}));
     except
       result:= False;
     end;
  end;
end;

procedure TFProgram.LoadCfgFile(FileName: String);
var
  CfgXML: TXMLDocument;
  inode : TDOMNode;
  NewFile: TFichier;
begin
  Try
    ReadXMLFile(CfgXML, FileName);
    With CfgXML do
    begin
      // Main settings
      GroupName:= xmlReadValue(CfgXML, 'groupname', atString);
      SavSizePos:= xmlReadValue(CfgXML, 'savsizepos', atBoolean);
      PrevSavSizePos:= SavSizePos;
      WState:=  xmlReadValue(CfgXML, 'wstate', atString);
      PrevWState:= WState;
      GrpIconFile:= xmlReadValue(CfgXML, 'grpiconfile', atString);
      PrevGrpIconFile:= GrpIconFile;
      GrpIconIndex:= xmlReadValue(CfgXML, 'grpiconindex', atInteger);
      PrevGrpIconIndex:= GrpIconIndex;
      IconDisplay:= xmlReadValue(CfgXML, 'icondisplay', atInteger);
      IconSort:= xmlReadValue(CfgXML, 'iconsort', atInteger);
      LastUpdChk:= xmlReadValue(CfgXML, 'lastupdchk', atDatetime);
      PrevLastUpdChk:= LastUpdChk;
      NoChkNewVer:= xmlReadValue(CfgXML, 'nochknewver', atBoolean);
      PrevNoChkNewVer:= NoChkNewVer;
      StartWin:= xmlReadValue(CfgXML, 'startwin', atBoolean);
      PrevStartWin:= StartWin;
      MiniInTray:= xmlReadValue(CfgXML, 'miniintray', atBoolean);
      PrevMiniInTray:= MiniInTray;
      HideInTaskBar:= xmlReadValue(CfgXML, 'hideintaskbar', atBoolean);
      PrevHideInTaskBar:= HideInTaskBar;
      HideBars:= xmlReadValue(CfgXML, 'hidebars', atBoolean);
      PrevHideBars:= HideBars;
      LangStr:= xmlReadValue(CfgXML, 'langstr', atString);

      // files settings
      iNode := DocumentElement.FirstChild;
      while iNode <> nil do
      begin
        NewFile.Name:=  nodeReadValue(inode, 'name', atString);
        NewFile.Path:=  nodeReadValue(inode, 'path', atString);
        NewFile.DisplayName:= nodeReadValue(inode, 'displayname', atString);
        NewFile.Size:= nodeReadValue(inode, 'size', atInteger);
        NewFile.TypeName:= nodeReadValue(inode, 'typename', atString);
        NewFile.Description:= nodeReadValue(inode, 'description', atString);
        NewFile.Params:= nodeReadValue(inode, 'params', atString);
        NewFile.StartPath:= nodeReadValue(inode, 'startpath', atString);
        NewFile.Date:= nodeReadValue(inode, 'date', atDatetime);
        NewFile.IconFile:= nodeReadValue(inode, 'iconfile', atString);
        NewFile.IconIndex:= nodeReadValue(inode, 'iconindex', atInteger);
        ListeFichiers.AddFile(NewFile);
        iNode := iNode.NextSibling;
      end;
    end;
  finally
    FreeAndNil(CfgXML);
  end;
end;

function TFProgram.SaveConfig(GrpName: String; Typ: SaveType): Bool;
var
  CfgXML: TXMLDocument;
  RootNode : TDOMNode;
  FileNode : TDOMNode;
  WindowPlacement: TWindowPlacement;
  WinPos : array [0..10] of Integer;
  i: Integer;
  Reg: TRegistry;
  FilNamWoExt: String;
begin
  if Typ= none then  exit;
  ConfigFile:= PrgMgrAppsData+GrpName+'.xml';
  try
    CfgXML := TXMLDocument.Create;
    With CfgXML do
    begin
      // Main config is in root node
      RootNode := CreateElement('config');
      TDOMElement(RootNode).SetAttribute('groupname', GroupName {%H-});
      TDOMElement(RootNode).SetAttribute ('savsizepos', IntToStr(Integer(SavSizePos)){%H-});
      If IconDisplay < 0 then IconDisplay:= 3;
      TDOMElement(RootNode).SetAttribute ('icondisplay', IntToStr(IconDisplay){%H-});
      If IconSort < 0 then IconSort:= 0;
      TDOMElement(RootNode).SetAttribute ('iconsort' , IntToStr(IconSort){%H-});
      TDOMElement(RootNode).SetAttribute ('miniintray',IntToStr(Integer(MiniInTray)){%H-});
      TDOMElement(RootNode).SetAttribute ('hideintaskbar', IntToStr(Integer(HideInTaskBar)){%H-});
      TDOMElement(RootNode).SetAttribute ('hidebars', IntToStr(Integer(HideBars)){%H-});
      // Window position
      WState:= '';
      If WindowState = wsMaximized then
      begin
        AppState :=  SW_SHOWMAXIMIZED;                   // Application is never maximized, only the main form
      end else
      begin
        GetWindowPlacement(Application.Handle, @WindowPlacement);
        AppState := WindowPlacement.showCmd;             // Elsewhere, we use the app placement
      end;
      WinPos[0]:= AppState;
      if Top < 0 then WinPos[1]:= 0 else WinPos[1]:= Top;
      if Left < 0 then WinPos[2]:= 0 else WinPos[2]:= Left;
      WinPos[3]:= Height;
      WinPos[4]:= Width;
      For i:= 0 to 4 do WState:=WState+IntToHex(WinPos[i], 4);
      TDOMElement(RootNode).SetAttribute ('wstate', WState {%H-});
      TDOMElement(RootNode).SetAttribute ('grpiconfile', GrpIconFile {%H-});
      TDOMElement(RootNode).SetAttribute ('grpiconindex', IntToStr(GrpIconIndex){%H-});
      TDOMElement(RootNode).SetAttribute ('nochknewver', IntToStr(Integer(NoChkNewVer)){%H-});
      TDOMElement(RootNode).SetAttribute ('lastupdchk', DateToStr(LastUpdChk){%H-});
      TDOMElement(RootNode).SetAttribute ('startwin', IntToStr(Integer(StartWin)){%H-});
      TDOMElement(RootNode).SetAttribute ('langstr', LangStr {%H-});
      Appendchild(RootNode);
      If ListeFichiers.Count > 0 Then
      begin
        For i:= 0 to ListeFichiers.Count-1 do
        begin
          FileNode := CreateElement('file');
          TDOMElement(FileNode).SetAttribute('name',  ListeFichiers.GetItem(i).Name {%H-});
          TDOMElement(FileNode).SetAttribute('path', ListeFichiers.GetItem(i).Path {%H-});
          TDOMElement(FileNode).SetAttribute('displayname', ListeFichiers.GetItem(i).DisplayName {%H-});
          TDOMElement(FileNode).SetAttribute('params', ListeFichiers.GetItem(i).Params {%H-});
          TDOMElement(FileNode).SetAttribute('startpath', ListeFichiers.GetItem(i).StartPath {%H-});
          TDOMElement(FileNode).SetAttribute('size', IntToStr(ListeFichiers.GetItem(i).Size){%H-});
          TDOMElement(FileNode).SetAttribute('typename', ListeFichiers.GetItem(i).TypeName {%H-});
          TDOMElement(FileNode).SetAttribute('description', ListeFichiers.GetItem(i).Description {%H-});
          TDOMElement(FileNode).SetAttribute('date', DateTimeToStr(ListeFichiers.GetItem(i).Date){%H-});
          TDOMElement(FileNode).SetAttribute('iconfile', ListeFichiers.GetItem(i).IconFile {%H-});
          TDOMElement(FileNode).SetAttribute('iconindex', IntToStr(ListeFichiers.GetItem(i).IconIndex){%H-});
          RootNode.Appendchild(FileNode);
        end;
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
    if StartWin  then  // Démarrage avec Windows coché
    begin
      if not Reg.ValueExists(ProgName+'_'+GroupName) then
      reg.WriteString(ProgName+'_'+GroupName, '"'+Application.ExeName+'" Grp='+GroupName) ;
      Reg.CloseKey;
    end else if Reg.ValueExists(ProgName+'_'+GroupName) then
    begin
      Reg.DeleteValue(ProgName+'_'+GroupName);
      Reg.CloseKey;
    end;
    Reg.Free;
    FreeAndNil(CfgXML);
  end;
end;

function TFProgram.StateChanged : SaveType;
var
  WinPos : array [0..10] of Integer;
  i: Integer;
  WindowPlacement: TWindowPlacement;
begin
 If (WindowState = wsMinimized) then
  begin
    AppState := SW_SHOWMINIMIZED
  end else
  begin
    GetWindowPlacement(Handle, @WindowPlacement);
    AppState := WindowPlacement.showCmd;
  end;
 WState:= '';
  WinPos[0]:= AppState;
  if Top < 0 then WinPos[1]:= 0 else WinPos[1]:= Top;
  if Left < 0 then WinPos[2]:= 0 else WinPos[2]:= Left;
  WinPos[3]:= Height;
  WinPos[4]:= Width;
  For i:= 0 to 4 do WState:=WState+IntToHex(WinPos[i], 4);
  If ((WState<>PrevWState) or
           (GrpIconFile<>PrevGrpIconFile) or
           (GrpIconIndex <> PrevGrpIconIndex) or
           (LastUpdChk<>PrevLastUpdChk) or
           (NoChkNewVer<>PrevNoChkNewVer) or
           (StartWin<>PrevStartWin) or
           (LangStr<>PrevLangStr) or
           (Prefs.ImgChanged) or
           (MiniInTray <> PrevMiniInTray) or
           (HideInTaskBar <> PrevHideInTaskBar) or
           (HideBars <> PrevHideBars)) or
           (SavSizePos <> PrevSavSizePos) then
   begin
    result:= State ;
  end else
  If ListeChange then begin
    result:= all;
  end else
  begin
    result:= none;
  end;
end;

procedure TFProgram.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
    If ListeChange then
  begin
    if WinVersion.VerMaj > 5 then   // Vista et après
    FSaveCfg.IconDefFile:= SystemRoot+'\system32\imageres.dll' else
    FSaveCfg.IconDefFile:= SystemRoot+'\system32\shell32.dll';
    FSaveCfg.EGrpName.Text:= GroupName;
    FSaveCfg.ImgGrpIcon.Picture.Icon:= Application.Icon;
    If FSaveCfg.Showmodal = mrOK then
    begin
      if FSaveCfg.RBtnSaveAs.Checked then
      begin
        if length(FSaveCfg.EGrpName.Text) > 0 then GroupName:= FSaveCfg.EGrpName.Text;
      end;

      if FSaveCfg.CBXShortCut.Checked then
      begin
        if length(FSaveCfg.IconFile) > 0 then GrpIconFile:= FSaveCfg.IconFile;
        if FSaveCfg.IconIndex >=0 then GrpIconIndex:= FSaveCfg.IconIndex;
        CreateShortcut(Application.ExeName, DesktopPath, GroupName, '','', 'Grp='+GroupName,
                       ShortCutName, GrpIconFile, GrpIconIndex);

      end;
      SaveConfig(GroupName, StateChanged);
    end;
  end else
  begin
    SaveConfig(GroupName, StateChanged);
    ListeChange:= False;
  end;
end;


procedure TFProgram.ListeFichiersOnChange(sender: TObject);
begin
  ListeChange:= True;
  SBSave.Enabled:= True;
  PMnuSave.Enabled:= True;
  PMnuSaveEnable(True);
end;

function TFProgram.GetFile(FileName: string):TFichier;
var
  SearchRec: TSearchRec;
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
   // Initialize file info structure
   ZeroMemory(@SearchRec, SizeOf(TSearchRec));
   FindFirst(FileName, faAnyFile, SearchRec);
   Result.Size:= SearchRec.size;
   Result.TypeName:= 'Application' ;
   try
     Result.Date:= FileDateToDateTime(FileAge(ExeName));
   except
   end;
end;

// Procedure to display icons and other in the listview

procedure TFProgram.LVDisplayFiles;
var
  ListItem: TListItem;
  Flag: Integer;
  //IcoSize: Integer;
  CurIcon: TIcon;
  hnd: Thandle;
  i: Integer;
  w: Integer;
  hIcon: Thandle;
  nIconId : DWORD;
  ItemPos: Tpoint;
  IcoInfo: TICONINFO;
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

    ListeFichiers.DoSort;
    ListView1.Clear;
    ImageList.Clear;

    ImageList.Height:= IcoSize;
    ImageList.Width:= IcoSize;

    Application.ProcessMessages; // Application.ProcessM

    // Create a temporary TIcon
    CurIcon := TIcon.Create;
    CurIcon.Height:= IcoSize;
    CurIcon.Width:= IcoSize;
    ListView1.LargeImages:= ImageList;
    // retrieve handle of ImageList
    hnd:= ImageList.ResolutionByIndex[0].Reference.Handle;
    setLength(PtArray, ListeFichiers.Count);
    bmp:= TBitmap.Create;
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
      If Assigned(PrivateExtractIcons) then
      begin
        //Function only from W2000, and can be discontinued ?
        // Do not display properly low color depth icons
        // The function doesnt extract properly dll icons
        If (PrivateExtractIcons ( PChar(ListeFichiers.GetItem(i).IconFile), ListeFichiers.GetItem(i).IconIndex,
                     IcoSize, Icosize, @hIcon, @nIconId, 1, LR_LOADFROMFILE) <>0) and (hIcon <> 0) and
                     (UpperCase(ExtractFileExt(ListeFichiers.GetItem(i).IconFile)) <> 'DLL') then
        begin
          GetIconInfo(hicon, @IcoInfo);
          ListItem.ImageIndex := ImageList_Add(hnd, IcoInfo.hbmColor, IcoInfo.hbmMask);
          //ListItem.ImageIndex := ImageList_Add(hnd, IcoInfo.hbmmask, 0);
          // CurIcon.Handle:= hIcon;
          // ListItem.ImageIndex := ImageList_AddIcon(hnd, CurIcon.Handle);
          end else
        begin
          GetIconFromFile(ListeFichiers.GetItem(i).IconFile ,CurIcon, Flag,0) ;
          ListItem.ImageIndex := ImageList_AddIcon(hnd, CurIcon.Handle);
        end;
      end;
       // Create an array of items coordinates
      ItemPos.x:= (Listview1.Items.Item[i].Position.x) +(IcoSize div 2);    // center coordinate
      ItemPos.y:= (Listview1.Items.Item[i].Position.y) +(IcoSize div 2);
      PtArray[i]:= ItemPos;
    end;
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
      // Replaced with own routineDon't work
      If DropItem = nil then   DropItem:= ClosestItem(Pt, PtArray);
      currentItem := Selected;
      while currentItem <> nil do
      begin
        NextItem := GetNextItem(currentItem, sdAll, [lIsSelected]) ;
        ListeFichiers.SortType:= cdcNone;
        if Assigned(dropItem) then  ListeFichiers.DoMove(currentItem.Index, DropItem.Index);
        //else ListeFichiers.DoMove(currentItem.Index, ListeFichiers.Count-1);
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
  //LVDisplayFiles;
end;




procedure TFProgram.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
    ListView1.Hint:= ListeFichiers.GetItem(Item.Index).Description ;
    LPrgSel.Caption:= ListView1.Hint;
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
  ShowWindow(handle, SW_SHOWMAXIMIZED);
end;

procedure TFProgram.PTrayMnuMinimizeClick(Sender: TObject);
begin
  PTrayMnuRestore.Enabled:= True;
  PTrayMnuMinimize.Enabled:= False;
  PTrayMnuMaximize.Enabled:= True;
  ShowWindow(Application.Handle, SW_SHOWMINIMIZED);
end;

procedure TFProgram.PTrayMnuRestoreClick(Sender: TObject);
begin
  PTrayMnuRestore.Enabled:= False;
  PTrayMnuMinimize.Enabled:= True;
  PTrayMnuMaximize.Enabled:= True;
  ShowWindow(handle, SW_SHOWNORMAL);
end;

function TFProgram.ReadFolder(strPath: string; Directory: Bool): Integer;
var
  i: Integer;
  SearchRec: TSearchRec;
  FileAttr: Bool;
begin
  //ListeFichiers.Reset;
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
          IconFile:= GroupXML{%H-}.DocumentElement{%H-}.AttribStrings['grpiconfile'];
          try
            IconIndex:= StrToInt(GroupXML.DocumentElement.AttribStrings['grpiconindex']{%H-});
          except
            IconIndex:= 0;
          end;
          LI := LV1.Items.Add;
          s:= GroupXML{%H-}.DocumentElement{%H-}.AttribStrings['groupname'];
          if length(s) > 0 then LI.Caption := s
          else LI.Caption:= PrgMgrAppsData+SearchRec.Name;
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
    mrRetry: if LV1.Selected.Caption = GroupName
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
  if WinVersion.VerMaj > 5 then   // Vista et après
  FSaveCfg.IconDefFile:= SystemRoot+'\system32\imageres.dll' else
  FSaveCfg.IconDefFile:= SystemRoot+'\system32\shell32.dll';
  FSaveCfg.EGrpName.Text:= GroupName;
  FSaveCfg.ImgGrpIcon.Picture.Icon.Handle:= ExtractIconU(handle, GrpIconFile, GrpIconIndex);
  If FSaveCfg.Showmodal = mrOK then
  begin
    if FSaveCfg.RBtnSaveAs.Checked then
    begin
      if length(FSaveCfg.EGrpName.Text) > 0 then GroupName:= FSaveCfg.EGrpName.Text;
    end;
    if length(FSaveCfg.IconFile) > 0 then GrpIconFile:= FSaveCfg.IconFile;
    if FSaveCfg.IconIndex >=0 then GrpIconIndex:= FSaveCfg.IconIndex;
    if FSaveCfg.CBXShortCut.Checked then
    begin
      if length(FSaveCfg.IconFile) > 0 then GrpIconFile:= FSaveCfg.IconFile;
      if FSaveCfg.IconIndex >=0 then GrpIconIndex:= FSaveCfg.IconIndex;
      CreateShortcut(Application.ExeName, DesktopPath, GroupName, '','', 'Grp='+UTF8ToAnsi(GroupName),
                     ShortCutName, GrpIconFile, GrpIconIndex);
    end;
    SaveConfig(GroupName, StateChanged);
    ListeChange:= False;
    SBSave.Enabled:= False;
    PMnuSave.Enabled:= PMnuSaveEnable(False);
  end ;
end;

procedure TFProgram.SBPrefsClick(Sender: TObject);
begin
  With Prefs do
  begin
    LWinVer.Caption:= ' '+WinVersion.VerDetail;
    if WinVersion.VerMaj > 5 then   // Vista et après
    IconDefFile:= SystemRoot+'\system32\imageres.dll' else
    IconDefFile:= SystemRoot+'\system32\shell32.dll';
    ImgGrpIcon.Picture.Icon.Handle:= Application.Icon.Handle;
    CBLangue.ItemIndex:= CurLang;
    CBStartWin.Checked:= StartWin;
    // CBStartMini.Checked:= StartMini;
    CBSavSizePos.Checked:= SavSizePos;
    CBNoChkNewVer.Checked:= NoChkNewVer;
    CBMiniInTray.Checked:= MiniInTray;
    CBHideInTaskbar.Enabled:= MiniInTray;
    CBHideInTaskbar.checked:= HideInTaskbar;
    if ShowModal = mrOK then
    begin
     If CBLangue.ItemIndex <> CurLang then
      begin
        CurLang:= CBLangue.ItemIndex;
        LangStr:= LangNums[CurLang];
        ModLangue;
      end;
      StartWin:= CBStartWin.Checked;
      SavSizePos:= CBSavSizePos.Checked;
      NoChkNewVer:= CBNoChkNewVer.Checked;
      MiniInTray:= CBMiniInTray.Checked;
      if ImgChanged then
      begin
        Application.Icon:= ImgGrpIcon.Picture.Icon ;
        Application.ProcessMessages;
        GrpIconFile:= IconFile;
        GrpIconIndex:= IconIndex;
        SBSave.Enabled:= True;
        PMnuSave.Enabled:= PmnuSaveEnable(True);
        //ImgChanged:= False;
      end;
    end;
    HideInTaskBar:= CBHideInTaskbar.Checked;
    HidinTaskBar(HideInTaskBar and MiniInTray);
    if CBXShortCut.Checked then
    begin
      CreateShortcut(Application.ExeName, DesktopPath, GroupName, '','', 'Grp='+GroupName,
                     ShortCutName, GrpIconFile, GrpIconIndex);
    end;
    TrayProgman.Visible:= MiniInTray;
    //SaveConfig(GroupName, StateChanged);
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
       FileList [i,1]:= DateTimeToStr(FileGetDateTime (s, 2));
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
        //ShowMessage(FileList[LB2.ItemIndex,0]);
        ListeFichiers.Reset;
        LoadCfgFile(FileList[LB2.ItemIndex,0]);
        LVDisplayFiles;
      end;
    end;
  end;
end;

procedure TFProgram.SBAboutClick(Sender: TObject);
begin
      AboutBox.LastUpdate:= LastUpdChk;
    AboutBox.LUpdate.Hint:=  LastUpdateSearch+': '+DateToStr(AboutBox.LastUpdate);
    AboutBox.ShowModal;
    LastUpdChk:= AboutBox.LastUpdate;
    exit;

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


// Crop speedbutton images to popup menu images
procedure TFProgram.CropBitmap(InBitmap, OutBitMap : TBitmap; Enable: Boolean);//X, Y, W, H :Integer);
begin
  OutBitMap.PixelFormat := InBitmap.PixelFormat;
  OutBitmap.Width:= InBitMap.Height;  // as we can have double width or not in sbuttons
  OutBitmap.Height:= InBitMap.Height;
  // First or second image
  if Enabled then BitBlt(OutBitMap.Canvas.Handle, 0, 0, OutBitmap.Width, OutBitmap.Height, InBitmap.Canvas.Handle, 0, 0, SRCCOPY)
  else BitBlt(OutBitMap.Canvas.Handle, 0, 0, OutBitmap.Width, OutBitmap.Height, InBitmap.Canvas.Handle, OutBitmap.Height, 0, SRCCOPY);
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
  ImgPrgSel.Picture.Icon.Handle:=  ExtractIconU(handle, GrpIconFile, GrpIconIndex);
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
begin
  if ListView1.Selected <> nil then
  begin
    PMnuRun.Visible:= True;
    PMnuRunAs.Visible:= True;
    PMnuProps.Visible:= True;
    N1.Visible:= True;
    PMnuDelete.Visible:= True;
    PMnuHideBars.Visible:= False;
    N2.Visible:= False;
    PMnuGroup.Visible:= False;
    PMnuFolder.Visible:= False;
    PMnuAddFile.Visible:= False;
    N3.Visible:= False;
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
    PMnuHideBars.Visible:= True;
    N2.Visible:= True;
    PMnuGroup.Visible:= True;
    PMnuFolder.Visible:= True;
    PMnuAddFile.Visible:= True;
    N3.Visible:= True;
    PMnuSave.Visible:= True;
    PMnuPrefs.Visible:= True;
    PMnuLoadConf.Visible:= True;
    N4.Visible:= True;
    PMnuAbout.Visible:= True;
    N5.Visible:= True;
    PMnuQuit.Visible:= True;

  end;

end;






procedure TFProgram.CBDisplayChange(Sender: TObject);
begin
  ListeChange:= True;
  LVDisplayFiles;
  IconDisplay:= CBDisplay.ItemIndex;
  IconSort:= CBSort.ItemIndex;
  SBSave.Enabled:= True;
  PMnuSave.Enabled:= PMnuSaveEnable(True);
end;

procedure TFProgram.CBSortChange(Sender: TObject);
begin
  IconSort:= CBSort.ItemIndex;
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
 //OldPath: String;
begin

  Item := ListView1.Selected;
  If Item = nil then exit;
  Fproperty.IconDefFile:= IconDefFile;
  MyFichier:=  ListeFichiers.GetItem(Item.Index);
  Fproperty.IconFile:= MyFichier.IconFile;
  Fproperty.IconIndex:= MyFichier.IconIndex;
  Fproperty.Image1.Picture.Icon.Handle:= ExtractIconU(Handle, PChar(MyFichier.IconFile), MyFichier.IconIndex);
  Fproperty.Caption:= Format(FpropertyCaption, [MyFichier.DisplayName]);
  FProperty.EDisplayName.Text:= MyFichier.DisplayName;
  FProperty.LTypeName.Caption:= MyFichier.TypeName;
  FProperty.ECible.Text:= MyFichier.Path+ MyFichier.Name;
  FProperty.EParams.Text:= MyFichier.Params;
  OldTarget:= FProperty.ECible.Text;
  Fproperty.EPath.Text:= MyFichier.StartPath;
  //Oldpath:= Fproperty.EPath.Text;
  FProperty.Memo1.Text:= MyFichier.Description;
  if FProperty.Showmodal = mrOK then
  begin
      if FProperty.ECible.Text <> OldTarget then
      begin
         ZeroMemory(@MyFichier, sizeOf(MyFichier));
         MyFichier:= GetFile(FProperty.ECible.Text);
      end else
      begin
        MyFichier.StartPath:= Fproperty.EPath.Text;
        MyFichier.IconFile:= Fproperty.IconFile;
        MyFichier.IconIndex:= Fproperty.IconIndex;
        MyFichier.DisplayName:= FProperty.EDisplayName.Text;
        MyFichier.Description:= FProperty.Memo1.Text;
        MyFichier.Params:= FProperty.EParams.Text;
      end;
      ListeFichiers.ModifyFile(Item.Index, MyFichier );
      LVDisplayFiles;

  end;










end;

procedure TFProgram.PMnuRunAsClick(Sender: TObject);
begin

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

end;





procedure TFProgram.ModLangue ;
begin
//ShowMessage(LangStr);
With LangFile do
 begin
   // MessageBox buttons
   YesBtn:= ReadString(LangStr, 'YesBtn', 'Oui');
   NoBtn:= ReadString(LangStr, 'NoBtn', 'Non');
   CancelBtn:= ReadString(LangStr, 'CancelBtn', 'Annuler');
   //Form
   CBDisplay.Items.Text:= StringReplace(ReadString(LangStr, 'CBDisplay.Items.Text',
                      ''),
                      '%s', #13#10, [rfReplaceAll]);
   CBDisplay.ItemIndex:= IconDisplay;
   CBSort.Items.Text:=  StringReplace(ReadString(LangStr, 'CBSort.Items.Text',
                      'Pas de tri%sTri par nom (ascendant)%sTri par nom (descendant)%sTri par date (ascendant)%sTri par date (descendant)'),
                     '%s', #13#10, [rfReplaceAll]);
   CBSort.ItemIndex:= IconSort;
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

   PTrayMnuRestore.Caption:= ReadString(LangStr, 'PTrayMnuRestore.Caption', PTrayMnuRestore.Caption);
   PTrayMnuMinimize.Caption:= ReadString(LangStr, 'PTrayMnuMinimize.Caption', PTrayMnuMinimize.Caption);
   PTrayMnuMaximize.Caption:= ReadString(LangStr, 'PTrayMnuMaximize.Caption', PTrayMnuMaximize.Caption);
   PTrayMnuAbout.Caption:= SBAbout.Hint;
   PTrayMnuQuit.Caption:= PMnuQuit.Caption;

   SMnuMaskBars:= LangFile.ReadString(LangStr, 'PMnuMaskBars','Masquer la barre de boutons');
   SMnuShowBars:= LangFile.ReadString(LangStr, 'PMnuShowBars','Afficher la barre de boutons');
   if HideBars then PMnuHideBars.Caption:= SMnuShowBars
   else PMnuHideBars.Caption:= SMnuMaskBars;
   ShortCutName:= ReadString(LangStr, 'ShortCutName', 'Gestionnaire de groupe de programmes');

   DeleteOKMsg:= ReadString(LangStr, 'DeleteOKMsg', 'Vous allez effacer %u élément%s. Etes-vous sur ?');

   UpdateAvailable:=ReadString(LangStr, 'UpdateAvailable', 'Nouvelle version %s disponible');
   LUpdateCaption:= ReadString(LangStr, 'LUpdateCaption', 'Recherche de mise à jour');
   LastChkCaption:= ReadString(LangStr, 'LastChkCaption', 'Dernière vérification');
   LastUpdateSearch:= ReadString(LangStr, 'LastUpdateSearch', 'Dernière recherche de mise à jour');
   NoLongerChkUpdates:= ReadString(LangStr, 'NoLongerChkUpdates', 'Ne plus rechercher les mises à jour');
   NextChkCaption:= ReadString(LangStr, 'NextChkCaption', 'Prochaine vérification');
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
   AboutBox.Caption:= SBAbout.Hint;

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
   Fproperty.LPath.Caption:= ReadString(LangStr, 'Fproperty.LPath.Caption', FProperty.LPath.Caption);

   FLoadGroup.Caption:= SBGroup.Hint;
   FLoadGroup.BtnNew.Caption:= ReadString(LangStr, 'FLoadGroup.BtnNew.Caption', FLoadGroup.BtnNew.Caption);
   FLoadGroup.BtnDelete.Caption:= ReadString(LangStr, 'FLoadGroup.BtnDelete.Caption', FLoadGroup.BtnDelete.Caption);
   FLoadGroup.BtnCancel.Caption:= CancelBtn; //SBrow1.CancelBtnCaption;

   //FloadConf.Caption:= ReadString(LangStr, 'FloadConf.Caption', FloadConf.Caption);
   //FLoadConf.BtnApply.Caption:= ReadString(LangStr, 'FLoadConf.BtnApply.Caption', FLoadConf.BtnApply.Caption);
   //FLoadConf.BtnCancel.Caption:= ReadString(LangStr, 'FLoadConf.BtnCancel.Caption', FLoadConf.BtnCancel.Caption);
 end;
end;











end.

