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
  OutFile "InstallPrgGrpMgr32.exe"

  ; The default installation directory
  InstallDir "$PROGRAMFILES\ProgramGrpMgr"

; Run in admin
  RequestExecutionLevel admin

  ;Windows vista.. 10 manifest
  ManifestSupportedOS all

;--------------------------------

  !define MUI_ICON "C:\Users\Bernard\Documents\Lazarus\Programme\ProgramGrpMgr.ico"
  !define MUI_UNICON "C:\Users\Bernard\Documents\Lazarus\Programme\ProgramGrpMgr.ico"


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
  LicenseLangString Licence ${LANG_ENGLISH} "C:\Users\Bernard\Documents\Lazarus\Programme\license.txt"
  LicenseLangString Licence ${LANG_FRENCH}  "C:\Users\Bernard\Documents\Lazarus\Programme\licensf.txt"

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

;Page instfiles

;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important
  ${If} ${RunningX64}
     MessageBox MB_OK "Sur ce système, installez l'application 64 bits"
  ${EndIf}
  SetShellVarContext all
  SetOutPath "$INSTDIR"
  File "C:\Users\Bernard\Documents\Lazarus\Programme\ProgramGrpMgrwin32.exe"
  ;Dans le cas ou on n'aurait pas pu fermer l'application
  Rename /REBOOTOK "$INSTDIR\ProgramGrpMgrwin64.exe" "$INSTDIR\ProgramGrpMgr.exe"
  ; add files / whatever that need to be installed here.
  File "C:\Users\Bernard\Documents\Lazarus\Programme\history.txt"
  File  "C:\Users\Bernard\Documents\Lazarus\Programme\ProgramGrpMgr.txt"
  File "C:\Users\Bernard\Documents\Lazarus\Programme\ProgramGrpMgr.lng"
  ;File "C:\Users\Bernard\Delphi\sdtp\Progman\ProgramGrpMgr.exe"
  Rename /REBOOTOK "$INSTDIR\ProgramGrpMgr.tmp" "$INSTDIR\ProgramGrpMgr.exe"
  File "C:\Users\Bernard\Documents\Lazarus\Programme\FAQ.txt"
  !getdllversion  "C:\Users\Bernard\Documents\Lazarus\Programme\ProgramGrpMgrwin64.exe" expv_
  ;Write uninstall in register
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "DisplayName" "$(RemoveStr)"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "DisplayVersion" "${expv_1}.${expv_2}.${expv_3}.${expv_4}"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "Publisher" "SDTP"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "URLInfoAbout" "www.sdtp.com"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "HelpLink" "www.sdtp.com"
  ;Store install folder
  WriteRegStr HKCU "Software\SDTP\ProgramGrpMgr" "InstallDir" $INSTDIR
  ; write out uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"
SectionEnd ; end the section

; Install shortcuts, language dependant

Section "Start Menu Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\ProgramGrpMgr"
  CreateShortCut  "$SMPROGRAMS\ProgramGrpMgr\$(ProgramLnkStr)" "$INSTDIR\ProgramGrpMgr.exe" "" "$INSTDIR\ProgramGrpMgr.exe" 0 SW_SHOWNORMAL "" "$(ProgramDescStr)"
  ;CreateShortCut  "$SMPROGRAMS\MeuhMeuhTV\$(HelpStr)" "$INSTDIR\MMTVRecorder.chm" "" "$INSTDIR\MMTVRecorder.chm" 0
  CreateShortCut  "$SMPROGRAMS\ProgramGrpMgr\$(UninstLnkStr)" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0

SectionEnd

;Uninstaller Section

Section Uninstall
SetShellVarContext all
; add delete commands to delete whatever files/registry keys/etc you installed here.
Delete /REBOOTOK "$INSTDIR\ProgramGrpMgr.exe"
Delete "$INSTDIR\history.txt"
Delete "$INSTDIR\ProgramGrpMgr.txt"
;Delete "$INSTDIR\ProgramGrpMgr.exe"
Delete "$INSTDIR\ProgramGrpMgr.lng"
Delete "$INSTDIR\FAQ.txt"
Delete "$INSTDIR\uninst.exe"

; remove shortcuts, if any.
  Delete  "$SMPROGRAMS\ProgramGrpMgr\$(ProgramLnkStr)"
  Delete  "$SMPROGRAMS\ProgramGrpMgr\$(UninstLnkStr)"
  Delete  "$DESKTOP\$(ProgramLnkStr)"
;  Delete "$SMPROGRAMS\MeuhMeuhTV\$(HelpStr)"


; remove directories used.
  RMDir "$SMPROGRAMS\ProgramGrpMgr"
  RMDir "$INSTDIR"

DeleteRegKey HKCU "Software\SDTP\ProgramGrpMgr"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr"

SectionEnd ; end of uninstall section

Function inst_shortcut
  CreateShortCut "$DESKTOP\$(ProgramLnkStr)" "$INSTDIR\ProgramGrpMgr.exe"
FunctionEnd