import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
                  'Terms of Service',
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

Welcome to Keyra! These Terms of Service ("Terms") govern your use of our application and services.

1. Acceptance of Terms

By accessing or using Keyra, you agree to be bound by these Terms. If you do not agree to these Terms, do not use our services.

2. Changes to Terms

We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms on this page.

3. User Accounts

• You are responsible for maintaining the confidentiality of your account
• You must provide accurate and complete information
• You are responsible for all activities under your account
• You must notify us immediately of any unauthorized use

4. Intellectual Property Rights

• All content in Keyra is owned by us or our licensors
• You may not copy, modify, or distribute our content without permission
• Your user-generated content remains your property

5. Acceptable Use

You agree not to:
• Violate any laws or regulations
• Impersonate others
• Share inappropriate content
• Attempt to access restricted areas
• Interfere with the service's operation

6. Premium Features

• Some features may require payment
• Subscriptions auto-renew unless cancelled
• Refunds are subject to our refund policy
• Prices may change with notice

7. Termination

We may terminate or suspend your account if you violate these Terms.

8. Disclaimer of Warranties

The service is provided "as is" without warranties of any kind.

9. Limitation of Liability

We are not liable for any indirect, incidental, or consequential damages.

10. Governing Law

These Terms are governed by the laws of California, United States.

11. Language Learning Content

• Learning materials are for educational purposes only
• Accuracy of translations is not guaranteed
• User progress depends on individual effort

12. User Support

We provide support through:
• In-app help center
• Email support
• Community forums

13. Third-Party Services

We may integrate with third-party services subject to their own terms.

14. Feedback

Your feedback helps us improve. By providing feedback, you grant us the right to use it.
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
