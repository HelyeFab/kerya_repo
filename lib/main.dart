import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Keyra/features/books/data/models/book_model.g.dart';
import 'package:Keyra/features/books/data/services/book_cache_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/badges/domain/repositories/badge_repository.dart';
import 'features/badges/data/repositories/mock_badge_repository.dart';
import 'features/badges/presentation/bloc/badge_bloc.dart';
import 'features/dictionary/data/repositories/saved_words_repository.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Keyra/features/dashboard/data/repositories/user_stats_repository.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:Keyra/core/presentation/bloc/language_bloc.dart';
import 'package:Keyra/core/ui_language/bloc/ui_language_bloc.dart';
import 'package:Keyra/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Keyra/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:Keyra/core/theme/app_theme.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/features/books/data/repositories/firestore_populator.dart';
import 'package:Keyra/features/library/presentation/pages/library_page.dart';
import 'package:Keyra/features/create/presentation/pages/create_page.dart';
import 'package:Keyra/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:Keyra/features/profile/presentation/pages/profile_page.dart';
import 'firebase_options.dart';
import 'package:Keyra/features/dictionary/data/services/dictionary_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'splash_screen.dart';
import 'dart:async';
import 'package:Keyra/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:Keyra/features/navigation/presentation/pages/navigation_page.dart';

// Create a stream controller for dictionary initialization status
final _dictionaryInitController = StreamController<bool>.broadcast();

class App extends StatelessWidget {
  final bool isFirstLaunch;
  final PreferencesService preferencesService;
  final DictionaryService dictionaryService;
  final Stream<bool> dictionaryInitStream;

  const App({
    super.key,
    required this.isFirstLaunch,
    required this.preferencesService,
    required this.dictionaryService,
    required this.dictionaryInitStream,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Keyra',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeState.themeMode,
          home: StreamBuilder<bool>(
            stream: dictionaryInitStream,
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
    );
  }
}

Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BookAdapter());
  final bookCacheService = BookCacheService();
  await bookCacheService.init();
}

void main() async {
  await initHive();
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Initialize preferences service
  final preferencesService = await PreferencesService.init();

  // Initialize theme bloc
  final themeBloc = await ThemeBloc.create();

  // Initialize language bloc
  final languageBloc = await LanguageBloc.create();

  // Initialize UI language bloc
  final prefs = await SharedPreferences.getInstance();
  final uiLanguageBloc = UiLanguageBloc(prefs);
  uiLanguageBloc.add(LoadSavedUiLanguageEvent());

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

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SavedWordsRepository>(
          create: (context) => SavedWordsRepository(),
        ),
        RepositoryProvider<BadgeRepository>(
          create: (context) => MockBadgeRepository(),
        ),
        RepositoryProvider<UserStatsRepository>(
          create: (context) => UserStatsRepository(),
        ),
        RepositoryProvider<DictionaryService>(
          create: (context) => dictionaryService,
        ),
        RepositoryProvider<BookCacheService>(
          create: (context) => BookCacheService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>.value(value: themeBloc),
          BlocProvider<LanguageBloc>.value(value: languageBloc),
          BlocProvider<UiLanguageBloc>.value(value: uiLanguageBloc),
          BlocProvider(
            create: (context) {
              final bloc = AuthBloc(
                authRepository: FirebaseAuthRepository(),
              );
              bloc.add(const AuthBlocEvent.startAuthListening());
              return bloc;
            },
          ),
          BlocProvider(
            create: (context) => BadgeBloc(
              badgeRepository: context.read<BadgeRepository>(),
              savedWordsRepository: context.read<SavedWordsRepository>(),
            ),
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
    ),
  );
}
