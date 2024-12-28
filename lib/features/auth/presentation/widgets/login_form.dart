import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/auth/presentation/bloc/auth_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthBlocEvent.emailSignInRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      HugeIcons.strokeRoundedMailAtSign01,
                      color: Theme.of(context).primaryColor,
                      size: 24.0,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(
                      HugeIcons.strokeRoundedLockPassword,
                      color: Theme.of(context).primaryColor,
                      size: 24.0,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword 
                          ? HugeIcons.strokeRoundedMonocle01
                          : HugeIcons.strokeRoundedView,
                        color: Theme.of(context).primaryColor,
                        size: 24.0,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscurePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: state.maybeWhen(
                    loading: () => null,
                    orElse: () => _onLoginPressed,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: Icon(
                    HugeIcons.strokeRoundedLogin01,
                    color: Theme.of(context).primaryColor,
                    size: 24.0,
                  ),
                  label: state.maybeWhen(
                    loading: () => const CircularProgressIndicator(),
                    orElse: () => const Text('Login'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<AuthBloc>().add(
                        const AuthBlocEvent.googleSignInRequested(),
                      ),
                  icon: Icon(
                    HugeIcons.strokeRoundedLogin01,
                    color: Theme.of(context).primaryColor,
                    size: 24.0,
                  ),
                  label: const Text('Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
