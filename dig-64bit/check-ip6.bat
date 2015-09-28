@echo off & title  π”√dig≤È—Øπ»∏ËIP - 1Pv6
cd %~dp0

:check
echo.
set /p i= input ip:
dig +subnet=%i% @ns1.google.com aaaa www.google.com
call :check