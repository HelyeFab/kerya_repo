import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/loading_animation.dart';
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
                  const Column(
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Keyra',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: 'FascinateInline',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  TabBar(
                    tabs: [
                      Tab(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedLogin01,
                          size: 24.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        text: 'Login',
                      ),
                      Tab(
                        icon: HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          size: 24.0,
                          color: Theme.of(context).primaryColor,
                        ),
                        text: 'Register',
                      ),
                    ],
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorWeight: 3.0,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                  const SizedBox(height: AppSpacing.lg),
                  const Center(child: LoadingAnimation(size: 48)),
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
