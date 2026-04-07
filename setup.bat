@echo off
setlocal

where docker >nul 2>nul
if errorlevel 1 (
  echo Docker nao foi encontrado neste computador.
  echo Instale o Docker Desktop e abra o programa antes de continuar.
  pause
  exit /b 1
)

if exist ".env" (
  echo O arquivo .env ja existe.
  echo Se quiser refazer a configuracao, edite o arquivo manualmente.
  start notepad ".env"
  pause
  exit /b 0
)

copy ".env.example" ".env" >nul
echo Arquivo .env criado com base em .env.example
echo.
echo Agora preencha os 3 campos obrigatorios:
echo - WHATSAPP_PHONE_NUMBER_ID
echo - WHATSAPP_BUSINESS_ACCOUNT_ID
echo - WHATSAPP_ACCESS_TOKEN
echo.
start notepad ".env"
pause
