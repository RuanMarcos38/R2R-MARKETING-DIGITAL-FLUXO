# Memória do n8n no Supabase — R2R

## Diagnóstico confirmado

O projeto correto é:

- Nome: `CRM R2 MARKETING DIGITAL`
- Project ref: `iqrnytsgwaiegddfxfjs`
- Região do banco: `us-west-2`
- Host direto: `db.iqrnytsgwaiegddfxfjs.supabase.co`

O host `aws-0-sa-east-1.pooler.supabase.com` está incorreto para este projeto porque aponta para a região `sa-east-1`.

## Credencial recomendada no n8n

Abra no Supabase: **Connect → Session pooler → View parameters**.

Copie o Host exatamente como o painel mostrar. Como o projeto está em `us-west-2`, o host terminará em `us-west-2.pooler.supabase.com`, podendo começar com `aws-0-` ou `aws-1-` conforme o pool atribuído ao projeto.

Preencha no n8n:

```text
Host: copiar do Session pooler
Database: postgres
User: postgres.iqrnytsgwaiegddfxfjs
Password: senha PostgreSQL do projeto
Port: 5432
Maximum Number of Connections: 5
SSL: Require
Ignore SSL Issues: desativado
```

Não use `anon key`, `service_role`, JWT, publishable key ou senha da conta Supabase no campo Password.

## Alternativa com conexão direta

Utilize somente se o servidor EasyPanel/n8n tiver IPv6 ou se o projeto possuir o add-on IPv4:

```text
Host: db.iqrnytsgwaiegddfxfjs.supabase.co
Database: postgres
User: postgres
Password: senha PostgreSQL do projeto
Port: 5432
SSL: Require
```

## Node Postgres Chat Memory

```text
Session ID: Define below
Key: {{ $('Preparar Entrada IA').item.json.sessionId }}
Table Name: r2r_chat_memory
Context Window Length: 30
```

A tabela `public.r2r_chat_memory` é exclusiva deste fluxo. Ela não altera nem reutiliza `chat_memory`, `contacts`, `messages`, `leads`, `mensagens` ou outras estruturas já utilizadas por projetos existentes.

## Verificação no Supabase

```sql
select
  count(*) as total,
  count(distinct session_id) as sessoes
from public.r2r_chat_memory;
```

Depois de uma conversa de teste, deve existir pelo menos uma linha para o telefone usado como `session_id`.

## Erros comuns

- `incorrect host`: região ou hostname do pooler incorreto.
- `password authentication failed`: senha PostgreSQL incorreta.
- `Tenant or user not found`: Host e usuário pertencem a poolers/projetos diferentes.
- `ENOTFOUND` ou `EAI_AGAIN`: falha de DNS no container/VPS.
- Timeout no host direto: servidor sem IPv6; utilize Session pooler.
