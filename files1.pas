//******************************************************************************
// Unit Files1 for ProgramGrpMgr (Lazarus)
// bb- sdtp - march 2019
//******************************************************************************

unit files1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dialogs;
Type


  TChampsCompare = (cdcNone, cdcDate, cdcName, cdcDisplayName, cdcSize, cdcTypeName);
  TSortDirections = (ascend, descend);
  PFichier = ^TFichier;
  TFichier = Record
    Name: String;
    Path: String;
    DisplayName: String;
    Params: String;
    StartPath: String;
    Description: String;
    Size: Int64;
    TypeName: String;
    Date: TDateTime;
    IconFile: String;
    IconIndex: Integer;
    OldIcon: Boolean;
  end;

 TFichierList = class(TList)
  private
    FOnChange: TNotifyEvent;
    FSortType: TChampsCompare;
    FSortDirection: TSortDirections;
  public
    Duplicates : TDuplicates;
    procedure Delete (const i : Integer);
    procedure DoMove (CurIndex,NewIndex:Integer);


    procedure DeleteMulti (j, k : Integer);
    procedure Reset;
    procedure AddFile(Fichier : TFichier);
    procedure ModifyFile (const i: integer; Fichier : TFichier);
    function GetItem(const i: Integer): TFichier;
    procedure DoSort;
    //procedure Move(CurIndex,NewIndex:Integer));
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    Property SortType : TChampsCompare read FSortType write FSortType default cdcNone;
    property SortDirection: TSortDirections read FSortDirection write FSortDirection default ascend;
  end;
  function CompareMulti(Item1, Item2: Pointer): Integer;
  function CompareMultiDesc(Item1, Item2: Pointer): Integer;
var
  ClesTri: array[0..10] of TChampsCompare;


implementation

function stringCompare(Item1, Item2: String): Integer;
begin

  result := Comparestr(UpperCase(Item1), UpperCase(Item2));
end;

function NumericCompare(Item1, Item2: Double): Integer;
begin
  if Item1 > Item2 then result := 1
  else
  if Item1 = Item2 then result := 0
  else result := -1;
end;

function CompareMulti(Item1, Item2: Pointer): Integer;
var
 Entry1, Entry2: PFichier;
 R, J: integer;
 ResComp: array[TChampsCompare] of integer;
begin
 Entry1:= PFichier(Item1);
 Entry2:= PFichier(Item2);
 ResComp[cdcNone]  := 0;
 ResComp[cdcDate]:= NumericCompare(Entry1^.Date, Entry2^.Date);
 ResComp[cdcName]  := StringCompare(Entry1^.Name, Entry2^.Name);
 ResComp[cdcDisplayName]:= StringCompare(Entry1^.DisplayName, Entry2^.DisplayName);
 ResComp[cdcSize]:= NumericCompare(Entry1^.Size, Entry2^.Size);

 R := 0;
 for J := 0 to 10 do
 begin
   if ResComp[ClesTri[J]] <> 0 then
    begin
      R := ResComp[ClesTri[J]];
      break;
    end;
 end;
 result :=  R;
end;

function CompareMultiDesc(Item1, Item2: Pointer): Integer;
begin
  result:=  -CompareMulti(Item1, Item2);
end;

procedure TFichierList.DoSort;
begin
  if FSortType <> cdcNone then
  begin
    ClesTri[1] := FSortType;
    //ClesTri[2] := cdcName;
    //ClesTri[3] := cdcDur;
    if FSortDirection = ascend then sort(@comparemulti) else sort(@comparemultidesc);
  end;
end;

procedure TFichierList.DoMove (CurIndex,NewIndex:Integer);
begin
  Move (CurIndex,NewIndex);
  if Assigned(FOnChange) then FOnChange(Self);
end;



procedure TFichierList.AddFile(Fichier : TFichier);
var
 K: PFichier;
begin
  new(K);
  K^.Name := Fichier.Name;
  K^.Path := Fichier.Path;
  K^.DisplayName:= Fichier.DisplayName;
  K^.Params:= Fichier.Params;
  K^.StartPath:= Fichier.StartPath;
  K^.Size:= Fichier.Size;
  K^.TypeName:= Fichier.TypeName;
  K^.Description:= Fichier.Description;
  K^.Date:= Fichier.Date;
  K^.IconFile:= Fichier.IconFile;
  K^.IconIndex:= Fichier.IconIndex;
  K^.OldIcon:= Fichier.OldIcon;
  add(K);
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TFichierList.ModifyFile (const i: integer; Fichier : TFichier);
begin
  TFichier(Items[i]^).Name := Fichier.Name;
  TFichier(Items[i]^).Path:= Fichier.Path;
  TFichier(Items[i]^).DisplayName  := Fichier.DisplayName;
  TFichier(Items[i]^).Params:= Fichier.Params;
  TFichier(Items[i]^).StartPath:= Fichier.StartPath;
  TFichier(Items[i]^).Size := Fichier.Size;
  TFichier(Items[i]^).TypeName := Fichier.TypeName;
  TFichier(Items[i]^).Description:= Fichier.Description;
  TFichier(Items[i]^).Date := Fichier.Date;
  TFichier(Items[i]^).IconFile := Fichier.IconFile;
  TFichier(Items[i]^).IconIndex := Fichier.IconIndex;
  TFichier(Items[i]^).OldIcon := Fichier.OldIcon;
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;


procedure TFichierList.Delete(const i: Integer);
begin
  inherited delete(i);
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TFichierList.DeleteMulti(j, k : Integer);
var
  i : Integer;
begin
  // On commence par le dernier, ajouter des sécurités
  For i:= k downto j do
  begin
     inherited delete(i);
  end;
  DoSort;
  if Assigned(FOnChange) then FOnChange(Self);
end;

function TFichierList.GetItem(const i: Integer): TFichier;
begin
 Result := TFichier(Items[i]^);
end;

procedure TFichierList.Reset;
var
 i: Integer;
begin
 for i := 0 to Count-1 do
  if Items[i] <> nil then Items[i]:= nil;
 Clear;
end;

end.

