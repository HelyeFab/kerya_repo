import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/core/services/preferences_service.dart';
import 'package:Keyra/features/navigation/presentation/pages/navigation_page.dart';
import 'package:Keyra/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:Keyra/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:Keyra/features/auth/data/repositories/firebase_auth_repository.dart';
import 'package:Keyra/core/theme/app_theme.dart';
import 'package:Keyra/features/books/data/repositories/firestore_populator.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Wait for Firebase Auth to be ready
  await FirebaseAuth.instance.authStateChanges().first;

  // Initialize preferences service
  final preferencesService = await PreferencesService.init();

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

  runApp(MyApp(preferencesService: preferencesService));
}

class MyApp extends StatelessWidget {
  final PreferencesService preferencesService;

  const MyApp({
    super.key,
    required this.preferencesService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = AuthBloc(
          authRepository: FirebaseAuthRepository(),
        );
        bloc.add(const AuthBlocEvent.startAuthListening());
        return bloc;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Keyra',
        theme: AppTheme.lightTheme,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return state.when(
              initial: () => const Center(child: CircularProgressIndicator()),
              loading: () => const Center(child: CircularProgressIndicator()),
              authenticated: (uid) => const NavigationPage(),
              unauthenticated: () => OnboardingPage(preferencesService: preferencesService),
              error: (message) => Center(
                child: Text('Error: $message'),
              ),
            );
          },
        ),
      ),
    );
  }
}
