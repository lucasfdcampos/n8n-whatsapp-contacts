FROM n8nio/n8n:latest

# Mudar para root para instalar pacotes
USER root

# Instalar Python e ferramentas necessárias (Alpine Linux)
RUN apk add --no-cache \
    python3 \
    py3-pip \
    jq

# Instalar bibliotecas Python para processar dados
RUN pip3 install --break-system-packages --no-cache-dir \
    pandas \
    openpyxl

# Criar diretório de saída
RUN mkdir -p /output && chown node:node /output

# Voltar para o usuário node (segurança)
USER node