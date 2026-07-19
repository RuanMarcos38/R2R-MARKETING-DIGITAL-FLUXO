# Correção — `access to env vars denied` no n8n

## Causa
O node `02 - Normalizar Entrada` lê `$env.TIMEZONE`. A instância está bloqueando o acesso às variáveis de ambiente. O texto `Cannot assign to read only property name...` é um erro secundário; a causa real é `access to env vars denied`.

## EasyPanel
1. Abra o projeto do n8n.
2. Entre no serviço/container do n8n.
3. Abra **Environment** ou **Variables**.
4. Adicione:

```env
N8N_BLOCK_ENV_ACCESS_IN_NODE=false
GENERIC_TIMEZONE=America/Sao_Paulo
TZ=America/Sao_Paulo
TIMEZONE=America/Sao_Paulo
```

5. Confirme também todas as variáveis do arquivo `variaveis_ambiente.env.example`.
6. Salve e clique em **Deploy**, **Recreate** ou reinicie o serviço.
7. Volte ao n8n e execute novamente desde o Webhook.

## Teste rápido
Crie temporariamente um Code node com:

```javascript
return [{ json: { timezone: $env.TIMEZONE, envLiberado: true } }];
```

O resultado esperado é `America/Sao_Paulo`. Exclua o node de teste depois.

## Segurança
Liberar `$env` permite que usuários com permissão para editar workflows leiam variáveis do container. Use apenas quando a instância for administrada por pessoas confiáveis. Para ambientes com vários usuários não confiáveis, migre os segredos para credenciais do n8n ou um gerenciador externo de segredos.

## Se ainda falhar
- Verifique se a variável foi colocada no serviço correto.
- Em queue mode, aplique também nos workers.
- Em task runners externos, aplique no serviço executor quando necessário.
- Faça recriação do container, não apenas refresh do navegador.
- Consulte os logs de inicialização e confirme que não existe outra definição `N8N_BLOCK_ENV_ACCESS_IN_NODE=true`.
