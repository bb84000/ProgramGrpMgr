program  ProgramGrpMgr ;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, indylaz, program1, files1, about, SaveCfg1, prefs1, Property1,
  ChkNewVer, alert, LoadGroup1, LoadConf1
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='ProgramGrpMgr';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFProgram, FProgram);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TFSaveCfg, FSaveCfg);
  Application.CreateForm(TPrefs, Prefs);
  Application.CreateForm(TFProperty, FProperty);
  Application.CreateForm(TFChkNewVer, FChkNewVer);
  Application.CreateForm(TAlertBox, AlertBox);
  Application.CreateForm(TFLoadGroup, FLoadGroup);
  Application.CreateForm(TFLoadConf, FLoadConf);
  Application.Run;
end.

