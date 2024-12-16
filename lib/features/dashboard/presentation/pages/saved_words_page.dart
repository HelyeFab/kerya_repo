import 'package:flutter/material.dart';
import '../../../../../core/services/firestore_service.dart';

class SavedWordsPage extends StatefulWidget {
  const SavedWordsPage({Key? key}) : super(key: key);

  @override
  _SavedWordsPageState createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Saved Words',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getSavedWordsWithDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No saved words found.'));
          } else {
            final words = snapshot.data!;
            return ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, index) {
                final wordData = words[index];
                final examples = wordData['examples'];
                final examplesText = (examples == null || examples.isEmpty)
                    ? 'Not available'
                    : examples.toString();

                return ListTile(
                  title: Text(wordData['word']),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(
                          wordData['word'],
                          style: const TextStyle(fontFamily: 'Noto Sans'),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Definition: ${wordData['definition']}',
                              style: const TextStyle(fontFamily: 'Noto Sans'),
                            ),
                            Text(
                              'Phonetic: ${wordData['phonetic'] ?? 'Not available'}',
                              style: const TextStyle(fontFamily: 'Noto Sans'),
                            ),
                            Text(
                              'Examples: $examplesText',
                              style: const TextStyle(fontFamily: 'Noto Sans'),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
