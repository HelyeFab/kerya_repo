// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/core/presentation/bloc/language_bloc.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:Keyra/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize services and blocs for testing
    final preferencesService = await PreferencesService.init();
    final themeBloc = await ThemeBloc.create();
    final languageBloc = await LanguageBloc.create();
    final dictionaryService = DictionaryService();
    
    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(
      preferencesService: preferencesService,
      isFirstLaunch: true,
      themeBloc: themeBloc,
      languageBloc: languageBloc,
      dictionaryService: dictionaryService,
    ));
  });
}
