#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker nao foi encontrado neste computador."
  echo "Instale o Docker Desktop ou Docker Engine antes de continuar."
  exit 1
fi

if [[ ! -f .env ]]; then
  echo "O arquivo .env nao existe."
  echo "Execute primeiro: ./setup.sh"
  exit 1
fi

required_vars=(
  WHATSAPP_PHONE_NUMBER_ID
  WHATSAPP_BUSINESS_ACCOUNT_ID
  WHATSAPP_ACCESS_TOKEN
)

for var_name in "${required_vars[@]}"; do
  if ! grep -Eq "^${var_name}=.+$" .env; then
    echo "Preencha ${var_name} no arquivo .env antes de iniciar."
    exit 1
  fi
done

docker compose up -d --build

port="$(grep -E '^N8N_PUBLIC_PORT=' .env | head -n1 | cut -d= -f2-)"
user="$(grep -E '^N8N_BASIC_AUTH_USER=' .env | head -n1 | cut -d= -f2-)"
password="$(grep -E '^N8N_BASIC_AUTH_PASSWORD=' .env | head -n1 | cut -d= -f2-)"

port="${port:-5679}"
user="${user:-admin}"
password="${password:-admin123}"

echo
echo "Ambiente iniciado com sucesso."
echo "Acesse: http://localhost:${port}"
echo "Usuario: ${user}"
echo "Senha: ${password}"
echo
echo "Depois, no n8n, importe o arquivo:"
echo "workflows/WhatsApp-Contacts-Extractor-v3.json"
