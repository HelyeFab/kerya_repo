import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/circular_stats_card.dart';
import 'saved_words_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load stats when page is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<DashboardBloc>().loadDashboardStats();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardBloc>().loadDashboardStats();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Your Reading Stats',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your reading progress',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Stats Content
                  BlocConsumer<DashboardBloc, DashboardState>(
                    listener: (context, state) {
                      state.maybeWhen(
                        error: (message) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(message),
                              backgroundColor: Theme.of(context).colorScheme.error,
                              action: SnackBarAction(
                                label: 'Retry',
                                textColor: Colors.white,
                                onPressed: () {
                                  context.read<DashboardBloc>().loadDashboardStats();
                                },
                              ),
                            ),
                          );
                        },
                        orElse: () {},
                      );
                    },
                    builder: (context, state) {
                      return state.when(
                        initial: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        loading: () => const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        loaded: (booksRead, favoriteBooks, readingStreak, savedWords) {
                          return Column(
                            children: [
                              // First Row: Books Read and Favorite Books
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: CircularStatsCard(
                                      title: 'Books Read',
                                      value: booksRead,
                                      maxValue: 50,
                                      icon: Icons.book,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Expanded(
                                    child: CircularStatsCard(
                                      title: 'Favorite Books',
                                      value: favoriteBooks,
                                      maxValue: 20,
                                      icon: Icons.favorite,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // Second Row: Reading Streak and Saved Words
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Reading Streak Circle
                                  Expanded(
                                    child: CircularStatsCard(
                                      title: 'Reading Streak',
                                      value: readingStreak,
                                      maxValue: 30,
                                      icon: Icons.local_fire_department,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  // Compact Saved Words Card
                                  Expanded(
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const SavedWordsPage(),
                                            ),
                                          ).then((_) {
                                            // Reload stats when returning from SavedWordsPage
                                            if (mounted) {
                                              context.read<DashboardBloc>().loadDashboardStats();
                                            }
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(16),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.bookmark,
                                                    size: 20,
                                                    color: Colors.purple,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    'Saved Words',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Icon(
                                                    Icons.chevron_right,
                                                    size: 20,
                                                    color: Colors.grey[400],
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                savedWords.toString(),
                                                style: const TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        error: (message) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: $message',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<DashboardBloc>().loadDashboardStats();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
