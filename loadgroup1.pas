unit LoadGroup1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  lazbbinifiles;

type

  { TFLoadGroup }

  TFLoadGroup = class(TForm)
    BtnCancel: TButton;
    BtnDelete: TButton;
    BtnNew: TButton;
    BtnOK: TButton;
    IL1: TImageList;
    LV1: TListView;
    procedure LV1SelectItem(Sender: TObject; Item: TListItem; Selected: Boolean );
  private

  public
    procedure Translate(LngFile: TBbiniFile);
  end;

var
  FLoadGroup: TFLoadGroup;

implementation

{$R *.lfm}

{ TFLoadGroup }

procedure TFLoadGroup.LV1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  BtnOK.Enabled:= True;
  BtnDelete.Enabled:= True;
end;

procedure TFLoadGroup.Translate(LngFile: TBbIniFile);
begin
  if assigned (Lngfile) then
  with LngFile do
  begin
    BtnOK.Caption:= ReadString('common', 'OKBtn', BtnOK.Caption);
    BtnCancel.Caption:= ReadString('common', 'CancelBtn', BtnCancel.Caption);
    BtnDelete.Caption:= ReadString('FLoadGroup', 'BtnDelete.Caption', BtnDelete.Caption);
    BtnNew.Caption:= ReadString('FLoadGroup', 'BtnNew.Caption', BtnNew.Caption);
  end;
end;

end.

