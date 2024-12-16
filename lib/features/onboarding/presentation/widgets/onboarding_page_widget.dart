import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../models/onboarding_data.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPageWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingXl,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              image: DecorationImage(
                image: AssetImage(data.imagePath),
                fit: BoxFit.contain,
              ),
              boxShadow: AppSpacing.shadowMd(Theme.of(context).shadowColor),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          const Spacer(),
          Text(
            data.title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            data.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
