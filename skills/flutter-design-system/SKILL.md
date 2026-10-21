---
name: flutter-design-system
description: Cria ou ajusta um sistema de design Flutter com Material 3, ColorScheme, ThemeData e componentes reutilizáveis. Use ao padronizar cores, tipografia, espaçamento, ícones e estados visuais entre telas.
---

# Criar um sistema de design

## Objetivo

Trocar decisões visuais dispersas por tokens e componentes consistentes que suportem temas e acessibilidade.

## Quando usar

Quando o app tem estilos duplicados ou precisa de identidade visual, tema claro/escuro ou componentes consistentes em várias telas.

## Quando não usar

Para um ajuste pontual de uma tela sem intenção de padronização. Não refaça a marca ou a experiência inteira por causa de um único botão.

## Verificar antes

Leia temas, `TextTheme`, `ColorScheme`, componentes compartilhados e guia visual existente. Levante plataformas, modos de brilho, escala de texto e requisitos de marca e contraste.

## Procedimento

1. Inventarie cores por **função** (`primary`, `onPrimary`, `surface`, `onSurface`, `error`, contornos), tipografia, espaçamentos, raios e estados. Identifique variações reais antes de criar tokens.
2. Construa `ColorScheme` e `ThemeData` com Material 3; defina `TextTheme`, `InputDecorationTheme` e temas de botões/navegação. Use `ThemeExtension` apenas para tokens que não cabem nos papéis padrão.
3. Substitua valores literais espalhados por `Theme.of(context)` e constantes de espaçamento; faça componentes reutilizáveis para padrões repetidos, com parâmetros de conteúdo e ação.
4. Estilize estados normal, pressionado, foco, erro, seleção, desabilitado e carregando. Mantenha significado além da cor por texto, ícone ou forma.
5. Migre telas representativas primeiro e confira se componentes antigos continuam legíveis antes de ampliar a mudança.

## Boas práticas

Use pares de `ColorScheme` para texto e fundo, em vez de presumir que uma cor de marca funciona em qualquer superfície. Reaproveite widgets nativos quando oferecem foco, semântica e estados prontos. Consulte o [guia oficial de temas](https://docs.flutter.dev/cookbook/design/themes).

## Erros comuns

- Misturar tokens semânticos com cores fixas em widgets.
- Usar o mesmo contraste para texto, contorno e controle sem medir o par real.
- Criar um componente genérico para cada widget simples, dificultando ajustes.

## Segurança e acessibilidade

Meça contraste em ambos os temas, inclusive erro, desabilitado e foco; garanta alvos de toque e escala de texto. Não codifique estado apenas em vermelho/verde.

## Validação

Revise telas críticas em brilho claro/escuro, foco por teclado e fontes ampliadas; use testes de widget para componentes compartilhados e teste de contraste dos pares usados. Execute `flutter analyze` e testes pertinentes.

## Critérios de aceitação

Os elementos recorrentes usam tema ou componente compartilhado, estados são distinguíveis sem cor e alterações de token propagam sem editar cada tela. Não há regressão visual relevante nas telas examinadas.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-design-system para criar ThemeData Material 3 para o app.”
- **Indireta:** “Cada formulário usa uma cor e um espaçamento diferente; quero consistência.”
- **Não ativa:** “Altere só a margem deste card de 8 para 12.”
