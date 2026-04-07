@echo off
setlocal

if not exist ".env" (
  copy ".env.example" ".env" >nul
  echo Arquivo .env criado com base em .env.example
  echo.
  echo Preencha o arquivo .env com:
  echo - WHATSAPP_PHONE_NUMBER_ID
  echo - WHATSAPP_BUSINESS_ACCOUNT_ID
  echo - WHATSAPP_ACCESS_TOKEN
  echo.
  echo Depois execute este arquivo novamente.
  pause
  exit /b 0
)

docker compose up -d --build
if errorlevel 1 (
  echo Falha ao subir o Docker.
  pause
  exit /b 1
)

echo.
echo Ambiente iniciado com sucesso.
echo Acesse: http://localhost:5679
echo Usuario: admin
echo Senha: admin123
echo.
echo Importe o arquivo workflows\WhatsApp-Contacts-Extractor-v3.json no n8n.
pause
