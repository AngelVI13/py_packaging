!define InstallDirPath "$PROGRAMFILES\ENV_PYTHON37_X64"
!define EnvScriptsPath "${InstallDirPath}\Scripts"

CreateDirectory "${InstallDirPath}"  # Make sure the directory exists before the writing of Uninstaller. Otherwise, it may not write correctly!
SetOutPath "${InstallDirPath}"
SetOverwrite on
File /nonfatal /r "InstallData\*.*"

SetOutPath "${InstallDirPath}\temp"
SetOverwrite on
File /nonfatal /r "SitePackages\*.*"
nsExec::ExecToStack '"${InstallDirPath}\python.exe" "${InstallDirPath}\get-pip.py"'  # install pip
nsExec::ExecToStack '"${InstallDirPath}\Scripts\pip.exe" install -r "${InstallDirPath}\temp\requirements.txt"'  # install you library. same as: `pip install .`
# RMDir /r "${InstallDirPath}\temp"  # remove source folder.
