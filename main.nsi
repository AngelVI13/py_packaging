;======================================================
; Include
 
  !include "MUI2.nsh"
	
;======================================================
; Installer Information
	# name the installer
	OutFile "RFPlatformInstaller.exe"

;======================================================
; MUI settings

	!define MUI_WELCOMEPAGE_TITLE "Welcome to Robot-Framework platform installation."
	!define MUI_WELCOMEPAGE_TEXT "Here will appear text regarding what will be installed."
	!define MUI_FINISHPAGE_TITLE "Installation finished"
	!define MUI_FINISHPAGE_TEXT "Some information abount installation."
	
;======================================================
; Pages
 
	!insertmacro MUI_PAGE_WELCOME
	!insertmacro MUI_PAGE_DIRECTORY
	!insertmacro MUI_PAGE_INSTFILES
	!insertmacro MUI_PAGE_FINISH
	
	!insertmacro MUI_UNPAGE_CONFIRM
	!insertmacro MUI_UNPAGE_INSTFILES

	
;======================================================
; Sections

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
	
	# install pip
	nsExec::ExecToStack '"$INSTDIR\python\python.exe" "$INSTDIR\python\get-pip.py"'  
	# install your libraries. same as: pip install (modify this when requirements will be added for root folder)
	nsExec::ExecToStack '"$INSTDIR\python\Scripts\pip.exe" install -r "$INSTDIR\polarion_synchronizer\requirements.txt"'  
	
SectionEnd



# create a section to define what the uninstaller does.
# the section will always be named "Uninstall"
Section "Uninstall"
	# Always delete uninstaller first
	Delete "$INSTDIR\uninstall.exe"
	 
	# Delete the directory recursively
	RMDir /r $INSTDIR
SectionEnd