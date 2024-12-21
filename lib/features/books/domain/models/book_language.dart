enum BookLanguage {
  english('en', 'English'),
  french('fr', 'Français'),
  spanish('es', 'Español'),
  italian('it', 'Italiano'),
  german('de', 'Deutsch'),
  japanese('ja', '日本語');

  final String code;
  final String displayName;

  const BookLanguage(this.code, this.displayName);

  String get flagAsset {
    switch (this) {
      case BookLanguage.english:
        return 'assets/flags/united-kingdom.png';
      case BookLanguage.french:
        return 'assets/flags/france.png';
      case BookLanguage.spanish:
        return 'assets/flags/spain.png';
      case BookLanguage.italian:
        return 'assets/flags/italy.png';
      case BookLanguage.german:
        return 'assets/flags/germany.png';
      case BookLanguage.japanese:
        return 'assets/flags/japan.png';
    }
  }

  static BookLanguage fromCode(String code) {
    return BookLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => BookLanguage.english,
    );
  }
}
