import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../../data/repositories/user_stats_repository.dart';
import 'saved_words_page.dart'; // Import the new page

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardBloc(
        userStatsRepository: UserStatsRepository(),
      )..loadDashboardStats(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Reading Stats',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const Center(child: Text('Loading...')),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  loaded: (booksRead, favoriteBooks, readingStreak, savedWords) {
                    return DashboardContent(
                      booksRead: booksRead,
                      favoriteBooks: favoriteBooks,
                      readingStreak: readingStreak,
                      savedWords: savedWords,
                    );
                  },
                  error: (message) => Center(
                    child: Text(
                      'Error: $message',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardContent extends StatelessWidget {
  final int booksRead;
  final int favoriteBooks;
  final int readingStreak;
  final int savedWords;

  const DashboardContent({
    Key? key,
    required this.booksRead,
    required this.favoriteBooks,
    required this.readingStreak,
    required this.savedWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Books Read',
          booksRead.toString(),
          Icons.book,
          Colors.blue,
        ),
        _buildStatCard(
          'Favorite Books',
          favoriteBooks.toString(),
          Icons.favorite,
          Colors.red,
        ),
        _buildStatCard(
          'Reading Streak',
          '$readingStreak days',
          Icons.local_fire_department,
          Colors.orange,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedWordsPage()),
            );
          },
          child: _buildStatCard(
            'Saved Words',
            savedWords.toString(),
            Icons.bookmark,
            Colors.purple,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
