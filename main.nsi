;======================================================
; Include
  !include "MUI2.nsh"
  !include "nsDialogs.nsh"
	
;======================================================
; Installer Information
	# name the installer
	OutFile "RFPlatformInstaller.exe"
	Name "Robot-Framework Platform"
	
;======================================================
; Pages
	Page custom WelcomePageCreate
	!insertmacro MUI_PAGE_DIRECTORY
	Page custom ProxyPageCreate ProxyPageLeave
	!insertmacro MUI_PAGE_INSTFILES
	Page custom FinishPageCreate
	
	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES

;======================================================
; Sections
Var pipPackageProxy
Var isProxyNeeded
Section "Install"	
	# Make sure the directory exists before the writing of Uninstaller. Otherwise, it may not write correctly!
	CreateDirectory "$INSTDIR"  
	
	# define uninstaller name
	WriteUninstaller "$INSTDIR\uninstall.exe"
	
	SetOutPath "$INSTDIR\python"
	SetOverwrite on
	File /nonfatal /r "InstallData\python\*.*"
	
	SetOutPath "$INSTDIR"
	SetOverwrite on
	File /nonfatal /r "InstallData\robot-framework-platform\*.*"
	
	# remove the pythonxx._pth file entirely, which reverts Python to behavior of the non-embeddable version.
	Delete "$INSTDIR\python\python38._pth"

    DetailPrint ""
	DetailPrint "Installing pip for Python"
	DetailPrint '"$INSTDIR\python\python.exe" "$INSTDIR\python\get-pip.py"'
    DetailPrint ""

	# install pip
	nsExec::ExecToLog '"$INSTDIR\python\python.exe" "$INSTDIR\python\get-pip.py"'

    DetailPrint ""
	DetailPrint "Installing needed packages for Python"

	# install your libraries. same as: pip install (modify this when requirements will be added for root folder)
	${If} $isProxyNeeded == 1
		DetailPrint '"$INSTDIR\python\Scripts\pip.exe" install --proxy "$pipPackageProxy" -r "$INSTDIR\polarion_synchronizer\requirements.txt"'
		DetailPrint ""
		nsExec::ExecToLog '"$INSTDIR\python\Scripts\pip.exe" install --proxy "$pipPackageProxy" -r "$INSTDIR\polarion_synchronizer\requirements.txt"'
	${Else}
        DetailPrint ""
		DetailPrint '"$INSTDIR\python\Scripts\pip.exe" install -r "$INSTDIR\polarion_synchronizer\requirements.txt"'
        DetailPrint ""
		nsExec::ExecToLog '"$INSTDIR\python\Scripts\pip.exe" install -r "$INSTDIR\polarion_synchronizer\requirements.txt"'
	${EndIf}
	  
	
SectionEnd

# create a section to define what the uninstaller does.
# the section will always be named "Uninstall"
Section "Uninstall"
	# Always delete uninstaller first
	Delete "$INSTDIR\uninstall.exe"
	 
	# Delete the directory recursively
	RMDir /r $INSTDIR
SectionEnd

;======================================================
; Functions

Var proxyTextInput	
Var proxyDesc
Var pipProxy

# Adding custom pages: https://nsis.sourceforge.io/Adding_custom_installer_pages
Function ProxyPageCreate
	nsDialogs::Create 1018
	Pop $0
	
	${NSD_CreateLabel} 0% 10u 100% 20u "Specify proxy for installing Python packages using pip. $\n!Note, that for FMC network proxy is required."
	Pop $proxyDesc
	
	${NSD_CreateText} 0% 70u 75% 12u "http://185.46.212.88:11223"
	Pop $proxyTextInput
	EnableWindow $proxyTextInput 0
	
	${NSD_CreateCheckbox} 0% 50u 100% 15u "Use proxy for dowloading Python packages"
	Pop $pipProxy
	${NSD_OnClick} $pipProxy EnableProxy

	nsDialogs::Show
FunctionEnd

Function ProxyPageLeave
${NSD_GetText} $proxyTextInput $pipPackageProxy ; Get text from $proxyTextInput and store
${NSD_GetState} $pipProxy $isProxyNeeded
FunctionEnd

# checkbox example is shown: https://nsis.sourceforge.io/Docs/nsDialogs/Readme.html#step-memory
Function EnableProxy
    Pop $pipProxy	
    ${NSD_GetState} $pipProxy $0
    ${If} $0 != 1
        ${NSD_SetText} $proxyTextInput ""
        EnableWindow $proxyTextInput 0
    ${Else}
        EnableWindow $proxyTextInput 1
    ${EndIf}
FunctionEnd


Var rfp_link
Var fr_user_guide
Var pageLinks
Var pageBody
Var pageTitle
Var title_font


Function WelcomePageCreate
  CreateFont $title_font "Microsoft Sans Serif" "15.75" "700"
  
  nsDialogs::Create 1018
  Pop $0
  
  ${NSD_CreateLabel} 8u 6u 280u 34u "Welcome to Robot-Framework Platform installation"
  Pop $pageTitle
  SendMessage $pageTitle ${WM_SETFONT} $title_font 0
  
  ${NSD_CreateLabel} 8u 46u 280u 30u "Setup wizard will install Robot-Framework platform on your computer. Local Python 3.8 will be installed with all needed packages into installation directory. "
  Pop $pageBody  
  
  ${NSD_CreateLabel} 8u 75u 280u 14u "For more detailed information, please refer to links below:"
  Pop $pageLinks
  
  ${NSD_CreateLink} 8u 103u 103u 14u "Robot Framework Platform"
  Pop $rfp_link
  ${NSD_OnClick} $rfp_link rfp_link_click
  
  ${NSD_CreateLink} 8u 89u 106u 14u "Robot Framework User Guide"
  Pop $fr_user_guide
  ${NSD_OnClick} $fr_user_guide fr_user_guide_click  
  nsDialogs::Show
FunctionEnd


Function FinishPageCreate
  CreateFont $title_font "Microsoft Sans Serif" "15.75" "700"
  
  nsDialogs::Create 1018
  Pop $0
  
  ${NSD_CreateLabel} 8u 6u 280u 34u "Robot-Framework Platform installation finished"
  Pop $pageTitle
  SendMessage $pageTitle ${WM_SETFONT} $title_font 0
  
  ${NSD_CreateLabel} 8u 46u 280u 30u "The Robot-Framework platform is ready to use."
  Pop $pageBody  
  
  ${NSD_CreateLabel} 8u 75u 280u 14u "For more information please click the link below:"
  Pop $pageLinks
  
  ${NSD_CreateLink} 8u 103u 103u 14u "Robot Framework Platform"
  Pop $rfp_link
  ${NSD_OnClick} $rfp_link rfp_link_click
  
  ${NSD_CreateLink} 8u 89u 106u 14u "Robot Framework User Guide"
  Pop $fr_user_guide
  ${NSD_OnClick} $fr_user_guide fr_user_guide_click  
  nsDialogs::Show
FunctionEnd

# on click of link open url: https://stackoverflow.com/a/11010817
Function rfp_link_click
    ExecShell "open" "http://www.google.com" 
FunctionEnd


Function fr_user_guide_click
    ExecShell "open" "http://www.google.com" 
FunctionEnd