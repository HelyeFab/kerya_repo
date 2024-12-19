import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_bloc.freezed.dart';
part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themePreferenceKey = 'theme_mode';
  final SharedPreferences _prefs;

  ThemeBloc(this._prefs) : super(ThemeState(themeMode: ThemeMode.system)) {
    on<ThemeEvent>((event, emit) {
      event.when(
        toggleTheme: () {
          final newMode = state.themeMode == ThemeMode.light
              ? ThemeMode.dark
              : ThemeMode.light;
          _saveThemeMode(newMode);
          emit(state.copyWith(themeMode: newMode));
        },
        setTheme: (ThemeMode mode) {
          _saveThemeMode(mode);
          emit(state.copyWith(themeMode: mode));
        },
      );
    });
    
    // Load saved theme immediately
    _loadSavedTheme();
  }

  static Future<ThemeBloc> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeBloc(prefs);
  }

  void _loadSavedTheme() {
    try {
      final savedMode = _prefs.getString(_themePreferenceKey);
      if (savedMode != null) {
        final themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
        add(ThemeEvent.setTheme(themeMode));
      }
    } catch (e) {
      debugPrint('Error loading theme: $e');
    }
  }

  void _saveThemeMode(ThemeMode mode) {
    try {
      _prefs.setString(_themePreferenceKey, mode == ThemeMode.dark ? 'dark' : 'light');
    } catch (e) {
      debugPrint('Error saving theme: $e');
    }
  }
}
