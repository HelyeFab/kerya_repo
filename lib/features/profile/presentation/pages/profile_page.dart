import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/core/ui_language/widgets/ui_language_selector_modal.dart';
import 'package:Keyra/core/ui_language/service/ui_translation_service.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../dictionary/presentation/pages/saved_words_page.dart';
import 'privacy_policy_page.dart';
import 'terms_of_service_page.dart';
import 'acknowledgments_page.dart';

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

  Future<void> _showLogoutConfirmation(BuildContext context) async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(UiTranslationService.translate(context, 'logout')),
          content: Text(UiTranslationService.translate(context, 'logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(UiTranslationService.translate(context, 'cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(UiTranslationService.translate(context, 'logout')),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      context.read<AuthBloc>().add(const AuthBlocEvent.signOutRequested());
    }
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    final theme = Theme.of(context);
    final iconColor = _getIconColor(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: iconColor,
            size: 24.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: HugeIcon(
              icon: HugeIcons.strokeRoundedLogout05,
              color: iconColor,
              size: 24.0,
            ),
            onPressed: () => _showLogoutConfirmation(context),
          ),
          const SizedBox(width: 16),
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
              title: Text(UiTranslationService.translate(context, 'saved words')),
              subtitle: Text(
                UiTranslationService.translate(context, 'saved words subtitle'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
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
                    UiTranslationService.translate(context, 'settings'),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedMoon,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'dark mode')),
                  trailing: BlocBuilder<ThemeBloc, ThemeState>(
                    builder: (context, state) {
                      return Switch(
                        value: state.themeMode == ThemeMode.dark,
                        onChanged: (bool value) {
                          context.read<ThemeBloc>().add(ThemeEvent.toggleTheme());
                        },
                      );
                    },
                  ),
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedNotificationBubble,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'notifications')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedTranslate,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'app language')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    UiTranslationService.translate(context, 'information'),
                    style: theme.textTheme.titleLarge,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedClipboard,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'version')),
                  trailing: const Text('1.0.0'),
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedStar,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'acknowledgments')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AcknowledgmentsPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedKnightShield,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'privacy policy')),
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
                  title: Text(UiTranslationService.translate(context, 'terms of service')),
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
                  title: Text(UiTranslationService.translate(context, 'developer')),
                  subtitle: const Text('Emmanuel Fabiani'),
                ),
                ListTile(
                  leading: HugeIcon(
                    icon: HugeIcons.strokeRoundedMessage01,
                    color: iconColor,
                    size: 24.0,
                  ),
                  title: Text(UiTranslationService.translate(context, 'contact us')),
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

  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const UiLanguageSelectorModal(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
    );
  }
}
