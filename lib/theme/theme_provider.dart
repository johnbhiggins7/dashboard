import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

/// Theme mode management for dashboard.
///
/// Manages three-state theme switching: System → Light → Dark → System.
/// Integrates with Forui theme system and persists user preference.
///
/// **Usage:**
/// ```dart
/// // In main.dart
/// ChangeNotifierProvider(
///   create: (_) => ThemeProvider(),
///   child: MaterialApp(themeMode: themeProvider.themeMode),
/// )
///
/// // In widgets
/// final provider = context.watch<ThemeProvider>();
/// provider.toggleThemeMode(); // Cycle through modes
/// provider.setThemeMode(ThemeMode.dark); // Direct setting
/// ```
///
/// **Integration:**
/// - Connects to DashboardHeader theme toggle button
/// - Works with Forui FThemes.zinc light/dark themes
/// - Defaults to system theme on first launch
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;
  static const _prefsKey = 'app.theme_mode';

  ThemeProvider({
    ThemeMode themeMode = ThemeMode.system,
  }) : _themeMode = themeMode;

  ThemeMode get themeMode => _themeMode;

  // Load persisted theme on startup
  void restorePersistedTheme() {
    // Fire and forget
    _loadPersistedTheme();
  }

  Future<void> _loadPersistedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_prefsKey);
      if (value == null) return;
      switch (value) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        case 'system':
        default:
          _themeMode = ThemeMode.system;
      }
      notifyListeners();
    } catch (e, st) {
      debugPrint('ThemeProvider: Failed to load theme preference: $e\n$st');
    }
  }

  void toggleThemeMode() {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = ThemeMode.light;
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.system;
        break;
    }
    notifyListeners();
    _persistTheme();
  }

  void setThemeMode(ThemeMode themeMode) {
    if (_themeMode != themeMode) {
      _themeMode = themeMode;
      notifyListeners();
      _persistTheme();
    }
  }

  Future<void> _persistTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = switch (_themeMode) {
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
        ThemeMode.system => 'system',
      };
      await prefs.setString(_prefsKey, value);
    } catch (e, st) {
      debugPrint('ThemeProvider: Failed to persist theme preference: $e\n$st');
    }
  }

  // Legacy compatibility methods
  @Deprecated('Use themeMode instead')
  Brightness get brightness {
    switch (_themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  @Deprecated('Use toggleThemeMode instead')
  void toggleBrightness() => toggleThemeMode();

  @Deprecated('Use setThemeMode instead')
  void setBrightness(Brightness brightness) {
    setThemeMode(
      brightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
    );
  }
}
