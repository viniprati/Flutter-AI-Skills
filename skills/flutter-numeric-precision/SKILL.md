---
name: flutter-numeric-precision
description: Escolhe representação e arredondamento corretos para dinheiro, medidas e quantidades em Dart/Flutter. Use quando somas, rateios ou comparações com double precisam ser exatos e auditáveis.
---

# Precisão numérica

## Objetivo e acionamento

Evite diferença de centavos, frações perdidas e totais incoerentes. Use em preço, saldo, medição, rateio, percentuais ou qualquer quantidade cuja menor unidade e regra de arredondamento sejam parte do requisito. Não ative para gráfico que apenas exibe valores já calculados corretamente.

## Antes de alterar

- Defina unidade mínima (centavo, grama, milissegundo), escala, faixa máxima e política de arredondamento contratada com backend e produto.
- Confira representação recebida/enviada na API, formato persistido e separador decimal do locale. Determine se o servidor usa inteiros, decimal textual ou ponto flutuante.
- Identifique operações que exigem conservação de soma e tratamento de sobras.

## Procedimento

1. Para valores discretos, converta na borda de entrada e use `int` na regra. Nomeie o tipo/campo pela unidade (`precoCentavos`, `pesoGramas`). Para precisão decimal maior, escolha biblioteca decimal adequada ao projeto e documente a escala; não multiplique `double` e arredonde em cada etapa sem regra.
2. Analise entrada textual sem depender de `double.parse` para dinheiro. Valide locale e número de casas; rejeite fração menor que a unidade admitida ou arredonde conforme política explícita.
3. Calcule totais e comparações na unidade inteira. Faça o arredondamento apenas na fronteira necessária e distribua o resto de forma determinística, sem perder ou criar unidades.
4. Serialize na unidade exigida pelo contrato e converta para exibição localizada apenas na UI. Teste ida e volta para não trocar reais por centavos nem quilogramas por gramas.

Exemplo Dart puro de rateio igual com conservação e critério estável de desempate:

```dart
List<int> dividirCentavos(int total, int partes) {
  if (total < 0 || partes <= 0) throw ArgumentError('Entrada inválida.');
  final base = total ~/ partes;
  final resto = total % partes;
  return List<int>.generate(partes, (i) => base + (i < resto ? 1 : 0));
}
```

`dividirCentavos(100, 3)` resulta em `[34, 33, 33]`; teste também `0`, `1`, muitos destinatários e o maior total permitido pelo contrato.

## Práticas e problemas comuns

- `0.1 + 0.2` em binário não é base segura para igualdade decimal exata. `toStringAsFixed` altera a apresentação, não a precisão das contas anteriores.
- Arredondar cada linha e depois somar pode divergir de somar e arredondar uma vez; estabeleça qual total é a referência.
- Não misture unidade base, percentual (0–1) e pontos percentuais (0–100) no mesmo campo.
- Evite converter `NaN`, infinito e valores negativos sem validação.

## Validação e critérios de aceitação

- Teste fronteiras da escala, zero, valores negativos, máximos, empate de restos e `sum(saídas) == entrada`.
- Teste serialização, leitura e formatação para `pt_BR` sem depender de `double` como fonte de verdade.
- Aceite quando a unidade está explícita em cada fronteira, o arredondamento é documentado e nenhuma operação viola os invariantes de soma e faixa.

## Cenários de ativação — especificações ainda não executadas em agente

- **Direta:** “Use flutter-numeric-precision para corrigir os centavos do carrinho.”
- **Indireta:** “O rateio de 100 centavos por três pessoas está perdendo um centavo.”
- **Não ativar:** “Mostre o valor total já calculado em um card com fonte maior.”
