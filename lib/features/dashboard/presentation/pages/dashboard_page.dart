import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/circular_stats_card.dart';
import '../widgets/study_progress_card.dart';
import 'saved_words_page.dart';
import 'study_session_page.dart';
import '../../../../features/dictionary/data/repositories/saved_words_repository.dart';
import '../../../../core/widgets/language_selector.dart';
import '../../../../features/books/domain/models/book_language.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with AutomaticKeepAliveClientMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  bool get wantKeepAlive => true;

  void _startStudySession(BuildContext context, BookLanguage? language) async {
    final savedWordsRepo = context.read<SavedWordsRepository>();
    print('Selected language: ${language?.code}');
    final words = await savedWordsRepo.getSavedWordsList(
      language: language?.code?.toLowerCase(),
    );
    print('Found ${words.length} words for language ${language?.code}');
    
    if (!context.mounted) return;
    
    if (words.isNotEmpty) {
      print('Attempting to navigate to StudySessionPage');
      try {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudySessionPage(
              words: words,
            ),
          ),
        );
        print('Navigation completed');
      } catch (e) {
        print('Navigation error: $e');
        print(e.toString());
      }
    } else {
      print('Showing no words snackbar');
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            language == null
                ? 'No words to study yet! Save some words first.'
                : 'No ${language.displayName} words to study yet!',
          ),
        ),
      );
    }
  }

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
                              const SizedBox(height: 32),

                              // Study Progress Section
                              Column(
                                children: [
                                  StudyProgressCard(
                                    onTap: () async {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) => AlertDialog(
                                          title: const Text('Study Words'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Select language to study:'),
                                              const SizedBox(height: 16),
                                              LanguageSelector(
                                                currentLanguage: null,
                                                onLanguageChanged: (language) {
                                                  Navigator.pop(dialogContext);
                                                  _startStudySession(context, language);
                                                },
                                                showAllOption: true,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
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
