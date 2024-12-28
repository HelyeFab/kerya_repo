// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/core/presentation/bloc/language_bloc.dart';
import 'package:Keyra/core/ui_language/bloc/ui_language_bloc.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize services and blocs for testing
    final preferencesService = await PreferencesService.init();
    final themeBloc = await ThemeBloc.create();
    final languageBloc = await LanguageBloc.create();
    final dictionaryService = DictionaryService();
    final prefs = await SharedPreferences.getInstance();
    final uiLanguageBloc = UiLanguageBloc(prefs);
    
    // Build our app and trigger a frame
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<DictionaryService>(
            create: (context) => dictionaryService,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<LanguageBloc>.value(value: languageBloc),
            BlocProvider<UiLanguageBloc>.value(value: uiLanguageBloc),
          ],
          child: BlocBuilder<UiLanguageBloc, UiLanguageState>(
            builder: (context, uiLanguageState) {
              return UiTranslations(
                currentLanguage: uiLanguageState.languageCode,
                child: const MaterialApp(
                  home: SizedBox(), // Empty widget for testing
                ),
              );
            },
          ),
        ),
      ),
    );
  });
}
