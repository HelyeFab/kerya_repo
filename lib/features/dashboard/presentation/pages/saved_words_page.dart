import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../../core/services/firestore_service.dart';

class SavedWordsPage extends StatefulWidget {
  const SavedWordsPage({Key? key}) : super(key: key);

  @override
  _SavedWordsPageState createState() => _SavedWordsPageState();
}

class _SavedWordsPageState extends State<SavedWordsPage> {
  final FirestoreService firestoreService = FirestoreService();
  
  // List of pastel colors to cycle through
  final List<Color> pastelColors = [
    const Color(0xFFFFE5E5), // Pastel Pink
    const Color(0xFFE5FFE5), // Pastel Green
    const Color(0xFFE5E5FF), // Pastel Blue
    const Color(0xFFFFE5FF), // Pastel Purple
    const Color(0xFFFFFFE5), // Pastel Yellow
    const Color(0xFFE5FFFF), // Pastel Cyan
  ];

  Future<void> _deleteWord(String wordId, String word) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Word?'),
          content: Text('Are you sure you want to delete "$word" from your saved words?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      try {
        await firestoreService.deleteSavedWord(wordId);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting word: $e')),
          );
        }
      }
    }
  }

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
              padding: const EdgeInsets.all(16),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final wordData = words[index];
                final examples = wordData['examples'];
                final examplesText = (examples == null || examples.isEmpty)
                    ? 'Not available'
                    : examples.toString();
                
                // Cycle through pastel colors
                final color = pastelColors[index % pastelColors.length];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            wordData['word'],
                            style: const TextStyle(
                              fontFamily: 'Noto Sans',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Definition: ${wordData['definition']}',
                                style: const TextStyle(fontFamily: 'Noto Sans'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Phonetic: ${wordData['phonetic'] ?? 'Not available'}',
                                style: const TextStyle(fontFamily: 'Noto Sans'),
                              ),
                              const SizedBox(height: 8),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wordData['word'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Noto Sans',
                                    ),
                                  ),
                                  if (wordData['phonetic'] != null) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      wordData['phonetic'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                        fontFamily: 'Noto Sans',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _deleteWord(wordData['id'], wordData['word']),
                              icon: const HugeIcon(
                                icon: HugeIcons.strokeRoundedDeletePutBack,
                                color: Colors.black,
                                size: 24.0,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
