@echo off
set PGPASSFILE=%PG_DATA%\pgpass.conf
set PGUSER=postgres
set DBname=test

rem curl "https://www.indeed.nl/python" -o "c:\temp2\pythonvacature.txt"
rem PowerShell -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\live_vacature\_zoekscript.ps1'"

"%PG_PROG%\bin\psql.exe" -X -q -1 -d %DBname% -U %PGUSER% -w -c "select main.buildzoekscript()"

call "C:\live_vacature\_zoekscript.bat"

"%PG_PROG%\bin\psql.exe" -X -q -1 -d %DBname% -U %PGUSER% -w -c "select main.getdata()"
