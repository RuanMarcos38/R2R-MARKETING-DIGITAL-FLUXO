-- Memória isolada do fluxo n8n R2R Atendimento IA
-- Projeto Supabase: CRM R2 MARKETING DIGITAL
-- Project ref: iqrnytsgwaiegddfxfjs
-- Esta migração não altera tabelas existentes.

create table if not exists public.r2r_chat_memory (
  id bigint generated always as identity primary key,
  session_id varchar(255) not null,
  message jsonb not null,
  created_at timestamptz not null default now()
);

create index if not exists r2r_chat_memory_session_id_id_idx
  on public.r2r_chat_memory (session_id, id desc);

alter table public.r2r_chat_memory enable row level security;

grant all on table public.r2r_chat_memory to postgres;
grant all on table public.r2r_chat_memory to service_role;
grant usage, select on sequence public.r2r_chat_memory_id_seq to postgres;
grant usage, select on sequence public.r2r_chat_memory_id_seq to service_role;

comment on table public.r2r_chat_memory is
  'Memoria isolada do fluxo n8n R2R Atendimento IA. Nao reutilizar em outros projetos.';
comment on column public.r2r_chat_memory.session_id is
  'Identificador persistente da conversa, normalmente o telefone normalizado.';
comment on column public.r2r_chat_memory.message is
  'Mensagem no formato JSON utilizado pelo Postgres Chat Memory do n8n.';
