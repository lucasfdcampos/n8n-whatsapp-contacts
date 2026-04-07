# WhatsApp Business - Extrator de Contatos

Projeto n8n para extrair contatos do WhatsApp Business API e salvar os resultados em arquivos locais.

## Comece Aqui

Guia completo de instalacao:
[INSTALACAO.md](./INSTALACAO.md)

Se usa:

- Windows: va para [Instalacao no Windows](./INSTALACAO.md#instalacao-no-windows)
- Linux: va para [Instalacao no Linux](./INSTALACAO.md#instalacao-no-linux)

Fluxo rapido:

- Windows: execute `setup.bat` e depois `run.bat`
- Linux: execute `./setup.sh` e depois `./run.sh`
- Alternativa para usuarios tecnicos no Linux: `make setup` e `make up`

## O que este projeto faz

- busca conversas da API do WhatsApp Business
- identifica contatos novos
- atualiza dados de contatos ja conhecidos
- salva os resultados em `output/`

## Como o fluxo funciona

O workflow foi montado para trabalhar de forma incremental.

Em cada execucao, ele:

1. le o arquivo de controle salvo anteriormente
2. busca as conversas da API do WhatsApp Business
3. compara os numeros encontrados com os contatos ja conhecidos
4. adiciona apenas contatos novos
5. atualiza ultima interacao e ultima mensagem dos contatos existentes
6. salva novamente os arquivos para a proxima execucao

Isso significa que o projeto nao recria sua base do zero toda vez. Ele aproveita o historico salvo para manter um CSV acumulado e um arquivo de controle interno.

Arquivos gerados:

- `output/contatos_controle.json`
- `output/contatos_whatsapp_acumulado.csv`
- `output/contatos_whatsapp_acumulado.json`

Se houver contatos novos em uma execucao, o fluxo tambem pode gerar um arquivo resumido com os novos contatos daquele dia.

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

## Atualizacao dos dados

Quando voce roda o workflow novamente:

- contatos antigos nao sao duplicados
- contatos novos sao adicionados
- contatos existentes podem ter data de interacao e ultima mensagem atualizadas

Em outras palavras, a base vai sendo enriquecida com o tempo.

## Observacoes

- o token do WhatsApp e lido do arquivo `.env`
- nao e necessario criar credencial manual no n8n para o token
- os modulos `fs` e `path` ja estao liberados para os nos `Code`

Se a API falhar no meio do processo, o fluxo foi configurado para evitar corromper os arquivos ja existentes.

## Limites conhecidos

- a API retorna contatos que interagiram com seu numero
- a janela de conversas costuma ficar limitada aos ultimos 90 dias
- o fluxo esta configurado para ate 50 paginas de 100 conversas cada

Por isso, a quantidade total de contatos disponiveis depende do que a propria API da Meta disponibiliza para o numero conectado.
