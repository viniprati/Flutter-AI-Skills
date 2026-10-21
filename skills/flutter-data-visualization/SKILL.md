---
name: flutter-data-visualization
description: Implementa e revisa dashboards e gráficos Flutter com indicadores, séries temporais, barras, proporções, filtros e alternativas acessíveis. Use quando a tarefa pedir visualização de dados reais ou correção de gráficos existentes.
---

# Visualização de dados em Flutter

## Objetivo e escopo

Transforme dados verificados em indicadores e gráficos que permitam comparar valores sem distorcer escala, período ou significado. Use em dashboards, relatórios visuais e filtros de análise. Para gerar um arquivo PDF, use `flutter-pdf-reporting`; para corrigir somente consultas à API, use a skill de dados correspondente. Não ative para um gráfico decorativo sem dados.

## Antes de implementar

- Localize a fonte, o contrato, a unidade, a data de referência e as permissões de acesso. Distinga valor ausente, zero e dado parcial.
- Confirme quais períodos o produto oferece, o fuso para agrupar datas, a regra de arredondamento e se os filtros operam no cliente ou no servidor.
- Inspecione o sistema de design e os componentes de gráfico já adotados. Acrescente pacote só se a solução existente ou `CustomPaint`/widgets básicos não atenderem.

## Procedimento

1. Crie uma transformação de dados testável fora do widget: filtre por intervalo semiaberto `[início, fim)`, agrupe por data/categoria e calcule os indicadores usando a mesma população de registros. Declare unidades e denominadores.
2. Escolha a forma conforme a pergunta: série temporal para evolução; barras com base zero para comparar magnitudes; proporção circular apenas para poucas partes mutuamente exclusivas que somem o todo. Inclua valores negativos e lacunas explicitamente quando existirem.
3. Exiba título, período, unidade, fonte e data da última atualização. Dê estados distintos para carregando, vazio, erro e parcial. Não preencha intervalos sem dados com números inventados.
4. Aplique os mesmos filtros aos cartões, gráficos e tabela. Use uma escala comum para barras comparadas. Para tendência, preserve ordem cronológica e rótulos legíveis; permita rolagem ou detalhamento em tela estreita.
5. Ofereça resumo textual ou tabela com categoria, valor e unidade. Em pintura personalizada, use `Semantics` com descrição da série e valores relevantes; mantenha legenda textual. Cor deve ser redundante com texto, forma ou padrão.

Exemplo de barra comparativa para valores não negativos (dependência: Flutter SDK). `maximo` deve ser calculado para a mesma série e período. Forneça largura limitada ao widget, como a de um cartão:

```dart
import 'package:flutter/material.dart';

class BarraComparativa extends StatelessWidget {
  const BarraComparativa({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.maximo,
  });

  final String rotulo;
  final double valor;
  final double maximo;

  @override
  Widget build(BuildContext context) {
    final valido = valor.isFinite &&
        maximo.isFinite &&
        valor >= 0 &&
        maximo >= 0 &&
        valor <= maximo;
    final proporcao = !valido || maximo == 0
        ? 0.0
        : (valor / maximo).clamp(0.0, 1.0).toDouble();
    final texto = valido
        ? '$rotulo: ${valor.toStringAsFixed(1)} unidades'
        : '$rotulo: dado inválido';
    return Semantics(
      container: true,
      label: texto,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(texto),
            LayoutBuilder(builder: (context, constraints) {
              return SizedBox(
                height: 12,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * proporcao,
                    height: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
```

## Erros e cuidados

- Não derive taxa percentual sem expor numerador e denominador; trate denominador zero como indisponível.
- Não trunque eixo de barras sem indicação inequívoca; não compare períodos com durações diferentes como se fossem iguais.
- Não coloque dados pessoais em gráficos compartilháveis sem verificar autorização; agregue ou oculte quando necessário.
- Evite construir milhares de widgets/pontos de uma vez. Agregue para a resolução da tela e meça desempenho antes de otimizar.

## Validação e aceite

Teste agregação, fronteiras de período, fuso, ausência de dados, valor parcial e arredondamento. Confira que total dos segmentos corresponde ao total apresentado. Em tamanhos compactos e texto ampliado, verifique cortes e rolagem. Faça leitura com TalkBack/VoiceOver quando houver dispositivo; teste de semântica automatizado não substitui essa verificação. Aceite quando fonte, período, unidade e estado dos dados estiverem claros e cada gráfico tiver equivalente textual.

## Especificações de ativação (ainda não executadas em agente)

- Direta: “Use flutter-data-visualization para criar um dashboard de vendas por semana.”
- Indireta: “Quero comparar a evolução mensal e entender o total de cada categoria no app.”
- Não ativar: “Altere só a cor do ícone da barra de navegação.”

Referências: [práticas de desempenho Flutter](https://docs.flutter.dev/perf/best-practices) e [Semantics](https://api.flutter.dev/flutter/widgets/Semantics-class.html).
