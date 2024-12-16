import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/keyra_logo.dart';
import '../../../navigation/presentation/pages/navigation_page.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthBlocEvent.startAuthListening());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (_) {
            // Navigate to NavigationPage when authenticated
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const NavigationPage(),
              ),
            );
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
          orElse: () {},
        );
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome to Keyra',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TabBar(
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.login),
                        text: 'Login',
                      ),
                      Tab(
                        icon: Icon(Icons.person_add),
                        text: 'Register',
                      ),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    indicatorColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        LoginForm(),
                        RegisterForm(),
                      ],
                    ),
                  ),
                  const Center(child: KeyraLogo(height: 48)),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
