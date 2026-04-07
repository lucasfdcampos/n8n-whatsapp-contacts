# WhatsApp Business - Extrator de Contatos

Projeto n8n para extrair contatos do WhatsApp Business API e salvar os resultados em arquivos locais.

## Comece Aqui

Guia completo de instalacao:
[INSTALACAO.md](./INSTALACAO.md)

Fluxo rapido:

- Windows: execute `setup.bat` e depois `run.bat`
- Linux: execute `./setup.sh` e depois `./run.sh`
- Alternativa para usuarios tecnicos no Linux: `make setup` e `make up`

## O que este projeto faz

- busca conversas da API do WhatsApp Business
- identifica contatos novos
- atualiza dados de contatos ja conhecidos
- salva os resultados em `output/`

Arquivos gerados:

- `output/contatos_controle.json`
- `output/contatos_whatsapp_acumulado.csv`
- `output/contatos_whatsapp_acumulado.json`

## Credenciais necessarias

Voce vai precisar preencher no arquivo `.env`:

- `WHATSAPP_PHONE_NUMBER_ID`
- `WHATSAPP_BUSINESS_ACCOUNT_ID`
- `WHATSAPP_ACCESS_TOKEN`

Esses dados sao obtidos no Meta for Developers.

## Depois de instalar

1. Abra o n8n em `http://localhost:5679`
2. Entre com o login definido no `.env`
3. Importe `workflows/WhatsApp-Contacts-Extractor-v3.json`
4. Execute o workflow manualmente

## Observacoes

- o token do WhatsApp e lido do arquivo `.env`
- nao e necessario criar credencial manual no n8n para o token
- os modulos `fs` e `path` ja estao liberados para os nos `Code`

## Limites conhecidos

- a API retorna contatos que interagiram com seu numero
- a janela de conversas costuma ficar limitada aos ultimos 90 dias
- o fluxo esta configurado para ate 50 paginas de 100 conversas cada
