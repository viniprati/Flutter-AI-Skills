---
name: flutter-android-release
description: Prepara e valida APK e AAB Android de aplicativos Flutter, incluindo versão, assinatura, R8, compatibilidade e instalação em dispositivo. Use antes de distribuir ou corrigir builds release Android.
---

# Release Android Flutter

## Objetivo e limites

Entregue artefato Android rastreável e pronto para o canal de distribuição escolhido. Use para preparar APK, AAB ou diagnosticar falhas exclusivas de release. Não ative para execução apenas em debug. Build concluído é uma etapa; funcionamento em aparelho exige teste próprio.

## Antes de compilar

Confirme canal de distribuição, identificador do aplicativo, `version` e build number em `pubspec.yaml`, SDKs exigidos, plugins nativos, endpoints de produção e política atual da loja. Examine `android/app/build.gradle(.kts)`, manifesto, permissões e configuração de assinatura. Não substitua identificador de app publicado sem plano de migração.

## Procedimento

1. Rode `flutter doctor -v`, `flutter pub get`, `flutter analyze` e `flutter test`. Documente falhas ou testes não executados.
2. Configure chave de upload/assinatura conforme o guia oficial. Mantenha keystore e senhas fora do Git e de logs; use secrets do ambiente de build. Confira que `release` não está apontando para a chave de debug.
3. Revise `applicationId`, ícones, nome, permissões, links, configurações de rede, `minSdk`/`targetSdk` compatíveis e versão. Alinhe flags `--dart-define` ao ambiente; não embuta segredos de servidor no APK.
4. Gere `flutter build appbundle --release` para distribuição via Google Play ou `flutter build apk --release` quando o canal aceitar APK. Registre comando, commit, versão, variante, hash do artefato e destino.
5. Teste R8/minificação em release, especialmente plugins que usam reflexão/JNI. Acrescente regras de preservação apenas para classes comprovadamente necessárias, baseadas na documentação do plugin e no erro reproduzido.
6. Instale a variante release em dispositivo ou emulador representativo. Verifique início, login, cache, permissões, navegação, PDF, notificações e rede conforme o produto. Para AAB, use caminho de teste de bundle/loja apropriado, não assuma que testar APK cobre distribuição por bundle.

## Falhas comuns, segurança e aceite

Assinatura de debug, IDs de exemplo, `targetSdk` desatualizado, URL de teste, permissões excessivas e classes removidas por R8 impedem uma release confiável. Não exponha `key.properties` ou keystore. Aceite quando assinatura, versão e configuração estiverem verificadas e os fluxos críticos tiverem evidência em instalação release; declare plataforma/dispositivo não testado.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-android-release para gerar um AAB assinado para testes.”
- Indireta: “O app funciona em debug, mas o APK release não abre o cache.”
- Não ativar: “Crie um teste unitário para a regra de desconto.”

Referência: [guia oficial de build e release Android](https://docs.flutter.dev/deployment/android).
