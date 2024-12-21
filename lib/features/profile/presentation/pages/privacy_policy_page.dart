import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/ui_language/translations/ui_translations.dart';
import '../../../../core/ui_language/bloc/ui_language_bloc.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiLanguageBloc, UiLanguageState>(
      builder: (context, uiLanguageState) {
        final languageCode = uiLanguageState.languageCode;
        return SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    child: IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowLeft01,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 24.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_last_updated'] ?? 'Last updated: December 19, 2024',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_welcome'] ?? 'Welcome to Keyra\'s Privacy Policy',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_section_1'] ?? '1. Information We Collect',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_collect_info'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_collect_account'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_collect_preferences'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_collect_progress'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_collect_saved'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_section_2'] ?? '2. How We Use Your Information',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_use_info'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_use_personalize'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_use_track'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_use_improve'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_use_support'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_section_3'] ?? '3. Data Security',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_security'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_section_4'] ?? '4. Data Sharing',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          UiTranslations.translations[languageCode]?['privacy_policy_sharing'] ?? '',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
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
