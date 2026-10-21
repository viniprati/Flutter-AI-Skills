---
name: flutter-rest-api
description: Implementa clientes REST testáveis em Flutter com serialização, erros, timeout, autenticação e paginação. Use ao conectar o app a endpoints HTTP ou corrigir chamadas dispersas em widgets.
---

# Cliente REST

## Objetivo e acionamento

Concentre transporte HTTP e contratos em uma camada testável, mantendo widgets livres de detalhes de status e JSON. Use para integração REST, revisão de cliente existente, paginação e tratamento de falhas. Não acione quando o trabalho é apenas apresentar dados já disponíveis em memória.

## Antes de alterar

- Consulte contrato real da API: URL base por ambiente, rotas/métodos, esquema JSON, autenticação, códigos, paginação, limite de requisição e semântica de repetição.
- Veja clientes e dependências já presentes (`http`, Dio ou outra). Não adicione pacote só para replicar funções existentes.
- Confira exigência de HTTPS e CORS para Web; `--dart-define` configura endpoint público, mas não protege segredo embutido no aplicativo.

## Procedimento

1. Injete `http.Client` (ou cliente existente) e `Uri` base no repositório/gateway. Monte caminhos por `Uri` e codifique query parameters; não concatene entrada de usuário diretamente em URLs.
2. Centralize cabeçalhos, tempo limite, serialização e leitura da resposta. Valide forma/tipos do JSON antes de construir modelos; trate corpo vazio quando o status o permitir.
3. Mapeie `400/422` para dados inválidos, `401` para sessão, `403` para permissão, `404`, `409`, `429` e `5xx` para categorias distintas. Capture timeout, erro de socket e resposta malformada sem mascarar a causa diagnóstica.
4. Implemente paginação pelo contrato (`cursor` ou página/total); deduplique IDs quando apropriado e pare no cursor/total informado. Imponha limite ou sinalize falha se a API devolver páginas inconsistentes.
5. Para mutações, defina chave idempotente ou revisão/`ETag` quando o servidor suportar. Após timeout, descubra se a operação foi aplicada antes de repetir; limite retries com backoff somente para chamadas seguras.
6. Exponha métodos tipados à camada de estado e descarte o cliente criado pelo repositório no ciclo de vida correto. Mantenha token fora de URL, logs e mensagens.

Para um contrato de página `{ "data": [{ "id": ..., "label": ... }], "nextPage": número ou null }`, adapte [o cliente Dart](examples/items_api.dart) e [seu teste com `MockClient`](examples/items_api_test.dart). Dependências: `http` e `flutter_test` (SDK Flutter). O chamador injeta e fecha o `http.Client`; o exemplo usa apenas HTTPS e não contém endpoint real. Ajuste nomes de campos e status ao contrato da sua API.

## Práticas e problemas comuns

- Não aceite qualquer `2xx` como um mesmo corpo: `204` não contém JSON; `201` pode ter recurso criado.
- Não confunda CORS do navegador com falha de autenticação ou conexão no Android.
- Uma URL de ambiente dentro do binário é visível; não inclua credenciais, chave privada nem segredo de assinatura.
- Testes que chamam serviço de produção são frágeis e podem alterar dados; use `MockClient` ou gateway falso para casos de status e paginação.

## Validação e critérios de aceitação

- Teste serialização de ida e volta, URLs/query, timeout, corpo inválido, códigos relevantes, múltiplas páginas e respostas duplicadas.
- Teste mutação com resposta perdida e estratégia de repetição contratada; verifique que segredos não aparecem no log.
- Aceite quando a UI recebe resultado/erro tipado, endpoint muda por configuração, e chamadas de rede são substituíveis por fake nos testes.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-rest-api para conectar o app ao endpoint de pedidos.”
- **Indireta:** “Tem `http.get` em três widgets e a lista para na primeira página.”
- **Não ativar:** “Crie uma lista local fixa para prototipar o layout.”
