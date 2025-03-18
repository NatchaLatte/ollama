@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

REM Configuration
SET "MODEL=deepseek-r1:32b"
SET "MAX_RETRIES=5"
SET "COOLDOWN=5"
SET /A "RETRY_COUNT=0"

:retry
ECHO Attempt !RETRY_COUNT!: Pulling !MODEL!...
ollama pull "!MODEL!"

IF !ERRORLEVEL! NEQ 0 (
    SET /A "RETRY_COUNT+=1"
    IF !RETRY_COUNT! GEQ !MAX_RETRIES! (
        ECHO Maximum retries reached. Exiting...
        EXIT /B 1
    )
    
    ECHO Failed. Retrying in !COOLDOWN! seconds...
    FOR /L %%I IN (!COOLDOWN!,-1,1) DO (
        ECHO %%I...
        TIMEOUT /T 1 /NOBREAK >NUL
    )
    GOTO retry
)

ECHO Pull !MODEL! successful!
PAUSE
ENDLOCAL