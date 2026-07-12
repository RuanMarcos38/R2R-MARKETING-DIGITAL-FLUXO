# R2R Marketing Digital — Fluxo n8n de Atendimento IA

Workflow de atendimento comercial da R2R Marketing Digital via WhatsApp.

## Arquitetura revisada

A versão atual foi reconstruída com **6 agentes de IA reais e independentes**, em vez de um único agente simulando várias funções:

1. Triagem e Qualificação;
2. Tráfego Pago e Aquisição;
3. Automação, WhatsApp, CRM e IA;
4. Sites, Landing Pages e Criativos;
5. Educação, Mentoria, Curso e Ebook;
6. Negociação, Objeções, Proposta e Handoff.

O fluxo possui um nó **Roteador de assuntos**, que analisa a mensagem e encaminha somente para o agente especialista correspondente. Todos os agentes usam a mesma sessão de memória PostgreSQL por telefone, permitindo continuar a conversa quando o cliente responde apenas “sim”, “não”, “ok” ou “obrigado”.

Além dos seis especialistas, existe um agente separado para retomada automática de conversas inativas.

## Recursos

- Webhook de entrada da Evolution API;
- Validação de mensagens e bloqueio de grupos/mensagens próprias;
- Debounce de 8 segundos;
- Roteamento por assunto;
- Seis agentes especialistas com prompts próprios;
- Memória PostgreSQL compartilhada por telefone;
- Respostas divididas e enviadas de forma humanizada;
- Registro de contatos no Supabase;
- Follow-up automático;
- Handoff e opt-out pelo bloco interno `###META###`.

## Importação

No n8n, abra **Workflows → Import from File**, selecione o JSON revisado, confira as credenciais e ative o workflow.

A versão completa mantém as credenciais já configuradas na instância. A versão pública do GitHub utiliza variáveis de ambiente para as chaves HTTP:

- `SUPABASE_SERVICE_ROLE_KEY`
- `EVOLUTION_API_KEY`

As credenciais OpenAI e PostgreSQL devem estar associadas aos respectivos nós.

## Antes de ativar

Confirme o endpoint da Evolution API, o projeto Supabase, as tabelas `contacts` e `chat_memory`, as credenciais OpenAI/PostgreSQL e a URL de produção do webhook. O gatilho **Verificar inativos (a cada 2 min)** permanece desativado até ser habilitado manualmente.