This repo follows the following stackoverflow comment: https://stackoverflow.com/a/60879297

1. Make sure you have [nsis](https://nsis.sourceforge.io/Download) installed
2. Load the script into the compiler and an installer will be produced


# NOTE:
Make sure you have the following files inside InstallData:
* Extracted [embeddable python](https://www.python.org/ftp/python/3.8.10/python-3.8.10-embed-amd64.zip) to InstallData\python directory.
* Store [get-pip.py](https://bootstrap.pypa.io/get-pip.py) script in InstallData\python directory.
* Clone\download "Robot Framework Platform" repo into InstallData\robot-framework-platform directory.

# TODOs:
1. Set up installer building on Azure pipelines.
