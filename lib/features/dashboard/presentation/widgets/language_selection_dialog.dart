import 'package:flutter/material.dart';

class LanguageSelectionDialog extends StatelessWidget {
  final List<String> languages;
  final Function(String?) onLanguageSelected;

  const LanguageSelectionDialog({
    super.key,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Language'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            // All languages option
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('All Languages'),
              onTap: () {
                Navigator.pop(context);
                onLanguageSelected(null);
              },
            ),
            const Divider(),
            // Individual language options
            ...languages.map((language) => ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(language),
                  onTap: () {
                    Navigator.pop(context);
                    onLanguageSelected(language);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
