import 'package:flutter/material.dart';
import '../../data/repositories/saved_words_repository.dart';
import '../../domain/models/saved_word.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedWordsPage extends StatelessWidget {
  final SavedWordsRepository _repository = SavedWordsRepository();

  SavedWordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
      body: StreamBuilder<List<SavedWord>>(
        stream: _repository.getSavedWords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final words = snapshot.data ?? [];
          if (words.isEmpty) {
            return const Center(
              child: Text('No saved words yet'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: words.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final word = words[index];
              return Dismissible(
                key: Key(word.id),
                background: Container(
                  color: Theme.of(context).colorScheme.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _repository.removeWord(word.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${word.word} removed'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          _repository.saveWord(word);
                        },
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              word.word,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Text(
                              timeago.format(word.savedAt ?? DateTime.now()),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          word.definition,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (word.examples.isNotEmpty ?? false) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Example: "${word.examples.first}"',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
