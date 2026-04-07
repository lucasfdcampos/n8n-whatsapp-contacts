# Instalacao

Este guia foi pensado para uma pessoa comum conseguir instalar o projeto sem precisar entender n8n, Docker Compose ou variaveis de ambiente em profundidade.

## Ir direto para

- Se usa Windows, clique em [Instalacao no Windows](#instalacao-no-windows)
- Se usa Linux, clique em [Instalacao no Linux](#instalacao-no-linux)
- Se quer apenas acessar o n8n depois de instalar, clique em [Primeiro acesso ao n8n](#primeiro-acesso-ao-n8n)

## Antes de comecar

Voce precisa de:

- Docker Desktop instalado e aberto
- acesso a internet
- estes 3 dados do WhatsApp Business API:
  - `WHATSAPP_PHONE_NUMBER_ID`
  - `WHATSAPP_BUSINESS_ACCOUNT_ID`
  - `WHATSAPP_ACCESS_TOKEN`

## Baixar o projeto

Voce pode escolher uma das opcoes:

### Opcao A: baixar ZIP

1. Baixe o ZIP do repositório no GitHub
2. Extraia a pasta
3. Abra a pasta do projeto

### Opcao B: clonar com Git

```bash
git clone https://github.com/lucasfdcampos/n8n-whatsapp-contacts.git
cd n8n-whatsapp-contacts
```

## Instalacao no Windows

### Passo 1. Preparar a configuracao

Execute:

`setup.bat`

O que ele faz:

- verifica se o Docker existe no computador
- cria o arquivo `.env` se ele ainda nao existir
- abre o `.env` no Bloco de Notas

### Passo 2. Preencher o arquivo `.env`

No arquivo `.env`, preencha estes campos:

```env
WHATSAPP_PHONE_NUMBER_ID=
WHATSAPP_BUSINESS_ACCOUNT_ID=
WHATSAPP_ACCESS_TOKEN=
```

Voce tambem pode trocar, se quiser:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_PUBLIC_PORT`

### Passo 3. Iniciar o sistema

Execute:

`run.bat`

O que ele faz:

- valida se o `.env` existe
- valida se os 3 campos obrigatorios foram preenchidos
- inicia o Docker
- mostra o endereco, usuario e senha do n8n

### Passo 4. Parar o sistema

Execute:

`stop.bat`

## Instalacao no Linux

### Passo 1. Preparar a configuracao

No terminal, dentro da pasta do projeto:

```bash
chmod +x setup.sh run.sh stop.sh
./setup.sh
```

O script cria o `.env` se ele ainda nao existir.

### Passo 2. Preencher o arquivo `.env`

Abra o arquivo `.env` e preencha:

```env
WHATSAPP_PHONE_NUMBER_ID=
WHATSAPP_BUSINESS_ACCOUNT_ID=
WHATSAPP_ACCESS_TOKEN=
```

Voce tambem pode trocar, se quiser:

- `N8N_BASIC_AUTH_USER`
- `N8N_BASIC_AUTH_PASSWORD`
- `N8N_PUBLIC_PORT`

### Passo 3. Iniciar o sistema

```bash
./run.sh
```

O script valida o `.env` antes de iniciar o Docker.

### Passo 4. Parar o sistema

```bash
./stop.sh
```

## Alternativa para usuarios tecnicos no Linux

Se preferir `make`:

```bash
make setup
make up
```

## Primeiro acesso ao n8n

Depois de iniciar o ambiente:

1. Abra `http://localhost:5679`
2. Entre com o usuario e senha do `.env`
3. Importe o arquivo `workflows/WhatsApp-Contacts-Extractor-v3.json`
4. Clique em executar o workflow

## Onde ficam os arquivos gerados

Os arquivos exportados ficam em:

`output/`

Arquivos principais:

- `contatos_controle.json`
- `contatos_whatsapp_acumulado.csv`
- `contatos_whatsapp_acumulado.json`

## Se algo der errado

### Docker nao abre

- confirme se o Docker Desktop esta instalado
- confirme se ele esta aberto antes de executar os scripts

### O sistema nao inicia

- verifique se o arquivo `.env` existe
- confira se os 3 campos obrigatorios foram preenchidos

### Token invalido

- revise o valor de `WHATSAPP_ACCESS_TOKEN`
- gere um novo token no Meta for Developers se necessario

### Porta ocupada

Se `http://localhost:5679` nao abrir, altere `N8N_PUBLIC_PORT` no `.env`
