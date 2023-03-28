chcp 65001
@echo off

REM 設定環境變量
set VENV_NAME=zolo_venv
set PYTHON_EXE=python
set FOLDER_NAME=whl
set VENV_PATH=package.zip
set VENV_ID=1fPWyPXUjjAtv4O102O-FyH9aJqtk8G3o

set DEPTH_MODEL_ID=1frT2jhdzcRee2Dg_P2bk4vfbpHzGdWcq
set DEPTH_MODEL_PATH=hub\checkpoints\ZoeD_M12_N.pt

set YOLO_MODEL_ID_LK=1knO2a4j-qFWwZ7cbuNvDNnhQO0B5lz4f
set YOLO_MODEL_PATH_LK=models\LK-ENPD_72.pt

set YOLO_MODEL_ID_TC3-PPE=1knO2a4j-qFWwZ7cbuNvDNnhQO0B5lz4f
set YOLO_MODEL_PATH_TC3-PPE=models\TC3-PPE_Detector_v3.pt

set YOLO_MODEL_ID_TC3-WaterColor=1zCCyAGwqTOPBmu5hSb6KjOF9dDYFU5so
set YOLO_MODEL_PATH_TC3-WaterColor=models\TC3-WaterColor_v1.pt

REM 下載並安裝依賴包
if exist %VENV_NAME% (
    echo %VENV_NAME% 已存在。
) else (
    echo 正在下載 %VENV_PATH%...
    gdown https://drive.google.com/uc?id=%VENV_ID% -O %VENV_PATH%
    echo 下載完成。
    if not exist whl (
        mkdir whl
    )
    echo whl.zip 解壓到 whl 文件夾。
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "& {Expand-Archive -Force package.zip .}"
	REM 創建虛擬環境
	echo 正在創建虛擬環境：%VENV_NAME%
	%PYTHON_EXE% -m venv %VENV_NAME%

	echo 虛擬環境創建成功。

	call %VENV_NAME%\Scripts\activate
	pip install gdown
    echo 安裝相依套件
    pip install --no-index --find-links ./whl -r requirements.txt
)

REM 下載模型
if not exist models (
    mkdir models
)

if exist %YOLO_MODEL_PATH_TC3-WaterColor% (
    echo %YOLO_MODEL_PATH_TC3-WaterColor% 已存在。
) else (
    echo 正在下載 %YOLO_MODEL_PATH_TC3-WaterColor% ...
    gdown https://drive.google.com/uc?id=%YOLO_MODEL_ID_TC3-WaterColor% -O %YOLO_MODEL_PATH_TC3-WaterColor%
    echo 下載完成。
)

if exist %YOLO_MODEL_PATH_LK% (
    echo %YOLO_MODEL_PATH_LK% 已存在。
) else (
    echo 正在下載 %YOLO_MODEL_PATH_LK% ...
    gdown https://drive.google.com/uc?id=%YOLO_MODEL_ID_LK% -O %YOLO_MODEL_PATH_LK%
    echo 下載完成。
)

if exist %YOLO_MODEL_PATH_TC3-PPE% (
    echo %YOLO_MODEL_PATH_TC3-PPE% 已存在。
) else (
    echo 正在下載 %YOLO_MODEL_PATH_TC3-PPE% ...
    gdown https://drive.google.com/uc?id=%YOLO_MODEL_ID_TC3-PPE% -O %YOLO_MODEL_PATH_TC3-PPE%
    echo 下載完成。
)

if not exist hub\checkpoints (
    mkdir hub\checkpoints
)

REM 下載深度模型
if exist %DEPTH_MODEL_PATH% (
    echo %DEPTH_MODEL_PATH% 已存在。
) else (
    echo 正在下載 DEPTH MODEL ...
    gdown https://drive.google.com/uc?id=%DEPTH_MODEL_ID% -O %DEPTH_MODEL_PATH%
    echo 下載完成。
)

echo 自動移除安裝檔案
if exist %VENV_PATH% (
    echo Removing %VENV_PATH%...
    del %VENV_PATH%
    echo %VENV_PATH% removed.
) 
if exist %FOLDER_NAME% (
    echo Removing %FOLDER_NAME%...
    rd /s /q %FOLDER_NAME%
    echo %FOLDER_NAME% removed successfully.
) 

echo 安裝完成.
pause