This repo follows the following stackoverflow comment: https://stackoverflow.com/a/60879297

1. Make sure you have [nsis](https://nsis.sourceforge.io/Download) installed
2. Load the script into the compiler and an installer will be produced


# NOTE:
Make sure you have the following files inside InstallData:
*   Extracted [embeddable python](https://www.python.org/ftp/python/3.8.10/python-3.8.10-embed-amd64.zip)
*   [get-pip.py](https://bootstrap.pypa.io/get-pip.py)

# TODOs:
1   Add uninstaller (Delete all data in install dir)
2   Get install dir from user
3   Copy robotframework platform contents to $INSTALL\_DIR and python installation to $INSTALL\_DIR/.python
