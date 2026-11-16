@echo off
rem Double-click de tai + giai nen game GamiQ (goi download-windows.ps1 cung thu muc)
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0download-windows.ps1" %*
