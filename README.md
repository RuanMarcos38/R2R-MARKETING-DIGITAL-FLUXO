# R2R Marketing Digital — Fluxo Único n8n V24

Workflow comercial unificado da **R2R Marketing Digital** para WhatsApp, reunindo prospecção, reativação por interesse, atendimento com IA, qualificação, tratamento de objeções e encaminhamento para fechamento.

## Versão V24

A V24 foi construída sobre o fluxo de prospecção e atendimento com fila de respostas, preservando as proteções contra duplicidade, mensagens seguidas e respostas repetidas. A arquitetura de reativação histórica foi adaptada do SDR para o portfólio da R2R Marketing Digital.

### O que o fluxo realiza

- Prospecção automática de empresas sem site;
- abordagem diagnóstica sobre site e gestão de tráfego pago;
- validação do WhatsApp;
- primeiro contato e retentativa controlada;
- recebimento de respostas da Evolution API;
- agrupamento de mensagens enviadas em sequência;
- uma resposta de IA por telefone e por lote;
- memória de contexto por contato;
- reativação de clientes que já entraram em contato por campanhas;
- identificação do serviço original antes da reativação;
- scripts específicos para Curso de Tráfego Pago, Landing Page, Site, CRM, E-book e Automação com IA;
- mensagem geral quando o histórico não comprova o serviço;
- atendimento completo para 23 categorias de serviço;
- opt-out por `SAIR`;
- limite diário, reserva idempotente e controle de retentativas no Supabase;
- atualização do interesse e do resumo da conversa.

## Regra comercial

O agente segue a sequência:

**Responder → compreender o cenário → diagnosticar → explicar a solução → tratar objeções → confirmar dúvidas → apresentar o preço autorizado → encaminhar o fechamento.**

O preço não deve ser a primeira informação da conversa. Quando o cliente pergunta diretamente, o agente responde com transparência usando apenas os valores autorizados e esclarece o escopo necessário.

### Valores configurados

- Landing Page: a partir de R$ 497,00;
- Site: a partir de R$ 1.200,00;
- E-commerce: a partir de R$ 5.000,00;
- Automação com IA: a partir de R$ 2.500,00;
- CRM: a partir de R$ 2.500,00;
- Sistema personalizado: levantamento e call comercial;
- demais serviços: confirmar com o comercial, sem inventar valor.

## Supabase isolado

Projeto utilizado: **CRM R2 MARKETING DIGITAL**.

A V24 não altera tabelas antigas. Foram criadas estruturas exclusivas:

- `r2r_mkt_v24_settings`;
- `r2r_mkt_v24_services`;
- `r2r_mkt_v24_contacts`;
- `r2r_mkt_v24_messages`;
- `r2r_mkt_v24_reactivations`.

O catálogo contém 23 serviços. As tabelas usam RLS, não possuem acesso direto para `anon` ou `authenticated` e são operadas por RPCs protegidas por segredo interno.

## Arquivo principal

Nome do arquivo importável gerado:

`R2R-Fluxo-Unico-Prospecao-Reativacao-Atendimento-V24.json`

A versão completa possui 172 nodes. A validação verificou nomes únicos, todas as conexões e a sintaxe dos 92 Code nodes.

## Antes de ativar

1. Importe o JSON no n8n.
2. Revise os nodes `00 - CONFIGURAR PROSPECÇÃO AQUI` e `00 - CONFIGURAR ATENDIMENTO AQUI`.
3. Confirme Apify, OpenAI, Evolution API e Supabase.
4. Desative versões antigas que utilizem os mesmos webhooks.
5. Configure na Evolution o evento `MESSAGES_UPSERT` para o webhook da V24.
6. Teste com outro número de WhatsApp antes de liberar a automação.
7. Transfira chaves para credenciais ou variáveis privadas do n8n.

## Segurança

Não publique arquivos com chaves ativas. Credenciais expostas em versões anteriores devem ser rotacionadas antes da ativação. A versão pública deve usar placeholders para OpenAI, Apify, Evolution API, chave publicável do Supabase e segredo RPC da V24.

## Conformidade

Utilize prospecção e reativação apenas com base legal, origem de contato documentada, identificação clara da empresa e opção de descadastro. Solicitações de `SAIR`, `PARAR` ou equivalentes devem interromper novas mensagens imediatamente.
