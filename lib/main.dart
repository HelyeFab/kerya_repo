import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:Keyra/core/presentation/bloc/language_bloc.dart';
import 'package:Keyra/features/navigation/presentation/pages/navigation_page.dart';
import 'package:Keyra/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:Keyra/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Keyra/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:Keyra/core/theme/app_theme.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/features/books/data/repositories/firestore_populator.dart';
import 'package:Keyra/features/home/presentation/pages/home_page.dart';
import 'package:Keyra/features/library/presentation/pages/library_page.dart';
import 'package:Keyra/features/create/presentation/pages/create_page.dart';
import 'package:Keyra/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:Keyra/features/profile/presentation/pages/profile_page.dart';
import 'firebase_options.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'splash_screen.dart';
import 'dart:async';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';

// Create a stream controller for dictionary initialization status
final _dictionaryInitController = StreamController<bool>.broadcast();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Initialize preferences service
  final preferencesService = await PreferencesService.init();

  // Initialize theme bloc
  final themeBloc = await ThemeBloc.create();

  // Initialize SharedPreferences for theme persistence
  final sharedPreferences = await SharedPreferences.getInstance();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Check if dictionary is already initialized
  final dictionaryService = DictionaryService();
  final isFirstLaunch = !dictionaryService.isDictionaryInitialized;
  debugPrint('Is first launch: $isFirstLaunch');

  // Initialize sample books if needed
  try {
    print('Attempting to populate sample books...');
    final populator = FirestorePopulator();
    
    // Try multiple times with increasing delays
    for (int i = 0; i < 3; i++) {
      try {
        final exists = await populator.areSampleBooksPopulated();
        if (!exists) {
          print('No sample books found, populating (attempt ${i + 1})...');
          await populator.populateWithSampleBooks();
          print('Successfully populated sample books');
          break;
        } else {
          print('Sample books already exist');
          break;
        }
      } catch (e) {
        print('Error in sample book initialization attempt ${i + 1}: $e');
        if (i < 2) {
          // Wait longer between each retry
          await Future.delayed(Duration(seconds: (i + 1) * 2));
        } else {
          rethrow;
        }
      }
    }
  } catch (e) {
    print('Error in sample book initialization: $e');
    // Continue with app initialization even if book population fails
  }

  // If it's first launch, start dictionary initialization in background
  if (isFirstLaunch) {
    debugPrint('Starting dictionary initialization in background...');
    dictionaryService.initialize().then((_) {
      debugPrint('Dictionary initialization complete');
      _dictionaryInitController.add(true);
    }).catchError((e) {
      debugPrint('Error initializing dictionary: $e');
      _dictionaryInitController.add(true); // Allow proceeding even on error
    });
  } else {
    // Dictionary already initialized
    _dictionaryInitController.add(true);
  }

  runApp(MyApp(
    preferencesService: preferencesService,
    isFirstLaunch: isFirstLaunch,
    themeBloc: themeBloc,
    dictionaryService: dictionaryService,
  ));
}

class MyApp extends StatelessWidget {
  final PreferencesService preferencesService;
  final bool isFirstLaunch;
  final ThemeBloc themeBloc;
  final DictionaryService dictionaryService;

  const MyApp({
    super.key,
    required this.preferencesService,
    required this.isFirstLaunch,
    required this.themeBloc,
    required this.dictionaryService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = AuthBloc(
              authRepository: FirebaseAuthRepository(),
            );
            bloc.add(const AuthBlocEvent.startAuthListening());
            return bloc;
          },
        ),
        BlocProvider.value(
          value: themeBloc,
        ),
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<SavedWordsRepository>(
            create: (context) => SavedWordsRepository(),
          ),
          RepositoryProvider<UserStatsRepository>(
            create: (context) => UserStatsRepository(),
          ),
          RepositoryProvider<DictionaryService>(
            create: (context) => dictionaryService,
          ),
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Keyra',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              home: StreamBuilder<bool>(
                stream: _dictionaryInitController.stream,
                initialData: !isFirstLaunch,
                builder: (context, snapshot) {
                  return SplashScreen(
                    isInitialized: snapshot.data ?? false,
                    isFirstLaunch: isFirstLaunch,
                    preferencesService: preferencesService,
                  );
                },
              ),
              routes: {
                '/home': (context) => const HomePage(),
                '/library': (context) => const LibraryPage(),
                '/create': (context) => const CreatePage(),
                '/dashboard': (context) => const DashboardPage(),
                '/profile': (context) => const ProfilePage(),
                '/onboarding': (context) => OnboardingPage(preferencesService: preferencesService),
                '/navigation': (context) => const NavigationPage(),
              },
            );
          },
        ),
      ),
    );
  }
}
