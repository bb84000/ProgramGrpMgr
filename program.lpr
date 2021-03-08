//******************************************************************************
// Main unit for ProgramGrpManager (Lazarus)
// bb - sdtp - february 2021
//******************************************************************************
program  ProgramGrpMgr ;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, program1,  lazbbaboutupdate, SaveCfg1, prefs1, Property1,
  ChkNewVer, LoadGroup1, LoadConf1, lazbbChkNewVer ;

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
  Application.CreateForm(TFLoadGroup, FLoadGroup);
  Application.CreateForm(TFLoadConf, FLoadConf);

  Application.Run;
end.

