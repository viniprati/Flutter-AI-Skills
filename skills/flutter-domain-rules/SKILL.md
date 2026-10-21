---
name: flutter-domain-rules
description: Extrai e implementa regras de negócio determinísticas fora dos widgets Flutter. Use em cálculos, limites, transições de estado e invariantes que precisam ser reutilizados e testados.
---

# Regras de domínio

## Objetivo e acionamento

Mantenha decisões de negócio verificáveis sem depender de `BuildContext`, widget ou transporte HTTP. Use ao criar ou corrigir cálculo, política de elegibilidade, transição de estado ou limite compartilhado. Não use para simples formatação visual ou disposição de componentes.

## Antes de alterar

- Escreva a regra em termos de entradas, saída, unidades, estados permitidos e erros. Confirme com o contrato do servidor se há concorrência ou autorização.
- Encontre usos atuais na UI, no repositório e no backend; identifique duplicações e números mágicos.
- Se quantidades fracionárias ou dinheiro forem envolvidos, escolha representação decimal/discreta antes do algoritmo.

## Procedimento

1. Modele estados e casos proibidos explicitamente. Evite que `null`, texto de botão ou cor representem estado de negócio.
2. Implemente função ou classe de domínio pura em `lib/domain/` (ou convenção equivalente). Receba parâmetros tipados, valide pré-condições e devolva resultado completo; não leia relógio ou armazenamento global dentro da função. Injete tempo quando ele for parte da regra.
3. Faça a UI apenas coletar entrada e renderizar o resultado; faça a camada de dados aplicar a mesma regra antes de persistir quando isso protege integridade. O servidor deve aplicar as regras que protegem dados compartilhados.
4. Escreva testes para limites, soma, estado inicial/final, entrada inválida e invariantes. Um cálculo de alocação, por exemplo, deve conservar o total e nunca produzir valor negativo nem exceder o pedido individual.
5. Faça migração incremental das chamadas existentes; mantenha testes de regressão dos casos que motivaram a mudança.

Exemplo Dart puro, independente de setor:

```dart
int saldoRestante({required int recebido, required Iterable<int> consumos}) {
  if (recebido < 0 || consumos.any((valor) => valor < 0)) {
    throw ArgumentError('Quantidades não podem ser negativas.');
  }
  final usado = consumos.fold<int>(0, (soma, valor) => soma + valor);
  if (usado > recebido) throw StateError('Consumo excede o recebido.');
  return recebido - usado;
}
```

## Práticas e problemas comuns

- Defina unidade no nome ou no tipo (`centavos`, `mililitros`, `unidades`) para evitar misturas.
- Não deixe uma validação apenas visual proteger dados; chamadas sem formulário também precisam obedecer à regra.
- Evite `DateTime.now()` escondido em regras testáveis e mutação do argumento de entrada.
- Não modele toda a aplicação com interfaces e casos de uso para uma única função simples; a separação deve reduzir acoplamento real.

## Validação e critérios de aceitação

- Rode `dart test`/`flutter test` conforme o projeto e `flutter analyze`; teste a regra sem iniciar widgets ou rede.
- Verifique a mesma decisão quando chamada pela tela e por outro fluxo de dados.
- Aceite quando entradas e invariantes são explícitos, falhas não deixam estado parcialmente atualizado e a regra funciona isoladamente em testes.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-domain-rules para tirar as regras de limite dos widgets.”
- **Indireta:** “O total muda dependendo da tela que salva o pedido.”
- **Não ativar:** “Centralize o formato de data usado nos títulos das telas.”
