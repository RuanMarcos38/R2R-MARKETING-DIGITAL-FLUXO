# Correção — resposta única e antiduplicidade no WhatsApp

## Problema observado

O atendimento enviava duas ou mais respostas para a mesma interação, incluindo reformulações muito parecidas sobre o mesmo orçamento e perguntas sucessivas.

## Correções aplicadas no workflow importável

- somente uma mensagem por interação real do cliente;
- encerramento imediato após a primeira pergunta;
- bloqueio de complementos e reformulações automáticas;
- preservação do especialista anterior quando o cliente informa apenas o orçamento;
- registro atômico por `last_message_id` para impedir processamento repetido do mesmo webhook;
- comparação persistente com a última resposta salva em `contacts.metadata`;
- bloqueio quando `last_customer_message_at <= last_ai_message_at`;
- armazenamento de `last_ai_message_text`, `last_ai_message_hash`, `last_ai_source_message_id` e `awaiting_customer_reply` dentro do JSONB `metadata` existente;
- nenhuma migration e nenhuma nova coluna no Supabase;
- workflow importado inativo para não conflitar com o atendimento em produção.

## Supabase

Projeto validado: `iqrnytsgwaiegddfxfjs` — CRM R2 MARKETING DIGITAL.

A tabela `contacts` já possui os campos necessários (`last_message_id`, `last_customer_message_at`, `last_ai_message_at` e `metadata`). Nenhum schema ou dado foi alterado durante a revisão.

## Arquivo validado

`R2R-Atendimento-IA-6-Agentes-RESPOSTA-UNICA-ANTIDUPLICIDADE-n8n.json`

- 50 nós;
- conexões sem referências ausentes;
- IDs e nomes de nós sem duplicidade;
- JavaScript de todos os nodes Code validado;
- SHA-256: `adf35bac6d17b6959fc7484efe13d1aaf3d9064a42fd5c9731425035663e56d4`.

## Implantação segura

Importar como novo workflow, manter inativo, testar com um número controlado e confirmar que somente um workflow com o webhook `r2r-ia` está ativo antes da substituição do fluxo atual.
