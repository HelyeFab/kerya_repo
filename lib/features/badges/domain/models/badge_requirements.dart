import 'package:freezed_annotation/freezed_annotation.dart';
import 'badge_level.dart';

part 'badge_requirements.freezed.dart';
part 'badge_requirements.g.dart';

@freezed
class BadgeRequirements with _$BadgeRequirements {
  const factory BadgeRequirements({
    required BadgeLevel level,
    required int requiredBooksRead,
    required int requiredFavoriteBooks,
    required int requiredReadingStreak,
  }) = _BadgeRequirements;

  factory BadgeRequirements.fromJson(Map<String, dynamic> json) =>
      _$BadgeRequirementsFromJson(json);

  static BadgeRequirements getRequirementsForLevel(BadgeLevel level) {
    switch (level) {
      case BadgeLevel.beginner:
        return const BadgeRequirements(
          level: BadgeLevel.beginner,
          requiredBooksRead: 20,
          requiredFavoriteBooks: 10,
          requiredReadingStreak: 15,
        );
      case BadgeLevel.intermediate:
        return const BadgeRequirements(
          level: BadgeLevel.intermediate,
          requiredBooksRead: 40,
          requiredFavoriteBooks: 18,
          requiredReadingStreak: 25,
        );
      case BadgeLevel.advanced:
        return const BadgeRequirements(
          level: BadgeLevel.advanced,
          requiredBooksRead: 50,
          requiredFavoriteBooks: 20,
          requiredReadingStreak: 30,
        );
      case BadgeLevel.master:
        return const BadgeRequirements(
          level: BadgeLevel.master,
          requiredBooksRead: 75,
          requiredFavoriteBooks: 25,
          requiredReadingStreak: 40,
        );
    }
  }

  const BadgeRequirements._();

  bool isSatisfiedBy({
    required int booksRead,
    required int favoriteBooks,
    required int readingStreak,
  }) {
    return booksRead >= requiredBooksRead &&
        favoriteBooks >= requiredFavoriteBooks &&
        readingStreak >= requiredReadingStreak;
  }
}
