# R2R Marketing Digital — Fluxo Único n8n V24.1

Workflow comercial unificado da **R2R Marketing Digital** para WhatsApp, reunindo prospecção, reativação por interesse, atendimento com IA, qualificação, tratamento de objeções e encaminhamento para fechamento.

## Correção V24.1 — fila persistente de respostas

A V24 original registrava as mensagens recebidas em `$getWorkflowStaticData('global')` e dependia de outra execução agendada para localizar a fila. Em testes manuais e em cenários com execuções concorrentes, esse estado podia não ficar disponível para o processamento seguinte. O resultado era uma execução encerrada em `FIM - Mensagem Registrada para o Agente IA`, enquanto o disparo de cada minuto concluía sem encontrar itens e não chegava ao agente.

A V24.1 substitui a fila temporária por uma fila persistente no Supabase:

- o webhook recebe e normaliza a mensagem da Evolution API;
- a mensagem é gravada com status `pending` em `r2r_mkt_v24_messages`;
- o disparo de cada minuto reivindica atomicamente as conversas prontas;
- mensagens seguidas do mesmo telefone são agrupadas;
- o agente de IA processa somente o lote reivindicado;
- depois do envio confirmado, as mensagens são marcadas como `processed`;
- se a Evolution API falhar, o lote volta para `pending` e pode ser tentado novamente;
- respostas duplicadas ou mensagens que devem ser ignoradas também finalizam o lote, evitando travamentos.

### RPCs adicionadas

- `r2r_mkt_v24_enqueue_inbound`;
- `r2r_mkt_v24_claim_inbound_batch`;
- `r2r_mkt_v24_complete_inbound`;
- `r2r_mkt_v24_release_inbound`.

As funções utilizam as tabelas isoladas `r2r_mkt_v24_*` e não alteram estruturas de outros projetos.

## O que o fluxo realiza

- Prospecção automática de empresas sem site;
- abordagem diagnóstica sobre site e gestão de tráfego pago;
- validação do WhatsApp;
- primeiro contato e retentativa controlada;
- recebimento de respostas da Evolution API;
- fila persistente no Supabase;
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

Estruturas exclusivas:

- `r2r_mkt_v24_settings`;
- `r2r_mkt_v24_services`;
- `r2r_mkt_v24_contacts`;
- `r2r_mkt_v24_messages`;
- `r2r_mkt_v24_reactivations`.

O catálogo contém 23 serviços. As tabelas usam RLS, não possuem acesso direto para leitura e escrita e são operadas por RPCs protegidas por segredo interno.

## Arquivo principal

`R2R-Fluxo-Unico-Prospecao-Reativacao-Atendimento-V24.1-CORRIGIDO.json`

A versão V24.1 possui 182 nodes. Foram validados nomes, IDs, conexões e a sintaxe dos 96 Code nodes.

## Antes de ativar

1. Importe o JSON V24.1 no n8n.
2. Revise os nodes `00 - CONFIGURAR PROSPECÇÃO AQUI` e `00 - CONFIGURAR ATENDIMENTO AQUI`.
3. Confirme Apify, OpenAI, Evolution API e Supabase.
4. Desative a V24 anterior para evitar dois webhooks ou dois processadores de fila.
5. Publique e ative somente a V24.1.
6. Configure na Evolution API o evento `MESSAGES_UPSERT` para a URL de produção do node `Receber Respostas Evolution`.
7. Envie uma mensagem real de outro WhatsApp.
8. Confirme no Supabase que a mensagem passa por `pending`, `processing` e `processed`.
9. Confirme no n8n que uma execução do processador chega ao agente de IA e ao envio da Evolution API.

## Segurança

Não publique arquivos com chaves ativas. Credenciais expostas em versões anteriores devem ser rotacionadas antes da ativação. A versão pública deve usar placeholders para OpenAI, Apify, Evolution API, chave publicável do Supabase, segredo RPC e segredo de webhook.

## Conformidade

Utilize prospecção e reativação apenas com base legal, origem de contato documentada, identificação clara da empresa e opção de descadastro. Solicitações de `SAIR`, `PARAR` ou equivalentes devem interromper novas mensagens imediatamente.
