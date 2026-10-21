---
name: flutter-high-contrast
description: Implementa tema de alto contraste em Flutter com cores semânticas, persistência da preferência e testes de legibilidade. Use ao melhorar contraste visual de textos, controles, estados e gráficos.
---

# Implementar alto contraste

## Objetivo

Permitir alternar para um tema legível e consistente, mantendo estados compreensíveis e a preferência restaurável.

## Quando usar

Quando há pedido de alto contraste, dificuldade de leitura por baixo contraste ou necessidade de um modo visual acessível em várias telas.

## Quando não usar

Para trocar uma cor de marca isolada ou criar modo escuro sem requisito de contraste. Não pinte widgets individualmente enquanto deixa o tema inconsistente.

## Verificar antes

Inventarie `ThemeData`, `ColorScheme`, `ThemeExtension`, fundos reais, imagens, gráficos e estados; identifique armazenamento local já usado e política de tema do sistema.

## Procedimento

1. Defina pares semânticos para superfícies, texto, botões, erros, foco, contornos e seleção em tema normal e alto contraste. Centralize em `ColorScheme`/`ThemeData`; reserve `ThemeExtension` para cores específicas que não cabem nos papéis padrão.
2. Meça as **cores finais renderizadas**, inclusive transparência sobre fundo: almeje pelo menos 4,5:1 para texto comum, 3:1 para texto grande e 3:1 para componentes/elementos gráficos essenciais conforme [WCAG 2.2](https://www.w3.org/TR/WCAG22/#contrast-minimum) e [contraste não textual](https://www.w3.org/TR/WCAG22/#non-text-contrast).
3. Dê a estados também texto, ícone, forma ou marca visível. Em gráficos, mantenha valores, legenda e resumo textual; não dependa da cor da fatia ou barra.
4. Exponha controle com rótulo/estado acessível. Salve a escolha no armazenamento adequado a preferência não sensível; se falhar, mantenha o estado anterior e ofereça nova tentativa.
5. Revise campos, diálogos, navegação, desabilitados e foco antes de propagar a mudança.

## Boas práticas

Teste contraste da combinação usada por cada componente, não só de uma tabela de cores. Mantenha tema sincronizado em rotas e overlays. Não altere regras de negócio para construir o tema.

O [exemplo de tema persistido](examples/high_contrast_demo.dart) é um `main.dart` executável. Requer o SDK Flutter e `shared_preferences` (`flutter pub add shared_preferences`); copie para `lib/main.dart` de um projeto de teste. Ele demonstra troca centralizada de tema, restauração e falha de gravação, mas não comprova contraste de todas as telas de outro app.

## Erros comuns

- Afirmar “tema WCAG” apenas por ter paleta escura.
- Verificar texto normal e esquecer bordas de campos, estado de foco e gráficos.
- Atualizar a UI antes de confirmar persistência e depois perder a escolha sem aviso.

## Segurança e acessibilidade

Não use apenas vermelho/verde para erro/sucesso; mantenha foco perceptível e alvos de toque. Evite registrar preferências com dados pessoais ou arquivos de credenciais.

## Validação

Teste pares de luminância nos dois temas, persistência após reinício e falha de gravação. Faça widget tests de telas representativas com 200% de texto e teste manual em dispositivo/monitor com diferentes condições de luz. Testes de paleta não certificam toda a interface.

Para o exemplo, execute `flutter analyze`, `flutter run` e reinicie o aplicativo para conferir a preferência. O exemplo não foi compilado neste repositório porque Flutter/Dart não estão instalados no ambiente de criação.

## Critérios de aceitação

Alternância e restauração funcionam; pares essenciais atendem aos limites definidos, estados não dependem só de cor e telas críticas seguem legíveis com fonte ampliada. Limites não testados ficam declarados.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-high-contrast para implementar um tema acessível no app.”
- **Indireta:** “Os textos e bordas somem para usuários com baixa visão; quero um controle de contraste.”
- **Não ativa:** “Mude a cor decorativa deste banner sem criar tema alternativo.”
