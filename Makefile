SHELL := /bin/bash

.PHONY: help setup check-env up down restart logs status import-workflow reset-output

help:
	@echo "Comandos disponiveis:"
	@echo "  make setup         - cria o arquivo .env a partir do .env.example"
	@echo "  make check-env     - valida se o .env foi preenchido"
	@echo "  make up            - sobe o ambiente com Docker"
	@echo "  make down          - para o ambiente"
	@echo "  make restart       - reinicia o ambiente"
	@echo "  make logs          - mostra os logs do n8n"
	@echo "  make status        - mostra o status dos containers"
	@echo "  make import-workflow - mostra onde importar o workflow"
	@echo "  make reset-output  - limpa os arquivos gerados em ./output"

setup:
	@if [ -f .env ]; then \
		echo "Arquivo .env ja existe. Nenhuma alteracao foi feita."; \
	else \
		cp .env.example .env; \
		echo "Arquivo .env criado com base em .env.example"; \
		echo "Agora edite o arquivo .env e preencha seus dados do WhatsApp."; \
	fi

check-env:
	@if [ ! -f .env ]; then \
		echo "Arquivo .env nao encontrado."; \
		echo "Execute: make setup"; \
		exit 1; \
	fi
	@if ! grep -Eq '^WHATSAPP_PHONE_NUMBER_ID=.+$$' .env; then \
		echo "Preencha WHATSAPP_PHONE_NUMBER_ID no arquivo .env"; \
		exit 1; \
	fi
	@if ! grep -Eq '^WHATSAPP_BUSINESS_ACCOUNT_ID=.+$$' .env; then \
		echo "Preencha WHATSAPP_BUSINESS_ACCOUNT_ID no arquivo .env"; \
		exit 1; \
	fi
	@if ! grep -Eq '^WHATSAPP_ACCESS_TOKEN=.+$$' .env; then \
		echo "Preencha WHATSAPP_ACCESS_TOKEN no arquivo .env"; \
		exit 1; \
	fi
	@echo ".env validado com sucesso."

up: check-env
	@docker compose up -d --build
	@echo "n8n iniciado em http://localhost:5679"

down:
	@docker compose down

restart: check-env
	@docker compose down
	@docker compose up -d --build

logs:
	@docker compose logs -f n8n

status:
	@docker compose ps

import-workflow:
	@echo "Importe o arquivo workflows/WhatsApp-Contacts-Extractor-v3.json no n8n."

reset-output:
	@mkdir -p output
	@find output -maxdepth 1 -type f \( -name '*.json' -o -name '*.csv' \) -delete
	@echo "Arquivos gerados em ./output foram removidos."
