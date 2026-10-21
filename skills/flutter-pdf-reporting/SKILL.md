---
name: flutter-pdf-reporting
description: Gera e revisa relatórios PDF em Flutter a partir de dados reais, com totais, tabelas, paginação, fontes brasileiras, prévia e impressão. Use quando o aplicativo precisar exportar ou corrigir relatórios em PDF.
---

# Relatórios PDF em Flutter

## Objetivo e uso

Produza PDF reprodutível a partir de um recorte de dados identificado, com totais verificáveis. Use para exportação, prévia, compartilhamento e impressão. Não ative para exibir um PDF já pronto sem geração, nem trate um relatório gerencial como documento fiscal.

## Pré-requisitos

Confira dados e permissões, período, fuso, moeda/unidade, regras de totalização e política de dados pessoais. Examine dependências e licença das fontes. Se o projeto já usa `pdf` e `printing`, confirme APIs e compatibilidade com o SDK instalado antes de atualizar. `pubspec.yaml` deve declarar essas dependências e o asset TTF escolhido, com glifos usados em português brasileiro.

## Procedimento

1. Receba um modelo imutável do relatório, vindo da camada de domínio/dados, com data de emissão, filtros e marcação de valores ausentes. Não consulte rede durante a montagem de cada página.
2. Calcule totais antes de renderizar; use centavos inteiros ou tipo decimal conforme a regra do projeto. Se faltar preço, mostre subtotal parcial e contagem de itens sem preço, sem somá-los como zero.
3. Carregue TTF licenciada de `rootBundle` e passe a `pw.ThemeData.withFont`. Monte `pw.MultiPage` com cabeçalho, linhas e rodapé com `context.pageNumber`/`context.pagesCount`; use tabelas que possam se dividir entre páginas.
4. Gere bytes com `document.save()`. Faça a prévia com `PdfPreview(build: (format) => gerar(format))`; ofereça compartilhamento/impressão pelas APIs do `printing` conforme a plataforma. Capture falhas e permita nova tentativa sem perder filtros.
5. Indique origem, período, unidade e escopo do documento. Para dados sensíveis, valide autorização antes de criar/compartilhar; não grave PDF em local público por padrão.
6. Mantenha uma versão estruturada dos dados no aplicativo para tecnologia assistiva; visualização do PDF não garante que o arquivo exportado tenha estrutura acessível.

Trecho mínimo do núcleo, após adicionar `pdf` e uma fonte TTF ao projeto:

```dart
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> gerarRelatorio(
  PdfPageFormat formato,
  List<(String, int)> itens,
) async {
  final bytes = await rootBundle.load('assets/fonts/Regular.ttf');
  final fonte = pw.Font.ttf(bytes);
  final total = itens.fold<int>(0, (soma, item) => soma + item.$2);
  final documento = pw.Document();
  documento.addPage(pw.MultiPage(
    pageFormat: formato,
    theme: pw.ThemeData.withFont(base: fonte),
    footer: (ctx) => pw.Text('${ctx.pageNumber}/${ctx.pagesCount}'),
    build: (_) => [
      pw.Text('Relatório', style: pw.TextStyle(font: fonte, fontSize: 18)),
      pw.TableHelper.fromTextArray(
        headers: ['Item', 'Valor (centavos)'],
        data: [for (final item in itens) [item.$1, '${item.$2}']],
      ),
      pw.Text('Total: $total centavos'),
    ],
  ));
  return documento.save();
}
```

Substitua o formato em centavos por formatação `pt_BR` no produto; a unidade explícita no trecho impede ambiguidade. Não copie fontes sem verificar licença.

## Erros comuns, validação e aceite

Evite fonte padrão que perca acentos, tabelas cortadas, subtotal com preço faltante, geração duplicada a cada rebuild e travamento por volume excessivo. Limite explicitamente o volume de dados: o `maxPages` de `pw.MultiPage` não é verificado em release. Teste totais e filtros com entradas conhecidas; gere casos vazios, acentuados e de várias páginas. Inspecione visualmente o PDF exportado e abra/compartilhe/imprima nos dispositivos alvo. Um teste de bytes ou build não comprova essas ações nativas nem acessibilidade estrutural do PDF. Aceite quando números, glifos, paginação e ações verificadas correspondam à origem.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-pdf-reporting para exportar o relatório mensal em PDF.”
- Indireta: “Preciso imprimir os totais e a tabela que aparecem na tela de análise.”
- Não ativar: “Mostre uma imagem PNG de um comprovante existente.”

Referências: [MultiPage do pdf](https://pub.dev/documentation/pdf/latest/widgets/MultiPage-class.html), [TableHelper](https://pub.dev/documentation/pdf/latest/widgets/TableHelper/fromTextArray.html) e [PdfPreview do printing](https://pub.dev/documentation/printing/latest/printing/PdfPreview-class.html).
