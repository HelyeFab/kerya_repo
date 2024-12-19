import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';

class StudyProgressCard extends StatelessWidget {
  final VoidCallback onTap;

  const StudyProgressCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final savedWordsRepo = context.read<SavedWordsRepository>();

    return StreamBuilder<Map<String, int>>(
      stream: savedWordsRepo.getWordProgressCounts(),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {'new': 0, 'learning': 0, 'learned': 0};
        final total = counts.values.fold(0, (sum, count) => sum + count);

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Icon(
                        Icons.school,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Study Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress Items
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProgressItem('New', counts['new'] ?? 0, Colors.blue),
                      _buildProgressItem('Learning', counts['learning'] ?? 0, Colors.orange),
                      _buildProgressItem('Learned', counts['learned'] ?? 0, Colors.green),
                    ],
                  ),
                  if (total > 0) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: (counts['learned'] ?? 0) / total,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                  // Total words
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      '$total Total Words',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
