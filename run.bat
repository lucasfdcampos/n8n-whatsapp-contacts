@echo off
setlocal

where docker >nul 2>nul
if errorlevel 1 (
  echo Docker nao foi encontrado neste computador.
  echo Instale o Docker Desktop e abra o programa antes de continuar.
  pause
  exit /b 1
)

if not exist ".env" (
  echo O arquivo .env nao existe.
  echo Execute primeiro: setup.bat
  pause
  exit /b 1
)

set "WHATSAPP_PHONE_NUMBER_ID="
set "WHATSAPP_BUSINESS_ACCOUNT_ID="
set "WHATSAPP_ACCESS_TOKEN="
set "N8N_PUBLIC_PORT=5679"
set "N8N_BASIC_AUTH_USER=admin"
set "N8N_BASIC_AUTH_PASSWORD=admin123"

for /f "usebackq tokens=1,* delims==" %%A in (".env") do (
  if /I "%%A"=="WHATSAPP_PHONE_NUMBER_ID" set "WHATSAPP_PHONE_NUMBER_ID=%%B"
  if /I "%%A"=="WHATSAPP_BUSINESS_ACCOUNT_ID" set "WHATSAPP_BUSINESS_ACCOUNT_ID=%%B"
  if /I "%%A"=="WHATSAPP_ACCESS_TOKEN" set "WHATSAPP_ACCESS_TOKEN=%%B"
  if /I "%%A"=="N8N_PUBLIC_PORT" set "N8N_PUBLIC_PORT=%%B"
  if /I "%%A"=="N8N_BASIC_AUTH_USER" set "N8N_BASIC_AUTH_USER=%%B"
  if /I "%%A"=="N8N_BASIC_AUTH_PASSWORD" set "N8N_BASIC_AUTH_PASSWORD=%%B"
)

if "%WHATSAPP_PHONE_NUMBER_ID%"=="" goto env_missing
if "%WHATSAPP_BUSINESS_ACCOUNT_ID%"=="" goto env_missing
if "%WHATSAPP_ACCESS_TOKEN%"=="" goto env_missing

docker compose up -d --build
if errorlevel 1 (
  echo Falha ao iniciar o ambiente.
  echo Verifique se o Docker Desktop esta aberto.
  pause
  exit /b 1
)

echo.
echo Ambiente iniciado com sucesso.
echo Acesse: http://localhost:%N8N_PUBLIC_PORT%
echo Usuario: %N8N_BASIC_AUTH_USER%
echo Senha: %N8N_BASIC_AUTH_PASSWORD%
echo.
echo Depois, no n8n, importe o arquivo:
echo workflows\WhatsApp-Contacts-Extractor-v3.json
pause
exit /b 0

:env_missing
echo O arquivo .env ainda nao foi preenchido completamente.
echo.
echo Preencha estes campos:
echo - WHATSAPP_PHONE_NUMBER_ID
echo - WHATSAPP_BUSINESS_ACCOUNT_ID
echo - WHATSAPP_ACCESS_TOKEN
echo.
start notepad ".env"
pause
exit /b 1
