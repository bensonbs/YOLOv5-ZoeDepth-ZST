@echo off
set VENV_NAME=zolo_venv
if not defined VENV_DIR (set "VENV_DIR=%~dp0%zolo_venv")
set PYTHON="%VENV_DIR%\Scripts\Python.exe"
echo venv %PYTHON%
call %VENV_NAME%\Scripts\activate
python servers.py
pause