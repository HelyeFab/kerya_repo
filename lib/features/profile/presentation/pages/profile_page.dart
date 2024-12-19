import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../dictionary/presentation/pages/saved_words_page.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';

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

  Color _getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? AppColors.icon
        : AppColors.iconDark;
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    final theme = Theme.of(context);
    final iconColor = _getIconColor(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedLogout05,
              color: iconColor,
              size: 24.0,
            ),
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
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedAllBookmark,
                color: iconColor,
                size: 24.0,
              ),
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
                  secondary: HugeIcon(
                    icon: HugeIcons.strokeRoundedMoon,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: const Text('Dark Mode'),
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (bool value) {
                    context.read<ThemeBloc>().add(const ThemeEvent.toggleTheme());
                  },
                ),
                const Divider(),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedNotificationBubble,
                    color: iconColor,
                    size: 24.0,
                  ),
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
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedClipboard,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: const Text('Version'),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedKnightShield,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedBook03,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TermsOfServicePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedCode,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: const Text('Developer'),
                  subtitle: const Text('Emmanuel Fabiani'),
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedMessage01,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: const Text('Contact Us'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'keyra-reader@gmail.com',
                      queryParameters: {
                        'subject': 'Keyra App Feedback',
                      },
                    );
                    final String url = emailLaunchUri.toString();
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    }
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
