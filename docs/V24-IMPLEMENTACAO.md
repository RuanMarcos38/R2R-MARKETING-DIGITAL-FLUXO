# Implementação V24 — R2R Marketing Digital

## Objetivo

Unificar, em um único workflow n8n:

1. prospecção de empresas;
2. validação e primeiro contato;
3. atendimento das respostas com IA;
4. reativação dos contatos históricos;
5. identificação do serviço que originou o contato;
6. continuidade comercial até proposta, pagamento ou handoff.

## Fontes utilizadas

A implementação foi baseada no fluxo de prospecção e atendimento V23.1, preservando a fila de respostas, agrupamento, idempotência e antirrepetição. A arquitetura de busca histórica e reserva da reativação foi adaptada do SDR V22, removendo todas as regras imobiliárias.

## Prospecção

A mensagem inicial não lista todos os serviços. Ela começa com uma pergunta diagnóstica:

> Hoje vocês já têm um site profissional e alguém responsável pelas campanhas no Meta e Google, ou alguma dessas áreas ainda está sem acompanhamento?

A resposta define a próxima tratativa. O agente deve descobrir, de forma progressiva, o cenário atual, o problema, o objetivo, a estrutura existente, a urgência, o decisor e o escopo necessário.

## Reativação

A reativação executa das 07h às 22h e consulta mensagens históricas da Evolution API.

### Critérios

- existe mensagem recebida anteriormente;
- o telefone não é grupo, broadcast ou número próprio;
- a conversa está inativa pelo período mínimo configurado;
- o contato não solicitou descadastro;
- não existe reativação concluída ou reserva ativa;
- o limite diário ainda está disponível.

### Classificação do interesse

O histórico é agrupado por telefone. O classificador procura evidências para:

- `curso_trafego`;
- `landing_page`;
- `site`;
- `crm`;
- `ebook`;
- `automacao_ia`.

A mensagem específica só é usada quando existe pontuação mínima e diferença suficiente em relação ao segundo assunto. Sem evidência clara, o fluxo usa uma mensagem geral e pergunta qual solução o contato buscava. Isso evita reativar o cliente falando do serviço incorreto.

## Atendimento comercial

O agente possui conhecimento das 23 categorias cadastradas no Supabase e segue estas regras:

- responder a pergunta atual primeiro;
- manter o assunto identificado;
- uma pergunta por mensagem;
- não repetir saudação ou informação;
- não fazer interrogatório em uma única resposta;
- explicar benefício, entregáveis e aderência;
- tratar objeções sem manipulação;
- não prometer resultados;
- não inventar valor, desconto, prazo ou funcionalidade;
- encaminhar pedido de proposta, contrato, pagamento ou negociação ao responsável.

## Política de preço

Valores autorizados:

| Serviço | Valor inicial |
|---|---:|
| Landing Page | R$ 497,00 |
| Site | R$ 1.200,00 |
| E-commerce | R$ 5.000,00 |
| Automação com IA | R$ 2.500,00 |
| CRM | R$ 2.500,00 |
| Sistema personalizado | Levantamento e call |

Para os demais serviços, o agente não inventa preço. Ele registra o interesse e encaminha ao comercial.

O preço deve ser apresentado após o diagnóstico e a explicação de valor. Uma pergunta direta sobre preço deve ser respondida com transparência, utilizando o valor “a partir de” e uma única pergunta essencial para definir o escopo.

## Fechamento

Quando as informações estiverem completas, o agente pergunta se ficou alguma dúvida. Somente após o cliente confirmar que está esclarecido, demonstrar interesse e estar ciente do valor, o agente pergunta se pode enviar o link de pagamento. Essa etapa ativa handoff para o responsável.

## Estrutura Supabase

Todas as estruturas da V24 usam prefixo exclusivo:

- `r2r_mkt_v24_settings`;
- `r2r_mkt_v24_services`;
- `r2r_mkt_v24_contacts`;
- `r2r_mkt_v24_messages`;
- `r2r_mkt_v24_reactivations`.

RPCs:

- `r2r_mkt_v24_control_snapshot`;
- `r2r_mkt_v24_catalog`;
- `r2r_mkt_v24_save_interest`;
- `r2r_mkt_v24_opt_out`;
- `r2r_mkt_v24_reserve_reactivation`;
- `r2r_mkt_v24_complete_reactivation`.

As tabelas existentes no projeto não foram renomeadas, apagadas ou alteradas.

## Proteções

- RLS habilitado;
- acesso direto revogado para `anon` e `authenticated`;
- RPCs com `security definer`;
- segredo interno validado por SHA-256;
- bloqueio por opt-out;
- trava transacional por telefone;
- limite diário no banco;
- uma reativação concluída por telefone;
- reserva antiga pode ser recuperada;
- limite de tentativas;
- gravação da mensagem somente após confirmação do envio.

## Validação do JSON

Resultado da validação da versão completa:

- 172 nodes;
- 132 nodes com conexões de saída;
- 92 Code nodes compilados;
- nenhum nome duplicado;
- nenhum ID duplicado;
- nenhuma conexão apontando para node inexistente;
- JSON válido e importável.

## Segurança operacional

A versão pública deve manter placeholders. Não inclua chaves OpenAI, Apify, Evolution API, service role ou segredo RPC em repositório público. Chaves que apareceram em arquivos anteriores precisam ser rotacionadas antes de colocar a V24 em produção.
