@echo off
setlocal
cd /d "%~dp0"
echo Starting Sewing Line AI Operator Allocation from:
echo %CD%
python -m pip install -r requirements.txt
if errorlevel 1 (
  echo Failed to install requirements. Check Python and internet connection.
  pause
  exit /b 1
)
python -m streamlit run app.py
if errorlevel 1 pause
