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
    final theme = Theme.of(context);

    return StreamBuilder<Map<String, int>>(
      stream: savedWordsRepo.getWordProgressCounts(),
      builder: (context, snapshot) {
        final counts = snapshot.data ?? {'new': 0, 'learning': 0, 'learned': 0};
        final total = counts.values.fold(0, (sum, count) => sum + count);

        return Card(
          elevation: 4,
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
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
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Study Progress',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
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
                      _buildProgressItem('New', counts['new'] ?? 0, Colors.blue, theme),
                      _buildProgressItem('Learning', counts['learning'] ?? 0, Colors.orange, theme),
                      _buildProgressItem('Learned', counts['learned'] ?? 0, Colors.green, theme),
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildProgressItem(String label, int count, Color color, ThemeData theme) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: theme.textTheme.headlineMedium?.copyWith(
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
