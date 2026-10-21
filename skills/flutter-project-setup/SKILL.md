---
name: flutter-project-setup
description: Prepara ou diagnostica o ambiente e a estrutura inicial de um projeto Flutter. Use ao criar um app, configurar Android ou outro alvo, instalar dependências ou estabelecer análise estática e testes iniciais.
---

# Preparar um projeto Flutter

## Objetivo

Deixar o projeto reproduzível no alvo solicitado, com ambiente identificado, dependências resolvidas, organização inicial proporcional ao escopo e verificações básicas executáveis.

## Quando usar

Ao iniciar um app, receber um repositório Flutter sem instruções de instalação ou configurar SDK, dispositivo, lints e comandos de qualidade.

## Quando não usar

Para corrigir uma funcionalidade isolada em projeto já configurado, sem evidência de problema de ambiente. Não recrie projetos ou arquivos nativos existentes para “padronizar” o código.

## Verificar antes

- Leia `pubspec.yaml`, `analysis_options.yaml`, `README`, estrutura `lib/`, `test/` e diretórios dos alvos; pergunte qual plataforma importa se não for inferível.
- Identifique versões **instaladas** com `flutter --version` e `dart --version`, restrições do projeto no `pubspec.yaml` e gerenciador de versão já adotado.
- Execute `flutter doctor -v` e `flutter devices`; se Android for alvo, confira SDK, licenças, JDK e emulador/aparelho. iOS requer macOS/Xcode.
- Confira se o projeto já tem configuração por ambiente e se há dados locais que não devem entrar no Git.

## Procedimento

1. Em projeto novo, crie com `flutter create nome_do_app` e selecione os alvos pedidos. Em projeto existente, preserve a estrutura e resolva somente as lacunas encontradas.
2. Alinhe a restrição de SDK e as dependências às APIs realmente usadas. Execute `flutter pub get`; registre conflitos de versão em vez de atualizar tudo sem necessidade.
3. Organize `lib/` por funcionalidades ou pelas fronteiras apresentação, domínio e dados conforme o tamanho do app. Crie interfaces e camadas somente quando houver dependências a separar.
4. Configure `analysis_options.yaml` a partir dos lints mantidos pelo projeto; habilite regras estritas gradualmente se a base existente exigir migração. Acrescente um teste de comportamento inicial somente se houver comportamento real.
5. Documente comandos para instalar, analisar, testar e executar cada alvo efetivamente configurado, inclusive variáveis não secretas necessárias.

## Boas práticas

Trate `pubspec.lock` conforme o tipo de projeto e a política existente. Separe configuração de desenvolvimento e produção; use `--dart-define` apenas para valores públicos de configuração, nunca como cofre de segredos. Mantenha `.gitignore` para arquivos locais e saídas de build.

## Erros comuns

- Confundir `flutter doctor` sem erros com execução comprovada no aparelho.
- Copiar a versão de outro app sem conferir restrições e plugins do projeto alvo.
- Adicionar pacotes, camadas ou plataformas sem caso de uso.

## Segurança e acessibilidade

Não inclua tokens, senhas, chaves privadas ou `.env` reais em código ou documentação. Escolha desde o início componentes Material/Cupertino acessíveis, tema centralizado e localização adequada ao público.

## Validação

Execute `flutter pub get`, `flutter analyze` e `flutter test` se o SDK estiver disponível; rode `flutter run -d ID` no alvo disponível quando a tarefa exigir prova de execução. Registre resultado, versão, alvo e verificações impossíveis com motivo. O [guia oficial da CLI](https://docs.flutter.dev/reference/flutter-cli) descreve os comandos.

## Critérios de aceitação

O projeto resolve dependências, analisa sem erros introduzidos, executa seus testes iniciais e possui instruções específicas para os alvos configurados. Pendências de SDK/dispositivo ficam explícitas, sem afirmação de validação física.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-project-setup para preparar meu novo app para Android.”
- **Indireta:** “Acabei de clonar este Flutter e não sei como instalar dependências nem verificar o emulador.”
- **Não ativa:** “Ajuste apenas a cor do botão Entrar no projeto que já compila.”
