---
name: flutter-responsive-layout
description: Adapta layouts Flutter a larguras, orientação, teclado e ampliação de texto. Use quando telas apresentam overflow, navegação inadequada ou campos ocultos em celulares, tablets e janelas maiores.
---

# Adaptar layouts a espaço disponível

## Objetivo

Manter conteúdo e ações utilizáveis em telas compactas e ampliadas, inclusive com teclado virtual e texto escalado.

## Quando usar

Ao criar telas para mais de uma largura ou corrigir `RenderFlex overflow`, corte de conteúdo e formulários cobertos pelo teclado.

## Quando não usar

Para modificar apenas cores ou dados de uma tela cujo layout já se adapta. Não crie breakpoints sem diferença real de composição.

## Verificar antes

Observe as constraints no local do problema, `MediaQuery.sizeOf`, `MediaQuery.viewInsetsOf`, `LayoutBuilder`, orientação, SafeArea e widgets de rolagem existentes. Identifique larguras alvo e escalas de fonte.

## Procedimento

1. Reproduza o problema na menor largura relevante, em janela larga, rotação e fonte ampliada. Registre onde o conteúdo deixa de caber.
2. Use `LayoutBuilder` para decisões com base no espaço **do componente**, `MediaQuery` para informações da janela/teclado, e `Flexible`/`Expanded` apenas onde a constraint é finita.
3. Troque linhas rígidas por composição vertical ou `Wrap` quando espaço/texto exigirem; limite larguras de leitura em telas amplas sem esticar formulários indefinidamente.
4. Coloque conteúdo longo em `ListView` ou `SingleChildScrollView`, mantenha ações alcançáveis e confira o comportamento com `viewInsets` quando o teclado abre.
5. Se a navegação mudar (barra inferior/rail), preserve destinos e ordem lógica entre os layouts.

## Boas práticas

Escolha breakpoints a partir da quebra observada de conteúdo. Prefira constraints e composição responsiva a coordenadas ou altura fixa. Trate textos, mensagens de erro e localização como conteúdo variável.

## Erros comuns

- Testar somente o retrato de um aparelho com texto padrão.
- Envolver tudo em `SingleChildScrollView` e perder desempenho/semântica em listas extensas.
- Usar `Expanded` dentro de eixo sem altura/largura limitada.

## Segurança e acessibilidade

Não esconda controles essenciais em layout compacto; foco por teclado e leitor de tela devem seguir ordem compreensível. Confirme que botões e erros continuam visíveis com teclado aberto e fonte até 200%.

## Validação

Faça widget tests com constraints compactas e amplas, texto em 100% e 200% e teclado simulado; verifique `tester.takeException()` e presença/acesso das ações. Percorra manualmente rotação e abertura do teclado no alvo disponível.

## Critérios de aceitação

Sem overflow ou ação inacessível nas condições definidas; conteúdo, mensagens e foco permanecem navegáveis. O relatório distingue testes simulados de execução em dispositivo.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-responsive-layout para adaptar cadastro a celular e tablet.”
- **Indireta:** “Ao abrir o teclado num celular pequeno, o botão Salvar some e aparece overflow.”
- **Não ativa:** “Corrija o cálculo da taxa no relatório sem mudar a tela.”
