; example1.nsi
;
; This script is perhaps one of the simplest NSIs you can make. All of the
; optional settings are left to their default settings. The installer simply
; prompts the user asking them where to install, and drops a copy of example1.nsi
; there.

;--------------------------------
  !include "MUI2.nsh"
  !include "${NSISDIR}\Contrib\Modern UI\BB.nsh"
  !include x64.nsh

  ;General
  Name "Program Group Manager"
  OutFile "test.exe"

  ; The default installation directory
  InstallDir "$PROGRAMFILES64\ProgramGrpMgr"

; Run in admin
  RequestExecutionLevel admin

  ;Windows vista.. 10 manifest
  ManifestSupportedOS all

;--------------------------------

  !define MUI_ICON "C:\Users\Bernard\Documents\Lazarus\ProgramGrpMgr\ProgramGrpMgr.ico"
  !define MUI_UNICON "C:\Users\Bernard\Documents\Lazarus\ProgramGrpMgr\ProgramGrpMgr.ico"


;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU"
  !define MUI_LANGDLL_REGISTRY_KEY "Software\SDTP\ProgramGrpMgr"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"
  !define MUI_FINISHPAGE_SHOWREADME
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "$(Check_box)"
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION inst_shortcut
; Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE $(licence)
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;Languages
;Languages
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "French"


  ;Licence langage file
  LicenseLangString Licence ${LANG_ENGLISH} "C:\Users\Bernard\Documents\Lazarus\ProgramGrpMgr\license.txt"
  LicenseLangString Licence ${LANG_FRENCH}  "C:\Users\Bernard\Documents\Lazarus\ProgramGrpMgr\licensf.txt"

  ;Language strings for uninstall string
  LangString RemoveStr ${LANG_ENGLISH}  "Program Group Manager (remove only)"
  LangString RemoveStr ${LANG_FRENCH} "Gestionnaire de groupe de programmes (désinstallation seulement)"

  ;Language string for links
  LangString ProgramLnkStr ${LANG_ENGLISH} "Program Group Manager.lnk"
  LangString ProgramLnkStr ${LANG_FRENCH} "Gestionnaire de groupe de programmes.lnk"
  LangString UninstLnkStr ${LANG_ENGLISH} "Program Group Manager uninstall.lnk"
  LangString UninstLnkStr ${LANG_FRENCH} "Désinstallation du Gestionnaire de groupe de programmes.lnk"

  LangString ProgramDescStr ${LANG_ENGLISH} "Program Group Manager"
  LangString ProgramDescStr ${LANG_FRENCH} "Gestionnaire de groupe de programmes"

  ;Language strings for language selection dialog
  LangString LangDialog_Title ${LANG_ENGLISH} "Installer Language|$(^CancelBtn)"
  LangString LangDialog_Title ${LANG_FRENCH} "Langue d'installation|$(^CancelBtn)"

  LangString LangDialog_Text ${LANG_ENGLISH} "Please select the installer language."
  LangString LangDialog_Text ${LANG_FRENCH} "Choisissez la langue du programme d'installation."

  ;language strings for checkbox
  LangString Check_box ${LANG_ENGLISH} "Install a shortcut on the desktop"
  LangString Check_box ${LANG_FRENCH} "Installer un raccourci sur le bureau"
  
  ;Cannot install
  LangString No_Install ${LANG_ENGLISH} "The application cannot be installed on a 32bit system"
  LangString No_Install ${LANG_FRENCH} "Cette application ne peut pas être installée sur un système 32bits"

  LangString Remove_Old ${LANG_ENGLISH} "Install will remove a previous installation."
  LangString Remove_Old ${LANG_FRENCH} "Install va supprimer une ancienne installation."
  
;Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important

  SetOutPath "$INSTDIR"
SectionEnd ; end the section

; Install shortcuts, language dependant

Section "Start Menu Shortcuts"
SectionEnd

;Uninstaller Section

Section Uninstall
SetShellVarContext all
SectionEnd ; end of uninstall section

Function inst_shortcut
  CreateShortCut "$DESKTOP\$(ProgramLnkStr)" "$INSTDIR\ProgramGrpMgr.exe"
FunctionEnd

Function .onInit
  ${If} ${RunningX64}
    SetRegView 64    ; change registry entries and install dir for 64 bit
  ${Else}
     MessageBox MB_OK "$(No_Install)"
     Quit
  ${EndIf}
  SetShellVarContext all
  ReadRegStr $R0 HKLM "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "UninstallString"
   ${If} $R0 == ""
        Goto Done
   ${EndIf}
  MessageBox MB_OK "$(Remove_Old)"
  ExecWait $R0
  Done:
FunctionEnd