# Validação — Workflow n8n em arquivo único

Arquivo preparado: `R2R-Atendimento-IA-6-Agentes-ARQUIVO-UNICO-n8n.json`

SHA-256: `44921f127b759c2334fd5a75036863f8c27d31d6d696334bd06a43b497a6c046`

## Estrutura validada

- 48 nós no workflow;
- 6 agentes especialistas independentes;
- 1 agente de retomada;
- 7 modelos OpenAI;
- 7 memórias PostgreSQL compartilhadas por telefone;
- regras mestres centralizadas dentro do próprio JSON;
- roteamento por assunto e continuidade do especialista anterior;
- tratamento de objeções, foco comercial, cortesia, concisão e opt-out;
- prompts totalmente incorporados, sem dependência de arquivos externos;
- workflow importado como inativo para evitar conflito com o fluxo atual;
- projeto Supabase exclusivo: `iqrnytsgwaiegddfxfjs` — CRM R2 MARKETING DIGITAL.

## Verificações técnicas

- JSON válido;
- nomes e IDs de nós sem duplicidade;
- conexões sem nós ausentes;
- referências entre nós válidas;
- JavaScript dos nós Code validado com `node --check`;
- nenhuma referência ao projeto imobiliário `uwzfgksmnqgaxtscwxow`;
- nenhuma alteração de schema ou dados realizada no Supabase.

O arquivo completo com as credenciais preservadas não deve ser publicado no repositório público. Ele é entregue diretamente para importação no n8n.