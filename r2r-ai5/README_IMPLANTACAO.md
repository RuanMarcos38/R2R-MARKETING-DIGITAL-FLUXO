# R2R Marketing Digital — Atendimento IA com 5 Agentes

## Isolamento
- Repositório-alvo: `RuanMarcos38/R2R-MARKETING-DIGITAL-FLUXO`.
- Banco-alvo: `CRM R2 MARKETING DIGITAL` (`iqrnytsgwaiegddfxfjs`).
- Todas as novas tabelas usam `r2r_ai5_`.
- A migração não altera tabelas, funções, triggers, políticas ou dados de outros projetos.
- O workflow importa desativado e sem IDs de credenciais.

## Cinco agentes
1. Triagem, diagnóstico e qualificação.
2. Tráfego Pago.
3. Curso e Mentoria.
4. Automação de Atendimento, CRM e IA.
5. Sites e Landing Pages.

## Recursos
- WhatsApp pela Evolution API.
- Deduplicação por ID externo.
- Áudio com transcrição.
- Imagem e PDF enviados ao modelo multimodal.
- Memória e histórico no Supabase.
- Uma pergunta por vez e respostas curtas.
- Pausa/digitação usando `delay` da Evolution API.
- Agendamento com consulta de conflito no Google Calendar.
- Cancelamento somente após confirmação e identificação do evento.
- Handoff para Ruan Marcos.
- Follow-up a cada 15 minutos, limitado a registros pendentes.
- Opt-out com SAIR/PARAR/REMOVER.

## Implantação
1. Execute `SUPABASE_MIGRATION_R2R_AI5.sql` no projeto correto.
2. Configure as variáveis de `variaveis_ambiente.env.example` no ambiente do n8n.
3. No n8n, crie um workflow novo e use **Import from File**.
4. Importe `R2R_AI5_WORKFLOW_N8N_EDITAVEL.json`.
5. Abra os três nodes do Google Calendar e associe a credencial OAuth correta.
6. Na Evolution API, configure o evento `MESSAGES_UPSERT` para a URL de produção do webhook `/webhook/r2r-marketing-ai5-whatsapp`.
7. Revise os links de checkout. Eles permanecem vazios por segurança porque as páginas atuais apresentam divergência de redirecionamento.
8. Teste em modo manual antes de ativar.

## Regra de preço
- Curso e mentoria usam valores públicos da base apenas depois de valorização e intenção real.
- Serviços personalizados não exibem valor sem diagnóstico de escopo e orçamento.
- Nunca inventar preço ou desconto.

## Observação técnica
O workflow usa a Responses API com Structured Outputs e `store:false`. As chaves permanecem somente em variáveis de ambiente.
