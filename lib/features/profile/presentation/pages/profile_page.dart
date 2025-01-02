import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Keyra/core/widgets/keyra_gradient_background.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Keyra/core/theme/color_schemes.dart';
import 'package:Keyra/core/theme/bloc/theme_bloc.dart';
import 'package:Keyra/core/ui_language/widgets/ui_language_selector_modal.dart';
import 'package:Keyra/core/ui_language/translations/ui_translations.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
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
          title: Text(UiTranslations.of(context).translate('logout')),
          content: Text(UiTranslations.of(context).translate('logout_confirm')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(UiTranslations.of(context).translate('cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(UiTranslations.of(context).translate('logout')),
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

    return KeyraGradientBackground(
      gradientColor: AppColors.controlPurple,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: user.photoURL != null
                            ? NetworkImage(user.photoURL!)
                            : null,
                        child: user.photoURL == null
                            ? Text(
                                user.email?.substring(0, 1).toUpperCase() ?? 'U',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.displayName ?? user.email ?? 'User',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      if (user.email != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          user.email!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Settings Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          UiTranslations.of(context).translate('settings'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.sectionTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedMoon,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('dark_mode')),
                        trailing: BlocBuilder<ThemeBloc, ThemeState>(
                          builder: (context, state) {
                            return Switch(
                              value: state.themeMode == ThemeMode.dark,
                              onChanged: (bool value) {
                                context.read<ThemeBloc>().add(const ThemeEvent.toggleTheme());
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
                        title: Text(UiTranslations.of(context).translate('notifications')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedTranslate,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('app_language')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _showLanguageDialog(context),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Information Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          UiTranslations.of(context).translate('information'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.sectionTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedClipboard,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('version')),
                        trailing: const Text('1.0.0'),
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedStar,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('acknowledgments')),
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
                        title: Text(UiTranslations.of(context).translate('privacy_policy')),
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
                        title: Text(UiTranslations.of(context).translate('terms_of_service')),
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
                        title: Text(UiTranslations.of(context).translate('developer')),
                        subtitle: const Text('Emmanuel Fabiani'),
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedMessage01,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('contact_us')),
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
              ),

              const SizedBox(height: 16),

              // Socials Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          UiTranslations.of(context).translate('socials'),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: AppColors.sectionTitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedTelegram,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('chat_with_friends')),
                        subtitle: Text(UiTranslations.of(context).translate('improve_language_skills')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          const url = 'https://t.me/keyra_community';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedInstagram,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('instagram')),
                        subtitle: Text(UiTranslations.of(context).translate('discover_learning_tips')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          const url = 'https://instagram.com/keyra_reader';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                      ListTile(
                        leading: HugeIcon(
                          icon: HugeIcons.strokeRoundedTiktok,
                          color: iconColor,
                          size: 24.0,
                        ),
                        title: Text(UiTranslations.of(context).translate('tiktok')),
                        subtitle: Text(UiTranslations.of(context).translate('fun_language_content')),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          const url = 'https://tiktok.com/@keyra_reader';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
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
