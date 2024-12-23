import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Keyra/core/widgets/menu_button.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';
import 'package:Keyra/core/ui_language/service/ui_translation_service.dart';
import 'package:Keyra/features/badges/presentation/widgets/badge_display.dart';
import 'package:Keyra/features/badges/presentation/bloc/badge_bloc.dart';
import 'package:Keyra/features/badges/presentation/bloc/badge_state.dart';
import 'package:Keyra/features/badges/presentation/bloc/badge_event.dart';
import 'package:Keyra/features/navigation/presentation/widgets/app_drawer.dart';
import 'package:Keyra/core/widgets/page_header.dart';
import 'package:Keyra/core/extensions/context_extensions.dart';
import 'package:Keyra/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:Keyra/features/dashboard/presentation/pages/study_session_page.dart';
import 'package:Keyra/features/dashboard/presentation/pages/study_words_page.dart';
import 'package:Keyra/features/dashboard/presentation/widgets/circular_stats_card.dart';
import 'package:Keyra/features/dashboard/presentation/widgets/study_progress_card.dart';
import 'package:Keyra/features/dashboard/presentation/widgets/no_saved_words_dialog.dart';
import 'package:Keyra/features/dictionary/data/repositories/saved_words_repository.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  bool get wantKeepAlive => true;

  void _startStudySession(BuildContext context, BookLanguage? language) async {
    final savedWordsRepo = context.read<SavedWordsRepository>();
    final words = await savedWordsRepo.getSavedWordsList(
      language: language?.code.toLowerCase(),
    );

    if (!context.mounted) return;

    if (words.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudySessionPage(
            words: words,
          ),
        ),
      );
    } else {
      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (context) => NoSavedWordsDialog(
          showLanguageSpecific: language != null,
          languageCode: language?.code,
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
        context.read<BadgeBloc>().add(const BadgeEvent.started());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: const AppDrawer(),
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: BlocBuilder<BadgeBloc, BadgeState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) => const SizedBox.shrink(),
                  loaded: (loaded) => BadgeDisplay(
                    level: loaded.progress.currentLevel,
                  ),
                  levelingUp: (levelingUp) => BadgeDisplay(
                    level: levelingUp.progress.currentLevel,
                  ),
                );
              },
            ),
          ),
          actions: const [
            MenuButton(),
            SizedBox(width: 16),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<DashboardBloc>().loadDashboardStats();
                },
                child: BlocConsumer<DashboardBloc, DashboardState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      error: (message) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(message),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            action: SnackBarAction(
                              label: UiTranslationService.translate(
                                  context, 'ok', null, false),
                              textColor: Colors.white,
                              onPressed: () {
                                context
                                    .read<DashboardBloc>()
                                    .loadDashboardStats();
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
                      initial: () => const Center(child: SizedBox()),
                      loading: () => const Center(child: SizedBox()),
                      loaded: (booksRead, favoriteBooks, readingStreak,
                          savedWords) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  Row(
                                    children: [
                                      SizedBox(),
                                      SizedBox(width: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Stats Content
                                      Column(
                                        children: [
                                          // First Row: Books Read and Favorite Books
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                child: CircularStatsCard(
                                                  title: UiTranslationService
                                                      .translate(context,
                                                          'books read'),
                                                  value: booksRead,
                                                  maxValue: 50,
                                                  icon: Icons.book,
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              Expanded(
                                                child: CircularStatsCard(
                                                  title: UiTranslationService
                                                      .translate(context,
                                                          'favorite books'),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // Reading Streak Circle
                                              Expanded(
                                                child: CircularStatsCard(
                                                  title: UiTranslationService
                                                      .translate(context,
                                                          'reading streak'),
                                                  value: readingStreak,
                                                  maxValue: 30,
                                                  icon: Icons
                                                      .local_fire_department,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                              // Compact Saved Words Card
                                              Expanded(
                                                child: Card(
                                                  elevation: 4,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surfaceContainerLowest,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const StudyWordsPage(),
                                                        ),
                                                      )
                                                          .then((_) {
                                                        // Reload stats when returning from SavedWordsPage
                                                        if (mounted) {
                                                          context
                                                              .read<
                                                                  DashboardBloc>()
                                                              .loadDashboardStats();
                                                        }
                                                      });
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              const Icon(
                                                                Icons.bookmark,
                                                                size: 20,
                                                                color: Colors
                                                                    .purple,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Flexible(
                                                                child: Text(
                                                                  UiTranslationService
                                                                      .translate(
                                                                          context,
                                                                          'saved words'),
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  width: 4),
                                                              Icon(
                                                                Icons
                                                                    .chevron_right,
                                                                size: 20,
                                                                color: Colors
                                                                    .grey[400],
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            savedWords
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 32,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
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
                                                onLanguageSelected: (language) {
                                                  _startStudySession(
                                                      context, language);
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
                                  context
                                      .read<DashboardBloc>()
                                      .loadDashboardStats();
                                },
                                icon: const Icon(Icons.refresh),
                                label: Text(UiTranslationService.translate(
                                    context, 'ok', null, false)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
