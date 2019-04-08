//******************************************************************************
// config1 Unit
// Main settings values
//******************************************************************************

unit Config1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

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
  public
    constructor Create; overload;
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
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnStateChange: TNotifyEvent read FOnStateChange write FOnStateChange;
    property GroupName: string read FGroupName write SetGroupName;
    property SavSizePos: Boolean read FSavSizePos write SetSavSizePos;
    property WState: string read FWState write SetWState;
    property GrpIconFile: string read FGrpIconFile write SetGrpIconFile ;
    property GrpIconIndex: integer read FGrpIconIndex write SetGrpIconIndex;
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

constructor TConfig.Create;
begin
  inherited;
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

end.

