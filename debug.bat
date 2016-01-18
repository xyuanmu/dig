@echo off

if exist "%windir%\sysWOW64\" ( set sys=64bit) else set sys=32bit
echo.Your system is %sys%

if exist "%~dp0dig.log" (
cls
echo.
echo.There is exist dig.log, would you like to extract IP from dig.log or get a new one?
echo.
echo.1. Extract IP from dig.log		2. Get a new dig.log
echo.
choice /c 12 /n /m "Please make a choice: "
if errorlevel 2 (
goto :main
)
if errorlevel 1 (
goto :ExtractIP
)
)
goto :main

:dig
if exist "%~dp0dig.log" (for /f %%a in ('dir/b dig.*log') do set/a num+=1)
rename dig.log dig.%num%.log >nul 2>nul
echo.
echo Get ip.txt, begin dig IP.
for /f "delims=" %%i in (ip.txt) do echo dig ip %%i & %~dp0/dig-%sys%/dig +subnet=%%i @ns1.google.com www.google.com>> dig.log 2>> nul
echo Finished dig!
goto :ExtractIP

:main
if exist "%~dp0ip.txt" (
goto :dig
) else (
if exist "%~dp0html.txt" (
findstr "<h3>Nameserver \d+\.\d+\.\d+\.\d+ Details:</h3>" html.txt > ip-0.txt
) else (
if defined url (
%~dp0tool/wget.exe %url% -O html.txt
findstr "<h3>Nameserver \d+\.\d+\.\d+\.\d+ Details:</h3>" html.txt > ip-0.txt
) else goto :seturl
)

del ip.txt>nul 2>nul
for /f "tokens=2" %%i in (ip-0.txt) do (
echo %%i>>ip.txt
)
del ip-0.txt html.txt>nul 2>nul
if exist "%~dp0ip.txt" (goto :dig) else echo Something went wrong! & goto :exit
)

:ExtractIP
echo.
echo Extract IP from dig.log, please wait a second...
del ip_range-0.txt >nul 2>nul
findstr /b "www\.google\.com\.		\d+\IN	A	\d+\.\d+\.\d+\.\d+" dig.log > ip_range-0.txt
del ip_range-1.txt >nul 2>nul
for /f "tokens=5" %%i in (ip_range-0.txt) do (
echo %%i>>ip_range-1.txt
)
for /f "delims=. tokens=1-3" %%i in (ip_range-1.txt) do (
echo %%i.%%j.%%k.0/24>>ip_range-2.txt
)
del ip_range-0.txt ip_range-1.txt >nul 2>nul
if exist "%~dp0ip_range.txt" (for /f %%a in ('dir/b ip_range.*txt') do set/a num+=1)
rename ip_range.txt ip_range.%num%.txt >nul 2>nul
for /f "delims=" %%i in (ip_range-2.txt) do (
if not defined %%i set %%i=A & echo %%i>>ip_range.txt
)
del ip_range-2.txt >nul 2>nul
goto :exit

:seturl
cls
set /p url="please input a url, support bestdns.org only: "
goto :main

:exit
pause
exit