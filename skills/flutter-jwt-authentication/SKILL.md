---
name: flutter-jwt-authentication
description: Implementa fluxo de login, sessão, expiração e logout com JWT em Flutter. Use quando uma API emite access tokens Bearer e o app precisa protegê-los e lidar com respostas 401.
---

# Autenticação JWT

## Objetivo e acionamento

Gerencie uma sessão JWT de acordo com o contrato da API e impeça que a interface confunda token presente com autorização garantida. Use em login, retomada, logout, refresh token e requisições autenticadas. Não acione para uma tela estática de login sem backend nem trate conta única demonstrativa como modelo de produção.

## Antes de alterar

- Confirme endpoints, formato `Bearer`, duração/expiração, refresh e revogação, escopos, mensagens de `401/403` e exigência de autenticação offline.
- Verifique plataformas, política de armazenamento e se já existe `AuthRepository`/interceptor. Identifique rotas que exigem autorização além de login.
- Confirme HTTPS e relógio/expiração recebida; JWT decodificado no cliente serve para UX, não para validar assinatura ou direitos.

## Procedimento

1. Faça login por HTTPS com credenciais no corpo da requisição, limite de tempo e prevenção de envio duplicado. Valide formato da resposta antes de aceitar a sessão.
2. Mantenha `accessToken` em memória quando não for necessária retomada. Se persistência for requisito, escolha armazenamento seguro adequado às plataformas e avalie o risco de Web; nunca use `shared_preferences` para senha, access token ou refresh token.
3. Injete `Authorization: Bearer ...` somente nas rotas previstas. Não inclua token em URL, analytics, mensagem de erro, captura de tela de diagnóstico ou log.
4. Compare expiração com margem curta e coordene refresh em uma única operação para evitar várias renovações paralelas. Se não há refresh, leve o usuário ao login preservando rascunhos permitidos.
5. Ao receber `401`, limpe ou renove sessão conforme contrato; `403` significa acesso negado, não necessariamente sessão vencida. Faça logout limpar estado em memória, armazenamento seguro e caches privados; chame revogação no servidor quando disponível.
6. Proteja navegação por estado autenticado, mas exija que o backend valide assinatura, expiração e autorização por recurso/usuário em cada operação.

Adapte [o fluxo mínimo em Dart](examples/in_memory_auth.dart) e [o teste com `MockClient`](examples/in_memory_auth_test.dart) quando a API fornecer `POST v1/auth/login` com `tokenType`, `accessToken` e `expiresIn` (segundos), e `GET v1/me` autenticado. Dependências: `http` e `flutter_test` (SDK Flutter). A URL base e o cliente são injetados; o chamador fecha o cliente. O exemplo mantém token apenas em memória, rejeita redirecionamentos e não implementa refresh, persistência, autorização no servidor nem login offline.

## Práticas e problemas comuns

- Não assine JWT no aplicativo nem distribua o segredo de assinatura ou chave privada nele.
- Não use apenas a presença de token persistido para assumir sessão válida depois de reiniciar.
- Não implemente “login offline” sem credenciais/verificação local e política próprias; cache de dados após login online não concede autenticação offline.
- Erro de rede no login não deve virar “senha incorreta” sem resposta do servidor.

## Validação e critérios de aceitação

- Teste login válido/inválido, resposta malformada, timeout, `401`, `403`, expiração, refresh concorrente e logout/reabertura. Verifique redaction de logs.
- Em integração controlada, confirme autorização do servidor: outro usuário não pode acessar recurso só por trocar ID na URL.
- Aceite quando token tem ciclo de vida explícito, armazenamento condiz com risco e nenhuma permissão depende apenas da lógica Flutter.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-jwt-authentication para login e expiração do token.”
- **Indireta:** “Depois de uma hora a API responde 401 e o app fica preso carregando.”
- **Não ativar:** “Monte só o layout visual de uma tela de boas-vindas.”
