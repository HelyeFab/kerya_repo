import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:Keyra/features/auth/presentation/bloc/auth_bloc.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String _formatErrorMessage(String message) {
    // Convert Firebase error messages to user-friendly messages
    if (message.contains('[firebase_auth/weak-password]')) {
      return 'Please choose a stronger password (at least 6 characters)';
    } else if (message.contains('[firebase_auth/email-already-in-use]')) {
      return 'This email is already registered. Please try logging in instead';
    } else if (message.contains('[firebase_auth/invalid-email]')) {
      return 'Please enter a valid email address';
    } else if (message.contains('[firebase_auth/network-request-failed]')) {
      return 'Network error. Please check your internet connection';
    }
    // Default case: clean up the technical error message
    return message.replaceAll(RegExp(r'\[.*?\]'), '').trim();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthBlocEvent.emailSignUpRequested(
              email: _emailController.text,
              password: _passwordController.text,
              name: _nameController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
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
                if (state.maybeWhen(
                  error: (message) => true,
                  orElse: () => false,
                ))
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      state.maybeWhen(
                        error: (message) => _formatErrorMessage(message),
                        orElse: () => '',
                      ),
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(
                      HugeIcons.strokeRoundedAddTeam,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(
                      HugeIcons.strokeRoundedMailAtSign01,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(
                      HugeIcons.strokeRoundedLockPassword,
                      color: Colors.black,
                      size: 24.0,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword 
                          ? HugeIcons.strokeRoundedMonocle01
                          : HugeIcons.strokeRoundedView,
                        color: Colors.black,
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
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: state.maybeWhen(
                    loading: () => null,
                    orElse: () => _onRegisterPressed,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(
                    HugeIcons.strokeRoundedUser,
                    size: 24.0,
                  ),
                  label: state.maybeWhen(
                    loading: () => const CircularProgressIndicator(),
                    orElse: () => const Text('Register'),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<AuthBloc>().add(
                        const AuthBlocEvent.googleSignInRequested(),
                      ),
                  icon: const Icon(Icons.login),
                  label: const Text('Sign up with Google'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
