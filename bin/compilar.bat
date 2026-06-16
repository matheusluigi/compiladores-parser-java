@echo off
REM ============================================================
REM compilar.bat - Gera e compila o compilador Java-- (Parser)
REM Passos (mesmos comandos da Aula 14):
REM   1) JCup  : gera parser.java e sym.java
REM   2) JFlex : gera Scanner.java
REM   3) javac : compila todos os .java
REM ============================================================
setlocal
REM Usa o Java do sistema se existir; senao usa o JDK portatil da pasta ..\jdk
set JAVA=..\jdk\jdk-17.0.19+10\bin\java.exe
set JAVAC=..\jdk\jdk-17.0.19+10\bin\javac.exe
where java  >nul 2>nul && set JAVA=java
where javac >nul 2>nul && set JAVAC=javac

echo [1/3] JCup  - gerando parser.java e sym.java ...
%JAVA% -jar java-cup-11b.jar Parser.cup

echo [2/3] JFlex - gerando Scanner.java ...
%JAVA% -jar jflex-full-1.9.1.jar Scanner.flex

echo [3/3] javac - compilando os arquivos .java ...
%JAVAC% -encoding UTF-8 -cp ".;java-cup-11b-runtime.jar" *.java

echo.
echo Concluido! Para executar:  executar.bat  (ou executar.bat entrada.txt)
pause
