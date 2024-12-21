enum BadgeLevel {
  beginner('Little Bookworm', 'assets/badge/caterpillar.png'),
  intermediate('Page Turner', 'assets/badge/open-book.png'),
  advanced('Chapter Champion', 'assets/badge/medal.png'),
  master('Story Sage', 'assets/badge/wizard-hat.png');

  final String displayName;
  final String assetPath;

  const BadgeLevel(this.displayName, this.assetPath);

  static BadgeLevel fromDisplayName(String name) {
    return BadgeLevel.values.firstWhere(
      (level) => level.displayName == name,
      orElse: () => BadgeLevel.beginner,
    );
  }
}
