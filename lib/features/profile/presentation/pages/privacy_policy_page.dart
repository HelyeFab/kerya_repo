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
                          UiTranslations.translations[languageCode]?['privacy_policy_content'] ?? UiTranslations.translations['en']?['privacy_policy_content'] ?? '',
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
