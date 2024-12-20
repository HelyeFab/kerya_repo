import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class AcknowledgmentsPage extends StatelessWidget {
  const AcknowledgmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acknowledgments'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Special Thanks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildAcknowledgmentSection(
              'Icons',
              'HugeIcons - Beautiful and consistent icon set',
            ),
            _buildAcknowledgmentSection(
              'Animations',
              'Lottie Animation - "Free fox greetings Animation" by Solitudinem',
            ),
            _buildAcknowledgmentSection(
              'Fonts',
              'FascinateInline - Unique and stylish font for our branding',
            ),
            _buildAcknowledgmentSection(
              'Open Source Libraries',
              'Flutter and Dart communities for their amazing work',
            ),
            _buildAcknowledgmentSection(
              'Contributors',
              'All the developers who have contributed to this project',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAcknowledgmentSection(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
