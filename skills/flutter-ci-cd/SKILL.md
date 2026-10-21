---
name: flutter-ci-cd
description: Configura CI para projetos Flutter com formatação, análise estática, testes e builds de validação, mantendo cache e segredos sob controle. Use quando o projeto precisar de verificações automáticas em pushes ou pull requests.
---

# CI para Flutter

## Objetivo e uso

Faça o repositório verificar automaticamente alterações Flutter com resultados reproduzíveis. Use para configurar ou reparar workflows de CI. Não ative para publicar em loja quando o pedido cobre apenas verificação; distribuição exige fluxo de release e segredos próprios.

## Pré-requisitos

Leia versões de Flutter/Dart exigidas em `pubspec.yaml`, lockfile, plataformas do repositório, comandos locais que passam, testes que dependem de serviços e regras de branches. Verifique o provedor escolhido; para GitHub Actions, examine workflows existentes e permissões do token. Escolha versão do SDK compatível com o projeto e mantenha essa escolha explícita.

## Procedimento

1. Crie workflow para `push` e `pull_request`, com `permissions: contents: read` salvo exigência justificada. Defina timeout e concorrência para evitar jobs obsoletos.
2. Instale o SDK Flutter no runner com versão/canal controlado; execute `flutter --version` e `flutter pub get`. Só habilite cache de dependências com chave baseada no lockfile e no SDK, sem incluir credenciais.
3. Execute na raiz do app: `dart format --output=none --set-exit-if-changed .`, `flutter analyze` e `flutter test`. Se houver módulos separados, execute comandos próprios em cada diretório. Publique resultados claros de falha.
4. Adicione `flutter build apk --debug` ou build de validação relevante quando houver Android SDK e dependências disponíveis. Build sem assinatura de distribuição não comprova release. Testes de integração com dispositivo/serviço devem usar job de ambiente de teste isolado e relatar quando foram ignorados.
5. Guarde segredos do lado do provedor CI, restrinja acesso em PRs externos e evite imprimir variáveis, arquivos `.env`, keystore ou logs de requisições autenticadas. Não use segredo de produção para teste automatizado.

## Erros comuns, validação e aceite

Evite versões flutuantes do SDK, cache sem chave de compatibilidade, `continue-on-error` em etapas obrigatórias e testes que passam apenas por ignorar integração crítica. Primeiro rode os comandos localmente; depois abra uma execução de PR ou push de teste e confira logs, resultado de cada etapa e artefatos. Aceite quando PR inválido falhar pela razão correta, PR válido passar e pendências nativas/externas estiverem indicadas.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-ci-cd para criar uma GitHub Action de análise e testes.”
- Indireta: “Todo PR precisa falhar se Dart estiver sem formatação ou se os testes quebrarem.”
- Não ativar: “Execute um teste local para este único widget.”

Referências: [entrega contínua Flutter](https://docs.flutter.dev/deployment/cd), [sintaxe GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax) e [dependências Flutter](https://docs.flutter.dev/packages-and-plugins/using-packages).
