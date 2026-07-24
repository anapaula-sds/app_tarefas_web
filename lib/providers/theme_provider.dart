import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // O aplicativo começa usando o tema claro.
  ThemeMode _themeMode = ThemeMode.light;

  // Permite consultar qual tema está ativo.
  ThemeMode get themeMode {
    return _themeMode;
  }

  // Retorna true quando o tema atual for escuro.
  bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }

  // Alterna entre o tema claro e o tema escuro.
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    // Avisa os widgets que estão observando este Provider
    // que o estado do tema mudou.
    notifyListeners();
  }
}