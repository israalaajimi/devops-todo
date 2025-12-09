@echo off
SET HOST=%1
IF "%HOST%"=="" SET HOST=http://localhost:3001

curl -s -o NUL -w "%%{http_code}" %HOST%/health > tmp.txt
SET /P HTTP_CODE=<tmp.txt
DEL tmp.txt

IF "%HTTP_CODE%"=="200" (
    echo SMOKE PASSED (%HTTP_CODE%)
    exit /b 0
) ELSE (
    echo SMOKE FAILED (HTTP %HTTP_CODE%)
    exit /b 1
)
