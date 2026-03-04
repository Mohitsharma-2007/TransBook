import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_theme.dart';

enum AppThemeMode {
  light,
  dark,
  modernBusiness,
  minimalist
}

class ThemeState {
  final AppThemeMode mode;
  final ThemeData themeData;

  ThemeState({required this.mode, required this.themeData});
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const _themePrefKey = 'selected_theme_mode';
  final SharedPreferences _prefs;

  ThemeNotifier(this._prefs) : super(ThemeState(mode: AppThemeMode.light, themeData: AppTheme.lightTheme)) {
    _loadTheme();
  }

  void _loadTheme() {
    final savedThemeStr = _prefs.getString(_themePrefKey);
    if (savedThemeStr != null) {
      final mode = AppThemeMode.values.firstWhere(
        (e) => e.toString() == savedThemeStr,
        orElse: () => AppThemeMode.light,
      );
      setTheme(mode);
    }
  }

  void setTheme(AppThemeMode mode) {
    ThemeData newTheme;
    switch (mode) {
      case AppThemeMode.dark:
        newTheme = AppTheme.darkTheme;
        break;
      case AppThemeMode.modernBusiness:
        newTheme = AppTheme.modernBusinessTheme;
        break;
      case AppThemeMode.minimalist:
        newTheme = AppTheme.minimalistTheme;
        break;
      case AppThemeMode.light:
      default:
        newTheme = AppTheme.lightTheme;
        break;
    }

    state = ThemeState(mode: mode, themeData: newTheme);
    _prefs.setString(_themePrefKey, mode.toString());
  }
}

// Ensure SharedPreferences is initialized before creating this provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
