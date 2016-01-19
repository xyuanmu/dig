@echo off
setlocal EnableDelayedExpansion
if exist "%windir%\sysWOW64\" (set sys=64bit) else set sys=32bit
::echo.Your system is %sys%

if exist "%~dp0ip.txt" (
cls
echo.
echo.There is exist ip.txt, would you like to dig IP from ip.txt or get a new one?
echo.
echo.1. dig IP from ip.txt		2. Get a new ip.txt
echo.
choice /c 12 /n /m "Please make a choice: "
if errorlevel 2 (
goto :getip
)
if errorlevel 1 (
goto :dig
)
)
goto :getip

:dig
::if exist "%~dp0dig.log" (set num=0 & for /f %%a in ('dir/b dig.*log') do set/a num+=1)
::rename dig.log dig.%num%.log >nul 2>nul
echo.
echo Get ip.txt, begin dig IP.
for /f "delims=" %%i in (ip.txt) do (
set /a n+=1
set !n!=%%i
echo dig !n! ip: %%i
%~dp0/dig-%sys%/dig +subnet=%%i @ns1.google.com www.google.com>> dig.log 2>> nul
)
echo dig finished^^!
goto :ExtractIP

:getip
if exist "%~dp0html.txt" (
findstr "<h3>Nameserver \d+\.\d+\.\d+\.\d+ Details:</h3>" html.txt > ip-0.txt
) else (
if defined url (
%~dp0tool/wget.exe %url% -O html.txt
findstr "<h3>Nameserver \d+\.\d+\.\d+\.\d+ Details:</h3>" html.txt > ip-0.txt
) else goto :seturl
)

del ip.txt>nul 2>nul
for /f "tokens=2" %%i in (ip-0.txt) do echo %%i>> ip.txt
del ip-0.txt html.txt>nul 2>nul
if exist "%~dp0ip.txt" (goto :dig) else echo Something went wrong^^! & goto :exit

:ExtractIP
echo.
echo Extract IP from dig.log, please wait a second...
del ip_range-0.txt >nul 2>nul
for /f "tokens=5" %%a in ('findstr /b "www\.google\.com\.		\d+\IN	A	\d+\.\d+\.\d+\.\d+" dig.log') do (
for /f "delims=. tokens=1-3" %%b in ("%%a") do (
echo %%b.%%c.%%d.0/24>> ip_range-0.txt
)
)
if exist "%~dp0ip_range.txt" (
for /f %%i in (ip_range.txt) do (
echo %%i>> ip_range-0.txt
)
)
del ip_range.txt >nul 2>nul
for /f "delims=" %%i in (ip_range-0.txt) do (
if not defined %%i set %%i=A & echo %%i>>ip_range.txt
)
del ip_range-0.txt >nul 2>nul
goto :exit

:seturl
cls
set /p url="please input a url, support bestdns.org only: "
goto :getip

:exit
pause
exit