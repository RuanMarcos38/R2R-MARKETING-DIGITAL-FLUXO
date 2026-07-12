# R2R Marketing Digital — Fluxo n8n de Atendimento IA

Workflow importável do n8n para atendimento comercial da R2R Marketing Digital via WhatsApp, com:

- Webhook de entrada da Evolution API;
- Normalização e validação das mensagens;
- Debounce de 8 segundos;
- Agente comercial com prompt de multiagentes;
- Memória PostgreSQL separada por telefone;
- Respostas divididas e enviadas de forma humanizada;
- Registro de contatos no Supabase;
- Follow-up automático de contatos inativos;
- Handoff previsto no bloco interno `###META###`.

## Arquivo para importar

Use o arquivo:

`R2R-Atendimento-IA-Multiagentes-n8n.json`

No n8n, abra **Workflows → Import from File**, selecione o JSON, confira as credenciais e publique/ative o fluxo.

## Credenciais

Por segurança, a versão pública usa estas variáveis de ambiente nas requisições HTTP:

- `SUPABASE_SERVICE_ROLE_KEY`
- `EVOLUTION_API_KEY`

As credenciais do OpenAI e PostgreSQL devem ser associadas aos respectivos nós após a importação, caso o n8n não faça o vínculo automaticamente.

> Não publique chaves de serviço ativas em um repositório público.

## Antes de ativar

Confirme o endpoint/instância da Evolution API, o projeto Supabase, as tabelas `contacts` e `chat_memory`, as credenciais do OpenAI/PostgreSQL e a URL de produção do webhook.
