#!/usr/bin/env bash
set -euo pipefail

if ! command -v docker >/dev/null 2>&1; then
  echo "Docker nao foi encontrado neste computador."
  echo "Instale o Docker Desktop ou Docker Engine antes de continuar."
  exit 1
fi

if [[ -f .env ]]; then
  echo "O arquivo .env ja existe."
  echo "Se quiser refazer a configuracao, edite o arquivo manualmente."
  exit 0
fi

cp .env.example .env
echo "Arquivo .env criado com base em .env.example"
echo
echo "Agora edite o arquivo .env e preencha os 3 campos obrigatorios:"
echo "- WHATSAPP_PHONE_NUMBER_ID"
echo "- WHATSAPP_BUSINESS_ACCOUNT_ID"
echo "- WHATSAPP_ACCESS_TOKEN"
