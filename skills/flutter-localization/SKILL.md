---
name: flutter-localization
description: Implementa localização Flutter com foco em pt_BR, textos traduzíveis e formatos de data, número, moeda e unidade. Use ao adicionar idiomas ou eliminar strings e formatos fixos na interface.
---

# Localizar um app Flutter

## Objetivo

Fazer textos e formatos respeitarem a localidade escolhida, mantendo português brasileiro correto e preparando traduções sem alterar regras de negócio.

## Quando usar

Ao adicionar `pt_BR` ou outro idioma, traduzir telas, formatar valores para usuários ou corrigir componentes padrão exibidos em língua inesperada.

## Quando não usar

Para mudar somente a redação de uma mensagem em app monolíngue, se não houver pedido ou necessidade de internacionalização. Não traduza identificadores de API ou valores persistidos usados como contrato.

## Verificar antes

Leia `pubspec.yaml`, `l10n.yaml`, arquivos ARB, `MaterialApp`/`CupertinoApp`, pacotes de localização e locais onde datas/números são convertidos. Identifique idiomas suportados e localidade padrão do produto.

## Procedimento

1. Use o mecanismo oficial `flutter_localizations` e `gen-l10n` conforme a versão **do projeto**. Configure `flutter: generate: true`, diretório ARB e `supportedLocales`/`localizationsDelegates`; evite imports do antigo pacote sintético `flutter_gen` em projetos atuais.
2. Extraia textos visíveis, rótulos semânticos, erros, botões e plurais para ARB com chaves estáveis, descrição e placeholders tipados. Não monte frases traduzidas por concatenação.
3. Use `Locale('pt', 'BR')` para pt_BR e formatos apropriados de `intl` para datas, números e moeda. Mantenha valores de domínio em unidades canônicas; converta/forme somente na borda da interface.
4. Faça seleção ou resolução de locale respeitar o sistema, salvo exigência explícita do produto. Verifique textos longos e idiomas com direção diferente quando suportados.
5. Rode `flutter gen-l10n` e atualize imports para o local gerado do projeto. Consulte o [guia oficial](https://docs.flutter.dev/ui/internationalization) para configuração compatível.

## Boas práticas

Separe formatação de apresentação de parsing e armazenamento; um valor monetário não deve mudar no banco quando muda o idioma. Escreva mensagens completas para tradução, com pluralização e contexto. Preserve acentos e caracteres Unicode em fontes e exportações.

## Erros comuns

- Fixar `locale: pt_BR` e impedir escolha automática mesmo quando o app promete outros idiomas.
- Usar `toStringAsFixed` e troca manual de ponto/vírgula para toda formatação.
- Deixar tooltips, `Semantics.label` e mensagens de validação fora das traduções.

## Segurança e acessibilidade

Não traduza códigos de erro, IDs ou dados recebidos da API como se fossem mensagens confiáveis; mapeie-os para textos locais. Verifique leitura por leitor de tela, expansão de texto e campos de entrada numérica sem confundir formato exibido com valor enviado.

## Validação

Gere localizações, execute `flutter analyze` e testes. Em widget tests, altere locale, verifique mensagens, plural e layout; teste data, moeda e decimal pt_BR com valores conhecidos e comportamento de fallback.

## Critérios de aceitação

Todo texto visível das telas alteradas é traduzível, os componentes Flutter usam a localidade esperada e os formatos não corrompem valores do domínio. Idiomas suportados e limites de tradução ficam documentados.

## Cenários de ativação

Especificações de teste de ativação, ainda não executadas em agente compatível:

- **Direta:** “Use flutter-localization para adicionar pt_BR e inglês com ARB.”
- **Indireta:** “O calendário está em inglês e o preço aparece com ponto decimal para usuários brasileiros.”
- **Não ativa:** “Troque a frase ‘Bem-vindo’ por ‘Olá’ neste único widget sem adicionar idiomas.”
