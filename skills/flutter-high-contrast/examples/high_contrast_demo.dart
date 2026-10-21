import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const HighContrastDemo());

ThemeData contrastTheme(bool enabled) {
  const darkBlue = Color(0xFF003366);
  final scheme = ColorScheme.fromSeed(
    seedColor: enabled ? darkBlue : const Color(0xFF386641),
  ).copyWith(
    primary: enabled ? darkBlue : const Color(0xFF386641),
    onPrimary: Colors.white,
    surface: Colors.white,
    onSurface: enabled ? Colors.black : const Color(0xFF202020),
    outline: enabled ? Colors.black : const Color(0xFF666666),
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(borderSide: BorderSide(color: scheme.outline)),
      enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: scheme.outline)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
    ),
  );
}

class HighContrastDemo extends StatefulWidget {
  const HighContrastDemo({super.key});

  @override
  State<HighContrastDemo> createState() => _HighContrastDemoState();
}

class _HighContrastDemoState extends State<HighContrastDemo> {
  final _preferences = SharedPreferencesAsync();
  bool _enabled = false;
  bool _ready = false;
  bool _busy = true;
  String? _message;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!_busy) setState(() => _busy = true);
    try {
      final saved = await _preferences.getBool('high_contrast') ?? false;
      if (!mounted) return;
      setState(() {
        _enabled = saved;
        _ready = true;
        _message = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _message = 'Não foi possível abrir a preferência. Tente novamente.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save(bool next) async {
    if (_busy || !_ready) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await _preferences.setBool('high_contrast', next);
      if (mounted) setState(() => _enabled = next);
    } catch (_) {
      if (mounted) {
        setState(() => _message =
            'Não foi possível salvar. O contraste anterior foi mantido.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: contrastTheme(_enabled),
        home: Scaffold(
          appBar: AppBar(title: const Text('Preferências de leitura')),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                SwitchListTile(
                  title: const Text('Alto contraste'),
                  value: _enabled,
                  onChanged: _ready && !_busy ? _save : null,
                ),
                if (!_ready && !_busy)
                  TextButton(
                    onPressed: _load,
                    child: const Text('Tentar novamente'),
                  ),
                if (_message != null)
                  Semantics(liveRegion: true, child: Text(_message!)),
                const Text('Leia as informações com conforto.'),
                const SizedBox(height: 16),
                const TextField(decoration: InputDecoration(labelText: 'Código')),
              ],
            ),
          ),
        ),
      );
}
