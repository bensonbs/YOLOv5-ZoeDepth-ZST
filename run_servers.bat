@echo off
if not defined VENV_DIR (set "VENV_DIR=%~dp0%zolo_venv")
set PYTHON="%VENV_DIR%\Scripts\Python.exe"
echo venv %PYTHON%
python servers.py
pause