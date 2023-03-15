@echo off

set VENV_NAME=zolo_venv
set PYTHON_EXE=python
set FOLDER_NAME=whl
set VENV_PATH=package.zip
set VENV_ID=1fPWyPXUjjAtv4O102O-FyH9aJqtk8G3o
set DEPTH_MODEL_ID=1frT2jhdzcRee2Dg_P2bk4vfbpHzGdWcq
set DEPTH_MODEL_PATH=hub\checkpoints\ZoeD_M12_N.pt

echo Creating virtual environment: %VENV_NAME% with Python: %PYTHON_EXE%
%PYTHON_EXE% -m venv %VENV_NAME%

echo Virtual environment created successfully.

call %VENV_NAME%\Scripts\activate
pip install gdown

if not exist hub\checkpoints (
    mkdir hub\checkpoints
)

if exist %DEPTH_MODEL_PATH% (
    echo %DEPTH_MODEL_PATH% already exists.
) else (
    echo Downloading DEPTH MODEL ...
    gdown https://drive.google.com/uc?id=%DEPTH_MODEL_ID% -O %DEPTH_MODEL_PATH%
    echo Download complete.
)

if exist %VENV_PATH% (
    echo %VENV_PATH% already exists.
) else (
    echo Downloading %VENV_PATH%...
    gdown https://drive.google.com/uc?id=%VENV_ID% -O %VENV_PATH%
    echo Download complete.
)

if not exist whl (
    mkdir whl
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Expand-Archive -Force package.zip .}"

echo whl.zip has been unzipped to the whl folder.

pip install --no-index --find-links ./whl -r requirements.txt

echo finish.
pause

if exist %VENV_PATH% (
    echo Removing %VENV_PATH%...
    del %VENV_PATH%
    echo %VENV_PATH% removed.
) else (
    echo %VENV_PATH% does not exist.
)
if exist %FOLDER_NAME% (
    echo Removing %FOLDER_NAME%...
    rd /s /q %FOLDER_NAME%
    echo %FOLDER_NAME% removed successfully.
) else (
    echo %FOLDER_NAME% not found.
)
