unit LoadGroup1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls;

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

end.

