---
name: flutter-state-management
description: Implementa ou revisa estado de interface Flutter, começando por ChangeNotifier e ListenableBuilder quando bastam. Use em telas com dados mutáveis, carregamento, falha, assinaturas e atualização da UI.
---

# Gerenciar estado de interface

## Objetivo

Tornar mudanças de dados previsíveis na UI, com estados de carregamento, sucesso e erro observáveis e ciclo de vida correto.

## Quando usar

Quando eventos da tela alteram dados compartilhados, chamadas assíncronas precisam refletir progresso ou reconstruções inesperadas causam falhas.

## Quando não usar

Para um valor local de widget que `setState` resolve com clareza. Não troque Provider, Riverpod, Bloc ou outra solução existente apenas por preferência desta skill.

## Verificar antes

Identifique dono e duração do estado, widgets consumidores, operações assíncronas, dependências atuais e como erros são expostos. Confira o pacote de estado já usado no projeto.

## Procedimento

1. Defina um modelo de estado pequeno: dados exibidos, `loading`/`busy`, erro recuperável e ações disponíveis. Decida quais valores são derivados em vez de armazenados em duplicidade.
2. Se `ChangeNotifier` for adequado, concentre transições em métodos do modelo, mantenha campos mutáveis privados quando possível e chame `notifyListeners()` depois de uma alteração consistente.
3. Na UI, use `ListenableBuilder` perto dos consumidores; limite a árvore reconstruída. Injete repositórios no modelo e mantenha `BuildContext` fora das regras de dados.
4. Para I/O, bloqueie ações duplicadas durante `busy`, use `try/catch/finally`, preserve entrada do usuário em falhas e descarte ou ignore respostas após `dispose` conforme o ciclo de vida.
5. Documente quem cria e descarta o notifier; remova listeners registrados manualmente.

Exemplo mínimo, apenas com o SDK Flutter (`package:flutter/foundation.dart` e `package:flutter/widgets.dart`):

```dart
class CounterModel extends ChangeNotifier {
  int _value = 0;
  int get value => _value;

  void increment() {
    _value++;
    notifyListeners();
  }
}

class CounterLabel extends StatelessWidget {
  const CounterLabel(this.model, {super.key});
  final CounterModel model;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: model,
    builder: (context, child) => Text('${model.value}'),
  );
}
```

O proprietário de `CounterModel` deve chamar `dispose()` ao encerrá-lo.

## Boas práticas

Prefira ações nomeadas, estados explícitos e testes de cada transição. Separe estado efêmero de tela de dados persistidos. Uma notificação informa mudança; ela não garante que a gravação ou a sincronização tenha terminado.

## Erros comuns

- Notificar antes de atualizar todos os campos relacionados.
- Criar `ChangeNotifier` em `build()` e perder estado a cada reconstrução.
- Exibir sucesso antes de `await` concluir ou engolir erro assíncrono.

## Segurança e acessibilidade

Não exponha tokens ou dados sensíveis por mensagens de erro. Anuncie carregamento/falha importantes e mantenha controles desabilitados com estado compreensível para tecnologia assistiva.

## Validação

Teste transições do modelo com dependências falsas, incluindo erro e dois toques rápidos; em widget test, confirme atualização do texto e preservação da entrada após falha. Execute `flutter analyze` e os testes aplicáveis.

## Critérios de aceitação

A UI mostra o mesmo estado que o modelo, operações concorrentes seguem a regra definida, falhas são recuperáveis e não restam listeners após descarte.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-state-management com ChangeNotifier nesta tela de pedidos.”
- **Indireta:** “O indicador de envio não acompanha a requisição e dois toques duplicam a ação.”
- **Não ativa:** “Mude apenas o texto estático do título.”
