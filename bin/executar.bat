@echo off
REM ============================================================
REM executar.bat - Roda o compilador sobre um arquivo de entrada
REM Uso:  executar.bat              (usa entrada.txt)
REM       executar.bat entrada_erro.txt
REM ============================================================
setlocal
set JAVA=..\jdk\jdk-17.0.19+10\bin\java.exe
where java >nul 2>nul && set JAVA=java

set ARQ=%1
if "%ARQ%"=="" set ARQ=entrada.txt

%JAVA% -cp ".;java-cup-11b-runtime.jar" Main %ARQ%
pause
