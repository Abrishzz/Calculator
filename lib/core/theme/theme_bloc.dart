import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class LoadThemePreferenceEvent extends ThemeEvent {}


class ThemeState {
  final ThemeMode themeMode;
  ThemeState(this.themeMode);
}


class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeState(ThemeMode.dark)) {
    on<LoadThemePreferenceEvent>(_loadThemePreference);
    on<ToggleThemeEvent>(_toggleTheme);
  }

  Future<void> _loadThemePreference(
      LoadThemePreferenceEvent event, Emitter<ThemeState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? true; 
    emit(ThemeState(isDarkMode ? ThemeMode.dark : ThemeMode.light));
  }

  Future<void> _toggleTheme(
      ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    final newMode =
        state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(ThemeState(newMode));

    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newMode == ThemeMode.dark);
  }
}
