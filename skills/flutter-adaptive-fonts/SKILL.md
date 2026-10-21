---
name: flutter-adaptive-fonts
description: Implementa controles de aumento, redução e restauração de texto sem perder a escala do sistema. Use quando usuários precisam ajustar fonte no app e manter telas e diálogos utilizáveis até 200%.
---

# Ajustar tamanho das letras

## Objetivo

Oferecer controle acessível de leitura que se soma à preferência do sistema sem cortar conteúdo ou esconder ações.

## Quando usar

Ao adicionar controles A+/A−/restaurar ou corrigir telas que ignoram escala de texto do aparelho.

## Quando não usar

Para alterar só a hierarquia tipográfica de um título. Não reduza nem desative a escala do sistema para eliminar overflow.

## Verificar antes

Leia como `MediaQuery.textScalerOf(context)` chega ao app, `TextTheme`, overlays/diálogos, persistência de preferências e versões de Flutter usadas. Defina com o produto o intervalo e se o ajuste adicional deve sobreviver ao reinício.

## Procedimento

1. Represente a escolha como fator adicional limitado e configurável, por exemplo 1,0 a 2,0; a opção “restaurar” volta a 1,0 **do aparelho**, não a texto sem escala.
2. Componha o `TextScaler` do sistema com o fator escolhido no ponto que engloba telas e rotas. Preserve a curva não linear do sistema aplicando o fator ao resultado de `system.scale(fontSize)`; evite substituir a escala por `TextScaler.linear` fixo.
3. Crie botões com rótulos como “Aumentar letras”, “Diminuir letras” e “Restaurar tamanho do aparelho”; desabilite ações no limite e anuncie o nível atual sem duplicar a leitura.
4. Corrija layouts que quebram: permita quebra de linha, rolagem de formulários/diálogos, `Wrap` para controles e adaptação de navegação. Evite alturas fixas em áreas com texto.
5. Se persistência for requisito, salve somente o fator adicional, recupere-o no início e mantenha a escolha anterior se a escrita falhar.

## Boas práticas

Escolha passos compreensíveis e limites documentados. Mantenha ícones e alvos de toque acessíveis. Avalie também gráficos, chips, mensagens de erro e diálogos fora da tela principal.

O [exemplo de escala e controles](examples/adaptive_fonts_demo.dart) é um `main.dart` executável que preserva a curva do sistema. Depende somente do SDK Flutter com `material.dart`; copie para `lib/main.dart` de um projeto Flutter de teste. Ele mantém o fator adicional apenas durante a sessão.

## Erros comuns

- Aplicar o fator duas vezes em widgets internos.
- Usar `textScaleFactor` antigo como fonte principal de verdade para escala não linear.
- Passar teste em uma tela e deixar popup ou navegação cortados.

## Segurança e acessibilidade

Não esconda aviso, confirmação ou campo obrigatório sob texto aumentado. Guarde a preferência separada de credenciais e ofereça recuperação clara quando não puder carregá-la.

## Validação

Em widget tests, simule escalas de sistema distintas, confirme que “restaurar” preserva cada uma e verifique 100% e 200% em larguras compacta/ampla e diálogos. Verifique overflow, foco e rolagem com teclado aberto; faça percurso manual no dispositivo disponível.

Para o exemplo, execute `flutter analyze` e `flutter run` no projeto de teste e abra o diálogo após chegar a 200%. O exemplo não foi compilado neste repositório porque Flutter/Dart não estão instalados no ambiente de criação.

## Critérios de aceitação

Os três controles funcionam nos limites, a escala do sistema é preservada, os textos alcançam 200% adicional quando configurado e as jornadas principais seguem utilizáveis sem cortes. Persistência, se prometida, é testada após reinício.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-adaptive-fonts para incluir A+, A− e restaurar até 200%.”
- **Indireta:** “A pessoa aumenta a letra no celular, mas meu app ignora isso e os diálogos cortam texto.”
- **Não ativa:** “Troque o peso do título principal de normal para semibold.”
