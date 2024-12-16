import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../dictionary/presentation/pages/saved_words_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.maybeWhen(
          authenticated: (_) {
            final user = FirebaseAuth.instance.currentUser;
            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildProfileContent(context, user);
          },
          orElse: () => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthBlocEvent.signOutRequested());
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: user.photoURL != null
                        ? NetworkImage(user.photoURL!)
                        : null,
                    child: user.photoURL == null
                        ? Text(
                            user.email?.substring(0, 1).toUpperCase() ?? 'U',
                            style: theme.textTheme.headlineMedium,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.displayName ?? user.email ?? 'User',
                    style: theme.textTheme.titleLarge,
                  ),
                  if (user.email != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      user.email!,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Saved Words Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Saved Words'),
              subtitle: const Text('View your saved word definitions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedWordsPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Settings Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Settings',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.brightness_6),
                  title: const Text('Dark Mode'),
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (bool value) {
                    // TODO: Implement theme switching
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to notifications settings
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'About',
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('Version'),
                  trailing: Text('1.0.0'),
                ),
                ListTile(
                  leading: const Icon(Icons.policy),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // TODO: Navigate to terms of service
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
