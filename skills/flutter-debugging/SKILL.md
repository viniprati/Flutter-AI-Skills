---
name: flutter-debugging
description: Diagnostica e corrige falhas de compilação, dependências, layout, null safety, exceções assíncronas, plugins e integração Android em projetos Flutter. Use quando houver erro reproduzível ou logs a investigar.
---

# Depuração Flutter

## Objetivo e escopo

Isole a primeira causa verificável de uma falha Flutter e aplique a menor correção que resolve o sintoma. Use para erros de execução, análise, build, layout ou integração de plugin. Não ative para revisar estilo sem defeito identificado.

## Pré-requisitos

Registre comando exato, plataforma, modo debug/profile/release, versão do Flutter/Dart (`flutter --version`), dispositivo, primeira mensagem de erro e trecho de stack trace. Verifique `flutter doctor -v`, `pubspec.yaml`, lockfile, Gradle e alterações recentes conforme o caso. Redija os logs antes de compartilhar: nunca exponha token, senha ou dados pessoais.

## Procedimento

1. Reproduza em ambiente controlado. Separe falha de resolução (`flutter pub get`), análise (`flutter analyze`), teste (`flutter test`), build (`flutter build ...`) e execução (`flutter run -d ID`). Corrija o primeiro erro causal; mensagens seguintes podem ser consequência.
2. Reduza a área: identifique arquivo/linha no stack trace, commit que introduziu a falha ou menor widget/caso que reproduz. Formule hipótese e teste uma mudança por vez.
3. Para `RenderFlex overflow`, veja constraints, texto ampliado, teclado e rolagem; prefira `Expanded`/`Flexible` ou layout rolável de acordo com o conteúdo. Para null safety, trate o estado ausente na origem e evite `!` como silenciador.
4. Para exceção assíncrona, confira `await`, `try/catch` na fronteira correta, `mounted` antes de usar contexto após `await` e cancelamento de subscriptions. Para plugin/Android, compare configuração nativa, versão de SDK, manifesto e comportamento em release; R8 pode mudar o resultado.
5. Adicione teste de regressão quando o bug for reproduzível por teste. Rode novamente o comando que falhava e um teste próximo; documente causa, evidência e limites.

## Erros comuns e aceite

Evite apagar lockfile, limpar cache global ou atualizar todas as dependências sem evidência. `flutter clean` é diagnóstico para artefatos gerados, não explicação causal. Build aprovado não comprova abertura, login, armazenamento ou notificações em aparelho. Aceite quando o erro original deixar de ocorrer no mesmo cenário e a correção tiver verificação proporcional ao risco.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-debugging para investigar este RenderFlex overflow.”
- Indireta: “O APK release compila, mas fecha ao abrir a tela que usa o plugin.”
- Não ativar: “Crie um novo guia de instalação no README.”

Referências: [depuração Flutter](https://docs.flutter.dev/testing/debugging), [DevTools](https://docs.flutter.dev/tools/devtools) e [build Android](https://docs.flutter.dev/deployment/android).
