//******************************************************************************
// config1 Unit
// Main settings values
//******************************************************************************

unit Config1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, laz2_DOM , laz2_XMLRead, bbutils;

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
    FHideBars: Boolean;
    FLangStr: String;
    Parent: TObject;
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
    procedure SetHideBars (b: Boolean);
    procedure SetLangStr (s: string);
    function SaveToXMLnode(iNode: TDOMNode): Boolean;
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
    property HideBars: Boolean read FHideBars write SetHideBars;
    property LangStr: String read FLangStr write SetLangStr;
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
   if HideInTaskbar <> b then
   begin
     FHideInTaskbar:= b;
     if Assigned(FOnStateChange) then FOnStateChange(Self);
   end;
end;

procedure TConfig.SetHideBars (b: Boolean);
begin
  if HideBars <> b then
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

function TConfig.SaveToXMLnode(iNode: TDOMNode): Boolean;
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
    TDOMElement(iNode).SetAttribute ('hidebars', IntToStr(Integer(FHideBars)));
    TDOMElement(iNode).SetAttribute ('wstate', FWState);
    TDOMElement(iNode).SetAttribute ('nochknewver', IntToStr(Integer(FNoChkNewVer)));
    TDOMElement(iNode).SetAttribute ('lastupdchk', DateToStr(FLastUpdChk));
    TDOMElement(iNode).SetAttribute ('startwin', IntToStr(Integer(FStartWin)));
    TDOMElement(iNode).SetAttribute ('langstr', FLangStr);
    Result:= True;
  except
    result:= False;
  end;
end;

function TConfig.ReadXMLNode(iNode: TDOMNode): Boolean;
begin
  try
    FGroupName:= TDOMElement(iNode).GetAttribute('groupname');
    FGrpIconFile:= TDOMElement(iNode).GetAttribute('grpiconfile');
    FGrpIconIndex:= StrToInt(TDOMElement(iNode).GetAttribute('grpiconindex'));
    FSavSizePos:= Boolean(StrToInt(TDOMElement(iNode).GetAttribute('savsizepos')));
    FIconDisplay:= StrToInt(TDOMElement(iNode).GetAttribute('icondisplay'));
    FIconSort:= StrToInt(TDOMElement(iNode).GetAttribute('iconsort'));
    FMiniInTray:= Boolean(StrToInt(TDOMElement(iNode).GetAttribute('miniintray')));
    FHideInTaskBar:= Boolean(StrToInt(TDOMElement(iNode).GetAttribute('hideintaskbar')));
    FHideBars:= Boolean(StrToInt(TDOMElement(iNode).GetAttribute('hidebars')));
    FWState:= TDOMElement(iNode).GetAttribute('wstate');
    FNoChkNewVer:= Boolean(StrToInt(TDOMElement(iNode).GetAttribute('nochknewver')));
    FLastUpdChk:= StrToDate(TDOMElement(iNode).GetAttribute('lastupdchk'));
    FStartWin:= Boolean(StrToInt(TDOMElement(iNode).GetAttribute('startwin')));
    FLangStr:= TDOMElement(iNode).GetAttribute('langstr');
    Result:= True;
  except
    Result:= False;
  end;
end;


end.

