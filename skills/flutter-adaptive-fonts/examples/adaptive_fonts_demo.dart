import 'package:flutter/material.dart';

void main() => runApp(const AdaptiveFontsDemo());

/// Multiplica a saída do sistema, inclusive quando sua escala não é linear.
class AdditionalTextScaler extends TextScaler {
  const AdditionalTextScaler(this.system, this.factor);

  final TextScaler system;
  final double factor;

  @override
  double scale(double fontSize) => system.scale(fontSize) * factor;

  @override
  double get textScaleFactor => scale(14) / 14;

  @override
  bool operator ==(Object other) =>
      other is AdditionalTextScaler &&
      other.system == system &&
      other.factor == factor;

  @override
  int get hashCode => Object.hash(system, factor);
}

class AdaptiveFontsDemo extends StatefulWidget {
  const AdaptiveFontsDemo({super.key});

  @override
  State<AdaptiveFontsDemo> createState() => _AdaptiveFontsDemoState();
}

class _AdaptiveFontsDemoState extends State<AdaptiveFontsDemo> {
  double _factor = 1;

  @override
  Widget build(BuildContext context) => MaterialApp(
        builder: (context, child) {
          final systemMedia = MediaQuery.of(context);
          return MediaQuery(
            data: systemMedia.copyWith(
              textScaler: AdditionalTextScaler(systemMedia.textScaler, _factor),
            ),
            child: child ?? const SizedBox.shrink(),
          );
        },
        home: Scaffold(
          appBar: AppBar(title: const Text('Leitura ajustável')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Diminuir letras',
                      onPressed: _factor > 1
                          ? () => setState(() => _factor -= 0.25)
                          : null,
                      icon: const Icon(Icons.text_decrease),
                    ),
                    Semantics(
                      liveRegion: true,
                      child: Text('${(_factor * 100).round()}% do aparelho'),
                    ),
                    IconButton(
                      tooltip: 'Aumentar letras',
                      onPressed: _factor < 2
                          ? () => setState(() => _factor += 0.25)
                          : null,
                      icon: const Icon(Icons.text_increase),
                    ),
                    IconButton(
                      tooltip: 'Restaurar tamanho do aparelho',
                      onPressed: _factor > 1
                          ? () => setState(() => _factor = 1)
                          : null,
                      icon: const Icon(Icons.restart_alt),
                    ),
                  ],
                ),
                const Text('Este texto preserva a escala configurada no sistema.'),
                TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      scrollable: true,
                      title: const Text('Detalhes'),
                      content: const Text('O ajuste também alcança diálogos.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  ),
                  child: const Text('Abrir diálogo'),
                ),
              ],
            ),
          ),
        ),
      );
}
