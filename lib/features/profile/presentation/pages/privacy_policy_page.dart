import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                    ),
                  ),
                  child: IconButton(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedArrowLeft01,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 24.0,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '''
Last updated: December 19, 2024

Welcome to Keyra's Privacy Policy. This document outlines how we collect, use, and protect your personal information.

1. Information We Collect

We collect information that you provide directly to us, including:
• Account information (email, name)
• Learning preferences
• Study progress and statistics
• Saved words and flashcards

2. How We Use Your Information

We use the collected information to:
• Personalize your learning experience
• Track your progress
• Improve our services
• Provide customer support

3. Data Security

We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.

4. Data Sharing

We do not sell your personal information to third parties. We may share your information only in the following circumstances:
• With your consent
• To comply with legal obligations
• To protect our rights and safety

5. Your Rights

You have the right to:
• Access your personal information
• Correct inaccurate data
• Request deletion of your data
• Opt-out of certain data collection

6. Changes to This Policy

We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

7. Contact Us

If you have any questions about this Privacy Policy, please contact us at:
support@keyra.app

8. Children's Privacy

Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13.

9. International Data Transfers

Your information may be transferred to and processed in countries other than your country of residence.

10. Cookies and Tracking

We use cookies and similar tracking technologies to improve your experience on our platform.
''',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
