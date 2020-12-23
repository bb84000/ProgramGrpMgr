//******************************************************************************
// config1 Unit
// Main settings values
//******************************************************************************

unit Config1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, laz2_DOM , laz2_XMLRead, bbutils, dialogs, graphics;

type
  TConfig = class
  private
    FOnChange: TNotifyEvent;
    FOnStateChange: TNotifyEvent;
    FGroupName: string;
    FSavSizePos: Boolean;
    FWState: string;
    FGrpIconFile: string;
    FGrpIconIndex: integer;
    FIconDisplay: integer;
    FIconSort: Integer;
    FLastUpdChk: Tdatetime;
    FNoChkNewVer: Boolean;
    FStartWin: Boolean;
    FMiniInTray: Boolean;
    FHideInTaskBar: Boolean;
    FIconCache: Boolean;
    FHideBars: Boolean;
    FLangStr: String;
    Parent: TObject;
    FBkgrndColor: TColor;
    function readIntValue(inode : TDOMNode; Attrib: String): Int64;
    function readDateValue(inode : TDOMNode; Attrib: String): TDateTime;

  public
    constructor Create (Sender: TObject); overload;
    procedure SetGroupName (s: string);
    procedure SetSavSizePos (b: Boolean);
    procedure SetWState (s: string);
    procedure SetGrpIconFile (s: string);
    procedure SetGrpIconIndex (i: integer);
    procedure SetIconDisplay (i: integer);
    procedure SetIconSort (i: integer);
    procedure SetLastUpdChk (dt: TDateTime);
    procedure SetNoChkNewVer (b: Boolean);
    procedure SetStartWin (b: Boolean);
    procedure SetMiniInTray (b: Boolean);
    procedure SetHideInTaskBar (b: Boolean);
    procedure SetIconCache (b: Boolean);
    procedure SetHideBars (b: Boolean);
    procedure SetLangStr (s: string);
    procedure SetBkgrndColor(cl: Tcolor);
    function SaveXMLnode(iNode: TDOMNode): Boolean;
    function ReadXMLNode(iNode: TDOMNode): Boolean;

  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;
    property GroupName: string read FGroupName write SetGroupName;
    property GrpIconFile: string read FGrpIconFile write SetGrpIconFile ;
    property GrpIconIndex: integer read FGrpIconIndex write SetGrpIconIndex;
    property SavSizePos: Boolean read FSavSizePos write SetSavSizePos;
    property WState: string read FWState write SetWState;
    property IconDisplay: integer read FIconDisplay write SetIconDisplay default 3;
    property IconSort: Integer read FIconSort write SetIconSort default 0;
    property LastUpdChk: Tdatetime read FLastUpdChk write SetLastUpdChk;
    property NoChkNewVer: Boolean read FNoChkNewVer write SetNoChkNewVer;
    property StartWin: Boolean read FStartWin write SetStartWin;
    property MiniInTray: Boolean read FMiniInTray write SetMiniInTray;
    property HideInTaskBar: Boolean read FHideInTaskBar write SetHideInTaskBar;
    property IconCache: Boolean read FIconCache write SetIconCache;
    property HideBars: Boolean read FHideBars write SetHideBars;
    property LangStr: String read FLangStr write SetLangStr;
    property BkgrndColor: TColor read FBkgrndColor write SetBkgrndColor;
  end;


implementation

constructor TConfig.Create(Sender: TObject);
begin
  Create;
  Parent:= Sender;
end;

procedure TConfig.SetGroupName(s: string);
begin
   if FGroupName <> s then
   begin
     FGroupName:= s;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetSavSizePos(b: Boolean);
begin
  if FSavSizePos <> b then
  begin
    FSavSizePos:= b;
    if Assigned(FOnStateChange) then FOnStateChange(Self);
  end;
end;

procedure TConfig.SetWState(s: string);
begin
   if FWState <> s then
   begin
     FWState:= s;
     if Assigned(FOnStateChange) then FOnStateChange(Self);
   end;
end;

procedure TConfig.SetGrpIconFile (s: string);
begin
  if FGrpIconFile <> s then
  begin
   FGrpIconFile:= s;
   if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TConfig.SetGrpIconIndex (i: integer);
begin
   if  FGrpIconIndex <> i then
  begin
    FGrpIconIndex:= i;
    if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetIconDisplay (i: integer);
begin
   if FIconDisplay <> i then
   begin
     FIconDisplay:= i;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetIconSort (i: integer);
begin
   if FIconSort <> i then
   begin
     FIconSort:= i;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetLastUpdChk(dt: TDateTime);
begin
   if FLastUpdChk <> dt then
   begin
     FLastUpdChk:= dt;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetNoChkNewVer(b: Boolean);
begin
   if FNoChkNewVer <> b then
   begin
     FNoChkNewVer:= b;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetStartWin (b: Boolean);
begin
   if FStartWin <> b then
   begin
     FStartWin:= b;
     if Assigned(FOnChange) then FOnChange(Self);
   end;
end;

procedure TConfig.SetMiniInTray (b: Boolean);
begin
   if FMiniInTray <> b then
   begin
     FMiniInTray:= b;
     if Assigned(FOnStateChange) then FOnStateChange(Self);
   end;
end;

procedure TConfig.SetHideInTaskBar (b: Boolean);
begin
   if FHideInTaskbar <> b then
   begin
     FHideInTaskbar:= b;
     if Assigned(FOnStateChange) then FOnStateChange(Self);
   end;
end;

procedure TConfig.SetIconCache (b: Boolean);
begin
  if FIconCache <> b then
  begin
    FIconCache:=  b;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TConfig.SetHideBars (b: Boolean);
begin
  if FHideBars <> b then
  begin
    FHideBars:= b;
    if Assigned(FOnStateChange) then FOnStateChange(Self);
  end;
end;

procedure TConfig.SetLangStr (s: string);
begin
  if FLangStr <> s then
  begin
    FLangStr:= s;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

procedure TConfig.SetBkgrndColor(cl: TColor);
begin
  if FBkgrndColor <> cl then
  begin
    FBkgrndColor:= cl;
    if Assigned(FOnChange) then FOnChange(Self);
  end;
end;

function TConfig.SaveXMLnode(iNode: TDOMNode): Boolean;
begin
  Try
    TDOMElement(iNode).SetAttribute('groupname', FGroupName);
    TDOMElement(iNode).SetAttribute ('grpiconfile', FGrpIconFile);
    TDOMElement(iNode).SetAttribute ('grpiconindex', IntToStr(FGrpIconIndex));
    TDOMElement(iNode).SetAttribute ('savsizepos', IntToStr(Integer(FSavSizePos)));
    TDOMElement(iNode).SetAttribute ('icondisplay', IntToStr(FIconDisplay));
    TDOMElement(iNode).SetAttribute ('iconsort' , IntToStr(FIconSort));
    TDOMElement(iNode).SetAttribute ('miniintray',IntToStr(Integer(FMiniInTray)));
    TDOMElement(iNode).SetAttribute ('hideintaskbar', IntToStr(Integer(FHideInTaskBar)));
    TDOMElement(iNode).SetAttribute ('iconcache', IntToStr(Integer(FIconCache)));
    TDOMElement(iNode).SetAttribute ('hidebars', IntToStr(Integer(FHideBars)));
    TDOMElement(iNode).SetAttribute ('wstate', FWState);
    TDOMElement(iNode).SetAttribute ('nochknewver', IntToStr(Integer(FNoChkNewVer)));
    TDOMElement(iNode).SetAttribute ('lastupdchk', DateToStr(FLastUpdChk));
    TDOMElement(iNode).SetAttribute ('startwin', IntToStr(Integer(FStartWin)));
    TDOMElement(iNode).SetAttribute ('langstr', FLangStr);
    TDOMElement(iNode).SetAttribute ('bkgrndcolor', ColorToString(FBkgrndColor));
    Result:= True;
  except
    result:= False;
  end;
end;


function TConfig.readIntValue(inode : TDOMNode; Attrib: String): INt64;
var
  s: String;
begin
  s:= TDOMElement(iNode).GetAttribute(Attrib) ;
  try
    result:= StrToInt64(s);
  except
    result:= 0;
  end;
end;

function TConfig.readDateValue(inode : TDOMNode; Attrib: String): TDateTime;
var
  s: String;
begin
  s:= TDOMElement(iNode).GetAttribute(Attrib) ;
  try
    result:= StrToDateTime(s);
  except
    result:= now();
  end;
end;

function TConfig.ReadXMLNode(iNode: TDOMNode): Boolean;
begin
  try
    FGroupName:= TDOMElement(iNode).GetAttribute('groupname');
    FGrpIconFile:= TDOMElement(iNode).GetAttribute('grpiconfile');
    FGrpIconIndex:= readIntValue(iNode, 'grpiconindex');   //StrToInt(TDOMElement(iNode).GetAttribute('grpiconindex'));
    FSavSizePos:= Boolean(readIntValue(iNode, 'savsizepos'));    //StrToInt(TDOMElement(iNode).GetAttribute('savsizepos')));
    FIconDisplay:= readIntValue(iNode, 'icondisplay'); //StrToInt(TDOMElement(iNode).GetAttribute('icondisplay'));
    FIconSort:=  readIntValue(iNode, 'iconsort');   //StrToInt(TDOMElement(iNode).GetAttribute('iconsort'));
    FMiniInTray:= Boolean(readIntValue(iNode, 'miniintray'));               //StrToInt(TDOMElement(iNode).GetAttribute('miniintray')));
    FHideInTaskBar:= Boolean(readIntValue(iNode, 'hideintaskbar')); //StrToInt(TDOMElement(iNode).GetAttribute('hideintaskbar')));
    FIconCache:=  Boolean(readIntValue(iNode, 'iconcache'));
    FHideBars:= Boolean(readIntValue(iNode, 'hidebars'));  //StrToInt(TDOMElement(iNode).GetAttribute('hidebars')));
    FWState:= TDOMElement(iNode).GetAttribute('wstate');
    FNoChkNewVer:= Boolean(readIntValue(iNode, 'nochknewver')); //StrToInt(TDOMElement(iNode).GetAttribute('nochknewver')));
    FLastUpdChk:= readDateValue(iNode, 'lastupdchk');  //StrToDate(TDOMElement(iNode).GetAttribute('lastupdchk'));
    FStartWin:= Boolean(readIntValue(iNode, 'startwin')); //StrToInt(TDOMElement(iNode).GetAttribute('startwin')));
    FLangStr:= TDOMElement(iNode).GetAttribute('langstr');
    FBkgrndColor:= StringToColor(TDOMElement(iNode).GetAttribute('bkgrndcolor'));
    result:= true;
  except
    Result:= False;
  end;
end;


end.

