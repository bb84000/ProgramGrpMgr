;Installation script for ProgramGrpMgr

;--------------------------------

  !include "MUI2.nsh"
  !include "${NSISDIR}\Contrib\Modern UI\BB.nsh"
  !include x64.nsh
  !include FileFunc.nsh
  
;--------------------------------
;Configuration

  ;General
  Name "Program Group Manager"
  OutFile "InstallPrgGrpMgr.exe"
  !define source_dir "C:\Users\Bernard\Documents\Lazarus\ProgramGrpMgr"

  RequestExecutionLevel admin
  
  ;Windows vista.. 10 manifest
  ManifestSupportedOS all


  !define MUI_ICON "${source_dir}\ProgramGrpMgr.ico"
  !define MUI_UNICON "${source_dir}\ProgramGrpMgr.ico"

  ; The default installation directory
  InstallDir "$PROGRAMFILES\ProgramGrpMgr"

;--------------------------------
; Interface Settings

!define MUI_ABORTWARNING

;--------------------------------
;Language Selection Dialog Settings

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "HKCU"
  !define MUI_LANGDLL_REGISTRY_KEY "Software\SDTP\ProgramGrpMgr"
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"
  !define MUI_FINISHPAGE_SHOWREADME
  !define MUI_FINISHPAGE_SHOWREADME_TEXT "$(Check_box)"
  !define MUI_FINISHPAGE_SHOWREADME_FUNCTION inst_shortcut
; Pages

  !define MUI_WELCOMEPAGE_TITLE_3LINES
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
  LangString RemoveStr ${LANG_ENGLISH}  "Program Group Manager"
  LangString RemoveStr ${LANG_FRENCH} "Gestionnaire de groupe de programmes"

  ;Language string for links
  LangString ProgramLnkStr ${LANG_ENGLISH} "Program Group Manager.lnk"
  LangString ProgramLnkStr ${LANG_FRENCH} "Gestionnaire de groupe de programmes.lnk"
  LangString UninstLnkStr ${LANG_ENGLISH} "Program Group Manager uninstall.lnk"
  LangString UninstLnkStr ${LANG_FRENCH} "D�sinstallation du Gestionnaire de groupe de programmes.lnk"

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
  LangString No_Install ${LANG_FRENCH} "Cette application ne peut pas �tre install�e sur un syst�me 32bits"
  
  ; Language styring for remove old install
  LangString Remove_Old ${LANG_ENGLISH} "Install will remove a previous installation."
  LangString Remove_Old ${LANG_FRENCH} "Install va supprimer une ancienne installation."


;--------------------------------

; The stuff to install
Section "" ;No components page, name is not important
  SetShellVarContext all
  SetOutPath "$INSTDIR"

  ${If} ${RunningX64}
    SetRegView 64    ; change registry entries and install dir for 64 bit
  ${EndIf}
  Var /GLOBAL prg_to_inst
  Var /GLOBAL prg_to_del
  ${If} ${RunningX64}  ; change registry entries and install dir for 64 bit
     !getdllversion  "${source_dir}\ProgramGrpMgrwin64.exe" expv_
     StrCpy "$prg_to_inst" "$INSTDIR\ProgramGrpMgrwin64.exe"
     StrCpy "$prg_to_del" "$INSTDIR\ProgramGrpMgrwin32.exe"
  ${Else}
     !getdllversion  "${source_dir}\ProgramGrpMgrwin32.exe" expv_
     StrCpy "$prg_to_inst" "$INSTDIR\ProgramGrpMgrwin32.exe"
     StrCpy "$prg_to_del" "$INSTDIR\ProgramGrpMgrwin64.exe"
  ${EndIf}

  ; Dans le cas ou on n'aurait pas pu fermer l'application
  Delete /REBOOTOK "$INSTDIR\ProgramGrpMgr.exe"
  File "${source_dir}\ProgramGrpMgrwin64.exe"
  File "${source_dir}\ProgramGrpMgrwin32.exe"
  File "${source_dir}\libeay32.dll"
  File "${source_dir}\ssleay32.dll"
  File "${source_dir}\licensf.txt"
  File "${source_dir}\license.txt"
  File "${source_dir}\OpenSSL License.txt"
  File "${source_dir}\history.txt"
  File "${source_dir}\ProgramGrpMgr.txt"
  File "${source_dir}\ProgramGrpMgr.lng"
  File "${source_dir}\ProgramGrpMgr.ini"
  File "${source_dir}\FAQ.txt"
  Rename /REBOOTOK "$prg_to_inst" "$INSTDIR\ProgramGrpMgr.exe"
  Delete /REBOOTOK "$prg_to_del"

  ; write out uninstaller
  WriteUninstaller "$INSTDIR\uninst.exe"
  
  ; Get install folder size
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2

  ;Write uninstall in register
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "DisplayIcon" "$INSTDIR\uninst.exe"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "DisplayName" "$(RemoveStr)"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "DisplayVersion" "${expv_1}.${expv_2}.${expv_3}.${expv_4}"
  WriteRegDWORD HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "EstimatedSize" "$0"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "Publisher" "SDTP"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "URLInfoAbout" "www.sdtp.com"
  WriteRegStr HKEY_LOCAL_MACHINE "Software\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "HelpLink" "www.sdtp.com"
  ;Store install folder
  WriteRegStr HKCU "Software\SDTP\ProgramGrpMgr" "InstallDir" $INSTDIR

SectionEnd ; end the section

; Install shortcuts, language dependant

Section "Start Menu Shortcuts"
  SetShellVarContext all
  CreateDirectory "$SMPROGRAMS\ProgramGrpMgr"
  CreateShortCut  "$SMPROGRAMS\ProgramGrpMgr\$(ProgramLnkStr)" "$INSTDIR\ProgramGrpMgr.exe" "" "$INSTDIR\ProgramGrpMgr.exe" 0 SW_SHOWNORMAL "" "$(ProgramDescStr)"
  CreateShortCut  "$SMPROGRAMS\ProgramGrpMgr\$(UninstLnkStr)" "$INSTDIR\uninst.exe" "" "$INSTDIR\uninst.exe" 0

SectionEnd

;Uninstaller Section

Section Uninstall
SetShellVarContext all
; add delete commands to delete whatever files/registry keys/etc you installed here.
Delete /REBOOTOK "$INSTDIR\ProgramGrpMgr.exe"
Delete "$INSTDIR\history.txt"
Delete "$INSTDIR\ProgramGrpMgr.txt"
Delete "$INSTDIR\ProgramGrpMgr.lng"
Delete "$INSTDIR\ProgramGrpMgr.ini"
Delete "$INSTDIR\libeay32.dll"
Delete "$INSTDIR\ssleay32.dll"
Delete "$INSTDIR\licensf.txt"
Delete "$INSTDIR\license.txt"
Delete "$INSTDIR\OpenSSL License.txt"
Delete "$INSTDIR\FAQ.txt"
Delete "$INSTDIR\uninst.exe"

; remove shortcuts, if any.
  Delete  "$SMPROGRAMS\ProgramGrpMgr\$(ProgramLnkStr)"
  Delete  "$SMPROGRAMS\ProgramGrpMgr\$(UninstLnkStr)"
  Delete  "$DESKTOP\$(ProgramLnkStr)"


; remove directories used.
  RMDir "$SMPROGRAMS\ProgramGrpMgr"
  RMDir "$INSTDIR"

DeleteRegKey HKCU "Software\SDTP\ProgramGrpMgr"
DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr"

SectionEnd ; end of uninstall section

Function inst_shortcut
  CreateShortCut "$DESKTOP\$(ProgramLnkStr)" "$INSTDIR\ProgramGrpMgr.exe"
FunctionEnd

Function .onInit
  ${If} ${RunningX64}
    SetRegView 64    ; change registry entries and install dir for 64 bit
    StrCpy "$INSTDIR" "$PROGRAMFILES64\ProgramGrpMgr"
  ${Else}

  ${EndIf}
  SetShellVarContext all
  ; Close all apps instance
  FindProcDLL::FindProc "$INSTDIR\ProgramGrpMgr.exe"
  ${While} $R0 > 0
    FindProcDLL::KillProc "$INSTDIR\ProgramGrpMgr.exe"
    FindProcDLL::WaitProcEnd "$INSTDIR\ProgramGrpMgr.exe" -1
    FindProcDLL::FindProc "$INSTDIR\ProgramGrpMgr.exe"
  ${EndWhile}
  ; See if there is old program
  ReadRegStr $R0 HKLM "SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\ProgramGrpMgr" "UninstallString"
   ${If} $R0 == ""
        Goto Done
   ${EndIf}
  MessageBox MB_OK "$(Remove_Old)"
  ExecWait $R0
  Done:
FunctionEnd