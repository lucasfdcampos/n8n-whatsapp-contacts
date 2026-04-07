# Instalacao Rapida

## O que voce precisa

- Docker Desktop instalado
- Internet
- Seus dados do WhatsApp Business API:
  - `WHATSAPP_PHONE_NUMBER_ID`
  - `WHATSAPP_BUSINESS_ACCOUNT_ID`
  - `WHATSAPP_ACCESS_TOKEN`

## Opcao 1: baixar o projeto

### Via Git

```bash
git clone https://github.com/lucasfdcampos/n8n-whatsapp-contacts.git
cd n8n-whatsapp-contacts
```

### Via ZIP

1. Baixe o ZIP do repositório no GitHub
2. Extraia a pasta
3. Abra a pasta extraida

## Linux

### 1. Criar o arquivo `.env`

```bash
make setup
```

Isso cria o arquivo `.env` automaticamente com base no `.env.example`.

### 2. Preencher seus dados

Abra o arquivo `.env` e preencha:

```env
WHATSAPP_PHONE_NUMBER_ID=
WHATSAPP_BUSINESS_ACCOUNT_ID=
WHATSAPP_ACCESS_TOKEN=
```

### 3. Subir o sistema

```bash
make up
```

O comando valida se os campos obrigatorios do `.env` foram preenchidos antes de iniciar o Docker.

### 4. Abrir o n8n

Acesse:

`http://localhost:5679`

Login padrao:

- usuario: `admin`
- senha: `admin123`

### 5. Importar o workflow

Importe este arquivo no n8n:

`workflows/WhatsApp-Contacts-Extractor-v3.json`

## Windows

### 1. Criar o arquivo `.env`

Clique duas vezes em:

`start.bat`

Na primeira execucao, ele cria o arquivo `.env` automaticamente e pede para voce preencher os dados.
Se o `.env` estiver incompleto, ele abre o arquivo no Bloco de Notas e nao tenta subir o Docker antes da hora.

### 2. Preencher seus dados

Abra o arquivo `.env` no Bloco de Notas e preencha:

```env
WHATSAPP_PHONE_NUMBER_ID=
WHATSAPP_BUSINESS_ACCOUNT_ID=
WHATSAPP_ACCESS_TOKEN=
```

### 3. Subir o sistema

Clique novamente em:

`start.bat`

### 4. Parar o sistema

Clique em:

`stop.bat`

## Onde ficam os arquivos gerados

Os arquivos exportados ficam em:

`output/`

Arquivos principais:

- `contatos_controle.json`
- `contatos_whatsapp_acumulado.csv`
- `contatos_whatsapp_acumulado.json`

## Observacoes

- O arquivo `.env` nao sobe para o GitHub
- O `docker compose` usa esse `.env` para configurar o container e tambem para valores como porta e login do n8n
- Os modulos `fs` e `path` ja estao liberados para os nos `Code` do n8n

## Solucao de problemas

### Docker nao abre

Verifique se o Docker Desktop esta aberto antes de executar os scripts.

### Porta ocupada

Se `http://localhost:5679` nao abrir, pode haver outro servico usando essa porta.

### Token invalido

Revise o valor de `WHATSAPP_ACCESS_TOKEN` no `.env`
