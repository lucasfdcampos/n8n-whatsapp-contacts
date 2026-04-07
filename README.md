# WhatsApp Business - Extrator de Contatos (Incremental)

Sistema n8n para extrair contatos do WhatsApp Business API de forma incremental. O projeto foi preparado para que outra pessoa consiga usar com poucos passos: criar o `.env`, subir o Docker e importar o workflow.

## Instalacao Rapida

Guia simples para usuario final:

- Linux: use `make setup`, edite o `.env` e depois `make up`
- Windows: execute `start.bat`; ele cria e valida o `.env` antes de subir
- Passo a passo completo: veja `INSTALACAO.md`

## Como Funciona

```
┌─────────────────────────────────────────────────────────────┐
│                     EXECUÇÃO                                │
├─────────────────────────────────────────────────────────────┤
│  1. Carrega arquivo de controle (contatos já salvos)        │
│  2. Busca TODAS as conversas (até 50 páginas = 5000)        │
│  3. Compara números com os já conhecidos                    │
│  4. Adiciona apenas NOVOS contatos                          │
│  5. Atualiza dados de contatos existentes (última msg)      │
│  6. Salva tudo para a próxima execução                      │
└─────────────────────────────────────────────────────────────┘
```

## Arquivos Gerados

```
/output/
├── contatos_controle.json           # Estado interno (NÃO apagar!)
├── contatos_whatsapp_acumulado.csv   # CSV completo (Excel)
├── contatos_whatsapp_acumulado.json   # Backup JSON completo
└── contatos_whatsapp_novos_2026-04-06.json  # Apenas novos desta execução
```

## Configuração

### 1. Credenciais do WhatsApp Business

```bash
# O arquivo .env pode ser criado automaticamente a partir do .env.example
WHATSAPP_PHONE_NUMBER_ID=seu_phone_number_id
WHATSAPP_BUSINESS_ACCOUNT_ID=seu_business_account_id
WHATSAPP_ACCESS_TOKEN=seu_access_token
```

**Obter credenciais (gratuito):**
1. Acesse https://developers.facebook.com/apps/
2. Crie um app "Business"
3. Adicione WhatsApp Business API
4. Copie Phone Number ID, Business Account ID
5. Gere um Access Token em API Setup

### 2. Iniciar n8n

```bash
make setup
make up
```

Acesse: http://localhost:5679 (login: `admin`, senha: `admin123`)

No Windows, `start.bat` cria o `.env` se necessario, abre o arquivo para edicao e so sobe o Docker quando os campos obrigatorios estiverem preenchidos.

### 3. Importar Workflow

Importe o arquivo `workflows/WhatsApp-Contacts-Extractor-v3.json`

### 4. Observação Importante

O `docker-compose.yml` já libera os módulos `fs` e `path` para os nós `Code` do n8n via `NODE_FUNCTION_ALLOW_BUILTIN=fs,path`.

Também não é mais necessário criar credencial manual no n8n para o token do WhatsApp: o workflow lê `WHATSAPP_ACCESS_TOKEN` diretamente do arquivo `.env`.

O `docker-compose.yml` também aceita valores do `.env` para porta pública, login do n8n e outras opções básicas, então o usuário final edita praticamente um arquivo só.

## Campos do CSV

| Campo | Descrição |
|-------|-----------|
| nome | Nome do contato (ou "Contato XXXX") |
| numero | Número normalizado (apenas dígitos) |
| whatsapp | ID original do WhatsApp |
| tipo | individual / group / business |
| formato_internacional | Número formatado (+55 (11) 99999-8888) |
| ultima_interacao | Data/hora da última conversa |
| ultima_mensagem | Texto da última mensagem |
| data_cadastro | Quando foi adicionado ao arquivo |
| origem | "novo" ou "atualizado" |

## Execução

### Manual
Clique em "Execute Workflow" no n8n

### Agendada (automático)
Adicione um nó Schedule Trigger no início do fluxo para executar periodicamente (ex: a cada 6 horas)

## Exemplo de Saída

```json
{
  "sucesso": true,
  "total_final": 347,
  "total_existentes": 340,
  "total_novos": 7,
  "total_atualizados": 12,
  "mensagem": "7 novos contatos adicionados! Total: 347"
}
```

Em caso de falha na API, o fluxo agora encerra sem corromper os arquivos existentes. Se a falha acontecer depois de algumas páginas, ele salva os contatos já processados e retorna uma mensagem de aviso.

## Resetar Base de Dados

Para começar do zero, apague o arquivo de controle:
```bash
rm /output/contatos_controle.json
```

## Limitações

⚠️ A API do WhatsApp Business retorna apenas:
- Contatos que **interagiram** com seu número
- Conversas dos últimos **90 dias**
- Máximo de **5000 conversas** por execução (50 páginas × 100)

Se precisar de mais, execute mais frequentemente.

## Troubleshooting

### "Erro de autenticação"
- Token expirado? Gere um novo no Meta for Developers
- Use tokens de longa duração (60 dias)

### "Nenhum contato novo"
- Normal se já processou todas as conversas
- Execute novamente quando houver novas interações

### "Arquivo CSV corrompido"
- Abra com encoding UTF-8
- O BOM (`\uFEFF`) é intencional para Excel
