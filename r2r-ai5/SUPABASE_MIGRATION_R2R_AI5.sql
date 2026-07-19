-- R2R Marketing Digital — Atendimento IA com 5 agentes
-- Projeto-alvo: CRM R2 MARKETING DIGITAL
-- Isolamento: todas as tabelas usam o prefixo r2r_ai5_.
-- Esta migração NÃO altera tabelas, triggers ou políticas existentes.

create extension if not exists pgcrypto;

create table if not exists public.r2r_ai5_contacts (
  id uuid primary key default gen_random_uuid(),
  phone text not null unique,
  whatsapp_name text,
  confirmed_name text,
  email text,
  company_name text,
  segment text,
  city text,
  service_interest text,
  active_agent text not null default 'a1_triagem',
  stage text not null default 'novo_contato',
  lead_score integer not null default 0 check (lead_score between 0 and 100),
  temperature text not null default 'frio' check (temperature in ('frio','morno','quente')),
  opt_out boolean not null default false,
  human_mode boolean not null default false,
  objective text,
  budget_ads text,
  budget_service text,
  timeline text,
  summary text,
  metadata jsonb not null default '{}'::jsonb,
  last_customer_message_at timestamptz,
  last_ai_message_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.r2r_ai5_message_events (
  id uuid primary key default gen_random_uuid(),
  external_id text not null unique,
  phone text not null,
  received_at timestamptz not null default now(),
  payload jsonb not null default '{}'::jsonb
);

create table if not exists public.r2r_ai5_messages (
  id uuid primary key default gen_random_uuid(),
  phone text not null,
  external_id text,
  direction text not null check (direction in ('in','out')),
  message_type text not null default 'text',
  content text,
  media_url text,
  agent text,
  intent text,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.r2r_ai5_state (
  phone text primary key,
  active_agent text not null default 'a1_triagem',
  current_stage text not null default 'novo_contato',
  known_facts jsonb not null default '{}'::jsonb,
  pending_question text,
  last_question text,
  last_response_hash text,
  conversation_summary text,
  processing_lock_until timestamptz,
  updated_at timestamptz not null default now()
);

create table if not exists public.r2r_ai5_appointments (
  id uuid primary key default gen_random_uuid(),
  phone text not null,
  customer_name text,
  email text,
  google_event_id text unique,
  meeting_type text,
  title text,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  timezone text not null default 'America/Sao_Paulo',
  location text,
  status text not null default 'scheduled' check (status in ('scheduled','cancelled','completed','no_show')),
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.r2r_ai5_followups (
  id uuid primary key default gen_random_uuid(),
  phone text not null,
  message text not null,
  agent text,
  due_at timestamptz not null,
  status text not null default 'pending' check (status in ('pending','sent','cancelled','failed')),
  attempts integer not null default 0,
  last_error text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.r2r_ai5_handoffs (
  id uuid primary key default gen_random_uuid(),
  phone text not null,
  reason text,
  summary text,
  assigned_to text not null default 'Ruan Marcos',
  status text not null default 'open' check (status in ('open','in_progress','resolved','cancelled')),
  created_at timestamptz not null default now(),
  resolved_at timestamptz
);

create table if not exists public.r2r_ai5_knowledge (
  id uuid primary key default gen_random_uuid(),
  source_key text not null unique,
  category text not null,
  title text not null,
  content text not null,
  source_url text,
  active boolean not null default true,
  priority integer not null default 0,
  metadata jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.r2r_ai5_agents (
  agent_key text primary key,
  name text not null,
  specialty text not null,
  active boolean not null default true,
  config jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create index if not exists r2r_ai5_messages_phone_created_idx on public.r2r_ai5_messages(phone, created_at desc);
create index if not exists r2r_ai5_appointments_phone_start_idx on public.r2r_ai5_appointments(phone, starts_at);
create index if not exists r2r_ai5_followups_due_idx on public.r2r_ai5_followups(status, due_at);
create index if not exists r2r_ai5_handoffs_phone_status_idx on public.r2r_ai5_handoffs(phone, status);

alter table public.r2r_ai5_contacts enable row level security;
alter table public.r2r_ai5_message_events enable row level security;
alter table public.r2r_ai5_messages enable row level security;
alter table public.r2r_ai5_state enable row level security;
alter table public.r2r_ai5_appointments enable row level security;
alter table public.r2r_ai5_followups enable row level security;
alter table public.r2r_ai5_handoffs enable row level security;
alter table public.r2r_ai5_knowledge enable row level security;
alter table public.r2r_ai5_agents enable row level security;

revoke all on public.r2r_ai5_contacts, public.r2r_ai5_message_events, public.r2r_ai5_messages,
  public.r2r_ai5_state, public.r2r_ai5_appointments, public.r2r_ai5_followups,
  public.r2r_ai5_handoffs, public.r2r_ai5_knowledge, public.r2r_ai5_agents from anon, authenticated;
grant all on public.r2r_ai5_contacts, public.r2r_ai5_message_events, public.r2r_ai5_messages,
  public.r2r_ai5_state, public.r2r_ai5_appointments, public.r2r_ai5_followups,
  public.r2r_ai5_handoffs, public.r2r_ai5_knowledge, public.r2r_ai5_agents to service_role;

insert into public.r2r_ai5_agents(agent_key,name,specialty,config) values
('a1_triagem','Agente 1 — Triagem e Qualificação','Diagnóstico, qualificação e roteamento','{"question_limit":1}'::jsonb),
('a2_trafego','Agente 2 — Tráfego Pago','Meta Ads, Google Ads, leads e aquisição','{"question_limit":1}'::jsonb),
('a3_curso','Agente 3 — Curso e Mentoria','Formação em tráfego pago e IA','{"question_limit":1}'::jsonb),
('a4_automacao','Agente 4 — Automação, CRM e IA','WhatsApp, n8n, CRM, agentes e follow-up','{"question_limit":1}'::jsonb),
('a5_sites','Agente 5 — Sites e Landing Pages','Sites, landing pages, e-commerce e SEO','{"question_limit":1}'::jsonb)
on conflict (agent_key) do update set name=excluded.name,specialty=excluded.specialty,config=excluded.config,updated_at=now();

insert into public.r2r_ai5_knowledge(source_key,category,title,content,source_url,priority) values
('r2r-geral','geral','R2R Marketing Digital','Agência de Joinville/SC com atendimento em todo o Brasil. Soluções: sites, landing pages, e-commerce, gestão de Meta Ads e Google Ads, social mídia, CRM com IA e automação de atendimento. Contato: contato@r2rmarketingdigital.com.br.','https://r2rmarketingdigital.com.br/',100),
('r2r-trafego','trafego','Gestão de Tráfego Pago','Planejamento e criação de campanhas, segmentação, testes de criativos, otimização de orçamento, relatórios simples e campanhas para WhatsApp, site e formulários. Resultados variam conforme mercado, oferta, investimento e estrutura.','https://r2rmarketingdigital.com.br/',100),
('meta-ads-manager','trafego','Meta Ads Manager oficial','O Ads Manager organiza anúncios nos níveis campanha, conjunto de anúncios e anúncio. Objetivo, público, orçamento, posicionamentos, criativos e mensuração devem estar alinhados. Não há garantia de performance.','https://www.facebook.com/business/tools/ads-manager',90),
('r2r-curso','curso','Aulas Online Plataforma','Formação prática com Meta Ads, Google Ads, públicos, criativos, métricas, landing pages, vídeos com IA, otimização e escala. Valor público exibido na página consultada: R$ 3.997,00. Confirmar antes de informar.','https://mentoria.r2rmarketingdigital.com.br/',100),
('r2r-mentoria','curso','Mentoria 30 Dias ao Vivo','Acompanhamento próximo por 30 dias, orientação estratégica, campanhas, criativos, vídeos com IA, métricas, otimização e escala. Valor público exibido na página consultada: R$ 4.500,00. Confirmar antes de informar.','https://mentoria.r2rmarketingdigital.com.br/',100),
('r2r-automacao','automacao','CRM com IA e Automação','Kanban comercial, atendimento via WhatsApp, agentes de IA humanizados, distribuição de leads, relatórios e integração com campanhas. A implantação depende do escopo e das integrações.','https://r2rmarketingdigital.com.br/',100),
('r2r-sites','sites','Sites Profissionais','Sites modernos, rápidos, responsivos, com SEO, WhatsApp, formulários, Analytics e estrutura para campanhas. Escopo e proposta são personalizados.','https://r2rmarketingdigital.com.br/',100),
('r2r-landing','sites','Landing Pages','Páginas focadas em conversão com copy, CTA, formulários, Pixel, Google Ads, carregamento otimizado e SEO. Escopo e proposta são personalizados.','https://r2rmarketingdigital.com.br/',100)
on conflict (source_key) do update set category=excluded.category,title=excluded.title,content=excluded.content,source_url=excluded.source_url,priority=excluded.priority,active=true,updated_at=now();
