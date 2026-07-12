# R2R GitHub + ChatGPT — Automação n8n

Este diretório pertence exclusivamente ao projeto `RuanMarcos38/R2R-MARKETING-DIGITAL-FLUXO`.

O workflow correspondente foi preparado como um único arquivo importável no n8n:

`R2R-GitHub-ChatGPT-Automacao-n8n-ARQUIVO-UNICO.json`

## Isolamento

- aceita somente eventos cujo `repository.full_name` seja `RuanMarcos38/R2R-MARKETING-DIGITAL-FLUXO`;
- ignora eventos de bots e comentários criados pela própria automação;
- não consulta nem altera outros repositórios;
- não escreve no Supabase;
- não altera o workflow de atendimento WhatsApp;
- é importado inativo para validação antes da ativação.

## Variáveis necessárias no n8n

- `OPENAI_API_KEY`
- `GITHUB_TOKEN`
- opcional: `OPENAI_MODEL` — padrão `gpt-4o-mini`

O token do GitHub deve ter apenas as permissões necessárias para ler metadados e publicar comentários/labels nesse repositório.

## Webhook

Depois da importação, configure o webhook do repositório para a URL de produção do nó:

`/webhook/r2r-github-ai-analysis`

Eventos recomendados: issues, pull requests, push, releases, issue comments e reviews.

## Segurança

O fluxo remove padrões de credenciais antes de enviar conteúdo ao modelo, exige revisão humana para áreas sensíveis e nunca aprova automaticamente alterações críticas.
