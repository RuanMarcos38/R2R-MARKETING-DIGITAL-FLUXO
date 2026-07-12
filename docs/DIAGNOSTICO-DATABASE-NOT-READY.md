# Diagnóstico — `Database is not ready!` no n8n

## Escopo preservado

Esta revisão foi feita sem alterar:

- o workflow ativo no n8n;
- a branch `main`;
- o projeto Supabase `RM NEGOCIO IMOBILIARIO`;
- tabelas, políticas, índices ou dados do Supabase;
- credenciais existentes.

A análise foi limitada ao projeto correto:

- **Projeto:** CRM R2 MARKETING DIGITAL
- **Project ref:** `iqrnytsgwaiegddfxfjs`
- **Status verificado:** `ACTIVE_HEALTHY`

As tabelas `public.contacts` e `public.chat_memory` existem. A tabela `chat_memory` possui registros e índice por `session_id`. O índice único `ux_contacts_phone` também existe, portanto o `on_conflict=phone` usado pelo workflow é compatível.

## Causa identificada

A mensagem exata `Database is not ready!` é emitida pelo servidor do próprio n8n quando a conexão do banco interno do n8n está indisponível (`connectionState.connected = false`).

Isso ocorre antes do processamento do workflow. Portanto, não é causado pela tabela `chat_memory`, pelo REST do Supabase ou pelos seis agentes.

O workflow pode continuar executando enquanto uma tentativa de publicação falha caso exista instabilidade momentânea, reinício, migração incompleta, múltiplas réplicas com estados diferentes ou perda de conexão do serviço principal do n8n com o banco interno.

## Revisão isolada preparada

O arquivo de revisão foi gerado como um workflow separado e inativo, com estas proteções:

- `active: false`;
- webhook alterado de `r2r-ia` para `r2r-ia-revisao`;
- novo identificador de webhook;
- follow-up agendado mantido desativado;
- somente o projeto Supabase `iqrnytsgwaiegddfxfjs` é referenciado;
- IDs e nomes dos nós validados;
- todas as conexões do grafo validadas;
- credenciais existentes dos nós OpenAI e PostgreSQL preservadas na versão privada de importação.

## Correção no EasyPanel/n8n

Realizar no serviço **n8n**, não no projeto Supabase CRM:

1. Abrir os logs do serviço principal do n8n no momento em que a publicação falhar.
2. Procurar por erros de conexão, migração, timeout, `ECONNREFUSED`, `connection terminated`, `SQLITE_BUSY`, autenticação ou DNS.
3. Confirmar qual banco interno o n8n usa:
   - SQLite: volume persistente montado em `/home/node/.n8n`;
   - PostgreSQL: variáveis `DB_TYPE` e `DB_POSTGRESDB_*` apontando para o banco interno correto.
4. Não usar o banco CRM como banco interno do n8n sem planejamento.
5. Se houver mais de uma réplica do serviço principal, confirmar que todas usam o mesmo banco interno e a mesma `N8N_ENCRYPTION_KEY`.
6. Reiniciar somente o serviço n8n após confirmar as variáveis e o armazenamento.
7. Testar o endpoint de prontidão do n8n e publicar novamente apenas quando estiver saudável.
8. Não ativar a revisão isolada antes de validar o webhook de teste.

## Sequência segura de teste

1. Importar a revisão isolada como novo workflow.
2. Reassociar as credenciais apenas se o n8n solicitar.
3. Executar manualmente com uma mensagem de teste.
4. Confirmar o agente selecionado e a gravação na memória.
5. Testar o webhook `r2r-ia-revisao`.
6. Somente após validação, planejar a troca do webhook de produção.
7. Manter o workflow atual ativo até a validação completa.
