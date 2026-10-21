---
name: flutter-push-notifications
description: Implementa e valida notificações push Firebase Cloud Messaging em Flutter, incluindo permissões, registro da instalação, estados do app e backend. Use quando a tarefa pedir avisos push ou diagnosticar seu recebimento.
---

# Push com Firebase Cloud Messaging

## Objetivo e limites

Configure o cliente Flutter para receber mensagens FCM e integrar uma origem de envio autorizada. Use para notificações remotas, abertura por toque e gestão de inscrição. Não ative para avisos puramente locais ou para uma central alimentada somente por consulta HTTP. Diferencie implementação no app, aceitação do envio pelo FCM e entrega observada no aparelho.

## Pré-requisitos

Confirme plataformas alvo, identificadores dos apps, projeto Firebase, versões de Android/iOS, ambiente de teste, consentimento esperado e contrato do backend. Verifique versões de `firebase_core` e `firebase_messaging`. Configure o projeto com o fluxo oficial FlutterFire da versão usada; Android exige configuração Google Services e, no Android 13+, permissão de notificações. iOS/Web exigem etapas próprias: não anuncie suporte antes de configurá-las.

## Procedimento

1. Inicialize Firebase antes de registrar os ouvintes. Solicite permissão em contexto compreensível ao usuário e trate negada, provisória e autorizada conforme plataforma.
2. Escolha o mecanismo de registro suportado pela versão instalada e pelo backend. O fluxo atual recomendado pelo Firebase usa Firebase Installation ID (FID): habilite a opção nativa quando exigida, escute `FirebaseMessaging.instance.onRegistered` cedo e chame `register()` após instalar o listener quando a inicialização automática estiver desativada ou na Web. Envie FID com data de atualização por HTTPS ao backend autenticado. Em integração legada por token, use `getToken()` e `onTokenRefresh`. Não misture FID e token para a mesma inscrição. Associe o identificador a usuário, instalação e ambiente; remova a associação ao sair ou desativar, com tratamento de falha.
3. Escute `FirebaseMessaging.onMessage` no primeiro plano. Defina explicitamente a experiência visual, pois notificação visível não aparece automaticamente em primeiro plano em todas as plataformas.
4. Para toque na notificação, trate tanto `getInitialMessage()` quanto `onMessageOpenedApp`; valide tipo/identificador recebido e busque dados autorizados antes de navegar. Use `onBackgroundMessage` apenas quando houver trabalho necessário: handler de nível superior com `@pragma('vm:entry-point')`, sem acesso a `BuildContext`.
5. Mantenha credenciais administrativas e envio no servidor. Não inclua conta de serviço, chave privada ou dados pessoais sensíveis no payload da tela bloqueada. Projete identificadores estáveis e deduplicação onde reenvios forem possíveis.

## Validação, erros e aceite

Teste permissão concedida/negada, renovação do identificador de registro, login/logout, primeiro plano, segundo plano e app encerrado; teste Android em dispositivo com os serviços exigidos. Para entrega, envie evento exclusivo de teste e observe o aparelho, toque, navegação e eventual duplicação. `integration_test` não controla diálogos nativos de permissão nem prova entrega do provedor. Registre separadamente configuração, resposta de aceite do FCM e recebimento real. Aceite quando o fluxo exigido for comprovado em cada plataforma anunciada e o backend não expuser credenciais.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-push-notifications para receber avisos FCM no Android.”
- Indireta: “O aviso chega ao servidor, mas não aparece com o aplicativo fechado.”
- Não ativar: “Mostre uma mensagem de erro em um SnackBar após salvar.”

Referências: [configuração e registro FCM Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/get-started), [gerenciamento de registros](https://firebase.google.com/docs/cloud-messaging/manage-tokens), [recebimento de mensagens](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages) e [limites de testes Flutter](https://docs.flutter.dev/testing/overview).
