# Relatório de Validação

- Nodes: 87
- Conexões de origem: 79
- Referências ausentes: 0
- IDs de nodes únicos: True
- Workflow ativo na importação: False
- Credenciais embutidas: não
- Prefixo exclusivo Supabase: `r2r_ai5_`
- Arquivos JSON carregáveis: sim
- Code Nodes validados: 28
- Code Nodes com erro de sintaxe: 0
- Consultas com continuidade em resposta vazia: 9

Referências ausentes: `[]`

## Correções de segurança operacional
- Nova mensagem recebida cancela follow-ups pendentes anteriores.
- Pedido direto de atendimento humano ativa `human_mode` imediatamente.
- Follow-up consulta `opt_out` e `human_mode` antes de enviar.
- Consultas vazias do Supabase e do Google Calendar não interrompem o fluxo.

## Supabase
- Migração aplicada: `create_r2r_ai5_isolated_flow`.
- Projeto: `CRM R2 MARKETING DIGITAL` (`iqrnytsgwaiegddfxfjs`).
- Tabelas novas confirmadas: 9.
- Registros iniciais: 5 agentes e 8 itens de conhecimento.
- RLS: ativo em todas as tabelas `r2r_ai5_`.
- Acesso de `anon` e `authenticated`: revogado.
- Acesso operacional: somente `service_role`.
- O advisor registrou avisos informativos de “RLS sem policy”; neste pacote isso é intencional, pois o n8n usa service role e clientes públicos não devem acessar essas tabelas.
- Outros avisos exibidos pelo advisor pertencem a funções e tabelas já existentes e não foram modificados.
