@echo off
cd /d "%~dp0"
echo DuckDB UI is running in your browser. Close this window to stop it.
"%LOCALAPPDATA%\Microsoft\WinGet\Packages\DuckDB.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\duckdb.exe" -ui shop.duckdb
