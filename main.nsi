# name the installer
OutFile "RFPlatformInstaller.exe"

# Create a default section
Section

!define InstallDirPath "$DESKTOP\ENV_PYTHON37_X64"
!define PythonPathFile "${InstallDirPath}\python38._pth"
!define EnvScriptsPath "${InstallDirPath}\Scripts"

# create a popup box, with an OK button and some text
# TODO: Uncomment
# MessageBox MB_OK "Install python to ${InstallDirPath}!"

CreateDirectory "${InstallDirPath}"  # Make sure the directory exists before the writing of Uninstaller. Otherwise, it may not write correctly!
SetOutPath "${InstallDirPath}"
SetOverwrite on
File /nonfatal /r "InstallData\*.*"

SetOutPath "${InstallDirPath}\temp"
SetOverwrite on
File /nonfatal /r "SitePackages\*.*"

# Update local python installation path settings so it can find locally installed packages
nsExec::ExecToStack 'powershell -Command "& {(Get-content ${PythonPathFile}) | Foreach-Object {$$_ -replace \$\"^#import site$$\$\", \"import site\"} | Set-Content ${PythonPathFile}}"'
nsExec::ExecToStack '"${InstallDirPath}\python.exe" "${InstallDirPath}\get-pip.py"'  # install pip
nsExec::ExecToStack '"${InstallDirPath}\Scripts\pip.exe" install -r "${InstallDirPath}\temp\requirements.txt"'  # install you library. same as: `pip install .`
# RMDir /r "${InstallDirPath}\temp"  # remove source folder.

# create a popup box, with an OK button and some text
# TODO: Uncomment
# MessageBox MB_OK "Finished!"

# TODO: add uninstaller

SectionEnd
