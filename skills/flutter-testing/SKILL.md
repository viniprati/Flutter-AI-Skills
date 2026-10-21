---
name: flutter-testing
description: Planeja e implementa testes unitários, de widgets e de integração para aplicativos Flutter. Use para cobrir regras de negócio, formulários, estados, falhas e fluxos de navegação com testes independentes de produção.
---

# Testes Flutter

## Objetivo e ativação

Escolha o menor tipo de teste que comprove o comportamento pedido e implemente casos que detectem regressões reais. Use ao criar funcionalidade, corrigir bug ou ampliar cobertura. Não ative para uma revisão textual sem código ou para validar apenas o formato de uma skill.

## Pré-requisitos

Leia regra, contrato, dependências injetáveis, testes existentes e alvo de plataforma. Confirme `flutter_test` em `dev_dependencies`; para integração, confirme `integration_test` do SDK e dispositivo/emulador. Separe serviços externos por interface ou função injetada e use dados fictícios.

## Procedimento

1. Escreva uma matriz curta de cenários: caminho esperado, limites, entrada inválida, falha de rede/armazenamento e repetição. Faça cada teste afirmar resultado observável, não apenas que a função foi chamada.
2. Use teste unitário para cálculo/modelo puro; widget test para texto, foco, acessibilidade, estado e interação; integração para fluxo completo e plugin nativo. Mantenha testes de widget independentes de API de produção.
3. Para bug, reproduza primeiro a falha com um teste. Use relógio, repositório e cliente HTTP falsos quando necessário; evite `Future.delayed` e dependência de ordem entre testes.
4. Execute `flutter test` e `flutter analyze`. Rode integração com `flutter test integration_test -d ID_DO_DISPOSITIVO` no alvo configurado. Registre plataforma, comando e testes ignorados.

Exemplo unitário autocontido em `test/reserva_test.dart` (dependência: `flutter_test` do SDK):

```dart
import 'package:flutter_test/flutter_test.dart';

bool podeReservar({
  required int disponivel,
  required int solicitado,
}) => solicitado > 0 && solicitado <= disponivel;

void main() {
  test('aceita o limite e rejeita excesso ou quantidade inválida', () {
    expect(podeReservar(disponivel: 5, solicitado: 5), isTrue);
    expect(podeReservar(disponivel: 5, solicitado: 6), isFalse);
    expect(podeReservar(disponivel: 5, solicitado: 0), isFalse);
  });
}
```

Em código real, teste a função do domínio por import; o exemplo define tudo no mesmo arquivo para não depender de serviço ou dados privados.

## Falhas comuns, validação e aceite

Não confunda teste de widget em largura simulada com teste em aparelho. `integration_test` não interage com diálogos nativos de permissão ou notificações; use roteiro manual ou ferramenta de automação nativa para isso. Evite asserts só de snapshots frágeis, mocks que repetem a implementação e testes que consultam produção. Aceite quando os casos críticos tiverem asserções reproduzíveis, isolamento e resultado registrado; declare os cenários que exigem teste manual.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-testing para testar as regras de reserva e o formulário.”
- Indireta: “Essa correção volta a quebrar quando a API fica indisponível; proteja o fluxo.”
- Não ativar: “Escreva uma seção de créditos no README.”

Referências: [tipos de testes Flutter](https://docs.flutter.dev/testing/overview) e [testes de integração](https://docs.flutter.dev/testing/integration-tests).
